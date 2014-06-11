Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52566 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaFKKsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:48:17 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 03/28] ath9k: Move acq to channel context
Date: Wed, 11 Jun 2014 16:17:51 +0530
Message-ID: <1402483696-2498-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124820_925851_96730206)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Add support to maintain per-channel ACs list.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  4 ++-
 drivers/net/wireless/ath/ath9k/channel.c |  4 ++-
 drivers/net/wireless/ath/ath9k/main.c    | 25 ++++++++------
 drivers/net/wireless/ath/ath9k/xmit.c    | 58 +++++++++++++++++++++++---------
 4 files changed, 63 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b6f6444..198cca3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -163,7 +163,6 @@ struct ath_txq {
 	u32 axq_ampdu_depth;
 	bool stopped;
 	bool axq_tx_inprogress;
-	struct list_head axq_acq;
 	struct list_head txq_fifo[ATH_TXFIFO_DEPTH];
 	u8 txq_headidx;
 	u8 txq_tailidx;
@@ -324,6 +323,8 @@ struct ath_rx {
 struct ath_chanctx {
 	struct cfg80211_chan_def chandef;
 	struct list_head vifs;
+	struct list_head acq[IEEE80211_NUM_ACS];
+
 	u16 txpower;
 	bool offchannel;
 };
@@ -348,6 +349,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq);
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
+void ath_txq_schedule_all(struct ath_softc *sc);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 1b40cf5..c8d91df 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -107,7 +107,7 @@ void ath_chanctx_init(struct ath_softc *sc)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
-	int i;
+	int i, j;
 
 	sband = &common->sbands[IEEE80211_BAND_2GHZ];
 	if (!sband->n_channels)
@@ -119,6 +119,8 @@ void ath_chanctx_init(struct ath_softc *sc)
 		cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
 		INIT_LIST_HEAD(&ctx->vifs);
 		ctx->txpower = ATH_TXPOWER_MAX;
+		for (j = 0; j < ARRAY_SIZE(ctx->acq); j++)
+			INIT_LIST_HEAD(&ctx->acq[j]);
 	}
 	sc->cur_chan = &sc->chanctx[0];
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5a9cee4..5f7e0bf 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -63,9 +63,16 @@ static bool ath9k_has_pending_frames(struct ath_softc *sc, struct ath_txq *txq)
 
 	spin_lock_bh(&txq->axq_lock);
 
-	if (txq->axq_depth || !list_empty(&txq->axq_acq))
+	if (txq->axq_depth)
 		pending = true;
 
+	if (txq->mac80211_qnum >= 0) {
+		struct list_head *list;
+
+		list = &sc->cur_chan->acq[txq->mac80211_qnum];
+		if (!list_empty(list))
+			pending = true;
+	}
 	spin_unlock_bh(&txq->axq_lock);
 	return pending;
 }
@@ -219,7 +226,6 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long flags;
-	int i;
 
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
@@ -247,15 +253,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		}
 	work:
 		ath_restart_work(sc);
-
-		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-			if (!ATH_TXQ_SETUP(sc, i))
-				continue;
-
-			spin_lock_bh(&sc->tx.txq[i].axq_lock);
-			ath_txq_schedule(sc, &sc->tx.txq[i]);
-			spin_unlock_bh(&sc->tx.txq[i].axq_lock);
-		}
+		ath_txq_schedule_all(sc);
 	}
 
 	sc->gtt_cnt = 0;
@@ -1035,6 +1033,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	avp->vif = vif;
 
+	/* XXX - will be removed once chanctx ops are added */
+	avp->chanctx = sc->cur_chan;
+	list_add_tail(&avp->list, &sc->cur_chan->vifs);
+
 	an->sc = sc;
 	an->sta = NULL;
 	an->vif = vif;
@@ -1120,6 +1122,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	}
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
+	list_del(&avp->list);
 	sc->nvifs--;
 	sc->tx99_vif = NULL;
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 66acb2c..b2e66d2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -103,9 +103,16 @@ void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
 		ieee80211_tx_status(sc->hw, skb);
 }
 
