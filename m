Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:2298 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbdCVT61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 15:58:27 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 4/5] NFC: pn544: Add GPIO ACPI mapping table
Date: Wed, 22 Mar 2017 21:57:51 +0200
Message-Id: <20170322195752.33291-4-andriy.shevchenko@linux.intel.com> (sfid-20170322_205855_483623_B2267CD2)
In-Reply-To: <20170322195752.33291-1-andriy.shevchenko@linux.intel.com>
References: <20170322195752.33291-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to make GPIO ACPI library stricter prepare users of
gpiod_get_index() to correctly behave when there no mapping is
provided by firmware.

Here we add explicit mapping between _CRS GpioIo() resources and
their names used in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/pn544/i2c.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 5e780e7a28e5..6226d220f1d0 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -870,22 +870,34 @@ static void pn544_hci_i2c_fw_work(struct work_struct *work)
 	}
 }
 
+static const struct acpi_gpio_params enable_gpios = { 1, 0, false };
+static const struct acpi_gpio_params firmware_gpios = { 2, 0, false };
+
+static const struct acpi_gpio_mapping acpi_pn544_gpios[] = {
+	{ "enable-gpios", &enable_gpios, 1 },
+	{ "firmware-gpios", &firmware_gpios, 1 },
+	{ },
+};
+
 static int pn544_hci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
+	int ret;
+
+	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_pn544_gpios);
+	if (ret)
+		return ret;
 
 	/* Get EN GPIO from ACPI */
-	phy->gpiod_en = devm_gpiod_get_index(dev, PN544_GPIO_NAME_EN, 1,
-					     GPIOD_OUT_LOW);
+	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_en)) {
 		nfc_err(dev, "Unable to get EN GPIO\n");
 		return PTR_ERR(phy->gpiod_en);
 	}
 
 	/* Get FW GPIO from ACPI */
-	phy->gpiod_fw = devm_gpiod_get_index(dev, PN544_GPIO_NAME_FW, 2,
-					     GPIOD_OUT_LOW);
+	phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_fw)) {
 		nfc_err(dev, "Unable to get FW GPIO\n");
 		return PTR_ERR(phy->gpiod_fw);
@@ -997,6 +1009,7 @@ static int pn544_hci_i2c_remove(struct i2c_client *client)
 	if (phy->powered)
 		pn544_hci_i2c_disable(phy);
 
+	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&client->dev));
 	return 0;
 }
 
-- 
2.11.0
