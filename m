Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:48189 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932770AbeGIQhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 12:37:09 -0400
Subject: [RFC v2 4/4] ath9k: Switch to mac80211 TXQ scheduling and airtime
 APIs
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Date: Mon, 09 Jul 2018 18:37:05 +0200
Message-ID: <153115422517.7447.43763883719180480.stgit@alrua-x1> (sfid-20180709_183720_570282_2008F372)
In-Reply-To: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves the ath9k driver to use the mac80211 TXQ scheduling and
airtime accounting APIs, removing the corresponding state tracking
inside the driver.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h     |   14 --
 drivers/net/wireless/ath/ath9k/debug.c     |    3 
 drivers/net/wireless/ath/ath9k/debug.h     |    8 -
 drivers/net/wireless/ath/ath9k/debug_sta.c |   54 ------
 drivers/net/wireless/ath/ath9k/init.c      |    3 
 drivers/net/wireless/ath/ath9k/recv.c      |    9 -
 drivers/net/wireless/ath/ath9k/xmit.c      |  245 ++++++++--------------------
 7 files changed, 76 insertions(+), 260 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ef0de4f1312c..f01aedfef24f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -112,8 +112,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_TXFIFO_DEPTH           8
 #define ATH_TX_ERROR               0x01
 
-#define ATH_AIRTIME_QUANTUM        300 /* usec */
-
 /* Stop tx traffic 1ms before the GO goes away */
 #define ATH_P2P_PS_STOP_TIME       1000
 
@@ -246,10 +244,8 @@ struct ath_atx_tid {
 	s8 bar_index;
 	bool active;
 	bool clear_ps_filter;
-	bool has_queued;
 };
 
