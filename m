Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58354 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZCCExH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 23:53:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 20:53:06 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18860.46785.374964.265308@gargle.gargle.HOWL> (sfid-20090303_055316_906090_C6DE67B0)
Date: Tue, 3 Mar 2009 10:19:05 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/7] ath9k: Cleanup beacon stuck processing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We never use SC_OP_NO_RESET, it is not configurable at all.
Remove all code that deals with this flag and make beacon
stuck processing simple.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |   21 ++++-----
 drivers/net/wireless/ath9k/beacon.c |   83 ++++++-----------------------------
 2 files changed, 24 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 7b1fbf3..497e6f3 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -549,17 +549,16 @@ struct ath_rfkill {
 #define SC_OP_TXAGGR		BIT(3)
 #define SC_OP_CHAINMASK_UPDATE	BIT(4)
 #define SC_OP_FULL_RESET	BIT(5)
-#define SC_OP_NO_RESET		BIT(6)
-#define SC_OP_PREAMBLE_SHORT	BIT(7)
-#define SC_OP_PROTECT_ENABLE	BIT(8)
-#define SC_OP_RXFLUSH		BIT(9)
-#define SC_OP_LED_ASSOCIATED	BIT(10)
-#define SC_OP_RFKILL_REGISTERED	BIT(11)
-#define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
-#define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
-#define SC_OP_WAIT_FOR_BEACON	BIT(14)
-#define SC_OP_LED_ON		BIT(15)
-#define SC_OP_SCANNING		BIT(16)
+#define SC_OP_PREAMBLE_SHORT	BIT(6)
+#define SC_OP_PROTECT_ENABLE	BIT(7)
+#define SC_OP_RXFLUSH		BIT(8)
+#define SC_OP_LED_ASSOCIATED	BIT(9)
+#define SC_OP_RFKILL_REGISTERED	BIT(10)
+#define SC_OP_RFKILL_SW_BLOCKED	BIT(11)
+#define SC_OP_RFKILL_HW_BLOCKED	BIT(12)
+#define SC_OP_WAIT_FOR_BEACON	BIT(13)
+#define SC_OP_LED_ON		BIT(14)
+#define SC_OP_SCANNING		BIT(15)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index c304489..349904c 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -49,13 +49,6 @@ static int ath_beaconq_config(struct ath_softc *sc)
 	}
 }
 
