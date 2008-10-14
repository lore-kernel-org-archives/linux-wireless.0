Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYJNR5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 13:57:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Kpo93-0001oE-Cb
	for linux-wireless@vger.kernel.org; Tue, 14 Oct 2008 19:57:21 +0200
Subject: [RFC] make ieee80211 invisible
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 19:49:22 +0200
Message-Id: <1224006562.10113.47.camel@johannes.berg> (sfid-20081014_195730_335063_053D77F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



This makes CONFIG_IEEE80211 invisible. The drivers that require it
(ipw2100, ipw2200, hostap) select it, and everybody else really
shouldn't even think about using it. Also, since there really is
no point in compiling anything without crypto support these days,
remove the crypto options and just enable them, leaving only the
debugging option which only shows up when a driver is select that
requires it. This makes it hard to enable, but most people wouldn't
want to anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/ieee80211/Kconfig |   56 ++++++++++++++------------------------------------
 1 file changed, 16 insertions(+), 40 deletions(-)

--- everything.orig/net/ieee80211/Kconfig	2008-10-14 19:42:44.000000000 +0200
+++ everything/net/ieee80211/Kconfig	2008-10-14 19:45:13.000000000 +0200
@@ -1,12 +1,23 @@
 config IEEE80211
-	tristate "Generic IEEE 802.11 Networking Stack (DEPRECATED)"
+	tristate
+	select WIRELESS_EXT
+	select CRYPTO
+	select CRYPTO_ARC4
+	select CRYPTO_ECB
+	select CRYPTO_AES
+	select CRYPTO_MICHAEL_MIC
+	select CRYPTO_ECB
+	select CRC32
+	select IEEE80211_CRYPT_WEP
+	select IEEE80211_CRYPT_TKIP
+	select IEEE80211_CRYPT_CCMP
 	---help---
 	This option enables the hardware independent IEEE 802.11
 	networking stack.  This component is deprecated in favor of the
 	mac80211 component.
 
 config IEEE80211_DEBUG
-	bool "Enable full debugging output"
+	bool "Full debugging output for the old IEEE80211 stack"
 	depends on IEEE80211
 	---help---
 	  This option will enable debug tracing output for the
@@ -29,45 +40,10 @@ config IEEE80211_DEBUG
 	  subsystem, you most likely want to say N here.
 
 config IEEE80211_CRYPT_WEP
-	tristate "IEEE 802.11 WEP encryption (802.1x)"
-	depends on IEEE80211
-	select CRYPTO
-	select CRYPTO_ARC4
-	select CRYPTO_ECB
-	select CRC32
-	---help---
-	Include software based cipher suites in support of IEEE
-	802.11's WEP.  This is needed for WEP as well as 802.1x.
-
-	This can be compiled as a module and it will be called
-	"ieee80211_crypt_wep".
+	tristate
 
 config IEEE80211_CRYPT_CCMP
-	tristate "IEEE 802.11i CCMP support"
-	depends on IEEE80211
-	select CRYPTO
-	select CRYPTO_AES
-	---help---
-	Include software based cipher suites in support of IEEE 802.11i
-	(aka TGi, WPA, WPA2, WPA-PSK, etc.) for use with CCMP enabled
-	networks.
-
-	This can be compiled as a module and it will be called
-	"ieee80211_crypt_ccmp".
+	tristate
 
 config IEEE80211_CRYPT_TKIP
-	tristate "IEEE 802.11i TKIP encryption"
-	depends on IEEE80211
-	select WIRELESS_EXT
-	select CRYPTO
-	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
-	select CRC32
-	---help---
-	Include software based cipher suites in support of IEEE 802.11i
-	(aka TGi, WPA, WPA2, WPA-PSK, etc.) for use with TKIP enabled
-	networks.
-
-	This can be compiled as a module and it will be called
-	"ieee80211_crypt_tkip".
-
+	tristate


