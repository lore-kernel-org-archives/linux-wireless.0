Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48474 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0HANrj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 09:47:39 -0400
Message-ID: <4C557AF4.8080908@openwrt.org>
Date: Sun, 01 Aug 2010 15:47:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Subject: [PATCH] ath9k: fix an issue in ath_atx_tid paused flag management
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

I noticed a possible issue in the paused flag management of the
ath_atx_tid data structure. In particular, in a noisy environment and
under heavy load, I observed that the AGGR session establishment could
fail several times consecutively causing values of the paused flag
greater than one for this TID (ath_tx_pause_tid is called more than
once from ath_tx_aggr_start).

Considering that the session for this TID can not be established also
after the mac80211 stack calls the ieee80211_agg_tx_operational() since
the ath_tx_aggr_resume() lowers the paused flag only by one.

This patch also replaces some BUG_ON calls with WARN_ON, as even if
these unlikely conditions happen, it's not fatal enough to justify a
BUG_ON.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -120,26 +120,14 @@ static void ath_tx_queue_tid(struct ath_
 	list_add_tail(&ac->list, &txq->axq_acq);
 }
 
-static void ath_tx_pause_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
-{
-	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
-
-	spin_lock_bh(&txq->axq_lock);
-	tid->paused++;
-	spin_unlock_bh(&txq->axq_lock);
-}
-
 static void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
 
-	BUG_ON(tid->paused <= 0);
-	spin_lock_bh(&txq->axq_lock);
-
-	tid->paused--;
+	WARN_ON(!tid->paused);
 
-	if (tid->paused > 0)
-		goto unlock;
+	spin_lock_bh(&txq->axq_lock);
+	tid->paused = false;
 
 	if (list_empty(&tid->buf_q))
 		goto unlock;
@@ -157,15 +145,10 @@ static void ath_tx_flush_tid(struct ath_
 	struct list_head bf_head;
 	INIT_LIST_HEAD(&bf_head);
 
-	BUG_ON(tid->paused <= 0);
-	spin_lock_bh(&txq->axq_lock);
+	WARN_ON(!tid->paused);
 
-	tid->paused--;
-
-	if (tid->paused > 0) {
-		spin_unlock_bh(&txq->axq_lock);
-		return;
-	}
+	spin_lock_bh(&txq->axq_lock);
+	tid->paused = false;
 
 	while (!list_empty(&tid->buf_q)) {
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
@@ -811,7 +794,7 @@ void ath_tx_aggr_start(struct ath_softc 
 	an = (struct ath_node *)sta->drv_priv;
 	txtid = ATH_AN_2_TID(an, tid);
 	txtid->state |= AGGR_ADDBA_PROGRESS;
-	ath_tx_pause_tid(sc, txtid);
+	txtid->paused = true;
 	*ssn = txtid->seq_start;
 }
 
@@ -835,10 +818,9 @@ void ath_tx_aggr_stop(struct ath_softc *
 		return;
 	}
 
-	ath_tx_pause_tid(sc, txtid);
-
 	/* drop all software retried frames and mark this TID */
 	spin_lock_bh(&txq->axq_lock);
+	txtid->paused = true;
 	while (!list_empty(&txtid->buf_q)) {
 		bf = list_first_entry(&txtid->buf_q, struct ath_buf, list);
 		if (!bf_isretried(bf)) {
