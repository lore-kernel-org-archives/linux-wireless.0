Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:31632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754337AbdC1JhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 05:37:10 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 2/5] NFC: pn544: Covert to use GPIO descriptor
Date: Tue, 28 Mar 2017 12:36:36 +0300
Message-Id: <20170328093639.53481-2-andriy.shevchenko@linux.intel.com> (sfid-20170328_113942_039637_FF1AF905)
In-Reply-To: <20170328093639.53481-1-andriy.shevchenko@linux.intel.com>
References: <20170328093639.53481-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we got rid of platform data, the driver may use
GPIO descriptor directly.

This change fixes a potential issue of double freeing GPIOs in ACPI
case by converting to devm_gpiod_get().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 v3: no change

 drivers/nfc/pn544/i2c.c | 126 +++++++++++++-----------------------------------
 1 file changed, 33 insertions(+), 93 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 41e518ee148e..b4001306aff8 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -21,9 +21,6 @@
 #include <linux/crc-ccitt.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
-#include <linux/of_gpio.h>
-#include <linux/of_irq.h>
 #include <linux/acpi.h>
 #include <linux/miscdevice.h>
 #include <linux/interrupt.h>
@@ -165,8 +162,9 @@ struct pn544_i2c_phy {
 	struct i2c_client *i2c_dev;
 	struct nfc_hci_dev *hdev;
 
-	unsigned int gpio_en;
-	unsigned int gpio_fw;
+	struct gpio_desc *gpiod_en;
+	struct gpio_desc *gpiod_fw;
+
 	unsigned int en_polarity;
 
 	u8 hw_variant;
@@ -208,19 +206,18 @@ static void pn544_hci_i2c_platform_init(struct pn544_i2c_phy *phy)
 	nfc_info(&phy->i2c_dev->dev, "Detecting nfc_en polarity\n");
 
 	/* Disable fw download */
-	gpio_set_value_cansleep(phy->gpio_fw, 0);
+	gpiod_set_value_cansleep(phy->gpiod_fw, 0);
 
 	for (polarity = 0; polarity < 2; polarity++) {
 		phy->en_polarity = polarity;
 		retry = 3;
 		while (retry--) {
 			/* power off */
-			gpio_set_value_cansleep(phy->gpio_en,
-						!phy->en_polarity);
+			gpiod_set_value_cansleep(phy->gpiod_en, !phy->en_polarity);
 			usleep_range(10000, 15000);
 
 			/* power on */
-			gpio_set_value_cansleep(phy->gpio_en, phy->en_polarity);
+			gpiod_set_value_cansleep(phy->gpiod_en, phy->en_polarity);
 			usleep_range(10000, 15000);
 
 			/* send reset */
@@ -239,14 +236,13 @@ static void pn544_hci_i2c_platform_init(struct pn544_i2c_phy *phy)
 		"Could not detect nfc_en polarity, fallback to active high\n");
 
 out:
-	gpio_set_value_cansleep(phy->gpio_en, !phy->en_polarity);
+	gpiod_set_value_cansleep(phy->gpiod_en, !phy->en_polarity);
 }
 
 static void pn544_hci_i2c_enable_mode(struct pn544_i2c_phy *phy, int run_mode)
 {
-	gpio_set_value_cansleep(phy->gpio_fw,
-				run_mode == PN544_FW_MODE ? 1 : 0);
-	gpio_set_value_cansleep(phy->gpio_en, phy->en_polarity);
+	gpiod_set_value_cansleep(phy->gpiod_fw, run_mode == PN544_FW_MODE ? 1 : 0);
+	gpiod_set_value_cansleep(phy->gpiod_en, phy->en_polarity);
 	usleep_range(10000, 15000);
 
 	phy->run_mode = run_mode;
@@ -269,14 +265,14 @@ static void pn544_hci_i2c_disable(void *phy_id)
 {
 	struct pn544_i2c_phy *phy = phy_id;
 
-	gpio_set_value_cansleep(phy->gpio_fw, 0);
-	gpio_set_value_cansleep(phy->gpio_en, !phy->en_polarity);
+	gpiod_set_value_cansleep(phy->gpiod_fw, 0);
+	gpiod_set_value_cansleep(phy->gpiod_en, !phy->en_polarity);
 	usleep_range(10000, 15000);
 
-	gpio_set_value_cansleep(phy->gpio_en, phy->en_polarity);
+	gpiod_set_value_cansleep(phy->gpiod_en, phy->en_polarity);
 	usleep_range(10000, 15000);
 
-	gpio_set_value_cansleep(phy->gpio_en, !phy->en_polarity);
+	gpiod_set_value_cansleep(phy->gpiod_en, !phy->en_polarity);
 	usleep_range(10000, 15000);
 
 	phy->powered = 0;
@@ -877,96 +873,47 @@ static void pn544_hci_i2c_fw_work(struct work_struct *work)
 static int pn544_hci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
-	struct gpio_desc *gpiod_en, *gpiod_fw;
 	struct device *dev = &client->dev;
 
 	/* Get EN GPIO from ACPI */
-	gpiod_en = devm_gpiod_get_index(dev, PN544_GPIO_NAME_EN, 1,
-					GPIOD_OUT_LOW);
-	if (IS_ERR(gpiod_en)) {
+	phy->gpiod_en = devm_gpiod_get_index(dev, PN544_GPIO_NAME_EN, 1,
+					     GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_en)) {
 		nfc_err(dev, "Unable to get EN GPIO\n");
-		return -ENODEV;
+		return PTR_ERR(phy->gpiod_en);
 	}
 
-	phy->gpio_en = desc_to_gpio(gpiod_en);
-
 	/* Get FW GPIO from ACPI */
-	gpiod_fw = devm_gpiod_get_index(dev, PN544_GPIO_NAME_FW, 2,
-					GPIOD_OUT_LOW);
-	if (IS_ERR(gpiod_fw)) {
+	phy->gpiod_fw = devm_gpiod_get_index(dev, PN544_GPIO_NAME_FW, 2,
+					     GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_fw)) {
 		nfc_err(dev, "Unable to get FW GPIO\n");
-		return -ENODEV;
+		return PTR_ERR(phy->gpiod_fw);
 	}
 
-	phy->gpio_fw = desc_to_gpio(gpiod_fw);
-
 	return 0;
 }
 
 static int pn544_hci_i2c_of_request_resources(struct i2c_client *client)
 {
 	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
-	struct device_node *pp;
-	int ret;
-
-	pp = client->dev.of_node;
-	if (!pp) {
-		ret = -ENODEV;
-		goto err_dt;
-	}
-
-	/* Obtention of EN GPIO from device tree */
-	ret = of_get_named_gpio(pp, "enable-gpios", 0);
-	if (ret < 0) {
-		if (ret != -EPROBE_DEFER)
-			nfc_err(&client->dev,
-				"Failed to get EN gpio, error: %d\n", ret);
-		goto err_dt;
-	}
-	phy->gpio_en = ret;
-
-	/* Configuration of EN GPIO */
-	ret = gpio_request(phy->gpio_en, PN544_GPIO_NAME_EN);
-	if (ret) {
-		nfc_err(&client->dev, "Fail EN pin\n");
-		goto err_dt;
-	}
-	ret = gpio_direction_output(phy->gpio_en, 0);
-	if (ret) {
-		nfc_err(&client->dev, "Fail EN pin direction\n");
-		goto err_gpio_en;
-	}
+	struct device *dev = &client->dev;
 
-	/* Obtention of FW GPIO from device tree */
-	ret = of_get_named_gpio(pp, "firmware-gpios", 0);
-	if (ret < 0) {
-		if (ret != -EPROBE_DEFER)
-			nfc_err(&client->dev,
-				"Failed to get FW gpio, error: %d\n", ret);
-		goto err_gpio_en;
+	/* Obtaining EN GPIO from device tree */
+	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_en)) {
+		nfc_err(dev, "Failed to get EN gpio\n");
+		return PTR_ERR(phy->gpiod_en);
 	}
-	phy->gpio_fw = ret;
 
-	/* Configuration of FW GPIO */
-	ret = gpio_request(phy->gpio_fw, PN544_GPIO_NAME_FW);
-	if (ret) {
-		nfc_err(&client->dev, "Fail FW pin\n");
-		goto err_gpio_en;
-	}
-	ret = gpio_direction_output(phy->gpio_fw, 0);
-	if (ret) {
-		nfc_err(&client->dev, "Fail FW pin direction\n");
-		goto err_gpio_fw;
+	/* Obtaining FW GPIO from device tree */
+	phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
+	if (IS_ERR(phy->gpiod_fw)) {
+		nfc_err(dev, "Failed to get FW gpio\n");
+		return PTR_ERR(phy->gpiod_fw);
 	}
 
 	return 0;
-
-err_gpio_fw:
-	gpio_free(phy->gpio_fw);
-err_gpio_en:
-	gpio_free(phy->gpio_en);
-err_dt:
-	return ret;
 }
 
 static int pn544_hci_i2c_probe(struct i2c_client *client,
@@ -1021,7 +968,7 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 				 PN544_HCI_I2C_DRIVER_NAME, phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-		goto err_rti;
+		return r;
 	}
 
 	r = pn544_hci_probe(phy, &i2c_phy_ops, LLC_SHDLC_NAME,
@@ -1036,10 +983,6 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 err_hci:
 	free_irq(client->irq, phy);
 
-err_rti:
-	gpio_free(phy->gpio_en);
-	gpio_free(phy->gpio_fw);
-
 	return r;
 }
 
@@ -1060,9 +1003,6 @@ static int pn544_hci_i2c_remove(struct i2c_client *client)
 
 	free_irq(client->irq, phy);
 
-	gpio_free(phy->gpio_en);
-	gpio_free(phy->gpio_fw);
-
 	return 0;
 }
 
-- 
2.11.0
