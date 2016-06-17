Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:58225 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbcFQJJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 05:09:56 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Tim Shepard <shep@alum.mit.edu>
Subject: [PATCH 1/2] ath9k: use mac80211 intermediate software queues
Date: Fri, 17 Jun 2016 11:09:28 +0200
Message-Id: <20160617090929.31606-2-toke@toke.dk> (sfid-20160617_111006_340065_57610E3C)
In-Reply-To: <20160617090929.31606-1-toke@toke.dk>
References: <20160617090929.31606-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch leaves the code for ath9k's internal per-node per-tid
queues in place and just modifies the driver to also pull from
the new mac80211 intermediate software queues, and implements
the .wake_tx_queue method, which will cause mac80211 to deliver
packets to be sent via the new intermediate queue.

Signed-off-by: Tim Shepard <shep@alum.mit.edu>

Reworked to not require the global variable renaming in ath9k.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h     |  16 +++-
 drivers/net/wireless/ath/ath9k/debug_sta.c |   7 +-
 drivers/net/wireless/ath/ath9k/init.c      |   1 +
 drivers/net/wireless/ath/ath9k/main.c      |   1 +
 drivers/net/wireless/ath/ath9k/xmit.c      | 119 +++++++++++++++++++++++++----
 5 files changed, 125 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 93b3793..caeae10 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -145,8 +145,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 #define BAW_WITHIN(_start, _bawsz, _seqno) \
 	((((_seqno) - (_start)) & 4095) < (_bawsz))
 
-#define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
-
 #define IS_HT_RATE(rate)   (rate & 0x80)
 #define IS_CCK_RATE(rate)  ((rate >= 0x18) && (rate <= 0x1e))
 #define IS_OFDM_RATE(rate) ((rate >= 0x8) && (rate <= 0xf))
