Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44585 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaCAG0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 01:26:39 -0500
Received: by mail-pa0-f51.google.com with SMTP id kq14so1705851pab.10
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 22:26:39 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: Kconfig: add missing dependency
Date: Sat,  1 Mar 2014 14:26:29 +0800
Message-Id: <761de703220ff26c7deddbcc7dc081e91c9e77c6.1393654723.git.gamerh2o@gmail.com> (sfid-20140301_072707_081682_A5E77194)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous driver changes to airo, atmel, wl3501_cs, and usb_zd1201 need
to include <net/cfg80211.h>, which depends on CFG80211, so add the
missing dependency.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 200020e..d1fab43 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -53,7 +53,7 @@ config LIBERTAS_THINFIRM_USB
 
 config AIRO
 	tristate "Cisco/Aironet 34X/35X/4500/4800 ISA and PCI cards"
-	depends on ISA_DMA_API && (PCI || BROKEN)
+	depends on CFG80211 && ISA_DMA_API && (PCI || BROKEN)
 	select WIRELESS_EXT
 	select CRYPTO
 	select WEXT_SPY
@@ -73,7 +73,7 @@ config AIRO
 
 config ATMEL
       tristate "Atmel at76c50x chipset  802.11b support"
-      depends on (PCI || PCMCIA)
+      depends on CFG80211 && (PCI || PCMCIA)
       select WIRELESS_EXT
       select WEXT_PRIV
       select FW_LOADER
@@ -138,7 +138,7 @@ config AIRO_CS
 
 config PCMCIA_WL3501
 	tristate "Planet WL3501 PCMCIA cards"
-	depends on PCMCIA
+	depends on CFG80211 && PCMCIA
 	select WIRELESS_EXT
 	select WEXT_SPY
 	help
@@ -168,7 +168,7 @@ config PRISM54
 
 config USB_ZD1201
 	tristate "USB ZD1201 based Wireless device support"
-	depends on USB
+	depends on CFG80211 && USB
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select FW_LOADER
-- 
1.8.5.3

