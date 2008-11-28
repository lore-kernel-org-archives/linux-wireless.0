Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20266 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYK1QvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 11:51:13 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 08:51:12 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18736.8389.643953.510307@gargle.gargle.HOWL> (sfid-20081128_175139_310221_B22AAA12)
Date: Fri, 28 Nov 2008 22:18:05 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/5] ath9k: Use cleaner debug masks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove all the useless __func__ prefixes in debug messages,
and replace the DPRINTF macro with a function.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ani.c    |   34 +++---
 drivers/net/wireless/ath9k/beacon.c |   77 +++++------
 drivers/net/wireless/ath9k/calib.c  |   69 +++++------
 drivers/net/wireless/ath9k/core.h   |  157 +++++++++---------------
 drivers/net/wireless/ath9k/eeprom.c |   16 +--
 drivers/net/wireless/ath9k/hw.c     |  189 +++++++++++----------------
 drivers/net/wireless/ath9k/mac.c    |   66 ++++------
 drivers/net/wireless/ath9k/main.c   |  238 ++++++++++++++++-------------------
 drivers/net/wireless/ath9k/phy.c    |   14 +--
 drivers/net/wireless/ath9k/rc.c     |    7 +-
 drivers/net/wireless/ath9k/recv.c   |   14 +--
 drivers/net/wireless/ath9k/regd.c   |   81 +++++-------
 drivers/net/wireless/ath9k/xmit.c   |   77 ++++-------
 13 files changed, 430 insertions(+), 609 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index ada12e9..c25b72b 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -53,8 +53,8 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 
 		if (level >= ARRAY_SIZE(ahp->ah_totalSizeDesired)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-				"%s: level out of range (%u > %u)\n",
-				__func__, level,
+				"level out of range (%u > %u)\n",
+				level,
 				(unsigned)ARRAY_SIZE(ahp->ah_totalSizeDesired));
 			return false;
 		}
@@ -158,8 +158,8 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 
 		if (level >= ARRAY_SIZE(firstep)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-				"%s: level out of range (%u > %u)\n",
-				__func__, level,
+				"level out of range (%u > %u)\n",
+				level,
 				(unsigned) ARRAY_SIZE(firstep));
 			return false;
 		}
@@ -180,8 +180,8 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 
 		if (level >= ARRAY_SIZE(cycpwrThr1)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-				"%s: level out of range (%u > %u)\n",
-				__func__, level,
+				"level out of range (%u > %u)\n",
+				level,
 				(unsigned)
 				ARRAY_SIZE(cycpwrThr1));
 			return false;
@@ -200,11 +200,11 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-			"%s: invalid cmd %u\n", __func__, cmd);
+			"invalid cmd %u\n", cmd);
 		return false;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "%s: ANI parameters:\n", __func__);
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "ANI parameters:\n");
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		"noiseImmunityLevel=%d, spurImmunityLevel=%d, "
 		"ofdmWeakSigDetectOff=%d\n",
@@ -262,8 +262,8 @@ static void ath9k_ani_restart(struct ath_hal *ah)
 				AR_PHY_COUNTMAX - aniState->cckTrigHigh;
 		}
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-			"%s: Writing ofdmbase=%u   cckbase=%u\n",
-			__func__, aniState->ofdmPhyErrBase,
+			"Writing ofdmbase=%u   cckbase=%u\n",
+			aniState->ofdmPhyErrBase,
 			aniState->cckPhyErrBase);
 		REG_WRITE(ah, AR_PHY_ERR_1, aniState->ofdmPhyErrBase);
 		REG_WRITE(ah, AR_PHY_ERR_2, aniState->cckPhyErrBase);
@@ -490,8 +490,7 @@ void ath9k_ani_reset(struct ath_hal *ah)
 	if (DO_ANI(ah) && ah->ah_opmode != ATH9K_M_STA
 	    && ah->ah_opmode != ATH9K_M_IBSS) {
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-			"%s: Reset ANI state opmode %u\n", __func__,
-			ah->ah_opmode);
+			"Reset ANI state opmode %u\n", ah->ah_opmode);
 		ahp->ah_stats.ast_ani_reset++;
 
 		ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL, 0);
@@ -581,9 +580,9 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 		    phyCnt2 < aniState->cckPhyErrBase) {
 			if (phyCnt1 < aniState->ofdmPhyErrBase) {
 				DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-					"%s: phyCnt1 0x%x, resetting "
+					"phyCnt1 0x%x, resetting "
 					"counter value to 0x%x\n",
-					__func__, phyCnt1,
+					phyCnt1,
 					aniState->ofdmPhyErrBase);
 				REG_WRITE(ah, AR_PHY_ERR_1,
 					  aniState->ofdmPhyErrBase);
@@ -592,9 +591,9 @@ void ath9k_hw_ani_monitor(struct ath_hal *ah,
 			}
 			if (phyCnt2 < aniState->cckPhyErrBase) {
 				DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-					"%s: phyCnt2 0x%x, resetting "
+					"phyCnt2 0x%x, resetting "
 					"counter value to 0x%x\n",
-					__func__, phyCnt2,
+					phyCnt2,
 					aniState->cckPhyErrBase);
 				REG_WRITE(ah, AR_PHY_ERR_2,
 					  aniState->cckPhyErrBase);
@@ -692,8 +691,7 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
 
 	if (cycles == 0 || cycles > cc) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"%s: cycle counter wrap. ExtBusy = 0\n",
-			__func__);
+			"cycle counter wrap. ExtBusy = 0\n");
 		good = 0;
 	} else {
 		u32 cc_d = cc - cycles;
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index e80d9b9..88fbfe5 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -41,8 +41,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 
 	if (!ath9k_hw_set_txq_props(ah, sc->sc_bhalq, &qi)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to update h/w beacon queue parameters\n",
-			__func__);
+			"unable to update h/w beacon queue parameters\n");
 		return 0;
 	} else {
 		ath9k_hw_resettxqueue(ah, sc->sc_bhalq); /* push to h/w */
@@ -53,8 +52,8 @@ static int ath_beaconq_config(struct ath_softc *sc)
 static void ath_bstuck_process(struct ath_softc *sc)
 {
 	DPRINTF(sc, ATH_DBG_BEACON,
-		"%s: stuck beacon; resetting (bmiss count %u)\n",
-		__func__, sc->sc_bmisscount);
+		"stuck beacon; resetting (bmiss count %u)\n",
+		sc->sc_bmisscount);
 	ath_reset(sc, false);
 }
 
@@ -76,8 +75,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	int ctsrate = 0;
 	int ctsduration = 0;
 
-	DPRINTF(sc, ATH_DBG_BEACON, "%s: m %p len %u\n",
-		__func__, skb, skb->len);
+	DPRINTF(sc, ATH_DBG_BEACON, "m %p len %u\n", skb, skb->len);
 
 	/* setup descriptors */
 	ds = bf->bf_desc;
@@ -158,8 +156,8 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	cabq = sc->sc_cabq;
 
 	if (avp->av_bcbuf == NULL) {
-		DPRINTF(sc, ATH_DBG_BEACON, "%s: avp=%p av_bcbuf=%p\n",
-			__func__, avp, avp->av_bcbuf);
+		DPRINTF(sc, ATH_DBG_BEACON, "avp=%p av_bcbuf=%p\n",
+			avp, avp->av_bcbuf);
 		return NULL;
 	}
 
@@ -216,7 +214,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 		if (sc->sc_nvaps > 1) {
 			ath_tx_draintxq(sc, cabq, false);
 			DPRINTF(sc, ATH_DBG_BEACON,
-				"%s: flush previous cabq traffic\n", __func__);
+				"flush previous cabq traffic\n");
 		}
 	}
 
@@ -253,8 +251,8 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 	avp = (void *)vif->drv_priv;
 
 	if (avp->av_bcbuf == NULL) {
-		DPRINTF(sc, ATH_DBG_BEACON, "%s: avp=%p av_bcbuf=%p\n",
-			__func__, avp, avp != NULL ? avp->av_bcbuf : NULL);
+		DPRINTF(sc, ATH_DBG_BEACON, "avp=%p av_bcbuf=%p\n",
+			avp, avp != NULL ? avp->av_bcbuf : NULL);
 		return;
 	}
 	bf = avp->av_bcbuf;
@@ -266,7 +264,7 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 	/* NB: caller is known to have already stopped tx dma */
 	ath9k_hw_puttxbuf(ah, sc->sc_bhalq, bf->bf_daddr);
 	ath9k_hw_txstart(ah, sc->sc_bhalq);
-	DPRINTF(sc, ATH_DBG_BEACON, "%s: TXDP%u = %llx (%p)\n", __func__,
+	DPRINTF(sc, ATH_DBG_BEACON, "TXDP%u = %llx (%p)\n",
 		sc->sc_bhalq, ito64(bf->bf_daddr), bf->bf_desc);
 }
 
@@ -351,8 +349,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	 */
 	skb = ieee80211_beacon_get(sc->hw, vif);
 	if (skb == NULL) {
-		DPRINTF(sc, ATH_DBG_BEACON, "%s: cannot get skb\n",
-			__func__);
+		DPRINTF(sc, ATH_DBG_BEACON, "cannot get skb\n");
 		return -ENOMEM;
 	}
 
@@ -388,8 +385,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 		val = cpu_to_le64(tsfadjust << 10);     /* TU->TSF */
 
 		DPRINTF(sc, ATH_DBG_BEACON,
-			"%s: %s beacons, bslot %d intval %u tsfadjust %llu\n",
-			__func__, "stagger",
+			"stagger beacons, bslot %d intval %u tsfadjust %llu\n",
 			avp->av_bslot, intval, (unsigned long long)tsfadjust);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
@@ -468,40 +464,39 @@ void ath9k_beacon_tasklet(unsigned long data)
 		if (sc->sc_bmisscount < BSTUCK_THRESH) {
 			if (sc->sc_flags & SC_OP_NO_RESET) {
 				DPRINTF(sc, ATH_DBG_BEACON,
-					"%s: missed %u consecutive beacons\n",
-					__func__, sc->sc_bmisscount);
+					"missed %u consecutive beacons\n",
+					sc->sc_bmisscount);
 				if (show_cycles) {
 					/*
 					 * Display cycle counter stats from HW
 					 * to aide in debug of stickiness.
 					 */
 					DPRINTF(sc, ATH_DBG_BEACON,
-						"%s: busy times: rx_clear=%d, "
+						"busy times: rx_clear=%d, "
 						"rx_frame=%d, tx_frame=%d\n",
-						__func__, rx_clear, rx_frame,
+						rx_clear, rx_frame,
 						tx_frame);
 				} else {
 					DPRINTF(sc, ATH_DBG_BEACON,
-						"%s: unable to obtain "
-						"busy times\n", __func__);
+						"unable to obtain "
+						"busy times\n");
 				}
 			} else {
 				DPRINTF(sc, ATH_DBG_BEACON,
-					"%s: missed %u consecutive beacons\n",
-					__func__, sc->sc_bmisscount);
+					"missed %u consecutive beacons\n",
+					sc->sc_bmisscount);
 			}
 		} else if (sc->sc_bmisscount >= BSTUCK_THRESH) {
 			if (sc->sc_flags & SC_OP_NO_RESET) {
 				if (sc->sc_bmisscount == BSTUCK_THRESH) {
 					DPRINTF(sc, ATH_DBG_BEACON,
-						"%s: beacon is officially "
-						"stuck\n", __func__);
+						"beacon is officially "
+						"stuck\n");
 					ath9k_hw_dmaRegDump(ah);
 				}
 			} else {
 				DPRINTF(sc, ATH_DBG_BEACON,
-					"%s: beacon is officially stuck\n",
-					__func__);
+					"beacon is officially stuck\n");
 				ath_bstuck_process(sc);
 			}
 		}
@@ -511,12 +506,12 @@ void ath9k_beacon_tasklet(unsigned long data)
 	if (sc->sc_bmisscount != 0) {
 		if (sc->sc_flags & SC_OP_NO_RESET) {
 			DPRINTF(sc, ATH_DBG_BEACON,
-				"%s: resume beacon xmit after %u misses\n",
-				__func__, sc->sc_bmisscount);
+				"resume beacon xmit after %u misses\n",
+				sc->sc_bmisscount);
 		} else {
 			DPRINTF(sc, ATH_DBG_BEACON,
-				"%s: resume beacon xmit after %u misses\n",
-				__func__, sc->sc_bmisscount);
+				"resume beacon xmit after %u misses\n",
+				sc->sc_bmisscount);
 		}
 		sc->sc_bmisscount = 0;
 	}
@@ -536,8 +531,8 @@ void ath9k_beacon_tasklet(unsigned long data)
 	if_id = sc->sc_bslot[(slot + 1) % ATH_BCBUF];
 
 	DPRINTF(sc, ATH_DBG_BEACON,
-		"%s: slot %d [tsf %llu tsftu %u intval %u] if_id %d\n",
-		__func__, slot, (unsigned long long)tsf, tsftu,
+		"slot %d [tsf %llu tsftu %u intval %u] if_id %d\n",
+		slot, (unsigned long long)tsf, tsftu,
 		intval, if_id);
 
 	bfaddr = 0;
