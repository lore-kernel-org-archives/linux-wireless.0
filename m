Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34035 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648Ab1CaQWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:22:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] compat-wireless: fix compile warning for wl12xx
Date: Thu, 31 Mar 2011 18:22:06 +0200
Message-Id: <1301588527-16615-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
References: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only CONFIG_WL12XX_SDIO and CONFIG_WL1251_SDIO are depending on
CONFIG_WL12XX_PLATFORM_DATA, so only these two config options should be
renamed. The other options should still use the normal name. The old
commit did not fix the problem for me.

This fixes compat-wireless commit:
        7b4debf48b81d7e7e0e2915b81ad6a4af57cb5d1
        compat-wireless: fix compilation warning for wl12xx

Luis please add this into the linux-2.6.39.y branch.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |    6 +++---
 patches/08-rename-config-options.patch |   18 +++++++++++-------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/config.mk b/config.mk
index a66fd5a..f7b5323 100644
--- a/config.mk
+++ b/config.mk
@@ -497,7 +497,7 @@ ifndef CONFIG_COMPAT_KERNEL_25
 
 ifdef CONFIG_CRC7
 CONFIG_WL1251_SPI=m
-CONFIG_COMPAT_WL12XX_SPI=m
+CONFIG_WL12XX_SPI=m
 endif #CONFIG_CRC7
 CONFIG_P54_SPI=m
 
@@ -519,7 +519,7 @@ CONFIG_B43_SDIO=y
 
 ifdef CONFIG_CRC7
 ifdef CONFIG_WL12XX_PLATFORM_DATA
-CONFIG_WL1251_SDIO=m
+CONFIG_COMPAT_WL1251_SDIO=m
 endif #CONFIG_WL12XX_PLATFORM_DATA
 
 ifndef CONFIG_COMPAT_KERNEL_32
@@ -607,7 +607,7 @@ CONFIG_ATH_COMMON=m
 
 ifdef CONFIG_CRC7
 CONFIG_WL1251=m
-CONFIG_COMPAT_WL12XX=m
+CONFIG_WL12XX=m
 CONFIG_WL12XX_HT=y
 endif #CONFIG_CRC7
 
diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index 3232b40..639ee3a 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -113,15 +113,11 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  hidp-objs := core.o sock.o
 --- a/drivers/net/wireless/wl12xx/Makefile
 +++ b/drivers/net/wireless/wl12xx/Makefile
-@@ -6,11 +6,11 @@
- wl12xx_sdio_test-objs = sdio_test.o
- 
+@@ -8,9 +8,9 @@ wl12xx_sdio_test-objs = sdio_test.o
  wl12xx-$(CONFIG_NL80211_TESTMODE)	+= testmode.o
--obj-$(CONFIG_WL12XX)			+= wl12xx.o
--obj-$(CONFIG_WL12XX_SPI)		+= wl12xx_spi.o
+ obj-$(CONFIG_WL12XX)			+= wl12xx.o
+ obj-$(CONFIG_WL12XX_SPI)		+= wl12xx_spi.o
 -obj-$(CONFIG_WL12XX_SDIO)		+= wl12xx_sdio.o
-+obj-$(CONFIG_COMPAT_WL12XX)			+= wl12xx.o
-+obj-$(CONFIG_COMPAT_WL12XX_SPI)		+= wl12xx_spi.o
 +obj-$(CONFIG_COMPAT_WL12XX_SDIO)		+= wl12xx_sdio.o
  
 -obj-$(CONFIG_WL12XX_SDIO_TEST)	+= wl12xx_sdio_test.o
@@ -129,3 +125,11 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  
  # small builtin driver bit
  obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
+--- a/drivers/net/wireless/wl1251/Makefile
++++ b/drivers/net/wireless/wl1251/Makefile
+@@ -5,4 +5,4 @@ wl1251_sdio-objs	+= sdio.o
+ 
+ obj-$(CONFIG_WL1251)		+= wl1251.o
+ obj-$(CONFIG_WL1251_SPI)	+= wl1251_spi.o
+-obj-$(CONFIG_WL1251_SDIO)	+= wl1251_sdio.o
++obj-$(CONFIG_COMPAT_WL1251_SDIO)	+= wl1251_sdio.o
-- 
1.7.1

