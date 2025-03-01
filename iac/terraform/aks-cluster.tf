#https://learn.hashicorp.com/tutorials/terraform/aks
# az ad sp create-for-rbac --name "terraform_diplomapp" --skip-assignment
# az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
# az aks browse --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)




resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.prefix.id}-rg"
  location = "West Europe"

  tags = {
    environment = "diplomapp"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

resource "azurerm_container_registry" "default" {
  name                = "acr1"
  resource_group_name = local.rgname
  location            = local.rgloc
  sku                 = "Standard"
  admin_enabled       = true

  tags = {
    environment = "diplomapp"
  }
}



  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "diplomapp"
  }
}
