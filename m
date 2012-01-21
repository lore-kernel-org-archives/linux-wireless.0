Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22697 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2AUJ4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 04:56:51 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2 6/6] ath6kl: Fix bug in maintaining aggregation state in AP mode
Date: Sat, 21 Jan 2012 15:22:53 +0530
Message-ID: <1327139573-7435-6-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120121_105654_566297_84551954)
In-Reply-To: <1327139573-7435-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1327139573-7435-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently rx aggregation related states are maintained per
vif, but this will not properly work when operating in AP mode.
Aggregation is completely broken when more than one
11n stations are connected to AP mode vif. Fix this issue
by keeping station specific aggregation state in sta_list.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
V2 -    Remove unnecessary rxtid->q (skb_queue) initialization from
        ath6kl_alloc_aggr_conn().
   -    Move aggr_conn allocation from ath6kl_alloc_aggr_conn() to
	ath6kl_core_init() and remove ath6kl_alloc_aggr_conn().
 
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 ++
 drivers/net/wireless/ath/ath6kl/core.c     |    7 ++
 drivers/net/wireless/ath/ath6kl/core.h     |    4 +-
 drivers/net/wireless/ath/ath6kl/init.c     |    4 +
 drivers/net/wireless/ath/ath6kl/main.c     |    7 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |  106 +++++++++++++++++-----------
 6 files changed, 88 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 8bf447a..fed7b80 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2871,6 +2871,11 @@ struct ath6kl *ath6kl_cfg80211_create(void)
 /* Note: ar variable must not be accessed after calling this! */
 void ath6kl_cfg80211_destroy(struct ath6kl *ar)
 {
+	int i;
+
+	for (i = 0; i < AP_MAX_NUM_STA; i++)
+		kfree(ar->sta_list[i].aggr_conn);
+
 	wiphy_free(ar->wiphy);
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index d764afe..0d92e71 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -253,6 +253,13 @@ struct ath6kl *ath6kl_core_create(struct device *dev)
 		spin_lock_init(&ar->sta_list[ctr].psq_lock);
 		skb_queue_head_init(&ar->sta_list[ctr].psq);
 		skb_queue_head_init(&ar->sta_list[ctr].apsdq);
+		ar->sta_list[ctr].aggr_conn =
+			kzalloc(sizeof(struct aggr_info_conn), GFP_KERNEL);
+		if (!ar->sta_list[ctr].aggr_conn) {
+			ath6kl_err("Failed to allocate memory for sta aggregation information\n");
+			ath6kl_core_destroy(ar);
+			return NULL;
+		}
 	}
 
 	skb_queue_head_init(&ar->mcastpsq);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 1b9054f..ed9fcc1 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -298,6 +298,7 @@ struct ath6kl_sta {
 	spinlock_t psq_lock;
 	u8 apsd_info;
 	struct sk_buff_head apsdq;
+	struct aggr_info_conn *aggr_conn;
 };
 
 struct ath6kl_version {
@@ -713,6 +714,7 @@ void ath6kl_free_cookie(struct ath6kl *ar, struct ath6kl_cookie *cookie);
 int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev);
 
 struct aggr_info *aggr_init(struct ath6kl_vif *vif);
+void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info_conn *aggr_conn);
 void ath6kl_rx_refill(struct htc_target *target,
 		      enum htc_endpoint_id endpoint);
 void ath6kl_refill_amsdu_rxbufs(struct ath6kl *ar, int count);
@@ -720,7 +722,7 @@ struct htc_packet *ath6kl_alloc_amsdu_rxbuf(struct htc_target *target,
 					    enum htc_endpoint_id endpoint,
 					    int len);
 void aggr_module_destroy(struct aggr_info *aggr_info);
-void aggr_reset_state(struct aggr_info *aggr_info);
+void aggr_reset_state(struct aggr_info_conn *aggr_conn);
 
 struct ath6kl_sta *ath6kl_find_sta(struct ath6kl_vif *vif, u8 * node_addr);
 struct ath6kl_sta *ath6kl_find_sta_by_aid(struct ath6kl *ar, u8 aid);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 167dc41..4d8eb1c 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1660,6 +1660,7 @@ void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
 void ath6kl_stop_txrx(struct ath6kl *ar)
 {
 	struct ath6kl_vif *vif, *tmp_vif;
+	int i;
 
 	set_bit(DESTROY_IN_PROGRESS, &ar->flag);
 
@@ -1668,6 +1669,9 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 		return;
 	}
 
