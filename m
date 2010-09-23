Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab0IWTc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 15:32:28 -0400
Message-Id: <20100923193138.247871680@sipsolutions.net>
Date: Thu, 23 Sep 2010 21:31:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 3/3] mac80211: clean up rx handling wrt. found_sta
References: <20100923193059.805312839@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a station was found, then we'll have exited
the function already, so it is not necessary to
have a variable keeping track of it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   60 ++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-09-23 21:27:23.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-09-23 21:27:25.000000000 +0200
@@ -2656,7 +2656,6 @@ static void __ieee80211_rx_handle_packet
 	struct ieee80211_rx_data rx;
 	struct ieee80211_sub_if_data *prev;
 	struct sta_info *sta, *tmp, *prev_sta;
-	bool found_sta = false;
 	int err = 0;
 
 	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
@@ -2689,8 +2688,6 @@ static void __ieee80211_rx_handle_packet
 		prev_sta = NULL;
 
 		for_each_sta_info(local, hdr->addr2, sta, tmp) {
-			found_sta = true;
-
 			if (!prev_sta) {
 				prev_sta = sta;
 				continue;
@@ -2712,43 +2709,40 @@ static void __ieee80211_rx_handle_packet
 		}
 	}
 
-	if (!found_sta) {
-		prev = NULL;
-
-		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-			if (!ieee80211_sdata_running(sdata))
-				continue;
-
-			if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
-			    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-				continue;
-
-			/*
-			 * frame is destined for this interface, but if it's
-			 * not also for the previous one we handle that after
-			 * the loop to avoid copying the SKB once too much
-			 */
+	prev = NULL;
 
-			if (!prev) {
-				prev = sdata;
-				continue;
-			}
-
-			rx.sta = sta_info_get_bss(prev, hdr->addr2);
-			rx.sdata = prev;
-			ieee80211_prepare_and_rx_handle(&rx, skb, false);
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			continue;
+
+		/*
+		 * frame is destined for this interface, but if it's
+		 * not also for the previous one we handle that after
+		 * the loop to avoid copying the SKB once too much
+		 */
 
+		if (!prev) {
 			prev = sdata;
+			continue;
 		}
 
-		if (prev) {
-			rx.sta = sta_info_get_bss(prev, hdr->addr2);
-			rx.sdata = prev;
+		rx.sta = sta_info_get_bss(prev, hdr->addr2);
+		rx.sdata = prev;
+		ieee80211_prepare_and_rx_handle(&rx, skb, false);
 
-			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
-				return;
-		}
+		prev = sdata;
+	}
+
+	if (prev) {
+		rx.sta = sta_info_get_bss(prev, hdr->addr2);
+		rx.sdata = prev;
 
+		if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
+			return;
 	}
 
 	dev_kfree_skb(skb);


