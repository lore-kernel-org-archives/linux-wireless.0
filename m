Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25329 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbYJ2Esu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:48:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:48:50 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.60020.399784.543071@gargle.gargle.HOWL> (sfid-20081029_054853_023105_D388771D)
Date: Wed, 29 Oct 2008 10:15:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 06/16] ath9k: Use bitfields to store tid's state in a single variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    8 ++++--
 drivers/net/wireless/ath9k/rc.c   |    4 +-
 drivers/net/wireless/ath9k/xmit.c |   49 +++++++++++++++----------------------
 3 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 27ed084..d89dd03 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -447,6 +447,10 @@ struct ath_txq {
 	struct list_head axq_acq;
 };
 
+#define AGGR_CLEANUP         BIT(1)
+#define AGGR_ADDBA_COMPLETE  BIT(2)
+#define AGGR_ADDBA_PROGRESS  BIT(3)
+
 /* per TID aggregate tx state for a destination */
 struct ath_atx_tid {
 	struct list_head list;		/* round-robin tid entry */
@@ -462,9 +466,7 @@ struct ath_atx_tid {
 	int baw_tail;			/* next unused tx buffer slot */
 	int sched;
 	int paused;
-	int cleanup_inprogress;
-	u32 addba_exchangecomplete:1;
-	int32_t addba_exchangeinprogress;
+	u8 state;
 	int addba_exchangeattempts;
 };
 
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index d55232a..f234a9b 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1909,8 +1909,8 @@ static void ath_tx_aggr_resp(struct ath_softc *sc,
 	state = si->ampdu_mlme.tid_state_tx[tidno];
 
 	if (state & HT_ADDBA_RECEIVED_MSK) {
-		txtid->addba_exchangecomplete = 1;
-		txtid->addba_exchangeinprogress = 0;
+		txtid->state |= AGGR_ADDBA_COMPLETE;
+		txtid->state &= ~AGGR_ADDBA_PROGRESS;
 		txtid->baw_size = buffersize;
 
 		DPRINTF(sc, ATH_DBG_AGGR,
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 8446ede..2d9fd10 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -125,13 +125,13 @@ static int ath_tx_findindex(const struct ath9k_rate_table *rt, int rate)
 
 /* Check if it's okay to send out aggregates */
 
-static int ath_aggr_query(struct ath_softc *sc,
-	struct ath_node *an, u8 tidno)
+static int ath_aggr_query(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 {
 	struct ath_atx_tid *tid;
 	tid = ATH_AN_2_TID(an, tidno);
 
-	if (tid->addba_exchangecomplete || tid->addba_exchangeinprogress)
+	if (tid->state & AGGR_ADDBA_COMPLETE ||
+	    tid->state & AGGR_ADDBA_PROGRESS)
 		return 1;
 	else
 		return 0;
@@ -886,7 +886,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 			/* transmit completion */
 		} else {
 
-			if (!tid->cleanup_inprogress &&
+			if (!(tid->state & AGGR_CLEANUP) &&
 			    ds->ds_txstat.ts_flags != ATH9K_TX_SW_ABORTED) {
 				if (bf->bf_retries < ATH_MAX_SW_RETRIES) {
 					ath_tx_set_retry(sc, bf);
@@ -1014,16 +1014,16 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 		bf = bf_next;
 	}
 
-	if (tid->cleanup_inprogress) {
+	if (tid->state & AGGR_CLEANUP) {
 		/* check to see if we're done with cleaning the h/w queue */
 		spin_lock_bh(&txq->axq_lock);
 
 		if (tid->baw_head == tid->baw_tail) {
-			tid->addba_exchangecomplete = 0;
+			tid->state &= ~AGGR_ADDBA_COMPLETE;
 			tid->addba_exchangeattempts = 0;
 			spin_unlock_bh(&txq->axq_lock);
 
-			tid->cleanup_inprogress = false;
+			tid->state &= ~AGGR_CLEANUP;
 
 			/* send buffered frames as singles */
 			ath_tx_flush_tid(sc, tid);
@@ -2336,17 +2336,8 @@ enum ATH_AGGR_CHECK ath_tx_aggr_check(struct ath_softc *sc,
 	/* ADDBA exchange must be completed before sending aggregates */
 	txtid = ATH_AN_2_TID(an, tidno);
 
-	if (txtid->addba_exchangecomplete)
-		return AGGR_EXCHANGE_DONE;
-
-	if (txtid->cleanup_inprogress)
-		return AGGR_CLEANUP_PROGRESS;
-
-	if (txtid->addba_exchangeinprogress)
-		return AGGR_EXCHANGE_PROGRESS;
-
-	if (!txtid->addba_exchangecomplete) {
-		if (!txtid->addba_exchangeinprogress &&
+	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
+		if (!(txtid->state & AGGR_ADDBA_PROGRESS) &&
 		    (txtid->addba_exchangeattempts < ADDBA_EXCHANGE_ATTEMPTS)) {
 			txtid->addba_exchangeattempts++;
 			return AGGR_REQUIRED;
@@ -2368,7 +2359,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		txtid = ATH_AN_2_TID(an, tid);
-		txtid->addba_exchangeinprogress = 1;
+		txtid->state |= AGGR_ADDBA_PROGRESS;
 		ath_tx_pause_tid(sc, txtid);
 	}
 
@@ -2402,10 +2393,10 @@ void ath_tx_aggr_teardown(struct ath_softc *sc, struct ath_node *an, u8 tid)
 
 	DPRINTF(sc, ATH_DBG_AGGR, "%s: teardown TX aggregation\n", __func__);
 
-	if (txtid->cleanup_inprogress) /* cleanup is in progress */
+	if (txtid->state & AGGR_CLEANUP) /* cleanup is in progress */
 		return;
 
-	if (!txtid->addba_exchangecomplete) {
+	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
 		txtid->addba_exchangeattempts = 0;
 		return;
 	}
@@ -2435,9 +2426,9 @@ void ath_tx_aggr_teardown(struct ath_softc *sc, struct ath_node *an, u8 tid)
 
 	if (txtid->baw_head != txtid->baw_tail) {
 		spin_unlock_bh(&txq->axq_lock);
-		txtid->cleanup_inprogress = true;
+		txtid->state |= AGGR_CLEANUP;
 	} else {
-		txtid->addba_exchangecomplete = 0;
+		txtid->state &= ~AGGR_ADDBA_COMPLETE;
 		txtid->addba_exchangeattempts = 0;
 		spin_unlock_bh(&txq->axq_lock);
 		ath_tx_flush_tid(sc, txtid);
@@ -2528,16 +2519,16 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->baw_head  = tid->baw_tail = 0;
 		tid->sched     = false;
 		tid->paused = false;
-		tid->cleanup_inprogress = false;
+		tid->state &= ~AGGR_CLEANUP;
 		INIT_LIST_HEAD(&tid->buf_q);
 
 		acno = TID_TO_WME_AC(tidno);
 		tid->ac = &an->an_aggr.tx.ac[acno];
 
 		/* ADDBA state */
-		tid->addba_exchangecomplete     = 0;
-		tid->addba_exchangeinprogress   = 0;
-		tid->addba_exchangeattempts     = 0;
+		tid->state &= ~AGGR_ADDBA_COMPLETE;
+		tid->state &= ~AGGR_ADDBA_PROGRESS;
+		tid->addba_exchangeattempts = 0;
 	}
 
 	/*
@@ -2597,9 +2588,9 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 					list_del(&tid->list);
 					tid->sched = false;
 					ath_tid_drain(sc, txq, tid);
-					tid->addba_exchangecomplete = 0;
+					tid->state &= ~AGGR_ADDBA_COMPLETE;
 					tid->addba_exchangeattempts = 0;
-					tid->cleanup_inprogress = false;
+					tid->state &= ~AGGR_CLEANUP;
 				}
 			}
 
-- 
1.6.0.3