@@ -580,8 +575,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 		 */
 		if (!ath9k_hw_stoptxdma(ah, sc->sc_bhalq)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: beacon queue %u did not stop?\n",
-				__func__, sc->sc_bhalq);
+				"beacon queue %u did not stop?\n", sc->sc_bhalq);
 			/* NB: the HAL still stops DMA, so proceed */
 		}
 
@@ -658,8 +652,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	else if (intval)	/* NB: can be 0 for monitor mode */
 		nexttbtt = roundup(nexttbtt, intval);
 
-	DPRINTF(sc, ATH_DBG_BEACON, "%s: nexttbtt %u intval %u (%u)\n",
-		__func__, nexttbtt, intval, conf.beacon_interval);
+	DPRINTF(sc, ATH_DBG_BEACON, "nexttbtt %u intval %u (%u)\n",
+		nexttbtt, intval, conf.beacon_interval);
 
 	/* Check for ATH9K_M_HOSTAP and sc_nostabeacons for WDS client */
 	if (sc->sc_ah->ah_opmode == ATH9K_M_STA) {
@@ -746,7 +740,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			bs.bs_sleepduration = bs.bs_dtimperiod;
 
 		DPRINTF(sc, ATH_DBG_BEACON,
-			"%s: tsf %llu "
+			"tsf %llu "
 			"tsf:tu %u "
 			"intval %u "
 			"nexttbtt %u "
@@ -758,7 +752,6 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			"maxdur %u "
 			"next %u "
 			"timoffset %u\n",
-			__func__,
 			(unsigned long long)tsf, tsftu,
 			bs.bs_intval,
 			bs.bs_nexttbtt,
@@ -798,8 +791,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			}
 #undef FUDGE
 			DPRINTF(sc, ATH_DBG_BEACON,
-				"%s: IBSS nexttbtt %u intval %u (%u)\n",
-				__func__, nexttbtt,
+				"IBSS nexttbtt %u intval %u (%u)\n",
+				nexttbtt,
 				intval & ~ATH9K_BEACON_RESET_TSF,
 				conf.beacon_interval);
 
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 0e214f7..51c8a3c 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -31,11 +31,11 @@ static const int16_t NOISE_FLOOR[] = { -96, -93, -98, -96, -93, -96 };
 static bool ath9k_hw_nf_in_range(struct ath_hal *ah, s16 nf)
 {
 	if (nf > ATH9K_NF_TOO_LOW) {
-		DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
-			"%s: noise floor value detected (%d) is "
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			"noise floor value detected (%d) is "
 			"lower than what we think is a "
 			"reasonable value (%d)\n",
-			__func__, nf, ATH9K_NF_TOO_LOW);
+			nf, ATH9K_NF_TOO_LOW);
 		return false;
 	}
 	return true;
@@ -116,7 +116,7 @@ static void ath9k_hw_do_getnf(struct ath_hal *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
+	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 		"NF calibrated [ctl] [chain 1] is %d\n", nf);
 	nfarray[1] = nf;
 
@@ -125,7 +125,7 @@ static void ath9k_hw_do_getnf(struct ath_hal *ah,
 			AR_PHY_CH2_MINCCA_PWR);
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
-		DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"NF calibrated [ctl] [chain 2] is %d\n", nf);
 		nfarray[2] = nf;
 	}
@@ -139,7 +139,7 @@ static void ath9k_hw_do_getnf(struct ath_hal *ah,
 
 	if (nf & 0x100)
 		nf = 0 - ((nf ^ 0x1ff) + 1);
-	DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
+	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 		"NF calibrated [ext] [chain 0] is %d\n", nf);
 	nfarray[3] = nf;
 
@@ -161,7 +161,7 @@ static void ath9k_hw_do_getnf(struct ath_hal *ah,
 			AR_PHY_CH2_EXT_MINCCA_PWR);
 		if (nf & 0x100)
 			nf = 0 - ((nf ^ 0x1ff) + 1);
-		DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"NF calibrated [ext] [chain 2] is %d\n", nf);
 		nfarray[5] = nf;
 	}
@@ -187,8 +187,7 @@ static bool getNoiseFloorThresh(struct ath_hal *ah,
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"%s: invalid channel flags 0x%x\n", __func__,
-			chan->channelFlags);
+			"invalid channel flags 0x%x\n", chan->channelFlags);
 		return false;
 	}
 
@@ -206,24 +205,22 @@ static void ath9k_hw_setup_calibration(struct ath_hal *ah,
 	case IQ_MISMATCH_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"%s: starting IQ Mismatch Calibration\n",
-			__func__);
+			"starting IQ Mismatch Calibration\n");
 		break;
 	case ADC_GAIN_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_GAIN);
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"%s: starting ADC Gain Calibration\n", __func__);
+			"starting ADC Gain Calibration\n");
 		break;
 	case ADC_DC_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_PER);
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"%s: starting ADC DC Calibration\n", __func__);
+			"starting ADC DC Calibration\n");
 		break;
 	case ADC_DC_INIT_CAL:
 		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_INIT);
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"%s: starting Init ADC DC Calibration\n",
-			__func__);
+			"starting Init ADC DC Calibration\n");
 		break;
 	}
 
@@ -594,16 +591,16 @@ void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
 
 	if (ichan == NULL) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"%s: invalid channel %u/0x%x; no mapping\n",
-			__func__, chan->channel, chan->channelFlags);
+			"invalid channel %u/0x%x; no mapping\n",
+			chan->channel, chan->channelFlags);
 		return;
 	}
 
 
 	if (currCal->calState != CAL_DONE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"%s: Calibration state incorrect, %d\n",
-			__func__, currCal->calState);
+			"Calibration state incorrect, %d\n",
+			currCal->calState);
 		return;
 	}
 
@@ -612,8 +609,8 @@ void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
 		return;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-		"%s: Resetting Cal %d state for channel %u/0x%x\n",
-		__func__, currCal->calData->calType, chan->channel,
+		"Resetting Cal %d state for channel %u/0x%x\n",
+		currCal->calData->calType, chan->channel,
 		chan->channelFlags);
 
 	ichan->CalValid &= ~currCal->calData->calType;
@@ -705,8 +702,7 @@ int16_t ath9k_hw_getnf(struct ath_hal *ah,
 	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"%s: NF did not complete in calibration window\n",
-			__func__);
+			"NF did not complete in calibration window\n");
 		nf = 0;
 		chan->rawNoiseFloor = nf;
 		return chan->rawNoiseFloor;
@@ -716,8 +712,8 @@ int16_t ath9k_hw_getnf(struct ath_hal *ah,
 		if (getNoiseFloorThresh(ah, chan, &nfThresh)
 		    && nf > nfThresh) {
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-				"%s: noise floor failed detected; "
-				"detected %d, threshold %d\n", __func__,
+				"noise floor failed detected; "
+				"detected %d, threshold %d\n",
 				nf, nfThresh);
 			chan->channelFlags |= CHANNEL_CW_INT;
 		}
@@ -759,9 +755,9 @@ s16 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan)
 
 	ichan = ath9k_regd_check_channel(ah, chan);
 	if (ichan == NULL) {
-		DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
-			"%s: invalid channel %u/0x%x; no mapping\n",
-			__func__, chan->channel, chan->channelFlags);
+		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+			"invalid channel %u/0x%x; no mapping\n",
+			chan->channel, chan->channelFlags);
 		return ATH_DEFAULT_NOISE_FLOOR;
 	}
 	if (ichan->rawNoiseFloor == 0) {
@@ -788,8 +784,8 @@ bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
 
 	if (ichan == NULL) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"%s: invalid channel %u/0x%x; no mapping\n",
-			__func__, chan->channel, chan->channelFlags);
+			"invalid channel %u/0x%x; no mapping\n",
+			chan->channel, chan->channelFlags);
 		return false;
 	}
 
@@ -834,8 +830,8 @@ bool ath9k_hw_init_cal(struct ath_hal *ah,
 
 	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL, 0)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"%s: offset calibration failed to complete in 1ms; "
-			"noisy environment?\n", __func__);
+			"offset calibration failed to complete in 1ms; "
+			"noisy environment?\n");
 		return false;
 	}
 
@@ -850,22 +846,19 @@ bool ath9k_hw_init_cal(struct ath_hal *ah,
 			INIT_CAL(&ahp->ah_adcGainCalData);
 			INSERT_CAL(ahp, &ahp->ah_adcGainCalData);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-				"%s: enabling ADC Gain Calibration.\n",
-				__func__);
+				"enabling ADC Gain Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, chan, ADC_DC_CAL)) {
 			INIT_CAL(&ahp->ah_adcDcCalData);
 			INSERT_CAL(ahp, &ahp->ah_adcDcCalData);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-				"%s: enabling ADC DC Calibration.\n",
-				__func__);
+				"enabling ADC DC Calibration.\n");
 		}
 		if (ath9k_hw_iscal_supported(ah, chan, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ahp->ah_iqCalData);
 			INSERT_CAL(ahp, &ahp->ah_iqCalData);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-				"%s: enabling IQ Calibration.\n",
-				__func__);
+				"enabling IQ Calibration.\n");
 		}
 
 		ahp->ah_cal_list_curr = ahp->ah_cal_list;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index f0c5437..ae32b2c 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -84,52 +84,33 @@ struct ath_node;
 
 static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
-/*************/
-/* Debugging */
-/*************/
-
 enum ATH_DEBUG {
 	ATH_DBG_RESET		= 0x00000001,
-	ATH_DBG_PHY_IO		= 0x00000002,
-	ATH_DBG_REG_IO		= 0x00000004,
-	ATH_DBG_QUEUE		= 0x00000008,
-	ATH_DBG_EEPROM		= 0x00000010,
-	ATH_DBG_NF_CAL		= 0x00000020,
-	ATH_DBG_CALIBRATE	= 0x00000040,
-	ATH_DBG_CHANNEL		= 0x00000080,
-	ATH_DBG_INTERRUPT	= 0x00000100,
-	ATH_DBG_REGULATORY	= 0x00000200,
-	ATH_DBG_ANI		= 0x00000400,
-	ATH_DBG_POWER_MGMT	= 0x00000800,
-	ATH_DBG_XMIT		= 0x00001000,
-	ATH_DBG_BEACON		= 0x00002000,
-	ATH_DBG_RATE		= 0x00004000,
-	ATH_DBG_CONFIG		= 0x00008000,
-	ATH_DBG_KEYCACHE	= 0x00010000,
-	ATH_DBG_AGGR		= 0x00020000,
-	ATH_DBG_FATAL		= 0x00040000,
+	ATH_DBG_REG_IO		= 0x00000002,
+	ATH_DBG_QUEUE		= 0x00000004,
+	ATH_DBG_EEPROM		= 0x00000008,
+	ATH_DBG_CALIBRATE	= 0x00000010,
+	ATH_DBG_CHANNEL		= 0x00000020,
+	ATH_DBG_INTERRUPT	= 0x00000040,
+	ATH_DBG_REGULATORY	= 0x00000080,
+	ATH_DBG_ANI		= 0x00000100,
+	ATH_DBG_POWER_MGMT	= 0x00000200,
+	ATH_DBG_XMIT		= 0x00000400,
+	ATH_DBG_BEACON		= 0x00001000,
+	ATH_DBG_CONFIG		= 0x00002000,
+	ATH_DBG_KEYCACHE	= 0x00004000,
+	ATH_DBG_FATAL		= 0x00008000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
 #define DBG_DEFAULT (ATH_DBG_FATAL)
 
-#define	DPRINTF(sc, _m, _fmt, ...) do {			\
-		if (sc->sc_debug & (_m))                \
-			printk(_fmt , ##__VA_ARGS__);	\
-	} while (0)
-
-/***************************/
-/* Load-time Configuration */
-/***************************/
-
-/* Per-instance load-time (note: NOT run-time) configurations
- * for Atheros Device */
 struct ath_config {
 	u32 ath_aggr_prot;
 	u16 txpowlimit;
 	u16 txpowlimit_override;
-	u8 cabqReadytime; /* Cabq Readytime % */
-	u8 swBeaconProcess; /* Process received beacons in SW (vs HW) */
+	u8 cabqReadytime;
+	u8 swBeaconProcess;
 };
 
 /*************************/
@@ -160,14 +141,13 @@ enum buffer_type {
 };
 
 struct ath_buf_state {
-	int bfs_nframes;			/* # frames in aggregate */
-	u16 bfs_al;				/* length of aggregate */
-	u16 bfs_frmlen;				/* length of frame */
-	int bfs_seqno;				/* sequence number */
-	int bfs_tidno;				/* tid of this frame */
-	int bfs_retries;			/* current retries */
-	u32 bf_type;				/* BUF_* (enum buffer_type) */
-	/* key type use to encrypt this frame */
+	int bfs_nframes;		/* # frames in aggregate */
+	u16 bfs_al;			/* length of aggregate */
+	u16 bfs_frmlen;			/* length of frame */
+	int bfs_seqno;			/* sequence number */
+	int bfs_tidno;			/* tid of this frame */
+	int bfs_retries;		/* current retries */
+	u32 bf_type;			/* BUF_* (enum buffer_type) */
 	u32 bfs_keyix;
 	enum ath9k_key_type bfs_keytype;
 };
@@ -213,13 +193,6 @@ struct ath_buf {
 	dma_addr_t bf_dmacontext;
 };
 
-/*
- * reset the rx buffer.
- * any new fields added to the athbuf and require
- * reset need to be added to this macro.
- * currently bf_status is the only one requires that
- * requires reset.
- */
 #define ATH_RXBUF_RESET(_bf)    ((_bf)->bf_status = 0)
 
 /* hw processing complete, desc processed by hal */
@@ -263,11 +236,8 @@ void ath_rx_cleanup(struct ath_softc *sc);
 int ath_rx_tasklet(struct ath_softc *sc, int flush);
 
 #define ATH_TXBUF               512
-/* max number of transmit attempts (tries) */
 #define ATH_TXMAXTRY            13
-/* max number of 11n transmit attempts (tries) */
 #define ATH_11N_TXMAXTRY        10
-/* max number of tries for management and control frames */
 #define ATH_MGT_TXMAXTRY        4
 #define WME_BA_BMP_SIZE         64
 #define WME_MAX_BA              WME_BA_BMP_SIZE
@@ -279,22 +249,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush);
 	 WME_AC_VO)
 
 
