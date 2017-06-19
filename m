Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:25391 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753965AbdFSKJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:09:13 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 07/13] NFC: st-nci: Get rid of platform data
Date: Mon, 19 Jun 2017 13:08:52 +0300
Message-Id: <20170619100858.2655-8-andriy.shevchenko@linux.intel.com> (sfid-20170619_120919_896046_ACB10544)
In-Reply-To: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
References: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Legacy platform data must go away. We are on the safe side here since
there are no users of it in the kernel.

If anyone by any odd reason needs it the GPIO lookup tables and
built-in device properties at your service.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 MAINTAINERS                          |  1 -
 drivers/nfc/st-nci/i2c.c             | 43 ++----------------------------------
 drivers/nfc/st-nci/spi.c             | 43 ++----------------------------------
 include/linux/platform_data/st-nci.h | 31 --------------------------
 4 files changed, 4 insertions(+), 114 deletions(-)
 delete mode 100644 include/linux/platform_data/st-nci.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e3d41ceaf20d..6f2d96313230 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9177,7 +9177,6 @@ F:	include/linux/platform_data/nfcmrvl.h
 F:	include/linux/platform_data/nxp-nci.h
 F:	include/linux/platform_data/pn544.h
 F:	include/linux/platform_data/st21nfca.h
-F:	include/linux/platform_data/st-nci.h
 F:	Documentation/devicetree/bindings/net/nfc/
 
 NFS, SUNRPC, AND LOCKD CLIENTS
diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 9dfae0efa922..6d3d8e43fa50 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -27,7 +27,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/nfc.h>
-#include <linux/platform_data/st-nci.h>
 
 #include "st-nci.h"
 
@@ -40,6 +39,7 @@
 #define ST_NCI_I2C_MIN_SIZE 4   /* PCB(1) + NCI Packet header(3) */
 #define ST_NCI_I2C_MAX_SIZE 250 /* req 4.2.1 */
 
+#define ST_NCI_DRIVER_NAME "st_nci"
 #define ST_NCI_I2C_DRIVER_NAME "st_nci_i2c"
 
 #define ST_NCI_GPIO_NAME_RESET "reset"
@@ -281,41 +281,10 @@ static int st_nci_i2c_of_request_resources(struct i2c_client *client)
 	return 0;
 }
 
-static int st_nci_i2c_request_resources(struct i2c_client *client)
-{
-	struct st_nci_nfc_platform_data *pdata;
-	struct st_nci_i2c_phy *phy = i2c_get_clientdata(client);
-	int r;
-
-	pdata = client->dev.platform_data;
-	if (pdata == NULL) {
-		nfc_err(&client->dev, "No platform data\n");
-		return -EINVAL;
-	}
-
-	/* store for later use */
-	phy->gpio_reset = pdata->gpio_reset;
-	phy->irq_polarity = pdata->irq_polarity;
-
-	r = devm_gpio_request_one(&client->dev,
-			phy->gpio_reset, GPIOF_OUT_INIT_HIGH,
-			ST_NCI_GPIO_NAME_RESET);
-	if (r) {
-		pr_err("%s : reset gpio_request failed\n", __FILE__);
-		return r;
-	}
-
-	phy->se_status.is_ese_present = pdata->is_ese_present;
-	phy->se_status.is_uicc_present = pdata->is_uicc_present;
-
-	return 0;
-}
-
 static int st_nci_i2c_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
 	struct st_nci_i2c_phy *phy;
-	struct st_nci_nfc_platform_data *pdata;
 	int r;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
@@ -335,20 +304,12 @@ static int st_nci_i2c_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, phy);
 
