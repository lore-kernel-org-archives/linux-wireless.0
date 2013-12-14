Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48968 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab3LNRD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 10/11] ath9k_hw: clean up station beacon timer API
Date: Sat, 14 Dec 2013 18:03:44 +0100
Message-Id: <1387040625-38114-10-git-send-email-nbd@openwrt.org> (sfid-20131214_180426_428685_25671A63)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused fields, pass timer info in usec instead of TU.
Preparation for fixing nexttbtt calculation

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c         | 38 +++++++-----------------
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 39 ++++++++-----------------
 drivers/net/wireless/ath/ath9k/hw.c             | 18 +++++-------
 drivers/net/wireless/ath/ath9k/hw.h             |  6 +---
 4 files changed, 31 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 17be353..5128856 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -476,10 +476,9 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_beacon_state bs;
 	int dtimperiod, dtimcount, sleepduration;
-	int cfpperiod, cfpcount;
 	u32 nexttbtt = 0, intval, tsftu;
 	u64 tsf;
-	int num_beacons, offset, dtim_dec_count, cfp_dec_count;
+	int num_beacons, offset, dtim_dec_count;
 
 	/* No need to configure beacon if we are not associated */
 	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
@@ -492,21 +491,19 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	intval = conf->beacon_interval;
 
 	/*
-	 * Setup dtim and cfp parameters according to
+	 * Setup dtim parameters according to
 	 * last beacon we received (which may be none).
 	 */
 	dtimperiod = conf->dtim_period;
 	dtimcount = conf->dtim_count;
 	if (dtimcount >= dtimperiod)	/* NB: sanity check */
 		dtimcount = 0;
-	cfpperiod = 1;			/* NB: no PCF support yet */
-	cfpcount = 0;
 
 	sleepduration = conf->listen_interval * intval;
 
 	/*
 	 * Pull nexttbtt forward to reflect the current
-	 * TSF and calculate dtim+cfp state for the result.
+	 * TSF and calculate dtim state for the result.
 	 */
 	tsf = ath9k_hw_gettsf64(ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf) + FUDGE;
@@ -519,26 +516,14 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 
 	/* DTIM Beacon every dtimperiod Beacon */
 	dtim_dec_count = num_beacons % dtimperiod;
-	/* CFP every cfpperiod DTIM Beacon */
-	cfp_dec_count = (num_beacons / dtimperiod) % cfpperiod;
-	if (dtim_dec_count)
-		cfp_dec_count++;
-
 	dtimcount -= dtim_dec_count;
 	if (dtimcount < 0)
 		dtimcount += dtimperiod;
 
-	cfpcount -= cfp_dec_count;
-	if (cfpcount < 0)
-		cfpcount += cfpperiod;
-
-	bs.bs_intval = intval;
-	bs.bs_nexttbtt = nexttbtt;
-	bs.bs_dtimperiod = dtimperiod*intval;
-	bs.bs_nextdtim = bs.bs_nexttbtt + dtimcount*intval;
-	bs.bs_cfpperiod = cfpperiod*bs.bs_dtimperiod;
-	bs.bs_cfpnext = bs.bs_nextdtim + cfpcount*bs.bs_dtimperiod;
-	bs.bs_cfpmaxduration = 0;
+	bs.bs_intval = TU_TO_USEC(intval);
+	bs.bs_nexttbtt = TU_TO_USEC(nexttbtt);
+	bs.bs_dtimperiod = dtimperiod * bs.bs_intval;
+	bs.bs_nextdtim = bs.bs_nexttbtt + dtimcount * bs.bs_intval;
 
 	/*
 	 * Calculate the number of consecutive beacons to miss* before taking
@@ -566,7 +551,8 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	 * XXX fixed at 100ms
 	 */
 
-	bs.bs_sleepduration = roundup(IEEE80211_MS_TO_TU(100), sleepduration);
+	bs.bs_sleepduration = TU_TO_USEC(roundup(IEEE80211_MS_TO_TU(100),
+						 sleepduration));
 	if (bs.bs_sleepduration > bs.bs_dtimperiod)
 		bs.bs_sleepduration = bs.bs_dtimperiod;
 
