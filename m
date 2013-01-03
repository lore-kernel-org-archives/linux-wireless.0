Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:33549
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267Ab3ACGw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 01:52:29 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k_hw: Fix calibration for AR9340
Date: Thu,  3 Jan 2013 12:21:22 +0530
Message-Id: <1357195883-8516-2-git-send-email-sujith@msujith.org> (sfid-20130103_075233_783171_C8582854)
In-Reply-To: <1357195883-8516-1-git-send-email-sujith@msujith.org>
References: <1357195883-8516-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

TX_IQ_ON_AGC_CAL should not be enabled for AR9340.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 598b847..303e40d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -326,7 +326,7 @@ static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ah->enabled_cals |= TX_IQ_CAL;
-		if (AR_SREV_9485_OR_LATER(ah))
+		if (AR_SREV_9485_OR_LATER(ah) && !AR_SREV_9340(ah))
 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
 	}
 
-- 
1.8.1