-void __ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
 void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
 
 struct ath_node {
@@ -263,12 +259,9 @@ struct ath_node {
 
 	bool sleeping;
 	bool no_ps_filter;
-	s64 airtime_deficit[IEEE80211_NUM_ACS];
-	u32 airtime_rx_start;
 
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
-	struct ath_airtime_stats airtime_stats;
 #endif
 	u8 key_idx[4];
 
@@ -986,11 +979,6 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 
 #define ATH9K_NUM_CHANCTX  2 /* supports 2 operating channels */
 
-#define AIRTIME_USE_TX		BIT(0)
-#define AIRTIME_USE_RX		BIT(1)
-#define AIRTIME_USE_NEW_QUEUES	BIT(2)
-#define AIRTIME_ACTIVE(flags) (!!(flags & (AIRTIME_USE_TX|AIRTIME_USE_RX)))
-
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -1034,8 +1022,6 @@ struct ath_softc {
 	short nbcnvifs;
 	unsigned long ps_usecount;
 
-	u16 airtime_flags; /* AIRTIME_* */
-
 	struct ath_rx rx;
 	struct ath_tx tx;
 	struct ath_beacon beacon;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index f685843a2ff3..ce62da4840e2 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1456,9 +1456,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 #endif
 	debugfs_create_file("tpc", 0600, sc->debug.debugfs_phy, sc, &fops_tpc);
 
-	debugfs_create_u16("airtime_flags", 0600,
-			   sc->debug.debugfs_phy, &sc->airtime_flags);
-
 	debugfs_create_file("nf_override", 0600,
 			    sc->debug.debugfs_phy, sc, &fops_nf_override);
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 249f8141cd00..559d9628f280 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -319,20 +319,12 @@ ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause)
 void ath_debug_rate_stats(struct ath_softc *sc,
 			  struct ath_rx_status *rs,
 			  struct sk_buff *skb);
-void ath_debug_airtime(struct ath_softc *sc,
-		       struct ath_node *an,
-		       u32 rx, u32 tx);
 #else
 static inline void ath_debug_rate_stats(struct ath_softc *sc,
 					struct ath_rx_status *rs,
 					struct sk_buff *skb)
 {
 }
-static inline void ath_debug_airtime(struct ath_softc *sc,
-			      struct ath_node *an,
-			      u32 rx, u32 tx)
-{
-}
 #endif /* CONFIG_ATH9K_STATION_STATISTICS */
 
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index a6f45f1bb5bb..bb6f3250aa30 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -242,59 +242,6 @@ static const struct file_operations fops_node_recv = {
 	.llseek = default_llseek,
 };
 
-void ath_debug_airtime(struct ath_softc *sc,
-		struct ath_node *an,
-		u32 rx,
-		u32 tx)
-{
-	struct ath_airtime_stats *astats = &an->airtime_stats;
-
-	astats->rx_airtime += rx;
-	astats->tx_airtime += tx;
-}
-
-static ssize_t read_airtime(struct file *file, char __user *user_buf,
-			size_t count, loff_t *ppos)
-{
-	struct ath_node *an = file->private_data;
-	struct ath_airtime_stats *astats;
-	static const char *qname[4] = {
-		"VO", "VI", "BE", "BK"
-	};
-	u32 len = 0, size = 256;
-	char *buf;
-	size_t retval;
-	int i;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	astats = &an->airtime_stats;
-
-	len += scnprintf(buf + len, size - len, "RX: %u us\n", astats->rx_airtime);
-	len += scnprintf(buf + len, size - len, "TX: %u us\n", astats->tx_airtime);
-	len += scnprintf(buf + len, size - len, "Deficit: ");
-	for (i = 0; i < 4; i++)
-		len += scnprintf(buf+len, size - len, "%s: %lld us ", qname[i], an->airtime_deficit[i]);
-	if (len < size)
-		buf[len++] = '\n';
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-}
-
-
-static const struct file_operations fops_airtime = {
-	.read = read_airtime,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-
 void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 			   struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
@@ -304,5 +251,4 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 
 	debugfs_create_file("node_aggr", 0444, dir, an, &fops_node_aggr);
 	debugfs_create_file("node_recv", 0444, dir, an, &fops_node_recv);
-	debugfs_create_file("airtime", 0444, dir, an, &fops_airtime);
 }
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c070a9e51ebf..45a31f8a1514 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -676,8 +676,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 	/* Will be cleared in ath9k_start() */
 	set_bit(ATH_OP_INVALID, &common->op_flags);
-	sc->airtime_flags = (AIRTIME_USE_TX | AIRTIME_USE_RX |
-			     AIRTIME_USE_NEW_QUEUES);
 
 	sc->sc_ah = ah;
 	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
@@ -1013,6 +1011,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 }
 
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a8ac42c96d71..fef8fbe12f45 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1054,14 +1054,7 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 						len, rxs->rate_idx, is_sp);
 	}
 
- 	if (!!(sc->airtime_flags & AIRTIME_USE_RX)) {
-		spin_lock_bh(&acq->lock);
-		an->airtime_deficit[acno] -= airtime;
-		if (an->airtime_deficit[acno] <= 0)
-			__ath_tx_queue_tid(sc, ATH_AN_2_TID(an, tidno));
-		spin_unlock_bh(&acq->lock);
-	}
-	ath_debug_airtime(sc, an, airtime, 0);
+	ieee80211_sta_register_airtime(sta, tidno, 0, airtime);
 exit:
 	rcu_read_unlock();
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7fdb152be0bb..5b6a1e3c3f24 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -112,44 +112,14 @@ void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
 		ath_tx_status(hw, skb);
 }
 
-void __ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
-{
-	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
-	struct ath_chanctx *ctx = avp->chanctx;
-	struct ath_acq *acq;
-	struct list_head *tid_list;
-	u8 acno = TID_TO_WME_AC(tid->tidno);
-
-	if (!ctx || !list_empty(&tid->list))
-		return;
-
-
-	acq = &ctx->acq[acno];
-	if ((sc->airtime_flags & AIRTIME_USE_NEW_QUEUES) &&
-	    tid->an->airtime_deficit[acno] > 0)
-		tid_list = &acq->acq_new;
-	else
-		tid_list = &acq->acq_old;
-
-	list_add_tail(&tid->list, tid_list);
-}
-
 void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
