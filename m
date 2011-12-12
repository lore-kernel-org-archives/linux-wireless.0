Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56654 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab1LLUGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 15:06:37 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/6] ath9k: reduce the number of unnecessary BAR tx packets
Date: Mon, 12 Dec 2011 21:06:22 +0100
Message-Id: <1323720386-46132-2-git-send-email-nbd@openwrt.org> (sfid-20111212_210646_971766_7261FFBC)
In-Reply-To: <1323720386-46132-1-git-send-email-nbd@openwrt.org>
References: <1323720386-46132-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When processing A-MPDU tx status, only send a BAR for the failed packet
with the highest sequence number.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 ++-
 drivers/net/wireless/ath/ath9k/debug.c |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |   50 +++++++++++++++++++------------
 4 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index fa6c905..6beaff5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -159,6 +159,9 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 /* return block-ack bitmap index given sequence and starting sequence */
 #define ATH_BA_INDEX(_st, _seq) (((_seq) - (_st)) & (IEEE80211_SEQ_MAX - 1))
 
+/* return the seqno for _start + _offset */
+#define ATH_BA_INDEX2SEQ(_seq, _offset) (((_seq) + (_offset)) & (IEEE80211_SEQ_MAX - 1))
+
 /* returns delimiter padding required given the packet length */
 #define ATH_AGGR_GET_NDELIM(_len)					\
        (((_len) >= ATH_AGGR_MINPLEN) ? 0 :                             \
@@ -252,9 +255,9 @@ struct ath_atx_tid {
 struct ath_node {
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct list_head list; /* for sc->nodes */
+#endif
 	struct ieee80211_sta *sta; /* station struct we're part of */
 	struct ieee80211_vif *vif; /* interface with which we're associated */
-#endif
 	struct ath_atx_tid tid[WME_NUM_TID];
 	struct ath_atx_ac ac[WME_NUM_AC];
 	int ps_key;
@@ -276,7 +279,6 @@ struct ath_tx_control {
 };
 
 #define ATH_TX_ERROR        0x01
-#define ATH_TX_BAR          0x02
 
 /**
  * @txq_map:  Index is mac80211 queue number.  This is
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 6fb719d..5cb8cce 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -856,7 +856,7 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 	sc->debug.stats.txstats[qnum].tx_bytes_all += bf->bf_mpdu->len;
 
 	if (bf_isampdu(bf)) {
-		if (flags & ATH_TX_BAR)
+		if (flags & ATH_TX_ERROR)
 			TX_STAT_INC(qnum, a_xretries);
 		else
 			TX_STAT_INC(qnum, a_completed);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7d92004..4475b0d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -644,9 +644,9 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 	spin_lock(&sc->nodes_lock);
 	list_add(&an->list, &sc->nodes);
 	spin_unlock(&sc->nodes_lock);
+#endif
 	an->sta = sta;
 	an->vif = vif;
-#endif
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		ath_tx_node_init(sc, an);
 		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a46b4e2..649a11e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -53,7 +53,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 			    int tx_flags, struct ath_txq *txq);
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_txq *txq, struct list_head *bf_q,
-				struct ath_tx_status *ts, int txok, int sendbar);
+				struct ath_tx_status *ts, int txok);
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head, bool internal);
 static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
@@ -150,6 +150,12 @@ static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
 	return (struct ath_frame_info *) &tx_info->rate_driver_data[0];
 }
 
+static void ath_send_bar(struct ath_atx_tid *tid, u16 seqno)
+{
+	ieee80211_send_bar(tid->an->vif, tid->an->sta->addr, tid->tidno,
+			   seqno << IEEE80211_SEQ_SEQ_SHIFT);
+}
+
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = tid->ac->txq;
@@ -158,6 +164,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	struct list_head bf_head;
 	struct ath_tx_status ts;
 	struct ath_frame_info *fi;
+	bool sendbar = false;
 
 	INIT_LIST_HEAD(&bf_head);
 
@@ -172,7 +179,8 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		if (bf && fi->retries) {
 			list_add_tail(&bf->list, &bf_head);
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 1);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
+			sendbar = true;
 		} else {
 			ath_tx_send_normal(sc, txq, NULL, skb);
 		}
@@ -185,6 +193,9 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	}
 
 	spin_unlock_bh(&txq->axq_lock);
+
+	if (sendbar)
+		ath_send_bar(tid, tid->seq_start);
 }
 
 static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
@@ -255,7 +266,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 
 		spin_unlock(&txq->axq_lock);
-		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
+		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 		spin_lock(&txq->axq_lock);
 	}
 
@@ -373,7 +384,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_buf *bf_next, *bf_last = bf->bf_lastbf;
 	struct list_head bf_head;
 	struct sk_buff_head bf_pending;
-	u16 seq_st = 0, acked_cnt = 0, txfail_cnt = 0;
+	u16 seq_st = 0, acked_cnt = 0, txfail_cnt = 0, seq_first;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
@@ -383,6 +394,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	u8 tidno;
 	bool flush = !!(ts->ts_status & ATH9K_TX_FLUSH);
 	int i, retries;
+	int bar_index = -1;
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -408,8 +420,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			if (!bf->bf_stale || bf_next != NULL)
 				list_move_tail(&bf->list, &bf_head);
 
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
-				0, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts, 0);
 
 			bf = bf_next;
 		}
@@ -419,6 +430,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	an = (struct ath_node *)sta->drv_priv;
 	tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
 	tid = ATH_AN_2_TID(an, tidno);
+	seq_first = tid->seq_start;
 
 	/*
 	 * The hardware occasionally sends a tx status for the wrong TID.
@@ -485,8 +497,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				txpending = 1;
 			} else {
 				txfail = 1;
-				sendbar = 1;
 				txfail_cnt++;
+				bar_index = max_t(int, bar_index,
+					ATH_BA_INDEX(seq_first, seqno));
 			}
 		}
 
@@ -515,7 +528,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			}
 
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
-				!txfail, sendbar);
+				!txfail);
 		} else {
 			/* retry the un-acked ones */
 			if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)) {
@@ -535,8 +548,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 						ath_tx_complete_buf(sc, bf, txq,
 								    &bf_head,
-								    ts, 0,
-								    !flush);
+								    ts, 0);
+						bar_index = max_t(int, bar_index,
+							ATH_BA_INDEX(seq_first,
+								seqno));
 						break;
 					}
 
