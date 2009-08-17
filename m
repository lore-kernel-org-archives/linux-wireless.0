Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53097 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbZHQR1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:31 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 03/33] wireless: move MWL8K right below libertas on kconfig
Date: Mon, 17 Aug 2009 13:27:02 -0400
Message-Id: <1250530052-14783-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index ab7a185..abb6930 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -176,6 +176,15 @@ config LIBERTAS_THINFIRM_USB
 	---help---
 	  A driver for Marvell Libertas 8388 USB devices using thinfirm.
 
+config MWL8K
+	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
+	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+	---help---
+	  This driver supports Marvell TOPDOG 802.11 wireless cards.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called mwl8k.  If unsure, say N.
+
 config AIRO
 	tristate "Cisco/Aironet 34X/35X/4500/4800 ISA and PCI cards"
 	depends on ISA_DMA_API && WLAN_80211 && (PCI || BROKEN)
@@ -484,15 +493,6 @@ config MAC80211_HWSIM
 	  To compile this driver as a module, choose M here: the module will be
 	  called mac80211_hwsim.  If unsure, say N.
 
-config MWL8K
-	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
-	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
-	---help---
-	  This driver supports Marvell TOPDOG 802.11 wireless cards.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called mwl8k.  If unsure, say N.
-
 source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/ath/Kconfig"
 
-- 
1.6.2.5

