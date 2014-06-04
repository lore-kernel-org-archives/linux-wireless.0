Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17988 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaFDNr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:47:28 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 03/13] ath9k: Move acq to channel context
Date: Wed, 4 Jun 2014 19:16:29 +0530
Message-ID: <1401889599-412-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154738_956637_2C6389C4)
In-Reply-To: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Add support to maintain per-channel ACs list.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 ++-
 drivers/net/wireless/ath/ath9k/channel.c |  4 +++-
 drivers/net/wireless/ath/ath9k/main.c    | 14 ++++++++++-
 drivers/net/wireless/ath/ath9k/xmit.c    | 41 ++++++++++++++++++++------------
 4 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 840cdf9..4906c55 100644
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
index 5a9cee4..9a2177d 100644
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
@@ -1035,6 +1042,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	avp->vif = vif;
 
+	/* XXX - will be removed once chanctx ops are added */
+	avp->chanctx = sc->cur_chan;
+	list_add_tail(&avp->list, &sc->cur_chan->vifs);
+
 	an->sc = sc;
 	an->sta = NULL;
 	an->vif = vif;
@@ -1120,6 +1131,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	}
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
+	list_del(&avp->list);
 	sc->nvifs--;
 	sc->tx99_vif = NULL;
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 66acb2c..a84fe1a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -103,9 +103,13 @@ void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
 		ieee80211_tx_status(sc->hw, skb);
 }
 
-static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
+static void ath_tx_queue_tid(struct ath_softc *sc, struct ath_txq *txq,
+			     struct ath_atx_tid *tid)
 {
+	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
+	struct ath_chanctx *ctx = avp->chanctx;
 	struct ath_atx_ac *ac = tid->ac;
+	struct list_head *list;
 
 	if (tid->sched)
 		return;
@@ -117,7 +121,9 @@ static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 		return;
 
 	ac->sched = true;
-	list_add_tail(&ac->list, &txq->axq_acq);
+
+	list = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
+	list_add_tail(&ac->list, list);
 }
 
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
@@ -626,7 +632,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		skb_queue_splice_tail(&bf_pending, &tid->retry_q);
 		if (!an->sleeping) {
-			ath_tx_queue_tid(txq, tid);
+			ath_tx_queue_tid(sc, txq, tid);
 
 			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 				tid->ac->clear_ps_filter = true;
@@ -1483,7 +1489,7 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 		ac->clear_ps_filter = true;
 
 		if (ath_tid_has_buffered(tid)) {
-			ath_tx_queue_tid(txq, tid);
+			ath_tx_queue_tid(sc, txq, tid);
 			ath_txq_schedule(sc, txq);
 		}
 
@@ -1507,7 +1513,7 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
 	tid->baw_size = IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
 
 	if (ath_tid_has_buffered(tid)) {
-		ath_tx_queue_tid(txq, tid);
+		ath_tx_queue_tid(sc, txq, tid);
 		ath_txq_schedule(sc, txq);
 	}
 
@@ -1642,7 +1648,6 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_link = NULL;
 		__skb_queue_head_init(&txq->complete_q);
 		INIT_LIST_HEAD(&txq->axq_q);
-		INIT_LIST_HEAD(&txq->axq_acq);
 		spin_lock_init(&txq->axq_lock);
 		txq->axq_depth = 0;
 		txq->axq_ampdu_depth = 0;
@@ -1804,7 +1809,7 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 	sc->tx.txqsetup &= ~(1<<txq->axq_qnum);
 }
 
-/* For each axq_acq entry, for each tid, try to schedule packets
+/* For each acq entry, for each tid, try to schedule packets
  * for transmit until ampdu_depth has reached min Q depth.
  */
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
@@ -1812,19 +1817,25 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
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
@@ -1844,7 +1855,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 			 * are pending for the tid
 			 */
 			if (ath_tid_has_buffered(tid))
-				ath_tx_queue_tid(txq, tid);
+				ath_tx_queue_tid(sc, txq, tid);
 
 			if (stop || tid == last_tid)
 				break;
@@ -1852,7 +1863,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 
 		if (!list_empty(&ac->tid_q) && !ac->sched) {
 			ac->sched = true;
-			list_add_tail(&ac->list, &txq->axq_acq);
+			list_add_tail(&ac->list, ac_list);
 		}
 
 		if (stop)
@@ -1863,7 +1874,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 				break;
 
 			sent = false;
-			last_ac = list_entry(txq->axq_acq.prev,
+			last_ac = list_entry(ac_list->prev,
 					     struct ath_atx_ac, list);
 		}
 	}
@@ -2198,7 +2209,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		TX_STAT_INC(txq->axq_qnum, a_queued_sw);
 		__skb_queue_tail(&tid->buf_q, skb);
 		if (!txctl->an->sleeping)
-			ath_tx_queue_tid(txq, tid);
+			ath_tx_queue_tid(sc, txq, tid);
 
 		ath_txq_schedule(sc, txq);
 		goto out;
-- 
2.0.0

