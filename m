Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:40682
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933446AbbGVLGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 07:06:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/3] ath9k: remove struct ath_atx_ac
Date: Wed, 22 Jul 2015 13:06:13 +0200
Message-Id: <1437563174-94761-2-git-send-email-nbd@openwrt.org> (sfid-20150722_130625_413564_BE797BED)
In-Reply-To: <1437563174-94761-1-git-send-email-nbd@openwrt.org>
References: <1437563174-94761-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct ath_atx_ac contains a list of active TIDs belonging to one WMM AC.
This patch changes the code to track active station TIDs in the txq directly.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  12 +---
 drivers/net/wireless/ath/ath9k/xmit.c  | 128 ++++++++++-----------------------
 2 files changed, 41 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 45596e5..14e0ecc 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -173,14 +173,6 @@ struct ath_txq {
 	struct sk_buff_head complete_q;
 };
 
-struct ath_atx_ac {
-	struct ath_txq *txq;
-	struct list_head list;
-	struct list_head tid_q;
-	bool clear_ps_filter;
-	bool sched;
-};
-
 struct ath_frame_info {
 	struct ath_buf *bf;
 	u16 framelen;
@@ -243,7 +235,7 @@ struct ath_atx_tid {
 	struct sk_buff_head buf_q;
 	struct sk_buff_head retry_q;
 	struct ath_node *an;
-	struct ath_atx_ac *ac;
+	struct ath_txq *txq;
 	unsigned long tx_buf[BITS_TO_LONGS(ATH_TID_MAX_BUFS)];
 	u16 seq_start;
 	u16 seq_next;
@@ -255,6 +247,7 @@ struct ath_atx_tid {
 	s8 bar_index;
 	bool sched;
 	bool active;
+	bool clear_ps_filter;
 };
 
 struct ath_node {
@@ -262,7 +255,6 @@ struct ath_node {
 	struct ieee80211_sta *sta; /* station struct we're part of */
 	struct ieee80211_vif *vif; /* interface with which we're associated */
 	struct ath_atx_tid tid[IEEE80211_NUM_TIDS];
-	struct ath_atx_ac ac[IEEE80211_NUM_ACS];
 
 	u16 maxampdu;
 	u8 mpdudensity;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b766a7f..f7d6a85 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -106,7 +106,6 @@ void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
 static void ath_tx_queue_tid(struct ath_softc *sc, struct ath_txq *txq,
 			     struct ath_atx_tid *tid)
 {
-	struct ath_atx_ac *ac = tid->ac;
 	struct list_head *list;
 	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
 	struct ath_chanctx *ctx = avp->chanctx;
@@ -118,15 +117,8 @@ static void ath_tx_queue_tid(struct ath_softc *sc, struct ath_txq *txq,
 		return;
 
 	tid->sched = true;
-	list_add_tail(&tid->list, &ac->tid_q);
-
-	if (ac->sched)
-		return;
-
-	ac->sched = true;
-
 	list = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
-	list_add_tail(&ac->list, list);
+	list_add_tail(&tid->list, list);
 }
 
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
@@ -208,7 +200,7 @@ static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
 static void
 ath_tx_tid_change_state(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_txq *txq = tid->ac->txq;
+	struct ath_txq *txq = tid->txq;
 	struct ieee80211_tx_info *tx_info;
 	struct sk_buff *skb, *tskb;
 	struct ath_buf *bf;
@@ -237,7 +229,7 @@ ath_tx_tid_change_state(struct ath_softc *sc, struct ath_atx_tid *tid)
 
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_txq *txq = tid->ac->txq;
+	struct ath_txq *txq = tid->txq;
 	struct sk_buff *skb;
 	struct ath_buf *bf;
 	struct list_head bf_head;
@@ -644,7 +636,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_queue_tid(sc, txq, tid);
 
 			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
-				tid->ac->clear_ps_filter = true;
+				tid->clear_ps_filter = true;
 		}
 	}
 
@@ -734,7 +726,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_rate *rates;
 	u32 max_4ms_framelen, frmlen;
 	u16 aggr_limit, bt_aggr_limit, legacy = 0;
-	int q = tid->ac->txq->mac80211_qnum;
+	int q = tid->txq->mac80211_qnum;
 	int i;
 
 	skb = bf->bf_mpdu;
@@ -1471,8 +1463,8 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	if (list_empty(&bf_q))
 		return false;
 
-	if (tid->ac->clear_ps_filter || tid->an->no_ps_filter) {
-		tid->ac->clear_ps_filter = false;
+	if (tid->clear_ps_filter || tid->an->no_ps_filter) {
+		tid->clear_ps_filter = false;
 		tx_info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	}
 
@@ -1491,7 +1483,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 
 	an = (struct ath_node *)sta->drv_priv;
 	txtid = ATH_AN_2_TID(an, tid);
-	txq = txtid->ac->txq;
+	txq = txtid->txq;
 
 	ath_txq_lock(sc, txq);
 
@@ -1525,7 +1517,7 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
-	struct ath_txq *txq = txtid->ac->txq;
+	struct ath_txq *txq = txtid->txq;
 
 	ath_txq_lock(sc, txq);
 	txtid->active = false;
@@ -1538,7 +1530,6 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 		       struct ath_node *an)
 {
 	struct ath_atx_tid *tid;
-	struct ath_atx_ac *ac;
 	struct ath_txq *txq;
 	bool buffered;
 	int tidno;
@@ -1546,8 +1537,7 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 
-		ac = tid->ac;
-		txq = ac->txq;
+		txq = tid->txq;
 
 		ath_txq_lock(sc, txq);
 
@@ -1561,11 +1551,6 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 		tid->sched = false;
 		list_del(&tid->list);
 
-		if (ac->sched) {
-			ac->sched = false;
-			list_del(&ac->list);
-		}
-
 		ath_txq_unlock(sc, txq);
 
 		ieee80211_sta_set_buffered(sta, tidno, buffered);
@@ -1575,18 +1560,16 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 {
 	struct ath_atx_tid *tid;
-	struct ath_atx_ac *ac;
 	struct ath_txq *txq;
 	int tidno;
 
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 
-		ac = tid->ac;
-		txq = ac->txq;
+		txq = tid->txq;
 
 		ath_txq_lock(sc, txq);
-		ac->clear_ps_filter = true;
+		tid->clear_ps_filter = true;
 
 		if (ath_tid_has_buffered(tid)) {
 			ath_tx_queue_tid(sc, txq, tid);
@@ -1606,7 +1589,7 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
 
 	an = (struct ath_node *)sta->drv_priv;
 	tid = ATH_AN_2_TID(an, tidno);
-	txq = tid->ac->txq;
+	txq = tid->txq;
 
 	ath_txq_lock(sc, txq);
 
@@ -1645,7 +1628,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 
 		tid = ATH_AN_2_TID(an, i);
 
-		ath_txq_lock(sc, tid->ac->txq);
+		ath_txq_lock(sc, tid->txq);
 		while (nframes > 0) {
 			bf = ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid, &tid_q);
 			if (!bf)
@@ -1669,7 +1652,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 			if (an->sta && !ath_tid_has_buffered(tid))
 				ieee80211_sta_set_buffered(an->sta, i, false);
 		}
-		ath_txq_unlock_complete(sc, tid->ac->txq);
+		ath_txq_unlock_complete(sc, tid->txq);
 	}
 
 	if (list_empty(&bf_q))
@@ -1918,9 +1901,8 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_atx_ac *ac, *last_ac;
 	struct ath_atx_tid *tid, *last_tid;
-	struct list_head *ac_list;
+	struct list_head *tid_list;
 	bool sent = false;
 
 	if (txq->mac80211_qnum < 0)
@@ -1930,63 +1912,46 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		return;
 
 	spin_lock_bh(&sc->chan_lock);
-	ac_list = &sc->cur_chan->acq[txq->mac80211_qnum];
+	tid_list = &sc->cur_chan->acq[txq->mac80211_qnum];
 
-	if (list_empty(ac_list)) {
+	if (list_empty(tid_list)) {
 		spin_unlock_bh(&sc->chan_lock);
 		return;
 	}
 
 	rcu_read_lock();
 
-	last_ac = list_entry(ac_list->prev, struct ath_atx_ac, list);
-	while (!list_empty(ac_list)) {
+	last_tid = list_entry(tid_list->prev, struct ath_atx_tid, list);
+	while (!list_empty(tid_list)) {
 		bool stop = false;
 
 		if (sc->cur_chan->stopped)
 			break;
 
-		ac = list_first_entry(ac_list, struct ath_atx_ac, list);
-		last_tid = list_entry(ac->tid_q.prev, struct ath_atx_tid, list);
-		list_del(&ac->list);
-		ac->sched = false;
-
-		while (!list_empty(&ac->tid_q)) {
-
-			tid = list_first_entry(&ac->tid_q, struct ath_atx_tid,
-					       list);
-			list_del(&tid->list);
-			tid->sched = false;
-
-			if (ath_tx_sched_aggr(sc, txq, tid, &stop))
-				sent = true;
-
-			/*
-			 * add tid to round-robin queue if more frames
-			 * are pending for the tid
-			 */
-			if (ath_tid_has_buffered(tid))
-				ath_tx_queue_tid(sc, txq, tid);
+		tid = list_first_entry(tid_list, struct ath_atx_tid, list);
+		list_del(&tid->list);
+		tid->sched = false;
 
-			if (stop || tid == last_tid)
-				break;
-		}
+		if (ath_tx_sched_aggr(sc, txq, tid, &stop))
+			sent = true;
 
-		if (!list_empty(&ac->tid_q) && !ac->sched) {
-			ac->sched = true;
-			list_add_tail(&ac->list, ac_list);
-		}
+		/*
+		 * add tid to round-robin queue if more frames
+		 * are pending for the tid
+		 */
+		if (ath_tid_has_buffered(tid))
+			ath_tx_queue_tid(sc, txq, tid);
 
 		if (stop)
 			break;
 
-		if (ac == last_ac) {
+		if (tid == last_tid) {
 			if (!sent)
 				break;
 
 			sent = false;
-			last_ac = list_entry(ac_list->prev,
-					     struct ath_atx_ac, list);
+			last_tid = list_entry(tid_list->prev,
+					      struct ath_atx_tid, list);
 		}
 	}
 
@@ -2376,10 +2341,10 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		txq = sc->tx.uapsdq;
 		ath_txq_lock(sc, txq);
 	} else if (txctl->an && queue) {
-		WARN_ON(tid->ac->txq != txctl->txq);
+		WARN_ON(tid->txq != txctl->txq);
 
 		if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
-			tid->ac->clear_ps_filter = true;
+			tid->clear_ps_filter = true;
 
 		/*
 		 * Add this frame to software queue for scheduling later
@@ -2873,7 +2838,6 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 {
 	struct ath_atx_tid *tid;
-	struct ath_atx_ac *ac;
 	int tidno, acno;
 
 	for (tidno = 0, tid = &an->tid[tidno];
@@ -2886,24 +2850,16 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->baw_head  = tid->baw_tail = 0;
 		tid->sched     = false;
 		tid->active	   = false;
+		tid->clear_ps_filter = true;
 		__skb_queue_head_init(&tid->buf_q);
 		__skb_queue_head_init(&tid->retry_q);
 		acno = TID_TO_WME_AC(tidno);
-		tid->ac = &an->ac[acno];
-	}
-
-	for (acno = 0, ac = &an->ac[acno];
-	     acno < IEEE80211_NUM_ACS; acno++, ac++) {
-		ac->sched    = false;
-		ac->clear_ps_filter = true;
-		ac->txq = sc->tx.txq_map[acno];
-		INIT_LIST_HEAD(&ac->tid_q);
+		tid->txq = sc->tx.txq_map[acno];
 	}
 }
 
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 {
-	struct ath_atx_ac *ac;
 	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
 	int tidno;
@@ -2911,8 +2867,7 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 
-		ac = tid->ac;
-		txq = ac->txq;
+		txq = tid->txq;
 
 		ath_txq_lock(sc, txq);
 
@@ -2921,11 +2876,6 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 			tid->sched = false;
 		}
 
-		if (ac->sched) {
-			list_del(&ac->list);
-			tid->ac->sched = false;
-		}
-
 		ath_tid_drain(sc, txq, tid);
 		tid->active = false;
 
-- 
2.2.2

