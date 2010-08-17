Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0HQKIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 06:08:10 -0400
Subject: [PATCH] mac80211-hwsim: allow configuring IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 12:08:07 +0200
Message-ID: <1282039687.3747.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It will not look standard-compliant in a sniffer
because because it doesn't
 * sync TSF
 * adjust the TSF in beacons
 * send beacons at TBTT
 * cancel beacons when another phy sends

However, it does allow testing the configuration
and parts of the mac80211 code for IBSS and as
such is still useful.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-08-17 11:53:00.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-08-17 12:06:20.000000000 +0200
@@ -9,7 +9,8 @@
 
 /*
  * TODO:
- * - IBSS mode simulation (Beacon transmission with competition for "air time")
+ * - Add TSF sync and fix IBSS beacon transmission by adding
+ *   competition for "air time" at TBTT
  * - RX filtering based on filter configuration (data->rx_filter)
  */
 
@@ -620,7 +621,8 @@ static void mac80211_hwsim_beacon_tx(voi
 	hwsim_check_magic(vif);
 
 	if (vif->type != NL80211_IFTYPE_AP &&
-	    vif->type != NL80211_IFTYPE_MESH_POINT)
+	    vif->type != NL80211_IFTYPE_MESH_POINT &&
+	    vif->type != NL80211_IFTYPE_ADHOC)
 		return;
 
 	skb = ieee80211_beacon_get(hw, vif);
@@ -1295,6 +1297,7 @@ static int __init init_mac80211_hwsim(vo
 		hw->wiphy->interface_modes =
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_ADHOC) |
 			BIT(NL80211_IFTYPE_MESH_POINT);
 
 		hw->flags = IEEE80211_HW_MFP_CAPABLE |