@@ -232,8 +230,10 @@ struct ath_buf {
 
 struct ath_atx_tid {
 	struct list_head list;
+	struct sk_buff_head i_q;
 	struct sk_buff_head buf_q;
 	struct sk_buff_head retry_q;
+	struct ieee80211_txq *swq;
 	struct ath_node *an;
 	struct ath_txq *txq;
 	unsigned long tx_buf[BITS_TO_LONGS(ATH_TID_MAX_BUFS)];
@@ -247,13 +247,13 @@ struct ath_atx_tid {
 	s8 bar_index;
 	bool active;
 	bool clear_ps_filter;
+	bool swq_nonempty;
 };
 
 struct ath_node {
 	struct ath_softc *sc;
 	struct ieee80211_sta *sta; /* station struct we're part of */
 	struct ieee80211_vif *vif; /* interface with which we're associated */
-	struct ath_atx_tid tid[IEEE80211_NUM_TIDS];
 
 	u16 maxampdu;
 	u8 mpdudensity;
@@ -271,6 +271,15 @@ struct ath_node {
 	struct list_head list;
 };
 
+static inline
+struct ath_atx_tid *ath_an_2_tid(struct ath_node *an, u8 tidno)
+{
+	struct ieee80211_sta *sta = an->sta;
+	struct ieee80211_vif *vif = an->vif;
+	struct ieee80211_txq *swq = sta ? sta->txq[tidno] : vif->txq;
+	return (struct ath_atx_tid *) swq->drv_priv;
+}
+
 struct ath_tx_control {
 	struct ath_txq *txq;
 	struct ath_node *an;
@@ -585,6 +594,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 				   u16 tids, int nframes,
 				   enum ieee80211_frame_release_type reason,
 				   bool more_data);
+void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *swq);
 
 /********/
 /* VIFs */
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index b66cfa9..0e7f6b5 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -25,6 +25,7 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 {
 	struct ath_node *an = file->private_data;
 	struct ath_softc *sc = an->sc;
+	struct ieee80211_txq *swq;
 	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
 	u32 len = 0, size = 4096;
@@ -52,8 +53,10 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 			 "TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
 			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
 
-	for (tidno = 0, tid = &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
+	for (tidno = 0;
+	     tidno < IEEE80211_NUM_TIDS; tidno++) {
+		swq = an->sta->txq[tidno];
+		tid = (struct ath_atx_tid *) swq->drv_priv;
 		txq = tid->txq;
 		ath_txq_lock(sc, txq);
 		if (tid->active) {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2ee8624..211736c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -873,6 +873,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->max_rate_tries = 10;
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vif);
+	hw->txq_data_size = sizeof(struct ath_atx_tid);
 	hw->extra_tx_headroom = 4;
 
 	hw->wiphy->available_antennas_rx = BIT(ah->caps.max_rxchains) - 1;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8b63988..6ab56e5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2668,4 +2668,5 @@ struct ieee80211_ops ath9k_ops = {
 	.sw_scan_start	    = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
 	.get_txpower        = ath9k_get_txpower,
+	.wake_tx_queue      = ath9k_wake_tx_queue,
 };
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8ddd604..cdc8684 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -65,6 +65,8 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
 					   struct sk_buff *skb);
+static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
+			  struct ath_tx_control *txctl);
 
 enum {
 	MCS_HT20,
@@ -118,6 +120,21 @@ static void ath_tx_queue_tid(struct ath_softc *sc, struct ath_txq *txq,
 		list_add_tail(&tid->list, list);
 }
 
+void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *swq)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_atx_tid *tid = (struct ath_atx_tid *) swq->drv_priv;
+	struct ath_txq *txq = tid->txq;
+
+	spin_lock_bh(&txq->axq_lock);
+
+	tid->swq_nonempty = true;
+	ath_tx_queue_tid(sc, txq, tid);
+	ath_txq_schedule(sc, txq);
+
+	spin_unlock_bh(&txq->axq_lock);
+}
+
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -170,12 +187,51 @@ static struct ath_atx_tid *
 ath_get_skb_tid(struct ath_softc *sc, struct ath_node *an, struct sk_buff *skb)
 {
 	u8 tidno = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
-	return ATH_AN_2_TID(an, tidno);
+	return ath_an_2_tid(an, tidno);
 }
 
+static void ath_swq_pull(struct ath_atx_tid *tid)
+{
+	struct sk_buff *skb;
+	struct ath_tx_control txctl;
+	struct ath_frame_info *fi;
+	int r;
+
+	if (!skb_queue_empty(&tid->i_q))
+		return;
+
+	if (!tid->swq_nonempty)
+		return;
+
+	skb = ieee80211_tx_dequeue(tid->an->sc->hw, tid->swq);
+	if (!skb) {
+		tid->swq_nonempty = false;
+	} else {
+		/* sad to do all this with axq_lock held */
+		memset(&txctl, 0, sizeof txctl);
+		txctl.txq = tid->txq;
+		txctl.sta = tid->an->sta;
+		r = ath_tx_prepare(tid->an->sc->hw, skb, &txctl);
+		if (WARN_ON(r != 0)) {
+			/** should not happen ??? */
+		} else {
+			/* perhaps not needed here ??? */
+			fi = get_frame_info(skb);
+			fi->txq = skb_get_queue_mapping(skb);
+
+			__skb_queue_tail(&tid->i_q, skb);
+			++tid->txq->pending_frames;
+		}
+	}
+ }
+
+
 static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
 {
-	return !skb_queue_empty(&tid->buf_q) || !skb_queue_empty(&tid->retry_q);
+	if (!skb_queue_empty(&tid->buf_q) || !skb_queue_empty(&tid->retry_q) || !skb_queue_empty(&tid->i_q))
+		return true;
+	ath_swq_pull(tid);
+	return !skb_queue_empty(&tid->i_q);
 }
 
 static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
@@ -185,6 +241,12 @@ static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
 	skb = __skb_dequeue(&tid->retry_q);
 	if (!skb)
 		skb = __skb_dequeue(&tid->buf_q);
+	if (!skb)
+		skb = __skb_dequeue(&tid->i_q);
+	if (!skb) {
+		ath_swq_pull(tid);
+		skb = __skb_dequeue(&tid->i_q);
+	}
 
 	return skb;
 }
@@ -870,6 +932,10 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 		*q = &tid->retry_q;
 		if (skb_queue_empty(*q))
 			*q = &tid->buf_q;
+		if (skb_queue_empty(*q))
+			*q = &tid->i_q;
+		if (skb_queue_empty(*q))
+			ath_swq_pull(tid);
 
 		skb = skb_peek(*q);
 		if (!skb)
@@ -1482,7 +1548,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	ath_dbg(common, XMIT, "%s called\n", __func__);
 
 	an = (struct ath_node *)sta->drv_priv;
-	txtid = ATH_AN_2_TID(an, tid);
+	txtid = ath_an_2_tid(an, tid);
 	txq = txtid->txq;
 
 	ath_txq_lock(sc, txq);
@@ -1517,7 +1583,7 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
-	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
+	struct ath_atx_tid *txtid = ath_an_2_tid(an, tid);
 	struct ath_txq *txq = txtid->txq;
 
 	ath_dbg(common, XMIT, "%s called\n", __func__);
@@ -1533,6 +1599,7 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 		       struct ath_node *an)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_txq *swq;
 	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
 	bool buffered;