-	struct ath_chanctx *ctx = avp->chanctx;
-	struct ath_acq *acq;
+	struct ieee80211_txq *queue =
+		container_of((void *)tid, struct ieee80211_txq, drv_priv);
 
-	if (!ctx || !list_empty(&tid->list))
-		return;
-
-	acq = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
-	spin_lock_bh(&acq->lock);
-	__ath_tx_queue_tid(sc, tid);
-	spin_unlock_bh(&acq->lock);
+	ieee80211_schedule_txq(sc->hw, queue, true);
 }
 
-
 void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
 {
 	struct ath_softc *sc = hw->priv;
@@ -162,11 +132,7 @@ void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
 		tid->tidno);
 
 	ath_txq_lock(sc, txq);
-
-	tid->has_queued = true;
-	ath_tx_queue_tid(sc, tid);
 	ath_txq_schedule(sc, txq);
-
 	ath_txq_unlock(sc, txq);
 }
 
@@ -216,8 +182,8 @@ ath_get_skb_tid(struct ath_softc *sc, struct ath_node *an, struct sk_buff *skb)
 	return ATH_AN_2_TID(an, tidno);
 }
 
-static struct sk_buff *
-ath_tid_pull(struct ath_atx_tid *tid)
+static int
+ath_tid_pull(struct ath_atx_tid *tid, struct sk_buff **skbuf)
 {
 	struct ieee80211_txq *txq = container_of((void*)tid, struct ieee80211_txq, drv_priv);
 	struct ath_softc *sc = tid->an->sc;
@@ -228,20 +194,16 @@ ath_tid_pull(struct ath_atx_tid *tid)
 	};
 	struct sk_buff *skb;
 	struct ath_frame_info *fi;
-	int q;
-
-	if (!tid->has_queued)
-		return NULL;
+	int q, ret;
 
 	skb = ieee80211_tx_dequeue(hw, txq);
-	if (!skb) {
-		tid->has_queued = false;
-		return NULL;
-	}
+	if (!skb)
+		return -ENOENT;
 
-	if (ath_tx_prepare(hw, skb, &txctl)) {
+	ret = ath_tx_prepare(hw, skb, &txctl);
+	if (ret) {
 		ieee80211_free_txskb(hw, skb);
-		return NULL;
+		return ret;
 	}
 
 	q = skb_get_queue_mapping(skb);
@@ -251,24 +213,19 @@ ath_tid_pull(struct ath_atx_tid *tid)
 		++tid->txq->pending_frames;
 	}
 
-	return skb;
-}
-
-
-static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
-{
-	return !skb_queue_empty(&tid->retry_q) || tid->has_queued;
+	*skbuf = skb;
+	return 0;
 }
 
-static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
+static int ath_tid_dequeue(struct ath_atx_tid *tid,
+			   struct sk_buff **skb)
 {
-	struct sk_buff *skb;
-
-	skb = __skb_dequeue(&tid->retry_q);
-	if (!skb)
-		skb = ath_tid_pull(tid);
+	int ret = 0;
+	*skb = __skb_dequeue(&tid->retry_q);
+	if (!*skb)
+		ret = ath_tid_pull(tid, skb);
 
-	return skb;
+	return ret;
 }
 
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
@@ -356,11 +313,12 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 	struct list_head bf_head;
 	struct ath_tx_status ts;
 	struct ath_frame_info *fi;
+	int ret;
 
 	memset(&ts, 0, sizeof(ts));
 	INIT_LIST_HEAD(&bf_head);
 
