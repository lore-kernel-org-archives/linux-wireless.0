Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44897 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbZIRJiP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 05:38:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 02:38:19 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19123.21772.162532.462510@gargle.gargle.HOWL>
Date: Fri, 18 Sep 2009 15:08:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 9/9] ath9k: Fix bugs in handling TX power
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

* Get power table offset from the EEPROM instead of using
  a hardcoded value of -5 if the EEPROM rev is >= 21.
* Add support in the 4k eeprom code for tx power offset
  in case we have a 4k AR9280 implementation.
* Fix tx power accuracy at high powers.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h     |    5 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c  |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c |  102 +++++++++++++++++++++++++-
 3 files changed, 104 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 3349274..2f2993b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -134,6 +134,7 @@
 #define AR5416_EEP_MINOR_VER_17      0x11
 #define AR5416_EEP_MINOR_VER_19      0x13
 #define AR5416_EEP_MINOR_VER_20      0x14
+#define AR5416_EEP_MINOR_VER_21      0x15
 #define AR5416_EEP_MINOR_VER_22      0x16
 
 #define AR5416_NUM_5G_CAL_PIERS         8
@@ -154,7 +155,7 @@
 #define AR5416_BCHAN_UNUSED             0xFF
 #define AR5416_MAX_PWR_RANGE_IN_HALF_DB 64
 #define AR5416_MAX_CHAINS               3
-#define AR5416_PWR_TABLE_OFFSET         -5
+#define AR5416_PWR_TABLE_OFFSET_DB     -5
 
 /* Rx gain type values */
 #define AR5416_EEP_RXGAIN_23DB_BACKOFF     0
@@ -302,7 +303,7 @@ struct base_eep_header {
 	u8 txGainType;
 	u8 rcChainMask;
 	u8 desiredScaleCCK;
-	u8 power_table_offset;
+	u8 pwr_table_offset;
 	u8 frac_n_5g;
 	u8 futureBase_3[21];
 } __packed;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 2a27b1d..58167d8 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -210,6 +210,8 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 		return pBase->rxMask;
 	case EEP_FRAC_N_5G:
 		return 0;
+	case EEP_PWR_TABLE_OFFSET:
+		return AR5416_PWR_TABLE_OFFSET_DB;
 	default:
 		return 0;
 	}
@@ -753,7 +755,7 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++)
-			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET * 2;
+			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET_DB * 2;
 	}
 
 	/* OFDM power per rate */
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 8f04b64..404a034 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -291,6 +291,11 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 			return pBase->frac_n_5g;
 		else
 			return 0;
+	case EEP_PWR_TABLE_OFFSET:
+		if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_21)
+			return pBase->pwr_table_offset;
+		else
+			return AR5416_PWR_TABLE_OFFSET_DB;
 	default:
 		return 0;
 	}
@@ -741,6 +746,76 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 	return;
 }
 
