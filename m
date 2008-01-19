Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:15632 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750942AbYASJRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 04:17:50 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 1/3] ath5k: better beacon timer calculation
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Sat, 19 Jan 2008 18:17:59 +0900
Message-ID: <20080119091759.31251.60264.stgit@one> (sfid-20080119_091814_814847_67DCB984)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update ath5k_beacon_update_timers() for better beacon timer calculation in a
variety of situations. most important is the possibility to call it with the
timestamp of a received beacon, when we detected that a HW merge has happened
and we need to reconfigure the beacon timers based on that.

we call this from the mac80211 callback reset_tsf now instead of beacon_update,
and there will be more use of it in the next patch.

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/base.c |  109 +++++++++++++++++++++++++++++++------
 1 files changed, 92 insertions(+), 17 deletions(-)


diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 784b359..ae3d470 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -290,6 +290,7 @@ static int 	ath5k_beacon_setup(struct ath5k_softc *sc,
 				struct ieee80211_tx_control *ctl);
 static void 	ath5k_beacon_send(struct ath5k_softc *sc);
 static void 	ath5k_beacon_config(struct ath5k_softc *sc);
+static void	ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
 
 static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
 {
@@ -1980,34 +1981,102 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 }
 
 
+/**
+ * ath5k_beacon_update_timers - update beacon timers
+ *
+ * @sc: struct ath5k_softc pointer we are operating on
+ * @bc_tsf: the timestamp of the beacon. 0 to reset the TSF. -1 to perform a
+ *          beacon timer update based on the current HW TSF.
+ *
+ * Calculate the next target beacon transmit time (TBTT) based on the timestamp
+ * of a received beacon or the current local hardware TSF and write it to the
+ * beacon timer registers.
+ *
+ * This is called in a variety of situations, e.g. when a beacon is received,
+ * when a HW merge has been detected, but also when an new IBSS is created or
+ * when we otherwise know we have to update the timers, but we keep it in this
+ * function to have it all together in one place.
+ */
 static void
-ath5k_beacon_update_timers(struct ath5k_softc *sc)
+ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 {
 	struct ath5k_hw *ah = sc->ah;
-	u32 uninitialized_var(nexttbtt), intval, tsftu;
-	u64 tsf;
+	u32 nexttbtt, intval, hw_tu, bc_tu;
+	u64 hw_tsf;
 
 	intval = sc->bintval & AR5K_BEACON_PERIOD;
 	if (WARN_ON(!intval))
 		return;
 
-	/* current TSF converted to TU */
-	tsf = ath5k_hw_get_tsf64(ah);
-	tsftu = TSF_TO_TU(tsf);
+	/* beacon TSF converted to TU */
+	bc_tu = TSF_TO_TU(bc_tsf);
 
-	/*
-	 * Pull nexttbtt forward to reflect the current
-	 * TSF. Add one intval otherwise the timespan
-	 * can be too short for ibss merges.
-	 */
-	nexttbtt = tsftu + 2 * intval;
+	/* current TSF converted to TU */
+	hw_tsf = ath5k_hw_get_tsf64(ah);
+	hw_tu = TSF_TO_TU(hw_tsf);
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
-		"hw tsftu %u nexttbtt %u intval %u\n", tsftu, nexttbtt, intval);
+#define FUDGE 3
+	/* we use FUDGE to make sure the next TBTT is ahead of the current TU */
+	if (bc_tsf == -1) {
+		/*
+		 * no beacons received, called internally.
+		 * just need to refresh timers based on HW TSF.
+		 */
+		nexttbtt = roundup(hw_tu + FUDGE, intval);
+	} else if (bc_tsf == 0) {
+		/*
+		 * no beacon received, probably called by ath5k_reset_tsf().
+		 * reset TSF to start with 0.
+		 */
+		nexttbtt = intval;
+		intval |= AR5K_BEACON_RESET_TSF;
+	} else if (bc_tsf > hw_tsf) {
+		/*
+		 * beacon received, SW merge happend but HW TSF not yet updated.
+		 * not possible to reconfigure timers yet, but next time we
+		 * receive a beacon with the same BSSID, the hardware will
+		 * automatically update the TSF and then we need to reconfigure
+		 * the timers.
+		 */
+		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+			"need to wait for HW TSF sync\n");
+		return;
+	} else {
+		/*
+		 * most important case for beacon synchronization between STA.
+		 *
+		 * beacon received and HW TSF has been already updated by HW.
+		 * update next TBTT based on the TSF of the beacon, but make
+		 * sure it is ahead of our local TSF timer.
+		 */
+		nexttbtt = bc_tu + roundup(hw_tu + FUDGE - bc_tu, intval);
+	}
+#undef FUDGE
 
 	intval |= AR5K_BEACON_ENA;
-
 	ath5k_hw_init_beacon(ah, nexttbtt, intval);
+
+	/*
+	 * debugging output last in order to preserve the time critical aspect
+	 * of this function
+	 */
+	if (bc_tsf == -1)
+		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+			"reconfigured timers based on HW TSF\n");
+	else if (bc_tsf == 0)
+		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+			"reset HW TSF and timers\n");
+	else
+		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+			"updated timers based on beacon TSF\n");
+
+	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+		"bc_tsf %llx hw_tsf %llx bc_tu %u hw_tu %u nexttbtt %u\n",
+		bc_tsf, hw_tsf, bc_tu, hw_tu, nexttbtt);
+	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "intval %u %s %s\n",
+		intval & AR5K_BEACON_PERIOD,
+		intval & AR5K_BEACON_ENA ? "AR5K_BEACON_ENA" : "",
+		intval & AR5K_BEACON_RESET_TSF ? "AR5K_BEACON_RESET_TSF" : "");
 }
 
 
@@ -2041,7 +2110,6 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 		 * only once here.
 		 */
 		ath5k_beaconq_config(sc);
-		ath5k_beacon_update_timers(sc);
 
 		if (!ath5k_hw_hasveol(ah))
 			sc->imask |= AR5K_INT_SWBA;
@@ -2791,7 +2859,14 @@ ath5k_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct ath5k_softc *sc = hw->priv;
 
-	ath5k_hw_reset_tsf(sc->ah);
+	/*
+	 * in IBSS mode we need to update the beacon timers too.
+	 * this will also reset the TSF if we call it with 0
+	 */
+	if (sc->opmode == IEEE80211_IF_TYPE_IBSS)
+		ath5k_beacon_update_timers(sc, 0);
+	else
+		ath5k_hw_reset_tsf(sc->ah);
 }
 
 static int

