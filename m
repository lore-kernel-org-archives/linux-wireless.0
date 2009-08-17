Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbZHQR1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 19/33] wireless: organize individual drivers alphabetically
Date: Mon, 17 Aug 2009 13:27:18 -0400
Message-Id: <1250530052-14783-20-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   95 +++++++++++++++++++++---------------------
 1 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index e57c62d..de76484 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -14,30 +14,6 @@ menuconfig WLAN_PRE80211
 	  This option does not affect the kernel build, it only
 	  lets you choose drivers.
 
-config STRIP
-	tristate "STRIP (Metricom starmode radio IP)"
-	depends on INET && WLAN_PRE80211
-	select WIRELESS_EXT
-	---help---
-	  Say Y if you have a Metricom radio and intend to use Starmode Radio
-	  IP. STRIP is a radio protocol developed for the MosquitoNet project
-	  (on the WWW at <http://mosquitonet.stanford.edu/>) to send Internet
-	  traffic using Metricom radios.  Metricom radios are small, battery
-	  powered, 100kbit/sec packet radio transceivers, about the size and
-	  weight of a cellular telephone. (You may also have heard them called
-	  "Metricom modems" but we avoid the term "modem" because it misleads
-	  many people into thinking that you can plug a Metricom modem into a
-	  phone line and use it as a modem.)
-
-	  You can use STRIP on any Linux machine with a serial port, although
-	  it is obviously most useful for people with laptop computers. If you
-	  think you might get a Metricom radio in the future, there is no harm
-	  in saying Y to STRIP now, except that it makes the kernel a bit
-	  bigger.
-
-	  To compile this as a module, choose M here: the module will be
-	  called strip.
-
 config ARLAN
 	tristate "Aironet Arlan 655 & IC2200 DS support"
 	depends on ISA && !64BIT && WLAN_PRE80211
@@ -89,6 +65,30 @@ config PCMCIA_WAVELAN
 	  To compile this driver as a module, choose M here: the module will be
 	  called wavelan_cs.  If unsure, say N.
 
+config STRIP
+	tristate "STRIP (Metricom starmode radio IP)"
+	depends on INET && WLAN_PRE80211
+	select WIRELESS_EXT
+	---help---
+	  Say Y if you have a Metricom radio and intend to use Starmode Radio
+	  IP. STRIP is a radio protocol developed for the MosquitoNet project
+	  (on the WWW at <http://mosquitonet.stanford.edu/>) to send Internet
+	  traffic using Metricom radios.  Metricom radios are small, battery
+	  powered, 100kbit/sec packet radio transceivers, about the size and
+	  weight of a cellular telephone. (You may also have heard them called
+	  "Metricom modems" but we avoid the term "modem" because it misleads
+	  many people into thinking that you can plug a Metricom modem into a
+	  phone line and use it as a modem.)
+
+	  You can use STRIP on any Linux machine with a serial port, although
+	  it is obviously most useful for people with laptop computers. If you
+	  think you might get a Metricom radio in the future, there is no harm
+	  in saying Y to STRIP now, except that it makes the kernel a bit
+	  bigger.
+
+	  To compile this as a module, choose M here: the module will be
+	  called strip.
+
 config PCMCIA_NETWAVE
 	tristate "Xircom Netwave AirSurfer Pcmcia wireless support"
 	depends on PCMCIA && WLAN_PRE80211
@@ -100,7 +100,6 @@ config PCMCIA_NETWAVE
 	  To compile this driver as a module, choose M here: the module will be
 	  called netwave_cs.  If unsure, say N.
 
-
 menuconfig WLAN_80211
 	bool "Wireless LAN (IEEE 802.11)"
 	depends on NETDEVICES
@@ -509,28 +508,6 @@ config USB_ZD1201
 
 endif # ZYDAS_80211
 
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
-config PCMCIA_WL3501
-      tristate "Planet WL3501 PCMCIA cards"
-      depends on EXPERIMENTAL && PCMCIA && WLAN_80211
-      select WIRELESS_EXT
-       ---help---
-         A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
-	 It has basic support for Linux wireless extensions and initial
-	 micro support for ethtool.
-
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
@@ -558,8 +535,30 @@ config ADM8211
 
 	  Thanks to Infineon-ADMtek for their support of this driver.
 
-source "drivers/net/wireless/hostap/Kconfig"
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
 source "drivers/net/wireless/orinoco/Kconfig"
+source "drivers/net/wireless/hostap/Kconfig"
+
+config PCMCIA_WL3501
+      tristate "Planet WL3501 PCMCIA cards"
+      depends on EXPERIMENTAL && PCMCIA && WLAN_80211
+      select WIRELESS_EXT
+       ---help---
+         A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
+	 It has basic support for Linux wireless extensions and initial
+	 micro support for ethtool.
 
 config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
-- 
1.6.2.5

