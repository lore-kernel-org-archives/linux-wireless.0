Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38707 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbA2BzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:55:01 -0500
Received: from [117.199.141.188] (port=12173 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YGRck-001zZ7-B0
	for linux-wireless@vger.kernel.org; Wed, 28 Jan 2015 07:21:34 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 4/6] ath9k: Fix manual peak calibration initialization
Date: Wed, 28 Jan 2015 17:54:24 +0530
Message-Id: <1422447866-19967-5-git-send-email-sujith@msujith.org> (sfid-20150129_025510_087194_66E35609)
In-Reply-To: <1422447866-19967-1-git-send-email-sujith@msujith.org>
References: <1422447866-19967-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The LNA gain setting override needs to be done
only for AR9330 and PCOEM chips.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 38 +++++++++++++++++++++------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 06ab71d..374aef1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1205,22 +1205,34 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 	int offset[8] = {0}, total = 0, test;
 	int agc_out, i;
 
+	/*
+	 * Turn off LNA/SW.
+	 */
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
 		      AR_PHY_65NM_RXRF_GAINSTAGES_RX_OVERRIDE, 0x1);
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
 		      AR_PHY_65NM_RXRF_GAINSTAGES_LNAON_CALDC, 0x0);
-	if (is_2g)
-		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
-			      AR_PHY_65NM_RXRF_GAINSTAGES_LNA2G_GAIN_OVR, 0x0);
-	else
-		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
-			      AR_PHY_65NM_RXRF_GAINSTAGES_LNA5G_GAIN_OVR, 0x0);
 
+	if (AR_SREV_9003_PCOEM(ah) || AR_SREV_9330_11(ah)) {
+		if (is_2g)
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
+				      AR_PHY_65NM_RXRF_GAINSTAGES_LNA2G_GAIN_OVR, 0x0);
+		else
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
+				      AR_PHY_65NM_RXRF_GAINSTAGES_LNA5G_GAIN_OVR, 0x0);
+	}
+
+	/*
+	 * Turn off RXON.
+	 */
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXTX2(chain),
 		      AR_PHY_65NM_RXTX2_RXON_OVR, 0x1);
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXTX2(chain),
 		      AR_PHY_65NM_RXTX2_RXON, 0x0);
 
+	/*
+	 * Turn on AGC for cal.
+	 */
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 		      AR_PHY_65NM_RXRF_AGC_AGC_OVERRIDE, 0x1);
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
@@ -1228,10 +1240,11 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 		      AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR, 0x1);
 
-	if (AR_SREV_9330_11(ah)) {
+	if (AR_SREV_9330_11(ah))
 		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 			      AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR, 0x0);
-	} else {
+
+	if (AR_SREV_9003_PCOEM(ah)) {
 		if (is_2g)
 			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 				      AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR, 0x0);
@@ -1266,10 +1279,19 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 			      AR_PHY_65NM_RXRF_AGC_AGC5G_CALDAC_OVR, total);
 
+	/*
+	 * Turn on LNA.
+	 */
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
 		      AR_PHY_65NM_RXRF_GAINSTAGES_RX_OVERRIDE, 0);
+	/*
+	 * Turn off RXON.
+	 */
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXTX2(chain),
 		      AR_PHY_65NM_RXTX2_RXON_OVR, 0);
+	/*
+	 * Turn off peak detect calibration.
+	 */
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 		      AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR, 0);
 }
-- 
2.2.2

