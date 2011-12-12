Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41147 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1LLRNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 12:13:42 -0500
Received: by bkcjm19 with SMTP id jm19so1672702bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 09:13:41 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-wireless: fix patches/08-rename-config-options.patch
Date: Mon, 12 Dec 2011 19:14:16 +0200
Message-Id: <1323710056-15765-1-git-send-email-eliad@wizery.com> (sfid-20111212_181345_317749_D8227368)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx_sdio_test module was removed

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 patches/08-rename-config-options.patch |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index fdd39ec..ae50768 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -107,18 +107,13 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  hidp-objs := core.o sock.o
 --- a/drivers/net/wireless/wl12xx/Makefile
 +++ b/drivers/net/wireless/wl12xx/Makefile
-@@ -8,9 +8,9 @@ wl12xx_sdio_test-objs	= sdio_test.o
+@@ -8,5 +8,5 @@ wl12xx_sdio_test-objs	= sdio_test.o
  wl12xx-$(CONFIG_NL80211_TESTMODE)	+= testmode.o
  obj-$(CONFIG_WL12XX)			+= wl12xx.o
  obj-$(CONFIG_WL12XX_SPI)		+= wl12xx_spi.o
 -obj-$(CONFIG_WL12XX_SDIO)		+= wl12xx_sdio.o
 +obj-$(CONFIG_COMPAT_WL12XX_SDIO)		+= wl12xx_sdio.o
  
--obj-$(CONFIG_WL12XX_SDIO_TEST)		+= wl12xx_sdio_test.o
-+obj-$(CONFIG_COMPAT_WL12XX_SDIO_TEST)		+= wl12xx_sdio_test.o
- 
- # small builtin driver bit
- obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
 --- a/drivers/net/wireless/wl1251/Makefile
 +++ b/drivers/net/wireless/wl1251/Makefile
 @@ -5,4 +5,4 @@ wl1251_sdio-objs	+= sdio.o
-- 
1.7.6.401.g6a319

