Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54796 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbcGDMiF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 08:38:05 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH v2 3/6] ath9k: Use tsf offset helper in ath9k_hw_reset
Date: Mon,  4 Jul 2016 14:37:22 +0200
Message-Id: <1467635845-32653-3-git-send-email-benjamin@sipsolutions.net> (sfid-20160704_143812_558693_D0C8365E)
In-Reply-To: <1467635845-32653-1-git-send-email-benjamin@sipsolutions.net>
References: <1467635845-32653-1-git-send-email-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

These changes make ath9k_hw_reset more consistent with other places that
handle the TSF value by using the same helper routine.

A slight improvement is to not assume that a fixed time of 1.5ms has
passed for the initval writes when compared to the first write attempt.
Instead the TSF value is re-calculated which will yield a higher accuracy
of the restored TSF timer.

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

