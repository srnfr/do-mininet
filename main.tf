variable "region_name" {
  type        = string
}
variable "domain_name" {
  type        = string
}
variable "droplet_size" {
  type        = string
}
variable "droplet_image" {
  type        = string
}
variable "prefix" {
  type        = string
}

variable "tag_name" {
  type        = string
}

variable "ssh_keys" {
  default = []
}

resource "digitalocean_tag" "tag" {
  name = var.tag_name
##  lifecycle {
##    prevent_destroy = true
##  }
}

resource "digitalocean_droplet" "mininet" {
  image  = var.droplet_image
  name   = "${var.prefix}-mininet"
  region = var.region_name
  size   = var.droplet_size
  tags               = [digitalocean_tag.tag.id]
  monitoring         = "true"
 ## private_networking = "true"
  ssh_keys           = var.ssh_keys
  user_data = "${file("cloud-init.yaml")}"
}

resource "digitalocean_record" "mininet" {
  domain = var.domain_name
  type   = "A"
  name   = "mininet"
  value  = digitalocean_droplet.mininet.ipv4_address
  ttl    = 300
}
