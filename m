Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48973 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab3LNRD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 11/11] ath9k: properly preserve TSF across reset
Date: Sat, 14 Dec 2013 18:03:45 +0100
Message-Id: <1387040625-38114-11-git-send-email-nbd@openwrt.org> (sfid-20131214_180410_169688_FD7C7262)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon code previously reset TSF on every configuration call, as
some of the code was not prepared to properly calculate nexttbtt based
on current TSF.

This patch adds a common function for calculating nexttbtt and moves the
TSF reset to driver start.

This should improve AP mode compatibility with various stations that
expect the TSF to not randomly jump due to hardware resets.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 88 ++++++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/main.c   |  2 +
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 5128856..78ffe76 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -431,6 +431,33 @@ static void ath9k_beacon_init(struct ath_softc *sc, u32 nexttbtt,
 	ath9k_hw_enable_interrupts(ah);
 }
 
+/* Calculate the modulo of a 64 bit TSF snapshot with a TU divisor */
+static u32 ath9k_mod_tsf64_tu(u64 tsf, u32 div_tu)
+{
+	u32 tsf_mod, tsf_hi, tsf_lo, mod_hi, mod_lo;
+
+	tsf_mod = tsf & (BIT(10) - 1);
+	tsf_hi = tsf >> 32;
+	tsf_lo = ((u32) tsf) >> 10;
+
+	mod_hi = tsf_hi % div_tu;
+	mod_lo = ((mod_hi << 22) + tsf_lo) % div_tu;
+
+	return (mod_lo << 10) | tsf_mod;
+}
+
+static u32 ath9k_get_next_tbtt(struct ath_softc *sc, u64 tsf,
+			       unsigned int interval)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	unsigned int offset;
+
+	tsf += TU_TO_USEC(FUDGE + ah->config.sw_beacon_response_time);
+	offset = ath9k_mod_tsf64_tu(tsf, interval);
+
+	return (u32) tsf + TU_TO_USEC(interval) - offset;
+}
+
 /*
  * For multi-bss ap support beacons are either staggered evenly over N slots or
  * burst together.  For the former arrange for the SWBA to be delivered for each
@@ -446,7 +473,8 @@ static void ath9k_beacon_config_ap(struct ath_softc *sc,
 	/* NB: the beacon interval is kept internally in TU's */
 	intval = TU_TO_USEC(conf->beacon_interval);
 	intval /= ATH_BCBUF;
-	nexttbtt = intval;
+	nexttbtt = ath9k_get_next_tbtt(sc, ath9k_hw_gettsf64(ah),
+				       conf->beacon_interval);
 
 	if (conf->enable_beacon)
 		ah->imask |= ATH9K_INT_SWBA;
@@ -458,7 +486,7 @@ static void ath9k_beacon_config_ap(struct ath_softc *sc,
 		(conf->enable_beacon) ? "Enable" : "Disable",
 		nexttbtt, intval, conf->beacon_interval);
 
-	ath9k_beacon_init(sc, nexttbtt, intval, true);
+	ath9k_beacon_init(sc, nexttbtt, intval, false);
 }
 
 /*
@@ -475,10 +503,9 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_beacon_state bs;
-	int dtimperiod, dtimcount, sleepduration;
-	u32 nexttbtt = 0, intval, tsftu;
+	int dtim_intval, sleepduration;
+	u32 nexttbtt = 0, intval;
 	u64 tsf;
-	int num_beacons, offset, dtim_dec_count;
 
 	/* No need to configure beacon if we are not associated */
 	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
@@ -494,11 +521,7 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	 * Setup dtim parameters according to
 	 * last beacon we received (which may be none).
 	 */
-	dtimperiod = conf->dtim_period;
-	dtimcount = conf->dtim_count;
-	if (dtimcount >= dtimperiod)	/* NB: sanity check */
-		dtimcount = 0;
-
+	dtim_intval = intval * conf->dtim_period;
 	sleepduration = conf->listen_interval * intval;
 
 	/*
@@ -506,24 +529,14 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	 * TSF and calculate dtim state for the result.
 	 */
 	tsf = ath9k_hw_gettsf64(ah);
-	tsftu = TSF_TO_TU(tsf>>32, tsf) + FUDGE;
-
-	num_beacons = tsftu / intval + 1;
-	offset = tsftu % intval;
-	nexttbtt = tsftu - offset;
-	if (offset)
-		nexttbtt += intval;
-
-	/* DTIM Beacon every dtimperiod Beacon */
-	dtim_dec_count = num_beacons % dtimperiod;
-	dtimcount -= dtim_dec_count;
-	if (dtimcount < 0)
-		dtimcount += dtimperiod;
+	nexttbtt = ath9k_get_next_tbtt(sc, tsf, intval);
 
 	bs.bs_intval = TU_TO_USEC(intval);
-	bs.bs_nexttbtt = TU_TO_USEC(nexttbtt);
-	bs.bs_dtimperiod = dtimperiod * bs.bs_intval;
-	bs.bs_nextdtim = bs.bs_nexttbtt + dtimcount * bs.bs_intval;
+	bs.bs_dtimperiod = conf->dtim_period * bs.bs_intval;
+	bs.bs_nexttbtt = nexttbtt;
+	bs.bs_nextdtim = nexttbtt;
+	if (conf->dtim_period > 1)
+		bs.bs_nextdtim = ath9k_get_next_tbtt(sc, tsf, dtim_intval);
 
 	/*
 	 * Calculate the number of consecutive beacons to miss* before taking
@@ -559,7 +572,6 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	/* TSF out of range threshold fixed at 1 second */
 	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
 
-	ath_dbg(common, BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
 	ath_dbg(common, BEACON, "bmiss: %u sleep: %u\n",
 		bs.bs_bmissthreshold, bs.bs_sleepduration);
 
@@ -584,25 +596,11 @@ static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
 
 	intval = TU_TO_USEC(conf->beacon_interval);
 
-	if (conf->ibss_creator) {
+	if (conf->ibss_creator)
 		nexttbtt = intval;
-	} else {
-		u32 tbtt, offset, tsftu;
-		u64 tsf;
-
-		/*
-		 * Pull nexttbtt forward to reflect the current
-		 * sync'd TSF.
-		 */
-		tsf = ath9k_hw_gettsf64(ah);
-		tsftu = TSF_TO_TU(tsf >> 32, tsf) + FUDGE;
-		offset = tsftu % conf->beacon_interval;
-		tbtt = tsftu - offset;
-		if (offset)
-			tbtt += conf->beacon_interval;
-
-		nexttbtt = TU_TO_USEC(tbtt);
-	}
+	else
+		nexttbtt = ath9k_get_next_tbtt(sc, ath9k_hw_gettsf64(ah),
+					       conf->beacon_interval);
 
 	if (conf->enable_beacon)
 		ah->imask |= ATH9K_INT_SWBA;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4798f6a..6a23120 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -760,6 +760,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 */
 	ath9k_cmn_init_crypto(sc->sc_ah);
 
+	ath9k_hw_reset_tsf(ah);
+
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	mutex_unlock(&sc->mutex);
-- 
1.8.3.4 (Apple Git-47)

