Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33672 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125Ab1LNVIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 16:08:19 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 6/6] ath9k: avoid retransmitting aggregation frames that a BAR was sent for
Date: Wed, 14 Dec 2011 22:08:08 +0100
Message-Id: <1323896888-85551-6-git-send-email-nbd@openwrt.org> (sfid-20111214_220824_909265_65C55DA4)
In-Reply-To: <1323896888-85551-5-git-send-email-nbd@openwrt.org>
References: <1323896888-85551-1-git-send-email-nbd@openwrt.org>
 <1323896888-85551-2-git-send-email-nbd@openwrt.org>
 <1323896888-85551-3-git-send-email-nbd@openwrt.org>
 <1323896888-85551-4-git-send-email-nbd@openwrt.org>
 <1323896888-85551-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The receiver will discard them anyway.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   27 ++++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6beaff5..130e5db 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -241,6 +241,7 @@ struct ath_atx_tid {
 	struct ath_node *an;
 	struct ath_atx_ac *ac;
 	unsigned long tx_buf[BITS_TO_LONGS(ATH_TID_MAX_BUFS)];
+	int bar_index;
 	u16 seq_start;
 	u16 seq_next;
 	u16 baw_size;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8766796..23e80e6 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -206,6 +206,8 @@ static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 	while (tid->baw_head != tid->baw_tail && !test_bit(tid->baw_head, tid->tx_buf)) {
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 		INCR(tid->baw_head, ATH_TID_MAX_BUFS);
+		if (tid->bar_index >= 0)
+			tid->bar_index--;
 	}
 }
 
@@ -263,6 +265,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 
 	tid->seq_next = tid->seq_start;
 	tid->baw_tail = tid->baw_head;
+	tid->bar_index = -1;
 }
 
 static void ath_tx_set_retry(struct ath_softc *sc, struct ath_txq *txq,
@@ -551,8 +554,12 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		bf = bf_next;
 	}
 
-	if (bar_index >= 0)
+	if (bar_index >= 0) {
+		u16 bar_seq = ATH_BA_INDEX2SEQ(seq_first, bar_index);
 		ath_send_bar(tid, ATH_BA_INDEX2SEQ(seq_first, bar_index + 1));
+		if (BAW_WITHIN(tid->seq_start, tid->baw_size, bar_seq))
+			tid->bar_index = ATH_BA_INDEX(tid->seq_start, bar_seq);
+	}
 
 	/* prepend un-acked frames to the beginning of the pending frame queue */
 	if (!skb_queue_empty(&bf_pending)) {
@@ -779,8 +786,6 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 
 		bf->bf_state.bf_type = BUF_AMPDU | BUF_AGGR;
 		seqno = bf->bf_state.seqno;
-		if (!bf_first)
-			bf_first = bf;
 
 		/* do not step over block-ack window */
 		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno)) {
@@ -788,6 +793,21 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 			break;
 		}
 
+		if (tid->bar_index > ATH_BA_INDEX(tid->seq_start, seqno)) {
+			struct ath_tx_status ts = {};
+			struct list_head bf_head;
+
+			INIT_LIST_HEAD(&bf_head);
+			list_add(&bf->list, &bf_head);
+			__skb_unlink(skb, &tid->buf_q);
+			ath_tx_update_baw(sc, tid, seqno);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
+			continue;
+		}
+
+		if (!bf_first)
+			bf_first = bf;
+
 		if (!rl) {
 			aggr_limit = ath_lookup_rate(sc, bf, tid);
 			rl = 1;
@@ -1130,6 +1150,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	txtid->state |= AGGR_ADDBA_PROGRESS;
 	txtid->paused = true;
 	*ssn = txtid->seq_start = txtid->seq_next;
+	txtid->bar_index = -1;
 
 	memset(txtid->tx_buf, 0, sizeof(txtid->tx_buf));
 	txtid->baw_head = txtid->baw_tail = 0;
-- 
1.7.3.2

