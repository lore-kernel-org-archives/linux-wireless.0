Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47804 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab1BXSxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 13:53:18 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: add rtl8192cu
Date: Thu, 24 Feb 2011 19:53:07 +0100
Message-Id: <1298573588-2943-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1298573588-2943-1-git-send-email-hauke@hauke-m.de>
References: <1298573588-2943-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk               |    6 +++++-
 scripts/admin-update.sh |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 1fa16dd..8007708 100644
--- a/config.mk
+++ b/config.mk
@@ -369,7 +369,6 @@ endif #CONFIG_PCMCIA
 endif #CONFIG_WIRELESS_EXT
 
 CONFIG_RTL8192CE=m
-CONFIG_RTLWIFI=m
 
 endif #CONFIG_PCI
 ## end of PCI
@@ -488,6 +487,8 @@ CONFIG_BT_HCIBPA10X=m
 CONFIG_BT_HCIBFUSB=m
 CONFIG_BT_ATH3K=m
 
+CONFIG_RTL8192CU=m
+
 endif #CONFIG_USB end of USB driver list
 
 ifdef CONFIG_SPI_MASTER
@@ -568,6 +569,9 @@ endif #CONFIG_MMC
 
 endif # end of SDIO driver list
 
+CONFIG_RTLWIFI=m
+CONFIG_RTL8192C_COMMON=m
+
 # Common rt2x00 requirements
 ifeq ($(NEED_RT2X00),y)
 CONFIG_RT2X00=y
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index dd88f65..58f3750 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -235,6 +235,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/rtl818x/rtl8187"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192c"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192ce"
+DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192cu"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
 DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
-- 
1.7.1

