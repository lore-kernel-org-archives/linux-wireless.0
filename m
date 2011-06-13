Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:34774 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1FMWgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:36:22 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh04-2.mail.saunalahti.fi (Postfix) with SMTP id C771E13BB01
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:20 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 928DB158A62
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:19 +0300 (EEST)
Subject: [PATCH v2 11/27] mac80211: rename ieee80211_packet_rx_flags to
	mac80211_packet_rx_flags
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:36:09 +0300
Message-ID: <20110613223609.10517.42930.stgit@localhost6.localdomain6> (sfid-20110614_005723_645337_91BFF79B)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |   30 +++++++++++++------------
 net/mac80211/rx.c         |   54 +++++++++++++++++++++++----------------------
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 7def6bf..821d432 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -161,31 +161,31 @@ typedef unsigned __bitwise__ ieee80211_rx_result;
 #define RX_QUEUED		((__force ieee80211_rx_result) 3u)
 
 /**
- * enum ieee80211_packet_rx_flags - packet RX flags
- * @IEEE80211_RX_RA_MATCH: frame is destined to interface currently processed
+ * enum mac80211_packet_rx_flags - packet RX flags
+ * @MAC80211_RX_RA_MATCH: frame is destined to interface currently processed
  *	(incl. multicast frames)
- * @IEEE80211_RX_IN_SCAN: received while scanning
- * @IEEE80211_RX_FRAGMENTED: fragmented frame
- * @IEEE80211_RX_AMSDU: a-MSDU packet
- * @IEEE80211_RX_MALFORMED_ACTION_FRM: action frame is malformed
- * @IEEE80211_RX_DEFERRED_RELEASE: frame was subjected to receive reordering
+ * @MAC80211_RX_IN_SCAN: received while scanning
+ * @MAC80211_RX_FRAGMENTED: fragmented frame
+ * @MAC80211_RX_AMSDU: a-MSDU packet
+ * @MAC80211_RX_MALFORMED_ACTION_FRM: action frame is malformed
+ * @MAC80211_RX_DEFERRED_RELEASE: frame was subjected to receive reordering
  *
  * These are per-frame flags that are attached to a frame in the
  * @rx_flags field of &struct ieee80211_rx_status.
  */
