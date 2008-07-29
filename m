Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17146 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbYG2Frn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:43 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:43 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 11/16] ath9k: Remove "OS_" prefixes in macros.
Date: Mon, 28 Jul 2008 22:47:20 -0700
Message-ID: <f716bd4495bedc5987c6fd1283a09843e3c9331e.1217309552.git.lrodriguez@atheros.com> (sfid-20080729_081547_034263_FE03E461)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 6fa1eb6..c3294c0 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -622,17 +622,15 @@ struct hal_country_entry {
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
-#define OS_REG_RMW(_a, _r, _set, _clr)    \
+#define REG_RMW(_a, _r, _set, _clr)    \
 	REG_WRITE(_a, _r, (REG_READ(_a, _r) & ~(_clr)) | (_set))
-#define OS_REG_RMW_FIELD(_a, _r, _f, _v) \
+#define REG_RMW_FIELD(_a, _r, _f, _v) \
 	REG_WRITE(_a, _r, \
 	(REG_READ(_a, _r) & ~_f) | (((_v) << _f##_S) & _f))
-#define OS_REG_SET_BIT(_a, _r, _f) \
+#define REG_SET_BIT(_a, _r, _f) \
 	REG_WRITE(_a, _r, REG_READ(_a, _r) | _f)
-#define OS_REG_CLR_BIT(_a, _r, _f) \
+#define REG_CLR_BIT(_a, _r, _f) \
 	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~_f)
-#define OS_REG_ath9k_regd_is_bit_set(_a, _r, _f) \
-	((REG_READ(_a, _r) & _f) != 0)
 
 #define HAL_COMP_BUF_MAX_SIZE   9216
 #define HAL_COMP_BUF_ALIGN_SIZE 512
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index c755ec9..08b4bd4 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -601,33 +601,34 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 
 		if ((i == 0) || AR_SREV_5416_V20_OR_LATER(ah)) {
 			if ((eep->baseEepHeader.version &
-			AR5416_EEP_VER_MINOR_MASK) >= AR5416_EEP_MINOR_VER_3) {
+			     AR5416_EEP_VER_MINOR_MASK) >=
+			    AR5416_EEP_MINOR_VER_3) {
 				txRxAttenLocal = pModal->txRxAttenCh[i];
 				if (AR_SREV_9280_10_OR_LATER(ah)) {
-					OS_REG_RMW_FIELD(ah,
-						 AR_PHY_GAIN_2GHZ +
-						 regChainOffset,
-					 AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN,
-						 pModal->
-						 bswMargin[i]);
-					OS_REG_RMW_FIELD(ah,
-						 AR_PHY_GAIN_2GHZ +
-						 regChainOffset,
-						 AR_PHY_GAIN_2GHZ_XATTEN1_DB,
-						 pModal->
-						 bswAtten[i]);
-					OS_REG_RMW_FIELD(ah,
-						 AR_PHY_GAIN_2GHZ +
-						 regChainOffset,
-					 AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
-						 pModal->
-						 xatten2Margin[i]);
-					OS_REG_RMW_FIELD(ah,
-						 AR_PHY_GAIN_2GHZ +
-						 regChainOffset,
-						 AR_PHY_GAIN_2GHZ_XATTEN2_DB,
-						 pModal->
-						 xatten2Db[i]);
+					REG_RMW_FIELD(ah,
+						AR_PHY_GAIN_2GHZ +
+						regChainOffset,
+						AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN,
+						pModal->
+						bswMargin[i]);
+					REG_RMW_FIELD(ah,
+						AR_PHY_GAIN_2GHZ +
+						regChainOffset,
+						AR_PHY_GAIN_2GHZ_XATTEN1_DB,
+						pModal->
+						bswAtten[i]);
+					REG_RMW_FIELD(ah,
+						AR_PHY_GAIN_2GHZ +
+						regChainOffset,
+						AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
+						pModal->
+						xatten2Margin[i]);
+					REG_RMW_FIELD(ah,
+						AR_PHY_GAIN_2GHZ +
+						regChainOffset,
+						AR_PHY_GAIN_2GHZ_XATTEN2_DB,
+						pModal->
+						xatten2Db[i]);
 				} else {
 					REG_WRITE(ah,
 						  AR_PHY_GAIN_2GHZ +
@@ -637,8 +638,8 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 							    regChainOffset) &
 						   ~AR_PHY_GAIN_2GHZ_BSW_MARGIN)
 						  | SM(pModal->
-					       bswMargin[i],
-					       AR_PHY_GAIN_2GHZ_BSW_MARGIN));
+						  bswMargin[i],
+						  AR_PHY_GAIN_2GHZ_BSW_MARGIN));
 					REG_WRITE(ah,
 						  AR_PHY_GAIN_2GHZ +
 						  regChainOffset,
@@ -647,20 +648,20 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 							    regChainOffset) &
 						   ~AR_PHY_GAIN_2GHZ_BSW_ATTEN)
 						  | SM(pModal->bswAtten[i],
-					       AR_PHY_GAIN_2GHZ_BSW_ATTEN));
+						  AR_PHY_GAIN_2GHZ_BSW_ATTEN));
 				}
 			}
 			if (AR_SREV_9280_10_OR_LATER(ah)) {
-				OS_REG_RMW_FIELD(ah,
-						 AR_PHY_RXGAIN +
-						 regChainOffset,
-						 AR9280_PHY_RXGAIN_TXRX_ATTEN,
-						 txRxAttenLocal);
-				OS_REG_RMW_FIELD(ah,
-						 AR_PHY_RXGAIN +
-						 regChainOffset,
-						 AR9280_PHY_RXGAIN_TXRX_MARGIN,
-						 pModal->rxTxMarginCh[i]);
+				REG_RMW_FIELD(ah,
+					      AR_PHY_RXGAIN +
+					      regChainOffset,
+					      AR9280_PHY_RXGAIN_TXRX_ATTEN,
+					      txRxAttenLocal);
+				REG_RMW_FIELD(ah,
+					      AR_PHY_RXGAIN +
+					      regChainOffset,
+					      AR9280_PHY_RXGAIN_TXRX_MARGIN,
+					      pModal->rxTxMarginCh[i]);
 			} else {
 				REG_WRITE(ah,
 					  AR_PHY_RXGAIN + regChainOffset,
@@ -728,20 +729,20 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 					  AR_AN_TOP2_LOCALBIAS_S,
 					  pModal->local_bias);
 		DPRINTF(ah->ah_sc, ATH_DBG_ANY, "ForceXPAon: %d\n",
-			 pModal->force_xpaon);
-		OS_REG_RMW_FIELD(ah, AR_PHY_XPA_CFG, AR_PHY_FORCE_XPA_CFG,
-				 pModal->force_xpaon);
+			pModal->force_xpaon);
+		REG_RMW_FIELD(ah, AR_PHY_XPA_CFG, AR_PHY_FORCE_XPA_CFG,
+			      pModal->force_xpaon);
 	}
 
