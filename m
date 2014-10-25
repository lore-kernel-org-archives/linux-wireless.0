Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:35424
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbaJYTeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:34:19 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 02/10] ath9k_hw: remove support for UB124 tx gain table
Date: Sat, 25 Oct 2014 17:19:27 +0200
Message-Id: <1414250375-74121-2-git-send-email-nbd@openwrt.org> (sfid-20141025_213423_162053_67B392F0)
In-Reply-To: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
References: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

UB124 is a USB based reference design not supported by ath9k or
ath9k_htc.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index ddef9ee..cb09102 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -670,9 +670,6 @@ static void ar9003_tx_gain_table_mode5(struct ath_hw *ah)
 	if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9485Modes_green_ob_db_tx_gain_1_1);
-	else if (AR_SREV_9340(ah))
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9340Modes_ub124_tx_gain_table_1p0);
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9580_1p0_type5_tx_gain_table);
-- 
2.1.2

