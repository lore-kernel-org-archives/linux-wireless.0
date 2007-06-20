Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbXFUKoZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 06:44:25 -0400
Subject: [PATCH] mac80211: remove ieee80211_set_aid_for_sta
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 00:17:07 +0200
Message-Id: <1182377827.3714.111.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove ieee80211_set_aid_for_sta and associated code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h          |    6 ------
 net/mac80211/ieee80211.c        |   28 ----------------------------
 net/mac80211/ieee80211_common.h |    7 +------
 3 files changed, 1 insertion(+), 40 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-06-20 19:23:47.487345639 +0200
+++ wireless-dev/include/net/mac80211.h	2007-06-20 19:23:57.597345639 +0200
@@ -944,12 +944,6 @@ struct sk_buff *
 ieee80211_get_buffered_bc(struct ieee80211_hw *hw, int if_id,
 			  struct ieee80211_tx_control *control);
 
-/* Low level drivers that have their own MLME and MAC indicate
- * the aid for an associating station with this call */
-int ieee80211_set_aid_for_sta(struct ieee80211_hw *hw,
-			      u8 *peer_address, u16 aid);
-
-
 /* Given an sk_buff with a raw 802.11 header at the data pointer this function
  * returns the 802.11 header length in bytes (not including encryption
  * headers). If the data in the sk_buff is too short to contain a valid 802.11
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-20 19:24:58.437345639 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-20 19:25:03.617345639 +0200
@@ -3075,34 +3075,6 @@ int ieee80211_radar_status(struct ieee80
 }
 EXPORT_SYMBOL(ieee80211_radar_status);
 
-int ieee80211_set_aid_for_sta(struct ieee80211_hw *hw, u8 *peer_address,
-			      u16 aid)
-{
-	struct sk_buff *skb;
-	struct ieee80211_msg_set_aid_for_sta *msg;
-	struct ieee80211_local *local = hw_to_local(hw);
-
-	/* unlikely because if this event only happens for APs,
-	 * which require an open ap device. */
-	if (unlikely(!local->apdev))
-		return 0;
-
-	skb = dev_alloc_skb(sizeof(struct ieee80211_frame_info) +
-			    sizeof(struct ieee80211_msg_set_aid_for_sta));
-
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, sizeof(struct ieee80211_frame_info));
-
-	msg = (struct ieee80211_msg_set_aid_for_sta *)
-		skb_put(skb, sizeof(struct ieee80211_msg_set_aid_for_sta));
-	memcpy(msg->sta_address, peer_address, ETH_ALEN);
-	msg->aid = aid;
-
-	ieee80211_rx_mgmt(local, skb, NULL, ieee80211_msg_set_aid_for_sta);
-	return 0;
-}
-EXPORT_SYMBOL(ieee80211_set_aid_for_sta);
 
 static void ap_sta_ps_start(struct net_device *dev, struct sta_info *sta)
 {
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-06-20 19:25:13.867345639 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-06-20 19:28:11.387345639 +0200
@@ -52,16 +52,11 @@ enum ieee80211_msg_type {
 	ieee80211_msg_michael_mic_failure = 5,
 	/* hole at 6, was monitor but never sent to userspace */
 	ieee80211_msg_sta_not_assoc = 7,
-	ieee80211_msg_set_aid_for_sta = 8 /* used by Intersil MVC driver */,
+	/* 8 was ieee80211_msg_set_aid_for_sta */
 	ieee80211_msg_key_threshold_notification = 9,
 	ieee80211_msg_radar = 11,
 };
 
-struct ieee80211_msg_set_aid_for_sta {
-	char	sta_address[ETH_ALEN];
-	u16	aid;
-};
-
 struct ieee80211_msg_key_notification {
 	int tx_rx_count;
 	char ifname[IFNAMSIZ];


