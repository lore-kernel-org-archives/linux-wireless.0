Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38926 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1DLNSt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:18:49 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:18:23 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 18/22] ath9k_hw: Read iq calibration data only for active chains
Date: Tue, 12 Apr 2011 18:47:51 +0530
Message-ID: <1302614273-2063-11-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
References: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 09f3aa7..bceff49 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -185,17 +185,19 @@ static void ar9003_hw_iqcal_collect(struct ath_hw *ah)
 
 	/* Accumulate IQ cal measures for active chains */
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ah->totalPowerMeasI[i] +=
-			REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ah->totalPowerMeasQ[i] +=
-			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ah->totalIqCorrMeas[i] +=
-			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
-			"%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
-			ah->cal_samples, i, ah->totalPowerMeasI[i],
-			ah->totalPowerMeasQ[i],
-			ah->totalIqCorrMeas[i]);
+		if (ah->txchainmask & BIT(i)) {
+			ah->totalPowerMeasI[i] +=
+				REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
+			ah->totalPowerMeasQ[i] +=
+				REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
+			ah->totalIqCorrMeas[i] +=
+				(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
+			ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+				"%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
+				ah->cal_samples, i, ah->totalPowerMeasI[i],
+				ah->totalPowerMeasQ[i],
+				ah->totalIqCorrMeas[i]);
+		}
 	}
 }
 
-- 
1.7.0.4

