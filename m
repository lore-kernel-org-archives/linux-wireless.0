Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0IXJXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 05:23:53 -0400
Message-Id: <20100924092306.234695699@sipsolutions.net>
Date: Fri, 24 Sep 2010 11:21:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/5] mac80211: move packet flags into packet
References: <20100924092104.384954781@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit 8c0c709eea5cbab97fb464cd68b06f24acc58ee1
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Nov 25 17:46:15 2009 +0100

    mac80211: move cmntr flag out of rx flags

moved the CMNTR flag into the skb RX flags for
some aggregation cleanups, but this was wrong
since the optimisation this flag tried to make
requires that it is kept across the processing
of multiple interfaces -- which isn't true for
flags in the skb. The patch not only broke the
optimisation, it also introduced a bug: under
some (common!) circumstances the flag will be
set on an already freed skb!

However, investigating this in more detail, I
found that most of the flags that we set should
be per packet, _except_ for this one, due to
a-MPDU processing. Additionally, the flags used
for processing (currently just this one) need
to be reset before processing a new packet.

Since we haven't actually seen bugs reported as
a result of the wrong flags handling (which is
not too surprising -- the only real bug case I
can come up with is an a-MSDU contained in an
a-MPDU), I'll make a different fix for rc.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    6 --
 net/mac80211/ieee80211_i.h |   38 +++++++++++++---
 net/mac80211/rx.c          |  102 +++++++++++++++++++++++++--------------------
 net/mac80211/wpa.c         |    2 
 4 files changed, 91 insertions(+), 57 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-09-24 11:03:11.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-09-24 11:03:12.000000000 +0200
@@ -315,6 +315,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	int tid;
 
 	/* does the frame have a qos control field? */
