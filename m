Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57811 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab3HFMSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 08:18:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 06/12] ath9k: fix block ack window tracking check
Date: Tue,  6 Aug 2013 14:18:07 +0200
Message-Id: <1375791493-83971-6-git-send-email-nbd@openwrt.org> (sfid-20130806_141840_028077_967D775C)
In-Reply-To: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
References: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a packet has been tracked as part of the BlockAck window and added
to the hardware queue, it can end up back in the TID queue again with
fi->retries still set to 0 (e.g. if the frame was filtered). Keep an
extra bit for the BAW tracking status to fix this corner case.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c  | 15 +++++++++------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 725515f..126f980 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -211,8 +211,9 @@ struct ath_frame_info {
 	int framelen;
 	enum ath9k_key_type keytype;
 	u8 keyix;
-	u8 retries;
 	u8 rtscts_rate;
+	u8 retries : 7;
+	u8 baw_tracked : 1;
 };
 
 struct ath_buf_state {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 887f2d4..d66e8b8 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -225,7 +225,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 			}
 		}
 
-		if (fi->retries) {
+		if (fi->baw_tracked) {
 			list_add_tail(&bf->list, &bf_head);
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
@@ -262,13 +262,16 @@ static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 }
 
 static void ath_tx_addto_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
-			     u16 seqno)
+			     struct ath_buf *bf)
 {
+	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
+	u16 seqno = bf->bf_state.seqno;
 	int index, cindex;
 
 	index  = ATH_BA_INDEX(tid->seq_start, seqno);
 	cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
 	__set_bit(cindex, tid->tx_buf);
+	fi->baw_tracked = 1;
 
 	if (index >= ((tid->baw_tail - tid->baw_head) &
 		(ATH_TID_MAX_BUFS - 1))) {
@@ -960,8 +963,8 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		bf->bf_next = NULL;
 
 		/* link buffers of this frame to the aggregate */
-		if (!fi->retries)
-			ath_tx_addto_baw(sc, tid, bf->bf_state.seqno);
+		if (!fi->baw_tracked)
+			ath_tx_addto_baw(sc, tid, bf);
 		bf->bf_state.ndelim = ndelim;
 
 		__skb_unlink(skb, tid_q);
@@ -1479,7 +1482,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 			__skb_unlink(bf->bf_mpdu, tid_q);
 			list_add_tail(&bf->list, &bf_q);
 			ath_set_rates(tid->an->vif, tid->an->sta, bf);
-			ath_tx_addto_baw(sc, tid, bf->bf_state.seqno);
+			ath_tx_addto_baw(sc, tid, bf);
 			bf->bf_state.bf_type &= ~BUF_AGGR;
 			if (bf_tail)
 				bf_tail->bf_next = bf;
@@ -1912,7 +1915,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_txq *txq,
 	list_add(&bf->list, &bf_head);
 
 	/* Add sub-frame to BAW */
-	ath_tx_addto_baw(sc, tid, bf->bf_state.seqno);
+	ath_tx_addto_baw(sc, tid, bf);
 
 	/* Queue to h/w without aggregation */
 	TX_STAT_INC(txq->axq_qnum, a_queued_hw);
-- 
1.8.0.2

