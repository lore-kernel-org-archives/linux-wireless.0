Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39180 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3EGXgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 19:36:01 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: Fix TID locking
Date: Wed,  8 May 2013 05:03:33 +0530
Message-Id: <1367969613-1867-4-git-send-email-sujith@msujith.org> (sfid-20130508_013607_632326_153467D6)
In-Reply-To: <1367969613-1867-1-git-send-email-sujith@msujith.org>
References: <1367969613-1867-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The TID state is accessed from various contexts without any
protection. Use the TX queue lock associated with the AC
to make sure that the TID data is locked properly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c   | 12 ++++++++----
 drivers/net/wireless/ath/ath9k/xmit.c | 37 ++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index aa4d368..aa1b63f 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1221,15 +1221,19 @@ static bool ath_tx_aggr_check(struct ath_softc *sc, struct ieee80211_sta *sta,
 			      u8 tidno)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
-	struct ath_atx_tid *txtid;
+	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tidno);
+	struct ath_txq *txq = txtid->ac->txq;
 
 	if (!sta->ht_cap.ht_supported)
 		return false;
 
-	txtid = ATH_AN_2_TID(an, tidno);
+	ath_txq_lock(sc, txq);
+	if (!(txtid->state & (AGGR_ADDBA_COMPLETE | AGGR_ADDBA_PROGRESS))) {
+		ath_txq_unlock(sc, txq);
+		return true;
+	}
+	ath_txq_unlock(sc, txq);
 
-	if (!(txtid->state & (AGGR_ADDBA_COMPLETE | AGGR_ADDBA_PROGRESS)))
-			return true;
 	return false;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index eab0fcb..655057d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -131,16 +131,13 @@ static void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 
 	WARN_ON(!tid->paused);
 
-	ath_txq_lock(sc, txq);
 	tid->paused = false;
 
 	if (skb_queue_empty(&tid->buf_q))
-		goto unlock;
+		return;
 
 	ath_tx_queue_tid(txq, tid);
 	ath_txq_schedule(sc, txq);
-unlock:
-	ath_txq_unlock_complete(sc, txq);
 }
 
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
@@ -1224,15 +1221,17 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn)
 {
-	struct ath_atx_tid *txtid;
-	struct ath_node *an;
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
+	struct ath_txq *txq = txtid->ac->txq;
 	u8 density;
 
-	an = (struct ath_node *)sta->drv_priv;
-	txtid = ATH_AN_2_TID(an, tid);
+	ath_txq_lock(sc, txq);
 
-	if (txtid->state & (AGGR_CLEANUP | AGGR_ADDBA_COMPLETE))
+	if (txtid->state & (AGGR_CLEANUP | AGGR_ADDBA_COMPLETE)) {
+		ath_txq_unlock(sc, txq);
 		return -EAGAIN;
+	}
 
 	/* update ampdu factor/density, they may have changed. This may happen
 	 * in HT IBSS when a beacon with HT-info is received after the station
@@ -1253,6 +1252,8 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	memset(txtid->tx_buf, 0, sizeof(txtid->tx_buf));
 	txtid->baw_head = txtid->baw_tail = 0;
 
+	ath_txq_unlock(sc, txq);
+
 	return 0;
 }
 
@@ -1262,15 +1263,19 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
 	struct ath_txq *txq = txtid->ac->txq;
 
-	if (txtid->state & AGGR_CLEANUP)
+	ath_txq_lock(sc, txq);
+
+	if (txtid->state & AGGR_CLEANUP) {
+		ath_txq_unlock(sc, txq);
 		return;
+	}
 
 	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
 		txtid->state &= ~AGGR_ADDBA_PROGRESS;
+		ath_txq_unlock(sc, txq);
 		return;
 	}
 
-	ath_txq_lock(sc, txq);
 	txtid->paused = true;
 
 	/*
@@ -1351,16 +1356,16 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
-	struct ath_atx_tid *txtid;
-	struct ath_node *an;
-
-	an = (struct ath_node *)sta->drv_priv;
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
+	struct ath_txq *txq = txtid->ac->txq;
 
-	txtid = ATH_AN_2_TID(an, tid);
+	ath_txq_lock(sc, txq);
 	txtid->baw_size = IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
 	txtid->state |= AGGR_ADDBA_COMPLETE;
 	txtid->state &= ~AGGR_ADDBA_PROGRESS;
 	ath_tx_resume_tid(sc, txtid);
+	ath_txq_unlock_complete(sc, txq);
 }
 
 /********************/
-- 
1.8.2.2

