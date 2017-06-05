Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56770 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751285AbdFEUUq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:20:46 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 12/12] NFC: st-nci: Get rid of code duplication in ->probe()
Date: Mon,  5 Jun 2017 23:20:09 +0300
Message-Id: <20170605202009.78561-13-andriy.shevchenko@linux.intel.com> (sfid-20170605_222050_435564_6511B0D7)
In-Reply-To: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
References: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since OF and ACPI case almost the same get rid of code duplication
by moving gpiod_get() calls directly to ->probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st-nci/i2c.c | 61 +++++++---------------------------------------
 drivers/nfc/st-nci/spi.c | 63 ++++++++----------------------------------------
 2 files changed, 19 insertions(+), 105 deletions(-)

diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index edda253b07fe..515f08d037fb 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -210,41 +210,6 @@ static const struct acpi_gpio_mapping acpi_st_nci_gpios[] = {
 	{},
 };
 
-static int st_nci_i2c_acpi_request_resources(struct i2c_client *client)
-{
-	struct st_nci_i2c_phy *phy = i2c_get_clientdata(client);
-	struct device *dev = &client->dev;
-	int r;
-
-	r = devm_acpi_dev_add_driver_gpios(dev, acpi_st_nci_gpios);
-	if (r)
-		return r;
-
-	/* Get RESET GPIO from ACPI */
-	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
-	if (IS_ERR(phy->gpiod_reset)) {
-		nfc_err(dev, "Unable to get RESET GPIO\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static int st_nci_i2c_of_request_resources(struct i2c_client *client)
-{
-	struct st_nci_i2c_phy *phy = i2c_get_clientdata(client);
-	struct device *dev = &client->dev;
-
-	/* Get GPIO from device tree */
-	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
-	if (IS_ERR(phy->gpiod_reset)) {
-		nfc_err(dev, "Unable to get RESET GPIO\n");
-		return PTR_ERR(phy->gpiod_reset);
-	}
-
-	return 0;
-}
-
 static int st_nci_i2c_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
@@ -260,8 +225,7 @@ static int st_nci_i2c_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	phy = devm_kzalloc(&client->dev, sizeof(struct st_nci_i2c_phy),
-			   GFP_KERNEL);
+	phy = devm_kzalloc(dev, sizeof(struct st_nci_i2c_phy), GFP_KERNEL);
 	if (!phy)
 		return -ENOMEM;
 
@@ -269,21 +233,14 @@ static int st_nci_i2c_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, phy);
 
-	if (client->dev.of_node) {
-		r = st_nci_i2c_of_request_resources(client);
-		if (r) {
-			nfc_err(&client->dev, "No platform data\n");
-			return r;
-		}
-	} else if (ACPI_HANDLE(&client->dev)) {
-		r = st_nci_i2c_acpi_request_resources(client);
-		if (r) {
-			nfc_err(&client->dev, "Cannot get ACPI data\n");
-			return r;
-		}
-	} else {
-		nfc_err(&client->dev,
-			"st_nci platform resources not available\n");
+	r = devm_acpi_dev_add_driver_gpios(dev, acpi_st_nci_gpios);
+	if (r)
+		dev_dbg(dev, "Unable to add GPIO mapping table\n");
+
+	/* Get RESET GPIO */
+	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(phy->gpiod_reset)) {
+		nfc_err(dev, "Unable to get RESET GPIO\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 80afdb9ea248..5be9fd326488 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -225,41 +225,6 @@ static const struct acpi_gpio_mapping acpi_st_nci_gpios[] = {
 	{},
 };
 
-static int st_nci_spi_acpi_request_resources(struct spi_device *spi_dev)
-{
-	struct st_nci_spi_phy *phy = spi_get_drvdata(spi_dev);
-	struct device *dev = &spi_dev->dev;
-	int r;
-
-	r = devm_acpi_dev_add_driver_gpios(dev, acpi_st_nci_gpios);
-	if (r)
-		return r;
-
-	/* Get RESET GPIO from ACPI */
-	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
-	if (IS_ERR(phy->gpiod_reset)) {
-		nfc_err(dev, "Unable to get RESET GPIO\n");
-		return PTR_ERR(phy->gpiod_reset);
-	}
-
-	return 0;
-}
-
-static int st_nci_spi_of_request_resources(struct spi_device *dev)
-{
-	struct st_nci_spi_phy *phy = spi_get_drvdata(dev);
-	struct device *dev = &dev->dev;
-
-	/* Get GPIO from device tree */
-	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
-	if (IS_ERR(phy->gpiod_reset)) {
-		nfc_err(dev, "Unable to get RESET GPIO\n");
-		return PTR_ERR(phy->gpiod_reset);
-	}
-
-	return 0;
-}
-
 static int st_nci_spi_probe(struct spi_device *dev)
 {
 	struct st_nci_spi_phy *phy;
@@ -275,8 +240,7 @@ static int st_nci_spi_probe(struct spi_device *dev)
 		return -ENODEV;
 	}
 
-	phy = devm_kzalloc(&dev->dev, sizeof(struct st_nci_spi_phy),
-			   GFP_KERNEL);
+	phy = devm_kzalloc(&dev->dev, sizeof(struct st_nci_spi_phy), GFP_KERNEL);
 	if (!phy)
 		return -ENOMEM;
 
@@ -284,22 +248,15 @@ static int st_nci_spi_probe(struct spi_device *dev)
 
 	spi_set_drvdata(dev, phy);
 
-	if (dev->dev.of_node) {
-		r = st_nci_spi_of_request_resources(dev);
-		if (r) {
-			nfc_err(&dev->dev, "No platform data\n");
-			return r;
-		}
-	} else if (ACPI_HANDLE(&dev->dev)) {
-		r = st_nci_spi_acpi_request_resources(dev);
-		if (r) {
-			nfc_err(&dev->dev, "Cannot get ACPI data\n");
-			return r;
-		}
-	} else {
-		nfc_err(&dev->dev,
-			"st_nci platform resources not available\n");
-		return -ENODEV;
+	r = devm_acpi_dev_add_driver_gpios(&dev->dev, acpi_st_nci_gpios);
+	if (r)
+		dev_dbg(&dev->dev, "Unable to add GPIO mapping table\n");
+
+	/* Get RESET GPIO */
+	phy->gpiod_reset = devm_gpiod_get(&dev->dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(phy->gpiod_reset)) {
+		nfc_err(&dev->dev, "Unable to get RESET GPIO\n");
+		return PTR_ERR(phy->gpiod_reset);
 	}
 
 	phy->se_status.is_ese_present =
-- 
2.11.0
