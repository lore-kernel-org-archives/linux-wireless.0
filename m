Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab2GFVFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 17:05:37 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/3] mac80211: redesign scan RX
Date: Fri,  6 Jul 2012 23:05:33 +0200
Message-Id: <1341608733-7503-4-git-send-email-johannes@sipsolutions.net> (sfid-20120706_230543_431509_5B2B8A6E)
In-Reply-To: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Scan receive is rather inefficient when there are
multiple virtual interfaces. We iterate all of the
virtual interfaces and then notify cfg80211 about
each beacon many times.

Redesign scan RX to happen before everything else.
Then we can also get rid of IEEE80211_RX_IN_SCAN
since we don't have to accept frames into the RX
handlers for scanning or scheduled scanning any
more. Overall, this simplifies the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c     |    2 --
 net/mac80211/ieee80211_i.h |    6 +----
 net/mac80211/rx.c          |   46 +++++++----------------------------
 net/mac80211/scan.c        |   57 ++++++++++++++++++--------------------------
 4 files changed, 32 insertions(+), 79 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 778e591..b8dfb44 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -325,8 +325,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 		local->rx_handlers_drop_defrag);
 	DEBUGFS_STATS_ADD(rx_handlers_drop_short,
 		local->rx_handlers_drop_short);
-	DEBUGFS_STATS_ADD(rx_handlers_drop_passive_scan,
-		local->rx_handlers_drop_passive_scan);
 	DEBUGFS_STATS_ADD(tx_expand_skb_head,
 		local->tx_expand_skb_head);
 	DEBUGFS_STATS_ADD(tx_expand_skb_head_cloned,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2e7dc0c..653be8d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -209,7 +209,6 @@ typedef unsigned __bitwise__ ieee80211_rx_result;
  * enum ieee80211_packet_rx_flags - packet RX flags
  * @IEEE80211_RX_RA_MATCH: frame is destined to interface currently processed
  *	(incl. multicast frames)
- * @IEEE80211_RX_IN_SCAN: received while scanning
  * @IEEE80211_RX_FRAGMENTED: fragmented frame
  * @IEEE80211_RX_AMSDU: a-MSDU packet
  * @IEEE80211_RX_MALFORMED_ACTION_FRM: action frame is malformed
@@ -219,7 +218,6 @@ typedef unsigned __bitwise__ ieee80211_rx_result;
  * @rx_flags field of &struct ieee80211_rx_status.
  */
 enum ieee80211_packet_rx_flags {
-	IEEE80211_RX_IN_SCAN			= BIT(0),
 	IEEE80211_RX_RA_MATCH			= BIT(1),
 	IEEE80211_RX_FRAGMENTED			= BIT(2),
 	IEEE80211_RX_AMSDU			= BIT(3),
@@ -1016,7 +1014,6 @@ struct ieee80211_local {
 	unsigned int rx_handlers_drop_nullfunc;
 	unsigned int rx_handlers_drop_defrag;
 	unsigned int rx_handlers_drop_short;
-	unsigned int rx_handlers_drop_passive_scan;
 	unsigned int tx_expand_skb_head;
 	unsigned int tx_expand_skb_head_cloned;
 	unsigned int rx_expand_skb_head;
@@ -1251,8 +1248,7 @@ int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
 void ieee80211_scan_cancel(struct ieee80211_local *local);
 void ieee80211_run_deferred_scan(struct ieee80211_local *local);
-ieee80211_rx_result
-ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
+void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb);
 
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
 struct ieee80211_bss *
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4e09b7f..ee96960 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -453,29 +453,6 @@ static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
 
 /* rx handlers */
 
-static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
-{
-	struct ieee80211_local *local = rx->local;
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
-	struct sk_buff *skb = rx->skb;
-
-	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
-		   !rcu_access_pointer(local->sched_scan_sdata)))
-		return RX_CONTINUE;
-
-	if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_SW_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
-	    rcu_access_pointer(local->sched_scan_sdata))
-		return ieee80211_scan_rx(rx->sdata, skb);
-
-	/* scanning finished during invoking of handlers */
-	I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
-	return RX_DROP_UNUSABLE;
-}
-
-
 static int ieee80211_is_unicast_robust_mgmt_frame(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -2732,7 +2709,6 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 			goto rxh_next;  \
 	} while (0);
 
-	CALL_RXH(ieee80211_rx_h_passive_scan)
 	CALL_RXH(ieee80211_rx_h_check)
 
 	ieee80211_rx_reorder_ampdu(rx);
