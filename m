Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:29796 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753905AbdFSKJu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:09:50 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 10/13] NFC: st-nci: Use unified device properties API meaningfully
Date: Mon, 19 Jun 2017 13:08:55 +0300
Message-Id: <20170619100858.2655-11-andriy.shevchenko@linux.intel.com> (sfid-20170619_121009_624576_3239246F)
In-Reply-To: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
References: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use unified device properties API in meaningful way.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st-nci/i2c.c | 30 ++++++------------------------
 drivers/nfc/st-nci/spi.c | 29 +++++------------------------
 2 files changed, 11 insertions(+), 48 deletions(-)

diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 93a621e27d4e..2ee381586f14 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -209,7 +209,6 @@ static int st_nci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct st_nci_i2c_phy *phy = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
-	u8 tmp;
 
 	/* Get RESET GPIO from ACPI */
 	phy->gpiod_reset = devm_gpiod_get_index(dev, ST_NCI_GPIO_NAME_RESET,
@@ -219,19 +218,6 @@ static int st_nci_i2c_acpi_request_resources(struct i2c_client *client)
 		return -ENODEV;
 	}
 
-	phy->se_status.is_ese_present = false;
-	phy->se_status.is_uicc_present = false;
-
-	if (device_property_present(dev, "ese-present")) {
-		device_property_read_u8(dev, "ese-present", &tmp);
-		phy->se_status.is_ese_present = tmp;
-	}
-
-	if (device_property_present(dev, "uicc-present")) {
-		device_property_read_u8(dev, "uicc-present", &tmp);
-		phy->se_status.is_uicc_present = tmp;
-	}
-
 	return 0;
 }
 
@@ -239,11 +225,6 @@ static int st_nci_i2c_of_request_resources(struct i2c_client *client)
 {
 	struct st_nci_i2c_phy *phy = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
-	struct device_node *pp;
-
-	pp = client->dev.of_node;
-	if (!pp)
-		return -ENODEV;
 
 	/* Get GPIO from device tree */
 	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
@@ -252,17 +233,13 @@ static int st_nci_i2c_of_request_resources(struct i2c_client *client)
 		return PTR_ERR(phy->gpiod_reset);
 	}
 
-	phy->se_status.is_ese_present =
-				of_property_read_bool(pp, "ese-present");
-	phy->se_status.is_uicc_present =
-				of_property_read_bool(pp, "uicc-present");
-
 	return 0;
 }
 
 static int st_nci_i2c_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
+	struct device *dev = &client->dev;
 	struct st_nci_i2c_phy *phy;
 	int r;
 
@@ -301,6 +278,11 @@ static int st_nci_i2c_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
+	phy->se_status.is_ese_present =
+				device_property_read_bool(dev, "ese-present");
+	phy->se_status.is_uicc_present =
+				device_property_read_bool(dev, "uicc-present");
+
 	r = ndlc_probe(phy, &i2c_phy_ops, &client->dev,
 			ST_NCI_FRAME_HEADROOM, ST_NCI_FRAME_TAILROOM,
 			&phy->ndlc, &phy->se_status);
diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 2834f6984608..383bf69163ef 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -224,7 +224,6 @@ static int st_nci_spi_acpi_request_resources(struct spi_device *spi_dev)
 {
 	struct st_nci_spi_phy *phy = spi_get_drvdata(spi_dev);
 	struct device *dev = &spi_dev->dev;
-	u8 tmp;
 
 	/* Get RESET GPIO from ACPI */
 	phy->gpiod_reset = devm_gpiod_get_index(dev, ST_NCI_GPIO_NAME_RESET,
@@ -234,19 +233,6 @@ static int st_nci_spi_acpi_request_resources(struct spi_device *spi_dev)
 		return PTR_ERR(phy->gpiod_reset);
 	}
 
-	phy->se_status.is_ese_present = false;
-	phy->se_status.is_uicc_present = false;
-
-	if (device_property_present(dev, "ese-present")) {
-		device_property_read_u8(dev, "ese-present", &tmp);
-		tmp = phy->se_status.is_ese_present;
-	}
-
-	if (device_property_present(dev, "uicc-present")) {
-		device_property_read_u8(dev, "uicc-present", &tmp);
-		tmp = phy->se_status.is_uicc_present;
-	}
-
 	return 0;
 }
 
@@ -254,11 +240,6 @@ static int st_nci_spi_of_request_resources(struct spi_device *spi)
 {
 	struct st_nci_spi_phy *phy = spi_get_drvdata(spi);
 	struct device *dev = &spi->dev;
-	struct device_node *pp;
-
-	pp = spi->dev.of_node;
-	if (!pp)
-		return -ENODEV;
 
 	/* Get GPIO from device tree */
 	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
@@ -267,11 +248,6 @@ static int st_nci_spi_of_request_resources(struct spi_device *spi)
 		return PTR_ERR(phy->gpiod_reset);
 	}
 
-	phy->se_status.is_ese_present =
-				of_property_read_bool(pp, "ese-present");
-	phy->se_status.is_uicc_present =
-				of_property_read_bool(pp, "uicc-present");
-
 	return 0;
 }
 
@@ -317,6 +293,11 @@ static int st_nci_spi_probe(struct spi_device *dev)
 		return -ENODEV;
 	}
 
+	phy->se_status.is_ese_present =
+			device_property_read_bool(&dev->dev, "ese-present");
+	phy->se_status.is_uicc_present =
+			device_property_read_bool(&dev->dev, "uicc-present");
+
 	r = ndlc_probe(phy, &spi_phy_ops, &dev->dev,
 			ST_NCI_FRAME_HEADROOM, ST_NCI_FRAME_TAILROOM,
 			&phy->ndlc, &phy->se_status);
-- 
2.11.0
