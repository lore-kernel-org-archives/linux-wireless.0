Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45611 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYJ2Eqg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:46:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:46:36 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.59919.63853.130010@gargle.gargle.HOWL> (sfid-20081029_054639_205211_9BFED745)
Date: Wed, 29 Oct 2008 10:13:59 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 02/16] ath9k: Simplify node attach/detach routines
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |   15 +++--
 drivers/net/wireless/ath9k/core.h |    2 +-
 drivers/net/wireless/ath9k/recv.c |   81 +++++++++++-------------
 drivers/net/wireless/ath9k/xmit.c |  125 +++++++++++++++---------------------
 4 files changed, 99 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 49fc264..689a280 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1366,9 +1366,10 @@ void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta, int if_id)
 
 	an = (struct ath_node *)sta->drv_priv;
 
-	/* set up per-node tx/rx state */
-	ath_tx_node_init(sc, an);
-	ath_rx_node_init(sc, an);
+	if (sc->sc_flags & SC_OP_TXAGGR)
+		ath_tx_node_init(sc, an);
+	if (sc->sc_flags & SC_OP_RXAGGR)
+		ath_rx_node_init(sc, an);
 
 	an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
 			     sta->ht_cap.ampdu_factor);
@@ -1384,10 +1385,10 @@ void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 
 	ath_chainmask_sel_timerstop(&an->an_chainmask_sel);
 
-	ath_tx_node_cleanup(sc, an);
-
-	ath_tx_node_free(sc, an);
-	ath_rx_node_free(sc, an);
+	if (sc->sc_flags & SC_OP_TXAGGR)
+		ath_tx_node_cleanup(sc, an);
+	if (sc->sc_flags & SC_OP_RXAGGR)
+		ath_rx_node_cleanup(sc, an);
 }
 
 /*
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index d7228ec..d8aafff 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -372,7 +372,7 @@ bool ath_stoprecv(struct ath_softc *sc);
 void ath_flushrecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
 void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an);
-void ath_rx_node_free(struct ath_softc *sc, struct ath_node *an);
+void ath_rx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
 void ath_handle_rx_intr(struct ath_softc *sc);
 int ath_rx_init(struct ath_softc *sc, int nbufs);
 void ath_rx_cleanup(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 6b4006e..27d6a98 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -1200,61 +1200,56 @@ void ath_rx_aggr_teardown(struct ath_softc *sc, struct ath_node *an, u8 tid)
 
 void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an)
 {
-	if (sc->sc_flags & SC_OP_RXAGGR) {
-		struct ath_arx_tid *rxtid;
-		int tidno;
-
-		/* Init per tid rx state */
-		for (tidno = 0, rxtid = &an->an_aggr.rx.tid[tidno];
-				tidno < WME_NUM_TID;
-				tidno++, rxtid++) {
-			rxtid->an        = an;
-			rxtid->seq_reset = 1;
-			rxtid->seq_next  = 0;
-			rxtid->baw_size  = WME_MAX_BA;
-			rxtid->baw_head  = rxtid->baw_tail = 0;
+	struct ath_arx_tid *rxtid;
+	int tidno;
+
+	/* Init per tid rx state */
+	for (tidno = 0, rxtid = &an->an_aggr.rx.tid[tidno];
+	     tidno < WME_NUM_TID;
+	     tidno++, rxtid++) {
+		rxtid->an        = an;
+		rxtid->seq_reset = 1;
+		rxtid->seq_next  = 0;
+		rxtid->baw_size  = WME_MAX_BA;
+		rxtid->baw_head  = rxtid->baw_tail = 0;
 
-			/*
-			 * Ensure the buffer pointer is null at this point
-			 * (needs to be allocated when addba is received)
-			*/
+		/*
+		 * Ensure the buffer pointer is null at this point
+		 * (needs to be allocated when addba is received)
+		 */
 
-			rxtid->rxbuf     = NULL;
-			setup_timer(&rxtid->timer, ath_rx_timer,
-				(unsigned long)rxtid);
-			spin_lock_init(&rxtid->tidlock);
+		rxtid->rxbuf     = NULL;
+		setup_timer(&rxtid->timer, ath_rx_timer,
+			    (unsigned long)rxtid);
+		spin_lock_init(&rxtid->tidlock);
 
-			/* ADDBA state */
-			rxtid->addba_exchangecomplete = 0;
-		}
+		/* ADDBA state */
+		rxtid->addba_exchangecomplete = 0;
 	}
 }
 
