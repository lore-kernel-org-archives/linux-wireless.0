Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34968 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbbKROrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 09:47:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 27/27] mac80211_hwsim: move Kconfig entry for sorting alphabetically
Date: Wed, 18 Nov 2015 16:46:06 +0200
Message-Id: <1447857966-19560-28-git-send-email-kvalo@codeaurora.org> (sfid-20151118_154729_021561_466934EC)
In-Reply-To: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211_hwsim was not placed alphabetically correctly in menuconfig, fix that.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/Kconfig |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 3af6d0b9ca21..8c8edaf1bba6 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -58,6 +58,19 @@ config PCMCIA_WL3501
 	  It has basic support for Linux wireless extensions and initial
 	  micro support for ethtool.
 
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
 config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
 	depends on USB
@@ -87,17 +100,4 @@ config USB_NET_RNDIS_WLAN
 
 	  If you choose to build a module, it'll be called rndis_wlan.
 
-config MAC80211_HWSIM
-	tristate "Simulated radio testing tool for mac80211"
-	depends on MAC80211
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
 endif # WLAN
-- 
1.7.9.5