-	while ((skb = ath_tid_dequeue(tid))) {
+	while ((ret = ath_tid_dequeue(tid, &skb)) == 0) {
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 
@@ -672,7 +630,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		skb_queue_splice_tail(&bf_pending, &tid->retry_q);
 		if (!an->sleeping) {
 			ath_tx_queue_tid(sc, tid);
-
 			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 				tid->clear_ps_filter = true;
 		}
@@ -699,11 +656,11 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
     return bf_isampdu(bf) && !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
 }
 
-static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_node *an,
-				 struct ath_atx_tid *tid, struct ath_buf *bf,
+static void ath_tx_count_airtime(struct ath_softc *sc,
+				 struct ieee80211_sta *sta,
+				 struct ath_buf *bf,
 				 struct ath_tx_status *ts)
 {
-	struct ath_txq *txq = tid->txq;
 	u32 airtime = 0;
 	int i;
 
@@ -713,17 +670,7 @@ static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_node *an,
 		airtime += rate_dur * bf->rates[i].count;
 	}
 
-	if (sc->airtime_flags & AIRTIME_USE_TX) {
-		int q = txq->mac80211_qnum;
-		struct ath_acq *acq = &sc->cur_chan->acq[q];
-
-		spin_lock_bh(&acq->lock);
-		an->airtime_deficit[q] -= airtime;
-		if (an->airtime_deficit[q] <= 0)
-			__ath_tx_queue_tid(sc, tid);
-		spin_unlock_bh(&acq->lock);
-	}
-	ath_debug_airtime(sc, an, 0, airtime);
+	ieee80211_sta_register_airtime(sta, ts->tid, airtime, 0);
 }
 
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
@@ -753,7 +700,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	if (sta) {
 		struct ath_node *an = (struct ath_node *)sta->drv_priv;
 		tid = ath_get_skb_tid(sc, an, bf->bf_mpdu);
-		ath_tx_count_airtime(sc, an, tid, bf, ts);
+		ath_tx_count_airtime(sc, sta, bf, ts);
 		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 			tid->clear_ps_filter = true;
 	}
@@ -937,20 +884,21 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	return ndelim;
 }
 
-static struct ath_buf *
+static int
 ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
-			struct ath_atx_tid *tid)
+			struct ath_atx_tid *tid, struct ath_buf **buf)
 {
 	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
-	struct sk_buff *skb, *first_skb = NULL;
 	struct ath_buf *bf;
+	struct sk_buff *skb, *first_skb = NULL;
 	u16 seqno;
+	int ret;
 
 	while (1) {
-		skb = ath_tid_dequeue(tid);
-		if (!skb)
-			break;
+		ret = ath_tid_dequeue(tid, &skb);
+		if (ret < 0)
+			return ret;
 
 		fi = get_frame_info(skb);
 		bf = fi->bf;
@@ -981,7 +929,7 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 
 		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
 			bf->bf_state.bf_type = 0;
-			return bf;
+			break;
 		}
 
 		bf->bf_state.bf_type = BUF_AMPDU | BUF_AGGR;
@@ -1000,7 +948,7 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 					first_skb = skb;
 				continue;
 			}
-			break;
+			return -EINPROGRESS;
 		}
 
 		if (tid->bar_index > ATH_BA_INDEX(tid->seq_start, seqno)) {
@@ -1014,10 +962,11 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 			continue;
 		}
 
-		return bf;
+		break;
 	}
 
-	return NULL;
+	*buf = bf;
+	return 0;
 }
 
 static int
@@ -1027,7 +976,7 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_txq *txq,
 {
 #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
 	struct ath_buf *bf = bf_first, *bf_prev = NULL;
-	int nframes = 0, ndelim;
+	int nframes = 0, ndelim, ret;
 	u16 aggr_limit = 0, al = 0, bpad = 0,
 	    al_delta, h_baw = tid->baw_size / 2;
 	struct ieee80211_tx_info *tx_info;
@@ -1081,7 +1030,9 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		bf_prev = bf;
 
-		bf = ath_tx_get_tid_subframe(sc, txq, tid);
+		ret = ath_tx_get_tid_subframe(sc, txq, tid, &bf);
+		if (ret < 0)
+			break;
 	}
 	goto finish;
 stop:
@@ -1478,7 +1429,7 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_txq *txq,
 		  struct ath_buf *bf_first)
 {
 	struct ath_buf *bf = bf_first, *bf_prev = NULL;
-	int nframes = 0;
+	int nframes = 0, ret;
 
 	do {
 		struct ieee80211_tx_info *tx_info;
@@ -1492,8 +1443,8 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_txq *txq,
 		if (nframes >= 2)
 			break;
 
-		bf = ath_tx_get_tid_subframe(sc, txq, tid);
-		if (!bf)
+		ret = ath_tx_get_tid_subframe(sc, txq, tid, &bf);
+		if (ret < 0)
 			break;
 
 		tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
@@ -1506,30 +1457,27 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_txq *txq,
 	} while (1);
 }
 
-static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
-			      struct ath_atx_tid *tid)
+static int ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
+			     struct ath_atx_tid *tid)
 {
-	struct ath_buf *bf;
+	struct ath_buf *bf = NULL;
 	struct ieee80211_tx_info *tx_info;
 	struct list_head bf_q;
-	int aggr_len = 0;
+	int aggr_len = 0, ret;
 	bool aggr;
 
-	if (!ath_tid_has_buffered(tid))
-		return false;
-
 	INIT_LIST_HEAD(&bf_q);
 
-	bf = ath_tx_get_tid_subframe(sc, txq, tid);
-	if (!bf)
-		return false;
+	ret = ath_tx_get_tid_subframe(sc, txq, tid, &bf);
+	if (ret < 0)
+		return ret;
 
 	tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
 	aggr = !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 	if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
 	    (!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH)) {
 		__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
-		return false;
+		return -EBUSY;
 	}
 
 	ath_set_rates(tid->an->vif, tid->an->sta, bf);
@@ -1539,7 +1487,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		ath_tx_form_burst(sc, txq, tid, &bf_q, bf);
 
 	if (list_empty(&bf_q))
-		return false;
+		return -EAGAIN;
 
 	if (tid->clear_ps_filter || tid->an->no_ps_filter) {
 		tid->clear_ps_filter = false;
@@ -1548,7 +1496,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	ath_tx_fill_desc(sc, bf, txq, aggr_len);
 	ath_tx_txqaddbuf(sc, txq, &bf_q, false);
-	return true;
+	return 0;
 }
 
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
@@ -1611,28 +1559,16 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *tid;
-	struct ath_txq *txq;
 	int tidno;
 
 	ath_dbg(common, XMIT, "%s called\n", __func__);
 
 	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid = ath_node_to_tid(an, tidno);
-		txq = tid->txq;
-
-		ath_txq_lock(sc, txq);
-
-		if (list_empty(&tid->list)) {
-			ath_txq_unlock(sc, txq);
-			continue;
-		}
 
 		if (!skb_queue_empty(&tid->retry_q))
 			ieee80211_sta_set_buffered(sta, tid->tidno, true);
 
-		list_del_init(&tid->list);
-
-		ath_txq_unlock(sc, txq);
 	}
 }
 
@@ -1651,11 +1587,12 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 
 		ath_txq_lock(sc, txq);
 		tid->clear_ps_filter = true;
-		if (ath_tid_has_buffered(tid)) {
+		if (!skb_queue_empty(&tid->retry_q)) {
 			ath_tx_queue_tid(sc, tid);
 			ath_txq_schedule(sc, txq);
 		}
 		ath_txq_unlock_complete(sc, txq);
+
 	}
 }
 
@@ -1670,9 +1607,9 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 	struct ath_txq *txq = sc->tx.uapsdq;
 	struct ieee80211_tx_info *info;
 	struct list_head bf_q;
-	struct ath_buf *bf_tail = NULL, *bf;
+	struct ath_buf *bf_tail = NULL, *bf = NULL;
 	int sent = 0;
