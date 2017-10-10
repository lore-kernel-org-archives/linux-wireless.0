Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:43403 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932100AbdJJOCs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 10:02:48 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [RFC 2/3] ath9k: Move to mac80211 TXQ scheduling API
Date: Tue, 10 Oct 2017 16:02:07 +0200
Message-Id: <20171010140208.1515-2-toke@toke.dk> (sfid-20171010_160341_629286_01B5926E)
In-Reply-To: <20171010140208.1515-1-toke@toke.dk>
References: <20171010140208.1515-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes TXQ scheduling from ath9k and changes it to use the mac80211 TXQ
scheduling API introduced in the previous patch.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |   7 +-
 drivers/net/wireless/ath/ath9k/channel.c |   2 -
 drivers/net/wireless/ath/ath9k/main.c    |   3 +-
 drivers/net/wireless/ath/ath9k/xmit.c    | 181 +++++++------------------------
 4 files changed, 40 insertions(+), 153 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index cf076719c27e..cb8f64864199 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -246,7 +246,6 @@ struct ath_atx_tid {
 	s8 bar_index;
 	bool active;
 	bool clear_ps_filter;
-	bool has_queued;
 };
 
 void __ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
@@ -591,8 +590,7 @@ bool ath_drain_all_txq(struct ath_softc *sc);
 void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq);
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
-void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
-void ath_txq_schedule_all(struct ath_softc *sc);
+void ath_txq_schedule(struct ath_softc *sc);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
@@ -610,7 +608,6 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 
-void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 		       struct ath_node *an);
 void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
@@ -618,7 +615,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 				   u16 tids, int nframes,
 				   enum ieee80211_frame_release_type reason,
 				   bool more_data);
-void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue);
+void ath9k_wake_tx_queue(struct ieee80211_hw *hw);
 
 /********/
 /* VIFs */
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index f0439f2d566b..6dc60fd53a8b 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1595,8 +1595,6 @@ void ath9k_p2p_ps_timer(void *priv)
 	an->sleeping = avp->noa.absent;
 	if (an->sleeping)
 		ath_tx_aggr_sleep(sta, sc, an);
-	else
-		ath_tx_aggr_wakeup(sc, an);
 
 out:
 	rcu_read_unlock();
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8b4ac7f0a09b..1601dd11e460 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -265,7 +265,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		}
 	work:
 		ath_restart_work(sc);
-		ath_txq_schedule_all(sc);
+		ath_txq_schedule(sc);
 	}
 
 	sc->gtt_cnt = 0;
@@ -1619,7 +1619,6 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	case STA_NOTIFY_AWAKE:
 		ath9k_sta_set_tx_filter(sc->sc_ah, an, false);
 		an->sleeping = false;
-		ath_tx_aggr_wakeup(sc, an);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 396bf05c6bf6..609f209a2278 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -150,24 +150,11 @@ void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 }
 
 
-void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
+void ath9k_wake_tx_queue(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_atx_tid *tid = (struct ath_atx_tid *) queue->drv_priv;
-	struct ath_txq *txq = tid->txq;
-
-	ath_dbg(common, QUEUE, "Waking TX queue: %pM (%d)\n",
-		queue->sta ? queue->sta->addr : queue->vif->addr,
-		tid->tidno);
-
-	ath_txq_lock(sc, txq);
-
-	tid->has_queued = true;
-	ath_tx_queue_tid(sc, tid);
-	ath_txq_schedule(sc, txq);
 
-	ath_txq_unlock(sc, txq);
+	ath_txq_schedule(sc);
 }
 
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
@@ -230,14 +217,11 @@ ath_tid_pull(struct ath_atx_tid *tid)
 	struct ath_frame_info *fi;
 	int q;
 
-	if (!tid->has_queued)
-		return NULL;
+	txq->drv_buffered = false;
 
 	skb = ieee80211_tx_dequeue(hw, txq);
-	if (!skb) {
-		tid->has_queued = false;
+	if (!skb)
 		return NULL;
-	}
 
 	if (ath_tx_prepare(hw, skb, &txctl)) {
 		ieee80211_free_txskb(hw, skb);
@@ -254,12 +238,6 @@ ath_tid_pull(struct ath_atx_tid *tid)
 	return skb;
  }
 
-
-static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
-{
-	return !skb_queue_empty(&tid->retry_q) || tid->has_queued;
-}
-
 static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
 {
 	struct sk_buff *skb;
@@ -670,12 +648,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			ieee80211_sta_set_buffered(sta, tid->tidno, true);
 
 		skb_queue_splice_tail(&bf_pending, &tid->retry_q);
-		if (!an->sleeping) {
-			ath_tx_queue_tid(sc, tid);
-
-			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
-				tid->clear_ps_filter = true;
-		}
+		if (!an->sleeping && (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY)))
+			tid->clear_ps_filter = true;
 	}
 
 	if (bar_index >= 0) {
@@ -719,8 +693,6 @@ static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_node *an,
 
 		spin_lock_bh(&acq->lock);
 		an->airtime_deficit[q] -= airtime;
-		if (an->airtime_deficit[q] <= 0)
-			__ath_tx_queue_tid(sc, tid);
 		spin_unlock_bh(&acq->lock);
 	}
 	ath_debug_airtime(sc, an, 0, airtime);
@@ -770,8 +742,6 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	} else
 		ath_tx_complete_aggr(sc, txq, bf, bf_head, sta, tid, ts, txok);
 
-	if (!flush)
-		ath_txq_schedule(sc, txq);
 }
 
 static bool ath_lookup_legacy(struct ath_buf *bf)
@@ -1506,7 +1476,7 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_txq *txq,
 	} while (1);
 }
 