@@ -554,6 +569,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		bf = bf_next;
 	}
 
+	if (bar_index >= 0)
+		ath_send_bar(tid, ATH_BA_INDEX2SEQ(seq_first, bar_index + 1));
+
 	/* prepend un-acked frames to the beginning of the pending frame queue */
 	if (!skb_queue_empty(&bf_pending)) {
 		if (an->sleeping)
@@ -1441,7 +1459,7 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, 0,
 					     retry_tx);
 		else
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 		spin_lock_bh(&txq->axq_lock);
 	}
 }
@@ -1945,9 +1963,6 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	ath_dbg(common, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
 
-	if (tx_flags & ATH_TX_BAR)
-		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-
 	if (!(tx_flags & ATH_TX_ERROR))
 		/* Frame was ACKed */
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
@@ -1991,16 +2006,13 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_txq *txq, struct list_head *bf_q,
-				struct ath_tx_status *ts, int txok, int sendbar)
+				struct ath_tx_status *ts, int txok)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	unsigned long flags;
 	int tx_flags = 0;
 
-	if (sendbar)
-		tx_flags = ATH_TX_BAR;
-
 	if (!txok)
 		tx_flags |= ATH_TX_ERROR;
 
@@ -2107,7 +2119,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 
 	if (!bf_isampdu(bf)) {
 		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
-		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok, 0);
+		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
 	} else
 		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok, true);
 
-- 
1.7.3.2