-void ath_rx_node_free(struct ath_softc *sc, struct ath_node *an)
+void ath_rx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 {
-	if (sc->sc_flags & SC_OP_RXAGGR) {
-		struct ath_arx_tid *rxtid;
-		int tidno, i;
+	struct ath_arx_tid *rxtid;
+	int tidno, i;
 
-		/* Init per tid rx state */
-		for (tidno = 0, rxtid = &an->an_aggr.rx.tid[tidno];
-				tidno < WME_NUM_TID;
-				tidno++, rxtid++) {
+	/* Init per tid rx state */
+	for (tidno = 0, rxtid = &an->an_aggr.rx.tid[tidno];
+	     tidno < WME_NUM_TID;
+	     tidno++, rxtid++) {
 
-			if (!rxtid->addba_exchangecomplete)
-				continue;
+		if (!rxtid->addba_exchangecomplete)
+			continue;
 
-			/* must cancel timer first */
-			del_timer_sync(&rxtid->timer);
+		/* must cancel timer first */
+		del_timer_sync(&rxtid->timer);
 
-			/* drop any pending sub-frames */
-			ath_rx_flush_tid(sc, rxtid, 1);
+		/* drop any pending sub-frames */
+		ath_rx_flush_tid(sc, rxtid, 1);
 
-			for (i = 0; i < ATH_TID_MAX_BUFS; i++)
-				ASSERT(rxtid->rxbuf[i].rx_wbuf == NULL);
+		for (i = 0; i < ATH_TID_MAX_BUFS; i++)
+			ASSERT(rxtid->rxbuf[i].rx_wbuf == NULL);
 
-			rxtid->addba_exchangecomplete = 0;
-		}
+		rxtid->addba_exchangecomplete = 0;
 	}
-
 }
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 70339f3..bea03db 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2566,62 +2566,60 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 {
-	if (sc->sc_flags & SC_OP_TXAGGR) {
-		struct ath_atx_tid *tid;
-		struct ath_atx_ac *ac;
-		int tidno, acno;
-
-		/*
-		 * Init per tid tx state
-		 */
-		for (tidno = 0, tid = &an->an_aggr.tx.tid[tidno];
-				tidno < WME_NUM_TID;
-				tidno++, tid++) {
-			tid->an        = an;
-			tid->tidno     = tidno;
-			tid->seq_start = tid->seq_next = 0;
-			tid->baw_size  = WME_MAX_BA;
-			tid->baw_head  = tid->baw_tail = 0;
-			tid->sched     = false;
-			tid->paused = false;
-			tid->cleanup_inprogress = false;
-			INIT_LIST_HEAD(&tid->buf_q);
-
-			acno = TID_TO_WME_AC(tidno);
-			tid->ac = &an->an_aggr.tx.ac[acno];
+	struct ath_atx_tid *tid;
+	struct ath_atx_ac *ac;
+	int tidno, acno;
 
-			/* ADDBA state */
-			tid->addba_exchangecomplete     = 0;
-			tid->addba_exchangeinprogress   = 0;
-			tid->addba_exchangeattempts     = 0;
-		}
+	/*
+	 * Init per tid tx state
+	 */
+	for (tidno = 0, tid = &an->an_aggr.tx.tid[tidno];
+	     tidno < WME_NUM_TID;
+	     tidno++, tid++) {
+		tid->an        = an;
+		tid->tidno     = tidno;
+		tid->seq_start = tid->seq_next = 0;
+		tid->baw_size  = WME_MAX_BA;
+		tid->baw_head  = tid->baw_tail = 0;
+		tid->sched     = false;
+		tid->paused = false;
+		tid->cleanup_inprogress = false;
+		INIT_LIST_HEAD(&tid->buf_q);
+
+		acno = TID_TO_WME_AC(tidno);
+		tid->ac = &an->an_aggr.tx.ac[acno];
+
+		/* ADDBA state */
+		tid->addba_exchangecomplete     = 0;
+		tid->addba_exchangeinprogress   = 0;
+		tid->addba_exchangeattempts     = 0;
+	}
 
-		/*
-		 * Init per ac tx state
-		 */
-		for (acno = 0, ac = &an->an_aggr.tx.ac[acno];
-				acno < WME_NUM_AC; acno++, ac++) {
-			ac->sched    = false;
-			INIT_LIST_HEAD(&ac->tid_q);
-
-			switch (acno) {
-			case WME_AC_BE:
-				ac->qnum = ath_tx_get_qnum(sc,
-					ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
-				break;
-			case WME_AC_BK:
-				ac->qnum = ath_tx_get_qnum(sc,
-					ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BK);
-				break;
-			case WME_AC_VI:
-				ac->qnum = ath_tx_get_qnum(sc,
-					ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_VI);
-				break;
-			case WME_AC_VO:
-				ac->qnum = ath_tx_get_qnum(sc,
-					ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_VO);
-				break;
-			}
+	/*
+	 * Init per ac tx state
+	 */
+	for (acno = 0, ac = &an->an_aggr.tx.ac[acno];
+	     acno < WME_NUM_AC; acno++, ac++) {
+		ac->sched    = false;
+		INIT_LIST_HEAD(&ac->tid_q);
+
+		switch (acno) {
+		case WME_AC_BE:
+			ac->qnum = ath_tx_get_qnum(sc,
+				   ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
+			break;
+		case WME_AC_BK:
+			ac->qnum = ath_tx_get_qnum(sc,
+				   ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BK);
+			break;
+		case WME_AC_VI:
+			ac->qnum = ath_tx_get_qnum(sc,
+				   ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_VI);
+			break;
+		case WME_AC_VO:
+			ac->qnum = ath_tx_get_qnum(sc,
+				   ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_VO);
+			break;
 		}
 	}
 }
@@ -2665,25 +2663,6 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 	}
 }
 
-/* Cleanup per node transmit state */
-
-void ath_tx_node_free(struct ath_softc *sc, struct ath_node *an)
-{
-	if (sc->sc_flags & SC_OP_TXAGGR) {
-		struct ath_atx_tid *tid;
-		int tidno, i;
-
-		/* Init per tid rx state */
-		for (tidno = 0, tid = &an->an_aggr.tx.tid[tidno];
-			tidno < WME_NUM_TID;
-		     tidno++, tid++) {
-
-			for (i = 0; i < ATH_TID_MAX_BUFS; i++)
-				ASSERT(tid->tx_buf[i] == NULL);
-		}
-	}
-}
-
 void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
 {
 	int hdrlen, padsize;
-- 
1.6.0.3

