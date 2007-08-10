Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbXHJVp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 17:45:57 -0400
Subject: [PATCH] mac80211: remove radar stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 23:48:33 +0200
Message-Id: <1186782513.17351.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unused in drivers, userspace and mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-dev.orig/include/net/mac80211.h	2007-08-10 23:46:55.283840246 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-10 23:47:01.203840246 +0200
@@ -1032,12 +1032,6 @@ ieee80211_get_mc_list_item(struct ieee80
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
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-10 23:46:13.313840246 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-10 23:47:11.393840246 +0200
@@ -3305,34 +3305,6 @@ ieee80211_rx_monitor(struct net_device *
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
 
 static void ap_sta_ps_start(struct net_device *dev, struct sta_info *sta)
 {
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-10 23:46:00.563840246 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-10 23:46:06.323840246 +0200
@@ -54,7 +54,7 @@ enum ieee80211_msg_type {
 	/* hole at 7, was ieee80211_msg_sta_not_assoc but now unused */
 	/* 8 was ieee80211_msg_set_aid_for_sta */
 	/* hole at 9, was ieee80211_msg_key_threshold_notification */
-	ieee80211_msg_radar = 11,
+	/* 11 was ieee80211_msg_radar */
 };
 
 struct ieee80211_msg_key_notification {