-/* Wireless Multimedia Extension Defines */
-#define WME_AC_BE               0 /* best effort */
-#define WME_AC_BK               1 /* background */
-#define WME_AC_VI               2 /* video */
-#define WME_AC_VO               3 /* voice */
-#define WME_NUM_AC              4
+#define WME_AC_BE   0
+#define WME_AC_BK   1
+#define WME_AC_VI   2
+#define WME_AC_VO   3
+#define WME_NUM_AC  4
 
-/*
- * Data transmit queue state.  One of these exists for each
- * hardware transmit queue.  Packets sent to us from above
- * are assigned to queues based on their priority.  Not all
- * devices support a complete set of hardware transmit queues.
- * For those devices the array sc_ac2q will map multiple
- * priorities to fewer hardware queues (typically all to one
- * hardware queue).
- */
 struct ath_txq {
 	u32 axq_qnum;			/* hardware q number */
 	u32 *axq_link;			/* link ptr in last TX desc */
@@ -372,14 +332,15 @@ struct ath_xmit_status {
 #define ATH_TX_BAR          0x04
 };
 
+/* All RSSI values are noise floor adjusted */
 struct ath_tx_stat {
-	int rssi;		/* RSSI (noise floor ajusted) */
-	int rssictl[ATH_MAX_ANTENNA];	/* RSSI (noise floor ajusted) */
-	int rssiextn[ATH_MAX_ANTENNA];	/* RSSI (noise floor ajusted) */
-	int rateieee;		/* data rate xmitted (IEEE rate code) */
-	int rateKbps;		/* data rate xmitted (Kbps) */
-	int ratecode;		/* phy rate code */
-	int flags;		/* validity flags */
+	int rssi;
+	int rssictl[ATH_MAX_ANTENNA];
+	int rssiextn[ATH_MAX_ANTENNA];
+	int rateieee;
+	int rateKbps;
+	int ratecode;
+	int flags;
 /* if any of ctl,extn chain rssis are valid */
 #define ATH_TX_CHAIN_RSSI_VALID 0x01
 /* if extn chain rssis are valid */
@@ -415,7 +376,7 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
 /**********************/
 
 #define ADDBA_EXCHANGE_ATTEMPTS    10
-#define ATH_AGGR_DELIM_SZ          4   /* delimiter size   */
+#define ATH_AGGR_DELIM_SZ          4
 #define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
 /* number of delimiters for encryption padding */
 #define ATH_AGGR_ENCRYPTDELIM      10
@@ -466,10 +427,9 @@ struct aggr_rifs_param {
 
 /* Per-node aggregation state */
 struct ath_node_aggr {
-	struct ath_atx tx;	/* node transmit state */
+	struct ath_atx tx;
 };
 
-/* driver-specific node state */
 struct ath_node {
 	struct ath_softc *an_sc;
 	struct ath_node_aggr an_aggr;
@@ -500,12 +460,11 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 #define ATH_SET_VAP_BSSID_MASK(bssid_mask) \
 	((bssid_mask)[0] &= ~(((ATH_BCBUF-1)<<2)|0x02))
 
-/* driver-specific vap state */
 struct ath_vap {
-	int av_bslot;			/* beacon slot index */
-	enum ath9k_opmode av_opmode;	/* VAP operational mode */
-	struct ath_buf *av_bcbuf;	/* beacon buffer */
-	struct ath_tx_control av_btxctl;  /* txctl information for beacon */
+	int av_bslot;
+	enum ath9k_opmode av_opmode;
+	struct ath_buf *av_bcbuf;
+	struct ath_tx_control av_btxctl;
 };
 
 /*******************/
@@ -518,12 +477,11 @@ struct ath_vap {
  * number of beacon intervals, the game's up.
  */
 #define BSTUCK_THRESH           	(9 * ATH_BCBUF)
-#define	ATH_BCBUF               	4   /* number of beacon buffers */
-#define ATH_DEFAULT_BINTVAL     	100 /* default beacon interval in TU */
+#define	ATH_BCBUF               	4
+#define ATH_DEFAULT_BINTVAL     	100 /* TU */
 #define ATH_DEFAULT_BMISS_LIMIT 	10
 #define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
 
-/* beacon configuration */
 struct ath_beacon_config {
 	u16 beacon_interval;
 	u16 listen_interval;
@@ -674,18 +632,18 @@ struct ath_softc {
 	u8 sc_tx_chainmask;
 	u8 sc_rx_chainmask;
 	enum ath9k_int sc_imask;
-	enum wireless_mode sc_curmode;	/* current phy mode */
+	enum wireless_mode sc_curmode;
 	enum PROT_MODE sc_protmode;
 
-	u8 sc_nbcnvaps;			/* # of vaps sending beacons */
-	u16 sc_nvaps;			/* # of active virtual ap's */
+	u8 sc_nbcnvaps;
+	u16 sc_nvaps;
 	struct ieee80211_vif *sc_vaps[ATH_BCBUF];
 
 	u8 sc_mcastantenna;
-	u8 sc_defant;			/* current default antenna */
-	u8 sc_rxotherant;		/* rx's on non-default antenna */
+	u8 sc_defant;
+	u8 sc_rxotherant;
 
-	struct ath9k_node_stats sc_halstats; /* station-mode rssi stats */
+	struct ath9k_node_stats sc_halstats;
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
 	enum ath9k_ht_macmode tx_chan_width;
 
@@ -699,22 +657,22 @@ struct ath_softc {
 	} sc_updateslot;	/* slot time update fsm */
 
 	/* Crypto */
-	u32 sc_keymax;		/* size of key cache */
-	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);	/* key use bit map */
+	u32 sc_keymax;
+	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);
 	u8 sc_splitmic;		/* split TKIP MIC keys */
 
 	/* RX */
 	struct list_head sc_rxbuf;
 	struct ath_descdma sc_rxdma;
-	int sc_rxbufsize;	/* rx size based on mtu */
-	u32 *sc_rxlink;		/* link ptr in last RX desc */
+	int sc_rxbufsize;
+	u32 *sc_rxlink;
 
 	/* TX */
 	struct list_head sc_txbuf;
 	struct ath_txq sc_txq[ATH9K_NUM_TX_QUEUES];
 	struct ath_descdma sc_txdma;
 	u32 sc_txqsetup;
-	int sc_haltype2q[ATH9K_WME_AC_VO+1]; /* HAL WME	AC -> h/w qnum */
+	int sc_haltype2q[ATH9K_WME_AC_VO+1];
 	u16 seq_no; /* TX sequence number */
 
 	/* Beacon */
@@ -724,13 +682,13 @@ struct ath_softc {
 	struct list_head sc_bbuf;
 	u32 sc_bhalq;
 	u32 sc_bmisscount;
-	u32 ast_be_xmit;	/* beacons transmitted */
+	u32 ast_be_xmit;
 	u64 bc_tstamp;
 
 	/* Rate */
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
 	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
-	u8 sc_protrix;		/* protection rate index */
+	u8 sc_protrix;
 
 	/* Channel, Band */
 	struct ieee80211_channel channels[IEEE80211_NUM_BANDS][ATH_CHAN_MAX];
@@ -755,6 +713,7 @@ struct ath_softc {
 	struct ath_ani sc_ani;
 };
 
+void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
 int ath_reset(struct ath_softc *sc, bool retry_tx);
 int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 466dbce..e180c90 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -116,7 +116,7 @@ static int ath9k_hw_flash_map(struct ath_hal *ah)
 
 	if (!ahp->ah_cal_mem) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"%s: cannot remap eeprom region \n", __func__);
+			"cannot remap eeprom region \n");
 		return -EIO;
 	}
 
@@ -149,7 +149,7 @@ static bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 
 	if (!ath9k_hw_use_flash(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"%s: Reading from EEPROM, not flash\n", __func__);
+			"Reading from EEPROM, not flash\n");
 		ar5416_eep_start_loc = 256;
 	}
 
@@ -162,8 +162,7 @@ static bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
 					 eep_data)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"%s: Unable to read eeprom region \n",
-				__func__);
+				"Unable to read eeprom region \n");
 			return false;
 		}
 		eep_data++;
@@ -185,12 +184,11 @@ static int ath9k_hw_check_eeprom(struct ath_hal *ah)
 		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
 					 &magic)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"%s: Reading Magic # failed\n", __func__);
+				"Reading Magic # failed\n");
 			return false;
 		}
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "%s: Read Magic = 0x%04X\n",
-			 __func__, magic);
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
@@ -1205,11 +1203,11 @@ bool ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 					((pdadcValues[4 * j + 3] & 0xFF) << 24);
 				REG_WRITE(ah, regOffset, reg32);
 
-				DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 					"PDADC (%d,%4x): %4.4x %8.8x\n",
 					i, regChainOffset, regOffset,
 					reg32);
-				DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
+				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 					"PDADC: Chain %d | PDADC %3d Value %3d | "
 					"PDADC %3d Value %3d | PDADC %3d Value %3d | "
 					"PDADC %3d Value %3d |\n",
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index ae7b1d6..ffec650 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -104,9 +104,10 @@ bool ath9k_hw_wait(struct ath_hal *ah, u32 reg, u32 mask, u32 val)
 
 		udelay(AH_TIME_QUANTUM);
 	}
-	DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
-		"%s: timeout on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
-		__func__, reg, REG_READ(ah, reg), mask, val);
+
+	DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+		"timeout on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
+		reg, REG_READ(ah, reg), mask, val);
 
 	return false;
 }
@@ -188,8 +189,8 @@ u16 ath9k_hw_computetxtime(struct ath_hal *ah,
 		}
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
-			"%s: unknown phy %u (rate ix %u)\n", __func__,
+		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+			"Unknown phy %u (rate ix %u)\n",
 			rates->info[rateix].phy, rateix);
 		txTime = 0;
 		break;
@@ -355,9 +356,9 @@ static bool ath9k_hw_chip_test(struct ath_hal *ah)
 			rdData = REG_READ(ah, addr);
 			if (rdData != wrData) {
 				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-					"%s: address test failed "
+					"address test failed "
 					"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
-					__func__, addr, wrData, rdData);
+					addr, wrData, rdData);
 				return false;
 			}
 		}
@@ -367,9 +368,9 @@ static bool ath9k_hw_chip_test(struct ath_hal *ah)
 			rdData = REG_READ(ah, addr);
 			if (wrData != rdData) {
 				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-					"%s: address test failed "
+					"address test failed "
 					"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
-					__func__, addr, wrData, rdData);
+					addr, wrData, rdData);
 				return false;
 			}
 		}
@@ -449,8 +450,7 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 	ahp = kzalloc(sizeof(struct ath_hal_5416), GFP_KERNEL);
 	if (ahp == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: cannot allocate memory for state block\n",
-			__func__);
+			"Cannot allocate memory for state block\n");
 		*status = -ENOMEM;
 		return NULL;
 	}
@@ -497,8 +497,7 @@ static int ath9k_hw_rfattach(struct ath_hal *ah)
 	rfStatus = ath9k_hw_init_rf(ah, &ecode);
 	if (!rfStatus) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-			"%s: RF setup failed, status %u\n", __func__,
-			ecode);
+			"RF setup failed, status %u\n", ecode);
 		return ecode;
 	}
 
@@ -523,9 +522,9 @@ static int ath9k_hw_rf_claim(struct ath_hal *ah)
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"%s: 5G Radio Chip Rev 0x%02X is not "
+			"5G Radio Chip Rev 0x%02X is not "
 			"supported by this driver\n",
-			__func__, ah->ah_analog5GhzRev);
+			ah->ah_analog5GhzRev);
 		return -EOPNOTSUPP;
 	}
 
@@ -551,7 +550,7 @@ static int ath9k_hw_init_macaddr(struct ath_hal *ah)
 	}
 	if (sum == 0 || sum == 0xffff * 3) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"%s: mac address read failed: %s\n", __func__,
+			"mac address read failed: %s\n",
 			print_mac(mac, ahp->ah_macaddr));
 		return -EADDRNOTAVAIL;
 	}
@@ -613,7 +612,7 @@ static int ath9k_hw_post_attach(struct ath_hal *ah)
 
 	if (!ath9k_hw_chip_test(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-			"%s: hardware self-test failed\n", __func__);
+			"hardware self-test failed\n");
 		return -ENODEV;
 	}
 
