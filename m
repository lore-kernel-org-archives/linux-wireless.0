Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab1ERIYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 04:24:09 -0400
Received: by wya21 with SMTP id 21so990546wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 01:24:08 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: remove unused crc7 references
Date: Wed, 18 May 2011 11:24:16 +0300
Message-Id: <1305707056-4503-1-git-send-email-eliad@wizery.com> (sfid-20110518_102414_405734_060E5F93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

crc7 is used only in wl12xx_spi.

Remove redundant crc7.h includes, and update Kconfig to select CRC7
only if WL12XX_SPI is being selected.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/Kconfig |    2 +-
 drivers/net/wireless/wl12xx/acx.c   |    1 -
 drivers/net/wireless/wl12xx/cmd.c   |    1 -
 drivers/net/wireless/wl12xx/io.c    |    1 -
 drivers/net/wireless/wl12xx/sdio.c  |    1 -
 5 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 35ce7b0..07bcb15 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -11,7 +11,6 @@ config WL12XX
 	depends on WL12XX_MENU && GENERIC_HARDIRQS
 	depends on INET
 	select FW_LOADER
-	select CRC7
 	---help---
 	  This module adds support for wireless adapters based on TI wl1271 and
 	  TI wl1273 chipsets. This module does *not* include support for wl1251.
@@ -33,6 +32,7 @@ config WL12XX_HT
 config WL12XX_SPI
 	tristate "TI wl12xx SPI support"
 	depends on WL12XX && SPI_MASTER
+	select CRC7
 	---help---
 	  This module adds support for the SPI interface of adapters using
 	  TI wl12xx chipsets.  Select this if your platform is using
diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index c6ee530..141748f 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/crc7.h>
 #include <linux/spi/spi.h>
 #include <linux/slab.h>
 
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 42935ac..b3a4f58 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -23,7 +23,6 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/crc7.h>
 #include <linux/spi/spi.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index da5c1ad..9ce8953 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -23,7 +23,6 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/crc7.h>
 #include <linux/spi/spi.h>
 
 #include "wl12xx.h"
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 92d29a8..c79f2c3 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -23,7 +23,6 @@
 
 #include <linux/irq.h>
 #include <linux/module.h>
-#include <linux/crc7.h>
 #include <linux/vmalloc.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
-- 
1.7.0.4

