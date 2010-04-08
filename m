Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab0DHT1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 046/102] ath9k_hw: add a helper for Power Amplifier calibration for AR9002
Date: Thu,  8 Apr 2010 15:26:42 -0400
Message-Id: <1270754858-26266-47-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code can be simplified and shared between two locations if we bring
this into a helper. During reset we do not account for the skip count.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index eed2c76..26bc381 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -949,6 +949,21 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah, bool is_reset)
 
 }
 
+static void ar9002_hw_pa_cal(struct ath_hw *ah, bool is_reset)
+{
+	if (AR_SREV_9271(ah)) {
+		if (is_reset || !ah->pacal_info.skipcount)
+			ath9k_hw_9271_pa_cal(ah, is_reset);
+		else
+			ah->pacal_info.skipcount--;
+	} else if (AR_SREV_9285_11_OR_LATER(ah)) {
+		if (is_reset || !ah->pacal_info.skipcount)
+			ath9k_hw_9285_pa_cal(ah, is_reset);
+		else
+			ah->pacal_info.skipcount--;
+	}
+}
+
 bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			u8 rxchainmask, bool longcal)
 {
@@ -973,17 +988,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 	/* Do NF cal only at longer intervals */
 	if (longcal) {
 		/* Do periodic PAOffset Cal */
-		if (AR_SREV_9271(ah)) {
-			if (!ah->pacal_info.skipcount)
-				ath9k_hw_9271_pa_cal(ah, false);
-			else
-				ah->pacal_info.skipcount--;
-		} else if (AR_SREV_9285_11_OR_LATER(ah)) {
-			if (!ah->pacal_info.skipcount)
-				ath9k_hw_9285_pa_cal(ah, false);
-			else
-				ah->pacal_info.skipcount--;
-		}
+		ar9002_hw_pa_cal(ah, false);
 
 		if (OLC_FOR_AR9280_20_LATER || OLC_FOR_AR9287_10_LATER)
 			ath9k_olc_temp_compensation(ah);
@@ -1142,10 +1147,7 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 
 	/* Do PA Calibration */
-	if (AR_SREV_9271(ah))
-		ath9k_hw_9271_pa_cal(ah, true);
-	else if (AR_SREV_9285_11_OR_LATER(ah))
-		ath9k_hw_9285_pa_cal(ah, true);
+	ar9002_hw_pa_cal(ah, true);
 
 	/* Do NF Calibration after DC offset and other calibrations */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-- 
1.6.3.3