-	OS_REG_RMW_FIELD(ah, AR_PHY_SETTLING, AR_PHY_SETTLING_SWITCH,
-			 pModal->switchSettling);
-	OS_REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ, AR_PHY_DESIRED_SZ_ADC,
-			 pModal->adcDesiredSize);
+	REG_RMW_FIELD(ah, AR_PHY_SETTLING, AR_PHY_SETTLING_SWITCH,
+		      pModal->switchSettling);
+	REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ, AR_PHY_DESIRED_SZ_ADC,
+		      pModal->adcDesiredSize);
 
 	if (!AR_SREV_9280_10_OR_LATER(ah))
-		OS_REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
-				 AR_PHY_DESIRED_SZ_PGA,
-				 pModal->pgaDesiredSize);
+		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
+			      AR_PHY_DESIRED_SZ_PGA,
+			      pModal->pgaDesiredSize);
 
 	REG_WRITE(ah, AR_PHY_RF_CTL4,
 		  SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAA_OFF)
@@ -752,37 +753,37 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 		  | SM(pModal->txFrameToXpaOn,
 		       AR_PHY_RF_CTL4_FRAME_XPAB_ON));
 
-	OS_REG_RMW_FIELD(ah, AR_PHY_RF_CTL3, AR_PHY_TX_END_TO_A2_RX_ON,
-			 pModal->txEndToRxOn);
+	REG_RMW_FIELD(ah, AR_PHY_RF_CTL3, AR_PHY_TX_END_TO_A2_RX_ON,
+		      pModal->txEndToRxOn);
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		OS_REG_RMW_FIELD(ah, AR_PHY_CCA, AR9280_PHY_CCA_THRESH62,
-				 pModal->thresh62);
-		OS_REG_RMW_FIELD(ah, AR_PHY_EXT_CCA0,
-				 AR_PHY_EXT_CCA0_THRESH62,
-				 pModal->thresh62);
+		REG_RMW_FIELD(ah, AR_PHY_CCA, AR9280_PHY_CCA_THRESH62,
+			      pModal->thresh62);
+		REG_RMW_FIELD(ah, AR_PHY_EXT_CCA0,
+			      AR_PHY_EXT_CCA0_THRESH62,
+			      pModal->thresh62);
 	} else {
-		OS_REG_RMW_FIELD(ah, AR_PHY_CCA, AR_PHY_CCA_THRESH62,
-				 pModal->thresh62);
-		OS_REG_RMW_FIELD(ah, AR_PHY_EXT_CCA,
-				 AR_PHY_EXT_CCA_THRESH62,
-				 pModal->thresh62);
+		REG_RMW_FIELD(ah, AR_PHY_CCA, AR_PHY_CCA_THRESH62,
+			      pModal->thresh62);
+		REG_RMW_FIELD(ah, AR_PHY_EXT_CCA,
+			      AR_PHY_EXT_CCA_THRESH62,
+			      pModal->thresh62);
 	}
 
 	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
 	    AR5416_EEP_MINOR_VER_2) {
-		OS_REG_RMW_FIELD(ah, AR_PHY_RF_CTL2,
-				 AR_PHY_TX_END_DATA_START,
-				 pModal->txFrameToDataStart);
-		OS_REG_RMW_FIELD(ah, AR_PHY_RF_CTL2, AR_PHY_TX_END_PA_ON,
-				 pModal->txFrameToPaOn);
+		REG_RMW_FIELD(ah, AR_PHY_RF_CTL2,
+			      AR_PHY_TX_END_DATA_START,
+			      pModal->txFrameToDataStart);
+		REG_RMW_FIELD(ah, AR_PHY_RF_CTL2, AR_PHY_TX_END_PA_ON,
+			      pModal->txFrameToPaOn);
 	}
 
 	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
 	    AR5416_EEP_MINOR_VER_3) {
 		if (IS_CHAN_HT40(chan))
-			OS_REG_RMW_FIELD(ah, AR_PHY_SETTLING,
-					 AR_PHY_SETTLING_SWITCH,
-					 pModal->swSettleHt40);
+			REG_RMW_FIELD(ah, AR_PHY_SETTLING,
+				      AR_PHY_SETTLING_SWITCH,
+				      pModal->swSettleHt40);
 	}
 
 	return true;
