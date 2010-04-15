Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:46064 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab0DOPXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 11:23:34 -0400
Received: by bwz25 with SMTP id 25so1743176bwz.28
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 08:23:33 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH v2] wl1251: register platform_device to pass board data
Date: Thu, 15 Apr 2010 18:23:23 +0300
Message-Id: <1271345003-15453-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1251 is embedded chip that can be connected using SDIO bus, and is not
an actual SDIO card. For this reason there is a need to pass some board
specific data, like 'EEPROM is attached' flag or power control callback.

However currently there is no way to pass this data through SDIO subsystem,
so this patch registers dummy platform_device to allow that, until we
have a better solution to this.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_sdio.c |   40 +++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index 2051ef0..7409c34 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -23,6 +23,8 @@
 #include <linux/mod_devicetable.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
+#include <linux/platform_device.h>
+#include <linux/spi/wl12xx.h>
 
 #include "wl1251.h"
 
@@ -34,6 +36,8 @@
 #define SDIO_DEVICE_ID_TI_WL1251	0x9066
 #endif
 
+static struct wl12xx_platform_data *wl12xx_board_data;
+
 static struct sdio_func *wl_to_func(struct wl1251 *wl)
 {
 	return wl->if_priv;
@@ -144,6 +148,30 @@ static const struct wl1251_if_operations wl1251_sdio_ops = {
 	.disable_irq = wl1251_sdio_disable_irq,
 };
 
+static int wl1251_platform_probe(struct platform_device *pdev)
+{
+	if (pdev->id != -1) {
+		wl1251_error("can only handle single device");
+		return -ENODEV;
+	}
+
+	wl12xx_board_data = pdev->dev.platform_data;
+	return 0;
+}
+
+/*
+ * Dummy platform_driver for passing platform_data to this driver,
+ * until we have a way to pass this through SDIO subsystem or
+ * some other way.
+ */
+static struct platform_driver wl1251_platform_driver = {
+	.driver = {
+		.name	= "wl1251_data",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= wl1251_platform_probe,
+};
+
 static int wl1251_sdio_probe(struct sdio_func *func,
 			     const struct sdio_device_id *id)
 {
@@ -169,6 +197,11 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	wl->if_ops = &wl1251_sdio_ops;
 	wl->set_power = wl1251_sdio_set_power;
 
+	if (wl12xx_board_data != NULL) {
+		wl->set_power = wl12xx_board_data->set_power;
+		wl->use_eeprom = wl12xx_board_data->use_eeprom;
+	}
+
 	sdio_release_host(func);
 	ret = wl1251_init_ieee80211(wl);
 	if (ret)
@@ -208,6 +241,12 @@ static int __init wl1251_sdio_init(void)
 {
 	int err;
 
+	err = platform_driver_register(&wl1251_platform_driver);
+	if (err) {
+		wl1251_error("failed to register platform driver: %d", err);
+		return err;
+	}
+
 	err = sdio_register_driver(&wl1251_sdio_driver);
 	if (err)
 		wl1251_error("failed to register sdio driver: %d", err);
@@ -217,6 +256,7 @@ static int __init wl1251_sdio_init(void)
 static void __exit wl1251_sdio_exit(void)
 {
 	sdio_unregister_driver(&wl1251_sdio_driver);
+	platform_driver_unregister(&wl1251_platform_driver);
 	wl1251_notice("unloaded");
 }
 
-- 
1.6.3.3

