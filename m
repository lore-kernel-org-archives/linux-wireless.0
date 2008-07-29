Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17136 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbYG2Frb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:31 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:31 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Vasantha kumar Thiagaranjan <vasanth@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 03/16] ath9k: Clean up in antenna diversity handling. Get rid of sc_needmib.
Date: Mon, 28 Jul 2008 22:47:12 -0700
Message-ID: <04c5518257a22e1402cb244d68eff07cf3fea31d.1217309551.git.lrodriguez@atheros.com> (sfid-20080729_074734_559347_28D2029E)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasantha kumar Thiagaranjan <vasanth@atheros.com>

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 855cda4..b2f44b1 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -709,27 +709,6 @@ void ath9k_beacon_tasklet(unsigned long data)
 	} else if (sc->sc_updateslot == COMMIT && sc->sc_slotupdate == slot)
 		ath_setslottime(sc);        /* commit change to hardware */
 
-	if ((!sc->sc_stagbeacons || slot == 0) && (!sc->sc_diversity)) {
-		int otherant;
-		/*
-		 * Check recent per-antenna transmit statistics and flip
-		 * the default rx antenna if noticeably more frames went out
-		 * on the non-default antenna.  Only do this if rx diversity
-		 * is off.
-		 * XXX assumes 2 anntenae
-		 */
-		otherant = sc->sc_defant & 1 ? 2 : 1;
-		if (sc->sc_ant_tx[otherant] > sc->sc_ant_tx[sc->sc_defant] +
-			ATH_ANTENNA_DIFF) {
-			DPRINTF(sc, ATH_DEBUG_BEACON,
-				"%s: flip defant to %u, %u > %u\n",
-				__func__, otherant, sc->sc_ant_tx[otherant],
-				sc->sc_ant_tx[sc->sc_defant]);
-			ath_setdefantenna(sc, otherant);
-		}
-		sc->sc_ant_tx[1] = sc->sc_ant_tx[2] = 0;
-	}
-
 	if (bfaddr != 0) {
 		/*
 		 * Stop any current dma and put the new frame(s) on the queue.
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 5752467..47d4891 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -834,7 +834,7 @@ int ath_open(struct ath_softc *sc, struct hal_channel *initial_chan)
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
 	 */
-	if (sc->sc_needmib &&
+	if (ath9k_hw_phycounters(ah) &&
 	    ((sc->sc_opmode == HAL_M_STA) || (sc->sc_opmode == HAL_M_IBSS)))
 		sc->sc_imask |= HAL_INT_MIB;
 	/*
@@ -1161,14 +1161,6 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	/* Get the chipset-specific aggr limit. */
 	sc->sc_rtsaggrlimit = ah->ah_caps.halRtsAggrLimit;
 
-	/*
-	 * Check if the device has hardware counters for PHY
-	 * errors.  If so we need to enable the MIB interrupt
-	 * so we can act on stat triggers.
-	 */
-	if (ath9k_hw_phycounters(ah))
-		sc->sc_needmib = 1;
-
 	/* Get the hardware key cache size. */
 	sc->sc_keymax = ah->ah_caps.halKeyCacheSize;
 	if (sc->sc_keymax > ATH_KEYMAX) {
@@ -1354,21 +1346,8 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	sc->sc_rxchaindetect_delta5GHz = 30;
 	sc->sc_rxchaindetect_delta2GHz = 30;
 
-	/*
-	 * Query the hal about antenna support
-	 * Enable rx fast diversity if hal has support
-	 */
-	if (ath9k_hw_getcapability(ah, HAL_CAP_DIVERSITY, 0, NULL)) {
-		sc->sc_hasdiversity = 1;
-		ath9k_hw_setcapability(ah, HAL_CAP_DIVERSITY,
-			1, AH_TRUE, NULL);
-		sc->sc_diversity = 1;
-	} else {
-		sc->sc_hasdiversity = 0;
-		sc->sc_diversity = 0;
-		ath9k_hw_setcapability(ah, HAL_CAP_DIVERSITY,
-			1, AH_FALSE, NULL);
-	}
+	ath9k_hw_setcapability(ah, HAL_CAP_DIVERSITY, 1, AH_TRUE, NULL);
+
 	sc->sc_defant = ath9k_hw_getdefantenna(ah);
 
 	/*
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index b6a6373..0995c6e 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -944,10 +944,7 @@ struct ath_softc {
 
 	/* Properties, Config */
 	unsigned int
-		sc_invalid             : 1, /* being detached */
-		sc_needmib             : 1, /* enable MIB stats intr */
-		sc_hasdiversity        : 1, /* rx diversity available */
-		sc_diversity           : 1, /* enable rx diversity */
+		sc_invalid,	/* being detached */
 		sc_hasveol             : 1, /* tx VEOL support */
 		sc_beacons             : 1, /* beacons running */
 		sc_hasbmask            : 1, /* bssid mask support */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 91ba3e4..ab52647 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -6701,15 +6701,9 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 	case HAL_CAP_PHYCOUNTERS:
 		return ahp->ah_hasHwPhyCounters ? HAL_OK : HAL_ENXIO;
 	case HAL_CAP_DIVERSITY:
-		switch (capability) {
-		case 0:
-			return AH_TRUE;
-		case 1:
-			return (REG_READ(ah, AR_PHY_CCK_DETECT) &
-				AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
-				AH_TRUE : AH_FALSE;
-		}
-		return AH_FALSE;
+		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
+			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
+			AH_TRUE : AH_FALSE;
 	case HAL_CAP_PHYDIAG:
 		return AH_TRUE;
 	case HAL_CAP_MCAST_KEYSRCH:
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 7ca0ef9..2446c00 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -1110,20 +1110,18 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		type = ath_rx_indicate(sc, skb,
 			&rx_status, ds->ds_rxstat.rs_keyix);
 
-		if (sc->sc_diversity) {
-			/*
-			 * When using hardware fast diversity, change the
-			 * default rx antenna if rx diversity chooses the
-			 * other antenna 3 times in a row.
-			 */
-			if (sc->sc_defant != ds->ds_rxstat.rs_antenna) {
-				if (++sc->sc_rxotherant >= 3)
-					ath_setdefantenna(sc,
-						  ds->ds_rxstat.rs_antenna);
-			} else {
-				sc->sc_rxotherant = 0;
-			}
+		/*
+		 * change the default rx antenna if rx diversity chooses the
+		 * other antenna 3 times in a row.
+		 */
+		if (sc->sc_defant != ds->ds_rxstat.rs_antenna) {
+			if (++sc->sc_rxotherant >= 3)
+				ath_setdefantenna(sc,
+						ds->ds_rxstat.rs_antenna);
+		} else {
+			sc->sc_rxotherant = 0;
 		}
+
 		/*
 		 * redo antenna detection for Lenovo devices
 		 */
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 4039a98..127204c 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1257,7 +1257,6 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ath_tx_info_priv *tx_info_priv;
-	u_int8_t txant;
 	int nacked, txok, nbad = 0, isrifs = 0;
 	enum hal_status status;
 
@@ -1345,10 +1344,6 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			spin_unlock_bh(&sc->sc_txbuflock);
 		}
 
-		if (txok) {
-			txant = ds->ds_txstat.ts_antenna;
-			sc->sc_ant_tx[txant]++;
-		}
 		if (!bf->bf_isampdu) {
 			/*
 			 * This frame is sent out as a single frame.
-- 
1.5.4.3

