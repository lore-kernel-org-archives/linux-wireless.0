Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:38583
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751820Ab2KQPvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 10:51:18 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: [PATCH] ath9k_hw: Fix regression in device reset
Date: Sat, 17 Nov 2012 21:20:50 +0530
Message-Id: <1353167450-3732-1-git-send-email-sujith@msujith.org> (sfid-20121117_165129_332022_7286035F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Commit "ath9k: improve suspend/resume reliability" broke ath9k_htc
and bringing up the device would hang indefinitely. Fix this.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 756191b..e06bcec 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1456,7 +1456,7 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 	switch (type) {
 	case ATH9K_RESET_POWER_ON:
 		ret = ath9k_hw_set_reset_power_on(ah);
-		if (!ret)
+		if (ret)
 			ah->reset_power_on = true;
 		break;
 	case ATH9K_RESET_WARM:
-- 
1.8.0