@@ -1536,12 +1537,12 @@ static void ath9k_hw_set_operating_mode(struct ath_hal *ah, int opmode)
 	case HAL_M_HOSTAP:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_STA_AP
 			  | AR_STA_ID1_KSRCH_MODE);
-		OS_REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
+		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
 	case HAL_M_IBSS:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_ADHOC
 			  | AR_STA_ID1_KSRCH_MODE);
-		OS_REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
+		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
 	case HAL_M_STA:
 	case HAL_M_MONITOR:
@@ -1877,11 +1878,11 @@ getNoiseFloorThresh(struct ath_hal *ah,
 
 static void ath9k_hw_start_nfcal(struct ath_hal *ah)
 {
-	OS_REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
-		       AR_PHY_AGC_CONTROL_ENABLE_NF);
-	OS_REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
-		       AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
-	OS_REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_ENABLE_NF);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
 }
 
 static void
@@ -1920,11 +1921,11 @@ ath9k_hw_loadnf(struct ath_hal *ah, struct hal_channel_internal *chan)
 		}
 	}
 
-	OS_REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
-		       AR_PHY_AGC_CONTROL_ENABLE_NF);
-	OS_REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
-		       AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
-	OS_REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_ENABLE_NF);
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
 
 	for (j = 0; j < 1000; j++) {
 		if ((REG_READ(ah, AR_PHY_AGC_CONTROL) &
@@ -2145,18 +2146,18 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 			return false;
 		}
 
-		OS_REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
-				 AR_PHY_DESIRED_SZ_TOT_DES,
-				 ahp->ah_totalSizeDesired[level]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
-				 AR_PHY_AGC_CTL1_COARSE_LOW,
-				 ahp->ah_coarseLow[level]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
-				 AR_PHY_AGC_CTL1_COARSE_HIGH,
-				 ahp->ah_coarseHigh[level]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
-				 AR_PHY_FIND_SIG_FIRPWR,
-				 ahp->ah_firpwr[level]);
+		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
+			      AR_PHY_DESIRED_SZ_TOT_DES,
+			      ahp->ah_totalSizeDesired[level]);
+		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
+			      AR_PHY_AGC_CTL1_COARSE_LOW,
+			      ahp->ah_coarseLow[level]);
+		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
+			      AR_PHY_AGC_CTL1_COARSE_HIGH,
+			      ahp->ah_coarseHigh[level]);
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
+			      AR_PHY_FIND_SIG_FIRPWR,
+			      ahp->ah_firpwr[level]);
 
 		if (level > aniState->noiseImmunityLevel)
 			ahp->ah_stats.ast_ani_niup++;
