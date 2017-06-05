Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:43808 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751285AbdFEUVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:21:15 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 09/12] NFC: st-nci: Covert to use GPIO descriptor
Date: Mon,  5 Jun 2017 23:20:06 +0300
Message-Id: <20170605202009.78561-10-andriy.shevchenko@linux.intel.com> (sfid-20170605_222118_121098_9A0AD6A4)
In-Reply-To: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
References: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we got rid of platform data, the driver may use GPIO descriptor
directly.

Looking deeply to the use of the GPIO pin it looks like it should be
a GPIO based reset control rather than custom GPIO handling. But this
is out of scope of the change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st-nci/i2c.c | 38 +++++++++++---------------------------
 drivers/nfc/st-nci/spi.c | 40 ++++++++++++----------------------------
 2 files changed, 23 insertions(+), 55 deletions(-)

diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index bdfbd543e671..cc63c2f6823f 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -19,13 +19,12 @@
 
 #include <linux/module.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
-#include <linux/of_gpio.h>
 #include <linux/acpi.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/nfc.h>
+#include <linux/of.h>
 
 #include "st-nci.h"
 
@@ -49,7 +48,7 @@ struct st_nci_i2c_phy {
 
 	bool irq_active;
 
-	unsigned int gpio_reset;
+	struct gpio_desc *gpiod_reset;
 
 	struct st_nci_se_status se_status;
 };
