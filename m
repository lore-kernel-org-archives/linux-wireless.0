Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42576 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZCFPMR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 10:12:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 07:12:16 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Use suitable macros with 4k eeprom data
Date: Fri, 6 Mar 2009 20:38:36 +0530
Message-ID: <1236352117-18466-1-git-send-email-vasanth@atheros.com> (sfid-20090306_161220_243339_AE13229B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch improves range and connection stability in AR9285.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 8a9e062..dd280cb 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -679,7 +679,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 				    vpdTableI[i][sizeCurrVpdTable - 2]);
 		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
 
-		if (tgtIndex > maxIndex) {
+		if (tgtIndex >= maxIndex) {
 			while ((ss <= tgtIndex) &&
 			       (k < (AR5416_NUM_PDADC_VALUES - 1))) {
 				tmpVal = (int16_t) TMP_VAL_VPD_TABLE;
@@ -713,11 +713,11 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	u8 *pCalBChans = NULL;
 	u16 pdGainOverlap_t2;
 	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
-	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
+	u16 gainBoundaries[AR5416_EEP4K_PD_GAINS_IN_MASK];
 	u16 numPiers, i, j;
 	int16_t tMinCalPower;
 	u16 numXpdGain, xpdMask;
-	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = { 0, 0, 0, 0 };
+	u16 xpdGainValues[AR5416_EEP4K_NUM_PD_GAINS] = { 0, 0 };
 	u32 reg32, regOffset, regChainOffset;
 
 	xpdMask = pEepData->modalHeader.xpdGain;
@@ -732,16 +732,16 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	}
 
 	pCalBChans = pEepData->calFreqPier2G;
-	numPiers = AR5416_NUM_2G_CAL_PIERS;
+	numPiers = AR5416_EEP4K_NUM_2G_CAL_PIERS;
 
 	numXpdGain = 0;
 
-	for (i = 1; i <= AR5416_PD_GAINS_IN_MASK; i++) {
-		if ((xpdMask >> (AR5416_PD_GAINS_IN_MASK - i)) & 1) {
-			if (numXpdGain >= AR5416_NUM_PD_GAINS)
+	for (i = 1; i <= AR5416_EEP4K_PD_GAINS_IN_MASK; i++) {
+		if ((xpdMask >> (AR5416_EEP4K_PD_GAINS_IN_MASK - i)) & 1) {
+			if (numXpdGain >= AR5416_EEP4K_NUM_PD_GAINS)
 				break;
 			xpdGainValues[numXpdGain] =
-				(u16)(AR5416_PD_GAINS_IN_MASK - i);
+				(u16)(AR5416_EEP4K_PD_GAINS_IN_MASK - i);
 			numXpdGain++;
 		}
 	}
@@ -754,7 +754,7 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 		      xpdGainValues[1]);
 	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3, 0);
 
-	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+	for (i = 0; i < AR5416_EEP4K_MAX_CHAINS; i++) {
 		if (AR_SREV_5416_20_OR_LATER(ah) &&
 		    (ah->rxchainmask == 5 || ah->txchainmask == 5) &&
 		    (i != 0)) {
-- 
1.5.5.1

