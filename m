Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58735 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab1INTYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 02/12] ath9k: reduce the number of functions that access the tx descriptor
Date: Wed, 14 Sep 2011 21:24:17 +0200
Message-Id: <1316028267-34187-2-git-send-email-nbd@openwrt.org> (sfid-20110914_212439_173964_170F7F88)
In-Reply-To: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes it easier to clean up the ath9k_hw descriptor API

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   91 +++++++++++++++++++------------
 2 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 51d4a60..9a10ab1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -213,6 +213,7 @@ struct ath_frame_info {
 struct ath_buf_state {
 	u8 bf_type;
 	u8 bfs_paprd;
+	u8 ndelim;
 	u16 seqno;
 	unsigned long bfs_paprd_timestamp;
 };
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5404982..48ac9ff 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -774,7 +774,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		if (!bf)
 			continue;
 
-		bf->bf_state.bf_type |= BUF_AMPDU;
+		bf->bf_state.bf_type = BUF_AMPDU | BUF_AGGR;
 		seqno = bf->bf_state.seqno;
 		if (!bf_first)
 			bf_first = bf;
@@ -824,20 +824,17 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 
 		nframes++;
 		bf->bf_next = NULL;
-		ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, 0);
 
 		/* link buffers of this frame to the aggregate */
 		if (!fi->retries)
 			ath_tx_addto_baw(sc, tid, seqno);
-		ath9k_hw_set11n_aggr_middle(sc->sc_ah, bf->bf_desc, ndelim);
+		bf->bf_state.ndelim = ndelim;
 
 		__skb_unlink(skb, &tid->buf_q);
 		list_add_tail(&bf->list, bf_q);
-		if (bf_prev) {
+		if (bf_prev)
 			bf_prev->bf_next = bf;
-			ath9k_hw_set_desc_link(sc->sc_ah, bf_prev->bf_desc,
-					       bf->bf_daddr);
-		}
+
 		bf_prev = bf;
 
 	} while (!skb_queue_empty(&tid->buf_q));
@@ -848,12 +845,50 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 #undef PADBYTES
 }
 
+static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf, int len)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
+	struct ath_buf *bf_first = bf;
+
+	bool aggr = !!(bf->bf_state.bf_type & BUF_AGGR);
+	bool clrdmask = !!(tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT);
+
+	u32 ds_next;
+
+	ath_buf_set_rate(sc, bf, len);
+
+	while (bf) {
+		if (bf->bf_next)
+			ds_next = bf->bf_next->bf_daddr;
+		else
+			ds_next = 0;
+
+		ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, clrdmask);
+		if (!aggr)
+			ath9k_hw_clr11n_aggr(sc->sc_ah, bf->bf_desc);
+		else if (!bf->bf_next)
+			ath9k_hw_set11n_aggr_last(sc->sc_ah, bf->bf_desc);
+		else {
+			if (bf == bf_first)
+				ath9k_hw_set11n_aggr_first(sc->sc_ah,
+					bf->bf_desc, len);
+
+			ath9k_hw_set11n_aggr_middle(sc->sc_ah, bf->bf_desc,
+				bf->bf_state.ndelim);
+		}
+
+		ath9k_hw_set_desc_link(ah, bf->bf_desc, ds_next);
+		bf = bf->bf_next;
+	}
+}
+
 static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			      struct ath_atx_tid *tid)
 {
 	struct ath_buf *bf;
 	enum ATH_AGGR_STATUS status;
-	struct ath_frame_info *fi;
+	struct ieee80211_tx_info *tx_info;
 	struct list_head bf_q;
 	int aggr_len;
 
@@ -874,34 +909,25 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		bf = list_first_entry(&bf_q, struct ath_buf, list);
 		bf->bf_lastbf = list_entry(bf_q.prev, struct ath_buf, list);
+		tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
 
 		if (tid->ac->clear_ps_filter) {
 			tid->ac->clear_ps_filter = false;
-			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, true);
+			tx_info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+		} else {
+			tx_info->flags &= ~IEEE80211_TX_CTL_CLEAR_PS_FILT;
 		}
 
 		/* if only one frame, send as non-aggregate */
 		if (bf == bf->bf_lastbf) {
-			fi = get_frame_info(bf->bf_mpdu);
-
-			bf->bf_state.bf_type &= ~BUF_AGGR;
-			ath9k_hw_clr11n_aggr(sc->sc_ah, bf->bf_desc);
-			ath_buf_set_rate(sc, bf, fi->framelen);
-			ath_tx_txqaddbuf(sc, txq, &bf_q, false);
-			continue;
+			aggr_len = get_frame_info(bf->bf_mpdu)->framelen;
+			bf->bf_state.bf_type = BUF_AMPDU;
+		} else {
+			TX_STAT_INC(txq->axq_qnum, a_aggr);
 		}
 
