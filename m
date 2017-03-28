Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:31632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752770AbdC1JhE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 05:37:04 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 1/5] NFC: pn544: Get rid of platform data
Date: Tue, 28 Mar 2017 12:36:35 +0300
Message-Id: <20170328093639.53481-1-andriy.shevchenko@linux.intel.com> (sfid-20170328_113941_501958_FCB4D07C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Legacy platform data must go away. We are on the safe side here since
there are no users of it in the kernel.

If anyone by any odd reason needs it the GPIO lookup tables and
built-in device properties at your service.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 v3: no change

 drivers/nfc/pn544/i2c.c             | 43 ++++++-------------------------------
 include/linux/platform_data/pn544.h | 43 -------------------------------------
 2 files changed, 6 insertions(+), 80 deletions(-)
 delete mode 100644 include/linux/platform_data/pn544.h

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index f837c39a8017..41e518ee148e 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -31,7 +31,7 @@
 #include <linux/nfc.h>
 #include <linux/firmware.h>
 #include <linux/gpio/consumer.h>
-#include <linux/platform_data/pn544.h>
+
 #include <asm/unaligned.h>
 
 #include <net/nfc/hci.h>
@@ -973,7 +973,6 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 			       const struct i2c_device_id *id)
 {
 	struct pn544_i2c_phy *phy;
-	struct pn544_nfc_platform_data *pdata;
 	int r = 0;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
@@ -995,32 +994,13 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
-	pdata = client->dev.platform_data;
-
 	/* No platform data, using device tree. */
-	if (!pdata && client->dev.of_node) {
+	if (client->dev.of_node) {
 		r = pn544_hci_i2c_of_request_resources(client);
 		if (r) {
 			nfc_err(&client->dev, "No DT data\n");
 			return r;
 		}
-	/* Using platform data. */
-	} else if (pdata) {
-
-		if (pdata->request_resources == NULL) {
-			nfc_err(&client->dev, "request_resources() missing\n");
-			return -EINVAL;
-		}
-
-		r = pdata->request_resources(client);
-		if (r) {
-			nfc_err(&client->dev,
-				"Cannot get platform resources\n");
-			return r;
-		}
-
-		phy->gpio_en = pdata->get_gpio(NFC_GPIO_ENABLE);
-		phy->gpio_fw = pdata->get_gpio(NFC_GPIO_FW_RESET);
 	/* Using ACPI */
 	} else if (ACPI_HANDLE(&client->dev)) {
 		r = pn544_hci_i2c_acpi_request_resources(client);
@@ -1057,12 +1037,8 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 	free_irq(client->irq, phy);
 
 err_rti:
-	if (!pdata) {
-		gpio_free(phy->gpio_en);
-		gpio_free(phy->gpio_fw);
-	} else if (pdata->free_resources) {
-		pdata->free_resources();
-	}
+	gpio_free(phy->gpio_en);
+	gpio_free(phy->gpio_fw);
 
 	return r;
 }
@@ -1070,7 +1046,6 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 static int pn544_hci_i2c_remove(struct i2c_client *client)
 {
 	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
-	struct pn544_nfc_platform_data *pdata = client->dev.platform_data;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
@@ -1085,14 +1060,8 @@ static int pn544_hci_i2c_remove(struct i2c_client *client)
 
 	free_irq(client->irq, phy);
 
-	/* No platform data, GPIOs have been requested by this driver */
-	if (!pdata) {
-		gpio_free(phy->gpio_en);
-		gpio_free(phy->gpio_fw);
-	/* Using platform data */
-	} else if (pdata->free_resources) {
-		pdata->free_resources();
-	}
+	gpio_free(phy->gpio_en);
+	gpio_free(phy->gpio_fw);
 
 	return 0;
 }
diff --git a/include/linux/platform_data/pn544.h b/include/linux/platform_data/pn544.h
deleted file mode 100644
index 5ce1ab983f44..000000000000
--- a/include/linux/platform_data/pn544.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * Driver include for the PN544 NFC chip.
- *
- * Copyright (C) Nokia Corporation
- *
- * Author: Jari Vanhala <ext-jari.vanhala@nokia.com>
- * Contact: Matti Aaltoenn <matti.j.aaltonen@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef _PN544_H_
-#define _PN544_H_
-
-#include <linux/i2c.h>
-
-enum {
-	NFC_GPIO_ENABLE,
-	NFC_GPIO_FW_RESET,
-	NFC_GPIO_IRQ
-};
-
-/* board config */
-struct pn544_nfc_platform_data {
-	int (*request_resources) (struct i2c_client *client);
-	void (*free_resources) (void);
-	void (*enable) (int fw);
-	int (*test) (void);
-	void (*disable) (void);
-	int (*get_gpio)(int type);
-};
-
-#endif /* _PN544_H_ */
-- 
2.11.0
