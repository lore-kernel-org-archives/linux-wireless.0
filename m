Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:33498 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaBGFAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 00:00:42 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 3/7] ath9k: Rename ar9003_hw_tx_iqcal_load_avg_2_passes
Date: Fri,  7 Feb 2014 10:29:51 +0530
Message-Id: <1391749195-24381-4-git-send-email-sujith@msujith.org> (sfid-20140207_060054_996499_D7EAB09C)
In-Reply-To: <1391749195-24381-1-git-send-email-sujith@msujith.org>
References: <1391749195-24381-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use ar9003_hw_tx_iq_cal_outlier_detection instead.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 0ee4250..9210beb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -886,9 +886,9 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
 	}
 }
 
-static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
-						 struct coeff *coeff,
-						 bool is_reusable)
+static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
+						  struct coeff *coeff,
+						  bool is_reusable)
 {
 	int i, im, nmeasurement;
 	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
@@ -1075,7 +1075,7 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 				coeff.phs_coeff[i][im] -= 128;
 		}
 	}
-	ar9003_hw_tx_iqcal_load_avg_2_passes(ah, &coeff, is_reusable);
+	ar9003_hw_tx_iq_cal_outlier_detection(ah, &coeff, is_reusable);
 
 	return;
 
-- 
1.8.5.3

