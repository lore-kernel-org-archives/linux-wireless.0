Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57809 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268Ab3HFMSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 08:18:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 02/12] ath9k: split tid retry packets into a separate queue
Date: Tue,  6 Aug 2013 14:18:03 +0200
Message-Id: <1375791493-83971-2-git-send-email-nbd@openwrt.org> (sfid-20130806_141829_500943_DD23A3E3)
In-Reply-To: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
References: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improves packet retry order and helps with further tx queueing
improvements.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/xmit.c  | 18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c497d52..2ce79c1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -241,6 +241,7 @@ struct ath_buf {
 struct ath_atx_tid {
 	struct list_head list;
 	struct sk_buff_head buf_q;
+	struct sk_buff_head retry_q;
 	struct ath_node *an;
 	struct ath_atx_ac *ac;
 	unsigned long tx_buf[BITS_TO_LONGS(ATH_TID_MAX_BUFS)];
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index eaa9eaf..c2b6cf0 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -170,12 +170,18 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 
 static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
 {
-	return !skb_queue_empty(&tid->buf_q);
+	return !skb_queue_empty(&tid->buf_q) || !skb_queue_empty(&tid->retry_q);
 }
 
 static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
 {
-	return __skb_dequeue(&tid->buf_q);
+	struct sk_buff *skb;
+
+	skb = __skb_dequeue(&tid->retry_q);
+	if (!skb)
+		skb = __skb_dequeue(&tid->buf_q);
+
+	return skb;
 }
 
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
@@ -593,7 +599,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		if (an->sleeping)
 			ieee80211_sta_set_buffered(sta, tid->tidno, true);
 
-		skb_queue_splice(&bf_pending, &tid->buf_q);
+		skb_queue_splice_tail(&bf_pending, &tid->retry_q);
 		if (!an->sleeping) {
 			ath_tx_queue_tid(txq, tid);
 
@@ -833,7 +839,10 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 	u16 seqno;
 
 	while (1) {
-		*q = &tid->buf_q;
+		*q = &tid->retry_q;
+		if (skb_queue_empty(*q))
+			*q = &tid->buf_q;
+
 		skb = skb_peek(*q);
 		if (!skb)
 			break;
@@ -2636,6 +2645,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->paused    = false;
 		tid->active	   = false;
 		__skb_queue_head_init(&tid->buf_q);
+		__skb_queue_head_init(&tid->retry_q);
 		acno = TID_TO_WME_AC(tidno);
 		tid->ac = &an->ac[acno];
 	}
-- 
1.8.0.2

