Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZDTHvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 03:51:42 -0400
Subject: [PATCH] mac80211-hwsim: allow configuring IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 09:51:35 +0200
Message-Id: <1240213895.18053.0.camel@johannes.local> (sfid-20090420_095147_326656_E43D5A70)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It will not work properly, because it doesn't
 * adjust the TSF in beacons
 * cancel beacons when another phy sends

However, it does allow testing the configuration
interfaces and as such was useful for me.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
If you prefer to not have a "broken" implementation that's
fine with me too, I don't really need this patch in now.

 drivers/net/wireless/mac80211_hwsim.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-04-19 16:39:46.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-04-19 17:26:33.000000000 +0200
@@ -9,7 +9,7 @@
 
 /*
  * TODO:
- * - IBSS mode simulation (Beacon transmission with competition for "air time")
+ * - Fix IBSS beacon transmission for "air time" competition
  * - RX filtering based on filter configuration (data->rx_filter)
  */
 
@@ -518,7 +518,8 @@ static void mac80211_hwsim_beacon_tx(voi
 	hwsim_check_magic(vif);
 
 	if (vif->type != NL80211_IFTYPE_AP &&
-	    vif->type != NL80211_IFTYPE_MESH_POINT)
+	    vif->type != NL80211_IFTYPE_MESH_POINT &&
+	    vif->type != NL80211_IFTYPE_ADHOC)
 		return;
 
 	skb = ieee80211_beacon_get(hw, vif);
@@ -932,6 +933,7 @@ static int __init init_mac80211_hwsim(vo
 		hw->wiphy->interface_modes =
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_ADHOC) |
 			BIT(NL80211_IFTYPE_MESH_POINT);
 
 		hw->flags = IEEE80211_HW_MFP_CAPABLE;


