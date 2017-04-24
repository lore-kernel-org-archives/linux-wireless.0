Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22990 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968979AbdDXSlc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 14:41:32 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/2] NFC: st21nfca: Get rid of code duplication in ->probe()
Date: Mon, 24 Apr 2017 21:41:28 +0300
Message-Id: <20170424184128.48061-2-andriy.shevchenko@linux.intel.com> (sfid-20170424_204253_408725_AB0B9A3D)
In-Reply-To: <20170424184128.48061-1-andriy.shevchenko@linux.intel.com>
References: <20170424184128.48061-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since OF and ACPI case almost the same get rid of code duplication
by moving gpiod_get() calls directly to ->probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st21nfca/i2c.c | 62 ++++++++--------------------------------------
 1 file changed, 10 insertions(+), 52 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index a04f24334b54..525f72f49b73 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -61,8 +61,6 @@
 #define ST21NFCA_HCI_DRIVER_NAME "st21nfca_hci"
 #define ST21NFCA_HCI_I2C_DRIVER_NAME "st21nfca_hci_i2c"
 
-#define ST21NFCA_GPIO_NAME_EN "enable"
-
 struct st21nfca_i2c_phy {
 	struct i2c_client *i2c_dev;
 	struct nfc_hci_dev *hdev;
@@ -508,44 +506,10 @@ static const struct acpi_gpio_mapping acpi_st21nfca_gpios[] = {
 	{},
 };
 
-static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
-{
-	struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
-	struct device *dev = &client->dev;
-	int ret;
-
-	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_st21nfca_gpios);
-	if (ret)
-		return ret;
-
-	/* Get EN GPIO from ACPI */
-	phy->gpiod_ena = devm_gpiod_get(dev, ST21NFCA_GPIO_NAME_EN, GPIOD_OUT_LOW);
-	if (IS_ERR(phy->gpiod_ena)) {
-		nfc_err(dev, "Unable to get ENABLE GPIO\n");
-		return PTR_ERR(phy->gpiod_ena);
-	}
-
-	return 0;
-}
-
-static int st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
-{
-	struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
-	struct device *dev = &client->dev;
-
-	/* Get GPIO from device tree */
-	phy->gpiod_ena = devm_gpiod_get(dev, ST21NFCA_GPIO_NAME_EN, GPIOD_OUT_HIGH);
-	if (IS_ERR(phy->gpiod_ena)) {
-		nfc_err(dev, "Failed to request enable pin\n");
-		return PTR_ERR(phy->gpiod_ena);
-	}
-
-	return 0;
-}
-
 static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
+	struct device *dev = &client->dev;
 	struct st21nfca_i2c_phy *phy;
 	int r;
 
@@ -572,21 +536,15 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 	mutex_init(&phy->phy_lock);
 	i2c_set_clientdata(client, phy);
 
-	if (client->dev.of_node) {
-		r = st21nfca_hci_i2c_of_request_resources(client);
-		if (r) {
-			nfc_err(&client->dev, "No platform data\n");
-			return r;
-		}
-	} else if (ACPI_HANDLE(&client->dev)) {
-		r = st21nfca_hci_i2c_acpi_request_resources(client);
-		if (r) {
-			nfc_err(&client->dev, "Cannot get ACPI data\n");
-			return r;
-		}
-	} else {
-		nfc_err(&client->dev, "st21nfca platform resources not available\n");
-		return -ENODEV;
+	r = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_st21nfca_gpios);
+	if (r)
+		dev_dbg(dev, "Unable to add GPIO mapping table\n");
+
+	/* Get EN GPIO from resource provider */
+	phy->gpiod_ena = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_ena)) {
+		nfc_err(dev, "Unable to get ENABLE GPIO\n");
+		return PTR_ERR(phy->gpiod_ena);
 	}
 
 	phy->se_status.is_ese_present =
-- 
2.11.0
