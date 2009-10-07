Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbZJGUW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 16:22:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] ath9k_hw: run ath9k_hw_9271_pa_cal() initial calibration
Date: Wed,  7 Oct 2009 16:22:19 -0400
Message-Id: <1254946939-4943-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254946939-4943-1-git-send-email-lrodriguez@atheros.com>
References: <1254946939-4943-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PA calibration for ar9271 ath9k_hw_9271_pa_cal() can run during
reset or initial calibration, update the PA calibration to account
for that and initialize PA calibration variables for both conditions.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 7aa3d1d..551f880 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -813,7 +813,7 @@ static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 	}
 }
 
-static void ath9k_hw_9271_pa_cal(struct ath_hw *ah)
+static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 {
 	u32 regVal;
 	unsigned int i;
@@ -889,10 +889,19 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah)
 		REG_WRITE(ah, 0x7834, regVal);
 	}
 
-	/*  Empirical offset correction  */
-#if 0
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9271_AN_RF2G6_OFFS, 0x20);
-#endif
+	regVal = (regVal >>20) & 0x7f;
+
+	/* Update PA cal info */
+	if ((!is_reset) && (ah->pacal_info.prev_offset == regVal)) {
+		if (ah->pacal_info.max_skipcount < MAX_PACAL_SKIPCOUNT)
+			ah->pacal_info.max_skipcount =
+				2 * ah->pacal_info.max_skipcount;
+		ah->pacal_info.skipcount = ah->pacal_info.max_skipcount;
+	} else {
+		ah->pacal_info.max_skipcount = 1;
+		ah->pacal_info.skipcount = 0;
+		ah->pacal_info.prev_offset = regVal;
+	}
 
 	regVal = REG_READ(ah, 0x7834);
 	regVal |= 0x1;
@@ -1043,7 +1052,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (longcal) {
 		/* Do periodic PAOffset Cal */
 		if (AR_SREV_9271(ah))
-			ath9k_hw_9271_pa_cal(ah);
+			ath9k_hw_9271_pa_cal(ah, false);
 		else if (AR_SREV_9285_11_OR_LATER(ah)) {
 			if (!ah->pacal_info.skipcount)
 				ath9k_hw_9285_pa_cal(ah, false);
@@ -1152,7 +1161,9 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 
 	/* Do PA Calibration */
-	if (AR_SREV_9285_11_OR_LATER(ah))
+	if (AR_SREV_9271(ah))
+		ath9k_hw_9271_pa_cal(ah, true);
+	else if (AR_SREV_9285_11_OR_LATER(ah))
 		ath9k_hw_9285_pa_cal(ah, true);
 
 	/* Do NF Calibration after DC offset and other calibrations */
-- 
1.6.0.4