-	pdata = client->dev.platform_data;
-	if (!pdata && client->dev.of_node) {
+	if (client->dev.of_node) {
 		r = st_nci_i2c_of_request_resources(client);
 		if (r) {
 			nfc_err(&client->dev, "No platform data\n");
 			return r;
 		}
-	} else if (pdata) {
-		r = st_nci_i2c_request_resources(client);
-		if (r) {
-			nfc_err(&client->dev,
-				"Cannot get platform resources\n");
-			return r;
-		}
 	} else if (ACPI_HANDLE(&client->dev)) {
 		r = st_nci_i2c_acpi_request_resources(client);
 		if (r) {
diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 89e341eba3eb..ee8ea708d5b7 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -28,7 +28,6 @@
 #include <linux/delay.h>
 #include <linux/nfc.h>
 #include <net/nfc/nci.h>
-#include <linux/platform_data/st-nci.h>
 
 #include "st-nci.h"
 
@@ -41,6 +40,7 @@
 #define ST_NCI_SPI_MIN_SIZE 4   /* PCB(1) + NCI Packet header(3) */
 #define ST_NCI_SPI_MAX_SIZE 250 /* req 4.2.1 */
 
+#define ST_NCI_DRIVER_NAME "st_nci"
 #define ST_NCI_SPI_DRIVER_NAME "st_nci_spi"
 
 #define ST_NCI_GPIO_NAME_RESET "reset"
@@ -296,40 +296,9 @@ static int st_nci_spi_of_request_resources(struct spi_device *dev)
 	return 0;
 }
 
-static int st_nci_spi_request_resources(struct spi_device *dev)
-{
-	struct st_nci_nfc_platform_data *pdata;
-	struct st_nci_spi_phy *phy = spi_get_drvdata(dev);
-	int r;
-
-	pdata = dev->dev.platform_data;
-	if (pdata == NULL) {
-		nfc_err(&dev->dev, "No platform data\n");
-		return -EINVAL;
-	}
-
-	/* store for later use */
-	phy->gpio_reset = pdata->gpio_reset;
-	phy->irq_polarity = pdata->irq_polarity;
-
-	r = devm_gpio_request_one(&dev->dev,
-			phy->gpio_reset, GPIOF_OUT_INIT_HIGH,
-			ST_NCI_GPIO_NAME_RESET);
-	if (r) {
-		pr_err("%s : reset gpio_request failed\n", __FILE__);
-		return r;
-	}
-
-	phy->se_status.is_ese_present = pdata->is_ese_present;
-	phy->se_status.is_uicc_present = pdata->is_uicc_present;
-
-	return 0;
-}
-
 static int st_nci_spi_probe(struct spi_device *dev)
 {
 	struct st_nci_spi_phy *phy;
-	struct st_nci_nfc_platform_data *pdata;
 	int r;
 
 	dev_dbg(&dev->dev, "%s\n", __func__);
@@ -351,20 +320,12 @@ static int st_nci_spi_probe(struct spi_device *dev)
 
 	spi_set_drvdata(dev, phy);
 
-	pdata = dev->dev.platform_data;
-	if (!pdata && dev->dev.of_node) {
+	if (dev->dev.of_node) {
 		r = st_nci_spi_of_request_resources(dev);
 		if (r) {
 			nfc_err(&dev->dev, "No platform data\n");
 			return r;
 		}
-	} else if (pdata) {
-		r = st_nci_spi_request_resources(dev);
-		if (r) {
-			nfc_err(&dev->dev,
-				"Cannot get platform resources\n");
-			return r;
-		}
 	} else if (ACPI_HANDLE(&dev->dev)) {
 		r = st_nci_spi_acpi_request_resources(dev);
 		if (r) {
diff --git a/include/linux/platform_data/st-nci.h b/include/linux/platform_data/st-nci.h
deleted file mode 100644
index f6494b347c06..000000000000
--- a/include/linux/platform_data/st-nci.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * Driver include for ST NCI NFC chip family.
- *
- * Copyright (C) 2014-2015  STMicroelectronics SAS. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef _ST_NCI_H_
-#define _ST_NCI_H_
-
-#define ST_NCI_DRIVER_NAME "st_nci"
-
-struct st_nci_nfc_platform_data {
-	unsigned int gpio_reset;
-	unsigned int irq_polarity;
-	bool is_ese_present;
-	bool is_uicc_present;
-};
-
-#endif /* _ST_NCI_H_ */
-- 
2.11.0