@@ -2174,44 +2175,44 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		const int m2CountThrLow[] = { 63, 48 };
 		u_int on = param ? 1 : 0;
 
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-				 AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
-				 m1ThreshLow[on]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-				 AR_PHY_SFCORR_LOW_M2_THRESH_LOW,
-				 m2ThreshLow[on]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-				 AR_PHY_SFCORR_M1_THRESH,
-				 m1Thresh[on]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-				 AR_PHY_SFCORR_M2_THRESH,
-				 m2Thresh[on]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-				 AR_PHY_SFCORR_M2COUNT_THR,
-				 m2CountThr[on]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-				 AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW,
-				 m2CountThrLow[on]);
-
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-				 AR_PHY_SFCORR_EXT_M1_THRESH_LOW,
-				 m1ThreshLow[on]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-				 AR_PHY_SFCORR_EXT_M2_THRESH_LOW,
-				 m2ThreshLow[on]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-				 AR_PHY_SFCORR_EXT_M1_THRESH,
-				 m1Thresh[on]);
-		OS_REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-				 AR_PHY_SFCORR_EXT_M2_THRESH,
-				 m2Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
+			      m1ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2_THRESH_LOW,
+			      m2ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M1_THRESH,
+			      m1Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2_THRESH,
+			      m2Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2COUNT_THR,
+			      m2CountThr[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW,
+			      m2CountThrLow[on]);
+
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH_LOW,
+			      m1ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH_LOW,
+			      m2ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH,
+			      m1Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH,
+			      m2Thresh[on]);
 
 		if (on)
-			OS_REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
-				       AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
+			REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
+				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
 		else
-			OS_REG_CLR_BIT(ah, AR_PHY_SFCORR_LOW,
-				       AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
+			REG_CLR_BIT(ah, AR_PHY_SFCORR_LOW,
+				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
 
 		if (!on != aniState->ofdmWeakSigDetectOff) {
 			if (on)
@@ -2226,9 +2227,9 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 		const int weakSigThrCck[] = { 8, 6 };
 		u_int high = param ? 1 : 0;
 
-		OS_REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT,
-				 AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK,
-				 weakSigThrCck[high]);
+		REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT,
+			      AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK,
+			      weakSigThrCck[high]);
 		if (high != aniState->cckWeakSigThreshold) {
 			if (high)
 				ahp->ah_stats.ast_ani_cckhigh++;
@@ -2246,12 +2247,12 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 			DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 				 "%s: level out of range (%u > %u)\n",
 				 __func__, level,
-				 (unsigned) ARRAY_SIZE(firstep));
+				(unsigned) ARRAY_SIZE(firstep));
 			return false;
 		}
-		OS_REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
-				 AR_PHY_FIND_SIG_FIRSTEP,
-				 firstep[level]);
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
+			      AR_PHY_FIND_SIG_FIRSTEP,
+			      firstep[level]);
 		if (level > aniState->firstepLevel)
 			ahp->ah_stats.ast_ani_stepup++;
 		else if (level < aniState->firstepLevel)
@@ -2269,12 +2270,12 @@ static bool ath9k_hw_ani_control(struct ath_hal *ah,
 				 "%s: level out of range (%u > %u)\n",
 				 __func__, level,
 				 (unsigned)
-				 ARRAY_SIZE(cycpwrThr1));
+				ARRAY_SIZE(cycpwrThr1));
 			return false;
 		}
-		OS_REG_RMW_FIELD(ah, AR_PHY_TIMING5,
-				 AR_PHY_TIMING5_CYCPWR_THR1,
-				 cycpwrThr1[level]);
+		REG_RMW_FIELD(ah, AR_PHY_TIMING5,
+			      AR_PHY_TIMING5_CYCPWR_THR1,
+			      cycpwrThr1[level]);
 		if (level > aniState->spurImmunityLevel)
 			ahp->ah_stats.ast_ani_spurup++;
 		else if (level < aniState->spurImmunityLevel)
@@ -2808,8 +2809,8 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hal *ah,
 
 	if (AR_SREV_9280_20_OR_LATER(ah)
 	    || (addr != AR_GPIO_OUTPUT_MUX1)) {
-		OS_REG_RMW(ah, addr, (type << gpio_shift),
-			   (0x1f << gpio_shift));
+		REG_RMW(ah, addr, (type << gpio_shift),
+			(0x1f << gpio_shift));
 	} else {
 		tmp = REG_READ(ah, addr);
 		tmp = ((tmp & 0x1F0) << 1) | (tmp & ~0x1F0);
@@ -2849,10 +2850,10 @@ static bool ath9k_hw_cfg_output(struct ath_hal *ah, u_int32_t gpio,
 
 	gpio_shift = 2 * gpio;
 
-	OS_REG_RMW(ah,
-		   AR_GPIO_OE_OUT,
-		   (AR_GPIO_OE_OUT_DRV_ALL << gpio_shift),
-		   (AR_GPIO_OE_OUT_DRV << gpio_shift));
+	REG_RMW(ah,
+		AR_GPIO_OE_OUT,
+		(AR_GPIO_OE_OUT_DRV_ALL << gpio_shift),
+		(AR_GPIO_OE_OUT_DRV << gpio_shift));
 
 	return true;
 }
@@ -2860,8 +2861,8 @@ static bool ath9k_hw_cfg_output(struct ath_hal *ah, u_int32_t gpio,
 static bool ath9k_hw_set_gpio(struct ath_hal *ah, u_int32_t gpio,
 			      u_int32_t val)
 {
-	OS_REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
-		   AR_GPIO_BIT(gpio));
+	REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
+		AR_GPIO_BIT(gpio));
 	return true;
 }
 
