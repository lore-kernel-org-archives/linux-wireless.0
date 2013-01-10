Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:53095
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab3AJQEu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 11:04:50 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] Revert "ath9k_hw: Fix calibration for AR9340"
Date: Thu, 10 Jan 2013 21:33:50 +0530
Message-Id: <1357833830-24005-1-git-send-email-sujith@msujith.org> (sfid-20130110_170454_400213_00E19FB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This reverts commit 03c2dc73581ad4ae54f1ccfc1463929b16b8b736.

The change for AR9340 breaks TP-Link TL-WDR4300, we can re-submit this
change once the HW differences are identified and appropriate code
changes have been made.

Reported-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 9221f32..4caa80b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -319,7 +319,7 @@ static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ah->enabled_cals |= TX_IQ_CAL;
-		if (AR_SREV_9485_OR_LATER(ah) && !AR_SREV_9340(ah))
+		if (AR_SREV_9485_OR_LATER(ah))
 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
 	}
 
-- 
1.8.1