@@ -659,15 +658,13 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		ahp->ah_intrMitigation = true;
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: couldn't reset chip\n",
-			 __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "Couldn't reset chip\n");
 		ecode = -EIO;
 		goto bad;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: couldn't wakeup chip\n",
-			 __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "Couldn't wakeup chip\n");
 		ecode = -EIO;
 		goto bad;
 	}
@@ -683,17 +680,16 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	}
 
 	DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-		"%s: serialize_regmode is %d\n",
-		__func__, ah->ah_config.serialize_regmode);
+		"serialize_regmode is %d\n",
+		ah->ah_config.serialize_regmode);
 
 	if ((ah->ah_macVersion != AR_SREV_VERSION_5416_PCI) &&
 	    (ah->ah_macVersion != AR_SREV_VERSION_5416_PCIE) &&
 	    (ah->ah_macVersion != AR_SREV_VERSION_9160) &&
 	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-			"%s: Mac Chip Rev 0x%02x.%x is not supported by "
-			"this driver\n", __func__,
-			ah->ah_macVersion, ah->ah_macRev);
+			"Mac Chip Rev 0x%02x.%x is not supported by "
+			"this driver\n", ah->ah_macVersion, ah->ah_macRev);
 		ecode = -EOPNOTSUPP;
 		goto bad;
 	}
@@ -738,7 +734,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	}
 
 	DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-		"%s: This Mac Chip Rev 0x%02x.%x is \n", __func__,
+		"This Mac Chip Rev 0x%02x.%x is \n",
 		ah->ah_macVersion, ah->ah_macRev);
 
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
@@ -875,7 +871,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 #endif
 	if (!ath9k_hw_fill_cap_info(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-			"%s:failed ath9k_hw_fill_cap_info\n", __func__);
+			"failed ath9k_hw_fill_cap_info\n");
 		ecode = -EINVAL;
 		goto bad;
 	}
@@ -883,8 +879,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	ecode = ath9k_hw_init_macaddr(ah);
 	if (ecode != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-			"%s: failed initializing mac address\n",
-			__func__);
+			"failed initializing mac address\n");
 		goto bad;
 	}
 
@@ -1081,8 +1076,7 @@ static bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u32 us)
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad ack timeout %u\n",
-			 __func__, us);
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad ack timeout %u\n", us);
 		ahp->ah_acktimeout = (u32) -1;
 		return false;
 	} else {
@@ -1098,8 +1092,7 @@ static bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u32 us)
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad cts timeout %u\n",
-			 __func__, us);
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad cts timeout %u\n", us);
 		ahp->ah_ctstimeout = (u32) -1;
 		return false;
 	} else {
@@ -1116,7 +1109,7 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hal *ah, u32 tu)
 
 	if (tu > 0xFFFF) {
 		DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
-			"%s: bad global tx timeout %u\n", __func__, tu);
+			"bad global tx timeout %u\n", tu);
 		ahp->ah_globaltxtimeout = (u32) -1;
 		return false;
 	} else {
@@ -1130,8 +1123,8 @@ static void ath9k_hw_init_user_settings(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "--AP %s ahp->ah_miscMode 0x%x\n",
-		 __func__, ahp->ah_miscMode);
+	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "ahp->ah_miscMode 0x%x\n",
+		ahp->ah_miscMode);
 
 	if (ahp->ah_miscMode != 0)
 		REG_WRITE(ah, AR_PCU_MISC,
@@ -1177,7 +1170,7 @@ struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_ANY,
-			 "devid=0x%x not supported.\n", devid);
+			"devid=0x%x not supported.\n", devid);
 		ah = NULL;
 		*error = -ENXIO;
 		break;
@@ -1356,13 +1349,13 @@ static int ath9k_hw_process_ini(struct ath_hal *ah,
 					  (u32) ah->ah_powerLimit));
 	if (status != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
-			"%s: error init'ing transmit power\n", __func__);
+			"error init'ing transmit power\n");
 		return -EIO;
 	}
 
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-			"%s: ar5416SetRfRegs failed\n", __func__);
+			"ar5416SetRfRegs failed\n");
 		return -EIO;
 	}
 
@@ -1534,8 +1527,7 @@ static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 	REG_WRITE(ah, (u16) (AR_RTC_RC), 0);
 	if (!ath9k_hw_wait(ah, (u16) (AR_RTC_RC), AR_RTC_RC_M, 0)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-			"%s: RTC stuck in MAC reset\n",
-			__func__);
+			"RTC stuck in MAC reset\n");
 		return false;
 	}
 
@@ -1562,8 +1554,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 			   AR_RTC_STATUS,
 			   AR_RTC_STATUS_M,
 			   AR_RTC_STATUS_ON)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: RTC not waking up\n",
-			 __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "RTC not waking up\n");
 		return false;
 	}
 
@@ -1642,9 +1633,8 @@ static struct ath9k_channel *ath9k_hw_check_chan(struct ath_hal *ah,
 {
 	if (!(IS_CHAN_2GHZ(chan) ^ IS_CHAN_5GHZ(chan))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"%s: invalid channel %u/0x%x; not marked as "
-			"2GHz or 5GHz\n", __func__, chan->channel,
-			chan->channelFlags);
+			"invalid channel %u/0x%x; not marked as "
+			"2GHz or 5GHz\n", chan->channel, chan->channelFlags);
 		return NULL;
 	}
 
@@ -1653,9 +1643,9 @@ static struct ath9k_channel *ath9k_hw_check_chan(struct ath_hal *ah,
 	    !IS_CHAN_HT20(chan) &&
 	    !IS_CHAN_HT40(chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"%s: invalid channel %u/0x%x; not marked as "
+			"invalid channel %u/0x%x; not marked as "
 			"OFDM or CCK or HT20 or HT40PLUS or HT40MINUS\n",
-			__func__, chan->channel, chan->channelFlags);
+			chan->channel, chan->channelFlags);
 		return NULL;
 	}
 
@@ -1671,8 +1661,7 @@ static bool ath9k_hw_channel_change(struct ath_hal *ah,
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
 		if (ath9k_hw_numtxpending(ah, qnum)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-				"%s: Transmit frames pending on queue %d\n",
-				__func__, qnum);
+				"Transmit frames pending on queue %d\n", qnum);
 			return false;
 		}
 	}
@@ -1680,8 +1669,8 @@ static bool ath9k_hw_channel_change(struct ath_hal *ah,
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
 	if (!ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
 			   AR_PHY_RFBUS_GRANT_EN)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_PHY_IO,
-			"%s: Could not kill baseband RX\n", __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+			"Could not kill baseband RX\n");
 		return false;
 	}
 
@@ -1690,13 +1679,13 @@ static bool ath9k_hw_channel_change(struct ath_hal *ah,
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		if (!(ath9k_hw_ar9280_set_channel(ah, chan))) {
 			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-				"%s: failed to set channel\n", __func__);
+				"failed to set channel\n");
 			return false;
 		}
 	} else {
 		if (!(ath9k_hw_set_channel(ah, chan))) {
 			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-				"%s: failed to set channel\n", __func__);
+				"failed to set channel\n");
 			return false;
 		}
 	}
@@ -1708,7 +1697,7 @@ static bool ath9k_hw_channel_change(struct ath_hal *ah,
 				 min((u32) MAX_RATE_POWER,
 				     (u32) ah->ah_powerLimit)) != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"%s: error init'ing transmit power\n", __func__);
+			"error init'ing transmit power\n");
 		return false;
 	}
 
@@ -2212,8 +2201,8 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 
 	if (ath9k_hw_check_chan(ah, chan) == NULL) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"%s: invalid channel %u/0x%x; no mapping\n",
-			__func__, chan->channel, chan->channelFlags);
+			"invalid channel %u/0x%x; no mapping\n",
+			chan->channel, chan->channelFlags);
 		ecode = -EINVAL;
 		goto bad;
 	}
@@ -2255,8 +2244,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	ath9k_hw_mark_phy_inactive(ah);
 
 	if (!ath9k_hw_chip_reset(ah, chan)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: chip reset failed\n",
-			 __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "chip reset failed\n");
 		ecode = -EINVAL;
 		goto bad;
 	}
@@ -2290,7 +2278,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 
 	if (!ath9k_hw_eeprom_set_board_values(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"%s: error setting board options\n", __func__);
+			"error setting board options\n");
 		ecode = -EIO;
 		goto bad;
 	}
@@ -2380,15 +2368,13 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 		mask = REG_READ(ah, AR_CFG);
 		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-				"%s CFG Byte Swap Set 0x%x\n", __func__,
-				mask);
+				"CFG Byte Swap Set 0x%x\n", mask);
 		} else {
 			mask =
 				INIT_CONFIG_STATUS | AR_CFG_SWRB | AR_CFG_SWTB;
 			REG_WRITE(ah, AR_CFG, mask);
 			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-				"%s Setting CFG 0x%x\n", __func__,
-				REG_READ(ah, AR_CFG));
+				"Setting CFG 0x%x\n", REG_READ(ah, AR_CFG));
 		}
 	} else {
 #ifdef __BIG_ENDIAN
@@ -2413,7 +2399,7 @@ bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry)
 
 	if (entry >= ah->ah_caps.keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-			"%s: entry %u out of range\n", __func__, entry);
+			"entry %u out of range\n", entry);
 		return false;
 	}
 
@@ -2450,7 +2436,7 @@ bool ath9k_hw_keysetmac(struct ath_hal *ah, u16 entry, const u8 *mac)
 
 	if (entry >= ah->ah_caps.keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-			"%s: entry %u out of range\n", __func__, entry);
+			"entry %u out of range\n", entry);
 		return false;
 	}
 
@@ -2486,7 +2472,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 
 	if (entry >= pCap->keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-			"%s: entry %u out of range\n", __func__, entry);
+			"entry %u out of range\n", entry);
 		return false;
 	}
 
@@ -2497,8 +2483,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 	case ATH9K_CIPHER_AES_CCM:
 		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-				"%s: AES-CCM not supported by "
-				"mac rev 0x%x\n", __func__,
+				"AES-CCM not supported by mac rev 0x%x\n",
 				ah->ah_macRev);
 			return false;
 		}
@@ -2509,16 +2494,14 @@ bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 		if (ATH9K_IS_MIC_ENABLED(ah)
 		    && entry + 64 >= pCap->keycache_size) {
 			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-				"%s: entry %u inappropriate for TKIP\n",
-				__func__, entry);
+				"entry %u inappropriate for TKIP\n", entry);
 			return false;
 		}
 		break;
 	case ATH9K_CIPHER_WEP:
 		if (k->kv_len < LEN_WEP40) {
 			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-				"%s: WEP key length %u too small\n",
-				__func__, k->kv_len);
+				"WEP key length %u too small\n", k->kv_len);
 			return false;
 		}
 		if (k->kv_len <= LEN_WEP40)
@@ -2533,8 +2516,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
-			"%s: cipher %u not supported\n", __func__,
-			k->kv_type);
+			"cipher %u not supported\n", k->kv_type);
 		return false;
 	}
 
@@ -2683,8 +2665,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 		}
 		if (i == 0) {
 			DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
-				"%s: Failed to wakeup in %uus\n",
-				__func__, POWER_UP_TIME / 20);
+				"Failed to wakeup in %uus\n", POWER_UP_TIME / 20);
 			return false;
 		}
 	}
@@ -2706,7 +2687,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 	};
 	int status = true, setChip = true;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT, "%s: %s -> %s (%s)\n", __func__,
+	DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT, "%s -> %s (%s)\n",
 		modes[ahp->ah_powerMode], modes[mode],
 		setChip ? "set chip " : "");
 
@@ -2723,7 +2704,7 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
-			"%s: unknown power mode %u\n", __func__, mode);
+			"Unknown power mode %u\n", mode);
 		return false;
 	}
 	ahp->ah_powerMode = mode;
@@ -2900,8 +2881,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 
 		if (isr & AR_ISR_RXORN) {
 			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
-				"%s: receive FIFO overrun interrupt\n",
-				__func__);
+				"receive FIFO overrun interrupt\n");
 		}
 
 		if (!AR_SREV_9100(ah)) {
@@ -2927,27 +2907,23 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 		if (fatal_int) {
 			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
 				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
-					"%s: received PCI FATAL interrupt\n",
-					__func__);
+					"received PCI FATAL interrupt\n");
 			}
 			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
 				DPRINTF(ah->ah_sc, ATH_DBG_ANY,
-					"%s: received PCI PERR interrupt\n",
-					__func__);
+					"received PCI PERR interrupt\n");
 			}
 		}
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
 			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
-				"%s: AR_INTR_SYNC_RADM_CPL_TIMEOUT\n",
-				__func__);
+				"AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
 			REG_WRITE(ah, AR_RC, 0);
 			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
 			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
-				"%s: AR_INTR_SYNC_LOCAL_TIMEOUT\n",
-				__func__);
+				"AR_INTR_SYNC_LOCAL_TIMEOUT\n");
 		}
 
 		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
