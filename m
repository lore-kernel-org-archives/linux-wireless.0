Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:39905 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754670AbdCGKaZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:30:25 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/5] NFC: st21nfca: Get rid of platform data
Date: Tue,  7 Mar 2017 12:25:43 +0200
Message-Id: <20170307102546.32224-2-andriy.shevchenko@linux.intel.com> (sfid-20170307_113118_195179_8781B4C8)
In-Reply-To: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
References: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Legacy platform data must go away. We are on the safe side here since
there are no users of it in the kernel.

If anyone by any odd reason needs it the GPIO lookup tables and
built-in device properties at your service.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nfc/st21nfca/i2c.c             | 46 +++-------------------------------
 include/linux/platform_data/st21nfca.h | 33 ------------------------
 2 files changed, 3 insertions(+), 76 deletions(-)
 delete mode 100644 include/linux/platform_data/st21nfca.h

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 737384d287aa..1eb558f00290 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -20,7 +20,6 @@
 #include <linux/crc-ccitt.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/of_irq.h>
 #include <linux/of_gpio.h>
@@ -30,7 +29,7 @@
 #include <linux/delay.h>
 #include <linux/nfc.h>
 #include <linux/firmware.h>
-#include <linux/platform_data/st21nfca.h>
+
 #include <asm/unaligned.h>
 
 #include <net/nfc/hci.h>
@@ -60,6 +59,7 @@
 #define IS_START_OF_FRAME(buf) (buf[0] == ST21NFCA_SOF_EOF && \
 				buf[1] == 0)
 
+#define ST21NFCA_HCI_DRIVER_NAME "st21nfca_hci"
 #define ST21NFCA_HCI_I2C_DRIVER_NAME "st21nfca_hci_i2c"
 
 #define ST21NFCA_GPIO_NAME_EN "enable"
@@ -577,43 +577,10 @@ static int st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
 	return 0;
 }
 
-static int st21nfca_hci_i2c_request_resources(struct i2c_client *client)
-{
-	struct st21nfca_nfc_platform_data *pdata;
-	struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
-	int r;
-
-	pdata = client->dev.platform_data;
-	if (pdata == NULL) {
-		nfc_err(&client->dev, "No platform data\n");
-		return -EINVAL;
-	}
-
-	/* store for later use */
-	phy->gpio_ena = pdata->gpio_ena;
-	phy->irq_polarity = pdata->irq_polarity;
-
-	if (phy->gpio_ena > 0) {
-		r = devm_gpio_request_one(&client->dev, phy->gpio_ena,
-					  GPIOF_OUT_INIT_HIGH,
-					  ST21NFCA_GPIO_NAME_EN);
-		if (r) {
-			pr_err("%s : ena gpio_request failed\n", __FILE__);
-			return r;
-		}
-	}
-
-	phy->se_status.is_ese_present = pdata->is_ese_present;
-	phy->se_status.is_uicc_present = pdata->is_uicc_present;
-
-	return 0;
-}
-
 static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
 	struct st21nfca_i2c_phy *phy;
-	struct st21nfca_nfc_platform_data *pdata;
 	int r;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
@@ -639,19 +606,12 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 	mutex_init(&phy->phy_lock);
 	i2c_set_clientdata(client, phy);
 
-	pdata = client->dev.platform_data;
-	if (!pdata && client->dev.of_node) {
+	if (client->dev.of_node) {
 		r = st21nfca_hci_i2c_of_request_resources(client);
 		if (r) {
 			nfc_err(&client->dev, "No platform data\n");
 			return r;
 		}
-	} else if (pdata) {
-		r = st21nfca_hci_i2c_request_resources(client);
-		if (r) {
-			nfc_err(&client->dev, "Cannot get platform resources\n");
-			return r;
-		}
 	} else if (ACPI_HANDLE(&client->dev)) {
 		r = st21nfca_hci_i2c_acpi_request_resources(client);
 		if (r) {
diff --git a/include/linux/platform_data/st21nfca.h b/include/linux/platform_data/st21nfca.h
deleted file mode 100644
index cc2bdafb0c69..000000000000
--- a/include/linux/platform_data/st21nfca.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Driver include for the ST21NFCA NFC chip.
- *
- * Copyright (C) 2014  STMicroelectronics SAS. All rights reserved.
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
-#ifndef _ST21NFCA_HCI_H_
-#define _ST21NFCA_HCI_H_
-
-#include <linux/i2c.h>
-
-#define ST21NFCA_HCI_DRIVER_NAME "st21nfca_hci"
-
-struct st21nfca_nfc_platform_data {
-	unsigned int gpio_ena;
-	unsigned int irq_polarity;
-	bool is_ese_present;
-	bool is_uicc_present;
-};
-
-#endif /* _ST21NFCA_HCI_H_ */
-- 
2.11.0
