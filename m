Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52227 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3KQFOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Nov 2013 00:14:54 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] ath9k: Remove unnecessary check
Date: Sun, 17 Nov 2013 10:40:14 +0530
Message-Id: <1384665016-12022-3-git-send-email-sujith@msujith.org> (sfid-20131117_061522_109944_A9728C12)
In-Reply-To: <1384665016-12022-1-git-send-email-sujith@msujith.org>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

TX IQ calibration is always enabled for SoC chips.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 2824824..347b002 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1252,8 +1252,7 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 		}
 	}
 
-	if ((IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan)) ||
-	    !(ah->enabled_cals & TX_IQ_CAL))
+	if (IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan))
 		goto skip_tx_iqcal;
 
 	/* Do Tx IQ Calibration */
-- 
1.8.4.2