@@ -2802,11 +2778,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			return 0;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			return 1;
-		}
-		else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
-			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN))
-				return 0;
-			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+		} else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
+			return 0;
 		} else if (!multicast &&
 			   !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
@@ -2843,11 +2816,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			 * and location updates. Note that mac80211
 			 * itself never looks at these frames.
 			 */
-			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
-			    ieee80211_is_public_action(hdr, skb->len))
+			if (ieee80211_is_public_action(hdr, skb->len))
 				return 1;
-			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
-			    !ieee80211_is_beacon(hdr->frame_control))
+			if (!ieee80211_is_beacon(hdr->frame_control))
 				return 0;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
@@ -2940,11 +2911,6 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	if (ieee80211_is_data(fc) || ieee80211_is_mgmt(fc))
 		local->dot11ReceivedFragmentCount++;
 
-	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
-		     test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
-		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
-		status->rx_flags |= IEEE80211_RX_IN_SCAN;
-
 	if (ieee80211_is_mgmt(fc))
 		err = skb_linearize(skb);
 	else
@@ -2959,6 +2925,10 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	ieee80211_parse_qos(&rx);
 	ieee80211_verify_alignment(&rx);
 
+	if (unlikely(ieee80211_is_probe_resp(hdr->frame_control) ||
+		     ieee80211_is_beacon(hdr->frame_control)))
+		ieee80211_scan_rx(local, skb);
+
 	if (ieee80211_is_data(fc)) {
 		prev_sta = NULL;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a5848d2..f9d61a4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -166,52 +166,47 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	return bss;
 }
 
-ieee80211_rx_result
-ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_sub_if_data *sdata1, *sdata2;
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
 	struct ieee80211_bss *bss;
 	u8 *elements;
 	struct ieee80211_channel *channel;
 	size_t baselen;
 	int freq;
-	__le16 fc;
-	bool presp, beacon = false;
+	bool beacon;
 	struct ieee802_11_elems elems;
 
-	if (skb->len < 2)
-		return RX_DROP_UNUSABLE;
-
-	mgmt = (struct ieee80211_mgmt *) skb->data;
-	fc = mgmt->frame_control;
+	if (skb->len < 24 ||
+	    (!ieee80211_is_probe_resp(mgmt->frame_control) &&
+	     !ieee80211_is_beacon(mgmt->frame_control)))
+		return;
 
-	if (ieee80211_is_ctl(fc))
-		return RX_CONTINUE;
+	sdata1 = rcu_dereference(local->scan_sdata);
+	sdata2 = rcu_dereference(local->sched_scan_sdata);
 
-	if (skb->len < 24)
-		return RX_CONTINUE;
+	if (likely(!sdata1 && !sdata2))
+		return;
 
-	presp = ieee80211_is_probe_resp(fc);
-	if (presp) {
+	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 		/* ignore ProbeResp to foreign address */
-		if (!ether_addr_equal(mgmt->da, sdata->vif.addr))
-			return RX_DROP_MONITOR;
+		if (!ether_addr_equal(mgmt->da, sdata1->vif.addr) &&
+		    !ether_addr_equal(mgmt->da, sdata2->vif.addr))
+			return;
 
-		presp = true;
 		elements = mgmt->u.probe_resp.variable;
 		baselen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+		beacon = false;
 	} else {
-		beacon = ieee80211_is_beacon(fc);
 		baselen = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 		elements = mgmt->u.beacon.variable;
+		beacon = true;
 	}
 
-	if (!presp && !beacon)
-		return RX_CONTINUE;
-
 	if (baselen > skb->len)
-		return RX_DROP_MONITOR;
+		return;
 
 	ieee802_11_parse_elems(elements, skb->len - baselen, &elems);
 
@@ -221,22 +216,16 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	else
 		freq = rx_status->freq;
 
-	channel = ieee80211_get_channel(sdata->local->hw.wiphy, freq);
+	channel = ieee80211_get_channel(local->hw.wiphy, freq);
 
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
-		return RX_DROP_MONITOR;
+		return;
 
-	bss = ieee80211_bss_info_update(sdata->local, rx_status,
+	bss = ieee80211_bss_info_update(local, rx_status,
 					mgmt, skb->len, &elems,
 					channel, beacon);
 	if (bss)
-		ieee80211_rx_bss_put(sdata->local, bss);
-
-	if (channel == sdata->local->oper_channel)
-		return RX_CONTINUE;
-
-	dev_kfree_skb(skb);
-	return RX_QUEUED;
+		ieee80211_rx_bss_put(local, bss);
 }
 
 /* return false if no more work */
-- 
1.7.10.4

