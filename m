Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbZHMTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 14/20] wireless: move drivers with menuconfigs together on kconfig
Date: Thu, 13 Aug 2009 15:31:43 -0400
Message-Id: <1250191909-21682-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The group drivers are now above, individual drivers below.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   76 +++++++++++++++++++++--------------------
 1 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 1c74512..d3b31f9 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -110,19 +110,6 @@ menuconfig WLAN_80211
 	  This option does not affect the kernel build, it only
 	  lets you choose drivers.
 
-config PCMCIA_RAYCS
-	tristate "Aviator/Raytheon 2.4GHz wireless support"
-	depends on PCMCIA && WLAN_80211
-	select WIRELESS_EXT
-	---help---
-	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
-	  (PC-card) wireless Ethernet networking card to your computer.
-	  Please read the file <file:Documentation/networking/ray_cs.txt> for
-	  details.
-
-	  To compile this driver as a module, choose M here: the module will be
-	  called ray_cs.  If unsure, say N.
-
 menuconfig MARVELL_80211
 	bool "Marvell Wireless Cards"
 	depends on WLAN_80211
@@ -297,15 +284,6 @@ config AT76C50X_USB
 
 endif # ATMEL_80211
 
-config PCMCIA_WL3501
-      tristate "Planet WL3501 PCMCIA cards"
-      depends on EXPERIMENTAL && PCMCIA && WLAN_80211
-      select WIRELESS_EXT
-       ---help---
-         A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
-	 It has basic support for Linux wireless extensions and initial
-	 micro support for ethtool.
-
 menuconfig CONEXANT_ST_80211
 	bool "Intersil / Conexant / STEricsson Wireless Cards"
 	depends on WLAN_80211
@@ -538,6 +516,45 @@ config RTL8187_LEDS
 
 endif # REALTEK_80211
 
+menuconfig INTEL_80211
+	bool "Intel Wireless Cards"
+	depends on WLAN_80211
+	---help---
+	  This will enable the support for Intel wireless drivers. This
+	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
+
+if INTEL_80211
+source "drivers/net/wireless/ipw2x00/Kconfig"
+source "drivers/net/wireless/iwlwifi/Kconfig"
+source "drivers/net/wireless/iwmc3200wifi/Kconfig"
+endif # INTEL_80211
+
+source "drivers/net/wireless/ath/Kconfig"
+source "drivers/net/wireless/rt2x00/Kconfig"
+source "drivers/net/wireless/wl12xx/Kconfig"
+
+config PCMCIA_RAYCS
+	tristate "Aviator/Raytheon 2.4GHz wireless support"
+	depends on PCMCIA && WLAN_80211
+	select WIRELESS_EXT
+	---help---
+	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
+	  (PC-card) wireless Ethernet networking card to your computer.
+	  Please read the file <file:Documentation/networking/ray_cs.txt> for
+	  details.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called ray_cs.  If unsure, say N.
+
+config PCMCIA_WL3501
+      tristate "Planet WL3501 PCMCIA cards"
+      depends on EXPERIMENTAL && PCMCIA && WLAN_80211
+      select WIRELESS_EXT
+       ---help---
+         A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
+	 It has basic support for Linux wireless extensions and initial
+	 micro support for ethtool.
+
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
@@ -578,22 +595,7 @@ config MAC80211_HWSIM
 	  To compile this driver as a module, choose M here: the module will be
 	  called mac80211_hwsim.  If unsure, say N.
 
-menuconfig INTEL_80211
-	bool "Intel Wireless Cards"
-	depends on WLAN_80211
-	---help---
-	  This will enable the support for Intel wireless drivers. This
-	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
-
-if INTEL_80211
-source "drivers/net/wireless/ipw2x00/Kconfig"
-source "drivers/net/wireless/iwlwifi/Kconfig"
-source "drivers/net/wireless/iwmc3200wifi/Kconfig"
-endif # INTEL_80211
-source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
-source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
-source "drivers/net/wireless/wl12xx/Kconfig"
 
 endmenu
-- 
1.6.2.5

