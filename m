Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29318 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab1DAKCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:02:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 03:01:46 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_hw: Use appropriate rx gain table for AR9485
Date: Fri, 1 Apr 2011 15:32:16 +0530
Message-ID: <1301652136-1807-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 3daf3df..aebaad9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -66,8 +66,8 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		/* rx/tx gain */
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9485_common_rx_gain_1_1,
-				ARRAY_SIZE(ar9485_common_rx_gain_1_1), 2);
+				ar9485Common_wo_xlna_rx_gain_1_1,
+				ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1), 2);
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 				ar9485_modes_lowest_ob_db_tx_gain_1_1,
 				ARRAY_SIZE(ar9485_modes_lowest_ob_db_tx_gain_1_1),
@@ -220,8 +220,8 @@ static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 	default:
 		if (AR_SREV_9485_11(ah))
 			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				       ar9485_common_rx_gain_1_1,
-				       ARRAY_SIZE(ar9485_common_rx_gain_1_1),
+				       ar9485Common_wo_xlna_rx_gain_1_1,
+				       ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
 				       2);
 		else
 			INIT_INI_ARRAY(&ah->iniModesRxGain,
-- 
1.7.0.4

