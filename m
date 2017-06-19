Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:9657 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753975AbdFSKJ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:09:28 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 08/13] NFC: st-nci: Get rid of "interesting" use of interrupt polarity
Date: Mon, 19 Jun 2017 13:08:53 +0300
Message-Id: <20170619100858.2655-9-andriy.shevchenko@linux.intel.com> (sfid-20170619_120936_894814_7BD67B15)
In-Reply-To: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
References: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I2C and SPI frameworks followed by IRQ framework do set
interrupt polarity correctly if it's properly specified in firmware
(ACPI or DT).

Get rid of the redundant trick when requesting interrupt.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st-nci/i2c.c | 8 +-------
 drivers/nfc/st-nci/spi.c | 8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 6d3d8e43fa50..bdfbd543e671 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -21,7 +21,6 @@
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
-#include <linux/of_irq.h>
 #include <linux/of_gpio.h>
 #include <linux/acpi.h>
 #include <linux/interrupt.h>
@@ -51,7 +50,6 @@ struct st_nci_i2c_phy {
 	bool irq_active;
 
 	unsigned int gpio_reset;
-	unsigned int irq_polarity;
 
 	struct st_nci_se_status se_status;
 };
@@ -225,8 +223,6 @@ static int st_nci_i2c_acpi_request_resources(struct i2c_client *client)
 
 	phy->gpio_reset = desc_to_gpio(gpiod_reset);
 
-	phy->irq_polarity = irq_get_trigger_type(client->irq);
-
 	phy->se_status.is_ese_present = false;
 	phy->se_status.is_uicc_present = false;
 
@@ -271,8 +267,6 @@ static int st_nci_i2c_of_request_resources(struct i2c_client *client)
 	}
 	phy->gpio_reset = gpio;
 
-	phy->irq_polarity = irq_get_trigger_type(client->irq);
-
 	phy->se_status.is_ese_present =
 				of_property_read_bool(pp, "ese-present");
 	phy->se_status.is_uicc_present =
@@ -333,7 +327,7 @@ static int st_nci_i2c_probe(struct i2c_client *client,
 	phy->irq_active = true;
 	r = devm_request_threaded_irq(&client->dev, client->irq, NULL,
 				st_nci_irq_thread_fn,
-				phy->irq_polarity | IRQF_ONESHOT,
+				IRQF_ONESHOT,
 				ST_NCI_DRIVER_NAME, phy);
 	if (r < 0)
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index ee8ea708d5b7..4585e205778b 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -21,7 +21,6 @@
 #include <linux/spi/spi.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
-#include <linux/of_irq.h>
 #include <linux/of_gpio.h>
 #include <linux/acpi.h>
 #include <linux/interrupt.h>
@@ -52,7 +51,6 @@ struct st_nci_spi_phy {
 	bool irq_active;
 
 	unsigned int gpio_reset;
-	unsigned int irq_polarity;
 
 	struct st_nci_se_status se_status;
 };
@@ -240,8 +238,6 @@ static int st_nci_spi_acpi_request_resources(struct spi_device *spi_dev)
 
 	phy->gpio_reset = desc_to_gpio(gpiod_reset);
 
-	phy->irq_polarity = irq_get_trigger_type(spi_dev->irq);
-
 	phy->se_status.is_ese_present = false;
 	phy->se_status.is_uicc_present = false;
 
@@ -286,8 +282,6 @@ static int st_nci_spi_of_request_resources(struct spi_device *dev)
 	}
 	phy->gpio_reset = gpio;
 
-	phy->irq_polarity = irq_get_trigger_type(dev->irq);
-
 	phy->se_status.is_ese_present =
 				of_property_read_bool(pp, "ese-present");
 	phy->se_status.is_uicc_present =
@@ -349,7 +343,7 @@ static int st_nci_spi_probe(struct spi_device *dev)
 	phy->irq_active = true;
 	r = devm_request_threaded_irq(&dev->dev, dev->irq, NULL,
 				st_nci_irq_thread_fn,
-				phy->irq_polarity | IRQF_ONESHOT,
+				IRQF_ONESHOT,
 				ST_NCI_SPI_DRIVER_NAME, phy);
 	if (r < 0)
 		nfc_err(&dev->dev, "Unable to register IRQ handler\n");
-- 
2.11.0
