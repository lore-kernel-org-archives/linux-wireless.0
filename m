Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbZHNAnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 20/25] wireless: simplify WLAN_PRE80211 entries
Date: Thu, 13 Aug 2009 20:42:59 -0400
Message-Id: <1250210584-13374-21-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do simplify them by ifdef'ing on WLAN_PRE80211 for
the WLAN_PRE80211 drivers, this removes the need to depend
on WLAN_PRE80211 on each individual driver.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 45e9cf2..3116763 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -14,9 +14,11 @@ menuconfig WLAN_PRE80211
 	  This option does not affect the kernel build, it only
 	  lets you choose drivers.
 
+if WLAN_PRE80211
+
 config ARLAN
 	tristate "Aironet Arlan 655 & IC2200 DS support"
-	depends on ISA && !64BIT && WLAN_PRE80211
+	depends on ISA && !64BIT
 	select WIRELESS_EXT
 	---help---
 	  Aironet makes Arlan, a class of wireless LAN adapters. These use the
@@ -32,7 +34,7 @@ config ARLAN
 
 config WAVELAN
 	tristate "AT&T/Lucent old WaveLAN & DEC RoamAbout DS ISA support"
-	depends on ISA && WLAN_PRE80211
+	depends on ISA
 	select WIRELESS_EXT
 	---help---
 	  The Lucent WaveLAN (formerly NCR and AT&T; or DEC RoamAbout DS) is
@@ -55,7 +57,7 @@ config WAVELAN
 
 config PCMCIA_WAVELAN
 	tristate "AT&T/Lucent old WaveLAN Pcmcia wireless support"
-	depends on PCMCIA && WLAN_PRE80211
+	depends on PCMCIA
 	select WIRELESS_EXT
 	help
 	  Say Y here if you intend to attach an AT&T/Lucent Wavelan PCMCIA
@@ -67,7 +69,7 @@ config PCMCIA_WAVELAN
 
 config STRIP
 	tristate "STRIP (Metricom starmode radio IP)"
-	depends on INET && WLAN_PRE80211
+	depends on INET
 	select WIRELESS_EXT
 	---help---
 	  Say Y if you have a Metricom radio and intend to use Starmode Radio
@@ -91,7 +93,7 @@ config STRIP
 
 config PCMCIA_NETWAVE
 	tristate "Xircom Netwave AirSurfer Pcmcia wireless support"
-	depends on PCMCIA && WLAN_PRE80211
+	depends on PCMCIA
 	select WIRELESS_EXT
 	help
 	  Say Y here if you intend to attach this type of PCMCIA (PC-card)
@@ -100,6 +102,8 @@ config PCMCIA_NETWAVE
 	  To compile this driver as a module, choose M here: the module will be
 	  called netwave_cs.  If unsure, say N.
 
+endif # WLAN_PRE80211
+
 menuconfig WLAN_80211
 	bool "Wireless LAN (IEEE 802.11)"
 	depends on NETDEVICES
-- 
1.6.2.5

