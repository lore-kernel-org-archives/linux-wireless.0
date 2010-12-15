Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:24992 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab0LOO3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 09:29:41 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oBFETdvu004458
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 16:29:40 +0200
From: luciano.coelho@nokia.com
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Roger Quadros <roger.quadros@nokia.com>
Subject: [PATCH v2] wl12xx_sdio_test: rename files to match current style
Date: Wed, 15 Dec 2010 16:31:39 +0200
Message-Id: <1292423499-5667-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Change some file names and Kconfig settings so that this new module matches
the new way of using wl12xx instead of wl1271.

Also fix SDIO power enabling and disabling to match the latest way of doing
it.

Cc: Roger Quadros <roger.quadros@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/Kconfig                |   12 +++++---
 drivers/net/wireless/wl12xx/Makefile               |    3 +-
 .../wl12xx/{wl1271_sdio_test.c => sdio_test.c}     |   28 +++++++++++++------
 3 files changed, 28 insertions(+), 15 deletions(-)
 rename drivers/net/wireless/wl12xx/{wl1271_sdio_test.c => sdio_test.c} (96%)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 085bc44..0e65bce 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -52,13 +52,15 @@ config WL12XX_SDIO
 	  If you choose to build a module, it'll be called wl12xx_sdio.
 	  Say N if unsure.
 
-config WL1271_SDIO_TEST
-	tristate "TI wl1271 SDIO testing support"
-	depends on WL1271 && MMC
+config WL12XX_SDIO_TEST
+	tristate "TI wl12xx SDIO testing support"
+	depends on WL12XX && MMC
+	default n
 	---help---
 	  This module adds support for the SDIO bus testing with the
-	  TI wl1271 chipset.  Select this if your platform is using
-	  the SDIO bus.
+	  TI wl12xx chipsets.  You probably don't want this unless you are
+	  testing a new hardware platform.  Select this if you want to test the
+	  SDIO bus which is connected to the wl12xx chip.
 
 config WL12XX_PLATFORM_DATA
 	bool
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index 1876785..521c041 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -3,13 +3,14 @@ wl12xx-objs		= main.o cmd.o io.o event.o tx.o rx.o ps.o acx.o \
 
 wl12xx_spi-objs	= spi.o
 wl12xx_sdio-objs	= sdio.o
+wl12xx_sdio_test-objs = sdio_test.o
 
 wl12xx-$(CONFIG_NL80211_TESTMODE)	+= testmode.o
 obj-$(CONFIG_WL12XX)			+= wl12xx.o
 obj-$(CONFIG_WL12XX_SPI)		+= wl12xx_spi.o
 obj-$(CONFIG_WL12XX_SDIO)		+= wl12xx_sdio.o
 
-obj-$(CONFIG_WL1271_SDIO_TEST)	+= wl1271_sdio_test.o
+obj-$(CONFIG_WL12XX_SDIO_TEST)	+= wl12xx_sdio_test.o
 
 # small builtin driver bit
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
similarity index 96%
rename from drivers/net/wireless/wl12xx/wl1271_sdio_test.c
rename to drivers/net/wireless/wl12xx/sdio_test.c
index 42d1314..9fcbd3d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio_test.c
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -1,11 +1,11 @@
 /*
- * wl1271_sdio_test.c - SDIO testing driver for wl1271
+ * SDIO testing driver for wl12xx
  *
  * Copyright (C) 2010 Nokia Corporation
  *
  * Contact: Roger Quadros <roger.quadros@nokia.com>
  *
- * wl1271 read/write routines taken from wl1271_sdio.c
+ * wl12xx read/write routines taken from the main module
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -34,10 +34,11 @@
 #include <linux/wl12xx.h>
 #include <linux/kthread.h>
 #include <linux/firmware.h>
+#include <linux/pm_runtime.h>
 
-#include "wl1271.h"
-#include "wl1271_io.h"
-#include "wl1271_boot.h"
+#include "wl12xx.h"
+#include "io.h"
+#include "boot.h"
 
 #ifndef SDIO_VENDOR_ID_TI
 #define SDIO_VENDOR_ID_TI		0x0097
@@ -130,22 +131,31 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 {
 	struct sdio_func *func = wl_to_func(wl);
+	int ret;
 
 	/* Let the SDIO stack handle wlan_enable control, so we
 	 * keep host claimed while wlan is in use to keep wl1271
 	 * alive.
 	 */
 	if (enable) {
-		sdio_claim_power(func);
+		/* Power up the card */
+		ret = pm_runtime_get_sync(&func->dev);
+		if (ret < 0)
+			goto out;
 		sdio_claim_host(func);
 		sdio_enable_func(func);
+		sdio_release_host(func);
 	} else {
+		sdio_claim_host(func);
 		sdio_disable_func(func);
 		sdio_release_host(func);
-		sdio_release_power(func);
+
+		/* Power down the card */
+		ret = pm_runtime_put_sync(&func->dev);
 	}
 
-	return 0;
+out:
+	return ret;
 }
 
 static void wl1271_sdio_disable_interrupts(struct wl1271 *wl)
@@ -481,7 +491,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 }
 
 static struct sdio_driver wl1271_sdio_driver = {
-	.name		= "wl1271_sdio_test",
+	.name		= "wl12xx_sdio_test",
 	.id_table	= wl1271_devices,
 	.probe		= wl1271_probe,
 	.remove		= __devexit_p(wl1271_remove),
-- 
1.7.0.4

