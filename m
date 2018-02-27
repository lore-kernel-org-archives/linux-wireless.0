Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33592 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750945AbeB0HwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 02:52:25 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: support A-MSDU in fast-rx
Date: Tue, 27 Feb 2018 08:52:19 +0100
Message-Id: <20180227075219.2049-1-nbd@nbd.name> (sfid-20180227_085228_817343_32D58028)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only works if the IV was stripped from packets. Create a smaller
variant of ieee80211_rx_h_amsdu, which bypasses checks already done
within the fast-rx context.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rx.c | 122 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 73 insertions(+), 49 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5be957af4b0e..5ae1414ca550 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2353,39 +2353,17 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
+__ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->sdata->dev;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
 	struct sk_buff_head frame_list;
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	struct ethhdr ethhdr;
 	const u8 *check_da = ethhdr.h_dest, *check_sa = ethhdr.h_source;
 
-	if (unlikely(!ieee80211_is_data(fc)))
-		return RX_CONTINUE;
-
-	if (unlikely(!ieee80211_is_data_present(fc)))
-		return RX_DROP_MONITOR;
-
-	if (!(status->rx_flags & IEEE80211_RX_AMSDU))
-		return RX_CONTINUE;
-
 	if (unlikely(ieee80211_has_a4(hdr->frame_control))) {
-		switch (rx->sdata->vif.type) {
-		case NL80211_IFTYPE_AP_VLAN:
-			if (!rx->sdata->u.vlan.sta)
-				return RX_DROP_UNUSABLE;
-			break;
-		case NL80211_IFTYPE_STATION:
-			if (!rx->sdata->u.mgd.use_4addr)
-				return RX_DROP_UNUSABLE;
-			break;
-		default:
-			return RX_DROP_UNUSABLE;
-		}
 		check_da = NULL;
 		check_sa = NULL;
 	} else switch (rx->sdata->vif.type) {
@@ -2405,9 +2383,6 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 			break;
 	}
 
-	if (is_multicast_ether_addr(hdr->addr1))
-		return RX_DROP_UNUSABLE;
-
 	skb->dev = dev;
 	__skb_queue_head_init(&frame_list);
 
@@ -2435,6 +2410,44 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 }
 
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
+{
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	__le16 fc = hdr->frame_control;
+
+	if (!(status->rx_flags & IEEE80211_RX_AMSDU))
+		return RX_CONTINUE;
+
+	if (unlikely(!ieee80211_is_data(fc)))
+		return RX_CONTINUE;
+
+	if (unlikely(!ieee80211_is_data_present(fc)))
+		return RX_DROP_MONITOR;
+
+	if (unlikely(ieee80211_has_a4(hdr->frame_control))) {
+		switch (rx->sdata->vif.type) {
+		case NL80211_IFTYPE_AP_VLAN:
+			if (!rx->sdata->u.vlan.sta)
+				return RX_DROP_UNUSABLE;
+			break;
+		case NL80211_IFTYPE_STATION:
+			if (!rx->sdata->u.mgd.use_4addr)
+				return RX_DROP_UNUSABLE;
+			break;
+		default:
+			return RX_DROP_UNUSABLE;
+		}
+	}
+
+	if (is_multicast_ether_addr(hdr->addr1))
+		return RX_DROP_UNUSABLE;
+
+	return __ieee80211_rx_h_amsdu(rx);
+}
+
 #ifdef CONFIG_MAC80211_MESH
 static ieee80211_rx_result
 ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
@@ -3908,6 +3921,7 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 		u8 sa[ETH_ALEN];
 	} addrs __aligned(2);
 	struct ieee80211_sta_rx_stats *stats = &sta->rx_stats;
+	int res;
 
 	if (fast_rx->uses_rss)
 		stats = this_cpu_ptr(sta->pcpu_rx_stats);
@@ -3929,10 +3943,6 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	    (status->flag & FAST_RX_CRYPT_FLAGS) != FAST_RX_CRYPT_FLAGS)
 		return false;
 
-	/* we don't deal with A-MSDU deaggregation here */
-	if (status->rx_flags & IEEE80211_RX_AMSDU)
-		return false;
-
 	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
 		return false;
 
@@ -3960,25 +3970,31 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	 * and strip the IV/MIC if necessary
 	 */
 	if (fast_rx->key && !(status->flag & RX_FLAG_IV_STRIPPED)) {
+		if (status->rx_flags & IEEE80211_RX_AMSDU)
+			return false;
+
 		/* GCMP header length is the same */
 		snap_offs += IEEE80211_CCMP_HDR_LEN;
 	}
 
-	if (!pskb_may_pull(skb, snap_offs + sizeof(*payload)))
-		goto drop;
-	payload = (void *)(skb->data + snap_offs);
+	if (!(status->rx_flags & IEEE80211_RX_AMSDU)) {
+		if (!pskb_may_pull(skb, snap_offs + sizeof(*payload)))
+			goto drop;
 
-	if (!ether_addr_equal(payload->snap, fast_rx->rfc1042_hdr))
-		return false;
+		payload = (void *)(skb->data + snap_offs);
 
-	/* Don't handle these here since they require special code.
-	 * Accept AARP and IPX even though they should come with a
-	 * bridge-tunnel header - but if we get them this way then
-	 * there's little point in discarding them.
-	 */
-	if (unlikely(payload->proto == cpu_to_be16(ETH_P_TDLS) ||
-		     payload->proto == fast_rx->control_port_protocol))
-		return false;
+		if (!ether_addr_equal(payload->snap, fast_rx->rfc1042_hdr))
+			return false;
+
+		/* Don't handle these here since they require special code.
+		 * Accept AARP and IPX even though they should come with a
+		 * bridge-tunnel header - but if we get them this way then
+		 * there's little point in discarding them.
+		 */
+		if (unlikely(payload->proto == cpu_to_be16(ETH_P_TDLS) ||
+			     payload->proto == fast_rx->control_port_protocol))
+			return false;
+	}
 
 	/* after this point, don't punt to the slowpath! */
 
@@ -3992,12 +4008,6 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	}
 
 	/* statistics part of ieee80211_rx_h_sta_process() */
-	stats->last_rx = jiffies;
-	stats->last_rate = sta_stats_encode_rate(status);
-
-	stats->fragments++;
-	stats->packets++;
-
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		stats->last_signal = status->signal;
 		if (!fast_rx->uses_rss)
@@ -4026,6 +4036,20 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	if (rx->key && !ieee80211_has_protected(hdr->frame_control))
 		goto drop;
 
+	if (status->rx_flags & IEEE80211_RX_AMSDU) {
+		res = __ieee80211_rx_h_amsdu(rx);
+		if (res != RX_QUEUED)
+			goto drop;
+
+		return true;
+	}
+
+	stats->last_rx = jiffies;
+	stats->last_rate = sta_stats_encode_rate(status);
+
+	stats->fragments++;
+	stats->packets++;
+
 	/* do the header conversion - first grab the addresses */
 	ether_addr_copy(addrs.da, skb->data + fast_rx->da_offs);
 	ether_addr_copy(addrs.sa, skb->data + fast_rx->sa_offs);
-- 
2.14.2
