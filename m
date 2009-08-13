Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZHMTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 02/20] wireless: move MWL8K right below Libertas on kconfig
Date: Thu, 13 Aug 2009 15:31:31 -0400
Message-Id: <1250191909-21682-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 92bb407..b2e8b04 100644
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
 menuconfig INTEL_80211
 	bool "Intel Wireless Cards"
 	depends on WLAN_80211
-- 
1.6.2.5

