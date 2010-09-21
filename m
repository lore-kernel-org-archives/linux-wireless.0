Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51729 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0IUU0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 16:26:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: fix wl12xx driver
Date: Tue, 21 Sep 2010 22:26:31 +0200
Message-Id: <1285100791-384-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1285100791-384-1-git-send-email-hauke@hauke-m.de>
References: <1285100791-384-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This deactivate the wl1271_sdio driver, because it needs
wl12xx_platform_data.c directly compiled into the kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk               |    2 ++
 scripts/admin-update.sh |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index de5766f..19ea6b2 100644
--- a/config.mk
+++ b/config.mk
@@ -485,7 +485,9 @@ ifdef CONFIG_CRC7
 CONFIG_WL1251_SDIO=m
 
 ifndef CONFIG_COMPAT_KERNEL_32
+ifdef CONFIG_WL12XX_PLATFORM_DATA
 CONFIG_WL1271_SDIO=m
+endif #CONFIG_WL12XX_PLATFORM_DATA
 endif #CONFIG_COMPAT_KERNEL_32
 
 endif #CONFIG_CRC7
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index ac9470d..91722f3 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -24,11 +24,12 @@ NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/
 INCLUDE_LINUX="ieee80211.h nl80211.h"
 INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h eeprom_93cx6.h"
 INCLUDE_LINUX="$INCLUDE_LINUX ath9k_platform.h"
+INCLUDE_LINUX="$INCLUDE_LINUX wl12xx.h"
 
 # For rndis_wext
 INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
 
-INCLUDE_LINUX_SPI="wl12xx.h libertas_spi.h"
+INCLUDE_LINUX_SPI="libertas_spi.h"
 
 # The good new yummy stuff
 INCLUDE_NET="cfg80211.h ieee80211_radiotap.h"
-- 
1.7.0.4