-static void ath_bstuck_process(struct ath_softc *sc)
-{
-	DPRINTF(sc, ATH_DBG_BEACON, "stuck beacon; resetting (bmiss count %u)\n",
-		sc->beacon.bmisscnt);
-	ath_reset(sc, false);
-}
-
 /*
  *  Associates the beacon frame buffer with a transmit descriptor.  Will set
  *  up all required antenna switch parameters, rate codes, and channel flags.
@@ -401,83 +394,37 @@ void ath_beacon_tasklet(unsigned long data)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf = NULL;
 	int slot, if_id;
-	u32 bfaddr, show_cycles = 0, bc = 0, tsftu;
-	u32 rx_clear = 0, rx_frame = 0, tx_frame = 0;
+	u32 bfaddr, bc = 0, tsftu;
 	u64 tsf;
 	u16 intval;
 
-	if (sc->sc_flags & SC_OP_NO_RESET) {
-		show_cycles = ath9k_hw_GetMibCycleCountsPct(ah,
-					    &rx_clear, &rx_frame, &tx_frame);
-	}
-
 	/*
 	 * Check if the previous beacon has gone out.  If
 	 * not don't try to post another, skip this period
 	 * and wait for the next.  Missed beacons indicate
 	 * a problem and should not occur.  If we miss too
 	 * many consecutive beacons reset the device.
-	 *
-	 * FIXME: Clean up this mess !!
 	 */
 	if (ath9k_hw_numtxpending(ah, sc->beacon.beaconq) != 0) {
 		sc->beacon.bmisscnt++;
-		/* XXX: doth needs the chanchange IE countdown decremented.
-		 *      We should consider adding a mac80211 call to indicate
-		 *      a beacon miss so appropriate action could be taken
-		 *      (in that layer).
-		 */
+
 		if (sc->beacon.bmisscnt < BSTUCK_THRESH) {
-			if (sc->sc_flags & SC_OP_NO_RESET) {
-				DPRINTF(sc, ATH_DBG_BEACON,
-					"missed %u consecutive beacons\n",
-					sc->beacon.bmisscnt);
-				if (show_cycles) {
-					/*
-					 * Display cycle counter stats from HW
-					 * to aide in debug of stickiness.
-					 */
-					DPRINTF(sc, ATH_DBG_BEACON,
-						"busy times: rx_clear=%d, "
-						"rx_frame=%d, tx_frame=%d\n",
-						rx_clear, rx_frame,
-						tx_frame);
-				} else {
-					DPRINTF(sc, ATH_DBG_BEACON,
-						"unable to obtain "
-						"busy times\n");
-				}
-			} else {
-				DPRINTF(sc, ATH_DBG_BEACON,
-					"missed %u consecutive beacons\n",
-					sc->beacon.bmisscnt);
-			}
+			DPRINTF(sc, ATH_DBG_BEACON,
+				"missed %u consecutive beacons\n",
+				sc->beacon.bmisscnt);
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
-			if (sc->sc_flags & SC_OP_NO_RESET) {
-				if (sc->beacon.bmisscnt == BSTUCK_THRESH) {
-					DPRINTF(sc, ATH_DBG_BEACON,
-						"beacon is officially "
-						"stuck\n");
-				}
-			} else {
-				DPRINTF(sc, ATH_DBG_BEACON,
-					"beacon is officially stuck\n");
-				ath_bstuck_process(sc);
-			}
+			DPRINTF(sc, ATH_DBG_BEACON,
+				"beacon is officially stuck\n");
+			ath_reset(sc, false);
 		}
+
 		return;
 	}
 
 	if (sc->beacon.bmisscnt != 0) {
-		if (sc->sc_flags & SC_OP_NO_RESET) {
-			DPRINTF(sc, ATH_DBG_BEACON,
-				"resume beacon xmit after %u misses\n",
-				sc->beacon.bmisscnt);
-		} else {
-			DPRINTF(sc, ATH_DBG_BEACON,
-				"resume beacon xmit after %u misses\n",
-				sc->beacon.bmisscnt);
-		}
+		DPRINTF(sc, ATH_DBG_BEACON,
+			"resume beacon xmit after %u misses\n",
+			sc->beacon.bmisscnt);
 		sc->beacon.bmisscnt = 0;
 	}
 
@@ -497,8 +444,7 @@ void ath_beacon_tasklet(unsigned long data)
 
 	DPRINTF(sc, ATH_DBG_BEACON,
 		"slot %d [tsf %llu tsftu %u intval %u] if_id %d\n",
-		slot, (unsigned long long)tsf, tsftu,
-		intval, if_id);
+		slot, tsf, tsftu, intval, if_id);
 
 	bfaddr = 0;
 	if (if_id != ATH_IF_ID_ANY) {
@@ -508,6 +454,7 @@ void ath_beacon_tasklet(unsigned long data)
 			bc = 1;
 		}
 	}
+
 	/*
 	 * Handle slot time change when a non-ERP station joins/leaves
 	 * an 11g network.  The 802.11 layer notifies us via callback,
@@ -524,7 +471,6 @@ void ath_beacon_tasklet(unsigned long data)
 	 *     interval has passed.  When bursting slot is always left
 	 *     set to ATH_BCBUF so this check is a noop.
 	 */
-	/* XXX locking */
 	if (sc->beacon.updateslot == UPDATE) {
 		sc->beacon.updateslot = COMMIT; /* commit next beacon */
 		sc->beacon.slotupdate = slot;
@@ -541,7 +487,6 @@ void ath_beacon_tasklet(unsigned long data)
 		if (!ath9k_hw_stoptxdma(ah, sc->beacon.beaconq)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"beacon queue %u did not stop?\n", sc->beacon.beaconq);
-			/* NB: the HAL still stops DMA, so proceed */
 		}
 
 		/* NB: cabq traffic should already be queued and primed */
-- 
1.6.1