@@ -323,9 +324,7 @@ static void ieee80211_parse_qos(struct i
 		/* frame has qos control */
 		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 		if (*qc & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
-			rx->flags |= IEEE80211_RX_AMSDU;
-		else
-			rx->flags &= ~IEEE80211_RX_AMSDU;
+			status->rx_flags |= IEEE80211_RX_AMSDU;
 	} else {
 		/*
 		 * IEEE 802.11-2007, 7.1.3.4.1 ("Sequence Number field"):
@@ -387,9 +386,10 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	struct sk_buff *skb = rx->skb;
 
-	if (likely(!(rx->flags & IEEE80211_RX_IN_SCAN)))
+	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN)))
 		return RX_CONTINUE;
 
 	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
@@ -783,13 +783,14 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
 	if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->queue] ==
 			     hdr->seq_ctrl)) {
-			if (rx->flags & IEEE80211_RX_RA_MATCH) {
+			if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
 				rx->local->dot11FrameDuplicateCount++;
 				rx->sta->num_duplicates++;
 			}
@@ -822,7 +823,7 @@ ieee80211_rx_h_check(struct ieee80211_rx
 		if ((!ieee80211_has_fromds(hdr->frame_control) &&
 		     !ieee80211_has_tods(hdr->frame_control) &&
 		     ieee80211_is_data(hdr->frame_control)) ||
-		    !(rx->flags & IEEE80211_RX_RA_MATCH)) {
+		    !(status->rx_flags & IEEE80211_RX_RA_MATCH)) {
 			/* Drop IBSS frames and frames for other hosts
 			 * silently. */
 			return RX_DROP_MONITOR;
@@ -879,7 +880,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	 * No point in finding a key and decrypting if the frame is neither
 	 * addressed to us nor a multicast frame.
 	 */
-	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
+	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	/* start without a key */
@@ -1112,7 +1113,7 @@ ieee80211_rx_h_sta_process(struct ieee80
 		sta->last_rx = jiffies;
 	}
 
-	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
+	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	if (rx->sdata->vif.type == NL80211_IFTYPE_STATION)
@@ -1269,6 +1270,7 @@ ieee80211_rx_h_defragment(struct ieee802
 	unsigned int frag, seq;
 	struct ieee80211_fragment_entry *entry;
 	struct sk_buff *skb;
+	struct ieee80211_rx_status *status;
 
 	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	fc = hdr->frame_control;
@@ -1368,7 +1370,8 @@ ieee80211_rx_h_defragment(struct ieee802
 	}
 
 	/* Complete frame has been reassembled - process it now */
-	rx->flags |= IEEE80211_RX_FRAGMENTED;
+	status = IEEE80211_SKB_RXCB(rx->skb);
+	status->rx_flags |= IEEE80211_RX_FRAGMENTED;
 
  out:
 	if (rx->sta)
@@ -1385,9 +1388,10 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	__le16 fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	if (likely(!rx->sta || !ieee80211_is_pspoll(fc) ||
-		   !(rx->flags & IEEE80211_RX_RA_MATCH)))
+		   !(status->rx_flags & IEEE80211_RX_RA_MATCH)))
 		return RX_CONTINUE;
 
 	if ((sdata->vif.type != NL80211_IFTYPE_AP) &&
@@ -1548,6 +1552,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 	struct sk_buff *skb, *xmit_skb;
 	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
 	struct sta_info *dsta;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	skb = rx->skb;
 	xmit_skb = NULL;
@@ -1555,7 +1560,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
-	    (rx->flags & IEEE80211_RX_RA_MATCH) &&
+	    (status->rx_flags & IEEE80211_RX_RA_MATCH) &&
 	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->u.vlan.sta)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
 			/*
@@ -1632,6 +1637,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
 	struct sk_buff_head frame_list;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	if (unlikely(!ieee80211_is_data(fc)))
 		return RX_CONTINUE;
@@ -1639,7 +1645,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
 	if (unlikely(!ieee80211_is_data_present(fc)))
 		return RX_DROP_MONITOR;
 
-	if (!(rx->flags & IEEE80211_RX_AMSDU))
+	if (!(status->rx_flags & IEEE80211_RX_AMSDU))
 		return RX_CONTINUE;
 
 	if (ieee80211_has_a4(hdr->frame_control) &&
@@ -1690,6 +1696,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 	struct sk_buff *skb = rx->skb, *fwd_skb;
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -1735,7 +1742,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 	mesh_hdr->ttl--;
 
-	if (rx->flags & IEEE80211_RX_RA_MATCH) {
+	if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
 		if (!mesh_hdr->ttl)
 			IEEE80211_IFSTA_MESH_CTR_INC(&rx->sdata->u.mesh,
 						     dropped_frames_ttl);
@@ -1945,6 +1952,7 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	/*
 	 * From here on, look only at management frames.
@@ -1957,7 +1965,7 @@ ieee80211_rx_h_mgmt_check(struct ieee802
 	if (!ieee80211_is_mgmt(mgmt->frame_control))
 		return RX_DROP_MONITOR;
 
-	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
+	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
 	if (ieee80211_drop_unencrypted_mgmt(rx))
@@ -1972,6 +1980,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	int len = rx->skb->len;
 
 	if (!ieee80211_is_action(mgmt->frame_control))
@@ -1984,7 +1993,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 	if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
 		return RX_DROP_UNUSABLE;
 
-	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
+	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_UNUSABLE;
 
 	switch (mgmt->u.action.category) {
@@ -2080,7 +2089,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 	return RX_CONTINUE;
 
  invalid:
-	rx->flags |= IEEE80211_MALFORMED_ACTION_FRM;
+	status->rx_flags |= IEEE80211_RX_MALFORMED_ACTION_FRM;
 	/* will return in the next handlers */
 	return RX_CONTINUE;
 
@@ -2102,10 +2111,10 @@ ieee80211_rx_h_action(struct ieee80211_r
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_rx_status *status;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	/* skip known-bad action frames and return them in the next handler */
-	if (rx->flags & IEEE80211_MALFORMED_ACTION_FRM)
+	if (status->rx_flags & IEEE80211_RX_MALFORMED_ACTION_FRM)
 		return RX_CONTINUE;
 
 	/*
@@ -2114,7 +2123,6 @@ ieee80211_rx_h_userspace_mgmt(struct iee
 	 * so userspace can register for those to know whether ones
 	 * it transmitted were processed or returned.
 	 */
-	status = IEEE80211_SKB_RXCB(rx->skb);
 
 	if (cfg80211_rx_mgmt(rx->sdata->dev, status->freq,
 			     rx->skb->data, rx->skb->len,
@@ -2136,6 +2144,7 @@ ieee80211_rx_h_action_return(struct ieee
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	struct sk_buff *nskb;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	if (!ieee80211_is_action(mgmt->frame_control))
 		return RX_CONTINUE;
@@ -2150,7 +2159,7 @@ ieee80211_rx_h_action_return(struct ieee
 	 * registration mechanisms, but older ones still use cooked
 	 * monitor interfaces so push all frames there.
 	 */
-	if (!(rx->flags & IEEE80211_MALFORMED_ACTION_FRM) &&
+	if (!(status->rx_flags & IEEE80211_RX_MALFORMED_ACTION_FRM) &&
 	    (sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
 		return RX_DROP_MONITOR;
@@ -2284,8 +2293,13 @@ static void ieee80211_rx_cooked_monitor(
 	struct net_device *prev_dev = NULL;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	if (status->flag & RX_FLAG_INTERNAL_CMTR)
+	/*
+	 * If cooked monitor has been processed already, then
+	 * don't do it again. If not, set the flag.
+	 */
+	if (rx->flags & IEEE80211_RX_CMNTR)
 		goto out_free_skb;
+	rx->flags |= IEEE80211_RX_CMNTR;
 
 	if (skb_headroom(skb) < sizeof(*rthdr) &&
 	    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC))
@@ -2341,12 +2355,8 @@ static void ieee80211_rx_cooked_monitor(
 	if (prev_dev) {
 		skb->dev = prev_dev;
 		netif_receive_skb(skb);
-		skb = NULL;
-	} else
-		goto out_free_skb;
-
-	status->flag |= RX_FLAG_INTERNAL_CMTR;
-	return;
+		return;
+	}
 
  out_free_skb:
 	dev_kfree_skb(skb);
@@ -2407,6 +2417,7 @@ static void ieee80211_rx_handlers(struct
 		 * same TID from the same station
 		 */
 		rx->skb = skb;
+		rx->flags = 0;
 
 		CALL_RXH(ieee80211_rx_h_decrypt)
 		CALL_RXH(ieee80211_rx_h_check_more_data)
@@ -2477,7 +2488,12 @@ static void ieee80211_invoke_rx_handlers
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 {
 	struct sk_buff_head frames;
-	struct ieee80211_rx_data rx = { };
+	struct ieee80211_rx_data rx = {
+		.sta = sta,
+		.sdata = sta->sdata,
+		.local = sta->local,
+		.queue = tid,
+	};
 	struct tid_ampdu_rx *tid_agg_rx;
 
 	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
@@ -2486,13 +2502,6 @@ void ieee80211_release_reorder_timeout(s
 
 	__skb_queue_head_init(&frames);
 
-	/* construct rx struct */
-	rx.sta = sta;
-	rx.sdata = sta->sdata;
-	rx.local = sta->local;
-	rx.queue = tid;
-	rx.flags |= IEEE80211_RX_RA_MATCH;
-
 	spin_lock(&tid_agg_rx->reorder_lock);
 	ieee80211_sta_reorder_release(&sta->local->hw, tid_agg_rx, &frames);
 	spin_unlock(&tid_agg_rx->reorder_lock);
@@ -2519,7 +2528,7 @@ static int prepare_for_handlers(struct i
 		    compare_ether_addr(sdata->vif.addr, hdr->addr1) != 0) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
-			rx->flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		break;
 	case NL80211_IFTYPE_ADHOC:
@@ -2529,15 +2538,15 @@ static int prepare_for_handlers(struct i
 			return 1;
 		}
 		else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
-			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
+			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN))
 				return 0;
-			rx->flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->vif.addr,
 					      hdr->addr1) != 0) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
-			rx->flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!rx->sta) {
 			int rate_idx;
 			if (status->flag & RX_FLAG_HT)
@@ -2555,7 +2564,7 @@ static int prepare_for_handlers(struct i
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 
-			rx->flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
@@ -2566,9 +2575,9 @@ static int prepare_for_handlers(struct i
 				return 0;
 		} else if (!ieee80211_bssid_match(bssid,
 					sdata->vif.addr)) {
-			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
+			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN))
 				return 0;
-			rx->flags &= ~IEEE80211_RX_RA_MATCH;
+			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		break;
 	case NL80211_IFTYPE_WDS:
@@ -2602,14 +2611,14 @@ static bool ieee80211_prepare_and_rx_han
 	int prepares;
 
 	rx->skb = skb;
-	rx->flags |= IEEE80211_RX_RA_MATCH;
+	status->rx_flags |= IEEE80211_RX_RA_MATCH;
 	prepares = prepare_for_handlers(rx, hdr);
 
 	if (!prepares)
 		return false;
 
 	if (status->flag & RX_FLAG_MMIC_ERROR) {
-		if (rx->flags & IEEE80211_RX_RA_MATCH)
+		if (status->rx_flags & IEEE80211_RX_RA_MATCH)
 			ieee80211_rx_michael_mic_report(hdr, rx);
 		return false;
 	}
@@ -2638,6 +2647,7 @@ static bool ieee80211_prepare_and_rx_han
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					 struct sk_buff *skb)
 {
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
@@ -2657,7 +2667,7 @@ static void __ieee80211_rx_handle_packet
 
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
 		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
-		rx.flags |= IEEE80211_RX_IN_SCAN;
+		status->rx_flags |= IEEE80211_RX_IN_SCAN;
 
 	if (ieee80211_is_mgmt(fc))
 		err = skb_linearize(skb);
@@ -2808,6 +2818,8 @@ void ieee80211_rx(struct ieee80211_hw *h
 		}
 	}
 
+	status->rx_flags = 0;
+
 	/*
 	 * key references and virtual interfaces are protected using RCU
 	 * and this requires that we are in a read-side RCU section during
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-09-24 11:02:25.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-09-24 11:03:12.000000000 +0200
@@ -159,13 +159,37 @@ typedef unsigned __bitwise__ ieee80211_r
 #define RX_DROP_MONITOR		((__force ieee80211_rx_result) 2u)
 #define RX_QUEUED		((__force ieee80211_rx_result) 3u)
 
-#define IEEE80211_RX_IN_SCAN		BIT(0)
-/* frame is destined to interface currently processed (incl. multicast frames) */
-#define IEEE80211_RX_RA_MATCH		BIT(1)
-#define IEEE80211_RX_AMSDU		BIT(2)
-#define IEEE80211_RX_FRAGMENTED		BIT(3)
-#define IEEE80211_MALFORMED_ACTION_FRM	BIT(4)
-/* only add flags here that do not change with subframes of an aMPDU */
+/**
+ * enum ieee80211_packet_rx_flags - packet RX flags
+ * @IEEE80211_RX_RA_MATCH: frame is destined to interface currently processed
+ *	(incl. multicast frames)
+ * @IEEE80211_RX_IN_SCAN: received while scanning
+ * @IEEE80211_RX_FRAGMENTED: fragmented frame
+ * @IEEE80211_PKT_RX_AMSDU: a-MSDU packet
+ * @IEEE80211_RX_MALFORMED_ACTION_FRM: action frame is malformed
+ *
+ * These are per-frame flags that are attached to a frame in the
+ * @rx_flags field of &struct ieee80211_rx_status.
+ */
+enum ieee80211_packet_rx_flags {
+	IEEE80211_RX_IN_SCAN			= BIT(0),
+	IEEE80211_RX_RA_MATCH			= BIT(1),
+	IEEE80211_RX_FRAGMENTED			= BIT(2),
+	IEEE80211_RX_AMSDU			= BIT(3),
+	IEEE80211_RX_MALFORMED_ACTION_FRM	= BIT(4),
+};
+
+/**
+ * enum ieee80211_rx_flags - RX data flags
+ *
+ * @IEEE80211_RX_CMNTR: received on cooked monitor already
+ *
+ * These flags are used across handling multiple interfaces
+ * for a single frame.
+ */
+enum ieee80211_rx_flags {
+	IEEE80211_RX_CMNTR		= BIT(0),
+};
 
 struct ieee80211_rx_data {
 	struct sk_buff *skb;
--- wireless-testing.orig/include/net/mac80211.h	2010-09-24 11:02:25.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-09-24 11:03:12.000000000 +0200
@@ -565,9 +565,6 @@ ieee80211_tx_info_clear_status(struct ie
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
  * @RX_FLAG_SHORT_GI: Short guard interval was used
- * @RX_FLAG_INTERNAL_CMTR: set internally after frame was reported
- *	on cooked monitor to avoid double-reporting it for multiple
- *	virtual interfaces
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -581,7 +578,6 @@ enum mac80211_rx_flags {
 	RX_FLAG_HT		= 1<<9,
 	RX_FLAG_40MHZ		= 1<<10,
 	RX_FLAG_SHORT_GI	= 1<<11,
-	RX_FLAG_INTERNAL_CMTR	= 1<<12,
 };
 
 /**
@@ -602,6 +598,7 @@ enum mac80211_rx_flags {
  * @rate_idx: index of data rate into band's supported rates or MCS index if
  *	HT rates are use (RX_FLAG_HT)
  * @flag: %RX_FLAG_*
+ * @rx_flags: internal RX flags for mac80211
  */
 struct ieee80211_rx_status {
 	u64 mactime;
@@ -611,6 +608,7 @@ struct ieee80211_rx_status {
 	int antenna;
 	int rate_idx;
 	int flag;
+	unsigned int rx_flags;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/wpa.c	2010-09-24 11:02:25.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.c	2010-09-24 11:03:12.000000000 +0200
@@ -117,7 +117,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 	key = &rx->key->conf.key[key_offset];
 	michael_mic(key, hdr, data, data_len, mic);
 	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0 || wpa_test) {
-		if (!(rx->flags & IEEE80211_RX_RA_MATCH))
+		if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
 			return RX_DROP_UNUSABLE;
 
 		mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,


