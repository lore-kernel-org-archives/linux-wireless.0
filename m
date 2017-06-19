Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:35244 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753866AbdFSKJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:09:10 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 06/13] NFC: fdp: Add GPIO ACPI mapping table
Date: Mon, 19 Jun 2017 13:08:51 +0300
Message-Id: <20170619100858.2655-7-andriy.shevchenko@linux.intel.com> (sfid-20170619_120918_836852_334119D8)
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
 drivers/nfc/fdp/i2c.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index c955f1f5139d..c4da50e07bbc 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -27,7 +27,6 @@
 
 #define FDP_I2C_DRIVER_NAME	"fdp_nci_i2c"
 
-#define FDP_DP_POWER_GPIO_NAME	"power"
 #define FDP_DP_CLOCK_TYPE_NAME	"clock-type"
 #define FDP_DP_CLOCK_FREQ_NAME	"clock-freq"
 #define FDP_DP_FW_VSC_CFG_NAME	"fw-vsc-cfg"
@@ -281,6 +280,13 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
 }
 
+static const struct acpi_gpio_params power_gpios = { 0, 0, false };
+
+static const struct acpi_gpio_mapping acpi_fdp_gpios[] = {
+	{ "power-gpios", &power_gpios, 1 },
+	{},
+};
+
 static int fdp_nci_i2c_probe(struct i2c_client *client)
 {
 	struct fdp_i2c_phy *phy;
@@ -321,10 +327,12 @@ static int fdp_nci_i2c_probe(struct i2c_client *client)
 		return r;
 	}
 
-	/* Requesting the power gpio */
-	phy->power_gpio = devm_gpiod_get(dev, FDP_DP_POWER_GPIO_NAME,
-					 GPIOD_OUT_LOW);
+	r = devm_acpi_dev_add_driver_gpios(dev, acpi_fdp_gpios);
+	if (r)
+		dev_dbg(dev, "Unable to add GPIO mapping table\n");
 
+	/* Requesting the power gpio */
+	phy->power_gpio = devm_gpiod_get(dev, "power", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->power_gpio)) {
 		nfc_err(dev, "Power GPIO request failed\n");
 		return PTR_ERR(phy->power_gpio);
-- 
2.11.0