@@ -3132,21 +3133,21 @@ static void ar5416DisablePciePhy(struct ath_hal *ah)
 
 static void ath9k_set_power_sleep(struct ath_hal *ah, int setChip)
 {
-	OS_REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
-		OS_REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
-			       AR_RTC_FORCE_WAKE_EN);
+		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
+			    AR_RTC_FORCE_WAKE_EN);
 		if (!AR_SREV_9100(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
-		OS_REG_CLR_BIT(ah, (u_int16_t) (AR_RTC_RESET),
-			       AR_RTC_RESET_EN);
+		REG_CLR_BIT(ah, (u_int16_t) (AR_RTC_RESET),
+			    AR_RTC_RESET_EN);
 	}
 }
 
 static void ath9k_set_power_network_sleep(struct ath_hal *ah, int setChip)
 {
-	OS_REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
 		struct hal_capabilities *pCap = &ah->ah_caps;
 
@@ -3154,8 +3155,8 @@ static void ath9k_set_power_network_sleep(struct ath_hal *ah, int setChip)
 			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
 				  AR_RTC_FORCE_WAKE_ON_INT);
 		} else {
-			OS_REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
-				       AR_RTC_FORCE_WAKE_EN);
+			REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
+				    AR_RTC_FORCE_WAKE_EN);
 		}
 	}
 }
@@ -3175,11 +3176,11 @@ static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 			}
 		}
 		if (AR_SREV_9100(ah))
-			OS_REG_SET_BIT(ah, AR_RTC_RESET,
+			REG_SET_BIT(ah, AR_RTC_RESET,
 				       AR_RTC_RESET_EN);
 
-		OS_REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
-			       AR_RTC_FORCE_WAKE_EN);
+		REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
+			    AR_RTC_FORCE_WAKE_EN);
 		udelay(50);
 
 		for (i = POWER_UP_TIME / 50; i > 0; i--) {
@@ -3187,7 +3188,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 			if (val == AR_RTC_STATUS_ON)
 				break;
 			udelay(50);
-			OS_REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
+			REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
 				       AR_RTC_FORCE_WAKE_EN);
 		}
 		if (i == 0) {
@@ -3198,7 +3199,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 		}
 	}
 
-	OS_REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	return true;
 }
 
@@ -3814,14 +3815,14 @@ ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 		}
 	}
 
-	OS_REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_NUM_PD_GAIN,
-			 (numXpdGain - 1) & 0x3);
-	OS_REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_1,
-			 xpdGainValues[0]);
-	OS_REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
-			 xpdGainValues[1]);
-	OS_REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3,
-			 xpdGainValues[2]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_NUM_PD_GAIN,
+		      (numXpdGain - 1) & 0x3);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_1,
+		      xpdGainValues[0]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
+		      xpdGainValues[1]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3,
+		      xpdGainValues[2]);
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 		if (AR_SREV_5416_V20_OR_LATER(ah) &&
@@ -3951,7 +3952,7 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 	}
 
-	OS_REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
+	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
 
 	if (ah->ah_config.ath_hal_pcieWaen) {
 		REG_WRITE(ah, AR_WA, ah->ah_config.ath_hal_pcieWaen);
@@ -4637,20 +4638,20 @@ ath9k_hw_set_delta_slope(struct ath_hal *ah,
 	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
 				      &ds_coef_exp);
 
-	OS_REG_RMW_FIELD(ah, AR_PHY_TIMING3,
-			 AR_PHY_TIMING3_DSC_MAN, ds_coef_man);
-	OS_REG_RMW_FIELD(ah, AR_PHY_TIMING3,
-			 AR_PHY_TIMING3_DSC_EXP, ds_coef_exp);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
+		      AR_PHY_TIMING3_DSC_MAN, ds_coef_man);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
+		      AR_PHY_TIMING3_DSC_EXP, ds_coef_exp);
 
 	coef_scaled = (9 * coef_scaled) / 10;
 
 	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
 				      &ds_coef_exp);
 