+	for (i = 0; i < AP_MAX_NUM_STA; i++)
+		aggr_reset_state(ar->sta_list[i].aggr_conn);
+
 	spin_lock_bh(&ar->list_lock);
 	list_for_each_entry_safe(vif, tmp_vif, &ar->vif_list, list) {
 		list_del(&vif->list);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index acb4acb..39da1f9 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -74,6 +74,7 @@ static void ath6kl_add_new_sta(struct ath6kl_vif *vif, u8 *mac, u16 aid,
 
 	ar->sta_list_index = ar->sta_list_index | (1 << free_slot);
 	ar->ap_stats.sta[free_slot].aid = cpu_to_le32(aid);
+	aggr_conn_init(vif, sta->aggr_conn);
 }
 
 static void ath6kl_sta_cleanup(struct ath6kl *ar, u8 i)
@@ -94,7 +95,7 @@ static void ath6kl_sta_cleanup(struct ath6kl *ar, u8 i)
 	sta->sta_flags = 0;
 
 	ar->sta_list_index = ar->sta_list_index & ~(1 << i);
-
+	aggr_reset_state(sta->aggr_conn);
 }
 
 static u8 ath6kl_remove_sta(struct ath6kl *ar, u8 *mac, u16 reason)
@@ -602,7 +603,7 @@ void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel, u8 *bssid,
 	netif_carrier_on(vif->ndev);
 	spin_unlock_bh(&vif->if_lock);
 
-	aggr_reset_state(vif->aggr_cntxt);
+	aggr_reset_state(vif->aggr_cntxt->aggr_conn);
 	vif->reconnect_flag = 0;
 
 	if ((vif->nw_type == ADHOC_NETWORK) && ar->ibss_ps_enable) {
@@ -924,7 +925,7 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 				       assoc_resp_len, assoc_info,
 				       prot_reason_status);
 
-	aggr_reset_state(vif->aggr_cntxt);
+	aggr_reset_state(vif->aggr_cntxt->aggr_conn);
 
 	del_timer(&vif->disconnect_timer);
 
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 8cf7b2f..62c1210 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -22,12 +22,18 @@
  * aid - tid_mux4..tid_mux7
  */
 #define ATH6KL_TID_MASK 0xf
+#define ATH6KL_AID_SHIFT 4
 
 static inline u8 ath6kl_get_tid(u8 tid_mux)
 {
 	return tid_mux & ATH6KL_TID_MASK;
 }
 