@@ -58,9 +57,9 @@ static int st_nci_i2c_enable(void *phy_id)
 {
 	struct st_nci_i2c_phy *phy = phy_id;
 
-	gpio_set_value(phy->gpio_reset, 0);
+	gpiod_set_value(phy->gpiod_reset, 0);
 	usleep_range(10000, 15000);
-	gpio_set_value(phy->gpio_reset, 1);
+	gpiod_set_value(phy->gpiod_reset, 1);
 	usleep_range(80000, 85000);
 
 	if (phy->ndlc->powered == 0 && phy->irq_active == 0) {
@@ -209,20 +208,16 @@ static struct nfc_phy_ops i2c_phy_ops = {
 static int st_nci_i2c_acpi_request_resources(struct i2c_client *client)
 {
 	struct st_nci_i2c_phy *phy = i2c_get_clientdata(client);
-	struct gpio_desc *gpiod_reset;
 	struct device *dev = &client->dev;
 	u8 tmp;
 
 	/* Get RESET GPIO from ACPI */
-	gpiod_reset = devm_gpiod_get_index(dev, ST_NCI_GPIO_NAME_RESET, 1,
-					   GPIOD_OUT_HIGH);
-	if (IS_ERR(gpiod_reset)) {
+	phy->gpiod_reset = devm_gpiod_get_index(dev, ST_NCI_GPIO_NAME_RESET, 1, GPIOD_OUT_HIGH);
+	if (IS_ERR(phy->gpiod_reset)) {
 		nfc_err(dev, "Unable to get RESET GPIO\n");
 		return -ENODEV;
 	}
 
-	phy->gpio_reset = desc_to_gpio(gpiod_reset);
-
 	phy->se_status.is_ese_present = false;
 	phy->se_status.is_uicc_present = false;
 
@@ -242,30 +237,19 @@ static int st_nci_i2c_acpi_request_resources(struct i2c_client *client)
 static int st_nci_i2c_of_request_resources(struct i2c_client *client)
 {
 	struct st_nci_i2c_phy *phy = i2c_get_clientdata(client);
+	struct device *dev = &client->dev;
 	struct device_node *pp;
-	int gpio;
-	int r;
 
 	pp = client->dev.of_node;
 	if (!pp)
 		return -ENODEV;
 
 	/* Get GPIO from device tree */
-	gpio = of_get_named_gpio(pp, "reset-gpios", 0);
-	if (gpio < 0) {
-		nfc_err(&client->dev,
-			"Failed to retrieve reset-gpios from device tree\n");
-		return gpio;
-	}
-
-	/* GPIO request and configuration */
-	r = devm_gpio_request_one(&client->dev, gpio,
-				GPIOF_OUT_INIT_HIGH, ST_NCI_GPIO_NAME_RESET);
-	if (r) {
-		nfc_err(&client->dev, "Failed to request reset pin\n");
-		return r;
+	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(phy->gpiod_reset)) {
+		nfc_err(dev, "Unable to get RESET GPIO\n");
+		return PTR_ERR(phy->gpiod_reset);
 	}
-	phy->gpio_reset = gpio;
 
 	phy->se_status.is_ese_present =
 				of_property_read_bool(pp, "ese-present");
diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 4585e205778b..acf339d83360 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -19,13 +19,12 @@
 
 #include <linux/module.h>
 #include <linux/spi/spi.h>
-#include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
-#include <linux/of_gpio.h>
 #include <linux/acpi.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/nfc.h>
+#include <linux/of.h>
 #include <net/nfc/nci.h>
 
 #include "st-nci.h"
@@ -50,7 +49,7 @@ struct st_nci_spi_phy {
 
 	bool irq_active;
 
-	unsigned int gpio_reset;
+	struct gpio_desc *gpiod_reset;
 
 	struct st_nci_se_status se_status;
 };
@@ -59,9 +58,9 @@ static int st_nci_spi_enable(void *phy_id)
 {
 	struct st_nci_spi_phy *phy = phy_id;
 
-	gpio_set_value(phy->gpio_reset, 0);
+	gpiod_set_value(phy->gpiod_reset, 0);
 	usleep_range(10000, 15000);
-	gpio_set_value(phy->gpio_reset, 1);
+	gpiod_set_value(phy->gpiod_reset, 1);
 	usleep_range(80000, 85000);
 
 	if (phy->ndlc->powered == 0 && phy->irq_active == 0) {
@@ -224,20 +223,16 @@ static struct nfc_phy_ops spi_phy_ops = {
 static int st_nci_spi_acpi_request_resources(struct spi_device *spi_dev)
 {
 	struct st_nci_spi_phy *phy = spi_get_drvdata(spi_dev);
-	struct gpio_desc *gpiod_reset;
 	struct device *dev = &spi_dev->dev;
 	u8 tmp;
 
 	/* Get RESET GPIO from ACPI */
-	gpiod_reset = devm_gpiod_get_index(dev, ST_NCI_GPIO_NAME_RESET, 1,
-					   GPIOD_OUT_HIGH);
-	if (IS_ERR(gpiod_reset)) {
+	phy->gpiod_reset = devm_gpiod_get_index(dev, ST_NCI_GPIO_NAME_RESET, 1, GPIOD_OUT_HIGH);
+	if (IS_ERR(phy->gpiod_reset)) {
 		nfc_err(dev, "Unable to get RESET GPIO\n");
-		return -ENODEV;
+		return PTR_ERR(phy->gpiod_reset);
 	}
 
-	phy->gpio_reset = desc_to_gpio(gpiod_reset);
-
 	phy->se_status.is_ese_present = false;
 	phy->se_status.is_uicc_present = false;
 
@@ -257,30 +252,19 @@ static int st_nci_spi_acpi_request_resources(struct spi_device *spi_dev)
 static int st_nci_spi_of_request_resources(struct spi_device *dev)
 {
 	struct st_nci_spi_phy *phy = spi_get_drvdata(dev);
+	struct device *dev = &dev->dev;
 	struct device_node *pp;
-	int gpio;
-	int r;
 
 	pp = dev->dev.of_node;
 	if (!pp)
 		return -ENODEV;
 
 	/* Get GPIO from device tree */
-	gpio = of_get_named_gpio(pp, "reset-gpios", 0);
-	if (gpio < 0) {
-		nfc_err(&dev->dev,
-			"Failed to retrieve reset-gpios from device tree\n");
-		return gpio;
-	}
-
-	/* GPIO request and configuration */
-	r = devm_gpio_request_one(&dev->dev, gpio,
-				GPIOF_OUT_INIT_HIGH, ST_NCI_GPIO_NAME_RESET);
-	if (r) {
-		nfc_err(&dev->dev, "Failed to request reset pin\n");
-		return r;
+	phy->gpiod_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(phy->gpiod_reset)) {
+		nfc_err(dev, "Unable to get RESET GPIO\n");
+		return PTR_ERR(phy->gpiod_reset);
 	}
-	phy->gpio_reset = gpio;
 
 	phy->se_status.is_ese_present =
 				of_property_read_bool(pp, "ese-present");
-- 
2.11.0