-	int i;
+	int i, ret;
 
 	INIT_LIST_HEAD(&bf_q);
 	for (i = 0; tids && nframes; i++, tids >>= 1) {
@@ -1685,8 +1622,9 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 
 		ath_txq_lock(sc, tid->txq);
 		while (nframes > 0) {
-			bf = ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid);
-			if (!bf)
+			ret = ath_tx_get_tid_subframe(sc, sc->tx.uapsdq,
+						      tid, &bf);
+			if (ret < 0)
 				break;
 
 			list_add_tail(&bf->list, &bf_q);
@@ -1950,11 +1888,12 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
  */
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
+	struct ieee80211_hw *hw = sc->hw;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_txq *queue;
 	struct ath_atx_tid *tid;
-	struct list_head *tid_list;
-	struct ath_acq *acq;
-	bool active = AIRTIME_ACTIVE(sc->airtime_flags);
+	bool first = true;
+	int ret;
 
 	if (txq->mac80211_qnum < 0)
 		return;
@@ -1964,51 +1903,19 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 
 	spin_lock_bh(&sc->chan_lock);
 	rcu_read_lock();
-	acq = &sc->cur_chan->acq[txq->mac80211_qnum];
 
 	if (sc->cur_chan->stopped)
 		goto out;
 
-begin:
-	tid_list = &acq->acq_new;
-	if (list_empty(tid_list)) {
-		tid_list = &acq->acq_old;
-		if (list_empty(tid_list))
-			goto out;
-	}
-	tid = list_first_entry(tid_list, struct ath_atx_tid, list);
-
-	if (active && tid->an->airtime_deficit[txq->mac80211_qnum] <= 0) {
-		spin_lock_bh(&acq->lock);
-		tid->an->airtime_deficit[txq->mac80211_qnum] += ATH_AIRTIME_QUANTUM;
-		list_move_tail(&tid->list, &acq->acq_old);
-		spin_unlock_bh(&acq->lock);
-		goto begin;
-	}
-
-	if (!ath_tid_has_buffered(tid)) {
-		spin_lock_bh(&acq->lock);
-		if ((tid_list == &acq->acq_new) && !list_empty(&acq->acq_old))
-			list_move_tail(&tid->list, &acq->acq_old);
-		else {
-			list_del_init(&tid->list);
-		}
-		spin_unlock_bh(&acq->lock);
-		goto begin;
-	}
+	while ((queue = ieee80211_next_txq(hw, txq->mac80211_qnum, first))) {
+		tid = (struct ath_atx_tid *)queue->drv_priv;
+		first = false;
 
+		ret = ath_tx_sched_aggr(sc, txq, tid);
+		ath_dbg(common, QUEUE, "ath_tx_sched_aggr returned %d\n", ret);
 
-	/*
-	 * If we succeed in scheduling something, immediately restart to make
-	 * sure we keep the HW busy.
-	 */
-	if(ath_tx_sched_aggr(sc, txq, tid)) {
-		if (!active) {
-			spin_lock_bh(&acq->lock);
-			list_move_tail(&tid->list, &acq->acq_old);
-			spin_unlock_bh(&acq->lock);
-		}
-		goto begin;
+		if (ret != -ENOENT)
+			ieee80211_schedule_txq(hw, queue, (ret == 0));
 	}
 
 out:
@@ -2863,9 +2770,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	struct ath_atx_tid *tid;
 	int tidno, acno;
 
-	for (acno = 0; acno < IEEE80211_NUM_ACS; acno++)
-		an->airtime_deficit[acno] = ATH_AIRTIME_QUANTUM;
-
 	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid = ath_node_to_tid(an, tidno);
 		tid->an        = an;
@@ -2875,7 +2779,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->baw_head  = tid->baw_tail = 0;
 		tid->active	   = false;
 		tid->clear_ps_filter = true;
-		tid->has_queued  = false;
 		__skb_queue_head_init(&tid->retry_q);
 		INIT_LIST_HEAD(&tid->list);
 		acno = TID_TO_WME_AC(tidno);
