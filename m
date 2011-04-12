Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38921 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab1DLNS2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:18:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:18:03 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/22] ath9k_hw: Clean up rx/tx chain configuration before AGC/IQ cal
Date: Tue, 12 Apr 2011 18:47:47 +0530
Message-ID: <1302614273-2063-7-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
References: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use hw supported chains instead of hard coded values.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 4a4cd88..09f3aa7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -940,21 +940,18 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			       struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	int val;
 
 	val = REG_READ(ah, AR_ENT_OTP);
 	ath_dbg(common, ATH_DBG_CALIBRATE, "ath9k: AR_ENT_OTP 0x%x\n", val);
 
-	if (AR_SREV_9485(ah))
-		ar9003_hw_set_chain_masks(ah, 0x1, 0x1);
-	else if (val & AR_ENT_OTP_CHAIN2_DISABLE)
+	/* Configure rx/tx chains before running AGC/TxiQ cals */
+	if (val & AR_ENT_OTP_CHAIN2_DISABLE)
 		ar9003_hw_set_chain_masks(ah, 0x3, 0x3);
 	else
-		/*
-		 * 0x7 = 0b111 , AR9003 needs to be configured for 3-chain
-		 * mode before running AGC/TxIQ cals
-		 */
-		ar9003_hw_set_chain_masks(ah, 0x7, 0x7);
+		ar9003_hw_set_chain_masks(ah, pCap->rx_chainmask,
+					  pCap->tx_chainmask);
 
 	/* Do Tx IQ Calibration */
 	if (AR_SREV_9485(ah))
-- 
1.7.0.4

