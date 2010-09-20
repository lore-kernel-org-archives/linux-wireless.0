Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57457 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab0ITRwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 13:52:49 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [mac80211] mac80211:  Support receiving data frames on multiple vifs.
Date: Mon, 20 Sep 2010 10:52:43 -0700
Message-Id: <1285005163-4569-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When using multiple STA interfaces on the same radio, some
data packets need to be received on all interfaces
(broadcast, for instance).

Remove special loop for data-only packets and just process all
packets in the big loop that previously only handled non-data
packets.

This needs review.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c036815... 63baa04... M	net/mac80211/rx.c
 net/mac80211/rx.c |  121 ++++++++++++++++++++++-------------------------------
 1 files changed, 50 insertions(+), 71 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c036815..63baa04 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2613,8 +2613,6 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	int prepares;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
-	struct sta_info *sta, *tmp;
-	bool found_sta = false;
 	int err = 0;
 
 	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
@@ -2643,87 +2641,68 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	ieee80211_parse_qos(&rx);
 	ieee80211_verify_alignment(&rx);
 
-	if (ieee80211_is_data(fc)) {
-		for_each_sta_info(local, hdr->addr2, sta, tmp) {
-			rx.sta = sta;
-			found_sta = true;
-			rx.sdata = sta->sdata;
-
-			rx.flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
-			if (prepares) {
-				if (status->flag & RX_FLAG_MMIC_ERROR) {
-					if (rx.flags & IEEE80211_RX_RA_MATCH)
-						ieee80211_rx_michael_mic_report(hdr, &rx);
-				} else
-					prev = rx.sdata;
-			}
-		}
-	}
-	if (!found_sta) {
-		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-			if (!ieee80211_sdata_running(sdata))
-				continue;
-
-			if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
-			    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-				continue;
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
 
-			/*
-			 * frame is destined for this interface, but if it's
-			 * not also for the previous one we handle that after
-			 * the loop to avoid copying the SKB once too much
-			 */
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			continue;
 
-			if (!prev) {
-				prev = sdata;
-				continue;
-			}
+		/*
+		 * frame is destined for this interface, but if it's
+		 * not also for the previous one we handle that after
+		 * the loop to avoid copying the SKB once too much
+		 */
 
-			rx.sta = sta_info_get_bss(prev, hdr->addr2);
+		if (!prev) {
+			prev = sdata;
+			continue;
+		}
 
-			rx.flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(prev, &rx, hdr);
+		rx.sta = sta_info_get_bss(prev, hdr->addr2);
+		rx.sdata = prev;
+		rx.flags |= IEEE80211_RX_RA_MATCH;
+		prepares = prepare_for_handlers(prev, &rx, hdr);
 
-			if (!prepares)
-				goto next;
+		if (!prepares)
+			goto next;
 
-			if (status->flag & RX_FLAG_MMIC_ERROR) {
-				rx.sdata = prev;
-				if (rx.flags & IEEE80211_RX_RA_MATCH)
-					ieee80211_rx_michael_mic_report(hdr,
-									&rx);
-				goto next;
-			}
+		if (status->flag & RX_FLAG_MMIC_ERROR) {
+			rx.sdata = prev;
+			if (rx.flags & IEEE80211_RX_RA_MATCH)
+				ieee80211_rx_michael_mic_report(hdr, &rx);
+			goto next;
+		}
 
-			/*
-			 * frame was destined for the previous interface
-			 * so invoke RX handlers for it
-			 */
+		/*
+		 * frame was destined for the previous interface
+		 * so invoke RX handlers for it
+		 */
 
-			skb_new = skb_copy(skb, GFP_ATOMIC);
-			if (!skb_new) {
-				if (net_ratelimit())
-					wiphy_debug(local->hw.wiphy,
-						    "failed to copy multicast frame for %s\n",
-						    prev->name);
-				goto next;
-			}
-			ieee80211_invoke_rx_handlers(prev, &rx, skb_new);
-next:
-			prev = sdata;
+		skb_new = skb_copy(skb, GFP_ATOMIC);
+		if (!skb_new) {
+			if (net_ratelimit())
+				wiphy_debug(local->hw.wiphy,
+					    "failed to copy multicast frame for %s\n",
+					    prev->name);
+			goto next;
 		}
+		ieee80211_invoke_rx_handlers(prev, &rx, skb_new);
+next:
+		prev = sdata;
+	} /* for all interfaces */
 
-		if (prev) {
-			rx.sta = sta_info_get_bss(prev, hdr->addr2);
-
-			rx.flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(prev, &rx, hdr);
+	if (prev) {
+		rx.sta = sta_info_get_bss(prev, hdr->addr2);
+		rx.sdata = prev;
+		rx.flags |= IEEE80211_RX_RA_MATCH;
+		prepares = prepare_for_handlers(prev, &rx, hdr);
 
-			if (!prepares)
-				prev = NULL;
-		}
+		if (!prepares)
+			prev = NULL;
 	}
+
 	if (prev)
 		ieee80211_invoke_rx_handlers(prev, &rx, skb);
 	else
-- 
1.7.2.2

