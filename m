Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33677 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120Ab1LNVIU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 16:08:20 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 5/6] ath9k: simplify tx locking
Date: Wed, 14 Dec 2011 22:08:07 +0100
Message-Id: <1323896888-85551-5-git-send-email-nbd@openwrt.org> (sfid-20111214_220827_097867_14C32CB6)
In-Reply-To: <1323896888-85551-4-git-send-email-nbd@openwrt.org>
References: <1323896888-85551-1-git-send-email-nbd@openwrt.org>
 <1323896888-85551-2-git-send-email-nbd@openwrt.org>
 <1323896888-85551-3-git-send-email-nbd@openwrt.org>
 <1323896888-85551-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of releasing and taking back the lock over and over again in the
tx path, hold the lock a bit longer, requiring much fewer lock/unlock pairs.
This makes locking much easier to review and should not have any noticeable
performance/latency impact.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   39 ++++----------------------------
 1 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8f38efb..8766796 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -169,13 +169,11 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	INIT_LIST_HEAD(&bf_head);
 
 	memset(&ts, 0, sizeof(ts));
-	spin_lock_bh(&txq->axq_lock);
 
 	while ((skb = __skb_dequeue(&tid->buf_q))) {
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 
-		spin_unlock_bh(&txq->axq_lock);
 		if (bf && fi->retries) {
 			list_add_tail(&bf->list, &bf_head);
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
@@ -184,7 +182,6 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		} else {
 			ath_tx_send_normal(sc, txq, NULL, skb);
 		}
-		spin_lock_bh(&txq->axq_lock);
 	}
 
 	if (tid->baw_head == tid->baw_tail) {
@@ -192,8 +189,6 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		tid->state &= ~AGGR_CLEANUP;
 	}
 
-	spin_unlock_bh(&txq->axq_lock);
-
 	if (sendbar)
 		ath_send_bar(tid, tid->seq_start);
 }
@@ -254,9 +249,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 		bf = fi->bf;
 
 		if (!bf) {
-			spin_unlock(&txq->axq_lock);
 			ath_tx_complete(sc, skb, ATH_TX_ERROR, txq);
-			spin_lock(&txq->axq_lock);
 			continue;
 		}
 
@@ -265,9 +258,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 		if (fi->retries)
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 
-		spin_unlock(&txq->axq_lock);
 		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
-		spin_lock(&txq->axq_lock);
 	}
 
 	tid->seq_next = tid->seq_start;
@@ -515,9 +506,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			 * complete the acked-ones/xretried ones; update
 			 * block-ack window
 			 */
-			spin_lock_bh(&txq->axq_lock);
 			ath_tx_update_baw(sc, tid, seqno);
-			spin_unlock_bh(&txq->axq_lock);
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
 				memcpy(tx_info->control.rates, rates, sizeof(rates));
@@ -540,9 +529,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				 * run out of tx buf.
 				 */
 				if (!tbf) {
-					spin_lock_bh(&txq->axq_lock);
 					ath_tx_update_baw(sc, tid, seqno);
-					spin_unlock_bh(&txq->axq_lock);
 
 					ath_tx_complete_buf(sc, bf, txq,
 							    &bf_head, ts, 0);
@@ -572,7 +559,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		if (an->sleeping)
 			ieee80211_sta_set_buffered(sta, tid->tidno, true);
 
-		spin_lock_bh(&txq->axq_lock);
 		skb_queue_splice(&bf_pending, &tid->buf_q);
 		if (!an->sleeping) {
 			ath_tx_queue_tid(txq, tid);
@@ -580,7 +566,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			if (ts->ts_status & ATH9K_TXERR_FILT)
 				tid->ac->clear_ps_filter = true;
 		}
-		spin_unlock_bh(&txq->axq_lock);
 	}
 
 	if (tid->state & AGGR_CLEANUP)
@@ -1179,9 +1164,9 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 		txtid->state |= AGGR_CLEANUP;
 	else
 		txtid->state &= ~AGGR_ADDBA_COMPLETE;
-	spin_unlock_bh(&txq->axq_lock);
 
 	ath_tx_flush_tid(sc, txtid);
+	spin_unlock_bh(&txq->axq_lock);
 }
 
 void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
@@ -1423,8 +1408,6 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
 
 static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 			       struct list_head *list, bool retry_tx)
-	__releases(txq->axq_lock)
-	__acquires(txq->axq_lock)
 {
 	struct ath_buf *bf, *lastbf;
 	struct list_head bf_head;
@@ -1451,13 +1434,11 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 		if (bf_is_ampdu_not_probing(bf))
 			txq->axq_ampdu_depth--;
 
-		spin_unlock_bh(&txq->axq_lock);
 		if (bf_isampdu(bf))
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, 0,
 					     retry_tx);
 		else
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
-		spin_lock_bh(&txq->axq_lock);
 	}
 }
 
@@ -1836,7 +1817,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 	struct ath_buf *bf;
 	u8 tidno;
 
-	spin_lock_bh(&txctl->txq->axq_lock);
 	if ((sc->sc_flags & SC_OP_TXAGGR) && txctl->an &&
 		ieee80211_is_data_qos(hdr->frame_control)) {
 		tidno = ieee80211_get_qos_ctl(hdr)[0] &
@@ -1855,7 +1835,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 	} else {
 		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
 		if (!bf)
-			goto out;
+			return;
 
 		bf->bf_state.bfs_paprd = txctl->paprd;
 
@@ -1864,9 +1844,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 
 		ath_tx_send_normal(sc, txctl->txq, tid, skb);
 	}
-
-out:
-	spin_unlock_bh(&txctl->txq->axq_lock);
 }
 
 /* Upon failure caller should free skb */
@@ -1933,9 +1910,11 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		ieee80211_stop_queue(sc->hw, q);
 		txq->stopped = 1;
 	}
-	spin_unlock_bh(&txq->axq_lock);
 
 	ath_tx_start_dma(sc, skb, txctl);
+
+	spin_unlock_bh(&txq->axq_lock);
+
 	return 0;
 }
 
@@ -1981,7 +1960,6 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	q = skb_get_queue_mapping(skb);
 	if (txq == sc->tx.txq_map[q]) {
-		spin_lock_bh(&txq->axq_lock);
 		if (WARN_ON(--txq->pending_frames < 0))
 			txq->pending_frames = 0;
 
@@ -1989,7 +1967,6 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 			ieee80211_wake_queue(sc->hw, q);
 			txq->stopped = 0;
 		}
-		spin_unlock_bh(&txq->axq_lock);
 	}
 
 	ieee80211_tx_status(hw, skb);
@@ -2095,8 +2072,6 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 				  struct ath_tx_status *ts, struct ath_buf *bf,
 				  struct list_head *bf_head)
-	__releases(txq->axq_lock)
-	__acquires(txq->axq_lock)
 {
 	int txok;
 
@@ -2106,16 +2081,12 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	if (bf_is_ampdu_not_probing(bf))
 		txq->axq_ampdu_depth--;
 
-	spin_unlock_bh(&txq->axq_lock);
-
 	if (!bf_isampdu(bf)) {
 		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
 		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
 	} else
 		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok, true);
 
-	spin_lock_bh(&txq->axq_lock);
-
 	if (sc->sc_flags & SC_OP_TXAGGR)
 		ath_txq_schedule(sc, txq);
 }
-- 
1.7.3.2