-	OS_REG_RMW_FIELD(ah, AR_PHY_HALFGI,
-			 AR_PHY_HALFGI_DSC_MAN, ds_coef_man);
-	OS_REG_RMW_FIELD(ah, AR_PHY_HALFGI,
-			 AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
+	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
+		      AR_PHY_HALFGI_DSC_MAN, ds_coef_man);
+	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
+		      AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
 }
 
 static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah,
@@ -4716,12 +4717,12 @@ static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah,
 	}
 
 	if (AR_NO_SPUR == bb_spur) {
-		OS_REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
-			       AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
+		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
+			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
 		return;
 	} else {
-		OS_REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
-			       AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
+		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
+			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
 	}
 
 	bin = bb_spur * 320;
@@ -5109,8 +5110,8 @@ static inline void ath9k_hw_init_chain_masks(struct ath_hal *ah)
 
 	switch (rx_chainmask) {
 	case 0x5:
-		OS_REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			       AR_PHY_SWAP_ALT_CHAIN);
+		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
+			    AR_PHY_SWAP_ALT_CHAIN);
 	case 0x3:
 		if (((ah)->ah_macVersion <= AR_SREV_VERSION_9160)) {
 			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
@@ -5131,8 +5132,8 @@ static inline void ath9k_hw_init_chain_masks(struct ath_hal *ah)
 
 	REG_WRITE(ah, AR_SELFGEN_MASK, tx_chainmask);
 	if (tx_chainmask == 0x5) {
-		OS_REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			       AR_PHY_SWAP_ALT_CHAIN);
+		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
+			    AR_PHY_SWAP_ALT_CHAIN);
 	}
 	if (AR_SREV_9100(ah))
 		REG_WRITE(ah, AR_PHY_ANALOG_SWAP,
@@ -5251,8 +5252,8 @@ static bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u_int us)
 		ahp->ah_acktimeout = (u_int) -1;
 		return false;
 	} else {
-		OS_REG_RMW_FIELD(ah, AR_TIME_OUT,
-				 AR_TIME_OUT_ACK, ath9k_hw_mac_to_clks(ah, us));
+		REG_RMW_FIELD(ah, AR_TIME_OUT,
+			      AR_TIME_OUT_ACK, ath9k_hw_mac_to_clks(ah, us));
 		ahp->ah_acktimeout = us;
 		return true;
 	}
@@ -5268,8 +5269,8 @@ static bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u_int us)
 		ahp->ah_ctstimeout = (u_int) -1;
 		return false;
 	} else {
-		OS_REG_RMW_FIELD(ah, AR_TIME_OUT,
-				 AR_TIME_OUT_CTS, ath9k_hw_mac_to_clks(ah, us));
+		REG_RMW_FIELD(ah, AR_TIME_OUT,
+			      AR_TIME_OUT_CTS, ath9k_hw_mac_to_clks(ah, us));
 		ahp->ah_ctstimeout = us;
 		return true;
 	}
@@ -5285,7 +5286,7 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hal *ah,
 		ahp->ah_globaltxtimeout = (u_int) -1;
 		return false;
 	} else {
-		OS_REG_RMW_FIELD(ah, AR_GTXTO, AR_GTXTO_TIMEOUT_LIMIT, tu);
+		REG_RMW_FIELD(ah, AR_GTXTO, AR_GTXTO_TIMEOUT_LIMIT, tu);
 		ahp->ah_globaltxtimeout = tu;
 		return true;
 	}
@@ -5461,9 +5462,9 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 static inline void ath9k_hw_setup_calibration(struct ath_hal *ah,
 					      struct hal_cal_list *currCal)
 {
-	OS_REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(0),
-			 AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX,
-			 currCal->calData->calCountMax);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(0),
+		      AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX,
+		      currCal->calData->calCountMax);
 
 	switch (currCal->calData->calType) {
 	case IQ_MISMATCH_CAL:
@@ -5490,8 +5491,8 @@ static inline void ath9k_hw_setup_calibration(struct ath_hal *ah,
 		break;
 	}
 
-	OS_REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
-		       AR_PHY_TIMING_CTRL4_DO_CAL);
+	REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
+		    AR_PHY_TIMING_CTRL4_DO_CAL);
 }
 
 static inline void ath9k_hw_reset_calibration(struct ath_hal *ah,
@@ -5712,7 +5713,7 @@ static inline void ath9k_hw_set_dma(struct ath_hal *ah)
 	regval = REG_READ(ah, AR_TXCFG) & ~AR_TXCFG_DMASZ_MASK;
 	REG_WRITE(ah, AR_TXCFG, regval | AR_TXCFG_DMASZ_128B);
 
-	OS_REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->ah_txTrigLevel);
+	REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->ah_txTrigLevel);
 
 	regval = REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_DMASZ_MASK;
 	REG_WRITE(ah, AR_RXCFG, regval | AR_RXCFG_DMASZ_128B);
