Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38190 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBGFAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 00:00:39 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/7] ath9k: Fix IQ cal post processing for SoC
Date: Fri,  7 Feb 2014 10:29:49 +0530
Message-Id: <1391749195-24381-2-git-send-email-sujith@msujith.org> (sfid-20140207_060053_176564_E6B2E981)
In-Reply-To: <1391749195-24381-1-git-send-email-sujith@msujith.org>
References: <1391749195-24381-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Calibration data is not reused for SoC chips, so
call ar9003_hw_tx_iq_cal_post_proc() with the correct
argument. The 'is_reusable' flag is currently used
only for PC-OEM chips, but it makes things clearer to
specify it explicity.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index a352128..225b758 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1461,7 +1461,7 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	bool txiqcal_done = false;
-	bool is_reusable = true, status = true;
+	bool status = true;
 	bool run_agc_cal = false, sep_iq_cal = false;
 
 	/* Use chip chainmask only for calibration */
@@ -1531,7 +1531,7 @@ skip_tx_iqcal:
 	}
 
 	if (txiqcal_done)
-		ar9003_hw_tx_iq_cal_post_proc(ah, is_reusable);
+		ar9003_hw_tx_iq_cal_post_proc(ah, false);
 
 	/* Revert chainmask to runtime parameters */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
-- 
1.8.5.3

