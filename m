Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:47923 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbZH3UWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 16:22:40 -0400
Message-ID: <4A9ADFA1.5030706@oracle.com>
Date: Sun, 30 Aug 2009 13:22:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ipw2100-devel@lists.sourceforge.net, linville@tuxdriver.com,
	akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] ipw2200: fix kconfig dependencies
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependencies for ipw2x00 drivers, fixes build errors:

ERROR: "wiphy_free" [drivers/net/wireless/ipw2x00/libipw.ko] undefined!
ERROR: "wiphy_unregister" [drivers/net/wireless/ipw2x00/libipw.ko] undefined!
ERROR: "wiphy_new" [drivers/net/wireless/ipw2x00/libipw.ko] undefined!
ERROR: "cfg80211_wext_giwname" [drivers/net/wireless/ipw2x00/ipw2200.ko] undefined!
ERROR: "wiphy_register" [drivers/net/wireless/ipw2x00/ipw2200.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/ipw2x00/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20090828.orig/drivers/net/wireless/ipw2x00/Kconfig
+++ linux-next-20090828/drivers/net/wireless/ipw2x00/Kconfig
@@ -4,7 +4,7 @@
 
 config IPW2100
 	tristate "Intel PRO/Wireless 2100 Network Connection"
-	depends on PCI && WLAN_80211
+	depends on PCI && WLAN_80211 && CFG80211
 	select WIRELESS_EXT
 	select FW_LOADER
 	select LIB80211
@@ -63,7 +63,7 @@ config IPW2100_DEBUG
 
 config IPW2200
 	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
-	depends on PCI && WLAN_80211
+	depends on PCI && WLAN_80211 && CFG80211
 	select WIRELESS_EXT
 	select FW_LOADER
 	select LIB80211
@@ -150,7 +150,7 @@ config IPW2200_DEBUG
 
 config LIBIPW
 	tristate
-	depends on PCI && WLAN_80211
+	depends on PCI && WLAN_80211 && CFG80211
 	select WIRELESS_EXT
 	select CRYPTO
 	select CRYPTO_ARC4
