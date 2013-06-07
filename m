Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51965 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab3FGQMG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 12:12:06 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v3 2/3] ath9k: implement support for .release_buffered_frames()
Date: Fri,  7 Jun 2013 18:12:01 +0200
Message-Id: <1370621522-59812-2-git-send-email-nbd@openwrt.org> (sfid-20130607_181258_326789_BD3F0EC1)
In-Reply-To: <1370621522-59812-1-git-send-email-nbd@openwrt.org>
References: <1370621522-59812-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for PS-Poll and U-APSD driver-buffered frames (part of
an aggregation session).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   5 +
 drivers/net/wireless/ath/ath9k/main.c  |   1 +
 drivers/net/wireless/ath/ath9k/xmit.c  | 175 ++++++++++++++++++++++++++-------
 3 files changed, 145 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4f79827..bd35a54 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -354,6 +354,11 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 		       struct ath_node *an);
+void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
+				   struct ieee80211_sta *sta,
+				   u16 tids, int nframes,
+				   enum ieee80211_frame_release_type reason,
+				   bool more_data);
 
 /********/
 /* VIFs */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e5b186b..bf61a1c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2347,6 +2347,7 @@ struct ieee80211_ops ath9k_ops = {
 	.flush		    = ath9k_flush,
 	.tx_frames_pending  = ath9k_tx_frames_pending,
 	.tx_last_beacon     = ath9k_tx_last_beacon,
+	.release_buffered_frames = ath9k_release_buffered_frames,
 	.get_stats	    = ath9k_get_stats,
 	.set_antenna	    = ath9k_set_antenna,
 	.get_antenna	    = ath9k_get_antenna,
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3931bd8..6c9ff9c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -518,6 +518,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
 				!txfail);
 		} else {
+			if (tx_info->flags & IEEE80211_TX_STATUS_EOSP) {
+				tx_info->flags &= ~IEEE80211_TX_STATUS_EOSP;
+				ieee80211_sta_eosp(sta);
+			}
 			/* retry the un-acked ones */
 			if (bf->bf_next == NULL && bf_last->bf_stale) {
 				struct ath_buf *tbf;
@@ -786,25 +790,20 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	return ndelim;
 }
 
-static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
-					     struct ath_txq *txq,
-					     struct ath_atx_tid *tid,
-					     struct list_head *bf_q,
-					     int *aggr_len)
+static struct ath_buf *
+ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
+			struct ath_atx_tid *tid)
 {
-#define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
-	struct ath_buf *bf, *bf_first = NULL, *bf_prev = NULL;
-	int rl = 0, nframes = 0, ndelim, prev_al = 0;
-	u16 aggr_limit = 0, al = 0, bpad = 0,
-		al_delta, h_baw = tid->baw_size / 2;
-	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
-	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
 	struct sk_buff *skb;
+	struct ath_buf *bf;
 	u16 seqno;
 
-	do {
+	while (1) {
 		skb = skb_peek(&tid->buf_q);
+		if (!skb)
+			break;
+
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 		if (!fi->bf)
@@ -820,10 +819,8 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		seqno = bf->bf_state.seqno;
 
 		/* do not step over block-ack window */
-		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno)) {
-			status = ATH_AGGR_BAW_CLOSED;
+		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno))
 			break;
-		}
 
 		if (tid->bar_index > ATH_BA_INDEX(tid->seq_start, seqno)) {
 			struct ath_tx_status ts = {};
@@ -837,6 +834,40 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 			continue;
 		}
 
