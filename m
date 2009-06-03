Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZFCQai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 12:30:38 -0400
Subject: [PATCH] cfg80211: fix Kconfig for users of cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <samuel@sortiz.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 18:30:31 +0200
Message-Id: <1244046631.4862.34.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * iwm doesn't depend on cfg80211 or wireless extensions
 * rndis wlan selects cfg80211 - needs to depend
 * mac80211 selects cfg80211 - needs to depend

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/Kconfig              |    2 +-
 drivers/net/wireless/iwmc3200wifi/Kconfig |    2 ++
 net/mac80211/Kconfig                      |    5 ++++-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/Kconfig	2009-06-03 18:20:06.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2009-06-03 18:24:58.000000000 +0200
@@ -1,16 +1,19 @@
 config MAC80211
 	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
+	depends on CFG80211
 	select CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_ARC4
 	select CRYPTO_AES
 	select CRC32
 	select WIRELESS_EXT
-	select CFG80211
 	---help---
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.
 
+comment "CFG80211 needs to be enabled for MAC80211"
+	depends on CFG80211=n
+
 config MAC80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on MAC80211
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/Kconfig	2009-06-03 18:25:55.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/Kconfig	2009-06-03 18:26:29.000000000 +0200
@@ -1,6 +1,8 @@
 config IWM
 	tristate "Intel Wireless Multicomm 3200 WiFi driver"
 	depends on MMC && WLAN_80211 && EXPERIMENTAL
+	depends on CFG80211
+	select WIRELESS_EXT
 	select LIB80211
 	select FW_LOADER
 
--- wireless-testing.orig/drivers/net/wireless/Kconfig	2009-06-03 18:26:37.000000000 +0200
+++ wireless-testing/drivers/net/wireless/Kconfig	2009-06-03 18:26:46.000000000 +0200
@@ -333,11 +333,11 @@ config USB_ZD1201
 config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
 	depends on USB && WLAN_80211 && EXPERIMENTAL
+	depends on CFG80211
 	select USB_USBNET
 	select USB_NET_CDCETHER
 	select USB_NET_RNDIS_HOST
 	select WIRELESS_EXT
-	select CFG80211
 	---help---
 	  This is a driver for wireless RNDIS devices.
 	  These are USB based adapters found in devices such as:


