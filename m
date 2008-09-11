Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYIKWPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 18:15:55 -0400
Subject: [PATCH] mac80211: fix build failure without mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Davide Pesavento <davidepesa@gmail.com>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 00:15:19 +0200
Message-Id: <1221171319.5956.5.camel@johannes.berg> (sfid-20080912_001558_918687_D13089F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh split-off patch introduced a build failure when
mesh isn't selected. Unfortunately, there's no way to
really fix this without adding an #ifdef, so do that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Davide Pesavento <davidepesa@gmail.com>
---
 net/mac80211/tx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-09-12 00:11:56.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-12 00:12:47.000000000 +0200
@@ -1854,10 +1854,8 @@ struct sk_buff *ieee80211_beacon_get(str
 	struct rate_selection rsel;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_mgmt *mgmt;
 	int *num_beacons;
 	enum ieee80211_band band = local->hw.conf.channel->band;
-	u8 *pos;
 
 	sband = local->hw.wiphy->bands[band];
 
@@ -1924,7 +1922,11 @@ struct sk_buff *ieee80211_beacon_get(str
 						 IEEE80211_STYPE_BEACON);
 
 		num_beacons = &ifsta->num_beacons;
+#ifdef CONFIG_MAC80211_MESH
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		struct ieee80211_mgmt *mgmt;
+		u8 *pos;
+
 		/* headroom, head length, tail length and maximum TIM length */
 		skb = dev_alloc_skb(local->tx_headroom + 400);
 		if (!skb)
@@ -1950,6 +1952,7 @@ struct sk_buff *ieee80211_beacon_get(str
 		mesh_mgmt_ies_add(skb, sdata);
 
 		num_beacons = &sdata->u.mesh.num_beacons;
+#endif
 	} else {
 		WARN_ON(1);
 		goto out;


