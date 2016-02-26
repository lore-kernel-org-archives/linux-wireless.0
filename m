Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60806 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbcBZILG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 03:11:06 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 11/13] ath9k: enable manual peak cal for all ar9300 chips
Date: Fri, 26 Feb 2016 16:08:41 +0800
Message-Id: <1456474123-10520-12-git-send-email-miaoqing@codeaurora.org> (sfid-20160226_092949_488780_B4F2BF64)
In-Reply-To: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
References: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

HW peak detect calibration would fail, enable all ar9300
chips manual peak calibration instead.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 0c39199..99bc1a6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1641,14 +1641,12 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 
 skip_tx_iqcal:
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
-		if (AR_SREV_9330_11(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah) ||
-		    AR_SREV_9561(ah)) {
-			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-				if (!(ah->rxchainmask & (1 << i)))
-					continue;
-				ar9003_hw_manual_peak_cal(ah, i,
-							  IS_CHAN_2GHZ(chan));
-			}
+		for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+			if (!(ah->rxchainmask & (1 << i)))
+				continue;
+
+			ar9003_hw_manual_peak_cal(ah, i,
+						  IS_CHAN_2GHZ(chan));
 		}
 
 		/*
-- 
1.9.1

