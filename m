Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33567 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdFEUUS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:20:18 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 02/12] NFC: st21nfca: Add GPIO ACPI mapping table
Date: Mon,  5 Jun 2017 23:19:59 +0300
Message-Id: <20170605202009.78561-3-andriy.shevchenko@linux.intel.com> (sfid-20170605_222026_983418_46358B36)
In-Reply-To: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
References: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to make GPIO ACPI library stricter prepare users of
gpiod_get_index() to correctly behave when there no mapping is
provided by firmware.

Here we add explicit mapping between _CRS GpioIo() resources and
their names used in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st21nfca/i2c.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 02a920ca07c8..9b889e017a9d 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -501,14 +501,25 @@ static struct nfc_phy_ops i2c_phy_ops = {
 	.disable = st21nfca_hci_i2c_disable,
 };
 
+static const struct acpi_gpio_params enable_gpios = { 1, 0, false };
+
+static const struct acpi_gpio_mapping acpi_st21nfca_gpios[] = {
+	{ "enable-gpios", &enable_gpios, 1 },
+	{},
+};
+
 static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
+	int ret;
+
+	ret = devm_acpi_dev_add_driver_gpios(dev, acpi_st21nfca_gpios);
+	if (ret)
+		return ret;
 
 	/* Get EN GPIO from ACPI */
-	phy->gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN, 1,
-					      GPIOD_OUT_LOW);
+	phy->gpiod_ena = devm_gpiod_get(dev, ST21NFCA_GPIO_NAME_EN, GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_ena)) {
 		nfc_err(dev, "Unable to get ENABLE GPIO\n");
 		return PTR_ERR(phy->gpiod_ena);
@@ -523,8 +534,7 @@ static int st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
 	struct device *dev = &client->dev;
 
 	/* Get GPIO from device tree */
-	phy->gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN, 0,
-					      GPIOD_OUT_HIGH);
+	phy->gpiod_ena = devm_gpiod_get(dev, ST21NFCA_GPIO_NAME_EN, GPIOD_OUT_HIGH);
 	if (IS_ERR(phy->gpiod_ena)) {
 		nfc_err(dev, "Failed to request enable pin\n");
 		return PTR_ERR(phy->gpiod_ena);
-- 
2.11.0