@@ -5745,8 +5746,8 @@ bool ath9k_hw_stopdmarecv(struct ath_hal *ah)
 
 void ath9k_hw_startpcureceive(struct ath_hal *ah)
 {
-	OS_REG_CLR_BIT(ah, AR_DIAG_SW,
-		       (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
+	REG_CLR_BIT(ah, AR_DIAG_SW,
+		    (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 
 	ath9k_enable_mib_counters(ah);
 
@@ -5755,7 +5756,7 @@ void ath9k_hw_startpcureceive(struct ath_hal *ah)
 
 void ath9k_hw_stoppcurecv(struct ath_hal *ah)
 {
-	OS_REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_DIS);
+	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_DIS);
 
 	ath9k_hw_disable_mib_counters(ah);
 }
@@ -5927,8 +5928,8 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 	}
 
 	if (AR_SREV_9280(ah)) {
-		OS_REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-			       AR_GPIO_JTAG_DISABLE);
+		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+			    AR_GPIO_JTAG_DISABLE);
 
 		if (ah->ah_caps.halWirelessModes & ATH9K_MODE_SEL_11A) {
 			if (IS_CHAN_5GHZ(chan))
@@ -6012,8 +6013,8 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 
 	if (ahp->ah_intrMitigation) {
 
-		OS_REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
-		OS_REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
+		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
+		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
 	}
 
 	ath9k_hw_init_bb(ah, chan);
@@ -6255,22 +6256,22 @@ static void ath9k_hw_iqcalibrate(struct ath_hal *ah, u_int8_t numChains)
 
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				 "Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
-				 i, iCoff, qCoff);
-
-			OS_REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
-					 AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF,
-					 iCoff);
-			OS_REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
-					 AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF,
-					 qCoff);
+				i, iCoff, qCoff);
+
+			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
+				      AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF,
+				      iCoff);
+			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
+				      AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF,
+				      qCoff);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-				 "IQ Cal and Correction done for Chain %d\n",
-				 i);
+				"IQ Cal and Correction done for Chain %d\n",
+				i);
 		}
 	}
 
-	OS_REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
-		       AR_PHY_TIMING_CTRL4_IQCORR_ENABLE);
+	REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
+		    AR_PHY_TIMING_CTRL4_IQCORR_ENABLE);
 }
 
 static void
@@ -6538,14 +6539,14 @@ static void ath9k_enable_rfkill(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	OS_REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-		       AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
 
-	OS_REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
-		       AR_GPIO_INPUT_MUX2_RFSILENT);
+	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
+		    AR_GPIO_INPUT_MUX2_RFSILENT);
 
 	ath9k_hw_cfg_gpio_input(ah, ahp->ah_gpioSelect);
-	OS_REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
+	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
 
 	if (ahp->ah_gpioBit == ath9k_hw_gpio_get(ah, ahp->ah_gpioSelect)) {
 
@@ -7023,9 +7024,9 @@ enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum hal_int ints)
 
 	if (!pCap->halAutoSleepSupport) {
 		if (ints & HAL_INT_TIM_TIMER)
-			OS_REG_SET_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
+			REG_SET_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
 		else
-			OS_REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
+			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
 	}
 
 	if (ints & HAL_INT_GLOBAL) {
@@ -7068,8 +7069,8 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 		flags |= AR_TBTT_TIMER_EN;
 		break;
 	case HAL_M_IBSS:
-		OS_REG_SET_BIT(ah, AR_TXCFG,
-			       AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
+		REG_SET_BIT(ah, AR_TXCFG,
+			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
 		REG_WRITE(ah, AR_NEXT_NDP_TIMER,
 			  TU_TO_USEC(next_beacon +
 				     (ahp->ah_atimWindow ? ahp->
@@ -7101,7 +7102,7 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 		ath9k_hw_reset_tsf(ah);
 	}
 
-	OS_REG_SET_BIT(ah, AR_TIMER_MODE, flags);
+	REG_SET_BIT(ah, AR_TIMER_MODE, flags);
 }
 
 void
@@ -7118,8 +7119,8 @@ ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 	REG_WRITE(ah, AR_DMA_BEACON_PERIOD,
 		  TU_TO_USEC(bs->bs_intval & HAL_BEACON_PERIOD));
 
-	OS_REG_RMW_FIELD(ah, AR_RSSI_THR,
-			 AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);
+	REG_RMW_FIELD(ah, AR_RSSI_THR,
+		      AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);
 
 	beaconintval = bs->bs_intval & HAL_BEACON_PERIOD;
 
@@ -7163,9 +7164,9 @@ ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 	REG_WRITE(ah, AR_TIM_PERIOD, TU_TO_USEC(beaconintval));
 	REG_WRITE(ah, AR_DTIM_PERIOD, TU_TO_USEC(dtimperiod));
 
-	OS_REG_SET_BIT(ah, AR_TIMER_MODE,
-		       AR_TBTT_TIMER_EN | AR_TIM_TIMER_EN |
-		       AR_DTIM_TIMER_EN);
+	REG_SET_BIT(ah, AR_TIMER_MODE,
+		    AR_TBTT_TIMER_EN | AR_TIM_TIMER_EN |
+		    AR_DTIM_TIMER_EN);
 
 }
 
@@ -7609,14 +7610,12 @@ ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
 
 	REG_WRITE(ah, AR_IMR_S0,
 		  SM(ahp->ah_txOkInterruptMask, AR_IMR_S0_QCU_TXOK)
-		  | SM(ahp->ah_txDescInterruptMask, AR_IMR_S0_QCU_TXDESC)
-		);
+		  | SM(ahp->ah_txDescInterruptMask, AR_IMR_S0_QCU_TXDESC));
 	REG_WRITE(ah, AR_IMR_S1,
 		  SM(ahp->ah_txErrInterruptMask, AR_IMR_S1_QCU_TXERR)
-		  | SM(ahp->ah_txEolInterruptMask, AR_IMR_S1_QCU_TXEOL)
-		);
-	OS_REG_RMW_FIELD(ah, AR_IMR_S2,
-			 AR_IMR_S2_QCU_TXURN, ahp->ah_txUrnInterruptMask);
+		  | SM(ahp->ah_txEolInterruptMask, AR_IMR_S1_QCU_TXEOL));
+	REG_RMW_FIELD(ah, AR_IMR_S2,
+		      AR_IMR_S2_QCU_TXURN, ahp->ah_txUrnInterruptMask);
 }
 
 bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