@@ -1540,9 +1607,11 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 
 	ath_dbg(common, XMIT, "%s called\n", __func__);
 
-	for (tidno = 0, tid = &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
+	for (tidno = 0;
+	     tidno < IEEE80211_NUM_TIDS; tidno++) {
 
+		swq = an->sta->txq[tidno];
+		tid = (struct ath_atx_tid *) swq->drv_priv;
 		txq = tid->txq;
 
 		ath_txq_lock(sc, txq);
@@ -1565,15 +1634,18 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_txq *swq;
 	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
 	int tidno;
 
 	ath_dbg(common, XMIT, "%s called\n", __func__);
 
-	for (tidno = 0, tid = &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
+	for (tidno = 0;
+	     tidno < IEEE80211_NUM_TIDS; tidno++) {
 
+		swq = an->sta->txq[tidno];
+		tid = (struct ath_atx_tid *) swq->drv_priv;
 		txq = tid->txq;
 
 		ath_txq_lock(sc, txq);
@@ -1599,7 +1671,7 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
 	ath_dbg(common, XMIT, "%s called\n", __func__);
 
 	an = (struct ath_node *)sta->drv_priv;
-	tid = ATH_AN_2_TID(an, tidno);
+	tid = ath_an_2_tid(an, tidno);
 	txq = tid->txq;
 
 	ath_txq_lock(sc, txq);
@@ -1637,7 +1709,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 		if (!(tids & 1))
 			continue;
 
-		tid = ATH_AN_2_TID(an, i);
+		tid = ath_an_2_tid(an, i);
 
 		ath_txq_lock(sc, tid->txq);
 		while (nframes > 0) {
@@ -2853,12 +2925,18 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 {
+	struct ieee80211_txq *swq;
+	struct ieee80211_sta *sta = an->sta;
+	struct ieee80211_vif *vif = an->vif;
 	struct ath_atx_tid *tid;
 	int tidno, acno;
 
-	for (tidno = 0, tid = &an->tid[tidno];
+	for (tidno = 0;
 	     tidno < IEEE80211_NUM_TIDS;
-	     tidno++, tid++) {
+	     tidno++) {
+		swq = sta ? sta->txq[tidno] : vif->txq;
+		tid = (struct ath_atx_tid *) swq->drv_priv;
+		tid->swq       = swq;
 		tid->an        = an;
 		tid->tidno     = tidno;
 		tid->seq_start = tid->seq_next = 0;
@@ -2866,23 +2944,33 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->baw_head  = tid->baw_tail = 0;
 		tid->active	   = false;
 		tid->clear_ps_filter = true;
+		tid->swq_nonempty  = false;
+		__skb_queue_head_init(&tid->i_q);
 		__skb_queue_head_init(&tid->buf_q);
 		__skb_queue_head_init(&tid->retry_q);
 		INIT_LIST_HEAD(&tid->list);
 		acno = TID_TO_WME_AC(tidno);
 		tid->txq = sc->tx.txq_map[acno];
+
+		if (!sta)
+			break; /* just one multicast ath_atx_tid */
 	}
 }
 
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 {
+	struct ieee80211_txq *swq;
+	struct ieee80211_sta *sta = an->sta;
+	struct ieee80211_vif *vif = an->vif;
 	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
 	int tidno;
 
-	for (tidno = 0, tid = &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
+	for (tidno = 0;
+	     tidno < IEEE80211_NUM_TIDS; tidno++) {
 
+		swq = sta ? sta->txq[tidno] : vif->txq;
+		tid = (struct ath_atx_tid *) swq->drv_priv;
 		txq = tid->txq;
 
 		ath_txq_lock(sc, txq);
@@ -2894,6 +2982,9 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 		tid->active = false;
 
 		ath_txq_unlock(sc, txq);
+
+		if (!sta)
+			break; /* just one multicast ath_atx_tid */
 	}
 }
 
-- 
2.8.3
