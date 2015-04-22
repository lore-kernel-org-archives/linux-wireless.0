Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54706 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530AbbDVNZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 09:25:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: remove IEEE80211_RX_RA_MATCH
Date: Wed, 22 Apr 2015 15:25:20 +0200
Message-Id: <1429709122-13734-2-git-send-email-johannes@sipsolutions.net> (sfid-20150422_152544_342728_195B458A)
In-Reply-To: <1429709122-13734-1-git-send-email-johannes@sipsolutions.net>
References: <1429709122-13734-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With promisc support gone, only AP and P2P-Device type interfaces
still clear IEEE80211_RX_RA_MATCH. In both cases this isn't really
necessary though, so we can remove that flag and the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 ---
 net/mac80211/rx.c          | 44 +++++---------------------------------------
 2 files changed, 5 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7d12ba5a4a36..e9f36f7ec733 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -181,8 +181,6 @@ typedef unsigned __bitwise__ ieee80211_rx_result;
 
 /**
  * enum ieee80211_packet_rx_flags - packet RX flags
- * @IEEE80211_RX_RA_MATCH: frame is destined to interface currently processed
- *	(incl. multicast frames)
  * @IEEE80211_RX_FRAGMENTED: fragmented frame
  * @IEEE80211_RX_AMSDU: a-MSDU packet
  * @IEEE80211_RX_MALFORMED_ACTION_FRM: action frame is malformed
@@ -192,7 +190,6 @@ typedef unsigned __bitwise__ ieee80211_rx_result;
  * @rx_flags field of &struct ieee80211_rx_status.
  */
 enum ieee80211_packet_rx_flags {
-	IEEE80211_RX_RA_MATCH			= BIT(1),
 	IEEE80211_RX_FRAGMENTED			= BIT(2),
 	IEEE80211_RX_AMSDU			= BIT(3),
 	IEEE80211_RX_MALFORMED_ACTION_FRM	= BIT(4),
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 99fb5d80e60a..2d8c83892214 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -981,7 +981,6 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct sta_info *sta = rx->sta;
 	struct tid_ampdu_rx *tid_agg_rx;
 	u16 sc;
@@ -1016,10 +1015,6 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 	    ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)
 		goto dont_reorder;
 
-	/* not actually part of this BA session */
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-		goto dont_reorder;
-
 	/* new, potentially un-ordered, ampdu frame - process it */
 
 	/* reset session timer */
@@ -1073,10 +1068,8 @@ ieee80211_rx_h_check_dup(struct ieee80211_rx_data *rx)
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->seqno_idx] ==
 			     hdr->seq_ctrl)) {
-			if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
-				rx->local->dot11FrameDuplicateCount++;
-				rx->sta->num_duplicates++;
-			}
+			rx->local->dot11FrameDuplicateCount++;
+			rx->sta->num_duplicates++;
 			return RX_DROP_UNUSABLE;
 		} else if (!(status->flag & RX_FLAG_AMSDU_MORE)) {
 			rx->sta->last_seq_ctrl[rx->seqno_idx] = hdr->seq_ctrl;
@@ -1267,7 +1260,7 @@ ieee80211_rx_h_uapsd_and_pspoll(struct ieee80211_rx_data *rx)
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	int tid, ac;
 
-	if (!rx->sta || !(status->rx_flags & IEEE80211_RX_RA_MATCH))
+	if (!rx->sta)
 		return RX_CONTINUE;
 
 	if (sdata->vif.type != NL80211_IFTYPE_AP &&
@@ -1388,9 +1381,6 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		}
 	}
 
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-		return RX_CONTINUE;
-
 	if (rx->sdata->vif.type == NL80211_IFTYPE_STATION)
 		ieee80211_sta_rx_notify(rx->sdata, hdr);
 
@@ -1519,13 +1509,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	 * possible.
 	 */
 
-	/*
-	 * No point in finding a key and decrypting if the frame is neither
-	 * addressed to us nor a multicast frame.
-	 */
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-		return RX_CONTINUE;
-
 	/* start without a key */
 	rx->key = NULL;
 	fc = hdr->frame_control;
@@ -2056,7 +2039,6 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	struct sk_buff *skb, *xmit_skb;
 	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
 	struct sta_info *dsta;
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	dev->stats.rx_packets++;
 	dev->stats.rx_bytes += rx->skb->len;
@@ -2067,7 +2049,6 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
-	    (status->rx_flags & IEEE80211_RX_RA_MATCH) &&
 	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->u.vlan.sta)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
 			/*
@@ -2208,7 +2189,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct sk_buff *skb = rx->skb, *fwd_skb;
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u16 q, hdrlen;
 
@@ -2239,8 +2219,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    mesh_rmc_check(rx->sdata, hdr->addr3, mesh_hdr))
 		return RX_DROP_MONITOR;
 
-	if (!ieee80211_is_data(hdr->frame_control) ||
-	    !(status->rx_flags & IEEE80211_RX_RA_MATCH))
+	if (!ieee80211_is_data(hdr->frame_control))
 		return RX_CONTINUE;
 
 	if (!mesh_hdr->ttl)
@@ -2560,9 +2539,6 @@ ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
 		rx->flags |= IEEE80211_RX_BEACON_REPORTED;
 	}
 
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-		return RX_DROP_MONITOR;
-
 	if (ieee80211_drop_unencrypted_mgmt(rx))
 		return RX_DROP_UNUSABLE;
 
@@ -2590,9 +2566,6 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	    mgmt->u.action.category != WLAN_CATEGORY_SPECTRUM_MGMT)
 		return RX_DROP_UNUSABLE;
 
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-		return RX_DROP_UNUSABLE;
-
 	switch (mgmt->u.action.category) {
 	case WLAN_CATEGORY_HT:
 		/* reject HT action frames from stations not supporting HT */
@@ -3334,9 +3307,7 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 				return false;
 			if (ieee80211_is_public_action(hdr, skb->len))
 				return true;
-			if (!ieee80211_is_beacon(hdr->frame_control))
-				return false;
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+			return ieee80211_is_beacon(hdr->frame_control);
 		} else if (!ieee80211_has_tods(hdr->frame_control)) {
 			/* ignore data frames to TDLS-peers */
 			if (ieee80211_is_data(hdr->frame_control))
@@ -3359,9 +3330,6 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 		    !ieee80211_is_probe_resp(hdr->frame_control) &&
 		    !ieee80211_is_beacon(hdr->frame_control))
 			return false;
-		if (!ether_addr_equal(sdata->vif.addr, hdr->addr1) &&
-		    !multicast)
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		break;
 	default:
 		/* should never get here */
@@ -3383,11 +3351,9 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 
 	rx->skb = skb;
-	status->rx_flags |= IEEE80211_RX_RA_MATCH;
 
 	if (!prepare_for_handlers(rx, hdr))
 		return false;
-- 
2.1.4