-static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
+static void ath_tx_queue_tid(struct ath_softc *sc, struct ath_txq *txq,
+			     struct ath_atx_tid *tid)
 {
 	struct ath_atx_ac *ac = tid->ac;
+	struct list_head *list;
+	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
+	struct ath_chanctx *ctx = avp->chanctx;
+
+	if (!ctx)
+		return;
 
 	if (tid->sched)
 		return;
@@ -117,7 +124,9 @@ static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 		return;
 
 	ac->sched = true;
-	list_add_tail(&ac->list, &txq->axq_acq);
+
+	list = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
+	list_add_tail(&ac->list, list);
 }
 
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
@@ -626,7 +635,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		skb_queue_splice_tail(&bf_pending, &tid->retry_q);
 		if (!an->sleeping) {
-			ath_tx_queue_tid(txq, tid);
+			ath_tx_queue_tid(sc, txq, tid);
 
 			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 				tid->ac->clear_ps_filter = true;
@@ -1483,7 +1492,7 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 		ac->clear_ps_filter = true;
 
 		if (ath_tid_has_buffered(tid)) {
-			ath_tx_queue_tid(txq, tid);
+			ath_tx_queue_tid(sc, txq, tid);
 			ath_txq_schedule(sc, txq);
 		}
 
@@ -1507,7 +1516,7 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
 	tid->baw_size = IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
 
 	if (ath_tid_has_buffered(tid)) {
-		ath_tx_queue_tid(txq, tid);
+		ath_tx_queue_tid(sc, txq, tid);
 		ath_txq_schedule(sc, txq);
 	}
 
@@ -1642,7 +1651,6 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_link = NULL;
 		__skb_queue_head_init(&txq->complete_q);
 		INIT_LIST_HEAD(&txq->axq_q);
-		INIT_LIST_HEAD(&txq->axq_acq);
 		spin_lock_init(&txq->axq_lock);
 		txq->axq_depth = 0;
 		txq->axq_ampdu_depth = 0;
@@ -1804,7 +1812,7 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 	sc->tx.txqsetup &= ~(1<<txq->axq_qnum);
 }
 
-/* For each axq_acq entry, for each tid, try to schedule packets
+/* For each acq entry, for each tid, try to schedule packets
  * for transmit until ampdu_depth has reached min Q depth.
  */
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
@@ -1812,19 +1820,25 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_ac *ac, *last_ac;
 	struct ath_atx_tid *tid, *last_tid;
+	struct list_head *ac_list;
 	bool sent = false;
 
+	if (txq->mac80211_qnum < 0)
+		return;
+
+	ac_list = &sc->cur_chan->acq[txq->mac80211_qnum];
+
 	if (test_bit(ATH_OP_HW_RESET, &common->op_flags) ||
-	    list_empty(&txq->axq_acq))
+	    list_empty(ac_list))
 		return;
 
 	rcu_read_lock();
 
-	last_ac = list_entry(txq->axq_acq.prev, struct ath_atx_ac, list);
-	while (!list_empty(&txq->axq_acq)) {
+	last_ac = list_entry(ac_list->prev, struct ath_atx_ac, list);
+	while (!list_empty(ac_list)) {
 		bool stop = false;
 
-		ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
+		ac = list_first_entry(ac_list, struct ath_atx_ac, list);
 		last_tid = list_entry(ac->tid_q.prev, struct ath_atx_tid, list);
 		list_del(&ac->list);
 		ac->sched = false;
@@ -1844,7 +1858,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 			 * are pending for the tid
 			 */
 			if (ath_tid_has_buffered(tid))
-				ath_tx_queue_tid(txq, tid);
+				ath_tx_queue_tid(sc, txq, tid);
 
 			if (stop || tid == last_tid)
 				break;
@@ -1852,7 +1866,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 
 		if (!list_empty(&ac->tid_q) && !ac->sched) {
 			ac->sched = true;
-			list_add_tail(&ac->list, &txq->axq_acq);
+			list_add_tail(&ac->list, ac_list);
 		}
 
 		if (stop)
@@ -1863,7 +1877,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 				break;
 
 			sent = false;
-			last_ac = list_entry(txq->axq_acq.prev,
+			last_ac = list_entry(ac_list->prev,
 					     struct ath_atx_ac, list);
 		}
 	}
@@ -1871,6 +1885,20 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	rcu_read_unlock();
 }
 
+void ath_txq_schedule_all(struct ath_softc *sc)
+{
+	struct ath_txq *txq;
+	int i;
+
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		txq = sc->tx.txq_map[i];
+
+		spin_lock_bh(&txq->axq_lock);
+		ath_txq_schedule(sc, txq);
+		spin_unlock_bh(&txq->axq_lock);
+	}
+}
+
 /***********/
 /* TX, DMA */
 /***********/
@@ -2198,7 +2226,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		TX_STAT_INC(txq->axq_qnum, a_queued_sw);
 		__skb_queue_tail(&tid->buf_q, skb);
 		if (!txctl->an->sleeping)
-			ath_tx_queue_tid(txq, tid);
+			ath_tx_queue_tid(sc, txq, tid);
 
 		ath_txq_schedule(sc, txq);
 		goto out;
-- 
2.0.0

