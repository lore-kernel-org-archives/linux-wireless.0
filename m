Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63575 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754440AbdC1JiP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 05:38:15 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 5/5] NFC: pn544: Get rid of code duplication in ->probe()
Date: Tue, 28 Mar 2017 12:36:39 +0300
Message-Id: <20170328093639.53481-5-andriy.shevchenko@linux.intel.com> (sfid-20170328_113943_762750_B340CCA0)
In-Reply-To: <20170328093639.53481-1-andriy.shevchenko@linux.intel.com>
References: <20170328093639.53481-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since OF and ACPI case almost the same get rid of code duplication
by moving gpiod_get() calls directly to ->probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 v3: use dev_dbg() instead of nfc_dbg()

 drivers/nfc/pn544/i2c.c | 84 ++++++++++---------------------------------------
 1 file changed, 17 insertions(+), 67 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 6226d220f1d0..7a2910f12aab 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -879,58 +879,10 @@ static const struct acpi_gpio_mapping acpi_pn544_gpios[] = {
 	{ },
 };
 
-static int pn544_hci_i2c_acpi_request_resources(struct i2c_client *client)
-{
-	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
-	struct device *dev = &client->dev;
-	int ret;
-
-	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_pn544_gpios);
-	if (ret)
-		return ret;
-
-	/* Get EN GPIO from ACPI */
-	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
-	if (IS_ERR(phy->gpiod_en)) {
-		nfc_err(dev, "Unable to get EN GPIO\n");
-		return PTR_ERR(phy->gpiod_en);
-	}
-
-	/* Get FW GPIO from ACPI */
-	phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
-	if (IS_ERR(phy->gpiod_fw)) {
-		nfc_err(dev, "Unable to get FW GPIO\n");
-		return PTR_ERR(phy->gpiod_fw);
-	}
-
-	return 0;
-}
-
-static int pn544_hci_i2c_of_request_resources(struct i2c_client *client)
-{
-	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
-	struct device *dev = &client->dev;
-
-	/* Obtaining EN GPIO from device tree */
-	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
-	if (IS_ERR(phy->gpiod_en)) {
-		nfc_err(dev, "Failed to get EN gpio\n");
-		return PTR_ERR(phy->gpiod_en);
-	}
-
-	/* Obtaining FW GPIO from device tree */
-	phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
-	if (IS_ERR(phy->gpiod_fw)) {
-		nfc_err(dev, "Failed to get FW gpio\n");
-		return PTR_ERR(phy->gpiod_fw);
-	}
-
-	return 0;
-}
-
 static int pn544_hci_i2c_probe(struct i2c_client *client,
 			       const struct i2c_device_id *id)
 {
+	struct device *dev = &client->dev;
 	struct pn544_i2c_phy *phy;
 	int r = 0;
 
@@ -953,24 +905,22 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
-	/* No platform data, using device tree. */
-	if (client->dev.of_node) {
-		r = pn544_hci_i2c_of_request_resources(client);
-		if (r) {
-			nfc_err(&client->dev, "No DT data\n");
-			return r;
-		}
-	/* Using ACPI */
-	} else if (ACPI_HANDLE(&client->dev)) {
-		r = pn544_hci_i2c_acpi_request_resources(client);
-		if (r) {
-			nfc_err(&client->dev,
-				"Cannot get ACPI data\n");
-			return r;
-		}
-	} else {
-		nfc_err(&client->dev, "No platform data\n");
-		return -EINVAL;
+	r = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_pn544_gpios);
+	if (r)
+		dev_dbg(dev, "Unable to add GPIO mapping table\n");
+
+	/* Get EN GPIO */
+	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_en)) {
+		nfc_err(dev, "Unable to get EN GPIO\n");
+		return PTR_ERR(phy->gpiod_en);
+	}
+
+	/* Get FW GPIO */
+	phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_fw)) {
+		nfc_err(dev, "Unable to get FW GPIO\n");
+		return PTR_ERR(phy->gpiod_fw);
 	}
 
 	pn544_hci_i2c_platform_init(phy);
-- 
2.11.0
