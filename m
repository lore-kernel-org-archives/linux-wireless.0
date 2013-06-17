Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45400 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab3FQBel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jun 2013 21:34:41 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix LNA gpio for AR9485
Date: Mon, 17 Jun 2013 07:01:47 +0530
Message-Id: <1371432707-5900-1-git-send-email-sujith@msujith.org> (sfid-20130617_033456_240085_0A5728E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit "ath9k: Add custom parameters for CUS198" didn't
pass the correct gpio value to ath9k_hw_cfg_output(). Fix it.

Reported-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 9a00bc0..eae23b9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3576,7 +3576,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		else
 			gpio = AR9300_EXT_LNA_CTL_GPIO_AR9485;
 
-		ath9k_hw_cfg_output(ah, AR9300_EXT_LNA_CTL_GPIO_AR9485,
+		ath9k_hw_cfg_output(ah, gpio,
 				    AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED);
 	}
 
-- 
1.8.3.1

