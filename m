Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46298 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab3KRTOz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 14:14:55 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/2] ath9k_hw: fix TSF save/restore around chip reset
Date: Mon, 18 Nov 2013 20:14:43 +0100
Message-Id: <1384802084-55082-1-git-send-email-nbd@openwrt.org> (sfid-20131118_201502_122613_BFD1CEEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A cold reset can be triggered because of DMA stop issues, and this leads
to TSF being cleared on all chipsets. To properly deal with this, always
save the TSF.
Additionally, account for the time it takes to do the actual chip reset,
which can be quite significant. On AR9344 it takes around 4.5 ms.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 54b0415..4046da5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/time.h>
 #include <asm/unaligned.h>
 
 #include "hw.h"
@@ -1856,10 +1857,12 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   struct ath9k_hw_cal_data *caldata, bool fastcc)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct timespec ts;
 	u32 saveLedState;
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	u64 tsf = 0;
+	s64 usec = 0;
 	int r;
 	bool start_mci_reset = false;
 	bool save_fullsleep = ah->chip_fullsleep;
@@ -1902,10 +1905,10 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	macStaId1 = REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_BASE_RATE_11B;
 
-	/* For chips on which RTC reset is done, save TSF before it gets cleared */
-	if (AR_SREV_9100(ah) ||
-	    (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)))
-		tsf = ath9k_hw_gettsf64(ah);
+	/* Save TSF before chip reset, a cold reset clears it */
+	tsf = ath9k_hw_gettsf64(ah);
+	getrawmonotonic(&ts);
+	usec = ts.tv_sec * 1000 + ts.tv_nsec / 1000;
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
 		(AR_CFG_LED_ASSOC_CTL | AR_CFG_LED_MODE_SEL |
@@ -1938,8 +1941,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 
 	/* Restore TSF */
-	if (tsf)
-		ath9k_hw_settsf64(ah, tsf);
+	getrawmonotonic(&ts);
+	usec = ts.tv_sec * 1000 + ts.tv_nsec / 1000 - usec;
+	ath9k_hw_settsf64(ah, tsf + usec);
 
 	if (AR_SREV_9280_20_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
-- 
1.8.3.4 (Apple Git-47)

