Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39088 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934636AbdAIKJs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 05:09:48 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: implement multicast forwarding on fast-RX path
Date: Mon,  9 Jan 2017 11:09:32 +0100
Message-Id: <20170109100932.23778-1-johannes@sipsolutions.net> (sfid-20170109_111113_727752_484E7E1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In AP (or VLAN) mode, when unicast 802.11 packets are received,
they might actually be multicast after conversion. In this case
the fast-RX path didn't handle them properly to send them back
to the wireless medium. Implement that by copying the SKB and
sending it back out.

The possible alternative would be to just punt the packet back
to the regular (slow) RX path, but since we have almost all of
the required code here already it's not so complicated to add
here. Punting it back would also mean acquiring the spinlock,
which would be bad for the stated purpose of the fast-RX path,
to enable well-performing parallel RX.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d2a00f2a6efe..ff32050c389d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3938,21 +3938,31 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	u64_stats_update_end(&stats->syncp);
 
 	if (fast_rx->internal_forward) {
-		struct sta_info *dsta = sta_info_get(rx->sdata, skb->data);
+		struct sk_buff *xmit_skb = NULL;
+		bool multicast = is_multicast_ether_addr(skb->data);
 
-		if (dsta) {
+		if (multicast) {
+			xmit_skb = skb_copy(skb, GFP_ATOMIC);
+		} else if (sta_info_get(rx->sdata, skb->data)) {
+			xmit_skb = skb;
+			skb = NULL;
+		}
+
+		if (xmit_skb) {
 			/*
 			 * Send to wireless media and increase priority by 256
 			 * to keep the received priority instead of
 			 * reclassifying the frame (see cfg80211_classify8021d).
 			 */
-			skb->priority += 256;
-			skb->protocol = htons(ETH_P_802_3);
-			skb_reset_network_header(skb);
-			skb_reset_mac_header(skb);
-			dev_queue_xmit(skb);
-			return true;
+			xmit_skb->priority += 256;
+			xmit_skb->protocol = htons(ETH_P_802_3);
+			skb_reset_network_header(xmit_skb);
+			skb_reset_mac_header(xmit_skb);
+			dev_queue_xmit(xmit_skb);
 		}
+
+		if (!skb)
+			return true;
 	}
 
 	/* deliver to local stack */
-- 
2.9.3