-enum ieee80211_packet_rx_flags {
-	IEEE80211_RX_IN_SCAN			= BIT(0),
-	IEEE80211_RX_RA_MATCH			= BIT(1),
-	IEEE80211_RX_FRAGMENTED			= BIT(2),
-	IEEE80211_RX_AMSDU			= BIT(3),
-	IEEE80211_RX_MALFORMED_ACTION_FRM	= BIT(4),
-	IEEE80211_RX_DEFERRED_RELEASE		= BIT(5),
+enum mac80211_packet_rx_flags {
+	MAC80211_RX_IN_SCAN			= BIT(0),
+	MAC80211_RX_RA_MATCH			= BIT(1),
+	MAC80211_RX_FRAGMENTED			= BIT(2),
+	MAC80211_RX_AMSDU			= BIT(3),
+	MAC80211_RX_MALFORMED_ACTION_FRM	= BIT(4),
+	MAC80211_RX_DEFERRED_RELEASE		= BIT(5),
 };
 
 /**
  * enum ieee80211_rx_flags - RX data flags
  *
- * @IEEE80211_RX_CMNTR: received on cooked monitor already
+ * @MAC80211_RX_CMNTR: received on cooked monitor already
  *
  * These flags are used across handling multiple interfaces
  * for a single frame.
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d49fa8b..12086b4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -339,7 +339,7 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 		/* frame has qos control */
 		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 		if (*qc & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
-			status->rx_flags |= IEEE80211_RX_AMSDU;
+			status->rx_flags |= MAC80211_RX_AMSDU;
 	} else {
 		/*
 		 * IEEE 802.11-2007, 7.1.3.4.1 ("Sequence Number field"):
@@ -404,7 +404,7 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	struct sk_buff *skb = rx->skb;
 
-	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
+	if (likely(!(status->rx_flags & MAC80211_RX_IN_SCAN) &&
 		   !local->sched_scanning))
 		return RX_CONTINUE;
 
@@ -563,7 +563,7 @@ static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
 	status = IEEE80211_SKB_RXCB(skb);
-	status->rx_flags |= IEEE80211_RX_DEFERRED_RELEASE;
+	status->rx_flags |= MAC80211_RX_DEFERRED_RELEASE;
 	skb_queue_tail(&local->rx_skb_queue, skb);
 
 no_frame:
@@ -812,7 +812,7 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->queue] ==
 			     hdr->seq_ctrl)) {
-			if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
+			if (status->rx_flags & MAC80211_RX_RA_MATCH) {
 				rx->local->dot11FrameDuplicateCount++;
 				rx->sta->num_duplicates++;
 			}
@@ -893,7 +893,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	 * No point in finding a key and decrypting if the frame is neither
 	 * addressed to us nor a multicast frame.
 	 */
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
+	if (!(status->rx_flags & MAC80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	/* start without a key */
@@ -1185,7 +1185,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		}
 	}
 
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
+	if (!(status->rx_flags & MAC80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	if (rx->sdata->vif.type == NL80211_IFTYPE_STATION)
@@ -1202,7 +1202,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	 */
 	if (!(sta->local->hw.flags & IEEE80211_HW_AP_LINK_PS) &&
 	    !ieee80211_has_morefrags(hdr->frame_control) &&
-	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
+	    !(status->rx_flags & MAC80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
 		if (test_sta_flags(sta, WLAN_STA_PS_STA)) {
@@ -1446,7 +1446,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
 	/* Complete frame has been reassembled - process it now */
 	status = IEEE80211_SKB_RXCB(rx->skb);
-	status->rx_flags |= IEEE80211_RX_FRAGMENTED;
+	status->rx_flags |= MAC80211_RX_FRAGMENTED;
 
  out:
 	if (rx->sta)
@@ -1466,7 +1466,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	if (likely(!rx->sta || !ieee80211_is_pspoll(fc) ||
-		   !(status->rx_flags & IEEE80211_RX_RA_MATCH)))
+		   !(status->rx_flags & MAC80211_RX_RA_MATCH)))
 		return RX_CONTINUE;
 
 	if ((sdata->vif.type != NL80211_IFTYPE_AP) &&
@@ -1675,7 +1675,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
-	    (status->rx_flags & IEEE80211_RX_RA_MATCH) &&
+	    (status->rx_flags & MAC80211_RX_RA_MATCH) &&
 	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->u.vlan.sta)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
 			/*
@@ -1760,7 +1760,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	if (unlikely(!ieee80211_is_data_present(fc)))
 		return RX_DROP_MONITOR;
 
-	if (!(status->rx_flags & IEEE80211_RX_AMSDU))
+	if (!(status->rx_flags & MAC80211_RX_AMSDU))
 		return RX_CONTINUE;
 
 	if (ieee80211_has_a4(hdr->frame_control) &&
@@ -1857,7 +1857,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 
 	mesh_hdr->ttl--;
 
-	if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
+	if (status->rx_flags & MAC80211_RX_RA_MATCH) {
 		if (!mesh_hdr->ttl)
 			IEEE80211_IFSTA_MESH_CTR_INC(&rx->sdata->u.mesh,
 						     dropped_frames_ttl);
@@ -2096,7 +2096,7 @@ ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
 	if (!ieee80211_is_mgmt(mgmt->frame_control))
 		return RX_DROP_MONITOR;
 
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
+	if (!(status->rx_flags & MAC80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
 	if (ieee80211_drop_unencrypted_mgmt(rx))
@@ -2124,7 +2124,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
 		return RX_DROP_UNUSABLE;
 
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
+	if (!(status->rx_flags & MAC80211_RX_RA_MATCH))
 		return RX_DROP_UNUSABLE;
 
 	switch (mgmt->u.action.category) {
@@ -2223,7 +2223,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 
  invalid:
-	status->rx_flags |= IEEE80211_RX_MALFORMED_ACTION_FRM;
+	status->rx_flags |= MAC80211_RX_MALFORMED_ACTION_FRM;
 	/* will return in the next handlers */
 	return RX_CONTINUE;
 
@@ -2248,7 +2248,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	/* skip known-bad action frames and return them in the next handler */
-	if (status->rx_flags & IEEE80211_RX_MALFORMED_ACTION_FRM)
+	if (status->rx_flags & MAC80211_RX_MALFORMED_ACTION_FRM)
 		return RX_CONTINUE;
 
 	/*
@@ -2293,7 +2293,7 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 	 * registration mechanisms, but older ones still use cooked
 	 * monitor interfaces so push all frames there.
 	 */
-	if (!(status->rx_flags & IEEE80211_RX_MALFORMED_ACTION_FRM) &&
+	if (!(status->rx_flags & MAC80211_RX_MALFORMED_ACTION_FRM) &&
 	    (sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
 		return RX_DROP_MONITOR;
@@ -2373,7 +2373,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 }
 
-/* TODO: use IEEE80211_RX_FRAGMENTED */
+/* TODO: use MAC80211_RX_FRAGMENTED */
 static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 					struct ieee80211_rate *rate)
 {
@@ -2626,7 +2626,7 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			if (!(sdata->dev->flags & IFF_PROMISC) ||
 			    sdata->u.mgd.use_4addr)
 				return 0;
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~MAC80211_RX_RA_MATCH;
 		}
 		break;
 	case NL80211_IFTYPE_ADHOC:
@@ -2636,15 +2636,15 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			return 1;
 		}
 		else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
-			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN))
+			if (!(status->rx_flags & MAC80211_RX_IN_SCAN))
 				return 0;
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~MAC80211_RX_RA_MATCH;
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->vif.addr,
 					      hdr->addr1) != 0) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~MAC80211_RX_RA_MATCH;
 		} else if (!rx->sta) {
 			int rate_idx;
 			if (status->flag & RX_FLAG_HT)
@@ -2662,7 +2662,7 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~MAC80211_RX_RA_MATCH;
 		}
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
@@ -2673,10 +2673,10 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 				return 0;
 		} else if (!ieee80211_bssid_match(bssid,
 					sdata->vif.addr)) {
-			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
+			if (!(status->rx_flags & MAC80211_RX_IN_SCAN) &&
 			    !ieee80211_is_beacon(hdr->frame_control))
 				return 0;
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~MAC80211_RX_RA_MATCH;
 		}
 		break;
 	case NL80211_IFTYPE_WDS:
@@ -2710,7 +2710,7 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 	int prepares;
 
 	rx->skb = skb;
-	status->rx_flags |= IEEE80211_RX_RA_MATCH;
+	status->rx_flags |= MAC80211_RX_RA_MATCH;
 	prepares = prepare_for_handlers(rx, hdr);
 
 	if (!prepares)
@@ -2760,7 +2760,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
 		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
-		status->rx_flags |= IEEE80211_RX_IN_SCAN;
+		status->rx_flags |= MAC80211_RX_IN_SCAN;
 
 	if (ieee80211_is_mgmt(fc))
 		err = skb_linearize(skb);

