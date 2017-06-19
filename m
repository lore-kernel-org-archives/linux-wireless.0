Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30902 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753962AbdFSKJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:09:16 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 11/13] NFC: st-nci: Add GPIO ACPI mapping table
Date: Mon, 19 Jun 2017 13:08:56 +0300
Message-Id: <20170619100858.2655-12-andriy.shevchenko@linux.intel.com> (sfid-20170619_120920_957623_A2D2133C)
In-Reply-To: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
References: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to make GPIO ACPI library stricter prepare users of
gpiod_get_index() to correctly behave when there no mapping is
provided by firmware.

Here we add explicit mapping between _CRS GpioIo() resources and
their names used in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st-nci/i2c.c | 17 +++++++++++++----
 drivers/nfc/st-nci/spi.c | 17 +++++++++++++----
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 2ee381586f14..edda253b07fe 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -40,8 +40,6 @@
 #define ST_NCI_DRIVER_NAME "st_nci"
 #define ST_NCI_I2C_DRIVER_NAME "st_nci_i2c"
 
-#define ST_NCI_GPIO_NAME_RESET "reset"
-
 struct st_nci_i2c_phy {
 	struct i2c_client *i2c_dev;
 	struct llt_ndlc *ndlc;
@@ -205,14 +203,25 @@ static struct nfc_phy_ops i2c_phy_ops = {
 	.disable = st_nci_i2c_disable,
 };
 
+static const struct acpi_gpio_params reset_gpios = { 1, 0, false };
+
+static const struct acpi_gpio_mapping acpi_st_nci_gpios[] = {
+	{ "reset-gpios", &reset_gpios, 1 },
+	{},
+};
+
 static int st_nci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct st_nci_i2c_phy *phy = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
+	int r;
+
+	r = devm_acpi_dev_add_driver_gpios(dev, acpi_st_nci_gpios);
+	if (r)
+		return r;
 
 	/* Get RESET GPIO from ACPI */
-	phy->gpiod_reset = devm_gpiod_get_index(dev, ST_NCI_GPIO_NAME_RESET,
-						1, GPIOD_OUT_HIGH);
+	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(phy->gpiod_reset)) {
 		nfc_err(dev, "Unable to get RESET GPIO\n");
 		return -ENODEV;
diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 383bf69163ef..99ecf92edc8c 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -41,8 +41,6 @@
 #define ST_NCI_DRIVER_NAME "st_nci"
 #define ST_NCI_SPI_DRIVER_NAME "st_nci_spi"
 
-#define ST_NCI_GPIO_NAME_RESET "reset"
-
 struct st_nci_spi_phy {
 	struct spi_device *spi_dev;
 	struct llt_ndlc *ndlc;
@@ -220,14 +218,25 @@ static struct nfc_phy_ops spi_phy_ops = {
 	.disable = st_nci_spi_disable,
 };
 
+static const struct acpi_gpio_params reset_gpios = { 1, 0, false };
+
+static const struct acpi_gpio_mapping acpi_st_nci_gpios[] = {
+	{ "reset-gpios", &reset_gpios, 1 },
+	{},
+};
+
 static int st_nci_spi_acpi_request_resources(struct spi_device *spi_dev)
 {
 	struct st_nci_spi_phy *phy = spi_get_drvdata(spi_dev);
 	struct device *dev = &spi_dev->dev;
+	int r;
+
+	r = devm_acpi_dev_add_driver_gpios(dev, acpi_st_nci_gpios);
+	if (r)
+		return r;
 
 	/* Get RESET GPIO from ACPI */
-	phy->gpiod_reset = devm_gpiod_get_index(dev, ST_NCI_GPIO_NAME_RESET,
-						1, GPIOD_OUT_HIGH);
+	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(phy->gpiod_reset)) {
 		nfc_err(dev, "Unable to get RESET GPIO\n");
 		return PTR_ERR(phy->gpiod_reset);
-- 
2.11.0
