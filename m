Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:47573 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759654Ab1LOWzz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 17:55:55 -0500
Message-ID: <1323989753.1270.19.camel@joe2Laptop> (sfid-20111215_235603_209505_0DD2F6DC)
Subject: [PATCH wireless-next] ath: Convert ath_dbg(bar, ATH_DBG_<FOO>, to
 ath_dbg(bar, FOO
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Thu, 15 Dec 2011 14:55:53 -0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ATH_DBG_ to macros to shorten the uses and
reduce the line count.

Coalesce ath_dbg formats.
Add missing spaces to coalesced formats.
Add missing newline terminations to ath_dbg formats.
Align ath_dbg arguments where appropriate.
Standardize ath_dbg formats without periods.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath.h                  |    7 +-
 drivers/net/wireless/ath/ath9k/ani.c            |   29 ++--
 drivers/net/wireless/ath/ath9k/ar5008_phy.c     |   42 ++---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c   |  134 +++++++--------
 drivers/net/wireless/ath/ath9k/ar9002_mac.c     |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c   |  120 ++++++-------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c  |   76 ++++-----
 drivers/net/wireless/ath/ath9k/ar9003_mac.c     |   14 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c     |  221 ++++++++++-------------
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c   |   17 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c     |   44 ++---
 drivers/net/wireless/ath/ath9k/beacon.c         |   39 ++---
 drivers/net/wireless/ath/ath9k/btcoex.c         |    3 +-
 drivers/net/wireless/ath/ath9k/calib.c          |   20 +--
 drivers/net/wireless/ath/ath9k/eeprom.c         |    3 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c      |   23 +--
 drivers/net/wireless/ath/ath9k/eeprom_9287.c    |   17 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c     |   28 ++--
 drivers/net/wireless/ath/ath9k/gpio.c           |   10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   51 +++---
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c   |    9 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |   20 +--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   83 ++++-----
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   13 +-
 drivers/net/wireless/ath/ath9k/hw.c             |   86 ++++-----
 drivers/net/wireless/ath/ath9k/init.c           |    7 +-
 drivers/net/wireless/ath/ath9k/mac.c            |   36 ++--
 drivers/net/wireless/ath/ath9k/main.c           |   96 +++++------
 drivers/net/wireless/ath/ath9k/mci.c            |  126 ++++++-------
 drivers/net/wireless/ath/ath9k/rc.c             |    7 +-
 drivers/net/wireless/ath/ath9k/recv.c           |   17 +-
 drivers/net/wireless/ath/ath9k/wmi.c            |    8 +-
 drivers/net/wireless/ath/ath9k/xmit.c           |   22 +--
 drivers/net/wireless/ath/key.c                  |    8 +-
 34 files changed, 647 insertions(+), 799 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 3e4dd2d..302cb97 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -250,7 +250,7 @@ enum ATH_DEBUG {
 
 #define ath_dbg(common, dbg_mask, fmt, ...)				\
 do {									\
-	if ((common)->debug_mask & dbg_mask)				\
+	if ((common)->debug_mask & ATH_DBG_##dbg_mask)			\
 		_ath_printk(KERN_DEBUG, common, fmt, ##__VA_ARGS__);	\
 } while (0)
 
@@ -260,10 +260,13 @@ do {									\
 #else
 
 static inline  __attribute__ ((format (printf, 3, 4)))
-void ath_dbg(struct ath_common *common, enum ATH_DEBUG dbg_mask,
+void _ath_dbg(struct ath_common *common, enum ATH_DEBUG dbg_mask,
 	     const char *fmt, ...)
 {
 }
+#define ath_dbg(common, dbg_mask, fmt, ...)				\
+	_ath_dbg(common, ATH_DBG_##dbg_mask, fmt, ##__VA_ARGS__)
+
 #define ATH_DBG_WARN(foo, arg...) do {} while (0)
 #define ATH_DBG_WARN_ON_ONCE(foo) ({				\
 	int __ret_warn_once = !!(foo);				\
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index a639b94..bc56f57 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -136,8 +136,8 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 		cck_base = AR_PHY_COUNTMAX - ah->config.cck_trig_high;
 	}
 
-	ath_dbg(common, ATH_DBG_ANI,
-		"Writing ofdmbase=%u   cckbase=%u\n", ofdm_base, cck_base);
+	ath_dbg(common, ANI, "Writing ofdmbase=%u   cckbase=%u\n",
+		ofdm_base, cck_base);
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
@@ -268,8 +268,7 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel)
 
 	aniState->noiseFloor = BEACON_RSSI(ah);
 
-	ath_dbg(common, ATH_DBG_ANI,
-		"**** ofdmlevel %d=>%d, rssi=%d[lo=%d hi=%d]\n",
+	ath_dbg(common, ANI, "**** ofdmlevel %d=>%d, rssi=%d[lo=%d hi=%d]\n",
 		aniState->ofdmNoiseImmunityLevel,
 		immunityLevel, aniState->noiseFloor,
 		aniState->rssiThrLow, aniState->rssiThrHigh);
@@ -336,8 +335,7 @@ static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel)
 	const struct ani_cck_level_entry *entry_cck;
 
 	aniState->noiseFloor = BEACON_RSSI(ah);
-	ath_dbg(common, ATH_DBG_ANI,
-		"**** ccklevel %d=>%d, rssi=%d[lo=%d hi=%d]\n",
+	ath_dbg(common, ANI, "**** ccklevel %d=>%d, rssi=%d[lo=%d hi=%d]\n",
 		aniState->cckNoiseImmunityLevel, immunityLevel,
 		aniState->noiseFloor, aniState->rssiThrLow,
 		aniState->rssiThrHigh);
@@ -481,8 +479,7 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
 
 	if (ah->opmode != NL80211_IFTYPE_STATION
 	    && ah->opmode != NL80211_IFTYPE_ADHOC) {
-		ath_dbg(common, ATH_DBG_ANI,
-			"Reset ANI state opmode %u\n", ah->opmode);
+		ath_dbg(common, ANI, "Reset ANI state opmode %u\n", ah->opmode);
 		ah->stats.ast_ani_reset++;
 
 		if (ah->opmode == NL80211_IFTYPE_AP) {
@@ -582,7 +579,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 		    ATH9K_ANI_OFDM_DEF_LEVEL ||
 		    aniState->cckNoiseImmunityLevel !=
 		    ATH9K_ANI_CCK_DEF_LEVEL) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"Restore defaults: opmode %u chan %d Mhz/0x%x is_scanning=%d ofdm:%d cck:%d\n",
 				ah->opmode,
 				chan->channel,
@@ -599,7 +596,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 		/*
 		 * restore historical levels for this channel
 		 */
-		ath_dbg(common, ATH_DBG_ANI,
+		ath_dbg(common, ANI,
 			"Restore history: opmode %u chan %d Mhz/0x%x is_scanning=%d ofdm:%d cck:%d\n",
 			ah->opmode,
 			chan->channel,
@@ -662,7 +659,7 @@ static bool ath9k_hw_ani_read_counters(struct ath_hw *ah)
 
 	if (!use_new_ani(ah) && (phyCnt1 < ofdm_base || phyCnt2 < cck_base)) {
 		if (phyCnt1 < ofdm_base) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"phyCnt1 0x%x, resetting counter value to 0x%x\n",
 				phyCnt1, ofdm_base);
 			REG_WRITE(ah, AR_PHY_ERR_1, ofdm_base);
@@ -670,7 +667,7 @@ static bool ath9k_hw_ani_read_counters(struct ath_hw *ah)
 				  AR_PHY_ERR_OFDM_TIMING);
 		}
 		if (phyCnt2 < cck_base) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"phyCnt2 0x%x, resetting counter value to 0x%x\n",
 				phyCnt2, cck_base);
 			REG_WRITE(ah, AR_PHY_ERR_2, cck_base);
@@ -713,7 +710,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 	cckPhyErrRate =  aniState->cckPhyErrCount * 1000 /
 			 aniState->listenTime;
 
-	ath_dbg(common, ATH_DBG_ANI,
+	ath_dbg(common, ANI,
 		"listenTime=%d OFDM:%d errs=%d/s CCK:%d errs=%d/s ofdm_turn=%d\n",
 		aniState->listenTime,
 		aniState->ofdmNoiseImmunityLevel,
@@ -748,7 +745,7 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	ath_dbg(common, ATH_DBG_ANI, "Enable MIB counters\n");
+	ath_dbg(common, ANI, "Enable MIB counters\n");
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
@@ -770,7 +767,7 @@ void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	ath_dbg(common, ATH_DBG_ANI, "Disable MIB counters\n");
+	ath_dbg(common, ANI, "Disable MIB counters\n");
 
 	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
@@ -845,7 +842,7 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int i;
 
-	ath_dbg(common, ATH_DBG_ANI, "Initialize ANI\n");
+	ath_dbg(common, ANI, "Initialize ANI\n");
 
 	if (use_new_ani(ah)) {
 		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH_NEW;
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index f199e9e..f901a17 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -158,7 +158,7 @@ static void ar5008_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
 	/* pre-reverse this field */
 	tmp_reg = ath9k_hw_reverse_bits(new_bias, 3);
 
-	ath_dbg(common, ATH_DBG_CONFIG, "Force rf_pwd_icsyndiv to %1d on %4d\n",
+	ath_dbg(common, CONFIG, "Force rf_pwd_icsyndiv to %1d on %4d\n",
 		new_bias, synth_freq);
 
 	/* swizzle rf_pwd_icsyndiv */
@@ -1053,8 +1053,7 @@ static bool ar5008_hw_ani_control_old(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(ah->totalSizeDesired)) {
-			ath_dbg(common, ATH_DBG_ANI,
-				"level out of range (%u > %zu)\n",
+			ath_dbg(common, ANI, "level out of range (%u > %zu)\n",
 				level, ARRAY_SIZE(ah->totalSizeDesired));
 			return false;
 		}
@@ -1157,8 +1156,7 @@ static bool ar5008_hw_ani_control_old(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(firstep)) {
-			ath_dbg(common, ATH_DBG_ANI,
-				"level out of range (%u > %zu)\n",
+			ath_dbg(common, ANI, "level out of range (%u > %zu)\n",
 				level, ARRAY_SIZE(firstep));
 			return false;
 		}
@@ -1177,8 +1175,7 @@ static bool ar5008_hw_ani_control_old(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(cycpwrThr1)) {
-			ath_dbg(common, ATH_DBG_ANI,
-				"level out of range (%u > %zu)\n",
+			ath_dbg(common, ANI, "level out of range (%u > %zu)\n",
 				level, ARRAY_SIZE(cycpwrThr1));
 			return false;
 		}
@@ -1195,23 +1192,22 @@ static bool ar5008_hw_ani_control_old(struct ath_hw *ah,
 	case ATH9K_ANI_PRESENT:
 		break;
 	default:
-		ath_dbg(common, ATH_DBG_ANI, "invalid cmd %u\n", cmd);
+		ath_dbg(common, ANI, "invalid cmd %u\n", cmd);
 		return false;
 	}
 
-	ath_dbg(common, ATH_DBG_ANI, "ANI parameters:\n");
-	ath_dbg(common, ATH_DBG_ANI,
+	ath_dbg(common, ANI, "ANI parameters:\n");
+	ath_dbg(common, ANI,
 		"noiseImmunityLevel=%d, spurImmunityLevel=%d, ofdmWeakSigDetectOff=%d\n",
 		aniState->noiseImmunityLevel,
 		aniState->spurImmunityLevel,
 		!aniState->ofdmWeakSigDetectOff);
-	ath_dbg(common, ATH_DBG_ANI,
+	ath_dbg(common, ANI,
 		"cckWeakSigThreshold=%d, firstepLevel=%d, listenTime=%d\n",
 		aniState->cckWeakSigThreshold,
 		aniState->firstepLevel,
 		aniState->listenTime);
-	ath_dbg(common, ATH_DBG_ANI,
-		"ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
+	ath_dbg(common, ANI, "ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
 		aniState->ofdmPhyErrCount,
 		aniState->cckPhyErrCount);
 
@@ -1295,7 +1291,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
 
 		if (!on != aniState->ofdmWeakSigDetectOff) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: ofdm weak signal: %s=>%s\n",
 				chan->channel,
 				!aniState->ofdmWeakSigDetectOff ?
@@ -1313,7 +1309,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(firstep_table)) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"ATH9K_ANI_FIRSTEP_LEVEL: level out of range (%u > %zu)\n",
 				level, ARRAY_SIZE(firstep_table));
 			return false;
@@ -1350,7 +1346,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 			      AR_PHY_FIND_SIG_FIRSTEP_LOW, value2);
 
 		if (level != aniState->firstepLevel) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: level %d=>%d[def:%d] firstep[level]=%d ini=%d\n",
 				chan->channel,
 				aniState->firstepLevel,
@@ -1358,7 +1354,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 				ATH9K_ANI_FIRSTEP_LVL_NEW,
 				value,
 				aniState->iniDef.firstep);
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: level %d=>%d[def:%d] firstep_low[level]=%d ini=%d\n",
 				chan->channel,
 				aniState->firstepLevel,
@@ -1378,7 +1374,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(cycpwrThr1_table)) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"ATH9K_ANI_SPUR_IMMUNITY_LEVEL: level out of range (%u > %zu)\n",
 				level, ARRAY_SIZE(cycpwrThr1_table));
 			return false;
@@ -1414,7 +1410,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 			      AR_PHY_EXT_TIMING5_CYCPWR_THR1, value2);
 
 		if (level != aniState->spurImmunityLevel) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: level %d=>%d[def:%d] cycpwrThr1[level]=%d ini=%d\n",
 				chan->channel,
 				aniState->spurImmunityLevel,
@@ -1422,7 +1418,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 				ATH9K_ANI_SPUR_IMMUNE_LVL_NEW,
 				value,
 				aniState->iniDef.cycpwrThr1);
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: level %d=>%d[def:%d] cycpwrThr1Ext[level]=%d ini=%d\n",
 				chan->channel,
 				aniState->spurImmunityLevel,
@@ -1448,11 +1444,11 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 	case ATH9K_ANI_PRESENT:
 		break;
 	default:
-		ath_dbg(common, ATH_DBG_ANI, "invalid cmd %u\n", cmd);
+		ath_dbg(common, ANI, "invalid cmd %u\n", cmd);
 		return false;
 	}
 
-	ath_dbg(common, ATH_DBG_ANI,
+	ath_dbg(common, ANI,
 		"ANI parameters: SI=%d, ofdmWS=%s FS=%d MRCcck=%s listenTime=%d ofdmErrs=%d cckErrs=%d\n",
 		aniState->spurImmunityLevel,
 		!aniState->ofdmWeakSigDetectOff ? "on" : "off",
@@ -1506,7 +1502,7 @@ static void ar5008_hw_ani_cache_ini_regs(struct ath_hw *ah)
 
 	iniDef = &aniState->iniDef;
 
-	ath_dbg(common, ATH_DBG_ANI, "ver %d.%d opmode %u chan %d Mhz/0x%x\n",
+	ath_dbg(common, ANI, "ver %d.%d opmode %u chan %d Mhz/0x%x\n",
 		ah->hw_version.macVersion,
 		ah->hw_version.macRev,
 		ah->opmode,
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 157337f..c55e5bb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -61,18 +61,16 @@ static void ar9002_hw_setup_calibration(struct ath_hw *ah,
 	switch (currCal->calData->calType) {
 	case IQ_MISMATCH_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"starting IQ Mismatch Calibration\n");
 		break;
 	case ADC_GAIN_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_GAIN);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"starting ADC Gain Calibration\n");
+		ath_dbg(common, CALIBRATE, "starting ADC Gain Calibration\n");
 		break;
 	case ADC_DC_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_PER);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"starting ADC DC Calibration\n");
+		ath_dbg(common, CALIBRATE, "starting ADC DC Calibration\n");
 		break;
 	}
 
@@ -129,7 +127,7 @@ static void ar9002_hw_iqcal_collect(struct ath_hw *ah)
 			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
 		ah->totalIqCorrMeas[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+		ath_dbg(ath9k_hw_common(ah), CALIBRATE,
 			"%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
 			ah->cal_samples, i, ah->totalPowerMeasI[i],
 			ah->totalPowerMeasQ[i],
@@ -151,7 +149,7 @@ static void ar9002_hw_adc_gaincal_collect(struct ath_hw *ah)
 		ah->totalAdcQEvenPhase[i] +=
 			REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+		ath_dbg(ath9k_hw_common(ah), CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; oddq=0x%08x; evenq=0x%08x;\n",
 			ah->cal_samples, i,
 			ah->totalAdcIOddPhase[i],
@@ -175,7 +173,7 @@ static void ar9002_hw_adc_dccal_collect(struct ath_hw *ah)
 		ah->totalAdcDcOffsetQEvenPhase[i] +=
 			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
 
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+		ath_dbg(ath9k_hw_common(ah), CALIBRATE,
 			"%d: Chn %d oddi=0x%08x; eveni=0x%08x; oddq=0x%08x; evenq=0x%08x;\n",
 			ah->cal_samples, i,
 			ah->totalAdcDcOffsetIOddPhase[i],
@@ -198,11 +196,11 @@ static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		powerMeasQ = ah->totalPowerMeasQ[i];
 		iqCorrMeas = ah->totalIqCorrMeas[i];
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Starting IQ Cal and Correction for Chain %d\n",
 			i);
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Original: Chn %d iq_corr_meas = 0x%08x\n",
 			i, ah->totalIqCorrMeas[i]);
 
@@ -213,12 +211,11 @@ static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			iqCorrNeg = 1;
 		}
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_i = 0x%08x\n", i, powerMeasI);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_q = 0x%08x\n", i, powerMeasQ);
-		ath_dbg(common, ATH_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
-			iqCorrNeg);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_i = 0x%08x\n",
+			i, powerMeasI);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_q = 0x%08x\n",
+			i, powerMeasQ);
+		ath_dbg(common, CALIBRATE, "iqCorrNeg is 0x%08x\n", iqCorrNeg);
 
 		iCoffDenom = (powerMeasI / 2 + powerMeasQ / 2) / 128;
 		qCoffDenom = powerMeasQ / 64;
@@ -227,13 +224,13 @@ static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		    (qCoffDenom != 0)) {
 			iCoff = iqCorrMeas / iCoffDenom;
 			qCoff = powerMeasI / qCoffDenom - 64;
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Chn %d iCoff = 0x%08x\n", i, iCoff);
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Chn %d qCoff = 0x%08x\n", i, qCoff);
+			ath_dbg(common, CALIBRATE, "Chn %d iCoff = 0x%08x\n",
+				i, iCoff);
+			ath_dbg(common, CALIBRATE, "Chn %d qCoff = 0x%08x\n",
+				i, qCoff);
 
 			iCoff = iCoff & 0x3f;
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"New: Chn %d iCoff = 0x%08x\n", i, iCoff);
 			if (iqCorrNeg == 0x0)
 				iCoff = 0x40 - iCoff;
@@ -243,7 +240,7 @@ static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			else if (qCoff <= -16)
 				qCoff = -16;
 
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
 				i, iCoff, qCoff);
 
@@ -253,7 +250,7 @@ static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
 				      AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF,
 				      qCoff);
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"IQ Cal and Correction done for Chain %d\n",
 				i);
 		}
@@ -275,21 +272,17 @@ static void ar9002_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 		qOddMeasOffset = ah->totalAdcQOddPhase[i];
 		qEvenMeasOffset = ah->totalAdcQEvenPhase[i];
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Starting ADC Gain Cal for Chain %d\n", i);
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_odd_i = 0x%08x\n", i,
-			iOddMeasOffset);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_even_i = 0x%08x\n", i,
-			iEvenMeasOffset);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_odd_q = 0x%08x\n", i,
-			qOddMeasOffset);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_even_q = 0x%08x\n", i,
-			qEvenMeasOffset);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_odd_i = 0x%08x\n",
+			i, iOddMeasOffset);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_even_i = 0x%08x\n",
+			i, iEvenMeasOffset);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_odd_q = 0x%08x\n",
+			i, qOddMeasOffset);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_even_q = 0x%08x\n",
+			i, qEvenMeasOffset);
 
 		if (iOddMeasOffset != 0 && qEvenMeasOffset != 0) {
 			iGainMismatch =
@@ -299,19 +292,19 @@ static void ar9002_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
 				((qOddMeasOffset * 32) /
 				 qEvenMeasOffset) & 0x3f;
 
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Chn %d gain_mismatch_i = 0x%08x\n", i,
-				iGainMismatch);
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Chn %d gain_mismatch_q = 0x%08x\n", i,
-				qGainMismatch);
+			ath_dbg(common, CALIBRATE,
+				"Chn %d gain_mismatch_i = 0x%08x\n",
+				i, iGainMismatch);
+			ath_dbg(common, CALIBRATE,
+				"Chn %d gain_mismatch_q = 0x%08x\n",
+				i, qGainMismatch);
 
 			val = REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i));
 			val &= 0xfffff000;
 			val |= (qGainMismatch) | (iGainMismatch << 6);
 			REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
 
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"ADC Gain Cal done for Chain %d\n", i);
 		}
 	}
@@ -337,40 +330,36 @@ static void ar9002_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 		qOddMeasOffset = ah->totalAdcDcOffsetQOddPhase[i];
 		qEvenMeasOffset = ah->totalAdcDcOffsetQEvenPhase[i];
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Starting ADC DC Offset Cal for Chain %d\n", i);
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_odd_i = %d\n", i,
-			iOddMeasOffset);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_even_i = %d\n", i,
-			iEvenMeasOffset);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_odd_q = %d\n", i,
-			qOddMeasOffset);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_even_q = %d\n", i,
-			qEvenMeasOffset);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_odd_i = %d\n",
+			i, iOddMeasOffset);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_even_i = %d\n",
+			i, iEvenMeasOffset);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_odd_q = %d\n",
+			i, qOddMeasOffset);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_even_q = %d\n",
+			i, qEvenMeasOffset);
 
 		iDcMismatch = (((iEvenMeasOffset - iOddMeasOffset) * 2) /
 			       numSamples) & 0x1ff;
 		qDcMismatch = (((qOddMeasOffset - qEvenMeasOffset) * 2) /
 			       numSamples) & 0x1ff;
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d dc_offset_mismatch_i = 0x%08x\n", i,
-			iDcMismatch);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d dc_offset_mismatch_q = 0x%08x\n", i,
-			qDcMismatch);
+		ath_dbg(common, CALIBRATE,
+			"Chn %d dc_offset_mismatch_i = 0x%08x\n",
+			i, iDcMismatch);
+		ath_dbg(common, CALIBRATE,
+			"Chn %d dc_offset_mismatch_q = 0x%08x\n",
+			i, qDcMismatch);
 
 		val = REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i));
 		val &= 0xc0000fff;
 		val |= (qDcMismatch << 12) | (iDcMismatch << 21);
 		REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"ADC DC Offset Cal done for Chain %d\n", i);
 	}
 
@@ -560,7 +549,7 @@ static inline void ar9285_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 		{ 0x7838, 0 },
 	};
 
-	ath_dbg(common, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
+	ath_dbg(common, CALIBRATE, "Running PA Calibration\n");
 
 	/* PA CAL is not needed for high power solution */
 	if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) ==
@@ -741,7 +730,7 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
 				  AR_PHY_AGC_CONTROL_CAL, 0, AH_WAIT_TIMEOUT)) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"offset calibration failed to complete in 1ms; noisy environment?\n");
 			return false;
 		}
@@ -755,7 +744,7 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
 	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
 			  0, AH_WAIT_TIMEOUT)) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"offset calibration failed to complete in 1ms; noisy environment?\n");
 		return false;
 	}
@@ -851,7 +840,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
 				   AR_PHY_AGC_CONTROL_CAL,
 				   0, AH_WAIT_TIMEOUT)) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"offset calibration failed to complete in 1ms; noisy environment?\n");
 			return false;
 		}