-		/* setup first desc of aggregate */
-		bf->bf_state.bf_type |= BUF_AGGR;
-		ath_buf_set_rate(sc, bf, aggr_len);
-		ath9k_hw_set11n_aggr_first(sc->sc_ah, bf->bf_desc, aggr_len);
-
-		/* anchor last desc of aggregate */
-		ath9k_hw_set11n_aggr_last(sc->sc_ah, bf->bf_lastbf->bf_desc);
-
+		ath_tx_fill_desc(sc, bf, aggr_len);
 		ath_tx_txqaddbuf(sc, txq, &bf_q, false);
-		TX_STAT_INC(txq->axq_qnum, a_aggr);
-
 	} while (txq->axq_ampdu_depth < ATH_AGGR_MIN_QDEPTH &&
 		 status != ATH_AGGR_BAW_CLOSED);
 }
@@ -1479,7 +1505,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	if (!bf)
 		return;
 
-	bf->bf_state.bf_type |= BUF_AMPDU;
+	bf->bf_state.bf_type = BUF_AMPDU;
 	INIT_LIST_HEAD(&bf_head);
 	list_add(&bf->list, &bf_head);
 
@@ -1489,7 +1515,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	/* Queue to h/w without aggregation */
 	TX_STAT_INC(txctl->txq->axq_qnum, a_queued_hw);
 	bf->bf_lastbf = bf;
-	ath_buf_set_rate(sc, bf, fi->framelen);
+	ath_tx_fill_desc(sc, bf, fi->framelen);
 	ath_tx_txqaddbuf(sc, txctl->txq, &bf_head, false);
 }
 
@@ -1509,14 +1535,14 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 
 	INIT_LIST_HEAD(&bf_head);
 	list_add_tail(&bf->list, &bf_head);
-	bf->bf_state.bf_type &= ~BUF_AMPDU;
+	bf->bf_state.bf_type = 0;
 
 	/* update starting sequence number for subsequent ADDBA request */
 	if (tid)
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
 	bf->bf_lastbf = bf;
-	ath_buf_set_rate(sc, bf, fi->framelen);
+	ath_tx_fill_desc(sc, bf, fi->framelen);
 	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
 	TX_STAT_INC(txq->axq_qnum, queued);
 }
@@ -1790,8 +1816,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	frm_type = get_hw_packet_type(skb);
 
 	ds = bf->bf_desc;
-	ath9k_hw_set_desc_link(ah, ds, 0);
-
 	ath9k_hw_set11n_txdesc(ah, ds, fi->framelen, frm_type, MAX_RATE_POWER,
 			       fi->keyix, fi->keytype, bf->bf_flags);
 
@@ -1852,9 +1876,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 		if (txctl->paprd)
 			bf->bf_state.bfs_paprd_timestamp = jiffies;
 
-		if (tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
-			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, true);
-
 		ath_tx_send_normal(sc, txctl->txq, tid, skb);
 	}
 
-- 
1.7.3.2

