Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38733 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab2DPTvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:51:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] ath9k: use ath9k_hw_fbin2freq instead of FBIN2FREQ
Date: Mon, 16 Apr 2012 22:46:32 +0200
Message-Id: <1334609192-26412-2-git-send-email-juhosg@openwrt.org> (sfid-20120416_215105_346125_37027B5A)
In-Reply-To: <1334609192-26412-1-git-send-email-juhosg@openwrt.org>
References: <1334609192-26412-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FBIN2FREQ macro and the ath9k_hw_fbin2freq function
does the same thing. Remove the macro, and use the inline
function instead.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    1 -
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    |   10 ++++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 122a066..86cd05a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4061,7 +4061,7 @@ static u8 ar9003_hw_eeprom_get_tgt_pwr(struct ath_hw *ah,
 	 * targetpower piers stored on eeprom
 	 */
 	for (i = 0; i < numPiers; i++) {
-		freqArray[i] = FBIN2FREQ(pFreqBin[i], is2GHz);
+		freqArray[i] = ath9k_hw_fbin2freq(pFreqBin[i], is2GHz);
 		targetPowerArray[i] = pEepromTargetPwr[i].tPow2x[rateIndex];
 	}
 
@@ -4097,7 +4097,7 @@ static u8 ar9003_hw_eeprom_get_ht20_tgt_pwr(struct ath_hw *ah,
 	 * from targetpower piers stored on eeprom
 	 */
 	for (i = 0; i < numPiers; i++) {
-		freqArray[i] = FBIN2FREQ(pFreqBin[i], is2GHz);
+		freqArray[i] = ath9k_hw_fbin2freq(pFreqBin[i], is2GHz);
 		targetPowerArray[i] = pEepromTargetPwr[i].tPow2x[rateIndex];
 	}
 
@@ -4133,7 +4133,7 @@ static u8 ar9003_hw_eeprom_get_ht40_tgt_pwr(struct ath_hw *ah,
 	 * targetpower piers stored on eeprom
 	 */
 	for (i = 0; i < numPiers; i++) {
-		freqArray[i] = FBIN2FREQ(pFreqBin[i], is2GHz);
+		freqArray[i] = ath9k_hw_fbin2freq(pFreqBin[i], is2GHz);
 		targetPowerArray[i] = pEepromTargetPwr[i].tPow2x[rateIndex];
 	}
 
@@ -4158,7 +4158,7 @@ static u8 ar9003_hw_eeprom_get_cck_tgt_pwr(struct ath_hw *ah,
 	 * targetpower piers stored on eeprom
 	 */
 	for (i = 0; i < numPiers; i++) {
-		freqArray[i] = FBIN2FREQ(pFreqBin[i], 1);
+		freqArray[i] = ath9k_hw_fbin2freq(pFreqBin[i], 1);
 		targetPowerArray[i] = pEepromTargetPwr[i].tPow2x[rateIndex];
 	}
 
@@ -4455,7 +4455,7 @@ static int ar9003_hw_cal_pier_get(struct ath_hw *ah,
 		is2GHz = 1;
 	}
 
-	*pfrequency = FBIN2FREQ(*pCalPier, is2GHz);
+	*pfrequency = ath9k_hw_fbin2freq(*pCalPier, is2GHz);
 	*pcorrection = pCalPierStruct->refPower;
 	*ptemperature = pCalPierStruct->tempMeas;
 	*pvoltage = pCalPierStruct->voltMeas;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index bb223fe..2505ac4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -42,7 +42,6 @@
 #define AR9300_EEPMISC_WOW           0x02
 #define AR9300_CUSTOMER_DATA_SIZE    20
 
-#define FBIN2FREQ(x, y) ((y) ? (2300 + x) : (4800 + 5 * x))
 #define AR9300_MAX_CHAINS            3
 #define AR9300_ANT_16S               25
 #define AR9300_FUTURE_MODAL_SZ       6
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 4c9bc9f..bbda25f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -208,11 +208,12 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 			continue;
 		negative = 0;
 		if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah))
-			cur_bb_spur = FBIN2FREQ(spur_fbin_ptr[i],
-					IS_CHAN_2GHZ(chan)) - synth_freq;
+			cur_bb_spur = ath9k_hw_fbin2freq(spur_fbin_ptr[i],
+							 IS_CHAN_2GHZ(chan));
 		else
-			cur_bb_spur = spur_freq[i] - synth_freq;
+			cur_bb_spur = spur_freq[i];
 
+		cur_bb_spur -= synth_freq;
 		if (cur_bb_spur < 0) {
 			negative = 1;
 			cur_bb_spur = -cur_bb_spur;
@@ -442,7 +443,8 @@ static void ar9003_hw_spur_mitigate_ofdm(struct ath_hw *ah,
 	ar9003_hw_spur_ofdm_clear(ah);
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS && spurChansPtr[i]; i++) {
-		freq_offset = FBIN2FREQ(spurChansPtr[i], mode) - synth_freq;
+		freq_offset = ath9k_hw_fbin2freq(spurChansPtr[i], mode);
+		freq_offset -= synth_freq;
 		if (abs(freq_offset) < range) {
 			ar9003_hw_spur_ofdm_work(ah, chan, freq_offset);
 			break;
-- 
1.7.2.1