@@ -886,22 +875,21 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		if (ar9002_hw_is_cal_supported(ah, chan, ADC_GAIN_CAL)) {
 			INIT_CAL(&ah->adcgain_caldata);
 			INSERT_CAL(ah, &ah->adcgain_caldata);
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-					"enabling ADC Gain Calibration.\n");
+			ath_dbg(common, CALIBRATE,
+					"enabling ADC Gain Calibration\n");
 		}
 
 		if (ar9002_hw_is_cal_supported(ah, chan, ADC_DC_CAL)) {
 			INIT_CAL(&ah->adcdc_caldata);
 			INSERT_CAL(ah, &ah->adcdc_caldata);
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-					"enabling ADC DC Calibration.\n");
+			ath_dbg(common, CALIBRATE,
+					"enabling ADC DC Calibration\n");
 		}
 
 		if (ar9002_hw_is_cal_supported(ah, chan, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ah->iq_caldata);
 			INSERT_CAL(ah, &ah->iq_caldata);
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-					"enabling IQ Calibration.\n");
+			ath_dbg(common, CALIBRATE, "enabling IQ Calibration\n");
 		}
 
 		ah->cal_list_curr = ah->cal_list;
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index b592016..7b6417b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -107,7 +107,7 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		}
 
 		if (isr & AR_ISR_RXORN) {
-			ath_dbg(common, ATH_DBG_INTERRUPT,
+			ath_dbg(common, INTERRUPT,
 				"receive FIFO overrun interrupt\n");
 		}
 
@@ -143,24 +143,24 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 
 		if (fatal_int) {
 			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
-				ath_dbg(common, ATH_DBG_ANY,
+				ath_dbg(common, ANY,
 					"received PCI FATAL interrupt\n");
 			}
 			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
-				ath_dbg(common, ATH_DBG_ANY,
+				ath_dbg(common, ANY,
 					"received PCI PERR interrupt\n");
 			}
 			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
-			ath_dbg(common, ATH_DBG_INTERRUPT,
+			ath_dbg(common, INTERRUPT,
 				"AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
 			REG_WRITE(ah, AR_RC, 0);
 			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
-			ath_dbg(common, ATH_DBG_INTERRUPT,
+			ath_dbg(common, INTERRUPT,
 				"AR_INTR_SYNC_LOCAL_TIMEOUT\n");
 		}
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 23b3a6c..8e70f0b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -52,7 +52,7 @@ static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 		currCal->calData->calCountMax);
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"starting IQ Mismatch Calibration\n");
 
 		/* Kick-off cal */
@@ -64,7 +64,7 @@ static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_THERM,
 			      AR_PHY_65NM_CH0_THERM_START, 1);
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"starting Temperature Compensation Calibration\n");
 		break;
 	}
@@ -194,7 +194,7 @@ static void ar9003_hw_iqcal_collect(struct ath_hw *ah)
 				REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
 			ah->totalIqCorrMeas[i] +=
 				(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-			ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+			ath_dbg(ath9k_hw_common(ah), CALIBRATE,
 				"%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
 				ah->cal_samples, i, ah->totalPowerMeasI[i],
 				ah->totalPowerMeasQ[i],
@@ -221,11 +221,10 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		powerMeasQ = ah->totalPowerMeasQ[i];
 		iqCorrMeas = ah->totalIqCorrMeas[i];
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Starting IQ Cal and Correction for Chain %d\n",
-			i);
+		ath_dbg(common, CALIBRATE,
+			"Starting IQ Cal and Correction for Chain %d\n", i);
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Original: Chn %d iq_corr_meas = 0x%08x\n",
 			i, ah->totalIqCorrMeas[i]);
 
@@ -236,12 +235,11 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			iqCorrNeg = 1;
 		}
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_i = 0x%08x\n", i, powerMeasI);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Chn %d pwr_meas_q = 0x%08x\n", i, powerMeasQ);
-		ath_dbg(common, ATH_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
-			iqCorrNeg);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_i = 0x%08x\n",
+			i, powerMeasI);
+		ath_dbg(common, CALIBRATE, "Chn %d pwr_meas_q = 0x%08x\n",
+			i, powerMeasQ);
+		ath_dbg(common, CALIBRATE, "iqCorrNeg is 0x%08x\n", iqCorrNeg);
 
 		iCoffDenom = (powerMeasI / 2 + powerMeasQ / 2) / 256;
 		qCoffDenom = powerMeasQ / 64;
@@ -249,10 +247,10 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 		if ((iCoffDenom != 0) && (qCoffDenom != 0)) {
 			iCoff = iqCorrMeas / iCoffDenom;
 			qCoff = powerMeasI / qCoffDenom - 64;
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Chn %d iCoff = 0x%08x\n", i, iCoff);
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Chn %d qCoff = 0x%08x\n", i, qCoff);
+			ath_dbg(common, CALIBRATE, "Chn %d iCoff = 0x%08x\n",
+				i, iCoff);
+			ath_dbg(common, CALIBRATE, "Chn %d qCoff = 0x%08x\n",
+				i, qCoff);
 
 			/* Force bounds on iCoff */
 			if (iCoff >= 63)
@@ -273,10 +271,10 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			iCoff = iCoff & 0x7f;
 			qCoff = qCoff & 0x7f;
 
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
 				i, iCoff, qCoff);
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"Register offset (0x%04x) before update = 0x%x\n",
 				offset_array[i],
 				REG_READ(ah, offset_array[i]));
@@ -287,25 +285,25 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			REG_RMW_FIELD(ah, offset_array[i],
 				      AR_PHY_RX_IQCAL_CORR_IQCORR_Q_Q_COFF,
 				      qCoff);
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"Register offset (0x%04x) QI COFF (bitfields 0x%08x) after update = 0x%x\n",
 				offset_array[i],
 				AR_PHY_RX_IQCAL_CORR_IQCORR_Q_I_COFF,
 				REG_READ(ah, offset_array[i]));
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"Register offset (0x%04x) QQ COFF (bitfields 0x%08x) after update = 0x%x\n",
 				offset_array[i],
 				AR_PHY_RX_IQCAL_CORR_IQCORR_Q_Q_COFF,
 				REG_READ(ah, offset_array[i]));
 
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"IQ Cal and Correction done for Chain %d\n", i);
 		}
 	}
 
 	REG_SET_BIT(ah, AR_PHY_RX_IQCAL_CORR_B0,
 		    AR_PHY_RX_IQCAL_CORR_IQCORR_ENABLE);
-	ath_dbg(common, ATH_DBG_CALIBRATE,
+	ath_dbg(common, CALIBRATE,
 		"IQ Cal and Correction (offset 0x%04x) enabled (bit position 0x%08x). New Value 0x%08x\n",
 		(unsigned) (AR_PHY_RX_IQCAL_CORR_B0),
 		AR_PHY_RX_IQCAL_CORR_IQCORR_ENABLE,
@@ -349,7 +347,7 @@ static bool ar9003_hw_solve_iq_cal(struct ath_hw *ah,
 	f2 = (f1 * f1 + f3 * f3) / result_shift;
 
 	if (!f2) {
-		ath_dbg(common, ATH_DBG_CALIBRATE, "Divide by 0\n");
+		ath_dbg(common, CALIBRATE, "Divide by 0\n");
 		return false;
 	}
 
@@ -470,7 +468,7 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 
 	if ((i2_p_q2_a0_d0 == 0) || (i2_p_q2_a0_d1 == 0) ||
 	    (i2_p_q2_a1_d0 == 0) || (i2_p_q2_a1_d1 == 0)) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Divide by 0:\n"
 			"a0_d0=%d\n"
 			"a0_d1=%d\n"
@@ -510,8 +508,7 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	mag2 = ar9003_hw_find_mag_approx(ah, cos_2phi_2, sin_2phi_2);
 
 	if ((mag1 == 0) || (mag2 == 0)) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Divide by 0: mag1=%d, mag2=%d\n",
+		ath_dbg(common, CALIBRATE, "Divide by 0: mag1=%d, mag2=%d\n",
 			mag1, mag2);
 		return false;
 	}
@@ -529,8 +526,8 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 			     mag_a0_d0, phs_a0_d0,
 			     mag_a1_d0,
 			     phs_a1_d0, solved_eq)) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Call to ar9003_hw_solve_iq_cal() failed.\n");
+		ath_dbg(common, CALIBRATE,
+			"Call to ar9003_hw_solve_iq_cal() failed\n");
 		return false;
 	}
 
@@ -539,12 +536,12 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	mag_rx = solved_eq[2];
 	phs_rx = solved_eq[3];
 
-	ath_dbg(common, ATH_DBG_CALIBRATE,
+	ath_dbg(common, CALIBRATE,
 		"chain %d: mag mismatch=%d phase mismatch=%d\n",
 		chain_idx, mag_tx/res_scale, phs_tx/res_scale);
 
 	if (res_scale == mag_tx) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Divide by 0: mag_tx=%d, res_scale=%d\n",
 			mag_tx, res_scale);
 		return false;
@@ -557,8 +554,7 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	q_q_coff = (mag_corr_tx * 128 / res_scale);
 	q_i_coff = (phs_corr_tx * 256 / res_scale);
 
-	ath_dbg(common, ATH_DBG_CALIBRATE,
-		"tx chain %d: mag corr=%d  phase corr=%d\n",
+	ath_dbg(common, CALIBRATE, "tx chain %d: mag corr=%d  phase corr=%d\n",
 		chain_idx, q_q_coff, q_i_coff);
 
 	if (q_i_coff < -63)
@@ -572,12 +568,11 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 
 	iqc_coeff[0] = (q_q_coff * 128) + q_i_coff;
 
-	ath_dbg(common, ATH_DBG_CALIBRATE,
-		"tx chain %d: iq corr coeff=%x\n",
+	ath_dbg(common, CALIBRATE, "tx chain %d: iq corr coeff=%x\n",
 		chain_idx, iqc_coeff[0]);
 
 	if (-mag_rx == res_scale) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Divide by 0: mag_rx=%d, res_scale=%d\n",
 			mag_rx, res_scale);
 		return false;
@@ -590,8 +585,7 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	q_q_coff = (mag_corr_rx * 128 / res_scale);
 	q_i_coff = (phs_corr_rx * 256 / res_scale);
 
-	ath_dbg(common, ATH_DBG_CALIBRATE,
-		"rx chain %d: mag corr=%d  phase corr=%d\n",
+	ath_dbg(common, CALIBRATE, "rx chain %d: mag corr=%d  phase corr=%d\n",
 		chain_idx, q_q_coff, q_i_coff);
 
 	if (q_i_coff < -63)
@@ -605,8 +599,7 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 
 	iqc_coeff[1] = (q_q_coff * 128) + q_i_coff;
 
-	ath_dbg(common, ATH_DBG_CALIBRATE,
-		"rx chain %d: iq corr coeff=%x\n",
+	ath_dbg(common, CALIBRATE, "rx chain %d: iq corr coeff=%x\n",
 		chain_idx, iqc_coeff[1]);
 
 	return true;
@@ -753,8 +746,7 @@ static bool ar9003_hw_tx_iq_cal_run(struct ath_hw *ah)
 	if (!ath9k_hw_wait(ah, AR_PHY_TX_IQCAL_START,
 			AR_PHY_TX_IQCAL_START_DO_CAL, 0,
 			AH_WAIT_TIMEOUT)) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Tx IQ Cal is not completed.\n");
+		ath_dbg(common, CALIBRATE, "Tx IQ Cal is not completed\n");
 		return false;
 	}
 	return true;
@@ -792,13 +784,13 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 			nmeasurement = MAX_MEASUREMENT;
 
 		for (im = 0; im < nmeasurement; im++) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Doing Tx IQ Cal for chain %d.\n", i);
+			ath_dbg(common, CALIBRATE,
+				"Doing Tx IQ Cal for chain %d\n", i);
 
 			if (REG_READ(ah, txiqcal_status[i]) &
 					AR_PHY_TX_IQCAL_STATUS_FAILED) {
-				ath_dbg(common, ATH_DBG_CALIBRATE,
-					"Tx IQ Cal failed for chain %d.\n", i);
+				ath_dbg(common, CALIBRATE,
+					"Tx IQ Cal failed for chain %d\n", i);
 				goto tx_iqcal_fail;
 			}
 
@@ -824,18 +816,16 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 				iq_res[idx + 1] = 0xffff & REG_READ(ah,
 						chan_info_tab[i] + offset);
 
-				ath_dbg(common, ATH_DBG_CALIBRATE,
-					"IQ_RES[%d]=0x%x "
-					"IQ_RES[%d]=0x%x\n",
+				ath_dbg(common, CALIBRATE,
+					"IQ_RES[%d]=0x%x IQ_RES[%d]=0x%x\n",
 					idx, iq_res[idx], idx + 1,
 					iq_res[idx + 1]);
 			}
 
 			if (!ar9003_hw_calc_iq_corr(ah, i, iq_res,
 						coeff.iqc_coeff)) {
-				ath_dbg(common, ATH_DBG_CALIBRATE,
-					"Failed in calculation of \
-					IQ correction.\n");
+				ath_dbg(common, CALIBRATE,
+					"Failed in calculation of IQ correction\n");
 				goto tx_iqcal_fail;
 			}
 
@@ -855,7 +845,7 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 	return;
 
 tx_iqcal_fail:
-	ath_dbg(common, ATH_DBG_CALIBRATE, "Tx IQ Cal failed\n");
+	ath_dbg(common, CALIBRATE, "Tx IQ Cal failed\n");
 	return;
 }
 
@@ -953,7 +943,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		if (!ar9003_hw_rtt_restore(ah, chan))
 			run_rtt_cal = true;
 
-		ath_dbg(common, ATH_DBG_CALIBRATE, "RTT restore %s\n",
+		ath_dbg(common, CALIBRATE, "RTT restore %s\n",
 			run_rtt_cal ? "failed" : "succeed");
 	}
 	run_agc_cal = run_rtt_cal;
@@ -1016,20 +1006,20 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		u32 pld[4] = {0, 0, 0, 0};
 
 		/* send CAL_REQ only when BT is AWAKE. */
-		ath_dbg(common, ATH_DBG_MCI, "MCI send WLAN_CAL_REQ 0x%x\n",
+		ath_dbg(common, MCI, "MCI send WLAN_CAL_REQ 0x%x\n",
 			mci_hw->wlan_cal_seq);
 		MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_REQ);
 		pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_seq++;
 		ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
 
 		/* Wait BT_CAL_GRANT for 50ms */
-		ath_dbg(common, ATH_DBG_MCI, "MCI wait for BT_CAL_GRANT");
+		ath_dbg(common, MCI, "MCI wait for BT_CAL_GRANT\n");
 
 		if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_GRANT, 0, 50000))
-			ath_dbg(common, ATH_DBG_MCI, "MCI got BT_CAL_GRANT");
+			ath_dbg(common, MCI, "MCI got BT_CAL_GRANT\n");
 		else {
 			is_reusable = false;
-			ath_dbg(common, ATH_DBG_MCI, "\nMCI BT is not responding");
+			ath_dbg(common, MCI, "\nMCI BT is not responding\n");
 		}
 	}
 
@@ -1058,7 +1048,7 @@ skip_tx_iqcal:
 
 		u32 pld[4] = {0, 0, 0, 0};
 
-		ath_dbg(common, ATH_DBG_MCI, "MCI Send WLAN_CAL_DONE 0x%x\n",
+		ath_dbg(common, MCI, "MCI Send WLAN_CAL_DONE 0x%x\n",
 			mci_hw->wlan_cal_done);
 		MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_DONE);
 		pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_done++;
@@ -1074,9 +1064,8 @@ skip_tx_iqcal:
 		if (run_rtt_cal)
 			ar9003_hw_rtt_disable(ah);
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"offset calibration failed to complete in 1ms;"
-			"noisy environment?\n");
+		ath_dbg(common, CALIBRATE,
+			"offset calibration failed to complete in 1ms; noisy environment?\n");
 		return false;
 	}
 
@@ -1135,15 +1124,14 @@ skip_tx_iqcal:
 	if (ah->supp_cals & IQ_MISMATCH_CAL) {
 		INIT_CAL(&ah->iq_caldata);
 		INSERT_CAL(ah, &ah->iq_caldata);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"enabling IQ Calibration.\n");
+		ath_dbg(common, CALIBRATE, "enabling IQ Calibration\n");
 	}
 
 	if (ah->supp_cals & TEMP_COMP_CAL) {
 		INIT_CAL(&ah->tempCompCalData);
 		INSERT_CAL(ah, &ah->tempCompCalData);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"enabling Temperature Compensation Calibration.\n");
+		ath_dbg(common, CALIBRATE,
+			"enabling Temperature Compensation Calibration\n");
 	}
 
 	/* Initialize current pointer to first element in list */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 4ba6f52..391def9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3043,8 +3043,7 @@ static bool ar9300_read_eeprom(struct ath_hw *ah, int address, u8 *buffer,
 	int i;
 
 	if ((address < 0) || ((address + count) / 2 > AR9300_EEPROM_SIZE - 1)) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"eeprom address not in range\n");
+		ath_dbg(common, EEPROM, "eeprom address not in range\n");
 		return false;
 	}
 
@@ -3075,8 +3074,8 @@ static bool ar9300_read_eeprom(struct ath_hw *ah, int address, u8 *buffer,
 	return true;
 
 error:
-	ath_dbg(common, ATH_DBG_EEPROM,
-		"unable to read eeprom region at offset %d\n", address);
+	ath_dbg(common, EEPROM, "unable to read eeprom region at offset %d\n",
+		address);
 	return false;
 }
 