+static inline u8 ath6kl_get_aid(u8 tid_mux)
+{
+	return tid_mux >> ATH6KL_AID_SHIFT;
+}
+
 static u8 ath6kl_ibss_map_epid(struct sk_buff *skb, struct net_device *dev,
 			       u32 *map_no)
 {
@@ -1003,7 +1009,7 @@ static void aggr_slice_amsdu(struct aggr_info *p_aggr,
 	dev_kfree_skb(skb);
 }
 
-static void aggr_deque_frms(struct aggr_info *p_aggr, u8 tid,
+static void aggr_deque_frms(struct aggr_info_conn *agg_conn, u8 tid,
 			    u16 seq_no, u8 order)
 {
 	struct sk_buff *skb;
@@ -1011,12 +1017,7 @@ static void aggr_deque_frms(struct aggr_info *p_aggr, u8 tid,
 	struct skb_hold_q *node;
 	u16 idx, idx_end, seq_end;
 	struct rxtid_stats *stats;
-	struct aggr_info_conn *agg_conn;
 
-	if (!p_aggr || !p_aggr->aggr_conn)
-		return;
-
-	agg_conn = p_aggr->aggr_conn;
 	rxtid = &agg_conn->rx_tid[tid];
 	stats = &agg_conn->stat[tid];
 
@@ -1047,7 +1048,8 @@ static void aggr_deque_frms(struct aggr_info *p_aggr, u8 tid,
 
 		if (node->skb) {
 			if (node->is_amsdu)
-				aggr_slice_amsdu(p_aggr, rxtid, node->skb);
+				aggr_slice_amsdu(agg_conn->aggr_info, rxtid,
+						 node->skb);
 			else
 				skb_queue_tail(&rxtid->q, node->skb);
 			node->skb = NULL;
@@ -1066,7 +1068,7 @@ static void aggr_deque_frms(struct aggr_info *p_aggr, u8 tid,
 		ath6kl_deliver_frames_to_nw_stack(agg_conn->dev, skb);
 }
 
-static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
+static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
 				  u16 seq_no,
 				  bool is_amsdu, struct sk_buff *frame)
 {
@@ -1077,7 +1079,6 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 	u16 idx, st, cur, end;
 	bool is_queued = false;
 	u16 extended_end;
-	struct aggr_info_conn *agg_conn = agg_info->aggr_conn;
 
 	rxtid = &agg_conn->rx_tid[tid];
 	stats = &agg_conn->stat[tid];
@@ -1086,7 +1087,7 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 
 	if (!rxtid->aggr) {
 		if (is_amsdu) {
-			aggr_slice_amsdu(agg_info, rxtid, frame);
+			aggr_slice_amsdu(agg_conn->aggr_info, rxtid, frame);
 			is_queued = true;
 			stats->num_amsdu++;
 			while ((skb = skb_dequeue(&rxtid->q)))
@@ -1110,7 +1111,7 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 		     (cur < end || cur > extended_end)) ||
 		    ((end > extended_end) && (cur > extended_end) &&
 		     (cur < end))) {
-			aggr_deque_frms(agg_info, tid, 0, 0);
+			aggr_deque_frms(agg_conn, tid, 0, 0);
 			if (cur >= rxtid->hold_q_sz - 1)
 				rxtid->seq_next = cur - (rxtid->hold_q_sz - 1);
 			else
@@ -1127,7 +1128,7 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 				st = ATH6KL_MAX_SEQ_NO -
 					(rxtid->hold_q_sz - 2 - cur);
 
-			aggr_deque_frms(agg_info, tid, st, 0);
+			aggr_deque_frms(agg_conn, tid, st, 0);
 		}
 
 		stats->num_oow++;
@@ -1166,7 +1167,7 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 
 	spin_unlock_bh(&rxtid->lock);
 
-	aggr_deque_frms(agg_info, tid, 0, 1);
+	aggr_deque_frms(agg_conn, tid, 0, 1);
 
 	if (agg_conn->timer_scheduled)
 		rxtid->progress = true;
@@ -1278,6 +1279,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	struct sk_buff *skb1 = NULL;
 	struct ethhdr *datap = NULL;
 	struct ath6kl_vif *vif;
+	struct aggr_info_conn *aggr_conn;
 	u16 seq_no, offset;
 	u8 tid, if_idx;
 
@@ -1529,11 +1531,21 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 
 	datap = (struct ethhdr *) skb->data;
 
-	if (is_unicast_ether_addr(datap->h_dest) &&
-	    aggr_process_recv_frm(vif->aggr_cntxt, tid, seq_no,
-				  is_amsdu, skb))
-		/* aggregation code will handle the skb */
-		return;
+	if (is_unicast_ether_addr(datap->h_dest)) {
+		if (vif->nw_type == AP_NETWORK) {
+			conn = ath6kl_find_sta(vif, datap->h_source);
+			if (!conn)
+				return;
+			aggr_conn = conn->aggr_conn;
+		} else
+			aggr_conn = vif->aggr_cntxt->aggr_conn;
+
+		if (aggr_process_recv_frm(aggr_conn, tid, seq_no,
+		    is_amsdu, skb)) {
+			/* aggregation code will handle the skb */
+			return;
+		}
+	}
 
 	ath6kl_deliver_frames_to_nw_stack(vif->ndev, skb);
 }
@@ -1558,7 +1570,7 @@ static void aggr_timeout(unsigned long arg)
 			   rxtid->seq_next,
 			   ((rxtid->seq_next + rxtid->hold_q_sz-1) &
 			    ATH6KL_MAX_SEQ_NO));
-		aggr_deque_frms(aggr_conn->aggr_info, i, 0, 0);
+		aggr_deque_frms(aggr_conn, i, 0, 0);
 	}
 
 	aggr_conn->timer_scheduled = false;
@@ -1598,7 +1610,7 @@ static void aggr_delete_tid_state(struct aggr_info_conn *aggr_conn, u8 tid)
 	stats = &aggr_conn->stat[tid];
 
 	if (rxtid->aggr)
-		aggr_deque_frms(aggr_conn->aggr_info, tid, 0, 0);
+		aggr_deque_frms(aggr_conn, tid, 0, 0);
 
 	rxtid->aggr = false;
 	rxtid->progress = false;
@@ -1616,17 +1628,23 @@ static void aggr_delete_tid_state(struct aggr_info_conn *aggr_conn, u8 tid)
 void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid_mux, u16 seq_no,
 			     u8 win_sz)
 {
-	struct aggr_info *p_aggr = vif->aggr_cntxt;
-	struct aggr_info_conn *aggr_conn;
+	struct ath6kl_sta *sta;
+	struct aggr_info_conn *aggr_conn = NULL;
 	struct rxtid *rxtid;
 	struct rxtid_stats *stats;
 	u16 hold_q_size;
-	u8 tid;
+	u8 tid, aid;
 
-	if (!p_aggr || !p_aggr->aggr_conn)
-		return;
+	if (vif->nw_type == AP_NETWORK) {
+		aid = ath6kl_get_aid(tid_mux);
+		sta = ath6kl_find_sta_by_aid(vif->ar, aid);
+		if (sta)
+			aggr_conn = sta->aggr_conn;
+	} else
+		aggr_conn = vif->aggr_cntxt->aggr_conn;
 
-	aggr_conn = p_aggr->aggr_conn;
+	if (!aggr_conn)
+		return;
 
 	tid = ath6kl_get_tid(tid_mux);
 	if (tid >= NUM_OF_TIDS)
@@ -1656,8 +1674,7 @@ void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid_mux, u16 seq_no,
 	rxtid->aggr = true;
 }
 
-static void aggr_conn_init(struct ath6kl_vif *vif,
-			   struct aggr_info_conn *aggr_conn)
+void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info_conn *aggr_conn)
 {
 	struct rxtid *rxtid;
 	u8 i;
@@ -1709,39 +1726,46 @@ struct aggr_info *aggr_init(struct ath6kl_vif *vif)
 
 void aggr_recv_delba_req_evt(struct ath6kl_vif *vif, u8 tid_mux)
 {
-	struct aggr_info *p_aggr = vif->aggr_cntxt;
+	struct ath6kl_sta *sta;
 	struct rxtid *rxtid;
-	struct aggr_info_conn *aggr_conn;
-	u8 tid;
+	struct aggr_info_conn *aggr_conn = NULL;
+	u8 tid, aid;
+
+	if (vif->nw_type == AP_NETWORK) {
+		aid = ath6kl_get_aid(tid_mux);
+		sta = ath6kl_find_sta_by_aid(vif->ar, aid);
+		if (sta)
+			aggr_conn = sta->aggr_conn;
+	} else
+		aggr_conn = vif->aggr_cntxt->aggr_conn;
 
-	if (!p_aggr || !p_aggr->aggr_conn)
+	if (!aggr_conn)
 		return;
 
 	tid = ath6kl_get_tid(tid_mux);
 	if (tid >= NUM_OF_TIDS)
 		return;
 
-	aggr_conn = p_aggr->aggr_conn;
 	rxtid = &aggr_conn->rx_tid[tid];
 
 	if (rxtid->aggr)
 		aggr_delete_tid_state(aggr_conn, tid);
 }
 
-void aggr_reset_state(struct aggr_info *aggr_info)
+void aggr_reset_state(struct aggr_info_conn *aggr_conn)
 {
 	u8 tid;
 
-	if (!aggr_info || !aggr_info->aggr_conn)
+	if (!aggr_conn)
 		return;
 
-	if (aggr_info->aggr_conn->timer_scheduled) {
-		del_timer(&aggr_info->aggr_conn->timer);
-		aggr_info->aggr_conn->timer_scheduled = false;
+	if (aggr_conn->timer_scheduled) {
+		del_timer(&aggr_conn->timer);
+		aggr_conn->timer_scheduled = false;
 	}
 
 	for (tid = 0; tid < NUM_OF_TIDS; tid++)
-		aggr_delete_tid_state(aggr_info->aggr_conn, tid);
+		aggr_delete_tid_state(aggr_conn, tid);
 }
 
 /* clean up our amsdu buffer list */
@@ -1768,10 +1792,10 @@ void ath6kl_cleanup_amsdu_rxbufs(struct ath6kl *ar)
 
 void aggr_module_destroy(struct aggr_info *aggr_info)
 {
-	if (!aggr_info || !aggr_info->aggr_conn)
+	if (!aggr_info)
 		return;
 
-	aggr_reset_state(aggr_info);
+	aggr_reset_state(aggr_info->aggr_conn);
 	skb_queue_purge(&aggr_info->rx_amsdu_freeq);
 	kfree(aggr_info->aggr_conn);
 	kfree(aggr_info);
-- 
1.7.0.4

