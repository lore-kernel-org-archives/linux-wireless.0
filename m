Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37060 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933473Ab1IOMZr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 08:25:47 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH RESEND 1/4] ath9k_hw: clean up hardware revision checks
Date: Thu, 15 Sep 2011 14:25:35 +0200
Message-Id: <1316089538-91685-1-git-send-email-nbd@openwrt.org> (sfid-20110915_142555_773758_4661338B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- AR_SREV_5416_20_OR_LATER is always true, remove it
- AR_SREV_9280_20_OR_LATER is always true within eeprom_4k.c and eeprom_9287.c
- (AR_SREV_9271 || AR_SREV_9285) is always true in eeprom_4k.c

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c  |    3 +-
 drivers/net/wireless/ath/ath9k/eeprom.c      |    7 +--
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |   85 ++++++++++++--------------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    6 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |   46 ++++++--------
 drivers/net/wireless/ath/ath9k/mac.c         |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h         |    4 -
 drivers/net/wireless/ath/ath9k/reg.h         |    4 -
 8 files changed, 63 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index fac2c6d..b130c26 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -704,8 +704,7 @@ static void ar5008_hw_override_ini(struct ath_hw *ah,
 		REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
 	}
 
-	if (!AR_SREV_5416_20_OR_LATER(ah) ||
-	    AR_SREV_9280_20_OR_LATER(ah))
+	if (AR_SREV_9280_20_OR_LATER(ah))
 		return;
 	/*
 	 * Disable BB clock gating
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index e61404d..e46f751 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -456,12 +456,7 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 		pPdGainBoundaries[i] =
 			min((u16)MAX_RATE_POWER, pPdGainBoundaries[i]);
 
-		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
-			minDelta = pPdGainBoundaries[0] - 23;
-			pPdGainBoundaries[0] = 23;
-		} else {
-			minDelta = 0;
-		}
+		minDelta = 0;
 
 		if (i == 0) {
 			if (AR_SREV_9280_20_OR_LATER(ah))
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index ea658e7..99f7a08 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -405,12 +405,7 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3, 0);
 
 	for (i = 0; i < AR5416_EEP4K_MAX_CHAINS; i++) {
-		if (AR_SREV_5416_20_OR_LATER(ah) &&
-		    (ah->rxchainmask == 5 || ah->txchainmask == 5) &&
-		    (i != 0)) {
-			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
-		} else
-			regChainOffset = i * 0x1000;
+		regChainOffset = i * 0x1000;
 
 		if (pEepData->baseEepHeader.txMask & (1 << i)) {
 			pRawDataset = pEepData->calPierData2G[i];
@@ -423,19 +418,17 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 
 			ENABLE_REGWRITE_BUFFER(ah);
 
-			if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
-				REG_WRITE(ah, AR_PHY_TPCRG5 + regChainOffset,
-					  SM(pdGainOverlap_t2,
-					     AR_PHY_TPCRG5_PD_GAIN_OVERLAP)
-					  | SM(gainBoundaries[0],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
-					  | SM(gainBoundaries[1],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
-					  | SM(gainBoundaries[2],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
-					  | SM(gainBoundaries[3],
-				       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
-			}
+			REG_WRITE(ah, AR_PHY_TPCRG5 + regChainOffset,
+				  SM(pdGainOverlap_t2,
+				     AR_PHY_TPCRG5_PD_GAIN_OVERLAP)
+				  | SM(gainBoundaries[0],
+				       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
+				  | SM(gainBoundaries[1],
+				       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
+				  | SM(gainBoundaries[2],
+				       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
+				  | SM(gainBoundaries[3],
+			       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
 
 			regOffset = AR_PHY_BASE + (672 << 2) + regChainOffset;
 			for (j = 0; j < 32; j++) {
@@ -715,10 +708,8 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	if (test)
 	    return;
 
-	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		for (i = 0; i < Ar5416RateSize; i++)
-			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET_DB * 2;
-	}
+	for (i = 0; i < Ar5416RateSize; i++)
+		ratesArray[i] -= AR5416_PWR_TABLE_OFFSET_DB * 2;
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
@@ -877,6 +868,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 	u8 txRxAttenLocal;
 	u8 ob[5], db1[5], db2[5];
 	u8 ant_div_control1, ant_div_control2;
+	u8 bb_desired_scale;
 	u32 regVal;
 
 	pModal = &eep->modalHeader;
@@ -1096,30 +1088,29 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 				      AR_PHY_SETTLING_SWITCH,
 				      pModal->swSettleHt40);
 	}
-	if (AR_SREV_9271(ah) || AR_SREV_9285(ah)) {
-		u8 bb_desired_scale = (pModal->bb_scale_smrt_antenna &
-				EEP_4K_BB_DESIRED_SCALE_MASK);
-		if ((pBase->txGainType == 0) && (bb_desired_scale != 0)) {
-			u32 pwrctrl, mask, clr;
-
-			mask = BIT(0)|BIT(5)|BIT(10)|BIT(15)|BIT(20)|BIT(25);
-			pwrctrl = mask * bb_desired_scale;
-			clr = mask * 0x1f;
-			REG_RMW(ah, AR_PHY_TX_PWRCTRL8, pwrctrl, clr);
-			REG_RMW(ah, AR_PHY_TX_PWRCTRL10, pwrctrl, clr);
-			REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL12, pwrctrl, clr);
-
-			mask = BIT(0)|BIT(5)|BIT(15);
-			pwrctrl = mask * bb_desired_scale;
-			clr = mask * 0x1f;
-			REG_RMW(ah, AR_PHY_TX_PWRCTRL9, pwrctrl, clr);
-
-			mask = BIT(0)|BIT(5);
-			pwrctrl = mask * bb_desired_scale;
-			clr = mask * 0x1f;
-			REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL11, pwrctrl, clr);
-			REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL13, pwrctrl, clr);
-		}
+
+	bb_desired_scale = (pModal->bb_scale_smrt_antenna &
+			EEP_4K_BB_DESIRED_SCALE_MASK);
+	if ((pBase->txGainType == 0) && (bb_desired_scale != 0)) {
+		u32 pwrctrl, mask, clr;
+
+		mask = BIT(0)|BIT(5)|BIT(10)|BIT(15)|BIT(20)|BIT(25);
+		pwrctrl = mask * bb_desired_scale;
+		clr = mask * 0x1f;
+		REG_RMW(ah, AR_PHY_TX_PWRCTRL8, pwrctrl, clr);
+		REG_RMW(ah, AR_PHY_TX_PWRCTRL10, pwrctrl, clr);
+		REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL12, pwrctrl, clr);
+
+		mask = BIT(0)|BIT(5)|BIT(15);
+		pwrctrl = mask * bb_desired_scale;
+		clr = mask * 0x1f;
+		REG_RMW(ah, AR_PHY_TX_PWRCTRL9, pwrctrl, clr);
+
+		mask = BIT(0)|BIT(5);
+		pwrctrl = mask * bb_desired_scale;
+		clr = mask * 0x1f;
+		REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL11, pwrctrl, clr);
+		REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL13, pwrctrl, clr);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 21f180d..ebf97ba 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -851,10 +851,8 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 	if (test)
 		return;
 
-	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		for (i = 0; i < Ar5416RateSize; i++)
-			ratesArray[i] -= AR9287_PWR_TABLE_OFFSET_DB * 2;
-	}
+	for (i = 0; i < Ar5416RateSize; i++)
+		ratesArray[i] -= AR9287_PWR_TABLE_OFFSET_DB * 2;
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index e7e84be..eda681f 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -547,8 +547,7 @@ static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
 				break;
 		}
 
-		if (AR_SREV_5416_20_OR_LATER(ah) &&
-		    (ah->rxchainmask == 5 || ah->txchainmask == 5) && (i != 0))
+		if ((ah->rxchainmask == 5 || ah->txchainmask == 5) && (i != 0))
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
 		else
 			regChainOffset = i * 0x1000;
@@ -565,9 +564,8 @@ static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
 			  SM(pModal->iqCalQCh[i],
 			     AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
 
-		if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah))
-			ath9k_hw_def_set_gain(ah, pModal, eep, txRxAttenLocal,
-					      regChainOffset, i);
+		ath9k_hw_def_set_gain(ah, pModal, eep, txRxAttenLocal,
+				      regChainOffset, i);
 	}
 
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
@@ -893,8 +891,7 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 		      xpdGainValues[2]);
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		if (AR_SREV_5416_20_OR_LATER(ah) &&
-		    (ah->rxchainmask == 5 || ah->txchainmask == 5) &&
+		if ((ah->rxchainmask == 5 || ah->txchainmask == 5) &&
 		    (i != 0)) {
 			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
 		} else
@@ -935,27 +932,24 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 
 			ENABLE_REGWRITE_BUFFER(ah);
 
-			if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
-				if (OLC_FOR_AR9280_20_LATER) {
-					REG_WRITE(ah,
-						AR_PHY_TPCRG5 + regChainOffset,
-						SM(0x6,
-						AR_PHY_TPCRG5_PD_GAIN_OVERLAP) |
-						SM_PD_GAIN(1) | SM_PD_GAIN(2) |
-						SM_PD_GAIN(3) | SM_PD_GAIN(4));
-				} else {
-					REG_WRITE(ah,
-						AR_PHY_TPCRG5 + regChainOffset,
-						SM(pdGainOverlap_t2,
-						AR_PHY_TPCRG5_PD_GAIN_OVERLAP)|
-						SM_PDGAIN_B(0, 1) |
-						SM_PDGAIN_B(1, 2) |
-						SM_PDGAIN_B(2, 3) |
-						SM_PDGAIN_B(3, 4));
-				}
+			if (OLC_FOR_AR9280_20_LATER) {
+				REG_WRITE(ah,
+					AR_PHY_TPCRG5 + regChainOffset,
+					SM(0x6,
+					AR_PHY_TPCRG5_PD_GAIN_OVERLAP) |
+					SM_PD_GAIN(1) | SM_PD_GAIN(2) |
+					SM_PD_GAIN(3) | SM_PD_GAIN(4));
+			} else {
+				REG_WRITE(ah,
+					AR_PHY_TPCRG5 + regChainOffset,
+					SM(pdGainOverlap_t2,
+					AR_PHY_TPCRG5_PD_GAIN_OVERLAP)|
+					SM_PDGAIN_B(0, 1) |
+					SM_PDGAIN_B(1, 2) |
+					SM_PDGAIN_B(2, 3) |
+					SM_PDGAIN_B(3, 4));
 			}
 
-
 			ath9k_adjust_pdadc_values(ah, pwr_table_offset,
 						  diff, pdadcValues);
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 786587a..22f23ea 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -584,7 +584,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	else
 		rs->rs_keyix = ATH9K_RXKEYIX_INVALID;
 
-	rs->rs_rate = RXSTATUS_RATE(ah, (&ads));
+	rs->rs_rate = MS(ads.ds_rxstatus0, AR_RxRate);
 	rs->rs_more = (ads.ds_rxstatus1 & AR_RxMore) ? 1 : 0;
 
 	rs->rs_isaggr = (ads.ds_rxstatus8 & AR_RxAggr) ? 1 : 0;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 25f2c9a..c763977 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -17,10 +17,6 @@
 #ifndef MAC_H
 #define MAC_H
 
-#define RXSTATUS_RATE(ah, ads) (AR_SREV_5416_20_OR_LATER(ah) ?		\
-				MS(ads->ds_rxstatus0, AR_RxRate) :	\
-				(ads->ds_rxstatus3 >> 2) & 0xFF)
-
 #define set11nTries(_series, _index) \
 	(SM((_series)[_index].Tries, AR_XmitDataTries##_index))
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 5d34381..3286802 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -800,10 +800,6 @@
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
 	 ((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE))
-#define AR_SREV_5416_20_OR_LATER(_ah) \
-	(((AR_SREV_5416(_ah)) && \
-	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)) || \
-	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
 #define AR_SREV_5416_22_OR_LATER(_ah) \
 	(((AR_SREV_5416(_ah)) && \
 	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22)) || \
-- 
1.7.3.2