@@ -3160,13 +3159,13 @@ static bool ar9300_uncompress_block(struct ath_hw *ah,
 		length &= 0xff;
 
 		if (length > 0 && spot >= 0 && spot+length <= mdataSize) {
-			ath_dbg(common, ATH_DBG_EEPROM,
+			ath_dbg(common, EEPROM,
 				"Restore at %d: spot=%d offset=%d length=%d\n",
 				it, spot, offset, length);
 			memcpy(&mptr[spot], &block[it+2], length);
 			spot += length;
 		} else if (length > 0) {
-			ath_dbg(common, ATH_DBG_EEPROM,
+			ath_dbg(common, EEPROM,
 				"Bad restore at %d: spot=%d offset=%d length=%d\n",
 				it, spot, offset, length);
 			return false;
@@ -3188,13 +3187,13 @@ static int ar9300_compress_decision(struct ath_hw *ah,
 	switch (code) {
 	case _CompressNone:
 		if (length != mdata_size) {
-			ath_dbg(common, ATH_DBG_EEPROM,
+			ath_dbg(common, EEPROM,
 				"EEPROM structure size mismatch memory=%d eeprom=%d\n",
 				mdata_size, length);
 			return -1;
 		}
 		memcpy(mptr, (u8 *) (word + COMP_HDR_LEN), length);
-		ath_dbg(common, ATH_DBG_EEPROM,
+		ath_dbg(common, EEPROM,
 			"restored eeprom %d: uncompressed, length %d\n",
 			it, length);
 		break;
@@ -3203,22 +3202,21 @@ static int ar9300_compress_decision(struct ath_hw *ah,
 		} else {
 			eep = ar9003_eeprom_struct_find_by_id(reference);
 			if (eep == NULL) {
-				ath_dbg(common, ATH_DBG_EEPROM,
+				ath_dbg(common, EEPROM,
 					"can't find reference eeprom struct %d\n",
 					reference);
 				return -1;
 			}
 			memcpy(mptr, eep, mdata_size);
 		}
-		ath_dbg(common, ATH_DBG_EEPROM,
+		ath_dbg(common, EEPROM,
 			"restore eeprom %d: block, reference %d, length %d\n",
 			it, reference, length);
 		ar9300_uncompress_block(ah, mptr, mdata_size,
 					(u8 *) (word + COMP_HDR_LEN), length);
 		break;
 	default:
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"unknown compression code %d\n", code);
+		ath_dbg(common, EEPROM, "unknown compression code %d\n", code);
 		return -1;
 	}
 	return 0;
@@ -3294,34 +3292,32 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 		cptr = AR9300_BASE_ADDR_512;
 	else
 		cptr = AR9300_BASE_ADDR;
-	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying EEPROM access at Address 0x%04x\n", cptr);
+	ath_dbg(common, EEPROM, "Trying EEPROM access at Address 0x%04x\n",
+		cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	cptr = AR9300_BASE_ADDR_512;
-	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying EEPROM access at Address 0x%04x\n", cptr);
+	ath_dbg(common, EEPROM, "Trying EEPROM access at Address 0x%04x\n",
+		cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	read = ar9300_read_otp;
 	cptr = AR9300_BASE_ADDR;
-	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying OTP access at Address 0x%04x\n", cptr);
+	ath_dbg(common, EEPROM, "Trying OTP access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	cptr = AR9300_BASE_ADDR_512;
-	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying OTP access at Address 0x%04x\n", cptr);
+	ath_dbg(common, EEPROM, "Trying OTP access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	goto fail;
 
 found:
-	ath_dbg(common, ATH_DBG_EEPROM, "Found valid EEPROM data\n");
+	ath_dbg(common, EEPROM, "Found valid EEPROM data\n");
 
 	for (it = 0; it < MSTATE; it++) {
 		if (!read(ah, cptr, word, COMP_HDR_LEN))
@@ -3332,13 +3328,12 @@ found:
 
 		ar9300_comp_hdr_unpack(word, &code, &reference,
 				       &length, &major, &minor);
-		ath_dbg(common, ATH_DBG_EEPROM,
+		ath_dbg(common, EEPROM,
 			"Found block at %x: code=%d ref=%d length=%d major=%d minor=%d\n",
 			cptr, code, reference, length, major, minor);
 		if ((!AR_SREV_9485(ah) && length >= 1024) ||
 		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485)) {
-			ath_dbg(common, ATH_DBG_EEPROM,
-				"Skipping bad header\n");
+			ath_dbg(common, EEPROM, "Skipping bad header\n");
 			cptr -= COMP_HDR_LEN;
 			continue;
 		}
@@ -3347,13 +3342,13 @@ found:
 		read(ah, cptr, word, COMP_HDR_LEN + osize + COMP_CKSUM_LEN);
 		checksum = ar9300_comp_cksum(&word[COMP_HDR_LEN], length);
 		mchecksum = get_unaligned_le16(&word[COMP_HDR_LEN + osize]);
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"checksum %x %x\n", checksum, mchecksum);
+		ath_dbg(common, EEPROM, "checksum %x %x\n",
+			checksum, mchecksum);
 		if (checksum == mchecksum) {
 			ar9300_compress_decision(ah, it, code, reference, mptr,
 						 word, length, mdata_size);
 		} else {
-			ath_dbg(common, ATH_DBG_EEPROM,
+			ath_dbg(common, EEPROM,
 				"skipping block with bad checksum\n");
 		}
 		cptr -= (COMP_HDR_LEN + osize + COMP_CKSUM_LEN);
@@ -4424,8 +4419,8 @@ static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq,
 					      is2GHz) + ht40PowerIncForPdadc;
 
 	for (i = 0; i < ar9300RateSize; i++) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"TPC[%02d] 0x%08x\n", i, targetPowerValT2[i]);
+		ath_dbg(common, EEPROM, "TPC[%02d] 0x%08x\n",
+			i, targetPowerValT2[i]);
 	}
 }
 
@@ -4444,7 +4439,7 @@ static int ar9003_hw_cal_pier_get(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (ichain >= AR9300_MAX_CHAINS) {
-		ath_dbg(common, ATH_DBG_EEPROM,
+		ath_dbg(common, EEPROM,
 			"Invalid chain index, must be less than %d\n",
 			AR9300_MAX_CHAINS);
 		return -1;
@@ -4452,7 +4447,7 @@ static int ar9003_hw_cal_pier_get(struct ath_hw *ah,
 
 	if (mode) {		/* 5GHz */
 		if (ipier >= AR9300_NUM_5G_CAL_PIERS) {
-			ath_dbg(common, ATH_DBG_EEPROM,
+			ath_dbg(common, EEPROM,
 				"Invalid 5GHz cal pier index, must be less than %d\n",
 				AR9300_NUM_5G_CAL_PIERS);
 			return -1;
@@ -4462,7 +4457,7 @@ static int ar9003_hw_cal_pier_get(struct ath_hw *ah,
 		is2GHz = 0;
 	} else {
 		if (ipier >= AR9300_NUM_2G_CAL_PIERS) {
-			ath_dbg(common, ATH_DBG_EEPROM,
+			ath_dbg(common, EEPROM,
 				"Invalid 2GHz cal pier index, must be less than %d\n",
 				AR9300_NUM_2G_CAL_PIERS);
 			return -1;
@@ -4624,8 +4619,7 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 
 	/* interpolate  */
 	for (ichain = 0; ichain < AR9300_MAX_CHAINS; ichain++) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"ch=%d f=%d low=%d %d h=%d %d\n",
+		ath_dbg(common, EEPROM, "ch=%d f=%d low=%d %d h=%d %d\n",
 			ichain, frequency, lfrequency[ichain],
 			lcorrection[ichain], hfrequency[ichain],
 			hcorrection[ichain]);
@@ -4680,7 +4674,7 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 	ar9003_hw_power_control_override(ah, frequency, correction, voltage,
 					 temperature);
 
-	ath_dbg(common, ATH_DBG_EEPROM,
+	ath_dbg(common, EEPROM,
 		"for frequency=%d, calibration correction = %d %d %d\n",
 		frequency, correction[0], correction[1], correction[2]);
 
@@ -4866,7 +4860,7 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 		else
 			freq = centers.ctl_center;
 
-		ath_dbg(common, ATH_DBG_REGULATORY,
+		ath_dbg(common, REGULATORY,
 			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, EXT_ADDITIVE %d\n",
 			ctlMode, numCtlModes, isHt40CtlMode,
 			(pCtlMode[ctlMode] & EXT_ADDITIVE));
@@ -4882,7 +4876,7 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 
 		twiceMaxEdgePower = MAX_RATE_POWER;
 		for (i = 0; (i < ctlNum) && ctlIndex[i]; i++) {
-			ath_dbg(common, ATH_DBG_REGULATORY,
+			ath_dbg(common, REGULATORY,
 				"LOOP-Ctlidx %d: cfgCtl 0x%2.2x pCtlMode 0x%2.2x ctlIndex 0x%2.2x chan %d\n",
 				i, cfgCtl, pCtlMode[ctlMode], ctlIndex[i],
 				chan->channel);
@@ -4924,7 +4918,7 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 
 			minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
 
-			ath_dbg(common, ATH_DBG_REGULATORY,
+			ath_dbg(common, REGULATORY,
 				"SEL-Min ctlMode %d pCtlMode %d 2xMaxEdge %d sP %d minCtlPwr %d\n",
 				ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
 				scaledPower, minCtlPower);
@@ -5048,7 +5042,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 				target_power_val_t2_eep[i]) >
 			    paprd_scale_factor)) {
 				ah->paprd_ratemask &= ~(1 << i);
-				ath_dbg(common, ATH_DBG_EEPROM,
+				ath_dbg(common, EEPROM,
 					"paprd disabled for mcs %d\n", i);
 			}
 		}
@@ -5066,8 +5060,8 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 		return;
 
 	for (i = 0; i < ar9300RateSize; i++) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"TPC[%02d] 0x%08x\n", i, targetPowerValT2[i]);
+		ath_dbg(common, EEPROM, "TPC[%02d] 0x%08x\n",
+			i, targetPowerValT2[i]);
 	}
 
 	ah->txpower_limit = regulatory->max_power_level;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 631fe4f..4a31515 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -305,10 +305,8 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		raw_intr = REG_READ(ah, AR_MCI_INTERRUPT_RAW);
 
 		if ((raw_intr == 0xdeadbeef) || (rx_msg_intr == 0xdeadbeef))
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI gets 0xdeadbeef during MCI int processing"
-				"new raw_intr=0x%08x, new rx_msg_raw=0x%08x, "
-				"raw_intr=0x%08x, rx_msg_raw=0x%08x\n",
+			ath_dbg(common, MCI,
+				"MCI gets 0xdeadbeef during MCI int processing new raw_intr=0x%08x, new rx_msg_raw=0x%08x, raw_intr=0x%08x, rx_msg_raw=0x%08x\n",
 				raw_intr, rx_msg_intr, mci->raw_intr,
 				mci->rx_msg_intr);
 		else {
@@ -322,7 +320,7 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 
 			REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_RAW, rx_msg_intr);
 			REG_WRITE(ah, AR_MCI_INTERRUPT_RAW, raw_intr);
-			ath_dbg(common, ATH_DBG_MCI, "AR_INTR_SYNC_MCI\n");
+			ath_dbg(common, MCI, "AR_INTR_SYNC_MCI\n");
 
 		}
 	}
@@ -335,7 +333,7 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		}
 
 		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT)
-			ath_dbg(common, ATH_DBG_INTERRUPT,
+			ath_dbg(common, INTERRUPT,
 				"AR_INTR_SYNC_LOCAL_TIMEOUT\n");
 
 		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
@@ -366,7 +364,7 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 
 	if ((MS(ads->ds_info, AR_DescId) != ATHEROS_VENDOR_ID) ||
 	    (MS(ads->ds_info, AR_TxRxDesc) != 1)) {
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_XMIT,
+		ath_dbg(ath9k_hw_common(ah), XMIT,
 			"Tx Descriptor error %x\n", ads->ds_info);
 		memset(ads, 0, sizeof(*ads));
 		return -EIO;
@@ -574,7 +572,7 @@ void ath9k_hw_reset_txstatus_ring(struct ath_hw *ah)
 	memset((void *) ah->ts_ring, 0,
 		ah->ts_size * sizeof(struct ar9003_txs));
 
-	ath_dbg(ath9k_hw_common(ah), ATH_DBG_XMIT,
+	ath_dbg(ath9k_hw_common(ah), XMIT,
 		"TS Start 0x%x End 0x%x Virt %p, Size %d\n",
 		ah->ts_paddr_start, ah->ts_paddr_end,
 		ah->ts_ring, ah->ts_size);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 8599822..fdd0f81 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -68,11 +68,11 @@ static int ar9003_mci_wait_for_interrupt(struct ath_hw *ah, u32 address,
 	}
 
 	if (time_out <= 0) {
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Wait for Reg 0x%08x = 0x%08x timeout.\n",
+		ath_dbg(common, MCI,
+			"MCI Wait for Reg 0x%08x = 0x%08x timeout\n",
 			address, bit_position);
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI INT_RAW = 0x%08x, RX_MSG_RAW = 0x%08x",
+		ath_dbg(common, MCI,
+			"MCI INT_RAW = 0x%08x, RX_MSG_RAW = 0x%08x\n",
 			REG_READ(ah, AR_MCI_INTERRUPT_RAW),
 			REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_RAW));
 		time_out = 0;
@@ -135,7 +135,7 @@ static void ar9003_mci_send_coex_version_query(struct ath_hw *ah,
 
 	if (!mci->bt_version_known &&
 			(mci->bt_state != MCI_BT_SLEEP)) {
-		ath_dbg(common, ATH_DBG_MCI, "MCI Send Coex version query\n");
+		ath_dbg(common, MCI, "MCI Send Coex version query\n");
 		MCI_GPM_SET_TYPE_OPCODE(payload,
 				MCI_GPM_COEX_AGENT, MCI_GPM_COEX_VERSION_QUERY);
 		ar9003_mci_send_message(ah, MCI_GPM, 0, payload, 16,
@@ -150,7 +150,7 @@ static void ar9003_mci_send_coex_version_response(struct ath_hw *ah,
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 payload[4] = {0, 0, 0, 0};
 
-	ath_dbg(common, ATH_DBG_MCI, "MCI Send Coex version response\n");
+	ath_dbg(common, MCI, "MCI Send Coex version response\n");
 	MCI_GPM_SET_TYPE_OPCODE(payload, MCI_GPM_COEX_AGENT,
 			MCI_GPM_COEX_VERSION_RESPONSE);
 	*(((u8 *)payload) + MCI_GPM_COEX_B_MAJOR_VERSION) =
@@ -187,8 +187,8 @@ static void ar9003_mci_send_coex_bt_status_query(struct ath_hw *ah,
 
 	if (mci->bt_state != MCI_BT_SLEEP) {
 
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Send Coex BT Status Query 0x%02X\n", query_type);
+		ath_dbg(common, MCI, "MCI Send Coex BT Status Query 0x%02X\n",
+			query_type);
 
 		MCI_GPM_SET_TYPE_OPCODE(payload,
 				MCI_GPM_COEX_AGENT, MCI_GPM_COEX_STATUS_QUERY);
@@ -203,9 +203,8 @@ static void ar9003_mci_send_coex_bt_status_query(struct ath_hw *ah,
 			if (query_btinfo) {
 				mci->need_flush_btinfo = true;
 
-				ath_dbg(common, ATH_DBG_MCI,
-					"MCI send bt_status_query fail, "
-					"set flush flag again\n");
+				ath_dbg(common, MCI,
+					"MCI send bt_status_query fail, set flush flag again\n");
 			}
 		}
 
@@ -221,7 +220,7 @@ void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 payload[4] = {0, 0, 0, 0};
 
-	ath_dbg(common, ATH_DBG_MCI, "MCI Send Coex %s BT GPM.\n",
+	ath_dbg(common, MCI, "MCI Send Coex %s BT GPM\n",
 		(halt) ? "halt" : "unhalt");
 
 	MCI_GPM_SET_TYPE_OPCODE(payload,
@@ -259,8 +258,8 @@ static void ar9003_mci_prep_interface(struct ath_hw *ah)
 		  REG_READ(ah, AR_MCI_INTERRUPT_RAW));
 
 	/* Remote Reset */
-	ath_dbg(common, ATH_DBG_MCI, "MCI Reset sequence start\n");
-	ath_dbg(common, ATH_DBG_MCI, "MCI send REMOTE_RESET\n");
+	ath_dbg(common, MCI, "MCI Reset sequence start\n");
+	ath_dbg(common, MCI, "MCI send REMOTE_RESET\n");
 	ar9003_mci_remote_reset(ah, true);
 
 	/*
@@ -271,14 +270,13 @@ static void ar9003_mci_prep_interface(struct ath_hw *ah)
 	if (AR_SREV_9462_10(ah))
 		udelay(252);
 
-	ath_dbg(common, ATH_DBG_MCI, "MCI Send REQ_WAKE to remoter(BT)\n");
+	ath_dbg(common, MCI, "MCI Send REQ_WAKE to remoter(BT)\n");
 	ar9003_mci_send_req_wake(ah, true);
 
 	if (ar9003_mci_wait_for_interrupt(ah, AR_MCI_INTERRUPT_RX_MSG_RAW,
 				AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING, 500)) {
 
-		ath_dbg(common, ATH_DBG_MCI,
-				"MCI SYS_WAKING from remote(BT)\n");
+		ath_dbg(common, MCI, "MCI SYS_WAKING from remote(BT)\n");
 		mci->bt_state = MCI_BT_AWAKE;
 
 		if (AR_SREV_9462_10(ah))
@@ -302,8 +300,7 @@ static void ar9003_mci_prep_interface(struct ath_hw *ah)
 
 		/* Send SYS_WAKING to BT */
 
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI send SW SYS_WAKING to remote BT\n");
+		ath_dbg(common, MCI, "MCI send SW SYS_WAKING to remote BT\n");
 
 		ar9003_mci_send_sys_waking(ah, true);
 		udelay(10);
@@ -332,8 +329,7 @@ static void ar9003_mci_prep_interface(struct ath_hw *ah)
 
 		if (AR_SREV_9462_10(ah) || mci->is_2g) {
 			/* Send LNA_TRANS */
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI send LNA_TRANS to BT\n");
+			ath_dbg(common, MCI, "MCI send LNA_TRANS to BT\n");
 			ar9003_mci_send_lna_transfer(ah, true);
 			udelay(5);
 		}
@@ -344,20 +340,17 @@ static void ar9003_mci_prep_interface(struct ath_hw *ah)
 				AR_MCI_INTERRUPT_RX_MSG_RAW,
 				AR_MCI_INTERRUPT_RX_MSG_LNA_INFO,
 				mci_timeout))
-				ath_dbg(common, ATH_DBG_MCI,
-					"MCI WLAN has control over the LNA & "
-					"BT obeys it\n");
+				ath_dbg(common, MCI,
+					"MCI WLAN has control over the LNA & BT obeys it\n");
 			else
-				ath_dbg(common, ATH_DBG_MCI,
-					"MCI BT didn't respond to"
-					"LNA_TRANS\n");
+				ath_dbg(common, MCI,
+					"MCI BT didn't respond to LNA_TRANS\n");
 		}
 
 		if (AR_SREV_9462_10(ah)) {
 			/* Send another remote_reset to deassert BT clk_req. */
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI another remote_reset to "
-				"deassert clk_req\n");
+			ath_dbg(common, MCI,
+				"MCI another remote_reset to deassert clk_req\n");
 			ar9003_mci_remote_reset(ah, true);
 			udelay(252);
 		}
@@ -441,7 +434,7 @@ static bool ar9003_mci_is_gpm_valid(struct ath_hw *ah, u32 msg_index)
 	recv_type = MCI_GPM_TYPE(payload);
 
 	if (recv_type == MCI_GPM_RSVD_PATTERN) {
-		ath_dbg(common, ATH_DBG_MCI, "MCI Skip RSVD GPM\n");
+		ath_dbg(common, MCI, "MCI Skip RSVD GPM\n");
 		return false;
 	}
 
@@ -514,11 +507,11 @@ static bool ar9003_mci_send_coex_bt_flags(struct ath_hw *ah, bool wait_done,
 	*(((u8 *)pld) + MCI_GPM_COEX_W_BT_FLAGS + 2) = (bt_flags >> 16) & 0xFF;
 	*(((u8 *)pld) + MCI_GPM_COEX_W_BT_FLAGS + 3) = (bt_flags >> 24) & 0xFF;
 
-	ath_dbg(common, ATH_DBG_MCI,
+	ath_dbg(common, MCI,
 		"MCI BT_MCI_FLAGS: Send Coex BT Update Flags %s 0x%08x\n",
-		(opcode == MCI_GPM_COEX_BT_FLAGS_READ) ? "READ" :
-		((opcode == MCI_GPM_COEX_BT_FLAGS_SET) ? "SET" : "CLEAR"),
-								bt_flags);
+		opcode == MCI_GPM_COEX_BT_FLAGS_READ ? "READ" :
+		opcode == MCI_GPM_COEX_BT_FLAGS_SET ? "SET" : "CLEAR",
+		bt_flags);
 
 	return ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16,
 							wait_done, true);
@@ -531,7 +524,7 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 regval, thresh;
 
-	ath_dbg(common, ATH_DBG_MCI, "MCI full_sleep = %d, is_2g = %d\n",
+	ath_dbg(common, MCI, "MCI full_sleep = %d, is_2g = %d\n",
 		is_full_sleep, is_2g);
 
 	/*
@@ -539,14 +532,13 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	 */
 
 	if (!mci->gpm_addr && !mci->sched_addr) {
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI GPM and schedule buffers are not allocated");
+		ath_dbg(common, MCI,
+			"MCI GPM and schedule buffers are not allocated\n");
 		return;
 	}
 
 	if (REG_READ(ah, AR_BTCOEX_CTRL) == 0xdeadbeef) {
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI it's deadbeef, quit mci_reset\n");
+		ath_dbg(common, MCI, "MCI it's deadbeef, quit mci_reset\n");
 		return;
 	}
 
@@ -574,8 +566,7 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA)) {
 
 		regval |= SM(1, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
-		ath_dbg(common, ATH_DBG_MCI,
-				"MCI sched one step look ahead\n");
+		ath_dbg(common, MCI, "MCI sched one step look ahead\n");
 
 		if (!(mci->config &
 		      ATH_MCI_CONFIG_DISABLE_AGGR_THRESH)) {
@@ -593,11 +584,9 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 				      AR_MCI_SCHD_TABLE_2_MEM_BASED, 1);
 
 		} else
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI sched aggr thresh: off\n");
+			ath_dbg(common, MCI, "MCI sched aggr thresh: off\n");
 	} else
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI SCHED one step look ahead off\n");
+		ath_dbg(common, MCI, "MCI SCHED one step look ahead off\n");
 
 	if (AR_SREV_9462_10(ah))
 		regval |= SM(1, AR_BTCOEX_CTRL_SPDT_ENABLE_10);
@@ -678,12 +667,12 @@ void ar9003_mci_mute_bt(struct ath_hw *ah)
 	 * 2. before reset MCI RX, to quiet BT and avoid MCI RX misalignment
 	 */
 
-	ath_dbg(common, ATH_DBG_MCI, "MCI Send LNA take\n");
+	ath_dbg(common, MCI, "MCI Send LNA take\n");
 	ar9003_mci_send_lna_take(ah, true);
 
 	udelay(5);
 
-	ath_dbg(common, ATH_DBG_MCI, "MCI Send sys sleeping\n");
+	ath_dbg(common, MCI, "MCI Send sys sleeping\n");
 	ar9003_mci_send_sys_sleeping(ah, true);
 }
 
@@ -696,7 +685,7 @@ void ar9003_mci_sync_bt_state(struct ath_hw *ah)
 	cur_bt_state = ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL);
 
 	if (mci->bt_state != cur_bt_state) {
-		ath_dbg(common, ATH_DBG_MCI,
+		ath_dbg(common, MCI,
 			"MCI BT state mismatches. old: %d, new: %d\n",
 			mci->bt_state, cur_bt_state);
 		mci->bt_state = cur_bt_state;
@@ -708,7 +697,7 @@ void ar9003_mci_sync_bt_state(struct ath_hw *ah)
 		ar9003_mci_send_coex_wlan_channels(ah, true);
 
 		if (mci->unhalt_bt_gpm == true) {
-			ath_dbg(common, ATH_DBG_MCI, "MCI unhalt BT GPM");
+			ath_dbg(common, MCI, "MCI unhalt BT GPM\n");
 			ar9003_mci_send_coex_halt_bt_gpm(ah, false, true);
 		}
 	}
@@ -734,7 +723,7 @@ static void ar9003_mci_send_2g5g_status(struct ath_hw *ah, bool wait_done)
 			to_set = MCI_5G_FLAGS_SET_MASK;
 		}
 
-		ath_dbg(common, ATH_DBG_MCI,
+		ath_dbg(common, MCI,
 			"MCI BT_MCI_FLAGS: %s 0x%08x clr=0x%08x, set=0x%08x\n",
 		mci->is_2g ? "2G" : "5G", new_flags, to_clear, to_set);
 
@@ -761,15 +750,15 @@ static void ar9003_mci_queue_unsent_gpm(struct ath_hw *ah, u8 header,
 	if (queue) {
 
 		if (payload)
-			ath_dbg(common, ATH_DBG_MCI,
+			ath_dbg(common, MCI,
 				"MCI ERROR: Send fail: %02x: %02x %02x %02x\n",
 				header,
 				*(((u8 *)payload) + 4),
 				*(((u8 *)payload) + 5),
 				*(((u8 *)payload) + 6));
 		else
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI ERROR: Send fail: %02x\n", header);
+			ath_dbg(common, MCI, "MCI ERROR: Send fail: %02x\n",
+				header);
 	}
 
 	/* check if the message is to be queued */
@@ -795,12 +784,12 @@ static void ar9003_mci_queue_unsent_gpm(struct ath_hw *ah, u8 header,
 		mci->update_2g5g = queue;
 
 		if (queue)
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI BT_MCI_FLAGS: 2G5G status <queued> %s.\n",
+			ath_dbg(common, MCI,
+				"MCI BT_MCI_FLAGS: 2G5G status <queued> %s\n",
 				mci->is_2g ? "2G" : "5G");
 		else
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI BT_MCI_FLAGS: 2G5G status <sent> %s.\n",
+			ath_dbg(common, MCI,
+				"MCI BT_MCI_FLAGS: 2G5G status <sent> %s\n",
 				mci->is_2g ? "2G" : "5G");
 
 		break;
@@ -809,11 +798,9 @@ static void ar9003_mci_queue_unsent_gpm(struct ath_hw *ah, u8 header,
 
 		mci->wlan_channels_update = queue;
 		if (queue)
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI WLAN channel map <queued>\n");
+			ath_dbg(common, MCI, "MCI WLAN channel map <queued>\n");
 		else
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI WLAN channel map <sent>\n");
+			ath_dbg(common, MCI, "MCI WLAN channel map <sent>\n");
 		break;
 
 	case MCI_GPM_COEX_HALT_BT_GPM:
@@ -824,11 +811,11 @@ static void ar9003_mci_queue_unsent_gpm(struct ath_hw *ah, u8 header,
 			mci->unhalt_bt_gpm = queue;
 
 			if (queue)
-				ath_dbg(common, ATH_DBG_MCI,
+				ath_dbg(common, MCI,
 					"MCI UNHALT BT GPM <queued>\n");
 			else {
 				mci->halted_bt_gpm = false;
-				ath_dbg(common, ATH_DBG_MCI,
+				ath_dbg(common, MCI,
 					"MCI UNHALT BT GPM <sent>\n");
 			}
 		}
@@ -839,10 +826,10 @@ static void ar9003_mci_queue_unsent_gpm(struct ath_hw *ah, u8 header,
 			mci->halted_bt_gpm = !queue;
 
 			if (queue)
-				ath_dbg(common, ATH_DBG_MCI,
+				ath_dbg(common, MCI,
 					"MCI HALT BT GPM <not sent>\n");
 			else
-				ath_dbg(common, ATH_DBG_MCI,
+				ath_dbg(common, MCI,
 					"MCI UNHALT BT GPM <sent>\n");
 		}
 
@@ -861,7 +848,7 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done)
 		if (mci->is_2g) {
 
 			ar9003_mci_send_2g5g_status(ah, true);
-			ath_dbg(common, ATH_DBG_MCI, "MCI Send LNA trans\n");
+			ath_dbg(common, MCI, "MCI Send LNA trans\n");
 			ar9003_mci_send_lna_transfer(ah, true);
 			udelay(5);
 
@@ -878,7 +865,7 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done)
 				}
 			}
 		} else {
-			ath_dbg(common, ATH_DBG_MCI, "MCI Send LNA take\n");
+			ath_dbg(common, MCI, "MCI Send LNA take\n");
 			ar9003_mci_send_lna_take(ah, true);
 			udelay(5);
 
@@ -913,9 +900,9 @@ bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
 
 	if ((regval == 0xdeadbeef) || !(regval & AR_BTCOEX_CTRL_MCI_MODE_EN)) {
 
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Not sending 0x%x. MCI is not enabled. "
-			"full_sleep = %d\n", header,
+		ath_dbg(common, MCI,
+			"MCI Not sending 0x%x. MCI is not enabled. full_sleep = %d\n",
+			header,
 			(ah->power_mode == ATH9K_PM_FULL_SLEEP) ? 1 : 0);
 
 		ar9003_mci_queue_unsent_gpm(ah, header, payload, true);
@@ -923,8 +910,9 @@ bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
 
 	} else if (check_bt && (mci->bt_state == MCI_BT_SLEEP)) {
 
-		ath_dbg(common, ATH_DBG_MCI,
-		"MCI Don't send message 0x%x. BT is in sleep state\n", header);
+		ath_dbg(common, MCI,
+			"MCI Don't send message 0x%x. BT is in sleep state\n",
+			header);
 
 		ar9003_mci_queue_unsent_gpm(ah, header, payload, true);
 		return false;
@@ -989,7 +977,7 @@ void ar9003_mci_cleanup(struct ath_hw *ah)
 
 	/* Turn off MCI and Jupiter mode. */
 	REG_WRITE(ah, AR_BTCOEX_CTRL, 0x00);
-	ath_dbg(common, ATH_DBG_MCI, "MCI ar9003_mci_cleanup\n");
+	ath_dbg(common, MCI, "MCI ar9003_mci_cleanup\n");
 	ar9003_mci_disable_interrupt(ah);
 }
 EXPORT_SYMBOL(ar9003_mci_cleanup);
@@ -1006,40 +994,35 @@ static void ar9003_mci_process_gpm_extra(struct ath_hw *ah, u8 gpm_type,
 
 	switch (gpm_opcode) {
 	case MCI_GPM_COEX_VERSION_QUERY:
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM COEX Version Query\n");
+		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Query\n");
 		ar9003_mci_send_coex_version_response(ah, true);
 		break;
 	case MCI_GPM_COEX_VERSION_RESPONSE:
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM COEX Version Response\n");
+		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Response\n");
 		mci->bt_ver_major =
 			*(p_data + MCI_GPM_COEX_B_MAJOR_VERSION);
 		mci->bt_ver_minor =
 			*(p_data + MCI_GPM_COEX_B_MINOR_VERSION);
 		mci->bt_version_known = true;
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI BT Coex version: %d.%d\n",
-			mci->bt_ver_major,
-			mci->bt_ver_minor);
+		ath_dbg(common, MCI, "MCI BT Coex version: %d.%d\n",
+			mci->bt_ver_major, mci->bt_ver_minor);
 		break;
 	case MCI_GPM_COEX_STATUS_QUERY:
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM COEX Status Query = 0x%02X.\n",
+		ath_dbg(common, MCI,
+			"MCI Recv GPM COEX Status Query = 0x%02X\n",
 			*(p_data + MCI_GPM_COEX_B_WLAN_BITMAP));
 		mci->wlan_channels_update = true;
 		ar9003_mci_send_coex_wlan_channels(ah, true);
 		break;
 	case MCI_GPM_COEX_BT_PROFILE_INFO:
 		mci->query_bt = true;
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM COEX BT_Profile_Info\n");
+		ath_dbg(common, MCI, "MCI Recv GPM COEX BT_Profile_Info\n");
 		break;
 	case MCI_GPM_COEX_BT_STATUS_UPDATE:
 		mci->query_bt = true;
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM COEX BT_Status_Update "
-			"SEQ=%d (drop&query)\n", *(p_gpm + 3));
+		ath_dbg(common, MCI,
+			"MCI Recv GPM COEX BT_Status_Update SEQ=%d (drop&query)\n",
+			*(p_gpm + 3));
 		break;
 	default:
 		break;
@@ -1090,9 +1073,8 @@ u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 				if ((gpm_type == MCI_GPM_BT_CAL_DONE) &&
 				    !b_is_bt_cal_done) {
 					gpm_type = MCI_GPM_BT_CAL_GRANT;
-					ath_dbg(common, ATH_DBG_MCI,
-						"MCI Recv BT_CAL_DONE"
-						"wait BT_CAL_GRANT\n");
+					ath_dbg(common, MCI,
+						"MCI Recv BT_CAL_DONE wait BT_CAL_GRANT\n");
 					continue;
 				}
 
@@ -1123,7 +1105,7 @@ u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 			u32 payload[4] = {0, 0, 0, 0};
 
 			gpm_type = MCI_GPM_BT_CAL_DONE;
-			ath_dbg(common, ATH_DBG_MCI,
+			ath_dbg(common, MCI,
 				"MCI Rcv BT_CAL_REQ, send WLAN_CAL_GRANT\n");
 
 			MCI_GPM_SET_CAL_TYPE(payload,
@@ -1132,13 +1114,12 @@ u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 			ar9003_mci_send_message(ah, MCI_GPM, 0, payload, 16,
 						false, false);
 
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI now wait for BT_CAL_DONE\n");
+			ath_dbg(common, MCI, "MCI now wait for BT_CAL_DONE\n");
 
 			continue;
 		} else {
-			ath_dbg(common, ATH_DBG_MCI, "MCI GPM subtype"
-					"not match 0x%x\n", *(p_gpm + 1));
+			ath_dbg(common, MCI, "MCI GPM subtype not match 0x%x\n",
+				*(p_gpm + 1));
 			mismatch++;
 			ar9003_mci_process_gpm_extra(ah, recv_type,
 					recv_opcode, p_gpm);
@@ -1151,16 +1132,15 @@ u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 
 	if (time_out <= 0) {
 		time_out = 0;
-		ath_dbg(common, ATH_DBG_MCI,
+		ath_dbg(common, MCI,
 			"MCI GPM received timeout, mismatch = %d\n", mismatch);
 	} else
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Receive GPM type=0x%x, code=0x%x\n",
+		ath_dbg(common, MCI, "MCI Receive GPM type=0x%x, code=0x%x\n",
 			gpm_type, gpm_opcode);
 
 	while (more_data == MCI_GPM_MORE) {
 
-		ath_dbg(common, ATH_DBG_MCI, "MCI discard remaining GPM\n");
+		ath_dbg(common, MCI, "MCI discard remaining GPM\n");
 		offset = ar9003_mci_state(ah, MCI_STATE_NEXT_GPM_OFFSET,
 					  &more_data);
 
@@ -1201,8 +1181,7 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 		break;
 	case MCI_STATE_INIT_GPM_OFFSET:
 		value = MS(REG_READ(ah, AR_MCI_GPM_1), AR_MCI_GPM_WRITE_PTR);
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI GPM initial WRITE_PTR=%d\n", value);
+		ath_dbg(common, MCI, "MCI GPM initial WRITE_PTR=%d\n", value);
 		mci->gpm_idx = value;
 		break;
 	case MCI_STATE_NEXT_GPM_OFFSET:
@@ -1227,8 +1206,8 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 		else if (value >= mci->gpm_len) {
 			if (value != 0xFFFF) {
 				value = 0;
-				ath_dbg(common, ATH_DBG_MCI, "MCI GPM offset"
-					"out of range\n");
+				ath_dbg(common, MCI,
+					"MCI GPM offset out of range\n");
 			}
 		} else
 			value--;
@@ -1236,8 +1215,8 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 		if (value == 0xFFFF) {
 			value = MCI_GPM_INVALID;
 			more_gpm = MCI_GPM_NOMORE;
-			ath_dbg(common, ATH_DBG_MCI, "MCI GPM ptr invalid"
-				"@ptr=%d, offset=%d, more=GPM_NOMORE\n",
+			ath_dbg(common, MCI,
+				"MCI GPM ptr invalid @ptr=%d, offset=%d, more=GPM_NOMORE\n",
 				gpm_ptr, value);
 		} else if (state_type == MCI_STATE_NEXT_GPM_OFFSET) {
 
@@ -1245,9 +1224,9 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 				value = MCI_GPM_INVALID;
 				more_gpm = MCI_GPM_NOMORE;
 
-				ath_dbg(common, ATH_DBG_MCI, "MCI GPM message"
-					"not available @ptr=%d, @offset=%d,"
-					"more=GPM_NOMORE\n", gpm_ptr, value);
+				ath_dbg(common, MCI,
+					"MCI GPM message not available @ptr=%d, @offset=%d, more=GPM_NOMORE\n",
+					gpm_ptr, value);
 			} else {
 				for (;;) {
 
@@ -1267,9 +1246,8 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 					    mci->gpm_len)
 						mci->gpm_idx = 0;
 
-					ath_dbg(common, ATH_DBG_MCI,
-						"MCI GPM message got ptr=%d,"
-						"@offset=%d, more=%d\n",
+					ath_dbg(common, MCI,
+						"MCI GPM message got ptr=%d, @offset=%d, more=%d\n",
 						gpm_ptr, temp_index,
 						(more_gpm == MCI_GPM_MORE));
 
@@ -1333,8 +1311,7 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 
 		if (mci->unhalt_bt_gpm) {
 
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI unhalt BT GPM\n");
+			ath_dbg(common, MCI, "MCI unhalt BT GPM\n");
 			ar9003_mci_send_coex_halt_bt_gpm(ah, false, true);
 		}
 
@@ -1360,8 +1337,8 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 				      ATH_MCI_CONFIG_MCI_OBS_GPIO) !=
 					ATH_MCI_CONFIG_MCI_OBS_GPIO) {
 
-				ath_dbg(common, ATH_DBG_MCI,
-					"MCI reconfigure observation");
+				ath_dbg(common, MCI,
+					"MCI reconfigure observation\n");
 				ar9003_mci_observation_set_up(ah);
 			}
 		}
@@ -1374,16 +1351,14 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 	case MCI_STATE_SET_BT_COEX_VERSION:
 
 		if (!p_data)
-			ath_dbg(common, ATH_DBG_MCI,
+			ath_dbg(common, MCI,
 				"MCI Set BT Coex version with NULL data!!\n");
 		else {
 			mci->bt_ver_major = (*p_data >> 8) & 0xff;
 			mci->bt_ver_minor = (*p_data) & 0xff;
 			mci->bt_version_known = true;
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI BT version set: %d.%d\n",
-				mci->bt_ver_major,
-				mci->bt_ver_minor);
+			ath_dbg(common, MCI, "MCI BT version set: %d.%d\n",
+				mci->bt_ver_major, mci->bt_ver_minor);
 		}
 		break;
 
@@ -1438,7 +1413,7 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 
 	case MCI_STATE_RECOVER_RX:
 
-		ath_dbg(common, ATH_DBG_MCI, "MCI hw RECOVER_RX\n");
+		ath_dbg(common, MCI, "MCI hw RECOVER_RX\n");
 		ar9003_mci_prep_interface(ah);
 		mci->query_bt = true;
 		mci->need_flush_btinfo = true;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index a4450cb..59647a3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -119,8 +119,8 @@ static int ar9003_get_training_power_5g(struct ath_hw *ah)
 		break;
 	default:
 		delta = 0;
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-		"Invalid tx-chainmask: %u\n", ah->txchainmask);
+		ath_dbg(common, CALIBRATE, "Invalid tx-chainmask: %u\n",
+			ah->txchainmask);
 	}
 
 	power += delta;
@@ -148,13 +148,12 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 	else
 		training_power = ar9003_get_training_power_5g(ah);
 
-	ath_dbg(common, ATH_DBG_CALIBRATE,
-		"Training power: %d, Target power: %d\n",
+	ath_dbg(common, CALIBRATE, "Training power: %d, Target power: %d\n",
 		training_power, ah->paprd_target_power);
 
 	if (training_power < 0) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"PAPRD target power delta out of range");
+		ath_dbg(common, CALIBRATE,
+			"PAPRD target power delta out of range\n");
 		return -ERANGE;
 	}
 	ah->paprd_training_power = training_power;
@@ -311,8 +310,8 @@ static unsigned int ar9003_get_desired_gain(struct ath_hw *ah, int chain,
 		reg_cl_gain = AR_PHY_CL_TAB_2;
 		break;
 	default:
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
-		"Invalid chainmask: %d\n", chain);
+		ath_dbg(ath9k_hw_common(ah), CALIBRATE,
+			"Invalid chainmask: %d\n", chain);
 		break;
 	}
 
@@ -850,7 +849,7 @@ bool ar9003_paprd_is_done(struct ath_hw *ah)
 		agc2_pwr = REG_READ_FIELD(ah, AR_PHY_PAPRD_TRAINER_STAT1,
 				AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_AGC2_PWR);
 
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+		ath_dbg(ath9k_hw_common(ah), CALIBRATE,
 			"AGC2_PWR = 0x%x training done = 0x%x\n",
 			agc2_pwr, paprd_done);
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index e41d269..2589b38 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -882,7 +882,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
 
 		if (!on != aniState->ofdmWeakSigDetectOff) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: ofdm weak signal: %s=>%s\n",
 				chan->channel,
 				!aniState->ofdmWeakSigDetectOff ?
@@ -900,7 +900,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(firstep_table)) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"ATH9K_ANI_FIRSTEP_LEVEL: level out of range (%u > %zu)\n",
 				level, ARRAY_SIZE(firstep_table));
 			return false;
@@ -937,7 +937,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 			      AR_PHY_FIND_SIG_LOW_FIRSTEP_LOW, value2);
 
 		if (level != aniState->firstepLevel) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: level %d=>%d[def:%d] firstep[level]=%d ini=%d\n",
 				chan->channel,
 				aniState->firstepLevel,
@@ -945,7 +945,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 				ATH9K_ANI_FIRSTEP_LVL_NEW,
 				value,
 				aniState->iniDef.firstep);
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: level %d=>%d[def:%d] firstep_low[level]=%d ini=%d\n",
 				chan->channel,
 				aniState->firstepLevel,
@@ -965,7 +965,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(cycpwrThr1_table)) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"ATH9K_ANI_SPUR_IMMUNITY_LEVEL: level out of range (%u > %zu)\n",
 				level, ARRAY_SIZE(cycpwrThr1_table));
 			return false;
@@ -1001,7 +1001,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 			      AR_PHY_EXT_CYCPWR_THR1, value2);
 
 		if (level != aniState->spurImmunityLevel) {
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: level %d=>%d[def:%d] cycpwrThr1[level]=%d ini=%d\n",
 				chan->channel,
 				aniState->spurImmunityLevel,
@@ -1009,7 +1009,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 				ATH9K_ANI_SPUR_IMMUNE_LVL_NEW,
 				value,
 				aniState->iniDef.cycpwrThr1);
-			ath_dbg(common, ATH_DBG_ANI,
+			ath_dbg(common, ANI,
 				"** ch %d: level %d=>%d[def:%d] cycpwrThr1Ext[level]=%d ini=%d\n",
 				chan->channel,
 				aniState->spurImmunityLevel,
@@ -1036,8 +1036,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,
 			      AR_PHY_MRC_CCK_MUX_REG, is_on);
 		if (!is_on != aniState->mrcCCKOff) {
-			ath_dbg(common, ATH_DBG_ANI,
-				"** ch %d: MRC CCK: %s=>%s\n",
+			ath_dbg(common, ANI, "** ch %d: MRC CCK: %s=>%s\n",
 				chan->channel,
 				!aniState->mrcCCKOff ? "on" : "off",
 				is_on ? "on" : "off");
@@ -1052,11 +1051,11 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 	case ATH9K_ANI_PRESENT:
 		break;
 	default:
-		ath_dbg(common, ATH_DBG_ANI, "invalid cmd %u\n", cmd);
+		ath_dbg(common, ANI, "invalid cmd %u\n", cmd);
 		return false;
 	}
 
-	ath_dbg(common, ATH_DBG_ANI,
+	ath_dbg(common, ANI,
 		"ANI parameters: SI=%d, ofdmWS=%s FS=%d MRCcck=%s listenTime=%d ofdmErrs=%d cckErrs=%d\n",
 		aniState->spurImmunityLevel,
 		!aniState->ofdmWeakSigDetectOff ? "on" : "off",
@@ -1125,8 +1124,7 @@ static void ar9003_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	aniState = &ah->curchan->ani;
 	iniDef = &aniState->iniDef;
 
-	ath_dbg(common, ATH_DBG_ANI,
-		"ver %d.%d opmode %u chan %d Mhz/0x%x\n",
+	ath_dbg(common, ANI, "ver %d.%d opmode %u chan %d Mhz/0x%x\n",
 		ah->hw_version.macVersion,
 		ah->hw_version.macRev,
 		ah->opmode,
@@ -1388,7 +1386,7 @@ void ar9003_hw_bb_watchdog_config(struct ath_hw *ah)
 			  ~(AR_PHY_WATCHDOG_NON_IDLE_ENABLE |
 			    AR_PHY_WATCHDOG_IDLE_ENABLE));
 
-		ath_dbg(common, ATH_DBG_RESET, "Disabled BB Watchdog\n");
+		ath_dbg(common, RESET, "Disabled BB Watchdog\n");
 		return;
 	}
 
@@ -1424,8 +1422,7 @@ void ar9003_hw_bb_watchdog_config(struct ath_hw *ah)
 		  AR_PHY_WATCHDOG_IDLE_MASK |
 		  (AR_PHY_WATCHDOG_NON_IDLE_MASK & (idle_count << 2)));
 
-	ath_dbg(common, ATH_DBG_RESET,
-		"Enabled BB Watchdog timeout (%u ms)\n",
+	ath_dbg(common, RESET, "Enabled BB Watchdog timeout (%u ms)\n",
 		idle_tmo_ms);
 }
 
@@ -1454,9 +1451,9 @@ void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah)
 		return;
 
 	status = ah->bb_watchdog_last_status;
-	ath_dbg(common, ATH_DBG_RESET,
+	ath_dbg(common, RESET,
 		"\n==== BB update: BB status=0x%08x ====\n", status);
-	ath_dbg(common, ATH_DBG_RESET,
+	ath_dbg(common, RESET,
 		"** BB state: wd=%u det=%u rdar=%u rOFDM=%d rCCK=%u tOFDM=%u tCCK=%u agc=%u src=%u **\n",
 		MS(status, AR_PHY_WATCHDOG_INFO),
 		MS(status, AR_PHY_WATCHDOG_DET_HANG),
@@ -1468,22 +1465,19 @@ void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah)
 		MS(status, AR_PHY_WATCHDOG_AGC_SM),
 		MS(status, AR_PHY_WATCHDOG_SRCH_SM));
 
-	ath_dbg(common, ATH_DBG_RESET,
-		"** BB WD cntl: cntl1=0x%08x cntl2=0x%08x **\n",
+	ath_dbg(common, RESET, "** BB WD cntl: cntl1=0x%08x cntl2=0x%08x **\n",
 		REG_READ(ah, AR_PHY_WATCHDOG_CTL_1),
 		REG_READ(ah, AR_PHY_WATCHDOG_CTL_2));
-	ath_dbg(common, ATH_DBG_RESET,
-		"** BB mode: BB_gen_controls=0x%08x **\n",
+	ath_dbg(common, RESET, "** BB mode: BB_gen_controls=0x%08x **\n",
 		REG_READ(ah, AR_PHY_GEN_CTRL));
 
 #define PCT(_field) (common->cc_survey._field * 100 / common->cc_survey.cycles)
 	if (common->cc_survey.cycles)
-		ath_dbg(common, ATH_DBG_RESET,
+		ath_dbg(common, RESET,
 			"** BB busy times: rx_clear=%d%%, rx_frame=%d%%, tx_frame=%d%% **\n",
 			PCT(rx_busy), PCT(rx_frame), PCT(tx_frame));
 
-	ath_dbg(common, ATH_DBG_RESET,
-		"==== BB update: done ====\n\n");
+	ath_dbg(common, RESET, "==== BB update: done ====\n\n");
 }
 EXPORT_SYMBOL(ar9003_hw_bb_watchdog_dbg_info);
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index a13cabb..dc5fd56 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -117,11 +117,10 @@ static void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 	memset(&txctl, 0, sizeof(struct ath_tx_control));
 	txctl.txq = sc->beacon.cabq;
 
-	ath_dbg(common, ATH_DBG_XMIT,
-		"transmitting CABQ packet, skb: %p\n", skb);
+	ath_dbg(common, XMIT, "transmitting CABQ packet, skb: %p\n", skb);
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		ath_dbg(common, ATH_DBG_XMIT, "CABQ TX failed\n");
+		ath_dbg(common, XMIT, "CABQ TX failed\n");
 		dev_kfree_skb_any(skb);
 	}
 }
@@ -204,7 +203,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 
 	if (skb && cabq_depth) {
 		if (sc->nvifs > 1) {
-			ath_dbg(common, ATH_DBG_BEACON,
+			ath_dbg(common, BEACON,
 				"Flushing previous cabq traffic\n");
 			ath_draintxq(sc, cabq, false);
 		}
@@ -297,7 +296,7 @@ int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
 		tsfadjust = TU_TO_USEC(intval * avp->av_bslot) / ATH_BCBUF;
 		avp->tsf_adjust = cpu_to_le64(tsfadjust);
 
-		ath_dbg(common, ATH_DBG_BEACON,
+		ath_dbg(common, BEACON,
 			"stagger beacons, bslot %d intval %u tsfadjust %llu\n",
 			avp->av_bslot, intval, (unsigned long long)tsfadjust);
 
@@ -371,15 +370,14 @@ void ath_beacon_tasklet(unsigned long data)
 		sc->beacon.bmisscnt++;
 
 		if (sc->beacon.bmisscnt < BSTUCK_THRESH * sc->nbcnvifs) {
-			ath_dbg(common, ATH_DBG_BSTUCK,
+			ath_dbg(common, BSTUCK,
 				"missed %u consecutive beacons\n",
 				sc->beacon.bmisscnt);
 			ath9k_hw_stop_dma_queue(ah, sc->beacon.beaconq);
 			if (sc->beacon.bmisscnt > 3)
 				ath9k_hw_bstuck_nfcal(ah);
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
-			ath_dbg(common, ATH_DBG_BSTUCK,
-				"beacon is officially stuck\n");
+			ath_dbg(common, BSTUCK, "beacon is officially stuck\n");
 			sc->sc_flags |= SC_OP_TSF_RESET;
 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 		}
@@ -406,7 +404,7 @@ void ath_beacon_tasklet(unsigned long data)
 		slot = (tsftu % (intval * ATH_BCBUF)) / intval;
 		vif = sc->beacon.bslot[slot];
 
-		ath_dbg(common, ATH_DBG_BEACON,
+		ath_dbg(common, BEACON,
 			"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
 			slot, tsf, tsftu / ATH_BCBUF, intval, vif);
 	} else {
@@ -424,7 +422,7 @@ void ath_beacon_tasklet(unsigned long data)
 		}
 
 		if (sc->beacon.bmisscnt != 0) {
-			ath_dbg(common, ATH_DBG_BSTUCK,
+			ath_dbg(common, BSTUCK,
 				"resume beacon xmit after %u misses\n",
 				sc->beacon.bmisscnt);
 			sc->beacon.bmisscnt = 0;
@@ -541,7 +539,7 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 
 	/* No need to configure beacon if we are not associated */
 	if (!common->curaid) {
-		ath_dbg(common, ATH_DBG_BEACON,
+		ath_dbg(common, BEACON,
 			"STA is not yet associated..skipping beacon config\n");
 		return;
 	}
@@ -631,8 +629,8 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	/* TSF out of range threshold fixed at 1 second */
 	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
 
-	ath_dbg(common, ATH_DBG_BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
-	ath_dbg(common, ATH_DBG_BEACON,
+	ath_dbg(common, BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
+	ath_dbg(common, BEACON,
 		"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
 		bs.bs_bmissthreshold, bs.bs_sleepduration,
 		bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
@@ -660,8 +658,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	tsf = roundup(ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE), intval);
 	nexttbtt = tsf + intval;
 
-	ath_dbg(common, ATH_DBG_BEACON,
-		"IBSS nexttbtt %u intval %u (%u)\n",
+	ath_dbg(common, BEACON, "IBSS nexttbtt %u intval %u (%u)\n",
 		nexttbtt, intval, conf->beacon_interval);
 
 	/*
@@ -699,9 +696,8 @@ static bool ath9k_allow_beacon_config(struct ath_softc *sc,
 	    (sc->nbcnvifs > 1) &&
 	    (vif->type == NL80211_IFTYPE_AP) &&
 	    (cur_conf->beacon_interval != bss_conf->beacon_int)) {
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Changing beacon interval of multiple \
-			AP interfaces !\n");
+		ath_dbg(common, CONFIG,
+			"Changing beacon interval of multiple AP interfaces !\n");
 		return false;
 	}
 	/*
@@ -710,7 +706,7 @@ static bool ath9k_allow_beacon_config(struct ath_softc *sc,
 	 */
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
 	    (vif->type != NL80211_IFTYPE_AP)) {
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"STA vif's beacon not allowed on AP mode\n");
 		return false;
 	}
@@ -722,7 +718,7 @@ static bool ath9k_allow_beacon_config(struct ath_softc *sc,
 	    (vif->type == NL80211_IFTYPE_STATION) &&
 	    (sc->sc_flags & SC_OP_BEACONS) &&
 	    !avp->primary_sta_vif) {
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Beacon already configured for a station interface\n");
 		return false;
 	}
@@ -802,8 +798,7 @@ void ath_set_beacon(struct ath_softc *sc)
 		ath_beacon_config_sta(sc, cur_conf);
 		break;
 	default:
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Unsupported beaconing mode\n");
+		ath_dbg(common, CONFIG, "Unsupported beaconing mode\n");
 		return;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index bbb2081..553d279 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -313,8 +313,7 @@ void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
 				AR_STOMP_NONE_WLAN_WGHT);
 		break;
 	default:
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
-				"Invalid Stomptype\n");
+		ath_dbg(ath9k_hw_common(ah), BTCOEX, "Invalid Stomptype\n");
 		break;
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 9953881..172e33d 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -116,7 +116,7 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 		if (h[i].privNF > limit->max) {
 			high_nf_mid = true;
 
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"NFmid[%d] (%d) > MAX (%d), %s\n",
 				i, h[i].privNF, limit->max,
 				(cal->nfcal_interference ?
@@ -199,8 +199,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 		return true;
 
 	if (currCal->calState != CAL_DONE) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Calibration state incorrect, %d\n",
+		ath_dbg(common, CALIBRATE, "Calibration state incorrect, %d\n",
 			currCal->calState);
 		return true;
 	}
@@ -208,8 +207,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 	if (!(ah->supp_cals & currCal->calData->calType))
 		return true;
 
-	ath_dbg(common, ATH_DBG_CALIBRATE,
-		"Resetting Cal %d state for channel %u\n",
+	ath_dbg(common, CALIBRATE, "Resetting Cal %d state for channel %u\n",
 		currCal->calData->calType, conf->channel->center_freq);
 
 	ah->caldata->CalValid &= ~currCal->calData->calType;
@@ -302,7 +300,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	 * noisefloor until the next calibration timer.
 	 */
 	if (j == 10000) {
-		ath_dbg(common, ATH_DBG_ANY,
+		ath_dbg(common, ANY,
 			"Timeout while waiting for nf to load: AR_PHY_AGC_CONTROL=0x%x\n",
 			REG_READ(ah, AR_PHY_AGC_CONTROL));
 		return;
@@ -344,17 +342,17 @@ static void ath9k_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
 		if (!nf[i])
 			continue;
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"NF calibrated [%s] [chain %d] is %d\n",
 			(i >= 3 ? "ext" : "ctl"), i % 3, nf[i]);
 
 		if (nf[i] > ATH9K_NF_TOO_HIGH) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"NF[%d] (%d) > MAX (%d), correcting to MAX\n",
 				i, nf[i], ATH9K_NF_TOO_HIGH);
 			nf[i] = limit->max;
 		} else if (nf[i] < limit->min) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"NF[%d] (%d) < MIN (%d), correcting to NOM\n",
 				i, nf[i], limit->min);
 			nf[i] = limit->nominal;
@@ -373,7 +371,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"NF did not complete in calibration window\n");
 		return false;
 	}
@@ -383,7 +381,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	nf = nfarray[0];
 	if (ath9k_hw_get_nf_thresh(ah, c->band, &nfThresh)
 	    && nf > nfThresh) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"noise floor failed detected; detected %d, threshold %d\n",
 			nf, nfThresh);
 		chan->channelFlags |= CHANNEL_CW_INT;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index e46f751..c435232 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -305,8 +305,7 @@ void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah)
 		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
 		break;
 	default:
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"Invalid chainmask configuration\n");
+		ath_dbg(common, EEPROM, "Invalid chainmask configuration\n");
 		break;
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 61fcab0..4322ac8 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -38,7 +38,7 @@ static bool __ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 
 	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
 		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc, eep_data)) {
-			ath_dbg(common, ATH_DBG_EEPROM,
+			ath_dbg(common, EEPROM,
 				"Unable to read eeprom region\n");
 			return false;
 		}
@@ -62,8 +62,7 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!ath9k_hw_use_flash(ah)) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"Reading from EEPROM, not flash\n");
+		ath_dbg(common, EEPROM, "Reading from EEPROM, not flash\n");
 	}
 
 	if (common->bus_ops->ath_bus_type == ATH_USB)
@@ -204,8 +203,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 			return false;
 		}
 
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"Read Magic = 0x%04X\n", magic);
+		ath_dbg(common, EEPROM, "Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
@@ -227,7 +225,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		}
 	}
 
-	ath_dbg(common, ATH_DBG_EEPROM, "need_swap = %s.\n",
+	ath_dbg(common, EEPROM, "need_swap = %s\n",
 		need_swap ? "True" : "False");
 
 	if (need_swap)
@@ -249,7 +247,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		u32 integer;
 		u16 word;
 
-		ath_dbg(common, ATH_DBG_EEPROM,
+		ath_dbg(common, EEPROM,
 			"EEPROM Endianness is not native.. Changing\n");
 
 		word = swab16(eep->baseEepHeader.length);
@@ -435,11 +433,11 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 				reg32 = get_unaligned_le32(&pdadcValues[4 * j]);
 				REG_WRITE(ah, regOffset, reg32);
 
-				ath_dbg(common, ATH_DBG_EEPROM,
+				ath_dbg(common, EEPROM,
 					"PDADC (%d,%4x): %4.4x %8.8x\n",
 					i, regChainOffset, regOffset,
 					reg32);
-				ath_dbg(common, ATH_DBG_EEPROM,
+				ath_dbg(common, EEPROM,
 					"PDADC: Chain %d | "
 					"PDADC %3d Value %3d | "
 					"PDADC %3d Value %3d | "
@@ -1079,8 +1077,7 @@ static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 
 	u16 spur_val = AR_NO_SPUR;
 
-	ath_dbg(common, ATH_DBG_ANI,
-		"Getting spur idx:%d is2Ghz:%d val:%x\n",
+	ath_dbg(common, ANI, "Getting spur idx:%d is2Ghz:%d val:%x\n",
 		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
@@ -1088,8 +1085,8 @@ static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->config.spurchans[i][is2GHz];
-		ath_dbg(common, ATH_DBG_ANI,
-			"Getting spur val from new loc. %d\n", spur_val);
+		ath_dbg(common, ANI, "Getting spur val from new loc. %d\n",
+			spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
 		spur_val = EEP_MAP4K_SPURCHAN;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 0981c07..f272236 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -41,7 +41,7 @@ static bool __ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 	for (addr = 0; addr < SIZE_EEPROM_AR9287; addr++) {
 		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc,
 					 eep_data)) {
-			ath_dbg(common, ATH_DBG_EEPROM,
+			ath_dbg(common, EEPROM,
 				"Unable to read eeprom region\n");
 			return false;
 		}
@@ -66,8 +66,7 @@ static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!ath9k_hw_use_flash(ah)) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"Reading from EEPROM, not flash\n");
+		ath_dbg(common, EEPROM, "Reading from EEPROM, not flash\n");
 	}
 
 	if (common->bus_ops->ath_bus_type == ATH_USB)
@@ -197,8 +196,7 @@ static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 			return false;
 		}
 
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"Read Magic = 0x%04X\n", magic);
+		ath_dbg(common, EEPROM, "Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
@@ -220,7 +218,7 @@ static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 		}
 	}
 
-	ath_dbg(common, ATH_DBG_EEPROM, "need_swap = %s.\n",
+	ath_dbg(common, EEPROM, "need_swap = %s\n",
 		need_swap ? "True" : "False");
 
 	if (need_swap)
@@ -1041,8 +1039,7 @@ static u16 ath9k_hw_ar9287_get_spur_channel(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	u16 spur_val = AR_NO_SPUR;
 
-	ath_dbg(common, ATH_DBG_ANI,
-		"Getting spur idx:%d is2Ghz:%d val:%x\n",
+	ath_dbg(common, ANI, "Getting spur idx:%d is2Ghz:%d val:%x\n",
 		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
@@ -1050,8 +1047,8 @@ static u16 ath9k_hw_ar9287_get_spur_channel(struct ath_hw *ah,
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->config.spurchans[i][is2GHz];
-		ath_dbg(common, ATH_DBG_ANI,
-			"Getting spur val from new loc. %d\n", spur_val);
+		ath_dbg(common, ANI, "Getting spur val from new loc. %d\n",
+			spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
 		spur_val = EEP_MAP9287_SPURCHAN;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 55a21d3..f57084e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -121,8 +121,7 @@ static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!ath9k_hw_use_flash(ah)) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"Reading from EEPROM, not flash\n");
+		ath_dbg(common, EEPROM, "Reading from EEPROM, not flash\n");
 	}
 
 	if (common->bus_ops->ath_bus_type == ATH_USB)
@@ -279,8 +278,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 	}
 
 	if (!ath9k_hw_use_flash(ah)) {
-		ath_dbg(common, ATH_DBG_EEPROM,
-			"Read Magic = 0x%04X\n", magic);
+		ath_dbg(common, EEPROM, "Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
@@ -303,7 +301,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		}
 	}
 
-	ath_dbg(common, ATH_DBG_EEPROM, "need_swap = %s.\n",
+	ath_dbg(common, EEPROM, "need_swap = %s\n",
 		need_swap ? "True" : "False");
 
 	if (need_swap)
@@ -325,7 +323,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		u32 integer, j;
 		u16 word;
 
-		ath_dbg(common, ATH_DBG_EEPROM,
+		ath_dbg(common, EEPROM,
 			"EEPROM Endianness is not native.. Changing.\n");
 
 		word = swab16(eep->baseEepHeader.length);
@@ -965,15 +963,12 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 				reg32 = get_unaligned_le32(&pdadcValues[4 * j]);
 				REG_WRITE(ah, regOffset, reg32);
 
-				ath_dbg(common, ATH_DBG_EEPROM,
+				ath_dbg(common, EEPROM,
 					"PDADC (%d,%4x): %4.4x %8.8x\n",
 					i, regChainOffset, regOffset,
 					reg32);
-				ath_dbg(common, ATH_DBG_EEPROM,
-					"PDADC: Chain %d | PDADC %3d "
-					"Value %3d | PDADC %3d Value %3d | "
-					"PDADC %3d Value %3d | PDADC %3d "
-					"Value %3d |\n",
+				ath_dbg(common, EEPROM,
+					"PDADC: Chain %d | PDADC %3d Value %3d | PDADC %3d Value %3d | PDADC %3d Value %3d | PDADC %3d Value %3d |\n",
 					i, 4 * j, pdadcValues[4 * j],
 					4 * j + 1, pdadcValues[4 * j + 1],
 					4 * j + 2, pdadcValues[4 * j + 2],
@@ -1278,7 +1273,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
 		break;
 	default:
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_EEPROM,
+		ath_dbg(ath9k_hw_common(ah), EEPROM,
 			"Invalid chainmask configuration\n");
 		break;
 	}
@@ -1396,8 +1391,7 @@ static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 
 	u16 spur_val = AR_NO_SPUR;
 
-	ath_dbg(common, ATH_DBG_ANI,
-		"Getting spur idx:%d is2Ghz:%d val:%x\n",
+	ath_dbg(common, ANI, "Getting spur idx:%d is2Ghz:%d val:%x\n",
 		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
@@ -1405,8 +1399,8 @@ static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 		break;
 	case SPUR_ENABLE_IOCTL:
 		spur_val = ah->config.spurchans[i][is2GHz];
-		ath_dbg(common, ATH_DBG_ANI,
-			"Getting spur val from new loc. %d\n", spur_val);
+		ath_dbg(common, ANI, "Getting spur val from new loc. %d\n",
+			spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
 		spur_val = EEP_DEF_SPURCHAN;
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index e4ae08e..7834d70 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -130,12 +130,12 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 		sc->sc_flags &= ~(SC_OP_BT_PRIORITY_DETECTED | SC_OP_BT_SCAN);
 		/* Detect if colocated bt started scanning */
 		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_SCAN_THRESHOLD) {
-			ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_BTCOEX,
+			ath_dbg(ath9k_hw_common(sc->sc_ah), BTCOEX,
 				"BT scan detected\n");
 			sc->sc_flags |= (SC_OP_BT_SCAN |
 					 SC_OP_BT_PRIORITY_DETECTED);
 		} else if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
-			ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_BTCOEX,
+			ath_dbg(ath9k_hw_common(sc->sc_ah), BTCOEX,
 				"BT priority traffic detected\n");
 			sc->sc_flags |= SC_OP_BT_PRIORITY_DETECTED;
 		}
@@ -230,8 +230,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
 
-	ath_dbg(common, ATH_DBG_BTCOEX,
-		"no stomp timer running\n");
+	ath_dbg(common, BTCOEX, "no stomp timer running\n");
 
 	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&btcoex->btcoex_lock);
@@ -280,8 +279,7 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_hw *ah = sc->sc_ah;
 
-	ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
-		"Starting btcoex timers\n");
+	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Starting btcoex timers\n");
 
 	/* make sure duty cycle timer is also stopped when resuming */
 	if (btcoex->hw_timer_enabled)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 57fe22b..2eadffb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -167,9 +167,9 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	/* TSF out of range threshold fixed at 1 second */
 	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
 
-	ath_dbg(common, ATH_DBG_CONFIG, "intval: %u tsf: %llu tsftu: %u\n",
+	ath_dbg(common, CONFIG, "intval: %u tsf: %llu tsftu: %u\n",
 		intval, tsf, tsftu);
-	ath_dbg(common, ATH_DBG_CONFIG,
+	ath_dbg(common, CONFIG,
 		"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
 		bs.bs_bmissthreshold, bs.bs_sleepduration,
 		bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
@@ -224,9 +224,8 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 	if (priv->op_flags & OP_ENABLE_BEACON)
 		imask |= ATH9K_INT_SWBA;
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"AP Beacon config, intval: %d, nexttbtt: %u, resp_time: %d "
-		"imask: 0x%x\n",
+	ath_dbg(common, CONFIG,
+		"AP Beacon config, intval: %d, nexttbtt: %u, resp_time: %d imask: 0x%x\n",
 		bss_conf->beacon_interval, nexttbtt,
 		priv->ah->config.sw_beacon_response_time, imask);
 
@@ -273,9 +272,8 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 	if (priv->op_flags & OP_ENABLE_BEACON)
 		imask |= ATH9K_INT_SWBA;
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"IBSS Beacon config, intval: %d, nexttbtt: %u, "
-		"resp_time: %d, imask: 0x%x\n",
+	ath_dbg(common, CONFIG,
+		"IBSS Beacon config, intval: %d, nexttbtt: %u, resp_time: %d, imask: 0x%x\n",
 		bss_conf->beacon_interval, nexttbtt,
 		priv->ah->config.sw_beacon_response_time, imask);
 
@@ -323,7 +321,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 
 		tx_slot = ath9k_htc_tx_get_slot(priv);
 		if (tx_slot < 0) {
-			ath_dbg(common, ATH_DBG_XMIT, "No free CAB slot\n");
+			ath_dbg(common, XMIT, "No free CAB slot\n");
 			dev_kfree_skb_any(skb);
 			goto next;
 		}
@@ -333,8 +331,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 			ath9k_htc_tx_clear_slot(priv, tx_slot);
 			dev_kfree_skb_any(skb);
 
-			ath_dbg(common, ATH_DBG_XMIT,
-				"Failed to send CAB frame\n");
+			ath_dbg(common, XMIT, "Failed to send CAB frame\n");
 		} else {
 			spin_lock_bh(&priv->tx.tx_lock);
 			priv->tx.queued_cnt++;
@@ -409,7 +406,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	ret = htc_send(priv->htc, beacon);
 	if (ret != 0) {
 		if (ret == -ENOMEM) {
-			ath_dbg(common, ATH_DBG_BSTUCK,
+			ath_dbg(common, BSTUCK,
 				"Failed to send beacon, no free TX buffer\n");
 		}
 		dev_kfree_skb_any(beacon);
@@ -434,7 +431,7 @@ static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv,
 	slot = ((tsftu % intval) * ATH9K_HTC_MAX_BCN_VIF) / intval;
 	slot = ATH9K_HTC_MAX_BCN_VIF - slot - 1;
 
-	ath_dbg(common, ATH_DBG_BEACON,
+	ath_dbg(common, BEACON,
 		"Choose slot: %d, tsf: %llu, tsftu: %u, intval: %u\n",
 		slot, tsf, tsftu, intval);
 
@@ -450,8 +447,7 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv,
 	if (swba->beacon_pending != 0) {
 		priv->cur_beacon_conf.bmiss_cnt++;
 		if (priv->cur_beacon_conf.bmiss_cnt > BSTUCK_THRESHOLD) {
-			ath_dbg(common, ATH_DBG_BSTUCK,
-				"Beacon stuck, HW reset\n");
+			ath_dbg(common, BSTUCK, "Beacon stuck, HW reset\n");
 			ieee80211_queue_work(priv->hw,
 					     &priv->fatal_work);
 		}
@@ -459,7 +455,7 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv,
 	}
 
 	if (priv->cur_beacon_conf.bmiss_cnt) {
-		ath_dbg(common, ATH_DBG_BSTUCK,
+		ath_dbg(common, BSTUCK,
 			"Resuming beacon xmit after %u misses\n",
 			priv->cur_beacon_conf.bmiss_cnt);
 		priv->cur_beacon_conf.bmiss_cnt = 0;
@@ -495,8 +491,8 @@ void ath9k_htc_assign_bslot(struct ath9k_htc_priv *priv,
 	priv->cur_beacon_conf.bslot[avp->bslot] = vif;
 	spin_unlock_bh(&priv->beacon_lock);
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Added interface at beacon slot: %d\n", avp->bslot);
+	ath_dbg(common, CONFIG, "Added interface at beacon slot: %d\n",
+		avp->bslot);
 }
 
 void ath9k_htc_remove_bslot(struct ath9k_htc_priv *priv,
@@ -509,8 +505,8 @@ void ath9k_htc_remove_bslot(struct ath9k_htc_priv *priv,
 	priv->cur_beacon_conf.bslot[avp->bslot] = NULL;
 	spin_unlock_bh(&priv->beacon_lock);
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Removed interface at beacon slot: %d\n", avp->bslot);
+	ath_dbg(common, CONFIG, "Removed interface at beacon slot: %d\n",
+		avp->bslot);
 }
 
 /*
@@ -536,8 +532,7 @@ void ath9k_htc_set_tsfadjust(struct ath9k_htc_priv *priv,
 	tsfadjust = cur_conf->beacon_interval * avp->bslot / ATH9K_HTC_MAX_BCN_VIF;
 	avp->tsfadjust = cpu_to_le64(TU_TO_USEC(tsfadjust));
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"tsfadjust is: %llu for bslot: %d\n",
+	ath_dbg(common, CONFIG, "tsfadjust is: %llu for bslot: %d\n",
 		(unsigned long long)tsfadjust, avp->bslot);
 }
 
@@ -568,7 +563,7 @@ static bool ath9k_htc_check_beacon_config(struct ath9k_htc_priv *priv,
 	    (priv->num_ap_vif > 1) &&
 	    (vif->type == NL80211_IFTYPE_AP) &&
 	    (cur_conf->beacon_interval != bss_conf->beacon_int)) {
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Changing beacon interval of multiple AP interfaces !\n");
 		return false;
 	}
@@ -579,7 +574,7 @@ static bool ath9k_htc_check_beacon_config(struct ath9k_htc_priv *priv,
 	 */
 	if (priv->num_ap_vif &&
 	    (vif->type != NL80211_IFTYPE_AP)) {
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"HW in AP mode, cannot set STA beacon parameters\n");
 		return false;
 	}
@@ -597,7 +592,7 @@ static bool ath9k_htc_check_beacon_config(struct ath9k_htc_priv *priv,
 							   &beacon_configured);
 
 		if (beacon_configured) {
-			ath_dbg(common, ATH_DBG_CONFIG,
+			ath_dbg(common, CONFIG,
 				"Beacon already configured for a station interface\n");
 			return false;
 		}
@@ -637,8 +632,7 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 		ath9k_htc_beacon_config_ap(priv, cur_conf);
 		break;
 	default:
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Unsupported beaconing mode\n");
+		ath_dbg(common, CONFIG, "Unsupported beaconing mode\n");
 		return;
 	}
 }
@@ -659,8 +653,7 @@ void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv)
 		ath9k_htc_beacon_config_ap(priv, cur_conf);
 		break;
 	default:
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Unsupported beaconing mode\n");
+		ath_dbg(common, CONFIG, "Unsupported beaconing mode\n");
 		return;
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index ce606b6..b7c0300 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -36,12 +36,12 @@ static void ath_detect_bt_priority(struct ath9k_htc_priv *priv)
 		priv->op_flags &= ~(OP_BT_PRIORITY_DETECTED | OP_BT_SCAN);
 		/* Detect if colocated bt started scanning */
 		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_SCAN_THRESHOLD) {
-			ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+			ath_dbg(ath9k_hw_common(ah), BTCOEX,
 				"BT scan detected\n");
 			priv->op_flags |= (OP_BT_SCAN |
 					 OP_BT_PRIORITY_DETECTED);
 		} else if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
-			ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+			ath_dbg(ath9k_hw_common(ah), BTCOEX,
 				"BT priority traffic detected\n");
 			priv->op_flags |= OP_BT_PRIORITY_DETECTED;
 		}
@@ -102,8 +102,7 @@ static void ath_btcoex_duty_cycle_work(struct work_struct *work)
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool is_btscan = priv->op_flags & OP_BT_SCAN;
 
-	ath_dbg(common, ATH_DBG_BTCOEX,
-		"time slice work for bt and wlan\n");
+	ath_dbg(common, BTCOEX, "time slice work for bt and wlan\n");
 
 	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW || is_btscan)
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
@@ -134,7 +133,7 @@ void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
 	struct ath_btcoex *btcoex = &priv->btcoex;
 	struct ath_hw *ah = priv->ah;
 
-	ath_dbg(ath9k_hw_common(ah), ATH_DBG_BTCOEX, "Starting btcoex work\n");
+	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Starting btcoex work\n");
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 966661c..6cbad73 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -299,8 +299,7 @@ static unsigned int ath9k_regread(void *hw_priv, u32 reg_offset)
 			  (u8 *) &val, sizeof(val),
 			  100);
 	if (unlikely(r)) {
-		ath_dbg(common, ATH_DBG_WMI,
-			"REGISTER READ FAILED: (0x%04x, %d)\n",
+		ath_dbg(common, WMI, "REGISTER READ FAILED: (0x%04x, %d)\n",
 			reg_offset, r);
 		return -EIO;
 	}
@@ -327,7 +326,7 @@ static void ath9k_multi_regread(void *hw_priv, u32 *addr,
 			   (u8 *)tmpval, sizeof(u32) * count,
 			   100);
 	if (unlikely(ret)) {
-		ath_dbg(common, ATH_DBG_WMI,
+		ath_dbg(common, WMI,
 			"Multiple REGISTER READ FAILED (count: %d)\n", count);
 	}
 
@@ -352,8 +351,7 @@ static void ath9k_regwrite_single(void *hw_priv, u32 val, u32 reg_offset)
 			  (u8 *) &val, sizeof(val),
 			  100);
 	if (unlikely(r)) {
-		ath_dbg(common, ATH_DBG_WMI,
-			"REGISTER WRITE FAILED:(0x%04x, %d)\n",
+		ath_dbg(common, WMI, "REGISTER WRITE FAILED:(0x%04x, %d)\n",
 			reg_offset, r);
 	}
 }
@@ -384,7 +382,7 @@ static void ath9k_regwrite_buffer(void *hw_priv, u32 val, u32 reg_offset)
 			  (u8 *) &rsp_status, sizeof(rsp_status),
 			  100);
 		if (unlikely(r)) {
-			ath_dbg(common, ATH_DBG_WMI,
+			ath_dbg(common, WMI,
 				"REGISTER WRITE FAILED, multi len: %d\n",
 				priv->wmi->multi_write_idx);
 		}
@@ -434,7 +432,7 @@ static void ath9k_regwrite_flush(void *hw_priv)
 			  (u8 *) &rsp_status, sizeof(rsp_status),
 			  100);
 		if (unlikely(r)) {
-			ath_dbg(common, ATH_DBG_WMI,
+			ath_dbg(common, WMI,
 				"REGISTER WRITE FAILED, multi len: %d\n",
 				priv->wmi->multi_write_idx);
 		}
@@ -512,8 +510,7 @@ static void setup_ht_cap(struct ath9k_htc_priv *priv,
 	tx_streams = ath9k_cmn_count_streams(priv->ah->txchainmask, 2);
 	rx_streams = ath9k_cmn_count_streams(priv->ah->rxchainmask, 2);
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"TX streams %d, RX streams: %d\n",
+	ath_dbg(common, CONFIG, "TX streams %d, RX streams: %d\n",
 		tx_streams, rx_streams);
 
 	if (tx_streams != rx_streams) {
@@ -876,9 +873,8 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 		goto err_world;
 	}
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"WMI:%d, BCN:%d, CAB:%d, UAPSD:%d, MGMT:%d, "
-		"BE:%d, BK:%d, VI:%d, VO:%d\n",
+	ath_dbg(common, CONFIG,
+		"WMI:%d, BCN:%d, CAB:%d, UAPSD:%d, MGMT:%d, BE:%d, BK:%d, VI:%d, VO:%d\n",
 		priv->wmi_cmd_ep,
 		priv->beacon_ep,
 		priv->cab_ep,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f8ce4ea..539f445 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -266,7 +266,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 
 	ath9k_wmi_event_drain(priv);
 
-	ath_dbg(common, ATH_DBG_CONFIG,
+	ath_dbg(common, CONFIG,
 		"(%u MHz) -> (%u MHz), HT: %d, HT40: %d fastcc: %d\n",
 		priv->ah->curchan->channel,
 		channel->center_freq, conf_is_ht(conf), conf_is_ht40(conf),
@@ -415,7 +415,7 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 	priv->vif_sta_pos[priv->mon_vif_idx] = sta_idx;
 	priv->ah->is_monitoring = true;
 
-	ath_dbg(common, ATH_DBG_CONFIG,
+	ath_dbg(common, CONFIG,
 		"Attached a monitor interface at idx: %d, sta idx: %d\n",
 		priv->mon_vif_idx, sta_idx);
 
@@ -427,7 +427,7 @@ err_sta:
 	 */
 	__ath9k_htc_remove_monitor_interface(priv);
 err_vif:
-	ath_dbg(common, ATH_DBG_FATAL, "Unable to attach a monitor interface\n");
+	ath_dbg(common, FATAL, "Unable to attach a monitor interface\n");
 
 	return ret;
 }
@@ -452,7 +452,7 @@ static int ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 	priv->nstations--;
 	priv->ah->is_monitoring = false;
 
-	ath_dbg(common, ATH_DBG_CONFIG,
+	ath_dbg(common, CONFIG,
 		"Removed a monitor interface at idx: %d, sta idx: %d\n",
 		priv->mon_vif_idx, sta_idx);
 
@@ -512,11 +512,11 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 	}
 
 	if (sta) {
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Added a station entry for: %pM (idx: %d)\n",
 			sta->addr, tsta.sta_index);
 	} else {
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Added a station entry for VIF %d (idx: %d)\n",
 			avp->index, tsta.sta_index);
 	}
@@ -556,11 +556,11 @@ static int ath9k_htc_remove_station(struct ath9k_htc_priv *priv,
 	}
 
 	if (sta) {
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Removed a station entry for: %pM (idx: %d)\n",
 			sta->addr, sta_idx);
 	} else {
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Removed a station entry for VIF %d (idx: %d)\n",
 			avp->index, sta_idx);
 	}
@@ -665,7 +665,7 @@ static void ath9k_htc_init_rate(struct ath9k_htc_priv *priv,
 	ath9k_htc_setup_rate(priv, sta, &trate);
 	ret = ath9k_htc_send_rate_cmd(priv, &trate);
 	if (!ret)
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Updated target sta: %pM, rate caps: 0x%X\n",
 			sta->addr, be32_to_cpu(trate.capflags));
 }
@@ -692,7 +692,7 @@ static void ath9k_htc_update_rate(struct ath9k_htc_priv *priv,
 
 	ret = ath9k_htc_send_rate_cmd(priv, &trate);
 	if (!ret)
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Updated target sta: %pM, rate caps: 0x%X\n",
 			bss_conf->bssid, be32_to_cpu(trate.capflags));
 }
@@ -721,11 +721,11 @@ static int ath9k_htc_tx_aggr_oper(struct ath9k_htc_priv *priv,
 
 	WMI_CMD_BUF(WMI_TX_AGGR_ENABLE_CMDID, &aggr);
 	if (ret)
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Unable to %s TX aggregation for (%pM, %d)\n",
 			(aggr.aggr_enable) ? "start" : "stop", sta->addr, tid);
 	else
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"%s TX aggregation for (%pM, %d)\n",
 			(aggr.aggr_enable) ? "Starting" : "Stopping",
 			sta->addr, tid);
@@ -784,7 +784,7 @@ void ath9k_htc_ani_work(struct work_struct *work)
 	/* Long calibration runs independently of short calibration. */
 	if ((timestamp - common->ani.longcal_timer) >= ATH_LONG_CALINTERVAL) {
 		longcal = true;
-		ath_dbg(common, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
+		ath_dbg(common, ANI, "longcal @%lu\n", jiffies);
 		common->ani.longcal_timer = timestamp;
 	}
 
@@ -793,8 +793,7 @@ void ath9k_htc_ani_work(struct work_struct *work)
 		if ((timestamp - common->ani.shortcal_timer) >=
 		    short_cal_interval) {
 			shortcal = true;
-			ath_dbg(common, ATH_DBG_ANI,
-				"shortcal @%lu\n", jiffies);
+			ath_dbg(common, ANI, "shortcal @%lu\n", jiffies);
 			common->ani.shortcal_timer = timestamp;
 			common->ani.resetcal_timer = timestamp;
 		}
@@ -866,7 +865,7 @@ static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	padsize = padpos & 3;
 	if (padsize && skb->len > padpos) {
 		if (skb_headroom(skb) < padsize) {
-			ath_dbg(common, ATH_DBG_XMIT, "No room for padding\n");
+			ath_dbg(common, XMIT, "No room for padding\n");
 			goto fail_tx;
 		}
 		skb_push(skb, padsize);
@@ -875,13 +874,13 @@ static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	slot = ath9k_htc_tx_get_slot(priv);
 	if (slot < 0) {
-		ath_dbg(common, ATH_DBG_XMIT, "No free TX slot\n");
+		ath_dbg(common, XMIT, "No free TX slot\n");
 		goto fail_tx;
 	}
 
 	ret = ath9k_htc_tx_start(priv, skb, slot, false);
 	if (ret != 0) {
-		ath_dbg(common, ATH_DBG_XMIT, "Tx failed\n");
+		ath_dbg(common, XMIT, "Tx failed\n");
 		goto clear_slot;
 	}
 
@@ -909,7 +908,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 
-	ath_dbg(common, ATH_DBG_CONFIG,
+	ath_dbg(common, CONFIG,
 		"Starting driver with initial channel: %d MHz\n",
 		curchan->center_freq);
 
@@ -943,7 +942,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 
 	ret = ath9k_htc_update_cap_target(priv, 0);
 	if (ret)
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Failed to update capability in target\n");
 
 	priv->op_flags &= ~OP_INVALID;
@@ -980,7 +979,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	mutex_lock(&priv->mutex);
 
 	if (priv->op_flags & OP_INVALID) {
-		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
+		ath_dbg(common, ANY, "Device not present\n");
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -1027,7 +1026,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 
 	priv->op_flags |= OP_INVALID;
 
-	ath_dbg(common, ATH_DBG_CONFIG, "Driver halt\n");
+	ath_dbg(common, CONFIG, "Driver halt\n");
 	mutex_unlock(&priv->mutex);
 }
 
@@ -1120,8 +1119,8 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		ath9k_htc_start_ani(priv);
 	}
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
+	ath_dbg(common, CONFIG, "Attach a VIF of type: %d at idx: %d\n",
+		vif->type, avp->index);
 
 out:
 	ath9k_htc_ps_restore(priv);
@@ -1177,7 +1176,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 			ath9k_htc_stop_ani(priv);
 	}
 
-	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface at idx: %d\n", avp->index);
+	ath_dbg(common, CONFIG, "Detach Interface at idx: %d\n", avp->index);
 
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
@@ -1202,8 +1201,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		mutex_unlock(&priv->htc_pm_lock);
 
 		if (enable_radio) {
-			ath_dbg(common, ATH_DBG_CONFIG,
-				"not-idle: enabling radio\n");
+			ath_dbg(common, CONFIG, "not-idle: enabling radio\n");
 			ath9k_htc_setpower(priv, ATH9K_PM_AWAKE);
 			ath9k_htc_radio_enable(hw);
 		}
@@ -1225,7 +1223,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
 
-		ath_dbg(common, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
+		ath_dbg(common, CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
 		ath9k_cmn_update_ichannel(&priv->ah->channels[pos],
@@ -1265,8 +1263,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		}
 		mutex_unlock(&priv->htc_pm_lock);
 
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"idle: disabling radio\n");
+		ath_dbg(common, CONFIG, "idle: disabling radio\n");
 		ath9k_htc_radio_disable(hw);
 	}
 
@@ -1298,7 +1295,7 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 	*total_flags &= SUPPORTED_FILTERS;
 
 	if (priv->op_flags & OP_INVALID) {
-		ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_ANY,
+		ath_dbg(ath9k_hw_common(priv->ah), ANY,
 			"Unable to configure filter on invalid state\n");
 		mutex_unlock(&priv->mutex);
 		return;
@@ -1309,8 +1306,8 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 	rfilt = ath9k_htc_calcrxfilter(priv);
 	ath9k_hw_setrxfilter(priv->ah, rfilt);
 
-	ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_CONFIG,
-		"Set HW RX filter: 0x%x\n", rfilt);
+	ath_dbg(ath9k_hw_common(priv->ah), CONFIG, "Set HW RX filter: 0x%x\n",
+		rfilt);
 
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
@@ -1377,7 +1374,7 @@ static int ath9k_htc_conf_tx(struct ieee80211_hw *hw,
 
 	qnum = get_hw_qnum(queue, priv->hwq_map);
 
-	ath_dbg(common, ATH_DBG_CONFIG,
+	ath_dbg(common, CONFIG,
 		"Configure tx [queue/hwq] [%d/%d],  aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
 		queue, qnum, params->aifs, params->cw_min,
 		params->cw_max, params->txop);
@@ -1412,7 +1409,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 		return -ENOSPC;
 
 	mutex_lock(&priv->mutex);
-	ath_dbg(common, ATH_DBG_CONFIG, "Set HW Key\n");
+	ath_dbg(common, CONFIG, "Set HW Key\n");
 	ath9k_htc_ps_wakeup(priv);
 
 	switch (cmd) {
@@ -1448,8 +1445,7 @@ static void ath9k_htc_set_bssid(struct ath9k_htc_priv *priv)
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 
 	ath9k_hw_write_associd(priv->ah);
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"BSSID: %pM aid: 0x%x\n",
+	ath_dbg(common, CONFIG, "BSSID: %pM aid: 0x%x\n",
 		common->curbssid, common->curaid);
 }
 
@@ -1487,7 +1483,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	ath9k_htc_ps_wakeup(priv);
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
+		ath_dbg(common, CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
 
 		bss_conf->assoc ?
@@ -1512,8 +1508,8 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon) {
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Beacon enabled for BSS: %pM\n", bss_conf->bssid);
+		ath_dbg(common, CONFIG, "Beacon enabled for BSS: %pM\n",
+			bss_conf->bssid);
 		ath9k_htc_set_tsfadjust(priv, vif);
 		priv->op_flags |= OP_ENABLE_BEACON;
 		ath9k_htc_beacon_config(priv, vif);
@@ -1525,7 +1521,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		 * AP/IBSS interfaces.
 		 */
 		if ((priv->num_ap_vif <= 1) || priv->num_ibss_vif) {
-			ath_dbg(common, ATH_DBG_CONFIG,
+			ath_dbg(common, CONFIG,
 				"Beacon disabled for BSS: %pM\n",
 				bss_conf->bssid);
 			priv->op_flags &= ~OP_ENABLE_BEACON;
@@ -1543,7 +1539,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		    (vif->type == NL80211_IFTYPE_AP)) {
 			priv->op_flags |= OP_TSF_RESET;
 		}
-		ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, CONFIG,
 			"Beacon interval changed for BSS: %pM\n",
 			bss_conf->bssid);
 		ath9k_htc_beacon_config(priv, vif);
@@ -1733,8 +1729,7 @@ static int ath9k_htc_set_bitrate_mask(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Set bitrate masks: 0x%x, 0x%x\n",
+	ath_dbg(common, CONFIG, "Set bitrate masks: 0x%x, 0x%x\n",
 		mask->control[IEEE80211_BAND_2GHZ].legacy,
 		mask->control[IEEE80211_BAND_5GHZ].legacy);
 out:
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 2d81c70..3e40a64 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -355,7 +355,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		vif_idx = avp->index;
 	} else {
 		if (!priv->ah->is_monitoring) {
-			ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
+			ath_dbg(ath9k_hw_common(priv->ah), XMIT,
 				"VIF is null, but no monitor interface !\n");
 			return -EINVAL;
 		}
@@ -620,8 +620,7 @@ static struct sk_buff* ath9k_htc_tx_get_packet(struct ath9k_htc_priv *priv,
 	}
 	spin_unlock_irqrestore(&epid_queue->lock, flags);
 
-	ath_dbg(common, ATH_DBG_XMIT,
-		"No matching packet for cookie: %d, epid: %d\n",
+	ath_dbg(common, XMIT, "No matching packet for cookie: %d, epid: %d\n",
 		txs->cookie, epid);
 
 	return NULL;
@@ -705,8 +704,7 @@ static inline bool check_packet(struct ath9k_htc_priv *priv, struct sk_buff *skb
 	if (time_after(jiffies,
 		       tx_ctl->timestamp +
 		       msecs_to_jiffies(ATH9K_HTC_TX_TIMEOUT_INTERVAL))) {
-		ath_dbg(common, ATH_DBG_XMIT,
-			"Dropping a packet due to TX timeout\n");
+		ath_dbg(common, XMIT, "Dropping a packet due to TX timeout\n");
 		return true;
 	}
 
@@ -753,7 +751,7 @@ void ath9k_htc_tx_cleanup_timer(unsigned long data)
 
 		skb = ath9k_htc_tx_get_packet(priv, &event->txs);
 		if (skb) {
-			ath_dbg(common, ATH_DBG_XMIT,
+			ath_dbg(common, XMIT,
 				"Found packet for cookie: %d, epid: %d\n",
 				event->txs.cookie,
 				MS(event->txs.ts_rate, ATH9K_HTC_TXSTAT_EPID));
@@ -1167,8 +1165,7 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	spin_unlock(&priv->rx.rxbuflock);
 
 	if (rxbuf == NULL) {
-		ath_dbg(common, ATH_DBG_ANY,
-			"No free RX buffer\n");
+		ath_dbg(common, ANY, "No free RX buffer\n");
 		goto err;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7f8fc65..d87e4e7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -133,7 +133,7 @@ bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 		udelay(AH_TIME_QUANTUM);
 	}
 
-	ath_dbg(ath9k_hw_common(ah), ATH_DBG_ANY,
+	ath_dbg(ath9k_hw_common(ah), ANY,
 		"timeout (%d us) on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
 		timeout, reg, REG_READ(ah, reg), mask, val);
 
@@ -491,8 +491,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	if (ecode != 0)
 		return ecode;
 
-	ath_dbg(ath9k_hw_common(ah), ATH_DBG_CONFIG,
-		"Eeprom VER: %d, REV: %d\n",
+	ath_dbg(ath9k_hw_common(ah), CONFIG, "Eeprom VER: %d, REV: %d\n",
 		ah->eep_ops->get_eeprom_ver(ah),
 		ah->eep_ops->get_eeprom_rev(ah));
 
@@ -567,7 +566,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		}
 	}
 
-	ath_dbg(common, ATH_DBG_RESET, "serialize_regmode is %d\n",
+	ath_dbg(common, RESET, "serialize_regmode is %d\n",
 		ah->config.serialize_regmode);
 
 	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
@@ -958,8 +957,8 @@ static void ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
 static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 {
 	if (tu > 0xFFFF) {
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_XMIT,
-			"bad global tx timeout %u\n", tu);
+		ath_dbg(ath9k_hw_common(ah), XMIT, "bad global tx timeout %u\n",
+			tu);
 		ah->globaltxtimeout = (u32) -1;
 		return false;
 	} else {
@@ -980,7 +979,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	int rx_lat = 0, tx_lat = 0, eifs = 0;
 	u32 reg;
 
-	ath_dbg(ath9k_hw_common(ah), ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
+	ath_dbg(ath9k_hw_common(ah), RESET, "ah->misc_mode 0x%x\n",
 		ah->misc_mode);
 
 	if (!chan)
@@ -1275,7 +1274,7 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 		    (npend || type == ATH9K_RESET_COLD)) {
 			int reset_err = 0;
 
-			ath_dbg(ath9k_hw_common(ah), ATH_DBG_RESET,
+			ath_dbg(ath9k_hw_common(ah), RESET,
 				"reset MAC via external reset\n");
 
 			reset_err = ah->external_reset();
@@ -1298,8 +1297,7 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 
 	REG_WRITE(ah, AR_RTC_RC, 0);
 	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0, AH_WAIT_TIMEOUT)) {
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_RESET,
-			"RTC stuck in MAC reset\n");
+		ath_dbg(ath9k_hw_common(ah), RESET, "RTC stuck in MAC reset\n");
 		return false;
 	}
 
@@ -1344,8 +1342,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 			   AR_RTC_STATUS_M,
 			   AR_RTC_STATUS_ON,
 			   AH_WAIT_TIMEOUT)) {
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_RESET,
-			"RTC not waking up\n");
+		ath_dbg(ath9k_hw_common(ah), RESET, "RTC not waking up\n");
 		return false;
 	}
 
@@ -1418,7 +1415,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
 		if (ath9k_hw_numtxpending(ah, qnum)) {
-			ath_dbg(common, ATH_DBG_QUEUE,
+			ath_dbg(common, QUEUE,
 				"Transmit frames pending on queue %d\n", qnum);
 			return false;
 		}
@@ -1536,7 +1533,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		if (mci_hw->bt_state == MCI_BT_CAL_START) {
 			u32 payload[4] = {0, 0, 0, 0};
 
-			ath_dbg(common, ATH_DBG_MCI, "MCI stop rx for BT CAL");
+			ath_dbg(common, MCI, "MCI stop rx for BT CAL\n");
 
 			mci_hw->bt_state = MCI_BT_CAL;
 
@@ -1548,23 +1545,22 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 			ar9003_mci_disable_interrupt(ah);
 
-			ath_dbg(common, ATH_DBG_MCI, "send WLAN_CAL_GRANT");
+			ath_dbg(common, MCI, "send WLAN_CAL_GRANT\n");
 			MCI_GPM_SET_CAL_TYPE(payload, MCI_GPM_WLAN_CAL_GRANT);
 			ar9003_mci_send_message(ah, MCI_GPM, 0, payload,
 						16, true, false);
 
-			ath_dbg(common, ATH_DBG_MCI, "\nMCI BT is calibrating");
+			ath_dbg(common, MCI, "\nMCI BT is calibrating\n");
 
 			/* Wait BT calibration to be completed for 25ms */
 
 			if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_DONE,
 								  0, 25000))
-				ath_dbg(common, ATH_DBG_MCI,
+				ath_dbg(common, MCI,
 					"MCI got BT_CAL_DONE\n");
 			else
-				ath_dbg(common, ATH_DBG_MCI,
-					"MCI ### BT cal takes to long, force"
-					"bt_state to be bt_awake\n");
+				ath_dbg(common, MCI,
+					"MCI ### BT cal takes to long, force bt_state to be bt_awake\n");
 			mci_hw->bt_state = MCI_BT_AWAKE;
 			/* MCI FIX: enable mci interrupt here */
 			ar9003_mci_enable_interrupt(ah);
@@ -1825,14 +1821,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 				 * message exchanges again and recal.
 				 */
 
-				ath_dbg(common, ATH_DBG_MCI, "MCI BT wakes up"
-					"during WLAN calibration\n");
+				ath_dbg(common, MCI,
+					"MCI BT wakes up during WLAN calibration\n");
 
 				REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_RAW,
 					  AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET |
 					  AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE);
-				ath_dbg(common, ATH_DBG_MCI, "MCI send"
-					"REMOTE_RESET\n");
+				ath_dbg(common, MCI, "MCI send REMOTE_RESET\n");
 				ar9003_mci_remote_reset(ah, true);
 				ar9003_mci_send_sys_waking(ah, true);
 				udelay(1);
@@ -1841,7 +1836,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 				mci_hw->bt_state = MCI_BT_AWAKE;
 
-				ath_dbg(common, ATH_DBG_MCI, "MCI re-cal\n");
+				ath_dbg(common, MCI, "MCI re-cal\n");
 
 				if (caldata) {
 					caldata->done_txiqcal_once = false;
@@ -1871,14 +1866,14 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		u32 mask;
 		mask = REG_READ(ah, AR_CFG);
 		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
-			ath_dbg(common, ATH_DBG_RESET,
-				"CFG Byte Swap Set 0x%x\n", mask);
+			ath_dbg(common, RESET, "CFG Byte Swap Set 0x%x\n",
+				mask);
 		} else {
 			mask =
 				INIT_CONFIG_STATUS | AR_CFG_SWRB | AR_CFG_SWTB;
 			REG_WRITE(ah, AR_CFG, mask);
-			ath_dbg(common, ATH_DBG_RESET,
-				"Setting CFG 0x%x\n", REG_READ(ah, AR_CFG));
+			ath_dbg(common, RESET, "Setting CFG 0x%x\n",
+				REG_READ(ah, AR_CFG));
 		}
 	} else {
 		if (common->bus_ops->ath_bus_type == ATH_USB) {
@@ -2090,7 +2085,7 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	if (ah->power_mode == mode)
 		return status;
 
-	ath_dbg(common, ATH_DBG_RESET, "%s -> %s\n",
+	ath_dbg(common, RESET, "%s -> %s\n",
 		modes[ah->power_mode], modes[mode]);
 
 	switch (mode) {
@@ -2107,8 +2102,8 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 			if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) &&
 				(mci->bt_state != MCI_BT_SLEEP) &&
 				!mci->halted_bt_gpm) {
-				ath_dbg(common, ATH_DBG_MCI, "MCI halt BT GPM"
-						"(full_sleep)");
+				ath_dbg(common, MCI,
+					"MCI halt BT GPM (full_sleep)\n");
 				ar9003_mci_send_coex_halt_bt_gpm(ah,
 								 true, true);
 			}
@@ -2174,9 +2169,8 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
 		break;
 	default:
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_BEACON,
-			"%s: unsupported opmode: %d\n",
-			__func__, ah->opmode);
+		ath_dbg(ath9k_hw_common(ah), BEACON,
+			"%s: unsupported opmode: %d\n", __func__, ah->opmode);
 		return;
 		break;
 	}
@@ -2227,10 +2221,10 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	else
 		nextTbtt = bs->bs_nexttbtt;
 
-	ath_dbg(common, ATH_DBG_BEACON, "next DTIM %d\n", bs->bs_nextdtim);
-	ath_dbg(common, ATH_DBG_BEACON, "next beacon %d\n", nextTbtt);
-	ath_dbg(common, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
-	ath_dbg(common, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
+	ath_dbg(common, BEACON, "next DTIM %d\n", bs->bs_nextdtim);
+	ath_dbg(common, BEACON, "next beacon %d\n", nextTbtt);
+	ath_dbg(common, BEACON, "beacon period %d\n", beaconintval);
+	ath_dbg(common, BEACON, "DTIM period %d\n", dtimperiod);
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
@@ -2298,8 +2292,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			regulatory->current_rd += 5;
 		else if (regulatory->current_rd == 0x41)
 			regulatory->current_rd = 0x43;
-		ath_dbg(common, ATH_DBG_REGULATORY,
-			"regdomain mapped to 0x%x\n", regulatory->current_rd);
+		ath_dbg(common, REGULATORY, "regdomain mapped to 0x%x\n",
+			regulatory->current_rd);
 	}
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_OP_MODE);
@@ -2823,7 +2817,7 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah)
 {
 	if (!ath9k_hw_wait(ah, AR_SLP32_MODE, AR_SLP32_TSF_WRITE_STATUS, 0,
 			   AH_TSF_WRITE_TIMEOUT))
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_RESET,
+		ath_dbg(ath9k_hw_common(ah), RESET,
 			"AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
 
 	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
@@ -2948,7 +2942,7 @@ void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 
 	timer_next = tsf + trig_timeout;
 
-	ath_dbg(ath9k_hw_common(ah), ATH_DBG_HWTIMER,
+	ath_dbg(ath9k_hw_common(ah), HWTIMER,
 		"current tsf %x period %x timer_next %x\n",
 		tsf, timer_period, timer_next);
 
@@ -3037,8 +3031,8 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		index = rightmost_index(timer_table, &thresh_mask);
 		timer = timer_table->timers[index];
 		BUG_ON(!timer);
-		ath_dbg(common, ATH_DBG_HWTIMER,
-			"TSF overflow for Gen timer %d\n", index);
+		ath_dbg(common, HWTIMER, "TSF overflow for Gen timer %d\n",
+			index);
 		timer->overflow(timer->arg);
 	}
 
@@ -3046,7 +3040,7 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		index = rightmost_index(timer_table, &trigger_mask);
 		timer = timer_table->timers[index];
 		BUG_ON(!timer);
-		ath_dbg(common, ATH_DBG_HWTIMER,
+		ath_dbg(common, HWTIMER,
 			"Gen timer[%d] trigger\n", index);
 		timer->trigger(timer->arg);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c5df981..58ce67f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -276,8 +276,7 @@ static void setup_ht_cap(struct ath_softc *sc,
 	tx_streams = ath9k_cmn_count_streams(ah->txchainmask, max_streams);
 	rx_streams = ath9k_cmn_count_streams(ah->rxchainmask, max_streams);
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"TX streams %d, RX streams: %d\n",
+	ath_dbg(common, CONFIG, "TX streams %d, RX streams: %d\n",
 		tx_streams, rx_streams);
 
 	if (tx_streams != rx_streams) {
@@ -329,7 +328,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	struct ath_buf *bf;
 	int i, bsize, error, desc_len;
 
-	ath_dbg(common, ATH_DBG_CONFIG, "%s DMA: %u buffers %u desc/buf\n",
+	ath_dbg(common, CONFIG, "%s DMA: %u buffers %u desc/buf\n",
 		name, nbuf, ndesc);
 
 	INIT_LIST_HEAD(head);
@@ -375,7 +374,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		goto fail;
 	}
 	ds = (u8 *) dd->dd_desc;
-	ath_dbg(common, ATH_DBG_CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
+	ath_dbg(common, CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
 		name, ds, (u32) dd->dd_desc_len,
 		ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 0e4fbb3..fd3f19c 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -21,7 +21,7 @@
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
 {
-	ath_dbg(ath9k_hw_common(ah), ATH_DBG_INTERRUPT,
+	ath_dbg(ath9k_hw_common(ah), INTERRUPT,
 		"tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
 		ah->txok_interrupt_mask, ah->txerr_interrupt_mask,
 		ah->txdesc_interrupt_mask, ah->txeol_interrupt_mask,
@@ -57,8 +57,7 @@ EXPORT_SYMBOL(ath9k_hw_puttxbuf);
 
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
-	ath_dbg(ath9k_hw_common(ah), ATH_DBG_QUEUE,
-		"Enable TXE on queue: %u\n", q);
+	ath_dbg(ath9k_hw_common(ah), QUEUE, "Enable TXE on queue: %u\n", q);
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
 }
 EXPORT_SYMBOL(ath9k_hw_txstart);
@@ -202,12 +201,12 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		ath_dbg(common, ATH_DBG_QUEUE,
+		ath_dbg(common, QUEUE,
 			"Set TXQ properties, inactive queue: %u\n", q);
 		return false;
 	}
 
-	ath_dbg(common, ATH_DBG_QUEUE, "Set queue properties for: %u\n", q);
+	ath_dbg(common, QUEUE, "Set queue properties for: %u\n", q);
 
 	qi->tqi_ver = qinfo->tqi_ver;
 	qi->tqi_subtype = qinfo->tqi_subtype;
@@ -266,7 +265,7 @@ bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		ath_dbg(common, ATH_DBG_QUEUE,
+		ath_dbg(common, QUEUE,
 			"Get TXQ properties, inactive queue: %u\n", q);
 		return false;
 	}
@@ -325,7 +324,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 		return -1;
 	}
 
-	ath_dbg(common, ATH_DBG_QUEUE, "Setup TX queue: %u\n", q);
+	ath_dbg(common, QUEUE, "Setup TX queue: %u\n", q);
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type != ATH9K_TX_QUEUE_INACTIVE) {
@@ -348,12 +347,11 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		ath_dbg(common, ATH_DBG_QUEUE,
-			"Release TXQ, inactive queue: %u\n", q);
+		ath_dbg(common, QUEUE, "Release TXQ, inactive queue: %u\n", q);
 		return false;
 	}
 
-	ath_dbg(common, ATH_DBG_QUEUE, "Release TX queue: %u\n", q);
+	ath_dbg(common, QUEUE, "Release TX queue: %u\n", q);
 
 	qi->tqi_type = ATH9K_TX_QUEUE_INACTIVE;
 	ah->txok_interrupt_mask &= ~(1 << q);
@@ -376,12 +374,11 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		ath_dbg(common, ATH_DBG_QUEUE,
-			"Reset TXQ, inactive queue: %u\n", q);
+		ath_dbg(common, QUEUE, "Reset TXQ, inactive queue: %u\n", q);
 		return true;
 	}
 
-	ath_dbg(common, ATH_DBG_QUEUE, "Reset TX queue: %u\n", q);
+	ath_dbg(common, QUEUE, "Reset TX queue: %u\n", q);
 
 	if (qi->tqi_cwmin == ATH9K_TXQ_USEDEFAULT) {
 		if (chan && IS_CHAN_B(chan))
@@ -784,7 +781,7 @@ void ath9k_hw_disable_interrupts(struct ath_hw *ah)
 	else
 		atomic_dec(&ah->intr_ref_cnt);
 
-	ath_dbg(common, ATH_DBG_INTERRUPT, "disable IER\n");
+	ath_dbg(common, INTERRUPT, "disable IER\n");
 	REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
 	(void) REG_READ(ah, AR_IER);
 	if (!AR_SREV_9100(ah)) {
@@ -807,8 +804,7 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 		return;
 
 	if (!atomic_inc_and_test(&ah->intr_ref_cnt)) {
-		ath_dbg(common, ATH_DBG_INTERRUPT,
-			"Do not enable IER ref count %d\n",
+		ath_dbg(common, INTERRUPT, "Do not enable IER ref count %d\n",
 			atomic_read(&ah->intr_ref_cnt));
 		return;
 	}
@@ -821,7 +817,7 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 	if (ah->imask & ATH9K_INT_MCI)
 		async_mask |= AR_INTR_ASYNC_MASK_MCI;
 
-	ath_dbg(common, ATH_DBG_INTERRUPT, "enable IER\n");
+	ath_dbg(common, INTERRUPT, "enable IER\n");
 	REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
 	if (!AR_SREV_9100(ah)) {
 		REG_WRITE(ah, AR_INTR_ASYNC_ENABLE, async_mask);
@@ -830,7 +826,7 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, sync_default);
 		REG_WRITE(ah, AR_INTR_SYNC_MASK, sync_default);
 	}
-	ath_dbg(common, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
+	ath_dbg(common, INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
 		REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
 }
 EXPORT_SYMBOL(ath9k_hw_enable_interrupts);
@@ -845,7 +841,7 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah)
 	if (!(ints & ATH9K_INT_GLOBAL))
 		ath9k_hw_disable_interrupts(ah);
 
-	ath_dbg(common, ATH_DBG_INTERRUPT, "New interrupt mask 0x%x\n", ints);
+	ath_dbg(common, INTERRUPT, "New interrupt mask 0x%x\n", ints);
 
 	mask = ints & ATH9K_INT_COMMON;
 	mask2 = 0;
@@ -908,7 +904,7 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah)
 			mask2 |= AR_IMR_S2_CST;
 	}
 
-	ath_dbg(common, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
+	ath_dbg(common, INTERRUPT, "new IMR 0x%x\n", mask);
 	REG_WRITE(ah, AR_IMR, mask);
 	ah->imrs2_reg &= ~(AR_IMR_S2_TIM | AR_IMR_S2_DTIM | AR_IMR_S2_DTIMSYNC |
 			   AR_IMR_S2_CABEND | AR_IMR_S2_CABTO |
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7d92004..b23fc3e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -339,8 +339,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 	if (!ath_prepare_reset(sc, retry_tx, flush))
 		fastcc = false;
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Reset to %u MHz, HT40: %d fastcc: %d\n",
+	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
 		hchan->channel, !!(hchan->channelFlags & (CHANNEL_HT40MINUS |
 							  CHANNEL_HT40PLUS)),
 		fastcc);
@@ -429,7 +428,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 	txctl.paprd = BIT(chain);
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		ath_dbg(common, ATH_DBG_CALIBRATE, "PAPRD TX failed\n");
+		ath_dbg(common, CALIBRATE, "PAPRD TX failed\n");
 		dev_kfree_skb_any(skb);
 		return false;
 	}
@@ -438,7 +437,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 			msecs_to_jiffies(ATH_PAPRD_TIMEOUT));
 
 	if (!time_left)
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Timeout waiting for paprd training on TX chain %d\n",
 			chain);
 
@@ -487,27 +486,27 @@ void ath_paprd_calibrate(struct work_struct *work)
 
 		chain_ok = 0;
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Sending PAPRD frame for thermal measurement "
-			"on chain %d\n", chain);
+		ath_dbg(common, CALIBRATE,
+			"Sending PAPRD frame for thermal measurement on chain %d\n",
+			chain);
 		if (!ath_paprd_send_frame(sc, skb, chain))
 			goto fail_paprd;
 
 		ar9003_paprd_setup_gain_table(ah, chain);
 
-		ath_dbg(common, ATH_DBG_CALIBRATE,
+		ath_dbg(common, CALIBRATE,
 			"Sending PAPRD training frame on chain %d\n", chain);
 		if (!ath_paprd_send_frame(sc, skb, chain))
 			goto fail_paprd;
 
 		if (!ar9003_paprd_is_done(ah)) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"PAPRD not yet done on chain %d\n", chain);
 			break;
 		}
 
 		if (ar9003_paprd_create_curve(ah, caldata, chain)) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
+			ath_dbg(common, CALIBRATE,
 				"PAPRD create curve failed on chain %d\n",
 								   chain);
 			break;
@@ -604,8 +603,9 @@ void ath_ani_calibrate(unsigned long data)
 						ah->rxchainmask, longcal);
 	}
 
-	ath_dbg(common, ATH_DBG_ANI,
-		"Calibration @%lu finished: %s %s %s, caldone: %s\n", jiffies,
+	ath_dbg(common, ANI,
+		"Calibration @%lu finished: %s %s %s, caldone: %s\n",
+		jiffies,
 		longcal ? "long" : "", shortcal ? "short" : "",
 		aniflag ? "ani" : "", common->ani.caldone ? "true" : "false");
 
@@ -715,8 +715,7 @@ void ath9k_tasklet(unsigned long data)
 		 * TSF sync does not look correct; remain awake to sync with
 		 * the next Beacon.
 		 */
-		ath_dbg(common, ATH_DBG_PS,
-			"TSFOOR - Sync with next Beacon\n");
+		ath_dbg(common, PS, "TSFOOR - Sync with next Beacon\n");
 		sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC;
 	}
 
@@ -936,8 +935,8 @@ void ath_hw_check(struct work_struct *work)
 	busy = ath_update_survey_stats(sc);
 	spin_unlock_irqrestore(&common->cc_lock, flags);
 
-	ath_dbg(common, ATH_DBG_RESET, "Possible baseband hang, "
-		"busy=%d (try %d)\n", busy, sc->hw_busy_count + 1);
+	ath_dbg(common, RESET, "Possible baseband hang, busy=%d (try %d)\n",
+		busy, sc->hw_busy_count + 1);
 	if (busy >= 99) {
 		if (++sc->hw_busy_count >= 3) {
 			RESET_STAT_INC(sc, RESET_TYPE_BB_HANG);
@@ -960,8 +959,7 @@ static void ath_hw_pll_rx_hang_check(struct ath_softc *sc, u32 pll_sqsum)
 		count++;
 		if (count == 3) {
 			/* Rx is hung for more than 500ms. Reset it */
-			ath_dbg(common, ATH_DBG_RESET,
-				"Possible RX hang, resetting");
+			ath_dbg(common, RESET, "Possible RX hang, resetting\n");
 			RESET_STAT_INC(sc, RESET_TYPE_PLL_HANG);
 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 			count = 0;
@@ -1001,7 +999,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath9k_channel *init_channel;
 	int r;
 
-	ath_dbg(common, ATH_DBG_CONFIG,
+	ath_dbg(common, CONFIG,
 		"Starting driver with initial channel: %d MHz\n",
 		curchan->center_freq);
 
@@ -1120,7 +1118,7 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (ieee80211_is_data(hdr->frame_control) &&
 		    !ieee80211_is_nullfunc(hdr->frame_control) &&
 		    !ieee80211_has_pm(hdr->frame_control)) {
-			ath_dbg(common, ATH_DBG_PS,
+			ath_dbg(common, PS,
 				"Add PM=1 for a TX frame while in PS mode\n");
 			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 		}
@@ -1143,12 +1141,11 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 			ath9k_hw_setrxabort(sc->sc_ah, 0);
 		if (ieee80211_is_pspoll(hdr->frame_control)) {
-			ath_dbg(common, ATH_DBG_PS,
+			ath_dbg(common, PS,
 				"Sending PS-Poll to pick a buffered frame\n");
 			sc->ps_flags |= PS_WAIT_FOR_PSPOLL_DATA;
 		} else {
-			ath_dbg(common, ATH_DBG_PS,
-				"Wake up to complete TX\n");
+			ath_dbg(common, PS, "Wake up to complete TX\n");
 			sc->ps_flags |= PS_WAIT_FOR_TX_ACK;
 		}
 		/*
@@ -1162,10 +1159,10 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	memset(&txctl, 0, sizeof(struct ath_tx_control));
 	txctl.txq = sc->tx.txq_map[skb_get_queue_mapping(skb)];
 
-	ath_dbg(common, ATH_DBG_XMIT, "transmitting packet, skb: %p\n", skb);
+	ath_dbg(common, XMIT, "transmitting packet, skb: %p\n", skb);
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		ath_dbg(common, ATH_DBG_XMIT, "TX failed\n");
+		ath_dbg(common, XMIT, "TX failed\n");
 		goto exit;
 	}
 
@@ -1186,7 +1183,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath_cancel_work(sc);
 
 	if (sc->sc_flags & SC_OP_INVALID) {
-		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
+		ath_dbg(common, ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
 	}
@@ -1252,7 +1249,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	mutex_unlock(&sc->mutex);
 
-	ath_dbg(common, ATH_DBG_CONFIG, "Driver halt\n");
+	ath_dbg(common, CONFIG, "Driver halt\n");
 }
 
 bool ath9k_uses_beacons(int type)
@@ -1467,8 +1464,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Attach a VIF of type: %d\n", vif->type);
+	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 
 	sc->nvifs++;
 
@@ -1488,7 +1484,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int ret = 0;
 
-	ath_dbg(common, ATH_DBG_CONFIG, "Change Interface\n");
+	ath_dbg(common, CONFIG, "Change Interface\n");
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
 
@@ -1531,7 +1527,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface\n");
+	ath_dbg(common, CONFIG, "Detach Interface\n");
 
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
@@ -1622,12 +1618,10 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
 		if (conf->flags & IEEE80211_CONF_MONITOR) {
-			ath_dbg(common, ATH_DBG_CONFIG,
-				"Monitor mode is enabled\n");
+			ath_dbg(common, CONFIG, "Monitor mode is enabled\n");
 			sc->sc_ah->is_monitoring = true;
 		} else {
-			ath_dbg(common, ATH_DBG_CONFIG,
-				"Monitor mode is disabled\n");
+			ath_dbg(common, CONFIG, "Monitor mode is disabled\n");
 			sc->sc_ah->is_monitoring = false;
 		}
 	}
@@ -1647,8 +1641,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		else
 			sc->sc_flags &= ~SC_OP_OFFCHANNEL;
 
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Set channel: %d MHz type: %d\n",
+		ath_dbg(common, CONFIG, "Set channel: %d MHz type: %d\n",
 			curchan->center_freq, conf->channel_type);
 
 		/* update survey stats for the old channel before switching */
@@ -1705,8 +1698,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Set power: %d\n", conf->power_level);
+		ath_dbg(common, CONFIG, "Set power: %d\n", conf->power_level);
 		sc->config.txpowlimit = 2 * conf->power_level;
 		ath9k_cmn_update_txpow(ah, sc->curtxpow,
 				       sc->config.txpowlimit, &sc->curtxpow);
@@ -1746,8 +1738,8 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
 	ath9k_ps_restore(sc);
 
-	ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_CONFIG,
-		"Set HW RX filter: 0x%x\n", rfilt);
+	ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG, "Set HW RX filter: 0x%x\n",
+		rfilt);
 }
 
 static int ath9k_sta_add(struct ieee80211_hw *hw,
@@ -1841,7 +1833,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	qi.tqi_cwmax = params->cw_max;
 	qi.tqi_burstTime = params->txop;
 
-	ath_dbg(common, ATH_DBG_CONFIG,
+	ath_dbg(common, CONFIG,
 		"Configure tx [queue/halq] [%d/%d], aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
 		queue, txq->axq_qnum, params->aifs, params->cw_min,
 		params->cw_max, params->txop);
@@ -1889,7 +1881,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
-	ath_dbg(common, ATH_DBG_CONFIG, "Set HW Key\n");
+	ath_dbg(common, CONFIG, "Set HW Key\n");
 
 	switch (cmd) {
 	case SET_KEY:
@@ -1941,9 +1933,8 @@ static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = bss_conf->aid;
 		ath9k_hw_write_associd(sc->sc_ah);
-		ath_dbg(common, ATH_DBG_CONFIG,
-				"Bss Info ASSOC %d, bssid: %pM\n",
-				bss_conf->aid, common->curbssid);
+		ath_dbg(common, CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
+			bss_conf->aid, common->curbssid);
 		ath_beacon_config(sc, vif);
 		/*
 		 * Request a re-configuration of Beacon related timers
@@ -1974,8 +1965,7 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
 
 	/* Reconfigure bss info */
 	if (avp->primary_sta_vif && !bss_conf->assoc) {
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Bss Info DISASSOC %d, bssid %pM\n",
+		ath_dbg(common, CONFIG, "Bss Info DISASSOC %d, bssid %pM\n",
 			common->curaid, common->curbssid);
 		sc->sc_flags &= ~(SC_OP_PRIM_STA_VIF | SC_OP_BEACONS);
 		avp->primary_sta_vif = false;
@@ -2017,7 +2007,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID) {
 		ath9k_config_bss(sc, vif);
 
-		ath_dbg(common, ATH_DBG_CONFIG, "BSSID: %pM aid: 0x%x\n",
+		ath_dbg(common, CONFIG, "BSSID: %pM aid: 0x%x\n",
 			common->curbssid, common->curaid);
 	}
 
@@ -2095,7 +2085,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
+		ath_dbg(common, CONFIG, "BSS Changed PREAMBLE %d\n",
 			bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
 			sc->sc_flags |= SC_OP_PREAMBLE_SHORT;
@@ -2104,7 +2094,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed CTS PROT %d\n",
+		ath_dbg(common, CONFIG, "BSS Changed CTS PROT %d\n",
 			bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot &&
 		    hw->conf.channel->band != IEEE80211_BAND_5GHZ)
@@ -2270,13 +2260,13 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 
 	if (ah->ah_flags & AH_UNPLUGGED) {
-		ath_dbg(common, ATH_DBG_ANY, "Device has been unplugged!\n");
+		ath_dbg(common, ANY, "Device has been unplugged!\n");
 		mutex_unlock(&sc->mutex);
 		return;
 	}
 
 	if (sc->sc_flags & SC_OP_INVALID) {
-		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
+		ath_dbg(common, ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 691bf47..ca9b53c 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -43,14 +43,14 @@ static bool ath_mci_add_profile(struct ath_common *common,
 
 	if ((mci->num_sco == ATH_MCI_MAX_SCO_PROFILE) &&
 	    (info->type == MCI_GPM_COEX_PROFILE_VOICE)) {
-		ath_dbg(common, ATH_DBG_MCI,
+		ath_dbg(common, MCI,
 			"Too many SCO profile, failed to add new profile\n");
 		return false;
 	}
 
 	if (((NUM_PROF(mci) - mci->num_sco) == ATH_MCI_MAX_ACL_PROFILE) &&
 	    (info->type != MCI_GPM_COEX_PROFILE_VOICE)) {
-		ath_dbg(common, ATH_DBG_MCI,
+		ath_dbg(common, MCI,
 			"Too many ACL profile, failed to add new profile\n");
 		return false;
 	}
@@ -80,8 +80,7 @@ static void ath_mci_del_profile(struct ath_common *common,
 	entry = ath_mci_find_profile(mci, info);
 
 	if (!entry) {
-		ath_dbg(common, ATH_DBG_MCI,
-			"Profile to be deleted not found\n");
+		ath_dbg(common, MCI, "Profile to be deleted not found\n");
 		return;
 	}
 	DEC_PROF(mci, entry);
@@ -132,30 +131,30 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
 					list);
 		if (mci->num_sco && info->T == 12) {
 			mci->aggr_limit = 8;
-			ath_dbg(common, ATH_DBG_MCI,
+			ath_dbg(common, MCI,
 				"Single SCO, aggregation limit 2 ms\n");
 		} else if ((info->type == MCI_GPM_COEX_PROFILE_BNEP) &&
 			   !info->master) {
 			btcoex->btcoex_period = 60;
-			ath_dbg(common, ATH_DBG_MCI,
+			ath_dbg(common, MCI,
 				"Single slave PAN/FTP, bt period 60 ms\n");
 		} else if ((info->type == MCI_GPM_COEX_PROFILE_HID) &&
 			 (info->T > 0 && info->T < 50) &&
 			 (info->A > 1 || info->W > 1)) {
 			btcoex->duty_cycle = 30;
 			mci->aggr_limit = 8;
-			ath_dbg(common, ATH_DBG_MCI,
+			ath_dbg(common, MCI,
 				"Multiple attempt/timeout single HID "
 				"aggregation limit 2 ms dutycycle 30%%\n");
 		}
 	} else if ((num_profile == 2) && (mci->num_hid == 2)) {
 		btcoex->duty_cycle = 30;
 		mci->aggr_limit = 8;
-		ath_dbg(common, ATH_DBG_MCI,
+		ath_dbg(common, MCI,
 			"Two HIDs aggregation limit 2 ms dutycycle 30%%\n");
 	} else if (num_profile > 3) {
 		mci->aggr_limit = 6;
-		ath_dbg(common, ATH_DBG_MCI,
+		ath_dbg(common, MCI,
 			"Three or more profiles aggregation limit 1.5 ms\n");
 	}
 
@@ -194,42 +193,41 @@ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	switch (opcode) {
 	case MCI_GPM_BT_CAL_REQ:
 
-		ath_dbg(common, ATH_DBG_MCI, "MCI received BT_CAL_REQ\n");
+		ath_dbg(common, MCI, "MCI received BT_CAL_REQ\n");
 
 		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_AWAKE) {
 			ar9003_mci_state(ah, MCI_STATE_SET_BT_CAL_START, NULL);
 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 		} else
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI State mismatches: %d\n",
+			ath_dbg(common, MCI, "MCI State mismatches: %d\n",
 				ar9003_mci_state(ah, MCI_STATE_BT, NULL));
 
 		break;
 
 	case MCI_GPM_BT_CAL_DONE:
 
-		ath_dbg(common, ATH_DBG_MCI, "MCI received BT_CAL_DONE\n");
+		ath_dbg(common, MCI, "MCI received BT_CAL_DONE\n");
 
 		if (ar9003_mci_state(ah, MCI_STATE_BT, NULL) == MCI_BT_CAL)
-			ath_dbg(common, ATH_DBG_MCI, "MCI error illegal!\n");
+			ath_dbg(common, MCI, "MCI error illegal!\n");
 		else
-			ath_dbg(common, ATH_DBG_MCI, "MCI BT not in CAL state\n");
+			ath_dbg(common, MCI, "MCI BT not in CAL state\n");
 
 		break;
 
 	case MCI_GPM_BT_CAL_GRANT:
 
-		ath_dbg(common, ATH_DBG_MCI, "MCI received BT_CAL_GRANT\n");
+		ath_dbg(common, MCI, "MCI received BT_CAL_GRANT\n");
 
 		/* Send WLAN_CAL_DONE for now */
-		ath_dbg(common, ATH_DBG_MCI, "MCI send WLAN_CAL_DONE\n");
+		ath_dbg(common, MCI, "MCI send WLAN_CAL_DONE\n");
 		MCI_GPM_SET_CAL_TYPE(payload, MCI_GPM_WLAN_CAL_DONE);
 		ar9003_mci_send_message(sc->sc_ah, MCI_GPM, 0, payload,
 					16, false, true);
 		break;
 
 	default:
-		ath_dbg(common, ATH_DBG_MCI, "MCI Unknown GPM CAL message\n");
+		ath_dbg(common, MCI, "MCI Unknown GPM CAL message\n");
 		break;
 	}
 }
@@ -272,8 +270,7 @@ static void ath_mci_process_status(struct ath_softc *sc,
 
 	/* Link status type are not handled */
 	if (status->is_link) {
-		ath_dbg(common, ATH_DBG_MCI,
-			"Skip link type status update\n");
+		ath_dbg(common, MCI, "Skip link type status update\n");
 		return;
 	}
 
@@ -281,14 +278,13 @@ static void ath_mci_process_status(struct ath_softc *sc,
 
 	info.conn_handle = status->conn_handle;
 	if (ath_mci_find_profile(mci, &info)) {
-		ath_dbg(common, ATH_DBG_MCI,
+		ath_dbg(common, MCI,
 			"Skip non link state update for existing profile %d\n",
 			status->conn_handle);
 		return;
 	}
 	if (status->conn_handle >= ATH_MCI_MAX_PROFILE) {
-		ath_dbg(common, ATH_DBG_MCI,
-			"Ignore too many non-link update\n");
+		ath_dbg(common, MCI, "Ignore too many non-link update\n");
 		return;
 	}
 	if (status->is_critical)
@@ -320,35 +316,32 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	switch (opcode) {
 
 	case MCI_GPM_COEX_VERSION_QUERY:
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM COEX Version Query.\n");
+		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Query\n");
 		version = ar9003_mci_state(ah,
 				MCI_STATE_SEND_WLAN_COEX_VERSION, NULL);
 		break;
 
 	case MCI_GPM_COEX_VERSION_RESPONSE:
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM COEX Version Response.\n");
+		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Response\n");
 		major = *(rx_payload + MCI_GPM_COEX_B_MAJOR_VERSION);
 		minor = *(rx_payload + MCI_GPM_COEX_B_MINOR_VERSION);
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI BT Coex version: %d.%d\n", major, minor);
+		ath_dbg(common, MCI, "MCI BT Coex version: %d.%d\n",
+			major, minor);
 		version = (major << 8) + minor;
 		version = ar9003_mci_state(ah,
 			  MCI_STATE_SET_BT_COEX_VERSION, &version);
 		break;
 
 	case MCI_GPM_COEX_STATUS_QUERY:
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM COEX Status Query = 0x%02x.\n",
+		ath_dbg(common, MCI,
+			"MCI Recv GPM COEX Status Query = 0x%02x\n",
 			*(rx_payload + MCI_GPM_COEX_B_WLAN_BITMAP));
 		ar9003_mci_state(ah,
 		MCI_STATE_SEND_WLAN_CHANNELS, NULL);
 		break;
 
 	case MCI_GPM_COEX_BT_PROFILE_INFO:
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM Coex BT profile info\n");
+		ath_dbg(common, MCI, "MCI Recv GPM Coex BT profile info\n");
 		memcpy(&profile_info,
 		       (rx_payload + MCI_GPM_COEX_B_PROFILE_TYPE), 10);
 
@@ -356,9 +349,9 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 		    || (profile_info.type >=
 					    MCI_GPM_COEX_PROFILE_MAX)) {
 
-			ath_dbg(common, ATH_DBG_MCI,
-				"illegal profile type = %d,"
-				"state = %d\n", profile_info.type,
+			ath_dbg(common, MCI,
+				"illegal profile type = %d, state = %d\n",
+				profile_info.type,
 				profile_info.start);
 			break;
 		}
@@ -375,9 +368,8 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 					       MCI_GPM_COEX_B_STATUS_STATE);
 
 		seq_num = *((u32 *)(rx_payload + 12));
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI Recv GPM COEX BT_Status_Update: "
-			"is_link=%d, linkId=%d, state=%d, SEQ=%d\n",
+		ath_dbg(common, MCI,
+			"MCI Recv GPM COEX BT_Status_Update: is_link=%d, linkId=%d, state=%d, SEQ=%d\n",
 			profile_status.is_link, profile_status.conn_handle,
 			profile_status.is_critical, seq_num);
 
@@ -385,8 +377,8 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 		break;
 
 	default:
-		ath_dbg(common, ATH_DBG_MCI,
-		"MCI Unknown GPM COEX message = 0x%02x\n", opcode);
+		ath_dbg(common, MCI, "MCI Unknown GPM COEX message = 0x%02x\n",
+			opcode);
 		break;
 	}
 }
@@ -428,7 +420,7 @@ int ath_mci_setup(struct ath_softc *sc)
 	mci->sched_buf.bf_len = ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE;
 
 	if (ath_mci_buf_alloc(sc, &mci->sched_buf)) {
-		ath_dbg(common, ATH_DBG_FATAL, "MCI buffer alloc failed\n");
+		ath_dbg(common, FATAL, "MCI buffer alloc failed\n");
 		error = -ENOMEM;
 		goto fail;
 	}
@@ -481,10 +473,9 @@ void ath_mci_intr(struct ath_softc *sc)
 	if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) == 0) {
 
 		ar9003_mci_state(sc->sc_ah, MCI_STATE_INIT_GPM_OFFSET, NULL);
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI interrupt but MCI disabled\n");
+		ath_dbg(common, MCI, "MCI interrupt but MCI disabled\n");
 
-		ath_dbg(common, ATH_DBG_MCI,
+		ath_dbg(common, MCI,
 			"MCI interrupt: intr = 0x%x, intr_rxmsg = 0x%x\n",
 			mci_int, mci_int_rxmsg);
 		return;
@@ -499,11 +490,11 @@ void ath_mci_intr(struct ath_softc *sc)
 		 * only when BT wake up. Now they are always sent, as a
 		 * recovery method to reset BT MCI's RX alignment.
 		 */
-		ath_dbg(common, ATH_DBG_MCI, "MCI interrupt send REMOTE_RESET\n");
+		ath_dbg(common, MCI, "MCI interrupt send REMOTE_RESET\n");
 
 		ar9003_mci_send_message(ah, MCI_REMOTE_RESET, 0,
 					payload, 16, true, false);
-		ath_dbg(common, ATH_DBG_MCI, "MCI interrupt send SYS_WAKING\n");
+		ath_dbg(common, MCI, "MCI interrupt send SYS_WAKING\n");
 		ar9003_mci_send_message(ah, MCI_SYS_WAKING, 0,
 					NULL, 0, true, false);
 
@@ -513,7 +504,7 @@ void ath_mci_intr(struct ath_softc *sc)
 		/*
 		 * always do this for recovery and 2G/5G toggling and LNA_TRANS
 		 */
-		ath_dbg(common, ATH_DBG_MCI, "MCI Set BT state to AWAKE.\n");
+		ath_dbg(common, MCI, "MCI Set BT state to AWAKE\n");
 		ar9003_mci_state(ah, MCI_STATE_SET_BT_AWAKE, NULL);
 	}
 
@@ -525,17 +516,16 @@ void ath_mci_intr(struct ath_softc *sc)
 
 			if (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL)
 					== MCI_BT_SLEEP)
-				ath_dbg(common, ATH_DBG_MCI,
+				ath_dbg(common, MCI,
 					"MCI BT stays in sleep mode\n");
 			else {
-				ath_dbg(common, ATH_DBG_MCI,
-					"MCI Set BT state to AWAKE.\n");
+				ath_dbg(common, MCI,
+					"MCI Set BT state to AWAKE\n");
 				ar9003_mci_state(ah,
 						 MCI_STATE_SET_BT_AWAKE, NULL);
 			}
 		} else
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI BT stays in AWAKE mode.\n");
+			ath_dbg(common, MCI, "MCI BT stays in AWAKE mode\n");
 	}
 
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING) {
@@ -546,23 +536,22 @@ void ath_mci_intr(struct ath_softc *sc)
 
 			if (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL)
 					== MCI_BT_AWAKE)
-				ath_dbg(common, ATH_DBG_MCI,
-					"MCI BT stays in AWAKE mode.\n");
+				ath_dbg(common, MCI,
+					"MCI BT stays in AWAKE mode\n");
 			else {
-				ath_dbg(common, ATH_DBG_MCI,
+				ath_dbg(common, MCI,
 					"MCI SetBT state to SLEEP\n");
 				ar9003_mci_state(ah, MCI_STATE_SET_BT_SLEEP,
 						 NULL);
 			}
 		} else
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI BT stays in SLEEP mode\n");
+			ath_dbg(common, MCI, "MCI BT stays in SLEEP mode\n");
 	}
 
 	if ((mci_int & AR_MCI_INTERRUPT_RX_INVALID_HDR) ||
 	    (mci_int & AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT)) {
 
-		ath_dbg(common, ATH_DBG_MCI, "MCI RX broken, skip GPM msgs\n");
+		ath_dbg(common, MCI, "MCI RX broken, skip GPM msgs\n");
 		ar9003_mci_state(ah, MCI_STATE_RECOVER_RX, NULL);
 		skip_gpm = true;
 	}
@@ -624,7 +613,7 @@ void ath_mci_intr(struct ath_softc *sc)
 
 		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_LNA_INFO) {
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_LNA_INFO;
-			ath_dbg(common, ATH_DBG_MCI, "MCI LNA_INFO\n");
+			ath_dbg(common, MCI, "MCI LNA_INFO\n");
 		}
 
 		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_INFO) {
@@ -635,16 +624,14 @@ void ath_mci_intr(struct ath_softc *sc)
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_INFO;
 
 			if (ar9003_mci_state(ah, MCI_STATE_CONT_TXRX, NULL))
-				ath_dbg(common, ATH_DBG_MCI,
-					"MCI CONT_INFO: "
-					"(tx) pri = %d, pwr = %d dBm\n",
+				ath_dbg(common, MCI,
+					"MCI CONT_INFO: (tx) pri = %d, pwr = %d dBm\n",
 					ar9003_mci_state(ah,
 						MCI_STATE_CONT_PRIORITY, NULL),
 					value_dbm);
 			else
-				ath_dbg(common, ATH_DBG_MCI,
-					"MCI CONT_INFO:"
-					"(rx) pri = %d,pwr = %d dBm\n",
+				ath_dbg(common, MCI,
+					"MCI CONT_INFO: (rx) pri = %d,pwr = %d dBm\n",
 					ar9003_mci_state(ah,
 						MCI_STATE_CONT_PRIORITY, NULL),
 					value_dbm);
@@ -652,12 +639,12 @@ void ath_mci_intr(struct ath_softc *sc)
 
 		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_NACK) {
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_NACK;
-			ath_dbg(common, ATH_DBG_MCI, "MCI CONT_NACK\n");
+			ath_dbg(common, MCI, "MCI CONT_NACK\n");
 		}
 
 		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_RST) {
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_RST;
-			ath_dbg(common, ATH_DBG_MCI, "MCI CONT_RST\n");
+			ath_dbg(common, MCI, "MCI CONT_RST\n");
 		}
 	}
 
@@ -667,7 +654,6 @@ void ath_mci_intr(struct ath_softc *sc)
 			     AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT);
 
 	if (mci_int_rxmsg & 0xfffffffe)
-		ath_dbg(common, ATH_DBG_MCI,
-			"MCI not processed mci_int_rxmsg = 0x%x\n",
+		ath_dbg(common, MCI, "MCI not processed mci_int_rxmsg = 0x%x\n",
 			mci_int_rxmsg);
 }
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 528d5f3..b3c3798 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1199,7 +1199,7 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 			return &ar5416_11na_ratetable;
 		return &ar5416_11a_ratetable;
 	default:
-		ath_dbg(common, ATH_DBG_CONFIG, "Invalid band\n");
+		ath_dbg(common, CONFIG, "Invalid band\n");
 		return NULL;
 	}
 }
@@ -1276,8 +1276,7 @@ static void ath_rc_init(struct ath_softc *sc,
 					ath_rc_priv->valid_rate_index[k-1];
 	ath_rc_priv->rate_table = rate_table;
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"RC Initialized with capabilities: 0x%x\n",
+	ath_dbg(common, CONFIG, "RC Initialized with capabilities: 0x%x\n",
 		ath_rc_priv->ht_cap);
 }
 
@@ -1474,7 +1473,7 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 						   oper_cw40, oper_sgi);
 			ath_rc_init(sc, priv_sta, sband, sta, rate_table);
 
-			ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_CONFIG,
+			ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
 				"Operating HT Bandwidth changed to: %d\n",
 				sc->hw->conf.channel_type);
 		}
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index e031841..0d7c33c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -172,7 +172,7 @@ static void ath_rx_addbuffer_edma(struct ath_softc *sc,
 	u32 nbuf = 0;
 
 	if (list_empty(&sc->rx.rxbuf)) {
-		ath_dbg(common, ATH_DBG_QUEUE, "No free rx buf available\n");
+		ath_dbg(common, QUEUE, "No free rx buf available\n");
 		return;
 	}
 
@@ -337,7 +337,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		return ath_rx_edma_init(sc, nbufs);
 	} else {
-		ath_dbg(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
+		ath_dbg(common, CONFIG, "cachelsz %u rxbufsize %u\n",
 			common->cachelsz, common->rx_bufsize);
 
 		/* Initialize rx descriptors */
@@ -591,7 +591,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 
 	if (sc->ps_flags & PS_BEACON_SYNC) {
 		sc->ps_flags &= ~PS_BEACON_SYNC;
-		ath_dbg(common, ATH_DBG_PS,
+		ath_dbg(common, PS,
 			"Reconfigure Beacon timers based on timestamp from the AP\n");
 		ath_set_beacon(sc);
 	}
@@ -604,7 +604,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		 * a backup trigger for returning into NETWORK SLEEP state,
 		 * so we are waiting for it as well.
 		 */
-		ath_dbg(common, ATH_DBG_PS,
+		ath_dbg(common, PS,
 			"Received DTIM beacon indicating buffered broadcast/multicast frame(s)\n");
 		sc->ps_flags |= PS_WAIT_FOR_CAB | PS_WAIT_FOR_BEACON;
 		return;
@@ -617,8 +617,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		 * been delivered.
 		 */
 		sc->ps_flags &= ~PS_WAIT_FOR_CAB;
-		ath_dbg(common, ATH_DBG_PS,
-			"PS wait for CAB frames timed out\n");
+		ath_dbg(common, PS, "PS wait for CAB frames timed out\n");
 	}
 }
 
@@ -643,13 +642,13 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb, bool mybeacon)
 		 * point.
 		 */
 		sc->ps_flags &= ~(PS_WAIT_FOR_CAB | PS_WAIT_FOR_BEACON);
-		ath_dbg(common, ATH_DBG_PS,
+		ath_dbg(common, PS,
 			"All PS CAB frames received, back to sleep\n");
 	} else if ((sc->ps_flags & PS_WAIT_FOR_PSPOLL_DATA) &&
 		   !is_multicast_ether_addr(hdr->addr1) &&
 		   !ieee80211_has_morefrags(hdr->frame_control)) {
 		sc->ps_flags &= ~PS_WAIT_FOR_PSPOLL_DATA;
-		ath_dbg(common, ATH_DBG_PS,
+		ath_dbg(common, PS,
 			"Going back to sleep after having received PS-Poll data (0x%lx)\n",
 			sc->ps_flags & (PS_WAIT_FOR_BEACON |
 					PS_WAIT_FOR_CAB |
@@ -932,7 +931,7 @@ static int ath9k_process_rate(struct ath_common *common,
 	 * No valid hardware bitrate found -- we should not get here
 	 * because hardware has already validated this frame as OK.
 	 */
-	ath_dbg(common, ATH_DBG_ANY,
+	ath_dbg(common, ANY,
 		"unsupported hw bitrate detected 0x%02x using 1 Mbit\n",
 		rx_stats->rs_rate);
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 35422fc..65c8894 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -187,7 +187,7 @@ void ath9k_fatal_work(struct work_struct *work)
 						   fatal_work);
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 
-	ath_dbg(common, ATH_DBG_FATAL, "FATAL Event received, resetting device\n");
+	ath_dbg(common, FATAL, "FATAL Event received, resetting device\n");
 	ath9k_htc_reset(priv);
 }
 
@@ -330,8 +330,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 
 	time_left = wait_for_completion_timeout(&wmi->cmd_wait, timeout);
 	if (!time_left) {
-		ath_dbg(common, ATH_DBG_WMI,
-			"Timeout waiting for WMI command: %s\n",
+		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
 		mutex_unlock(&wmi->op_mutex);
 		return -ETIMEDOUT;
@@ -342,8 +341,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	return 0;
 
 out:
-	ath_dbg(common, ATH_DBG_WMI,
-		"WMI failure for: %s\n", wmi_cmd_to_name(cmd_id));
+	ath_dbg(common, WMI, "WMI failure for: %s\n", wmi_cmd_to_name(cmd_id));
 	mutex_unlock(&wmi->op_mutex);
 	kfree_skb(skb);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9e65c31..b07ae44 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1602,8 +1602,8 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	bf = list_first_entry(head, struct ath_buf, list);
 	bf_last = list_entry(head->prev, struct ath_buf, list);
 
-	ath_dbg(common, ATH_DBG_QUEUE,
-		"qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
+	ath_dbg(common, QUEUE, "qnum: %d, txq depth: %d\n",
+		txq->axq_qnum, txq->axq_depth);
 
 	if (edma && list_empty(&txq->txq_fifo[txq->txq_headidx])) {
 		list_splice_tail_init(head, &txq->txq_fifo[txq->txq_headidx]);
@@ -1614,8 +1614,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 
 		if (txq->axq_link) {
 			ath9k_hw_set_desc_link(ah, txq->axq_link, bf->bf_daddr);
-			ath_dbg(common, ATH_DBG_XMIT,
-				"link[%u] (%p)=%llx (%p)\n",
+			ath_dbg(common, XMIT, "link[%u] (%p)=%llx (%p)\n",
 				txq->axq_qnum, txq->axq_link,
 				ito64(bf->bf_daddr), bf->bf_desc);
 		} else if (!edma)
@@ -1627,7 +1626,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	if (puttxbuf) {
 		TX_STAT_INC(txq->axq_qnum, puttxbuf);
 		ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
-		ath_dbg(common, ATH_DBG_XMIT, "TXDP[%u] = %llx (%p)\n",
+		ath_dbg(common, XMIT, "TXDP[%u] = %llx (%p)\n",
 			txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
 	}
 
@@ -1773,7 +1772,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
-		ath_dbg(common, ATH_DBG_XMIT, "TX buffers are full\n");
+		ath_dbg(common, XMIT, "TX buffers are full\n");
 		goto error;
 	}
 
@@ -1934,7 +1933,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	struct ieee80211_hdr * hdr = (struct ieee80211_hdr *)skb->data;
 	int q, padpos, padsize;
 
-	ath_dbg(common, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
+	ath_dbg(common, XMIT, "TX complete: skb: %p\n", skb);
 
 	if (tx_flags & ATH_TX_BAR)
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
@@ -1956,7 +1955,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	if ((sc->ps_flags & PS_WAIT_FOR_TX_ACK) && !txq->axq_depth) {
 		sc->ps_flags &= ~PS_WAIT_FOR_TX_ACK;
-		ath_dbg(common, ATH_DBG_PS,
+		ath_dbg(common, PS,
 			"Going back to sleep after having received TX status (0x%lx)\n",
 			sc->ps_flags & (PS_WAIT_FOR_BEACON |
 					PS_WAIT_FOR_CAB |
@@ -2118,7 +2117,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_tx_status ts;
 	int status;
 
-	ath_dbg(common, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
+	ath_dbg(common, QUEUE, "tx queue %d (%x), link %p\n",
 		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
 		txq->axq_link);
 
@@ -2212,7 +2211,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 		}
 
 	if (needreset) {
-		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
+		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
 			"tx hung, resetting the chip\n");
 		RESET_STAT_INC(sc, RESET_TYPE_TX_HANG);
 		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
@@ -2255,8 +2254,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		if (status == -EINPROGRESS)
 			break;
 		if (status == -EIO) {
-			ath_dbg(common, ATH_DBG_XMIT,
-				"Error processing tx status\n");
+			ath_dbg(common, XMIT, "Error processing tx status\n");
 			break;
 		}
 
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 4cf7c5e..0e81904 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -143,7 +143,7 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 		break;
 	case ATH_CIPHER_AES_CCM:
 		if (!(common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM)) {
-			ath_dbg(common, ATH_DBG_ANY,
+			ath_dbg(common, ANY,
 				"AES-CCM not supported by this mac rev\n");
 			return false;
 		}
@@ -152,15 +152,15 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 	case ATH_CIPHER_TKIP:
 		keyType = AR_KEYTABLE_TYPE_TKIP;
 		if (entry + 64 >= common->keymax) {
-			ath_dbg(common, ATH_DBG_ANY,
+			ath_dbg(common, ANY,
 				"entry %u inappropriate for TKIP\n", entry);
 			return false;
 		}
 		break;
 	case ATH_CIPHER_WEP:
 		if (k->kv_len < WLAN_KEY_LEN_WEP40) {
-			ath_dbg(common, ATH_DBG_ANY,
-				"WEP key length %u too small\n", k->kv_len);
+			ath_dbg(common, ANY, "WEP key length %u too small\n",
+				k->kv_len);
 			return false;
 		}
 		if (k->kv_len <= WLAN_KEY_LEN_WEP40)
-- 
1.7.8.111.gad25c.dirty