-static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
+static int ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			      struct ath_atx_tid *tid)
 {
 	struct ath_buf *bf;
@@ -1515,21 +1485,18 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	int aggr_len = 0;
 	bool aggr;
 
-	if (!ath_tid_has_buffered(tid))
-		return false;
-
 	INIT_LIST_HEAD(&bf_q);
 
 	bf = ath_tx_get_tid_subframe(sc, txq, tid);
 	if (!bf)
-		return false;
+		return -ENOENT;
 
 	tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
 	aggr = !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 	if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
 	    (!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH)) {
 		__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
-		return false;
+		return -ENOBUFS;
 	}
 
 	ath_set_rates(tid->an->vif, tid->an->sta, bf);
@@ -1539,7 +1506,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		ath_tx_form_burst(sc, txq, tid, &bf_q, bf);
 
 	if (list_empty(&bf_q))
-		return false;
+		return -ENOENT;
 
 	if (tid->clear_ps_filter || tid->an->no_ps_filter) {
 		tid->clear_ps_filter = false;
@@ -1548,7 +1515,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	ath_tx_fill_desc(sc, bf, txq, aggr_len);
 	ath_tx_txqaddbuf(sc, txq, &bf_q, false);
-	return true;
+	return 0;
 }
 
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
@@ -1611,51 +1578,18 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *tid;
-	struct ath_txq *txq;
+	struct ieee80211_txq *queue;
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
+		queue = container_of((void*)tid, struct ieee80211_txq, drv_priv);
 
 		if (!skb_queue_empty(&tid->retry_q))
-			ieee80211_sta_set_buffered(sta, tid->tidno, true);
+			queue->drv_buffered = true;
 
-		list_del_init(&tid->list);
-
-		ath_txq_unlock(sc, txq);
-	}
-}
-
-void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
-{
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_atx_tid *tid;
-	struct ath_txq *txq;
-	int tidno;
-
-	ath_dbg(common, XMIT, "%s called\n", __func__);
-
-	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
-		tid = ath_node_to_tid(an, tidno);
-		txq = tid->txq;
-
-		ath_txq_lock(sc, txq);
-		tid->clear_ps_filter = true;
-		if (ath_tid_has_buffered(tid)) {
-			ath_tx_queue_tid(sc, tid);
-			ath_txq_schedule(sc, txq);
-		}
-		ath_txq_unlock_complete(sc, txq);
 	}
 }
 
@@ -1948,86 +1882,44 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 /* For each acq entry, for each tid, try to schedule packets
  * for transmit until ampdu_depth has reached min Q depth.
  */
-void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
+void ath_txq_schedule(struct ath_softc *sc)
 {
+	struct ieee80211_hw *hw = sc->hw;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_txq *queue;
 	struct ath_atx_tid *tid;
-	struct list_head *tid_list;
-	struct ath_acq *acq;
-	bool active = AIRTIME_ACTIVE(sc->airtime_flags);
+	struct ath_txq *txq;
+	int ret = 0;
 
-	if (txq->mac80211_qnum < 0)
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
 		return;
 
-	if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
+	queue = ieee80211_next_txq(hw);
+	if (!queue)
 		return;
 
-	spin_lock_bh(&sc->chan_lock);
-	rcu_read_lock();
-	acq = &sc->cur_chan->acq[txq->mac80211_qnum];
+	tid = (struct ath_atx_tid *)queue->drv_priv;
+	txq = tid->txq;
 
-	if (sc->cur_chan->stopped)
+	ath_txq_lock(sc, txq);
+	if (txq->mac80211_qnum < 0)
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
+	spin_lock_bh(&sc->chan_lock);
+	rcu_read_lock();
 
+	if (!sc->cur_chan->stopped)
+		ret = ath_tx_sched_aggr(sc, txq, tid);
 
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
-	}
-
-out:
 	rcu_read_unlock();
 	spin_unlock_bh(&sc->chan_lock);
-}
 
-void ath_txq_schedule_all(struct ath_softc *sc)
-{
-	struct ath_txq *txq;
-	int i;
+out:
 
-	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		txq = sc->tx.txq_map[i];
+	if (ret != -ENOENT)
+		ieee80211_schedule_txq(hw, queue);
 
-		spin_lock_bh(&txq->axq_lock);
-		ath_txq_schedule(sc, txq);
-		spin_unlock_bh(&txq->axq_lock);
-	}
+	ath_txq_unlock(sc, txq);
 }
 
 /***********/
@@ -2645,7 +2537,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
-			ath_txq_schedule(sc, txq);
 			break;
 		}
 		bf = list_first_entry(&txq->axq_q, struct ath_buf, list);
@@ -2697,6 +2588,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		ath_tx_process_buffer(sc, txq, &ts, bf, &bf_head);
 	}
 	ath_txq_unlock_complete(sc, txq);
+	ath_txq_schedule(sc);
 }
 
 void ath_tx_tasklet(struct ath_softc *sc)
@@ -2711,6 +2603,7 @@ void ath_tx_tasklet(struct ath_softc *sc)
 			ath_tx_processq(sc, &sc->tx.txq[i]);
 	}
 	rcu_read_unlock();
+	ath_txq_schedule(sc);
 }
 
 void ath_tx_edma_tasklet(struct ath_softc *sc)
@@ -2796,6 +2689,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		ath_txq_unlock_complete(sc, txq);
 	}
 	rcu_read_unlock();
+	ath_txq_schedule(sc);
 }
 
 /*****************/
@@ -2875,7 +2769,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->baw_head  = tid->baw_tail = 0;
 		tid->active	   = false;
 		tid->clear_ps_filter = true;
-		tid->has_queued  = false;
 		__skb_queue_head_init(&tid->retry_q);
 		INIT_LIST_HEAD(&tid->list);
 		acno = TID_TO_WME_AC(tidno);
-- 
2.14.2
