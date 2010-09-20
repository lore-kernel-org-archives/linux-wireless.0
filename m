Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45832 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0ITVjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 17:39:40 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [mac80211] mac80211:  Support receiving data frames on multiple vifs.
Date: Mon, 20 Sep 2010 14:39:36 -0700
Message-Id: <1285018776-21795-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When using multiple STA interfaces on the same radio, some
data packets need to be received on all interfaces
(broadcast, for instance).

Make the STA loop look similar to the mgt-data loop.

Also, add logic to check RX_FLAG_MMIC_ERROR for last
interface in mgt-data loop.

This needs review.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c036815... a7847e1... M	net/mac80211/rx.c
 net/mac80211/rx.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c036815..a7847e1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2613,7 +2613,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	int prepares;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
-	struct sta_info *sta, *tmp;
+	struct sta_info *sta, *tmp, *prev_sta;
 	bool found_sta = false;
 	int err = 0;
 
@@ -2644,22 +2644,74 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	ieee80211_verify_alignment(&rx);
 
 	if (ieee80211_is_data(fc)) {
+		prev_sta = NULL;
 		for_each_sta_info(local, hdr->addr2, sta, tmp) {
-			rx.sta = sta;
 			found_sta = true;
-			rx.sdata = sta->sdata;
+			if (!prev_sta) {
+				prev_sta = sta;
+				continue;
+			}
+
+			rx.sta = prev_sta;
+			rx.sdata = prev_sta->sdata;
 
 			rx.flags |= IEEE80211_RX_RA_MATCH;
 			prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
-			if (prepares) {
-				if (status->flag & RX_FLAG_MMIC_ERROR) {
-					if (rx.flags & IEEE80211_RX_RA_MATCH)
-						ieee80211_rx_michael_mic_report(hdr, &rx);
-				} else
-					prev = rx.sdata;
+			if (!prepares)
+				goto next_sta;
+
+			if (status->flag & RX_FLAG_MMIC_ERROR) {
+				if (rx.flags & IEEE80211_RX_RA_MATCH)
+					ieee80211_rx_michael_mic_report(hdr, &rx);
+				goto next_sta;
+			}
+
+			/*
+			 * frame was destined for the previous interface
+			 * so invoke RX handlers for it
+			 */
+			skb_new = skb_copy(skb, GFP_ATOMIC);
+			if (!skb_new) {
+				if (net_ratelimit())
+					wiphy_debug(local->hw.wiphy,
+						    "failed to copy multicast"
+						    " frame for %s\n",
+						    prev_sta->sdata->name);
+				goto next_sta;
+			}
+			ieee80211_invoke_rx_handlers(prev_sta->sdata, &rx,
+						     skb_new);
+next_sta:
+			prev_sta = sta;
+		} /* for all STA info */
+
+		if (prev_sta) {
+			rx.sta = prev_sta;
+			rx.sdata = prev_sta->sdata;
+
+			rx.flags |= IEEE80211_RX_RA_MATCH;
+			prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
+			if (!prepares)
+				prev_sta = NULL;
+
+			if (status->flag & RX_FLAG_MMIC_ERROR) {
+				if (rx.flags & IEEE80211_RX_RA_MATCH)
+					ieee80211_rx_michael_mic_report(hdr, &rx);
+				prev_sta = NULL;
 			}
 		}
-	}
+
+
+		if (prev_sta) {
+			ieee80211_invoke_rx_handlers(prev_sta->sdata, &rx, skb);
+			return;
+		} else {
+			if (found_sta) {
+				dev_kfree_skb(skb);
+				return;
+			}
+		}
+	} /* if data frame */
 	if (!found_sta) {
 		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 			if (!ieee80211_sdata_running(sdata))
@@ -2722,6 +2774,14 @@ next:
 
 			if (!prepares)
 				prev = NULL;
+
+			if (status->flag & RX_FLAG_MMIC_ERROR) {
+				rx.sdata = prev;
+				if (rx.flags & IEEE80211_RX_RA_MATCH)
+					ieee80211_rx_michael_mic_report(hdr,
+									&rx);
+				prev = NULL;
+			}
 		}
 	}
 	if (prev)
-- 
1.7.2.2

