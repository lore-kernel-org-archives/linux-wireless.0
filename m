Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60848 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbcBZILQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 03:11:16 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 13/13] ath9k: set correct peak detect threshold
Date: Fri, 26 Feb 2016 16:08:43 +0800
Message-Id: <1456474123-10520-14-git-send-email-miaoqing@codeaurora.org> (sfid-20160226_091119_875380_8BCAC832)
In-Reply-To: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
References: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Set QCA9561 peak detect threshold to 11.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index e1573ab..518e649 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1203,12 +1203,12 @@ static void ar9003_hw_tx_iq_cal_reload(struct ath_hw *ah)
 static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 {
 	int offset[8] = {0}, total = 0, test;
-	int agc_out, i, peak_detect_threshold;
+	int agc_out, i, peak_detect_threshold = 0;
 
 	if (AR_SREV_9550(ah) || AR_SREV_9531(ah))
 		peak_detect_threshold = 8;
-	else
-		peak_detect_threshold = 0;
+	else if (AR_SREV_9561(ah))
+		peak_detect_threshold = 11;
 
 	/*
 	 * Turn off LNA/SW.
@@ -1249,17 +1249,14 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 			      AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR, 0x0);
 
-	if (AR_SREV_9003_PCOEM(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
-	    AR_SREV_9561(ah)) {
-		if (is_2g)
-			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
-				      AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR,
-				      peak_detect_threshold);
-		else
-			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
-				      AR_PHY_65NM_RXRF_AGC_AGC5G_DBDAC_OVR,
-				      peak_detect_threshold);
-	}
+	if (is_2g)
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+			      AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR,
+			      peak_detect_threshold);
+	else
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+			      AR_PHY_65NM_RXRF_AGC_AGC5G_DBDAC_OVR,
+			      peak_detect_threshold);
 
 	for (i = 6; i > 0; i--) {
 		offset[i] = BIT(i - 1);
-- 
1.9.1

