Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53127 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747AbZHQR1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"Johannes Berg\"" <johannes@sipsolutions.net>
Subject: [PATCH v5 18/33] wireless: move mac80211_hwsim to top level wireless driver menu
Date: Mon, 17 Aug 2009 13:27:17 -0400
Message-Id: <1250530052-14783-19-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211_hwsim is not a device driver for real hardware it is a
driver we can use to simulate a real device for testing mac80211.
Move it to the top wireless driver menu by removing its dependency
on WLAN_80211.

While at it move it outside of the WLAN_80211 section as we'll
be touching all those later.

Cc: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg" <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index f9f2b67..e57c62d 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -558,19 +558,6 @@ config ADM8211
 
 	  Thanks to Infineon-ADMtek for their support of this driver.
 
-config MAC80211_HWSIM
-	tristate "Simulated radio testing tool for mac80211"
-	depends on MAC80211 && WLAN_80211
-	---help---
-	  This driver is a developer testing tool that can be used to test
-	  IEEE 802.11 networking stack (mac80211) functionality. This is not
-	  needed for normal wireless LAN usage and is only for testing. See
-	  Documentation/networking/mac80211_hwsim for more information on how
-	  to use this tool.
-
-	  To compile this driver as a module, choose M here: the module will be
-	  called mac80211_hwsim.  If unsure, say N.
-
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 
@@ -606,4 +593,17 @@ config USB_NET_RNDIS_WLAN
 
 	  If you choose to build a module, it'll be called rndis_wlan.
 
+config MAC80211_HWSIM
+	tristate "Simulated radio testing tool for mac80211"
+	depends on MAC80211
+	---help---
+	  This driver is a developer testing tool that can be used to test
+	  IEEE 802.11 networking stack (mac80211) functionality. This is not
+	  needed for normal wireless LAN usage and is only for testing. See
+	  Documentation/networking/mac80211_hwsim for more information on how
+	  to use this tool.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called mac80211_hwsim.  If unsure, say N.
+
 endmenu
-- 
1.6.2.5