@@ -574,10 +560,8 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
 
 	ath_dbg(common, BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
-	ath_dbg(common, BEACON,
-		"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
-		bs.bs_bmissthreshold, bs.bs_sleepduration,
-		bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
+	ath_dbg(common, BEACON, "bmiss: %u sleep: %u\n",
+		bs.bs_bmissthreshold, bs.bs_sleepduration);
 
 	/* Set the computed STA beacon timers */
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index e0c03bd..8b57577 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -70,11 +70,11 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	struct ath9k_beacon_state bs;
 	enum ath9k_int imask = 0;
 	int dtimperiod, dtimcount, sleepduration;
-	int cfpperiod, cfpcount, bmiss_timeout;
+	int bmiss_timeout;
 	u32 nexttbtt = 0, intval, tsftu;
 	__be32 htc_imask = 0;
 	u64 tsf;
-	int num_beacons, offset, dtim_dec_count, cfp_dec_count;
+	int num_beacons, offset, dtim_dec_count;
 	int ret __attribute__ ((unused));
 	u8 cmd_rsp;
 
@@ -84,7 +84,7 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	bmiss_timeout = (ATH_DEFAULT_BMISS_LIMIT * bss_conf->beacon_interval);
 
 	/*
-	 * Setup dtim and cfp parameters according to
+	 * Setup dtim parameters according to
 	 * last beacon we received (which may be none).
 	 */
 	dtimperiod = bss_conf->dtim_period;
@@ -93,8 +93,6 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	dtimcount = 1;
 	if (dtimcount >= dtimperiod)	/* NB: sanity check */
 		dtimcount = 0;
-	cfpperiod = 1;			/* NB: no PCF support yet */
-	cfpcount = 0;
 
 	sleepduration = intval;
 	if (sleepduration <= 0)
@@ -102,7 +100,7 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 
 	/*
 	 * Pull nexttbtt forward to reflect the current
-	 * TSF and calculate dtim+cfp state for the result.
+	 * TSF and calculate dtim state for the result.
 	 */
 	tsf = ath9k_hw_gettsf64(priv->ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf) + FUDGE;
@@ -115,26 +113,14 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 
 	/* DTIM Beacon every dtimperiod Beacon */
 	dtim_dec_count = num_beacons % dtimperiod;
-	/* CFP every cfpperiod DTIM Beacon */
-	cfp_dec_count = (num_beacons / dtimperiod) % cfpperiod;
-	if (dtim_dec_count)
-		cfp_dec_count++;
-
 	dtimcount -= dtim_dec_count;
 	if (dtimcount < 0)
 		dtimcount += dtimperiod;
 
-	cfpcount -= cfp_dec_count;
-	if (cfpcount < 0)
-		cfpcount += cfpperiod;
-
-	bs.bs_intval = intval;
-	bs.bs_nexttbtt = nexttbtt;
-	bs.bs_dtimperiod = dtimperiod*intval;
-	bs.bs_nextdtim = bs.bs_nexttbtt + dtimcount*intval;
-	bs.bs_cfpperiod = cfpperiod*bs.bs_dtimperiod;
-	bs.bs_cfpnext = bs.bs_nextdtim + cfpcount*bs.bs_dtimperiod;
-	bs.bs_cfpmaxduration = 0;
+	bs.bs_intval = TU_TO_USEC(intval);
+	bs.bs_nexttbtt = TU_TO_USEC(nexttbtt);
+	bs.bs_dtimperiod = dtimperiod * bs.bs_intval;
+	bs.bs_nextdtim = bs.bs_nexttbtt + dtimcount * bs.bs_intval;
 
 	/*
 	 * Calculate the number of consecutive beacons to miss* before taking
@@ -161,7 +147,8 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	 * XXX fixed at 100ms
 	 */
 
-	bs.bs_sleepduration = roundup(IEEE80211_MS_TO_TU(100), sleepduration);
+	bs.bs_sleepduration = TU_TO_USEC(roundup(IEEE80211_MS_TO_TU(100),
+						 sleepduration));
 	if (bs.bs_sleepduration > bs.bs_dtimperiod)
 		bs.bs_sleepduration = bs.bs_dtimperiod;
 
@@ -170,10 +157,8 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 
 	ath_dbg(common, CONFIG, "intval: %u tsf: %llu tsftu: %u\n",
 		intval, tsf, tsftu);
-	ath_dbg(common, CONFIG,
-		"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
-		bs.bs_bmissthreshold, bs.bs_sleepduration,
-		bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
+	ath_dbg(common, CONFIG, "bmiss: %u sleep: %u\n",
+		bs.bs_bmissthreshold, bs.bs_sleepduration);
 
 	/* Set the computed STA beacon timers */
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index dd10fee..4797cb2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2291,12 +2291,9 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
-	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
-
-	REG_WRITE(ah, AR_BEACON_PERIOD,
-		  TU_TO_USEC(bs->bs_intval));
-	REG_WRITE(ah, AR_DMA_BEACON_PERIOD,
-		  TU_TO_USEC(bs->bs_intval));
+	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, bs->bs_nexttbtt);
+	REG_WRITE(ah, AR_BEACON_PERIOD, bs->bs_intval);
+	REG_WRITE(ah, AR_DMA_BEACON_PERIOD, bs->bs_intval);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
@@ -2324,9 +2321,8 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
-	REG_WRITE(ah, AR_NEXT_DTIM,
-		  TU_TO_USEC(bs->bs_nextdtim - SLEEP_SLOP));
-	REG_WRITE(ah, AR_NEXT_TIM, TU_TO_USEC(nextTbtt - SLEEP_SLOP));
+	REG_WRITE(ah, AR_NEXT_DTIM, bs->bs_nextdtim - SLEEP_SLOP);
+	REG_WRITE(ah, AR_NEXT_TIM, nextTbtt - SLEEP_SLOP);
 
 	REG_WRITE(ah, AR_SLEEP1,
 		  SM((CAB_TIMEOUT_VAL << 3), AR_SLEEP1_CAB_TIMEOUT)
@@ -2340,8 +2336,8 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	REG_WRITE(ah, AR_SLEEP2,
 		  SM(beacontimeout, AR_SLEEP2_BEACON_TIMEOUT));
 
-	REG_WRITE(ah, AR_TIM_PERIOD, TU_TO_USEC(beaconintval));
-	REG_WRITE(ah, AR_DTIM_PERIOD, TU_TO_USEC(dtimperiod));
+	REG_WRITE(ah, AR_TIM_PERIOD, beaconintval);
+	REG_WRITE(ah, AR_DTIM_PERIOD, dtimperiod);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4e3b73b..54932d8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -168,7 +168,7 @@
 #define CAB_TIMEOUT_VAL             10
 #define BEACON_TIMEOUT_VAL          10
 #define MIN_BEACON_TIMEOUT_VAL      1
-#define SLEEP_SLOP                  3
+#define SLEEP_SLOP                  TU_TO_USEC(3)
 
 #define INIT_CONFIG_STATUS          0x00000000
 #define INIT_RSSI_THR               0x00000700
@@ -451,10 +451,6 @@ struct ath9k_beacon_state {
 	u32 bs_intval;
 #define ATH9K_TSFOOR_THRESHOLD    0x00004240 /* 16k us */
 	u32 bs_dtimperiod;
-	u16 bs_cfpperiod;
-	u16 bs_cfpmaxduration;
-	u32 bs_cfpnext;
-	u16 bs_timoffset;
 	u16 bs_bmissthreshold;
 	u32 bs_sleepduration;
 	u32 bs_tsfoor_threshold;
-- 
1.8.3.4 (Apple Git-47)