@@ -8113,16 +8112,16 @@ bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set)
 {
 	if (set) {
 
-		OS_REG_SET_BIT(ah, AR_DIAG_SW,
-			       (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
+		REG_SET_BIT(ah, AR_DIAG_SW,
+			    (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 
 		if (!ath9k_hw_wait
 		    (ah, AR_OBS_BUS_1, AR_OBS_BUS_1_RX_STATE, 0)) {
 			u_int32_t reg;
 
-			OS_REG_CLR_BIT(ah, AR_DIAG_SW,
-				       (AR_DIAG_RX_DIS |
-					AR_DIAG_RX_ABORT));
+			REG_CLR_BIT(ah, AR_DIAG_SW,
+				    (AR_DIAG_RX_DIS |
+				     AR_DIAG_RX_ABORT));
 
 			reg = REG_READ(ah, AR_OBS_BUS_1);
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
@@ -8132,8 +8131,8 @@ bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set)
 			return false;
 		}
 	} else {
-		OS_REG_CLR_BIT(ah, AR_DIAG_SW,
-			       (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
+		REG_CLR_BIT(ah, AR_DIAG_SW,
+			    (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 	}
 
 	return true;
@@ -8549,7 +8548,7 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
 				  SM(10, AR_QUIET2_QUIET_DUR));
 			REG_WRITE(ah, AR_QUIET_PERIOD, 100);
 			REG_WRITE(ah, AR_NEXT_QUIET_TIMER, tsfLow >> 10);
-			OS_REG_SET_BIT(ah, AR_TIMER_MODE,
+			REG_SET_BIT(ah, AR_TIMER_MODE,
 				       AR_QUIET_TIMER_EN);
 
 			if ((REG_READ(ah, AR_TSF_L32) >> 10) ==
@@ -8562,10 +8561,10 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
 				__func__, tsfLow);
 		}
 
-		OS_REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
+		REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
 
 		udelay(200);
-		OS_REG_CLR_BIT(ah, AR_TIMER_MODE, AR_QUIET_TIMER_EN);
+		REG_CLR_BIT(ah, AR_TIMER_MODE, AR_QUIET_TIMER_EN);
 
 		wait = 1000;
 
@@ -8580,7 +8579,7 @@ bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
 			udelay(100);
 		}
 
-		OS_REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
+		REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
 	}
 
 	REG_WRITE(ah, AR_Q_TXD, 0);
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index e1fc9c6..6751bed 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -150,8 +150,8 @@ ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
 			refDivA = 1;
 			channelSel = (freq * 0x8000) / 15;
 
-			OS_REG_RMW_FIELD(ah, AR_AN_SYNTH9,
-					 AR_AN_SYNTH9_REFDIVA, refDivA);
+			REG_RMW_FIELD(ah, AR_AN_SYNTH9,
+				      AR_AN_SYNTH9_REFDIVA, refDivA);
 		}
 		if (!fracMode) {
 			ndiv = (freq * (refDivA >> aModeRefSel)) / 60;
-- 
1.5.4.3