+static int16_t ath9k_change_gain_boundary_setting(struct ath_hw *ah,
+				u16 *gb,
+				u16 numXpdGain,
+				u16 pdGainOverlap_t2,
+				int8_t pwr_table_offset,
+				int16_t *diff)
+
+{
+	u16 k;
+
+	/* Prior to writing the boundaries or the pdadc vs. power table
+	 * into the chip registers the default starting point on the pdadc
+	 * vs. power table needs to be checked and the curve boundaries
+	 * adjusted accordingly
+	 */
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		u16 gb_limit;
+
+		if (AR5416_PWR_TABLE_OFFSET_DB != pwr_table_offset) {
+			/* get the difference in dB */
+			*diff = (u16)(pwr_table_offset - AR5416_PWR_TABLE_OFFSET_DB);
+			/* get the number of half dB steps */
+			*diff *= 2;
+			/* change the original gain boundary settings
+			 * by the number of half dB steps
+			 */
+			for (k = 0; k < numXpdGain; k++)
+				gb[k] = (u16)(gb[k] - *diff);
+		}
+		/* Because of a hardware limitation, ensure the gain boundary
+		 * is not larger than (63 - overlap)
+		 */
+		gb_limit = (u16)(AR5416_MAX_RATE_POWER - pdGainOverlap_t2);
+
+		for (k = 0; k < numXpdGain; k++)
+			gb[k] = (u16)min(gb_limit, gb[k]);
+	}
+
+	return *diff;
+}
+
+static void ath9k_adjust_pdadc_values(struct ath_hw *ah,
+				      int8_t pwr_table_offset,
+				      int16_t diff,
+				      u8 *pdadcValues)
+{
+#define NUM_PDADC(diff) (AR5416_NUM_PDADC_VALUES - diff)
+	u16 k;
+
+	/* If this is a board that has a pwrTableOffset that differs from
+	 * the default AR5416_PWR_TABLE_OFFSET_DB then the start of the
+	 * pdadc vs pwr table needs to be adjusted prior to writing to the
+	 * chip.
+	 */
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		if (AR5416_PWR_TABLE_OFFSET_DB != pwr_table_offset) {
+			/* shift the table to start at the new offset */
+			for (k = 0; k < (u16)NUM_PDADC(diff); k++ ) {
+				pdadcValues[k] = pdadcValues[k + diff];
+			}
+
+			/* fill the back of the table */
+			for (k = (u16)NUM_PDADC(diff); k < NUM_PDADC(0); k++) {
+				pdadcValues[k] = pdadcValues[NUM_PDADC(diff)];
+			}
+		}
+	}
+#undef NUM_PDADC
+}
+
 static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
@@ -756,15 +831,18 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
 	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
 	u16 numPiers, i, j;
-	int16_t tMinCalPower;
+	int16_t tMinCalPower, diff = 0;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = { 0, 0, 0, 0 };
 	u32 reg32, regOffset, regChainOffset;
 	int16_t modalIdx;
+	int8_t pwr_table_offset;
 
 	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
 	xpdMask = pEepData->modalHeader[modalIdx].xpdGain;
 
+	pwr_table_offset = ah->eep_ops->get_eeprom(ah, EEP_PWR_TABLE_OFFSET);
+
 	if ((pEepData->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
 	    AR5416_EEP_MINOR_VER_2) {
 		pdGainOverlap_t2 =
@@ -844,6 +922,13 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 							numXpdGain);
 			}
 
+			diff = ath9k_change_gain_boundary_setting(ah,
+							   gainBoundaries,
+							   numXpdGain,
+							   pdGainOverlap_t2,
+							   pwr_table_offset,
+							   &diff);
+
 			if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
 				if (OLC_FOR_AR9280_20_LATER) {
 					REG_WRITE(ah,
@@ -864,6 +949,10 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 				}
 			}
 
+
+			ath9k_adjust_pdadc_values(ah, pwr_table_offset,
+						  diff, pdadcValues);
+
 			regOffset = AR_PHY_BASE + (672 << 2) + regChainOffset;
 			for (j = 0; j < 32; j++) {
 				reg32 = ((pdadcValues[4 * j + 0] & 0xFF) << 0) |
@@ -1199,8 +1288,13 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	}
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		for (i = 0; i < Ar5416RateSize; i++)
-			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET * 2;
+		for (i = 0; i < Ar5416RateSize; i++) {
+			int8_t pwr_table_offset;
+
+			pwr_table_offset = ah->eep_ops->get_eeprom(ah,
+							EEP_PWR_TABLE_OFFSET);
+			ratesArray[i] -= pwr_table_offset * 2;
+		}
 	}
 
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
@@ -1299,7 +1393,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		regulatory->max_power_level =
-			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
+			ratesArray[i] + AR5416_PWR_TABLE_OFFSET_DB * 2;
 	else
 		regulatory->max_power_level = ratesArray[i];
 
-- 
1.6.4.4

