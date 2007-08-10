Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbXHJVj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 17:39:59 -0400
Subject: [PATCH] mac80211: remove ieee80211_msg_key_threshold_notification
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 23:42:29 +0200
Message-Id: <1186782149.17351.17.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hostapd doesn't care at the moment.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-10 23:39:49.903840246 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-10 23:40:52.453840246 +0200
@@ -226,35 +226,8 @@ static void ieee80211_key_threshold_noti
 					   struct ieee80211_key *key,
 					   struct sta_info *sta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sk_buff *skb;
-	struct ieee80211_msg_key_notification *msg;
-
-	/* if no one will get it anyway, don't even allocate it.
-	 * unlikely because this is only relevant for APs
-	 * where the device must be open... */
-	if (unlikely(!local->apdev))
-		return;
-
-	skb = dev_alloc_skb(sizeof(struct ieee80211_frame_info) +
-			    sizeof(struct ieee80211_msg_key_notification));
-	if (!skb)
-		return;
-
-	skb_reserve(skb, sizeof(struct ieee80211_frame_info));
-	msg = (struct ieee80211_msg_key_notification *)
-		skb_put(skb, sizeof(struct ieee80211_msg_key_notification));
-	msg->tx_rx_count = key->tx_rx_count;
-	memcpy(msg->ifname, dev->name, IFNAMSIZ);
-	if (sta)
-		memcpy(msg->addr, sta->addr, ETH_ALEN);
-	else
-		memset(msg->addr, 0xff, ETH_ALEN);
-
-	key->tx_rx_count = 0;
-
-	ieee80211_rx_mgmt(local, skb, NULL,
-			  ieee80211_msg_key_threshold_notification);
+	/* dummy function for when we add back support */
+	/* TODO: add back support via cfg80211/nl80211 */
 }
 
 
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-10 23:39:28.643840246 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-10 23:39:40.913840246 +0200
@@ -53,7 +53,7 @@ enum ieee80211_msg_type {
 	/* hole at 6, was monitor but never sent to userspace */
 	/* hole at 7, was ieee80211_msg_sta_not_assoc but now unused */
 	/* 8 was ieee80211_msg_set_aid_for_sta */
-	ieee80211_msg_key_threshold_notification = 9,
+	/* hole at 9, was ieee80211_msg_key_threshold_notification */
 	ieee80211_msg_radar = 11,
 };
 