@@ -2969,12 +2945,10 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 	u32 mask, mask2;
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: 0x%x => 0x%x\n", __func__,
-		 omask, ints);
+	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
 
 	if (omask & ATH9K_INT_GLOBAL) {
-		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: disable IER\n",
-			 __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "disable IER\n");
 		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
 		(void) REG_READ(ah, AR_IER);
 		if (!AR_SREV_9100(ah)) {
@@ -3029,8 +3003,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 			mask2 |= AR_IMR_S2_CST;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: new IMR 0x%x\n", __func__,
-		 mask);
+	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
 	REG_WRITE(ah, AR_IMR, mask);
 	mask = REG_READ(ah, AR_IMR_S2) & ~(AR_IMR_S2_TIM |
 					   AR_IMR_S2_DTIM |
@@ -3050,8 +3023,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 	}
 
 	if (ints & ATH9K_INT_GLOBAL) {
-		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: enable IER\n",
-			 __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "enable IER\n");
 		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
 		if (!AR_SREV_9100(ah)) {
 			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
@@ -3157,14 +3129,10 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 	else
 		nextTbtt = bs->bs_nexttbtt;
 
-	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "%s: next DTIM %d\n", __func__,
-		 bs->bs_nextdtim);
-	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "%s: next beacon %d\n", __func__,
-		 nextTbtt);
-	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "%s: beacon period %d\n", __func__,
-		 beaconintval);
-	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "%s: DTIM period %d\n", __func__,
-		 dtimperiod);
+	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "next DTIM %d\n", bs->bs_nextdtim);
+	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "next beacon %d\n", nextTbtt);
+	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
+	DPRINTF(ah->ah_sc, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
 
 	REG_WRITE(ah, AR_NEXT_DTIM,
 		  TU_TO_USEC(bs->bs_nextdtim - SLEEP_SLOP));
@@ -3217,8 +3185,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 		else if (ah->ah_currentRD == 0x41)
 			ah->ah_currentRD = 0x43;
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: regdomain mapped to 0x%x\n", __func__,
-			ah->ah_currentRD);
+			"regdomain mapped to 0x%x\n", ah->ah_currentRD);
 	}
 
 	eeval = ath9k_hw_get_eeprom(ah, EEP_OP_MODE);
@@ -3824,8 +3791,7 @@ void ath9k_hw_reset_tsf(struct ath_hal *ah)
 		count++;
 		if (count > 10) {
 			DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-				"%s: AR_SLP32_TSF_WRITE_STATUS limit exceeded\n",
-				__func__);
+				"AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
 			break;
 		}
 		udelay(10);
@@ -3850,8 +3816,7 @@ bool ath9k_hw_setslottime(struct ath_hal *ah, u32 us)
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: bad slot time %u\n",
-			 __func__, us);
+		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "bad slot time %u\n", us);
 		ahp->ah_slottime = (u32) -1;
 		return false;
 	} else {
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index 36955e0..8d2b139 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -25,10 +25,10 @@ static void ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
-		"%s: tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
-		__func__, ahp->ah_txOkInterruptMask,
-		ahp->ah_txErrInterruptMask, ahp->ah_txDescInterruptMask,
-		ahp->ah_txEolInterruptMask, ahp->ah_txUrnInterruptMask);
+		"tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
+		ahp->ah_txOkInterruptMask, ahp->ah_txErrInterruptMask,
+		ahp->ah_txDescInterruptMask, ahp->ah_txEolInterruptMask,
+		ahp->ah_txUrnInterruptMask);
 
 	REG_WRITE(ah, AR_IMR_S0,
 		  SM(ahp->ah_txOkInterruptMask, AR_IMR_S0_QCU_TXOK)
@@ -126,7 +126,7 @@ bool ath9k_hw_puttxbuf(struct ath_hal *ah, u32 q, u32 txdp)
 
 bool ath9k_hw_txstart(struct ath_hal *ah, u32 q)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: queue %u\n", __func__, q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "queue %u\n", q);
 
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
 
@@ -207,9 +207,8 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q)
 				break;
 
 			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-				"%s: TSF have moved while trying to set "
-				"quiet time TSF: 0x%08x\n",
-				__func__, tsfLow);
+				"TSF have moved while trying to set "
+				"quiet time TSF: 0x%08x\n", tsfLow);
 		}
 
 		REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
@@ -222,9 +221,8 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u32 q)
 		while (ath9k_hw_numtxpending(ah, q)) {
 			if ((--wait) == 0) {
 				DPRINTF(ah->ah_sc, ATH_DBG_XMIT,
-					"%s: Failed to stop Tx DMA in 100 "
-					"msec after killing last frame\n",
-					__func__);
+					"Failed to stop Tx DMA in 100 "
+					"msec after killing last frame\n");
 				break;
 			}
 			udelay(100);
@@ -523,19 +521,17 @@ bool ath9k_hw_set_txq_props(struct ath_hal *ah, int q,
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
-			 __func__, q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
 		return false;
 	}
 
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue\n",
-			 __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
 		return false;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: queue %p\n", __func__, qi);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "queue %p\n", qi);
 
 	qi->tqi_ver = qinfo->tqi_ver;
 	qi->tqi_subtype = qinfo->tqi_subtype;
@@ -593,15 +589,13 @@ bool ath9k_hw_get_txq_props(struct ath_hal *ah, int q,
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
-			 __func__, q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
 		return false;
 	}
 
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue\n",
-			 __func__);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue\n");
 		return false;
 	}
 
@@ -651,22 +645,21 @@ int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
 				break;
 		if (q == pCap->total_queues) {
 			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-				"%s: no available tx queue\n", __func__);
+				"no available tx queue\n");
 			return -1;
 		}
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: bad tx queue type %u\n",
-			__func__, type);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "bad tx queue type %u\n", type);
 		return -1;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: queue %u\n", __func__, q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "queue %u\n", q);
 
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type != ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-			"%s: tx queue %u already active\n", __func__, q);
+			"tx queue %u already active\n", q);
 		return -1;
 	}
 	memset(qi, 0, sizeof(struct ath9k_tx_queue_info));
@@ -697,19 +690,16 @@ bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q)
 	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
-			 __func__, q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
 		return false;
 	}
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue %u\n",
-			 __func__, q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue %u\n", q);
 		return false;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: release queue %u\n",
-		__func__, q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "release queue %u\n", q);
 
 	qi->tqi_type = ATH9K_TX_QUEUE_INACTIVE;
 	ahp->ah_txOkInterruptMask &= ~(1 << q);
@@ -731,19 +721,17 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q)
 	u32 cwMin, chanCwMin, value;
 
 	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
-			 __func__, q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "invalid queue num %u\n", q);
 		return false;
 	}
 
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue %u\n",
-			 __func__, q);
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "inactive queue %u\n", q);
 		return true;
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: reset queue %u\n", __func__, q);
+	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "reset queue %u\n", q);
 
 	if (qi->tqi_cwmin == ATH9K_TXQ_USEDEFAULT) {
 		if (chan && IS_CHAN_B(chan))
@@ -976,8 +964,7 @@ bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set)
 
 			reg = REG_READ(ah, AR_OBS_BUS_1);
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-				"%s: rx failed to go idle in 10 ms RXSM=0x%x\n",
-				__func__, reg);
+				"rx failed to go idle in 10 ms RXSM=0x%x\n", reg);
 
 			return false;
 		}
@@ -1022,9 +1009,8 @@ bool ath9k_hw_stopdmarecv(struct ath_hal *ah)
 
 	if (!ath9k_hw_wait(ah, AR_CR, AR_CR_RXE, 0)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
-			"%s: dma failed to stop in 10ms\n"
+			"dma failed to stop in 10ms\n"
 			"AR_CR=0x%08x\nAR_DIAG_SW=0x%08x\n",
-			__func__,
 			REG_READ(ah, AR_CR), REG_READ(ah, AR_DIAG_SW));
 		return false;
 	} else {
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index d1ddb07..4fbe34e 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -38,6 +38,21 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 
 static void ath_detach(struct ath_softc *sc);
 
+void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...)
+{
+	if (!sc)
+		return;
+
+	if (sc->sc_debug & dbg_mask) {
+		va_list args;
+
+		va_start(args, fmt);
+		printk(KERN_DEBUG "ath9k: ");
+		vprintk(fmt, args);
+		va_end(args);
+	}
+}
+
 /* return bus cachesize in 4B word units */
 
 static void bus_read_cachesize(struct ath_softc *sc, int *csz)
@@ -175,8 +190,8 @@ static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
 		rate[i].bitrate = rate_table->info[i].ratekbps / 100;
 		rate[i].hw_value = rate_table->info[i].ratecode;
 		sband->n_bitrates++;
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Rate: %2dMbps, ratecode: %2d\n",
-			__func__, rate[i].bitrate / 10,	rate[i].hw_value);
+		DPRINTF(sc, ATH_DBG_CONFIG, "Rate: %2dMbps, ratecode: %2d\n",
+			rate[i].bitrate / 10, rate[i].hw_value);
 	}
 }
 
@@ -198,9 +213,9 @@ static int ath_setup_channels(struct ath_softc *sc)
 				      &nregclass, CTRY_DEFAULT, false, 1)) {
 		u32 rd = ah->ah_currentRD;
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to collect channel list; "
+			"Unable to collect channel list; "
 			"regdomain likely %u country code %u\n",
-			__func__, rd, CTRY_DEFAULT);
+			rd, CTRY_DEFAULT);
 		return -EINVAL;
 	}
 
@@ -223,9 +238,9 @@ static int ath_setup_channels(struct ath_softc *sc)
 
 			band_2ghz->n_channels = ++a;
 
-			DPRINTF(sc, ATH_DBG_CONFIG, "%s: 2MHz channel: %d, "
+			DPRINTF(sc, ATH_DBG_CONFIG, "2MHz channel: %d, "
 				"channelFlags: 0x%x\n",
-				__func__, c->channel, c->channelFlags);
+				c->channel, c->channelFlags);
 		} else if (IS_CHAN_5GHZ(c)) {
 			chan_5ghz[b].band = IEEE80211_BAND_5GHZ;
 			chan_5ghz[b].center_freq = c->channel;
@@ -238,9 +253,9 @@ static int ath_setup_channels(struct ath_softc *sc)
 
 			band_5ghz->n_channels = ++b;
 
-			DPRINTF(sc, ATH_DBG_CONFIG, "%s: 5MHz channel: %d, "
+			DPRINTF(sc, ATH_DBG_CONFIG, "5MHz channel: %d, "
 				"channelFlags: 0x%x\n",
-				__func__, c->channel, c->channelFlags);
+				c->channel, c->channelFlags);
 		}
 	}
 
@@ -274,9 +289,9 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 		 * hardware at the new frequency, and then re-enable
 		 * the relevant bits of the h/w.
 		 */
-		ath9k_hw_set_interrupts(ah, 0);	/* disable interrupts */
-		ath_draintxq(sc, false);	/* clear pending tx frames */
-		stopped = ath_stoprecv(sc);	/* turn off frame recv */
+		ath9k_hw_set_interrupts(ah, 0);
+		ath_draintxq(sc, false);
+		stopped = ath_stoprecv(sc);
 
 		/* XXX: do not flush receive queue here. We don't want
 		 * to flush data frames already in queue because of
@@ -286,8 +301,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 			fastcc = false;
 
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"%s: (%u MHz) -> (%u MHz), cflags:%x, chanwidth: %d\n",
-			__func__,
+			"(%u MHz) -> (%u MHz), cflags:%x, chanwidth: %d\n",
 			sc->sc_ah->ah_curchan->channel,
 			hchan->channel, hchan->channelFlags, sc->tx_chan_width);
 
@@ -296,8 +310,8 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 				    sc->sc_ht_extprotspacing, fastcc, &status)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: unable to reset channel %u (%uMhz) "
-				"flags 0x%x hal status %u\n", __func__,
+				"Unable to reset channel %u (%uMhz) "
+				"flags 0x%x hal status %u\n",
 				ath9k_hw_mhz2ieee(ah, hchan->channel,
 						  hchan->channelFlags),
 				hchan->channel, hchan->channelFlags, status);
@@ -311,7 +325,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 		if (ath_startrecv(sc) != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: unable to restart recv logic\n", __func__);
+				"Unable to restart recv logic\n");
 			return -EIO;
 		}
 
@@ -352,8 +366,7 @@ static void ath_ani_calibrate(unsigned long data)
 	/* Long calibration runs independently of short calibration. */
 	if ((timestamp - sc->sc_ani.sc_longcal_timer) >= ATH_LONG_CALINTERVAL) {
 		longcal = true;
-		DPRINTF(sc, ATH_DBG_ANI, "%s: longcal @%lu\n",
-			__func__, jiffies);
+		DPRINTF(sc, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
 		sc->sc_ani.sc_longcal_timer = timestamp;
 	}
 
@@ -362,8 +375,7 @@ static void ath_ani_calibrate(unsigned long data)
 		if ((timestamp - sc->sc_ani.sc_shortcal_timer) >=
 		    ATH_SHORT_CALINTERVAL) {
 			shortcal = true;
-			DPRINTF(sc, ATH_DBG_ANI, "%s: shortcal @%lu\n",
-			       __func__, jiffies);
+			DPRINTF(sc, ATH_DBG_ANI, "shortcal @%lu\n", jiffies);
 			sc->sc_ani.sc_shortcal_timer = timestamp;
 			sc->sc_ani.sc_resetcal_timer = timestamp;
 		}
@@ -404,15 +416,13 @@ static void ath_ani_calibrate(unsigned long data)
 							       ah->ah_curchan);
 
 				DPRINTF(sc, ATH_DBG_ANI,
-					"%s: calibrate chan %u/%x nf: %d\n",
-					 __func__,
+					"calibrate chan %u/%x nf: %d\n",
 					ah->ah_curchan->channel,
 					ah->ah_curchan->channelFlags,
 					sc->sc_ani.sc_noise_floor);
 			} else {
 				DPRINTF(sc, ATH_DBG_ANY,
-					"%s: calibrate chan %u/%x failed\n",
-					 __func__,
+					"calibrate chan %u/%x failed\n",
 					ah->ah_curchan->channel,
 					ah->ah_curchan->channelFlags);
 			}
