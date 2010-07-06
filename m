Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21927 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0GFQvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 12:51:33 -0400
Subject: [PATCH] ath9k: remove unneeded calculation of minimal calibration
 power
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Date: Tue, 06 Jul 2010 12:51:27 -0400
Message-ID: <20100706165127.31444.5131.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove tMinCalPower from ath9k_hw_set_def_power_cal_table(), as it's
never used.  Remove corresponding arguments of the functions calculating
that value.

Original patch by Prarit Bhargava <prarit@redhat.com>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |    7 ++-----
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    4 ----
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |    7 ++-----
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index e25a2ab..00cc3db 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -222,7 +222,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				struct cal_data_per_freq_4k *pRawDataSet,
 				u8 *bChans, u16 availPiers,
-				u16 tPdGainOverlap, int16_t *pMinCalPower,
+				u16 tPdGainOverlap,
 				u16 *pPdGainBoundaries, u8 *pPDADCValues,
 				u16 numXpdGains)
 {
@@ -308,8 +308,6 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 		}
 	}
 
-	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
-
 	k = 0;
 
 	for (i = 0; i < numXpdGains; i++) {
@@ -399,7 +397,6 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
 	u16 gainBoundaries[AR5416_EEP4K_PD_GAINS_IN_MASK];
 	u16 numPiers, i, j;
-	int16_t tMinCalPower;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR5416_EEP4K_NUM_PD_GAINS] = { 0, 0 };
 	u32 reg32, regOffset, regChainOffset;
@@ -452,7 +449,7 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 			ath9k_hw_get_4k_gain_boundaries_pdadcs(ah, chan,
 					    pRawDataset, pCalBChans,
 					    numPiers, pdGainOverlap_t2,
-					    &tMinCalPower, gainBoundaries,
+					    gainBoundaries,
 					    pdadcValues, numXpdGain);
 
 			ENABLE_REGWRITE_BUFFER(ah);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 39a4105..cb388d2 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -223,7 +223,6 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 			       struct cal_data_per_freq_ar9287 *pRawDataSet,
 			       u8 *bChans, u16 availPiers,
 			       u16 tPdGainOverlap,
-			       int16_t *pMinCalPower,
 			       u16 *pPdGainBoundaries,
 			       u8 *pPDADCValues,
 			       u16 numXpdGains)
@@ -303,7 +302,6 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 		}
 	}
 
-	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
 	k = 0;
 
 	for (i = 0; i < numXpdGains; i++) {
@@ -458,7 +456,6 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 	u8 pdadcValues[AR9287_NUM_PDADC_VALUES];
 	u16 gainBoundaries[AR9287_PD_GAINS_IN_MASK];
 	u16 numPiers = 0, i, j;
-	int16_t tMinCalPower;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR9287_NUM_PD_GAINS] = {0, 0, 0, 0};
 	u32 reg32, regOffset, regChainOffset, regval;
@@ -530,7 +527,6 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 							   pRawDataset,
 							   pCalBChans, numPiers,
 							   pdGainOverlap_t2,
-							   &tMinCalPower,
 							   gainBoundaries,
 							   pdadcValues,
 							   numXpdGain);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 77b1433..57d86d4 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -593,7 +593,7 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				struct cal_data_per_freq *pRawDataSet,
 				u8 *bChans, u16 availPiers,
-				u16 tPdGainOverlap, int16_t *pMinCalPower,
+				u16 tPdGainOverlap,
 				u16 *pPdGainBoundaries, u8 *pPDADCValues,
 				u16 numXpdGains)
 {
@@ -675,8 +675,6 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 		}
 	}
 
-	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
-
 	k = 0;
 
 	for (i = 0; i < numXpdGains; i++) {
@@ -838,7 +836,7 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
 	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
 	u16 numPiers, i, j;
-	int16_t tMinCalPower, diff = 0;
+	int16_t diff = 0;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = { 0, 0, 0, 0 };
 	u32 reg32, regOffset, regChainOffset;
@@ -923,7 +921,6 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 							chan, pRawDataset,
 							pCalBChans, numPiers,
 							pdGainOverlap_t2,
-							&tMinCalPower,
 							gainBoundaries,
 							pdadcValues,
 							numXpdGain);
