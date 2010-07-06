Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0GFMNs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 08:13:48 -0400
Message-ID: <4C331BB9.5010005@redhat.com>
Date: Tue, 06 Jul 2010 08:04:09 -0400
From: Prarit Bhargava <prarit@redhat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Pavel Roskin <proski@gnu.org>, ath9k-devel@atheros.com,
	linville@tuxdriver.com
Subject: Re: ath: Fix uninitialized variable warnings [v2]
References: <20100701160048.23795.39782.sendpatchset@prarit.bos.redhat.com> <1278165872.6710.1.camel@mj>
In-Reply-To: <1278165872.6710.1.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2010 10:04 AM, Pavel Roskin wrote:
> On Thu, 2010-07-01 at 12:09 -0400, Prarit Bhargava wrote:
>> Fix 'make CONFIG_DEBUG_SECTION_MISMATCH=y' warning:
> 
> I don't think the warnings you are fixing have anything to do with
> CONFIG_DEBUG_SECTION_MISMATCH.
> 
>> drivers/net/wireless/mwl8k.c: In function 'mwl8k_bss_info_changed_sta':
>> drivers/net/wireless/mwl8k.c:3404: warning: 'ap_legacy_rates' may be used uninitialized in this function
> 
> The patch doesn't appear to touch mwl8k.c at all.
> 
> Please fix the description.


New patch with updated description.

P.


Fix 'make CONFIG_DEBUG_SECTION_MISMATCH=y' warning:

drivers/net/wireless/ath/ath9k/eeprom_4k.c: In function 'ath9k_hw_get_4k_gain_boundaries_pdadcs.clone.1':
drivers/net/wireless/ath/ath9k/eeprom_4k.c:310: warning: 'minPwrT4' may be used uninitialized in this function
drivers/net/wireless/ath/ath9k/eeprom_def.c: In function 'ath9k_hw_get_def_gain_boundaries_pdadcs.clone.0':
drivers/net/wireless/ath/ath9k/eeprom_def.c:677: warning: 'minPwrT4' may be used uninitialized in this function
drivers/net/wireless/ath/ath9k/eeprom_9287.c: In function 'ath9k_hw_get_AR9287_gain_boundaries_pdadcs':
drivers/net/wireless/ath/ath9k/eeprom_9287.c:301: warning: 'minPwrT4' may be used uninitialized in this function

Pavel pointed out that tMinCalPower or pMinCalPower isn't used anywhere, so
the simplest way to fix these warnings is to get rid of the code.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 41a77d1..393f8c5 100644
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
@@ -307,8 +307,6 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 		}
 	}
 
-	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
-
 	k = 0;
 
 	for (i = 0; i < numXpdGains; i++) {
@@ -398,7 +396,6 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
 	u16 gainBoundaries[AR5416_EEP4K_PD_GAINS_IN_MASK];
 	u16 numPiers, i, j;
-	int16_t tMinCalPower;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR5416_EEP4K_NUM_PD_GAINS] = { 0, 0 };
 	u32 reg32, regOffset, regChainOffset;
@@ -451,7 +448,7 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 			ath9k_hw_get_4k_gain_boundaries_pdadcs(ah, chan,
 					    pRawDataset, pCalBChans,
 					    numPiers, pdGainOverlap_t2,
-					    &tMinCalPower, gainBoundaries,
+					    gainBoundaries,
 					    pdadcValues, numXpdGain);
 
 			ENABLE_REGWRITE_BUFFER(ah);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index b471db5..6d6b1c5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -219,7 +219,7 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 				   struct ath9k_channel *chan,
 				   struct cal_data_per_freq_ar9287 *pRawDataSet,
 				   u8 *bChans,  u16 availPiers,
-				   u16 tPdGainOverlap, int16_t *pMinCalPower,
+				   u16 tPdGainOverlap,
 				   u16 *pPdGainBoundaries, u8 *pPDADCValues,
 				   u16 numXpdGains)
 {
@@ -298,7 +298,6 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 			}
 		}
 	}
-	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
 
 	k = 0;
 	for (i = 0; i < numXpdGains; i++) {
@@ -448,7 +447,6 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 	u8  pdadcValues[AR9287_NUM_PDADC_VALUES];
 	u16 gainBoundaries[AR9287_PD_GAINS_IN_MASK];
 	u16 numPiers = 0, i, j;
-	int16_t  tMinCalPower;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR9287_NUM_PD_GAINS] = {0, 0, 0, 0};
 	u32 reg32, regOffset, regChainOffset;
@@ -514,7 +512,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 						  ah, chan, pRawDataset,
 						  pCalBChans, numPiers,
 						  pdGainOverlap_t2,
-						  &tMinCalPower, gainBoundaries,
+						  gainBoundaries,
 						  pdadcValues, numXpdGain);
 			}
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 7e1ed78..6ff2742 100644
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
@@ -674,8 +674,6 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 		}
 	}
 
-	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
-
 	k = 0;
 
 	for (i = 0; i < numXpdGains; i++) {
@@ -837,7 +835,7 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
 	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
 	u16 numPiers, i, j;
-	int16_t tMinCalPower, diff = 0;
+	int16_t diff = 0;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = { 0, 0, 0, 0 };
 	u32 reg32, regOffset, regChainOffset;
@@ -922,7 +920,6 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 							chan, pRawDataset,
 							pCalBChans, numPiers,
 							pdGainOverlap_t2,
-							&tMinCalPower,
 							gainBoundaries,
 							pdadcValues,
 							numXpdGain);