+		bf->bf_next = NULL;
+		bf->bf_lastbf = bf;
+		return bf;
+	}
+
+	return NULL;
+}
+
+static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
+					     struct ath_txq *txq,
+					     struct ath_atx_tid *tid,
+					     struct list_head *bf_q,
+					     int *aggr_len)
+{
+#define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
+	struct ath_buf *bf, *bf_first = NULL, *bf_prev = NULL;
+	int rl = 0, nframes = 0, ndelim, prev_al = 0;
+	u16 aggr_limit = 0, al = 0, bpad = 0,
+		al_delta, h_baw = tid->baw_size / 2;
+	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
+	struct ieee80211_tx_info *tx_info;
+	struct ath_frame_info *fi;
+	struct sk_buff *skb;
+
+	do {
+		bf = ath_tx_get_tid_subframe(sc, txq, tid);
+		if (!bf) {
+			status = ATH_AGGR_BAW_CLOSED;
+			break;
+		}
+
+		skb = bf->bf_mpdu;
+		fi = get_frame_info(skb);
+
 		if (!bf_first)
 			bf_first = bf;
 
@@ -882,7 +913,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 
 		/* link buffers of this frame to the aggregate */
 		if (!fi->retries)
-			ath_tx_addto_baw(sc, tid, seqno);
+			ath_tx_addto_baw(sc, tid, bf->bf_state.seqno);
 		bf->bf_state.ndelim = ndelim;
 
 		__skb_unlink(skb, &tid->buf_q);
@@ -1090,10 +1121,8 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_txq *txq, int len)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
-	struct ath_buf *bf_first = bf;
+	struct ath_buf *bf_first = NULL;
 	struct ath_tx_info info;
-	bool aggr = !!(bf->bf_state.bf_type & BUF_AGGR);
 
 	memset(&info, 0, sizeof(info));
 	info.is_first = true;
@@ -1101,24 +1130,11 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 	info.txpower = MAX_RATE_POWER;
 	info.qcu = txq->axq_qnum;
 
-	info.flags = ATH9K_TXDESC_INTREQ;
-	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
-		info.flags |= ATH9K_TXDESC_NOACK;
-	if (tx_info->flags & IEEE80211_TX_CTL_LDPC)
-		info.flags |= ATH9K_TXDESC_LDPC;
-
-	ath_buf_set_rate(sc, bf, &info, len);
-
-	if (tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
-		info.flags |= ATH9K_TXDESC_CLRDMASK;
-
-	if (bf->bf_state.bfs_paprd)
-		info.flags |= (u32) bf->bf_state.bfs_paprd << ATH9K_TXDESC_PAPRD_S;
-
-
 	while (bf) {
 		struct sk_buff *skb = bf->bf_mpdu;
+		struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 		struct ath_frame_info *fi = get_frame_info(skb);
+		bool aggr = !!(bf->bf_state.bf_type & BUF_AGGR);
 
 		info.type = get_hw_packet_type(skb);
 		if (bf->bf_next)
@@ -1126,6 +1142,26 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 		else
 			info.link = 0;
 
+		if (!bf_first) {
+			bf_first = bf;
+
+			info.flags = ATH9K_TXDESC_INTREQ;
+			if ((tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) ||
+			    txq == sc->tx.uapsdq)
+				info.flags |= ATH9K_TXDESC_CLRDMASK;
+
+			if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
+				info.flags |= ATH9K_TXDESC_NOACK;
+			if (tx_info->flags & IEEE80211_TX_CTL_LDPC)
+				info.flags |= ATH9K_TXDESC_LDPC;
+
+			if (bf->bf_state.bfs_paprd)
+				info.flags |= (u32) bf->bf_state.bfs_paprd <<
+					      ATH9K_TXDESC_PAPRD_S;
+
+			ath_buf_set_rate(sc, bf, &info, len);
+		}
+
 		info.buf_addr[0] = bf->bf_buf_addr;
 		info.buf_len[0] = skb->len;
 		info.pkt_len = fi->framelen;
@@ -1135,7 +1171,7 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 		if (aggr) {
 			if (bf == bf_first)
 				info.aggr = AGGR_BUF_FIRST;
-			else if (!bf->bf_next)
+			else if (bf == bf_first->bf_lastbf)
 				info.aggr = AGGR_BUF_LAST;
 			else
 				info.aggr = AGGR_BUF_MIDDLE;
@@ -1144,6 +1180,9 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 			info.aggr_len = len;
 		}
 
+		if (bf == bf_first->bf_lastbf)
+			bf_first = NULL;
+
 		ath9k_hw_set_txdesc(ah, bf->bf_desc, &info);
 		bf = bf->bf_next;
 	}
@@ -1328,6 +1367,70 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
 	ath_txq_unlock_complete(sc, txq);
 }
 
+void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
+				   struct ieee80211_sta *sta,
+				   u16 tids, int nframes,
+				   enum ieee80211_frame_release_type reason,
+				   bool more_data)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+	struct ath_txq *txq = sc->tx.uapsdq;
+	struct ieee80211_tx_info *info;
+	struct list_head bf_q;
+	struct ath_buf *bf_tail = NULL, *bf;
+	int sent = 0;
+	int i;
+
+	INIT_LIST_HEAD(&bf_q);
+	for (i = 0; tids && nframes; i++, tids >>= 1) {
+		struct ath_atx_tid *tid;
+
+		if (!(tids & 1))
+			continue;
+
+		tid = ATH_AN_2_TID(an, i);
+		if (tid->paused)
+			continue;
+
+		ath_txq_lock(sc, tid->ac->txq);
+		while (!skb_queue_empty(&tid->buf_q) && nframes > 0) {
+			bf = ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid);
+			if (!bf)
+				break;
+
+			__skb_unlink(bf->bf_mpdu, &tid->buf_q);
+			list_add_tail(&bf->list, &bf_q);
+			ath_set_rates(tid->an->vif, tid->an->sta, bf);
+			ath_tx_addto_baw(sc, tid, bf->bf_state.seqno);
+			bf->bf_state.bf_type &= ~BUF_AGGR;
+			if (bf_tail)
+				bf_tail->bf_next = bf;
+
+			bf_tail = bf;
+			nframes--;
+			sent++;
+			TX_STAT_INC(txq->axq_qnum, a_queued_hw);
+
+			if (skb_queue_empty(&tid->buf_q))
+				ieee80211_sta_set_buffered(an->sta, i, false);
+		}
+		ath_txq_unlock_complete(sc, tid->ac->txq);
+	}
+
+	if (list_empty(&bf_q))
+		return;
+
+	info = IEEE80211_SKB_CB(bf_tail->bf_mpdu);
+	info->flags |= IEEE80211_TX_STATUS_EOSP;
+
+	bf = list_first_entry(&bf_q, struct ath_buf, list);
+	ath_txq_lock(sc, txq);
+	ath_tx_fill_desc(sc, bf, txq, 0);
+	ath_tx_txqaddbuf(sc, txq, &bf_q, false);
+	ath_txq_unlock(sc, txq);
+}
+
 /********************/
 /* Queue Management */
 /********************/
-- 
1.8.0.2

