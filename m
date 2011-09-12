Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:50778 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811Ab1ILHAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 03:00:38 -0400
Received: by mail-ww0-f50.google.com with SMTP id 3so1506063wwe.7
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 00:00:35 -0700 (PDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Shahar Levi <shahar_levi@ti.com>
Subject: [PATCH] wl12xx: Fix sdio test module functionality
Date: Mon, 12 Sep 2011 10:00:37 +0300
Message-Id: <1315810837-30599-1-git-send-email-shahar_levi@ti.com> (sfid-20110912_090042_171901_8D37FAF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sdio test is broken due to changing in the io layer and FW
macro name. Those fixes have been implemented in the wl12xx driver.
Align the sdio test module with those fixes + small beautify
indentation in the makefile.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/Makefile    |    6 +++---
 drivers/net/wireless/wl12xx/sdio_test.c |   17 +++++++++++++----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index 521c041..621b348 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,16 +1,16 @@
 wl12xx-objs		= main.o cmd.o io.o event.o tx.o rx.o ps.o acx.o \
 			  boot.o init.o debugfs.o scan.o
 
-wl12xx_spi-objs	= spi.o
+wl12xx_spi-objs 	= spi.o
 wl12xx_sdio-objs	= sdio.o
-wl12xx_sdio_test-objs = sdio_test.o
+wl12xx_sdio_test-objs	= sdio_test.o
 
 wl12xx-$(CONFIG_NL80211_TESTMODE)	+= testmode.o
 obj-$(CONFIG_WL12XX)			+= wl12xx.o
 obj-$(CONFIG_WL12XX_SPI)		+= wl12xx_spi.o
 obj-$(CONFIG_WL12XX_SDIO)		+= wl12xx_sdio.o
 
-obj-$(CONFIG_WL12XX_SDIO_TEST)	+= wl12xx_sdio_test.o
+obj-$(CONFIG_WL12XX_SDIO_TEST)		+= wl12xx_sdio_test.o
 
 # small builtin driver bit
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
diff --git a/drivers/net/wireless/wl12xx/sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
index f289153..1047dd2 100644
--- a/drivers/net/wireless/wl12xx/sdio_test.c
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -30,6 +30,7 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
+#include <linux/mmc/host.h>
 #include <linux/gpio.h>
 #include <linux/wl12xx.h>
 #include <linux/kthread.h>
@@ -142,14 +143,23 @@ static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 		ret = pm_runtime_get_sync(&func->dev);
 		if (ret < 0)
 			goto out;
+
+		/* Runtime PM might be disabled, power up the card manually */
+		ret = mmc_power_restore_host(func->card->host);
+		if (ret < 0)
+			goto out;
+
 		sdio_claim_host(func);
 		sdio_enable_func(func);
-		sdio_release_host(func);
 	} else {
-		sdio_claim_host(func);
 		sdio_disable_func(func);
 		sdio_release_host(func);
 
+		/* Runtime PM might be disabled, power off the card manually */
+		ret = mmc_power_save_host(func->card->host);
+		if (ret < 0)
+			goto out;
+
 		/* Power down the card */
 		ret = pm_runtime_put_sync(&func->dev);
 	}
@@ -193,7 +203,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 		ret = request_firmware(&fw, WL128X_FW_NAME,
 				       wl1271_wl_to_dev(wl));
 	else
-		ret = request_firmware(&fw, WL1271_FW_NAME,
+		ret = request_firmware(&fw, WL127X_FW_NAME,
 				       wl1271_wl_to_dev(wl));
 
 	if (ret < 0) {
@@ -433,7 +443,6 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	sdio_set_drvdata(func, wl_test);
 
-
 	/* power up the device */
 	ret = wl1271_chip_wakeup(wl);
 	if (ret) {
-- 
1.7.1