@@ -449,8 +459,8 @@ static void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 		sc->sc_rx_chainmask = 1;
 	}
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: tx chmask: %d, rx chmask: %d\n",
-		__func__, sc->sc_tx_chainmask, sc->sc_rx_chainmask);
+	DPRINTF(sc, ATH_DBG_CONFIG, "tx chmask: %d, rx chmask: %d\n",
+		sc->sc_tx_chainmask, sc->sc_rx_chainmask);
 }
 
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
@@ -712,7 +722,7 @@ static int ath_setkey_tkip(struct ath_softc *sc,
 	if (!ath_keyset(sc, key->keyidx, hk, NULL)) {
 		/* Txmic entry failed. No need to proceed further */
 		DPRINTF(sc, ATH_DBG_KEYCACHE,
-			"%s Setting TX MIC Key Failed\n", __func__);
+			"Setting TX MIC Key Failed\n");
 		return 0;
 	}
 
@@ -836,8 +846,7 @@ static void ath9k_ht_conf(struct ath_softc *sc,
 		ath9k_hw_set11nmac2040(sc->sc_ah, sc->tx_chan_width);
 
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"%s: BSS Changed HT, chanwidth: %d\n",
-			__func__, sc->tx_chan_width);
+			"BSS Changed HT, chanwidth: %d\n", sc->tx_chan_width);
 	}
 }
 
@@ -864,9 +873,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 	DECLARE_MAC_BUF(mac);
 
 	if (bss_conf->assoc) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Bss Info ASSOC %d\n",
-			__func__,
-			bss_conf->aid);
+		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info ASSOC %d\n", bss_conf->aid);
 
 		/* New association, store aid */
 		if (avp->av_opmode == ATH9K_M_STA) {
@@ -889,18 +896,13 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		ath_update_chainmask(sc, hw->conf.ht.enabled);
 
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"%s: bssid %s aid 0x%x\n",
-			__func__,
+			"bssid %s aid 0x%x\n",
 			print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
 
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
-			__func__,
-			curchan->center_freq);
-
 		pos = ath_get_channel(sc, curchan);
 		if (pos == -1) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Invalid channel\n", __func__);
+				"Invalid channel: %d\n", curchan->center_freq);
 			return;
 		}
 
@@ -921,14 +923,15 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 
 		/* set h/w channel */
 		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Unable to set channel\n", __func__);
+			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel: %d\n",
+				curchan->center_freq);
+
 		/* Start ANI */
 		mod_timer(&sc->sc_ani.timer,
 			jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 
 	} else {
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Bss Info DISSOC\n", __func__);
+		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISSOC\n");
 		sc->sc_curaid = 0;
 	}
 }
@@ -1067,8 +1070,8 @@ static void ath_radio_enable(struct ath_softc *sc)
 			    sc->sc_ht_extprotspacing,
 			    false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to reset channel %u (%uMhz) "
-			"flags 0x%x hal status %u\n", __func__,
+			"Unable to reset channel %u (%uMhz) "
+			"flags 0x%x hal status %u\n",
 			ath9k_hw_mhz2ieee(ah,
 					  ah->ah_curchan->channel,
 					  ah->ah_curchan->channelFlags),
@@ -1080,7 +1083,7 @@ static void ath_radio_enable(struct ath_softc *sc)
 	ath_update_txpow(sc);
 	if (ath_startrecv(sc) != 0) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to restart recv logic\n", __func__);
+			"Unable to restart recv logic\n");
 		return;
 	}
 
@@ -1125,8 +1128,8 @@ static void ath_radio_disable(struct ath_softc *sc)
 			    sc->sc_ht_extprotspacing,
 			    false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to reset channel %u (%uMhz) "
-			"flags 0x%x hal status %u\n", __func__,
+			"Unable to reset channel %u (%uMhz) "
+			"flags 0x%x hal status %u\n",
 			ath9k_hw_mhz2ieee(ah,
 				ah->ah_curchan->channel,
 				ah->ah_curchan->channelFlags),
@@ -1206,7 +1209,7 @@ static int ath_sw_toggle_radio(void *data, enum rfkill_state state)
 			sc->sc_flags &= ~SC_OP_RFKILL_SW_BLOCKED;
 			if (sc->sc_flags & SC_OP_RFKILL_HW_BLOCKED) {
 				DPRINTF(sc, ATH_DBG_FATAL, "Can't turn on the"
-					"radio as it is disabled by h/w \n");
+					"radio as it is disabled by h/w\n");
 				return -EPERM;
 			}
 			ath_radio_enable(sc);
@@ -1286,7 +1289,7 @@ static void ath_detach(struct ath_softc *sc)
 	struct ieee80211_hw *hw = sc->hw;
 	int i = 0;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach ATH hw\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	ath_deinit_rfkill(sc);
@@ -1341,8 +1344,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	ah = ath9k_hw_attach(devid, sc, sc->mem, &status);
 	if (ah == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to attach hardware; HAL status %u\n",
-			__func__, status);
+			"Unable to attach hardware; HAL status %u\n", status);
 		error = -ENXIO;
 		goto bad;
 	}
@@ -1352,8 +1354,8 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_keymax = ah->ah_caps.keycache_size;
 	if (sc->sc_keymax > ATH_KEYMAX) {
 		DPRINTF(sc, ATH_DBG_KEYCACHE,
-			"%s: Warning, using only %u entries in %u key cache\n",
-			__func__, ATH_KEYMAX, sc->sc_keymax);
+			"Warning, using only %u entries in %u key cache\n",
+			ATH_KEYMAX, sc->sc_keymax);
 		sc->sc_keymax = ATH_KEYMAX;
 	}
 
@@ -1400,14 +1402,14 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_bhalq = ath_beaconq_setup(ah);
 	if (sc->sc_bhalq == -1) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup a beacon xmit queue\n", __func__);
+			"Unable to setup a beacon xmit queue\n");
 		error = -EIO;
 		goto bad2;
 	}
 	sc->sc_cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
 	if (sc->sc_cabq == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup CAB xmit queue\n", __func__);
+			"Unable to setup CAB xmit queue\n");
 		error = -EIO;
 		goto bad2;
 	}
@@ -1422,30 +1424,26 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	/* NB: ensure BK queue is the lowest priority h/w queue */
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BK)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup xmit queue for BK traffic\n",
-			__func__);
+			"Unable to setup xmit queue for BK traffic\n");
 		error = -EIO;
 		goto bad2;
 	}
 
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BE)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup xmit queue for BE traffic\n",
-			__func__);
+			"Unable to setup xmit queue for BE traffic\n");
 		error = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VI)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup xmit queue for VI traffic\n",
-			__func__);
+			"Unable to setup xmit queue for VI traffic\n");
 		error = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VO)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to setup xmit queue for VO traffic\n",
-			__func__);
+			"Unable to setup xmit queue for VO traffic\n");
 		error = -EIO;
 		goto bad2;
 	}
@@ -1557,7 +1555,7 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 	struct ieee80211_hw *hw = sc->hw;
 	int error = 0;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach ATH hw\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
 
 	error = ath_init(devid, sc);
 	if (error != 0)
@@ -1588,8 +1586,7 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 	error = ath_rate_control_register();
 	if (error != 0) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Unable to register rate control "
-			"algorithm:%d\n", __func__, error);
+			"Unable to register rate control algorithm: %d\n", error);
 		ath_rate_control_unregister();
 		goto bad;
 	}
@@ -1657,15 +1654,13 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			    sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to reset hardware; hal status %u\n",
-			__func__, status);
+			"Unable to reset hardware; hal status %u\n", status);
 		error = -EIO;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0)
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to start recv logic\n", __func__);
+		DPRINTF(sc, ATH_DBG_FATAL, "Unable to start recv logic\n");
 
 	/*
 	 * We may be doing a reset in response to a request
@@ -1713,13 +1708,12 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	struct ath_buf *bf;
 	int i, bsize, error;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: %s DMA: %u buffers %u desc/buf\n",
-		__func__, name, nbuf, ndesc);
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s DMA: %u buffers %u desc/buf\n",
+		name, nbuf, ndesc);
 
 	/* ath_desc must be a multiple of DWORDs */
 	if ((sizeof(struct ath_desc) % 4) != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: ath_desc not DWORD aligned\n",
-			__func__);
+		DPRINTF(sc, ATH_DBG_FATAL, "ath_desc not DWORD aligned\n");
 		ASSERT((sizeof(struct ath_desc) % 4) == 0);
 		error = -ENOMEM;
 		goto fail;
@@ -1755,8 +1749,8 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		goto fail;
 	}
 	ds = dd->dd_desc;
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: %s DMA map: %p (%u) -> %llx (%u)\n",
-		__func__, dd->dd_name, ds, (u32) dd->dd_desc_len,
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
+		dd->dd_name, ds, (u32) dd->dd_desc_len,
 		ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
 
 	/* allocate buffers */
@@ -1878,14 +1872,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath9k_channel *init_channel;
 	int error = 0, pos, status;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Starting driver with "
-		"initial channel: %d MHz\n", __func__, curchan->center_freq);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
+		"initial channel: %d MHz\n", curchan->center_freq);
 
 	/* setup initial channel */
 
 	pos = ath_get_channel(sc, curchan);
 	if (pos == -1) {
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid channel\n", __func__);
+		DPRINTF(sc, ATH_DBG_FATAL, "Invalid channel: %d\n", curchan->center_freq);
 		error = -EINVAL;
 		goto error;
 	}
@@ -1911,8 +1905,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			    sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to reset hardware; hal status %u "
-			"(freq %u flags 0x%x)\n", __func__, status,
+			"Unable to reset hardware; hal status %u "
+			"(freq %u flags 0x%x)\n", status,
 			init_channel->channel, init_channel->channelFlags);
 		error = -EIO;
 		spin_unlock_bh(&sc->sc_resetlock);
@@ -1935,7 +1929,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 */
 	if (ath_startrecv(sc) != 0) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to start recv logic\n", __func__);
+			"Unable to start recv logic\n");
 		error = -EIO;
 		goto error;
 	}
@@ -2027,12 +2021,10 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	if (!txctl.txq)
 		goto exit;
 
-	DPRINTF(sc, ATH_DBG_XMIT, "%s: transmitting packet, skb: %p\n",
-		__func__,
-		skb);
+	DPRINTF(sc, ATH_DBG_XMIT, "transmitting packet, skb: %p\n", skb);
 
 	if (ath_tx_start(sc, skb, &txctl) != 0) {
-		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX failed\n", __func__);
+		DPRINTF(sc, ATH_DBG_XMIT, "TX failed\n");
 		goto exit;
 	}
 
@@ -2047,11 +2039,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 
 	if (sc->sc_flags & SC_OP_INVALID) {
-		DPRINTF(sc, ATH_DBG_ANY, "%s: Device not present\n", __func__);
+		DPRINTF(sc, ATH_DBG_ANY, "Device not present\n");
 		return;
 	}
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Cleaning up\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Cleaning up\n");
 
 	ieee80211_stop_queues(sc->hw);
 
@@ -2076,7 +2068,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	sc->sc_flags |= SC_OP_INVALID;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Driver halt\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Driver halt\n");
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
@@ -2103,14 +2095,11 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		break;
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Interface type %d not yet supported\n",
-			__func__, conf->type);
+			"Interface type %d not yet supported\n", conf->type);
 		return -EOPNOTSUPP;
 	}
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach a VAP of type: %d\n",
-		__func__,
-		ic_opmode);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Attach a VAP of type: %d\n", ic_opmode);
 
 	/* Set the VAP opmode */
 	avp->av_opmode = ic_opmode;
@@ -2141,7 +2130,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_vap *avp = (void *)conf->vif->drv_priv;
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach VAP\n", __func__);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Detach Interface\n");
 
 #ifdef CONFIG_SLOW_ANT_DIV
 	ath_slow_ant_div_stop(&sc->sc_antdiv);
@@ -2171,12 +2160,13 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos;
 
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
-			__func__, curchan->center_freq);
+		DPRINTF(sc, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
+			curchan->center_freq);
 
 		pos = ath_get_channel(sc, curchan);
 		if (pos == -1) {
-			DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid channel\n", __func__);
+			DPRINTF(sc, ATH_DBG_FATAL, "Invalid channel: %d\n",
+				curchan->center_freq);
 			return -EINVAL;
 		}
 
@@ -2197,8 +2187,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 
 		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Unable to set channel\n", __func__);
