terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

terraform {
  backend "gcs" {
    bucket  = "seven-tf-state-bucket"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = "seven-exp"
  region  = "us-central1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# A simple Google Cloud Storage bucket resource
resource "google_storage_bucket" "test_bucket" {
  name     = "yorumew-${random_id.suffix.hex}"
  project  = "seven-exp"
  location = "US-CENTRAL1"

  # Allows the bucket to be destroyed even if it contains objects
  force_destroy = true

  # Enables uniform access control at the bucket level
  uniform_bucket_level_access = true

  labels = {
    purpose = "quick-test"
  }
}

resource "google_pubsub_topic" "test_topic" {
  name = "yorumew-topic-${random_id.suffix.hex}"
}

# Outputs the name of the created bucket after apply
output "bucket_name" {
  description = "The name of the GCS bucket."
  value       = google_storage_bucket.test_bucket.name
}
