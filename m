Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab0FQX4Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 19:56:25 -0400
Message-ID: <4C1AA4AF.8040306@redhat.com>
Date: Thu, 17 Jun 2010 18:41:51 -0400
From: Prarit Bhargava <prarit@redhat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Pavel Roskin <proski@gnu.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	ath9k-devel@atheros.com
Subject: Re: [PATCH]: ath: Fix uninitialized variable warnings
References: <20100527181052.23905.67123.sendpatchset@prarit.bos.redhat.com>	 <20100528173431.GB2405@tuxdriver.com> <1275079476.18152.18.camel@mj>
In-Reply-To: <1275079476.18152.18.camel@mj>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> It looks to me like minPwrT4 will get initialized as long as
>> numXpdGains is non-zero in all cases.  Anyone know if this is true?
> 
> It's calculated based on a value from EEPROM (xpdMask).  If xpdMask is
> 0, numXpdGain would be 0.  So bogus EEPROM can lead to bogus
> tMinCalPower.  But the good thing is that tMinCalPower is never used.
> 
> So let's just eliminate tMinCalPower in all three files, as well as the
> corresponding function arguments.
> 

[John -- I tried using wireless-next-2.6, however, the compile died with

drivers/net/wireless/wl12xx/wl1251_sdio.c: In function ‘wl1251_sdio_read_elp’:
drivers/net/wireless/wl12xx/wl1251_sdio.c:109: error: implicit declaration of function ‘sdio_writeb_readb’
make[4]: *** [drivers/net/wireless/wl12xx/wl1251_sdio.o] Error 1

I'll take a look and probably submit a patch to fix that right after I do this.]

Thanks for the input and help Pavel.  Sorry this is such a late response -- I
got caught up with a few other things.

New linux-2.6 patch using Pavel's suggestion.


Fix "make -j32 CONFIG_DEBUG_SECTION_MISMATCH=y" warning:

drivers/net/wireless/ath/ath9k/eeprom_9287.c: In function ‘ath9k_hw_get_AR9287_gain_boundaries_pdadcs’:
drivers/net/wireless/ath/ath9k/eeprom_9287.c:301: warning: ‘minPwrT4’ may be used uninitialized in this function
drivers/net/wireless/ath/ath9k/eeprom_4k.c: In function ‘ath9k_hw_get_4k_gain_boundaries_pdadcs.clone.1’:
drivers/net/wireless/ath/ath9k/eeprom_4k.c:310: warning: ‘minPwrT4’ may be used uninitialized in this function
drivers/net/wireless/ath/ath9k/eeprom_def.c: In function ‘ath9k_hw_get_def_gain_boundaries_pdadcs.clone.0’:
drivers/net/wireless/ath/ath9k/eeprom_def.c:677: warning: ‘minPwrT4’ may be used uninitialized in this function

Remove tMinCalPower and the corresponding function arguments  as it is not
used.

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
