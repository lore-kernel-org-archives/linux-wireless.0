Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764497AbXHJWE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 18:04:26 -0400
Message-Id: <20070810220634.450509000@sipsolutions.net>
References: <20070810220544.321975000@sipsolutions.net>
Date: Sat, 11 Aug 2007 00:05:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] mac80211: remove radar stuff
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unused in drivers, userspace and mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h          |    6 ------
 net/mac80211/ieee80211.c        |   28 ----------------------------
 net/mac80211/ieee80211_common.h |    2 +-
 3 files changed, 1 insertion(+), 35 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-10 23:55:56.363840246 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-11 00:02:16.053840246 +0200
@@ -1038,12 +1038,6 @@ ieee80211_get_mc_list_item(struct ieee80
 /* called by driver to notify scan status completed */
 void ieee80211_scan_completed(struct ieee80211_hw *hw);
 
-/* Function to indicate Radar Detection. The low level driver must call this
- * function to indicate the presence of radar in the current channel.
- * Additionally the radar type also could be sent */
-int  ieee80211_radar_status(struct ieee80211_hw *hw, int channel,
-			    int radar, int radar_type);
-
 /* return a pointer to the source address (SA) */
 static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
 {
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-11 00:01:44.943840246 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-11 00:02:29.073840246 +0200
@@ -201,34 +201,6 @@ ieee80211_rx_mgmt(struct ieee80211_local
 	netif_rx(skb);
 }
 
-int ieee80211_radar_status(struct ieee80211_hw *hw, int channel,
-			   int radar, int radar_type)
-{
-	struct sk_buff *skb;
-	struct ieee80211_radar_info *msg;
-	struct ieee80211_local *local = hw_to_local(hw);
-
-	if (!local->apdev)
-		return 0;
-
-	skb = dev_alloc_skb(sizeof(struct ieee80211_frame_info) +
-			    sizeof(struct ieee80211_radar_info));
-
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, sizeof(struct ieee80211_frame_info));
-
-	msg = (struct ieee80211_radar_info *)
-		skb_put(skb, sizeof(struct ieee80211_radar_info));
-	msg->channel = channel;
-	msg->radar = radar;
-	msg->radar_type = radar_type;
-
-	ieee80211_rx_mgmt(local, skb, NULL, ieee80211_msg_radar);
-	return 0;
-}
-EXPORT_SYMBOL(ieee80211_radar_status);
-
 void ieee80211_key_threshold_notify(struct net_device *dev,
 				    struct ieee80211_key *key,
 				    struct sta_info *sta)
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-11 00:01:44.943840246 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-11 00:02:16.063840246 +0200
@@ -54,7 +54,7 @@ enum ieee80211_msg_type {
 	/* hole at 7, was ieee80211_msg_sta_not_assoc but now unused */
 	/* 8 was ieee80211_msg_set_aid_for_sta */
 	/* hole at 9, was ieee80211_msg_key_threshold_notification */
-	ieee80211_msg_radar = 11,
+	/* 11 was ieee80211_msg_radar */
 };
 
 struct ieee80211_msg_key_notification {

-- 

