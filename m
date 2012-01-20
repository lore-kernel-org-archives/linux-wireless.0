Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8436 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab2ATPwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 10:52:24 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 3/6] ath6kl: Define a structure for connection specific aggregation information
Date: Fri, 20 Jan 2012 21:21:59 +0530
Message-ID: <1327074722-3492-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120120_165228_496409_EBFED07C)
In-Reply-To: <1327074722-3492-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1327074722-3492-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch just groups connection specific aggregation information
from struct aggr_info into a new structure (struct aggr_info_conn)
so that, in softAP mode, this can be used when each connected station
is made to have it's own aggregation state.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 drivers/net/wireless/ath/ath6kl/core.h     |   11 ++-
 drivers/net/wireless/ath/ath6kl/txrx.c     |  164 +++++++++++++++++-----------
 3 files changed, 108 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 594d246..8bf447a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2694,7 +2694,7 @@ void ath6kl_cfg80211_stop_all(struct ath6kl *ar)
 
 static int ath6kl_cfg80211_vif_init(struct ath6kl_vif *vif)
 {
-	vif->aggr_cntxt = aggr_init(vif->ndev);
+	vif->aggr_cntxt = aggr_init(vif);
 	if (!vif->aggr_cntxt) {
 		ath6kl_err("failed to initialize aggr\n");
 		return -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 67b22e4..1b9054f 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -242,14 +242,19 @@ struct rxtid_stats {
 	u32 num_bar;
 };
 
-struct aggr_info {
+struct aggr_info_conn {
 	u8 aggr_sz;
 	u8 timer_scheduled;
 	struct timer_list timer;
 	struct net_device *dev;
 	struct rxtid rx_tid[NUM_OF_TIDS];
-	struct sk_buff_head free_q;
 	struct rxtid_stats stat[NUM_OF_TIDS];
+	struct aggr_info *aggr_info;
+};
+
+struct aggr_info {
+	struct aggr_info_conn *aggr_conn;
+	struct sk_buff_head rx_amsdu_freeq;
 };
 
 struct ath6kl_wep_key {
@@ -707,7 +712,7 @@ struct ath6kl_cookie *ath6kl_alloc_cookie(struct ath6kl *ar);
 void ath6kl_free_cookie(struct ath6kl *ar, struct ath6kl_cookie *cookie);
 int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev);
 
-struct aggr_info *aggr_init(struct net_device *dev);
+struct aggr_info *aggr_init(struct ath6kl_vif *vif);
 void ath6kl_rx_refill(struct htc_target *target,
 		      enum htc_endpoint_id endpoint);
 void ath6kl_refill_amsdu_rxbufs(struct ath6kl *ar, int count);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index cb7421a..35ddae3 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -819,10 +819,12 @@ static struct sk_buff *aggr_get_free_skb(struct aggr_info *p_aggr)
 {
 	struct sk_buff *skb = NULL;
 
-	if (skb_queue_len(&p_aggr->free_q) < (AGGR_NUM_OF_FREE_NETBUFS >> 2))
-		ath6kl_alloc_netbufs(&p_aggr->free_q, AGGR_NUM_OF_FREE_NETBUFS);
+	if (skb_queue_len(&p_aggr->rx_amsdu_freeq) <
+	    (AGGR_NUM_OF_FREE_NETBUFS >> 2))
+		ath6kl_alloc_netbufs(&p_aggr->rx_amsdu_freeq,
+				     AGGR_NUM_OF_FREE_NETBUFS);
 
-	skb = skb_dequeue(&p_aggr->free_q);
+	skb = skb_dequeue(&p_aggr->rx_amsdu_freeq);
 
 	return skb;
 }
@@ -998,12 +1000,14 @@ static void aggr_deque_frms(struct aggr_info *p_aggr, u8 tid,
 	struct skb_hold_q *node;
 	u16 idx, idx_end, seq_end;
 	struct rxtid_stats *stats;
+	struct aggr_info_conn *agg_conn;
 
-	if (!p_aggr)
+	if (!p_aggr || !p_aggr->aggr_conn)
 		return;
 
-	rxtid = &p_aggr->rx_tid[tid];
-	stats = &p_aggr->stat[tid];
+	agg_conn = p_aggr->aggr_conn;
+	rxtid = &agg_conn->rx_tid[tid];
+	stats = &agg_conn->stat[tid];
 
 	idx = AGGR_WIN_IDX(rxtid->seq_next, rxtid->hold_q_sz);
 
@@ -1048,7 +1052,7 @@ static void aggr_deque_frms(struct aggr_info *p_aggr, u8 tid,
 	stats->num_delivered += skb_queue_len(&rxtid->q);
 
 	while ((skb = skb_dequeue(&rxtid->q)))
-		ath6kl_deliver_frames_to_nw_stack(p_aggr->dev, skb);
+		ath6kl_deliver_frames_to_nw_stack(agg_conn->dev, skb);
 }
 
 static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
@@ -1062,9 +1066,10 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 	u16 idx, st, cur, end;
 	bool is_queued = false;
 	u16 extended_end;
+	struct aggr_info_conn *agg_conn = agg_info->aggr_conn;
 
-	rxtid = &agg_info->rx_tid[tid];
-	stats = &agg_info->stat[tid];
+	rxtid = &agg_conn->rx_tid[tid];
+	stats = &agg_conn->stat[tid];
 
 	stats->num_into_aggr++;
 
@@ -1074,7 +1079,7 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 			is_queued = true;
 			stats->num_amsdu++;
 			while ((skb = skb_dequeue(&rxtid->q)))
-				ath6kl_deliver_frames_to_nw_stack(agg_info->dev,
+				ath6kl_deliver_frames_to_nw_stack(agg_conn->dev,
 								  skb);
 		}
 		return is_queued;
@@ -1152,7 +1157,7 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 
 	aggr_deque_frms(agg_info, tid, 0, 1);
 
-	if (agg_info->timer_scheduled)
+	if (agg_conn->timer_scheduled)
 		rxtid->progress = true;
 	else
 		for (idx = 0 ; idx < rxtid->hold_q_sz; idx++) {
@@ -1163,8 +1168,8 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 				 * the frame doesn't remain stuck
 				 * forever.
 				 */
-				agg_info->timer_scheduled = true;
-				mod_timer(&agg_info->timer,
+				agg_conn->timer_scheduled = true;
+				mod_timer(&agg_conn->timer,
 					  (jiffies +
 					   HZ * (AGGR_RX_TIMEOUT) / 1000));
 				rxtid->progress = false;
@@ -1525,13 +1530,13 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 static void aggr_timeout(unsigned long arg)
 {
 	u8 i, j;
-	struct aggr_info *p_aggr = (struct aggr_info *) arg;
+	struct aggr_info_conn *aggr_conn = (struct aggr_info_conn *) arg;
 	struct rxtid *rxtid;
 	struct rxtid_stats *stats;
 
 	for (i = 0; i < NUM_OF_TIDS; i++) {
-		rxtid = &p_aggr->rx_tid[i];
-		stats = &p_aggr->stat[i];
+		rxtid = &aggr_conn->rx_tid[i];
+		stats = &aggr_conn->stat[i];
 
 		if (!rxtid->aggr || !rxtid->timer_mon || rxtid->progress)
 			continue;
@@ -1542,18 +1547,18 @@ static void aggr_timeout(unsigned long arg)
 			   rxtid->seq_next,
 			   ((rxtid->seq_next + rxtid->hold_q_sz-1) &
 			    ATH6KL_MAX_SEQ_NO));
-		aggr_deque_frms(p_aggr, i, 0, 0);
+		aggr_deque_frms(aggr_conn->aggr_info, i, 0, 0);
 	}
 
-	p_aggr->timer_scheduled = false;
+	aggr_conn->timer_scheduled = false;
 
 	for (i = 0; i < NUM_OF_TIDS; i++) {
-		rxtid = &p_aggr->rx_tid[i];
+		rxtid = &aggr_conn->rx_tid[i];
 
 		if (rxtid->aggr && rxtid->hold_q) {
 			for (j = 0; j < rxtid->hold_q_sz; j++) {
 				if (rxtid->hold_q[j].skb) {
-					p_aggr->timer_scheduled = true;
+					aggr_conn->timer_scheduled = true;
 					rxtid->timer_mon = true;
 					rxtid->progress = false;
 					break;
@@ -1565,24 +1570,24 @@ static void aggr_timeout(unsigned long arg)
 		}
 	}
 
-	if (p_aggr->timer_scheduled)
-		mod_timer(&p_aggr->timer,
+	if (aggr_conn->timer_scheduled)
+		mod_timer(&aggr_conn->timer,
 			  jiffies + msecs_to_jiffies(AGGR_RX_TIMEOUT));
 }
 
-static void aggr_delete_tid_state(struct aggr_info *p_aggr, u8 tid)
+static void aggr_delete_tid_state(struct aggr_info_conn *aggr_conn, u8 tid)
 {
 	struct rxtid *rxtid;
 	struct rxtid_stats *stats;
 
-	if (!p_aggr || tid >= NUM_OF_TIDS)
+	if (!aggr_conn || tid >= NUM_OF_TIDS)
 		return;
 
-	rxtid = &p_aggr->rx_tid[tid];
-	stats = &p_aggr->stat[tid];
+	rxtid = &aggr_conn->rx_tid[tid];
+	stats = &aggr_conn->stat[tid];
 
 	if (rxtid->aggr)
-		aggr_deque_frms(p_aggr, tid, 0, 0);
+		aggr_deque_frms(aggr_conn->aggr_info, tid, 0, 0);
 
 	rxtid->aggr = false;
 	rxtid->progress = false;
@@ -1601,22 +1606,25 @@ void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
 			     u8 win_sz)
 {
 	struct aggr_info *p_aggr = vif->aggr_cntxt;
+	struct aggr_info_conn *aggr_conn;
 	struct rxtid *rxtid;
 	struct rxtid_stats *stats;
 	u16 hold_q_size;
 
-	if (!p_aggr)
+	if (!p_aggr || !p_aggr->aggr_conn)
 		return;
 
-	rxtid = &p_aggr->rx_tid[tid];
-	stats = &p_aggr->stat[tid];
+	aggr_conn = p_aggr->aggr_conn;
+
+	rxtid = &aggr_conn->rx_tid[tid];
+	stats = &aggr_conn->stat[tid];
 
 	if (win_sz < AGGR_WIN_SZ_MIN || win_sz > AGGR_WIN_SZ_MAX)
 		ath6kl_dbg(ATH6KL_DBG_WLAN_RX, "%s: win_sz %d, tid %d\n",
 			   __func__, win_sz, tid);
 
 	if (rxtid->aggr)
-		aggr_delete_tid_state(p_aggr, tid);
+		aggr_delete_tid_state(aggr_conn, tid);
 
 	rxtid->seq_next = seq_no;
 	hold_q_size = TID_WINDOW_SZ(win_sz) * sizeof(struct skb_hold_q);
@@ -1632,31 +1640,23 @@ void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
 	rxtid->aggr = true;
 }
 
-struct aggr_info *aggr_init(struct net_device *dev)
+static void aggr_conn_init(struct ath6kl_vif *vif,
+			   struct aggr_info_conn *aggr_conn)
 {
-	struct aggr_info *p_aggr = NULL;
 	struct rxtid *rxtid;
 	u8 i;
 
-	p_aggr = kzalloc(sizeof(struct aggr_info), GFP_KERNEL);
-	if (!p_aggr) {
-		ath6kl_err("failed to alloc memory for aggr_node\n");
-		return NULL;
-	}
-
-	p_aggr->aggr_sz = AGGR_SZ_DEFAULT;
-	p_aggr->dev = dev;
-	init_timer(&p_aggr->timer);
-	p_aggr->timer.function = aggr_timeout;
-	p_aggr->timer.data = (unsigned long) p_aggr;
-
-	p_aggr->timer_scheduled = false;
-	skb_queue_head_init(&p_aggr->free_q);
+	aggr_conn->aggr_sz = AGGR_SZ_DEFAULT;
+	aggr_conn->dev = vif->ndev;
+	init_timer(&aggr_conn->timer);
+	aggr_conn->timer.function = aggr_timeout;
+	aggr_conn->timer.data = (unsigned long) aggr_conn;
+	aggr_conn->aggr_info = vif->aggr_cntxt;
 
-	ath6kl_alloc_netbufs(&p_aggr->free_q, AGGR_NUM_OF_FREE_NETBUFS);
+	aggr_conn->timer_scheduled = false;
 
 	for (i = 0; i < NUM_OF_TIDS; i++) {
-		rxtid = &p_aggr->rx_tid[i];
+		rxtid = &aggr_conn->rx_tid[i];
 		rxtid->aggr = false;
 		rxtid->progress = false;
 		rxtid->timer_mon = false;
@@ -1664,6 +1664,30 @@ struct aggr_info *aggr_init(struct net_device *dev)
 		spin_lock_init(&rxtid->lock);
 	}
 
+}
+
+struct aggr_info *aggr_init(struct ath6kl_vif *vif)
+{
+	struct aggr_info *p_aggr = NULL;
+
+	p_aggr = kzalloc(sizeof(struct aggr_info), GFP_KERNEL);
+	if (!p_aggr) {
+		ath6kl_err("failed to alloc memory for aggr_node\n");
+		return NULL;
+	}
+
+	p_aggr->aggr_conn = kzalloc(sizeof(struct aggr_info_conn), GFP_KERNEL);
+	if (!p_aggr->aggr_conn) {
+		ath6kl_err("failed to alloc memory for connection specific aggr info\n");
+		kfree(p_aggr);
+		return NULL;
+	}
+
+	aggr_conn_init(vif, p_aggr->aggr_conn);
+
+	skb_queue_head_init(&p_aggr->rx_amsdu_freeq);
+	ath6kl_alloc_netbufs(&p_aggr->rx_amsdu_freeq, AGGR_NUM_OF_FREE_NETBUFS);
+
 	return p_aggr;
 }
 
@@ -1671,27 +1695,32 @@ void aggr_recv_delba_req_evt(struct ath6kl_vif *vif, u8 tid)
 {
 	struct aggr_info *p_aggr = vif->aggr_cntxt;
 	struct rxtid *rxtid;
+	struct aggr_info_conn *aggr_conn;
 
-	if (!p_aggr)
+	if (!p_aggr || !p_aggr->aggr_conn)
 		return;
 
-	rxtid = &p_aggr->rx_tid[tid];
+	aggr_conn = p_aggr->aggr_conn;
+	rxtid = &aggr_conn->rx_tid[tid];
 
 	if (rxtid->aggr)
-		aggr_delete_tid_state(p_aggr, tid);
+		aggr_delete_tid_state(aggr_conn, tid);
 }
 
 void aggr_reset_state(struct aggr_info *aggr_info)
 {
 	u8 tid;
 
-	if (aggr_info->timer_scheduled) {
-		del_timer(&aggr_info->timer);
-		aggr_info->timer_scheduled = false;
+	if (!aggr_info || !aggr_info->aggr_conn)
+		return;
+
+	if (aggr_info->aggr_conn->timer_scheduled) {
+		del_timer(&aggr_info->aggr_conn->timer);
+		aggr_info->aggr_conn->timer_scheduled = false;
 	}
 
 	for (tid = 0; tid < NUM_OF_TIDS; tid++)
-		aggr_delete_tid_state(aggr_info, tid);
+		aggr_delete_tid_state(aggr_info->aggr_conn, tid);
 }
 
 /* clean up our amsdu buffer list */
@@ -1716,21 +1745,18 @@ void ath6kl_cleanup_amsdu_rxbufs(struct ath6kl *ar)
 	spin_unlock_bh(&ar->lock);
 }
 
-void aggr_module_destroy(struct aggr_info *aggr_info)
+static void ath6kl_cleanup_aggr_conn(struct aggr_info_conn *aggr_conn)
 {
 	struct rxtid *rxtid;
 	u8 i, k;
 
-	if (!aggr_info)
-		return;
-
-	if (aggr_info->timer_scheduled) {
-		del_timer(&aggr_info->timer);
-		aggr_info->timer_scheduled = false;
+	if (aggr_conn->timer_scheduled) {
+		del_timer(&aggr_conn->timer);
+		aggr_conn->timer_scheduled = false;
 	}
 
 	for (i = 0; i < NUM_OF_TIDS; i++) {
-		rxtid = &aggr_info->rx_tid[i];
+		rxtid = &aggr_conn->rx_tid[i];
 		if (rxtid->hold_q) {
 			for (k = 0; k < rxtid->hold_q_sz; k++)
 				dev_kfree_skb(rxtid->hold_q[k].skb);
@@ -1739,7 +1765,15 @@ void aggr_module_destroy(struct aggr_info *aggr_info)
 
 		skb_queue_purge(&rxtid->q);
 	}
+	kfree(aggr_conn);
+}
+
+void aggr_module_destroy(struct aggr_info *aggr_info)
+{
+	if (!aggr_info || !aggr_info->aggr_conn)
+		return;
 
-	skb_queue_purge(&aggr_info->free_q);
+	ath6kl_cleanup_aggr_conn(aggr_info->aggr_conn);
+	skb_queue_purge(&aggr_info->rx_amsdu_freeq);
 	kfree(aggr_info);
 }
-- 
1.7.0.4