+			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel\n");
 			return -EINVAL;
 		}
 	}
@@ -2249,9 +2238,9 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 			sc->sc_config.ath_aggr_prot = 0;
 
 			DPRINTF(sc, ATH_DBG_CONFIG,
-				"%s: RX filter 0x%x bssid %s aid 0x%x\n",
-				__func__, rfilt,
-				print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
+				"RX filter 0x%x bssid %s aid 0x%x\n",
+				rfilt, print_mac(mac, sc->sc_curbssid),
+				sc->sc_curaid);
 
 			/* need to reconfigure the beacon */
 			sc->sc_flags &= ~SC_OP_BEACONS ;
@@ -2328,8 +2317,7 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 			ath9k_hw_write_associd(sc->sc_ah, ath_bcast_mac, 0);
 	}
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set HW RX filter: 0x%x\n",
-		__func__, sc->rx_filter);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx_filter);
 }
 
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
@@ -2369,20 +2357,14 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	qnum = ath_get_hal_qnum(queue, sc);
 
 	DPRINTF(sc, ATH_DBG_CONFIG,
-		"%s: Configure tx [queue/halq] [%d/%d],  "
+		"Configure tx [queue/halq] [%d/%d],  "
 		"aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
-		__func__,
-		queue,
-		qnum,
-		params->aifs,
-		params->cw_min,
-		params->cw_max,
-		params->txop);
+		queue, qnum, params->aifs, params->cw_min,
+		params->cw_max, params->txop);
 
 	ret = ath_txq_update(sc, qnum, &qi);
 	if (ret)
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: TXQ Update failed\n", __func__);
+		DPRINTF(sc, ATH_DBG_FATAL, "TXQ Update failed\n");
 
 	return ret;
 }
@@ -2396,7 +2378,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
-	DPRINTF(sc, ATH_DBG_KEYCACHE, " %s: Set HW Key\n", __func__);
+	DPRINTF(sc, ATH_DBG_KEYCACHE, "Set HW Key\n");
 
 	switch (cmd) {
 	case SET_KEY:
@@ -2429,8 +2411,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed PREAMBLE %d\n",
-			__func__,
+		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
 			bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
 			sc->sc_flags |= SC_OP_PREAMBLE_SHORT;
@@ -2439,8 +2420,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed CTS PROT %d\n",
-			__func__,
+		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed CTS PROT %d\n",
 			bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot &&
 		    hw->conf.channel->band != IEEE80211_BAND_5GHZ)
@@ -2453,8 +2433,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_ht_conf(sc, bss_conf);
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed ASSOC %d\n",
-			__func__,
+		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
 		ath9k_bss_assoc_info(sc, vif, bss_conf);
 	}
@@ -2498,8 +2477,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 		ret = ath_tx_aggr_start(sc, sta, tid, ssn);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Unable to start TX aggregation\n",
-				__func__);
+				"Unable to start TX aggregation\n");
 		else
 			ieee80211_start_tx_ba_cb_irqsafe(hw, sta->addr, tid);
 		break;
@@ -2507,8 +2485,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 		ret = ath_tx_aggr_stop(sc, sta, tid);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Unable to stop TX aggregation\n",
-				__func__);
+				"Unable to stop TX aggregation\n");
 
 		ieee80211_stop_tx_ba_cb_irqsafe(hw, sta->addr, tid);
 		break;
@@ -2516,8 +2493,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 		ath_tx_aggr_resume(sc, sta, tid);
 		break;
 	default:
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Unknown AMPDU action\n", __func__);
+		DPRINTF(sc, ATH_DBG_FATAL, "Unknown AMPDU action\n");
 	}
 
 	return ret;
@@ -2573,7 +2549,6 @@ static struct {
 /*
  * Return the MAC/BB name. "????" is returned if the MAC/BB is unknown.
  */
-
 static const char *
 ath_mac_bb_name(u32 mac_bb_version)
 {
@@ -2591,7 +2566,6 @@ ath_mac_bb_name(u32 mac_bb_version)
 /*
  * Return the RF name. "????" is returned if the RF is unknown.
  */
-
 static const char *
 ath_rf_name(u16 rf_version)
 {
@@ -2630,7 +2604,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (ret) {
 		printk(KERN_ERR "ath9k: 32-bit DMA consistent "
-			"DMA enable faled\n");
+			"DMA enable failed\n");
 		goto bad;
 	}
 
@@ -2840,6 +2814,6 @@ module_init(init_ath_pci);
 static void __exit exit_ath_pci(void)
 {
 	pci_unregister_driver(&ath_pci_driver);
-	printk(KERN_INFO "%s: driver unloaded\n", dev_info);
+	printk(KERN_INFO "%s: Driver unloaded\n", dev_info);
 }
 module_exit(exit_ath_pci);
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 4f1c8bf..766982a 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -52,8 +52,7 @@ ath9k_hw_set_channel(struct ath_hal *ah, struct ath9k_channel *chan)
 			bModeSynth = 1;
 		} else {
 			DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-				 "%s: invalid channel %u MHz\n", __func__,
-				 freq);
+				"Invalid channel %u MHz\n", freq);
 			return false;
 		}
 
@@ -86,7 +85,7 @@ ath9k_hw_set_channel(struct ath_hal *ah, struct ath9k_channel *chan)
 		aModeRefSel = ath9k_hw_reverse_bits(1, 2);
 	} else {
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			 "%s: invalid channel %u MHz\n", __func__, freq);
+			"Invalid channel %u MHz\n", freq);
 		return false;
 	}
 
@@ -348,8 +347,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, int *status)
 		    || ahp->ah_analogBank6TPCData == NULL
 		    || ahp->ah_analogBank7Data == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-				 "%s: cannot allocate RF banks\n",
-				 __func__);
+				"Cannot allocate RF banks\n");
 			*status = -ENOMEM;
 			return false;
 		}
@@ -360,8 +358,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, int *status)
 			     ahp->ah_iniAddac.ia_columns), GFP_KERNEL);
 		if (ahp->ah_addac5416_21 == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-				 "%s: cannot allocate ah_addac5416_21\n",
-				 __func__);
+				"Cannot allocate ah_addac5416_21\n");
 			*status = -ENOMEM;
 			return false;
 		}
@@ -371,8 +368,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, int *status)
 			     ahp->ah_iniBank6.ia_rows), GFP_KERNEL);
 		if (ahp->ah_bank6Temp == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-				 "%s: cannot allocate ah_bank6Temp\n",
-				 __func__);
+				"Cannot allocate ah_bank6Temp\n");
 			*status = -ENOMEM;
 			return false;
 		}
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 7c08583..7d5affd 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1326,13 +1326,13 @@ static struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 			mode = ATH9K_MODE_11NA_HT40PLUS;
 		break;
 	default:
-		DPRINTF(sc, ATH_DBG_RATE, "Invalid band\n");
+		DPRINTF(sc, ATH_DBG_CONFIG, "Invalid band\n");
 		return NULL;
 	}
 
 	BUG_ON(mode >= ATH9K_MODE_MAX);
 
-	DPRINTF(sc, ATH_DBG_RATE, "Choosing rate table for mode: %d\n", mode);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Choosing rate table for mode: %d\n", mode);
 	return sc->hw_rate_table[mode];
 }
 
@@ -1572,8 +1572,7 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 	rate_priv = kzalloc(sizeof(struct ath_rate_priv), gfp);
 	if (!rate_priv) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Unable to allocate private rc structure\n",
-			__func__);
+			"Unable to allocate private rc structure\n");
 		return NULL;
 	}
 
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index ba6194a..26e2001 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -104,8 +104,7 @@ static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len)
 			skb_reserve(skb, sc->sc_cachelsz - off);
 	} else {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: skbuff alloc of size %u failed\n",
-			__func__, len);
+			"skbuff alloc of size %u failed\n", len);
 		return NULL;
 	}
 
@@ -262,11 +261,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 
 	/* calculate and install multicast filter */
 	mfilt[0] = mfilt[1] = ~0;
-
 	ath9k_hw_setmcastfilter(ah, mfilt[0], mfilt[1]);
-	DPRINTF(sc, ATH_DBG_CONFIG ,
-		"%s: RX filter 0x%x, MC filter %08x:%08x\n",
-		__func__, rfilt, mfilt[0], mfilt[1]);
 }
 
 int ath_rx_init(struct ath_softc *sc, int nbufs)
@@ -284,8 +279,8 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 					   min(sc->sc_cachelsz,
 					       (u16)64));
 
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: cachelsz %u rxbufsize %u\n",
-			__func__, sc->sc_cachelsz, sc->sc_rxbufsize);
+		DPRINTF(sc, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
+			sc->sc_cachelsz, sc->sc_rxbufsize);
 
 		/* Initialize rx descriptors */
 
@@ -293,8 +288,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 					  "rx", nbufs, 1);
 		if (error != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: failed to allocate rx descriptors: %d\n",
-				__func__, error);
+				"failed to allocate rx descriptors: %d\n", error);
 			break;
 		}
 
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 62e2888..e3dd91f 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -78,8 +78,7 @@ static bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah)
 				return true;
 	}
 	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-		 "%s: invalid regulatory domain/country code 0x%x\n",
-		 __func__, rd);
+		 "invalid regulatory domain/country code 0x%x\n", rd);
 	return false;
 }
 
@@ -107,13 +106,12 @@ static bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
 		return true;
 
 	rd = ath9k_regd_get_eepromRD(ah);
-	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: EEPROM regdomain 0x%x\n",
-		 __func__, rd);
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "EEPROM regdomain 0x%x\n", rd);
 
 	if (rd & COUNTRY_ERD_FLAG) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: EEPROM setting is country code %u\n",
-			__func__, rd & ~COUNTRY_ERD_FLAG);
+			"EEPROM setting is country code %u\n",
+			rd & ~COUNTRY_ERD_FLAG);
 		return cc == (rd & ~COUNTRY_ERD_FLAG);
 	}
 
@@ -290,8 +288,7 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 		}
 		if (!found) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				"%s: Failed to find reg domain pair %u\n",
-				__func__, regDmn);
+				"Failed to find reg domain pair %u\n", regDmn);
 			return false;
 		}
 		if (!(channelFlag & CHANNEL_2GHZ)) {
@@ -307,8 +304,7 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 	found = ath9k_regd_is_valid_reg_domain(regDmn, rd);
 	if (!found) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: Failed to find unitary reg domain %u\n",
-			__func__, regDmn);
+			"Failed to find unitary reg domain %u\n", regDmn);
 		return false;
 	} else {
 		rd->pscan &= regPair->pscanMask;
@@ -430,30 +426,27 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 
 	if (!(c_lo <= c && c <= c_hi)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: c %u out of range [%u..%u]\n",
-			__func__, c, c_lo, c_hi);
+			"c %u out of range [%u..%u]\n",
+			c, c_lo, c_hi);
 		return false;
 	}
 	if ((fband->channelBW == CHANNEL_HALF_BW) &&
 	    !(ah->ah_caps.hw_caps & ATH9K_HW_CAP_CHAN_HALFRATE)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: Skipping %u half rate channel\n",
-			__func__, c);
+			"Skipping %u half rate channel\n", c);
 		return false;
 	}
 
 	if ((fband->channelBW == CHANNEL_QUARTER_BW) &&
 	    !(ah->ah_caps.hw_caps & ATH9K_HW_CAP_CHAN_QUARTERRATE)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: Skipping %u quarter rate channel\n",
-			__func__, c);
+			"Skipping %u quarter rate channel\n", c);
 		return false;
 	}
 
 	if (((c + fband->channelSep) / 2) > (maxChan + HALF_MAXCHANBW)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: c %u > maxChan %u\n",
-			__func__, c, maxChan);
+			"c %u > maxChan %u\n", c, maxChan);
 		return false;
 	}
 
@@ -606,8 +599,7 @@ static bool ath9k_regd_japan_check(struct ath_hal *ah,
 	}
 
 	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-		"%s: Skipping %d freq band\n",
-		__func__, j_bandcheck[i].freqbandbit);
+		"Skipping %d freq band\n", j_bandcheck[i].freqbandbit);
 
 	return skipband;
 }
@@ -632,20 +624,19 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	unsigned long *modes_avail;
 	DECLARE_BITMAP(modes_allowed, ATH9K_MODE_MAX);
 
-	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: cc %u %s %s\n",
-		 __func__, cc,
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "cc %u %s %s\n", cc,
 		 enableOutdoor ? "Enable outdoor" : "",
 		 enableExtendedChannels ? "Enable ecm" : "");
 
 	if (!ath9k_regd_is_ccode_valid(ah, cc)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: invalid country code %d\n", __func__, cc);
+			"Invalid country code %d\n", cc);
 		return false;
 	}
 
 	if (!ath9k_regd_is_eeprom_valid(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: invalid EEPROM contents\n", __func__);
+			"Invalid EEPROM contents\n");
 		return false;
 	}
 
@@ -693,9 +684,9 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					    ~CHANNEL_2GHZ,
 					    &rd5GHz)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: couldn't find unitary "
+			"Couldn't find unitary "
 			"5GHz reg domain for country %u\n",
