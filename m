Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41929 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbbASCK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 21:10:57 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [PATCH 5/6] ath9k: Set correct peak detect threshold
Date: Mon, 19 Jan 2015 07:43:17 +0530
Message-Id: <1421633598-4488-6-git-send-email-sujith@msujith.org> (sfid-20150119_031105_710177_0A1EDB6E)
In-Reply-To: <1421633598-4488-1-git-send-email-sujith@msujith.org>
References: <1421633598-4488-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The value is different for PCOEM cards and AR955x/AR953x.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 374aef1..91130c0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1203,7 +1203,12 @@ static void ar9003_hw_tx_iq_cal_reload(struct ath_hw *ah)
 static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 {
 	int offset[8] = {0}, total = 0, test;
-	int agc_out, i;
+	int agc_out, i, peak_detect_threshold;
+
+	if (AR_SREV_9550(ah) || AR_SREV_9531(ah))
+		peak_detect_threshold = 8;
+	else
+		peak_detect_threshold = 0;
 
 	/*
 	 * Turn off LNA/SW.
@@ -1244,13 +1249,15 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 			      AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR, 0x0);
 
-	if (AR_SREV_9003_PCOEM(ah)) {
+	if (AR_SREV_9003_PCOEM(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
 		if (is_2g)
 			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
-				      AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR, 0x0);
+				      AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR,
+				      peak_detect_threshold);
 		else
 			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
-				      AR_PHY_65NM_RXRF_AGC_AGC5G_DBDAC_OVR, 0x0);
+				      AR_PHY_65NM_RXRF_AGC_AGC5G_DBDAC_OVR,
+				      peak_detect_threshold);
 	}
 
 	for (i = 6; i > 0; i--) {
-- 
2.2.2

