Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51637 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2DVWDb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 18:03:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/7] compat-wireless: ti: fix some problems with the config options
Date: Mon, 23 Apr 2012 00:03:14 +0200
Message-Id: <1335132199-21320-2-git-send-email-hauke@hauke-m.de> (sfid-20120423_000335_128068_D3CD515E)
In-Reply-To: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
References: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the ti drivers where reorganized some config options in config.mk
where wrong. This patch corrects them.
---
 config.mk                              |   13 +++++--------
 patches/08-rename-config-options.patch |   11 -----------
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/config.mk b/config.mk
index 22a8cf1..012a59f 100644
--- a/config.mk
+++ b/config.mk
@@ -545,7 +545,7 @@ ifndef CONFIG_COMPAT_KERNEL_2_6_25
 
 ifdef CONFIG_CRC7
 export CONFIG_WL1251_SPI=m
-export CONFIG_WL12XX_SPI=m
+export CONFIG_WLCORE_SPI=m
 endif #CONFIG_CRC7
 export CONFIG_P54_SPI=m
 
@@ -568,14 +568,8 @@ export CONFIG_B43_SDIO=y
 ifdef CONFIG_CRC7
 ifdef CONFIG_WL12XX_PLATFORM_DATA
 export CONFIG_COMPAT_WL1251_SDIO=m
+export CONFIG_WLCORE_SDIO=m
 endif #CONFIG_WL12XX_PLATFORM_DATA
-
-ifndef CONFIG_COMPAT_KERNEL_2_6_32
-ifdef CONFIG_WL12XX_PLATFORM_DATA
-export CONFIG_COMPAT_WLCORE_SDIO=m
-endif #CONFIG_WL12XX_PLATFORM_DATA
-endif #CONFIG_COMPAT_KERNEL_2_6_32
-
 endif #CONFIG_CRC7
 
 export CONFIG_MWIFIEX_SDIO=m
@@ -639,6 +633,9 @@ export CONFIG_ATH_COMMON=m
 export CONFIG_BRCMUTIL=m
 # export CONFIG_BRCMDBG=y
 
+export CONFIG_WL_TI=y
+export CONFIG_WLCORE=m
+
 ifdef CONFIG_CRC7
 export CONFIG_WL1251=m
 export CONFIG_WL12XX=m
diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index 52143d1..da63989 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -90,17 +90,6 @@ CONFIG_BT_HIDP does not build with older kernel versions.
 +obj-$(CONFIG_COMPAT_BT_HIDP) += hidp.o
  
  hidp-objs := core.o sock.o
---- a/drivers/net/wireless/ti/wlcore/Makefile
-+++ b/drivers/net/wireless/ti/wlcore/Makefile
-@@ -7,7 +7,7 @@ wlcore_sdio-objs	= sdio.o
- wlcore-$(CONFIG_NL80211_TESTMODE)	+= testmode.o
- obj-$(CONFIG_WLCORE)			+= wlcore.o
- obj-$(CONFIG_WLCORE_SPI)		+= wlcore_spi.o
--obj-$(CONFIG_WLCORE_SDIO)		+= wlcore_sdio.o
-+obj-$(CONFIG_COMPAT_WLCORE_SDIO)	+= wlcore_sdio.o
- 
- # small builtin driver bit
- obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
 --- a/drivers/net/wireless/ti/wl1251/Makefile
 +++ b/drivers/net/wireless/ti/wl1251/Makefile
 @@ -5,6 +5,6 @@ wl1251_sdio-objs	+= sdio.o
-- 
1.7.9.5