-			__func__, ah->ah_countryCode);
+			ah->ah_countryCode);
 		return false;
 	}
 	if (!ath9k_regd_get_wmode_regdomain(ah,
@@ -703,9 +694,9 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					    CHANNEL_2GHZ,
 					    &rd2GHz)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: couldn't find unitary 2GHz "
+			"Couldn't find unitary 2GHz "
 			"reg domain for country %u\n",
-			__func__, ah->ah_countryCode);
+			ah->ah_countryCode);
 		return false;
 	}
 
@@ -717,9 +708,9 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 							    ~CHANNEL_2GHZ,
 							    &rd5GHz)) {
 				DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-					"%s: couldn't find unitary 5GHz "
+					"Couldn't find unitary 5GHz "
 					"reg domain for country %u\n",
-					__func__, ah->ah_countryCode);
+					ah->ah_countryCode);
 				return false;
 			}
 		}
@@ -749,15 +740,14 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 
 		if (!test_bit(cm->mode, modes_avail)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				"%s: !avail mode %d flags 0x%x\n",
-				__func__, cm->mode, cm->flags);
+				"!avail mode %d flags 0x%x\n",
+				cm->mode, cm->flags);
 			continue;
 		}
 		if (!ath9k_get_channel_edges(ah, cm->flags, &c_lo, &c_hi)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				"%s: channels 0x%x not supported "
-				"by hardware\n",
-				__func__, cm->flags);
+				"channels 0x%x not supported "
+				"by hardware\n", cm->flags);
 			continue;
 		}
 
@@ -788,8 +778,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 			break;
 		default:
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				"%s: Unknown HAL mode 0x%x\n", __func__,
-				cm->mode);
+				"Unknown HAL mode 0x%x\n", cm->mode);
 			continue;
 		}
 
@@ -841,9 +830,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					if (next >= maxchans) {
 						DPRINTF(ah->ah_sc,
 							ATH_DBG_REGULATORY,
-							"%s: too many channels "
-							"for channel table\n",
-							__func__);
+							"too many channels "
+							"for channel table\n");
 						goto done;
 					}
 					if (ath9k_regd_add_channel(ah,
@@ -869,9 +857,8 @@ done:
 
 		if (next > ARRAY_SIZE(ah->ah_channels)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				"%s: too many channels %u; truncating to %u\n",
-				__func__, next,
-				(int) ARRAY_SIZE(ah->ah_channels));
+				"too many channels %u; truncating to %u\n",
+				next, (int) ARRAY_SIZE(ah->ah_channels));
 			next = ARRAY_SIZE(ah->ah_channels);
 		}
 #ifdef ATH_NF_PER_CHAN
@@ -919,7 +906,7 @@ ath9k_regd_check_channel(struct ath_hal *ah,
 	int n, lim;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-		"%s: channel %u/0x%x (0x%x) requested\n", __func__,
+		"channel %u/0x%x (0x%x) requested\n",
 		c->channel, c->channelFlags, flags);
 
 	cc = ah->ah_curchan;
@@ -950,15 +937,15 @@ ath9k_regd_check_channel(struct ath_hal *ah,
 			d = flags - (cc->channelFlags & CHAN_FLAGS);
 		}
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"%s: channel %u/0x%x d %d\n", __func__,
+			"channel %u/0x%x d %d\n",
 			cc->channel, cc->channelFlags, d);
 		if (d > 0) {
 			base = cc + 1;
 			lim--;
 		}
 	}
-	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: no match for %u/0x%x\n",
-		__func__, c->channel, c->channelFlags);
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "no match for %u/0x%x\n",
+		c->channel, c->channelFlags);
 	return NULL;
 }
 
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 413fbdd..fc52f61 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -83,18 +83,16 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
 
 	DPRINTF(sc, ATH_DBG_QUEUE,
-		"%s: txq depth = %d\n", __func__, txq->axq_depth);
+		"qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
 
 	if (txq->axq_link == NULL) {
 		ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
 		DPRINTF(sc, ATH_DBG_XMIT,
-			"%s: TXDP[%u] = %llx (%p)\n",
-			__func__, txq->axq_qnum,
-			ito64(bf->bf_daddr), bf->bf_desc);
+			"TXDP[%u] = %llx (%p)\n",
+			txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
 	} else {
 		*txq->axq_link = bf->bf_daddr;
-		DPRINTF(sc, ATH_DBG_XMIT, "%s: link[%u] (%p)=%llx (%p)\n",
-			__func__,
+		DPRINTF(sc, ATH_DBG_XMIT, "link[%u] (%p)=%llx (%p)\n",
 			txq->axq_qnum, txq->axq_link,
 			ito64(bf->bf_daddr), bf->bf_desc);
 	}
@@ -109,8 +107,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
 
-	DPRINTF(sc, ATH_DBG_XMIT,
-		"%s: TX complete: skb: %p\n", __func__, skb);
+	DPRINTF(sc, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
 
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
 	    tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
@@ -983,8 +980,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	int txok, nbad = 0;
 	int status;
 
-	DPRINTF(sc, ATH_DBG_QUEUE,
-		"%s: tx queue %d (%x), link %p\n", __func__,
+	DPRINTF(sc, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
 		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
 		txq->axq_link);
 
@@ -1116,9 +1112,9 @@ static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_hal *ah = sc->sc_ah;
 
 	(void) ath9k_hw_stoptxdma(ah, txq->axq_qnum);
-	DPRINTF(sc, ATH_DBG_XMIT, "%s: tx queue [%u] %x, link %p\n",
-		__func__, txq->axq_qnum,
-		ath9k_hw_gettxbuf(ah, txq->axq_qnum), txq->axq_link);
+	DPRINTF(sc, ATH_DBG_XMIT, "tx queue [%u] %x, link %p\n",
+		txq->axq_qnum, ath9k_hw_gettxbuf(ah, txq->axq_qnum),
+		txq->axq_link);
 }
 
 /* Drain only the data queues */
@@ -1142,8 +1138,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 
 	if (npend) {
 		/* TxDMA not stopped, reset the hal */
-		DPRINTF(sc, ATH_DBG_XMIT,
-			"%s: Unable to stop TxDMA. Reset HAL!\n", __func__);
+		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
 		if (!ath9k_hw_reset(ah,
@@ -1153,8 +1148,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 				    sc->sc_ht_extprotspacing, true, &status)) {
 
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: unable to reset hardware; hal status %u\n",
-				__func__,
+				"Unable to reset hardware; hal status %u\n",
 				status);
 		}
 		spin_unlock_bh(&sc->sc_resetlock);
@@ -1194,7 +1188,6 @@ static void ath_tx_addto_baw(struct ath_softc *sc,
  * Function to send an A-MPDU
  * NB: must be called with txq lock held
  */
-
 static int ath_tx_send_ampdu(struct ath_softc *sc,
 			     struct ath_atx_tid *tid,
 			     struct list_head *bf_head,
@@ -1242,7 +1235,6 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
  * looks up the rate
  * returns aggr limit based on lowest of the rates
  */
-
 static u32 ath_lookup_rate(struct ath_softc *sc,
 			   struct ath_buf *bf,
 			   struct ath_atx_tid *tid)
@@ -1310,7 +1302,6 @@ static u32 ath_lookup_rate(struct ath_softc *sc,
  * meet the minimum required mpdudensity.
  * caller should make sure that the rate is  HT rate .
  */
-
 static int ath_compute_num_delims(struct ath_softc *sc,
 				  struct ath_atx_tid *tid,
 				  struct ath_buf *bf,
@@ -1382,7 +1373,6 @@ static int ath_compute_num_delims(struct ath_softc *sc,
  * For aggregation from software buffer queue.
  * NB: must be called with txq lock held
  */
-
 static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 					struct ath_atx_tid *tid,
 					struct list_head *bf_q,
@@ -1505,7 +1495,6 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
  * process pending frames possibly doing a-mpdu aggregation
  * NB: must be called with txq lock held
  */
-
 static void ath_tx_sched_aggr(struct ath_softc *sc,
 	struct ath_txq *txq, struct ath_atx_tid *tid)
 {
@@ -1635,7 +1624,6 @@ static void ath_tid_drain(struct ath_softc *sc,
  * Drain all pending buffers
  * NB: must be called with txq lock held
  */
-
 static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 					  struct ath_txq *txq)
 {
@@ -1795,8 +1783,7 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
-		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX buffers are full\n",
-			__func__);
+		DPRINTF(sc, ATH_DBG_XMIT, "TX buffers are full\n");
 		return -1;
 	}
 
@@ -1820,8 +1807,8 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 			"tx", nbufs, 1);
 		if (error != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: failed to allocate tx descriptors: %d\n",
-				__func__, error);
+				"Failed to allocate tx descriptors: %d\n",
+				error);
 			break;
 		}
 
@@ -1830,9 +1817,8 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 					  "beacon", ATH_BCBUF, 1);
 		if (error != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: failed to allocate "
-				"beacon descripotrs: %d\n",
-				__func__, error);
+				"Failed to allocate beacon descriptors: %d\n",
+				error);
 			break;
 		}
 
@@ -1904,8 +1890,8 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	}
 	if (qnum >= ARRAY_SIZE(sc->sc_txq)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: hal qnum %u out of range, max %u!\n",
-			__func__, qnum, (unsigned int)ARRAY_SIZE(sc->sc_txq));
+			"qnum %u out of range, max %u!\n",
+			qnum, (unsigned int)ARRAY_SIZE(sc->sc_txq));
 		ath9k_hw_releasetxqueue(ah, qnum);
 		return NULL;
 	}
@@ -1950,8 +1936,8 @@ int ath_tx_setup(struct ath_softc *sc, int haltype)
 
 	if (haltype >= ARRAY_SIZE(sc->sc_haltype2q)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: HAL AC %u out of range, max %zu!\n",
-			__func__, haltype, ARRAY_SIZE(sc->sc_haltype2q));
+			"HAL AC %u out of range, max %zu!\n",
+			 haltype, ARRAY_SIZE(sc->sc_haltype2q));
 		return 0;
 	}
 	txq = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, haltype);
@@ -1970,8 +1956,7 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 	case ATH9K_TX_QUEUE_DATA:
 		if (haltype >= ARRAY_SIZE(sc->sc_haltype2q)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: HAL AC %u out of range, max %zu!\n",
-				__func__,
+				"HAL AC %u out of range, max %zu!\n",
 				haltype, ARRAY_SIZE(sc->sc_haltype2q));
 			return -1;
 		}
@@ -2004,8 +1989,8 @@ struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 	/* Try to avoid running out of descriptors */
 	if (txq->axq_depth >= (ATH_TXBUF - 20)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: TX queue: %d is full, depth: %d\n",
-			__func__, qnum, txq->axq_depth);
+			"TX queue: %d is full, depth: %d\n",
+			qnum, txq->axq_depth);
 		ieee80211_stop_queue(sc->hw, skb_get_queue_mapping(skb));
 		txq->stopped = 1;
 		spin_unlock_bh(&txq->axq_lock);
@@ -2047,8 +2032,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 
 	if (!ath9k_hw_set_txq_props(ah, qnum, &qi)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to update hardware queue %u!\n",
-			__func__, qnum);
+			"Unable to update hardware queue %u!\n", qnum);
 		error = -EIO;
 	} else {
 		ath9k_hw_resettxqueue(ah, qnum); /* push to h/w */
@@ -2167,7 +2151,7 @@ void ath_draintxq(struct ath_softc *sc, bool retry_tx)
 	 * we go to INIT state */
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		(void) ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
-		DPRINTF(sc, ATH_DBG_XMIT, "%s: beacon queue %x\n", __func__,
+		DPRINTF(sc, ATH_DBG_XMIT, "beacon queue %x\n",
 			ath9k_hw_gettxbuf(sc->sc_ah, sc->sc_bhalq));
 	}
 
@@ -2267,8 +2251,6 @@ void ath_tx_aggr_teardown(struct ath_softc *sc, struct ath_node *an, u8 tid)
 	struct list_head bf_head;
 	INIT_LIST_HEAD(&bf_head);
 
-	DPRINTF(sc, ATH_DBG_AGGR, "%s: teardown TX aggregation\n", __func__);
-
 	if (txtid->state & AGGR_CLEANUP) /* cleanup is in progress */
 		return;
 
@@ -2501,8 +2483,7 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
 	if (hdrlen & 3) {
 		padsize = hdrlen % 4;
 		if (skb_headroom(skb) < padsize) {
-			DPRINTF(sc, ATH_DBG_XMIT, "%s: TX CABQ padding "
-				"failed\n", __func__);
+			DPRINTF(sc, ATH_DBG_XMIT, "TX CABQ padding failed\n");
 			dev_kfree_skb_any(skb);
 			return;
 		}
@@ -2512,12 +2493,10 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
 
 	txctl.txq = sc->sc_cabq;
 
-	DPRINTF(sc, ATH_DBG_XMIT, "%s: transmitting CABQ packet, skb: %p\n",
-		__func__,
-		skb);
+	DPRINTF(sc, ATH_DBG_XMIT, "transmitting CABQ packet, skb: %p\n", skb);
 
 	if (ath_tx_start(sc, skb, &txctl) != 0) {
-		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX failed\n", __func__);
+		DPRINTF(sc, ATH_DBG_XMIT, "CABQ TX failed\n");
 		goto exit;
 	}
 
-- 
1.6.0.3

