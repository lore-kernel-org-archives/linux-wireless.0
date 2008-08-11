Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52544 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYHKIoX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:44:23 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:44:23 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63797.263181.681201@localhost.localdomain> (sfid-20080811_104426_223425_FA382FE6)
Date: Mon, 11 Aug 2008 14:02:53 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 01/10] ath9k: Merge reset functions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath9k/core.c   |   73 +++++++++++------------------------
 drivers/net/wireless/ath9k/core.h   |    3 +-
 drivers/net/wireless/ath9k/recv.c   |    2 +-
 drivers/net/wireless/ath9k/xmit.c   |    2 +-
 5 files changed, 27 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index caf5694..67a8046 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -719,7 +719,7 @@ void ath_bstuck_process(struct ath_softc *sc)
 	DPRINTF(sc, ATH_DBG_BEACON,
 		"%s: stuck beacon; resetting (bmiss count %u)\n",
 		__func__, sc->sc_bmisscount);
-	ath_internal_reset(sc);
+	ath_reset(sc, false);
 }
 
 /*
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index f6c4528..10f2729 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -828,29 +828,30 @@ done:
 	return error;
 }
 
-/*
- * Reset the hardware w/o losing operational state.  This is
- * basically a more efficient way of doing ath_stop, ath_init,
- * followed by state transitions to the current 802.11
- * operational state.  Used to recover from errors rx overrun
- * and to reset the hardware when rf gain settings must be reset.
- */
-
-static int ath_reset_start(struct ath_softc *sc, u32 flag)
+int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
+	int status;
+	int error = 0;
+	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
 	ath9k_hw_set_interrupts(ah, 0);	/* disable interrupts */
-	ath_draintxq(sc, flag & RESET_RETRY_TXQ);	/* stop xmit side */
-	ath_stoprecv(sc);	/* stop recv side */
-	ath_flushrecv(sc);	/* flush recv queue */
-
-	return 0;
-}
+	ath_draintxq(sc, retry_tx);	/* stop xmit */
+	ath_stoprecv(sc);		/* stop recv */
+	ath_flushrecv(sc);		/* flush recv queue */
 
-static int ath_reset_end(struct ath_softc *sc, u32 flag)
-{
-	struct ath_hal *ah = sc->sc_ah;
+	/* Reset chip */
+	spin_lock_bh(&sc->sc_resetlock);
+	if (!ath9k_hw_reset(ah, sc->sc_opmode, &sc->sc_curchan,
+			   ht_macmode,
+			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
+			   sc->sc_ht_extprotspacing, false, &status)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: unable to reset hardware; hal status %u\n",
+			__func__, status);
+		error = -EIO;
+	}
+	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0)	/* restart recv */
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -863,14 +864,15 @@ static int ath_reset_end(struct ath_softc *sc, u32 flag)
 	 */
 	ath_setcurmode(sc, ath_chan2mode(&sc->sc_curchan));
 
-	ath_update_txpow(sc);	/* update tx power state */
+	ath_update_txpow(sc);
 
 	if (sc->sc_beacons)
 		ath_beacon_config(sc, ATH_IF_ID_ANY);	/* restart beacons */
+
 	ath9k_hw_set_interrupts(ah, sc->sc_imask);
 
 	/* Restart the txq */
-	if (flag & RESET_RETRY_TXQ) {
+	if (retry_tx) {
 		int i;
 		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 			if (ATH_TXQ_SETUP(sc, i)) {
@@ -880,28 +882,6 @@ static int ath_reset_end(struct ath_softc *sc, u32 flag)
 			}
 		}
 	}
-	return 0;
-}
-
-int ath_reset(struct ath_softc *sc)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	int status;
-	int error = 0;
-	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
-
-	/* NB: indicate channel change so we do a full reset */
-	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, sc->sc_opmode, &sc->sc_curchan,
-			   ht_macmode,
-			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			   sc->sc_ht_extprotspacing, false, &status)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to reset hardware; hal status %u\n",
-			__func__, status);
-		error = -EIO;
-	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	return error;
 }
@@ -1050,7 +1030,7 @@ static void ath9k_tasklet(unsigned long data)
 
 	if (status & ATH9K_INT_FATAL) {
 		/* need a chip reset */
-		ath_internal_reset(sc);
+		ath_reset(sc, false);
 		return;
 	} else {
 
@@ -1815,13 +1795,6 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 /* Utilities */
 /*************/
 
-void ath_internal_reset(struct ath_softc *sc)
-{
-	ath_reset_start(sc, 0);
-	ath_reset(sc);
-	ath_reset_end(sc, 0);
-}
-
 int ath_get_hal_qnum(u16 queue, struct ath_softc *sc)
 {
 	int qnum;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 673b3d8..ef8f637 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -1030,7 +1030,7 @@ void ath_deinit(struct ath_softc *sc);
 int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan);
 int ath_suspend(struct ath_softc *sc);
 irqreturn_t ath_isr(int irq, void *dev);
-int ath_reset(struct ath_softc *sc);
+int ath_reset(struct ath_softc *sc, bool retry_tx);
 void ath_scan_start(struct ath_softc *sc);
 void ath_scan_end(struct ath_softc *sc);
 int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan);
@@ -1056,7 +1056,6 @@ int ath_cabq_update(struct ath_softc *);
 void ath_get_currentCountry(struct ath_softc *sc,
 	struct ath9k_country_entry *ctry);
 u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp);
-void ath_internal_reset(struct ath_softc *sc);
 u32 ath_chan2flags(struct ieee80211_channel *chan, struct ath_softc *sc);
 dma_addr_t ath_skb_map_single(struct ath_softc *sc,
 			      struct sk_buff *skb,
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 2fe8061..838b656 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -1089,7 +1089,7 @@ rx_next:
 			"%s: Reset rx chain mask. "
 			"Do internal reset\n", __func__);
 		ASSERT(flush == 0);
-		ath_internal_reset(sc);
+		ath_reset(sc, false);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 157f830..93064cc 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1242,7 +1242,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 	}
 
 	if (needreset)
-		ath_internal_reset(sc);
+		ath_reset(sc, false);
 
 	return;
 }
-- 
1.5.6.5

