Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45933 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589AbcFGNKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 09:10:10 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 3/6] ath9k: Use tsf offset helper in ath9k_hw_reset
Date: Tue,  7 Jun 2016 15:09:58 +0200
Message-Id: <1465305001-26067-3-git-send-email-benjamin@sipsolutions.net> (sfid-20160607_151030_828333_7A827F54)
In-Reply-To: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
References: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

Not much of a change. Only small fix is that we don't assume that
exactly 1.5ms have passed for the second AR91xx SoC TSF setting.

Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8b2895f..1c27e2d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1832,8 +1832,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u32 saveLedState;
 	u32 saveDefAntenna;
 	u32 macStaId1;
+	struct timespec tsf_ts;
+	u32 tsf_offset;
 	u64 tsf = 0;
-	s64 usec = 0;
 	int r;
 	bool start_mci_reset = false;
 	bool save_fullsleep = ah->chip_fullsleep;
@@ -1877,8 +1878,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	macStaId1 = REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_BASE_RATE_11B;
 
 	/* Save TSF before chip reset, a cold reset clears it */
+	getrawmonotonic(&tsf_ts);
 	tsf = ath9k_hw_gettsf64(ah);
-	usec = ktime_to_us(ktime_get_raw());
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
 		(AR_CFG_LED_ASSOC_CTL | AR_CFG_LED_MODE_SEL |
@@ -1911,8 +1912,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 
 	/* Restore TSF */
-	usec = ktime_to_us(ktime_get_raw()) - usec;
-	ath9k_hw_settsf64(ah, tsf + usec);
+	tsf_offset = ath9k_hw_get_tsf_offset(&tsf_ts, NULL);
+	ath9k_hw_settsf64(ah, tsf + tsf_offset);
 
 	if (AR_SREV_9280_20_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
@@ -1932,12 +1933,11 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	/*
 	 * Some AR91xx SoC devices frequently fail to accept TSF writes
 	 * right after the chip reset. When that happens, write a new
-	 * value after the initvals have been applied, with an offset
-	 * based on measured time difference
+	 * value after the initvals have been applied.
 	 */
 	if (AR_SREV_9100(ah) && (ath9k_hw_gettsf64(ah) < tsf)) {
-		tsf += 1500;
-		ath9k_hw_settsf64(ah, tsf);
+		tsf_offset = ath9k_hw_get_tsf_offset(&tsf_ts, NULL);
+		ath9k_hw_settsf64(ah, tsf + tsf_offset);
 	}
 
 	ath9k_hw_init_mfp(ah);
-- 
2.8.1

