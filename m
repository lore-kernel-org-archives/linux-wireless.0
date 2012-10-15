Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51873 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2JOINJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 04:13:09 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH 03/12] ath9k: Set appropriate bit for AR9565 in btc control register
Date: Mon, 15 Oct 2012 13:25:29 +0530
Message-ID: <1350287738-18687-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_101315_827992_7BCA5A1F)
In-Reply-To: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bala Shanmugam <bkamatch@qca.qualcomm.com>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 6fbd376..b2b9941 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -850,11 +850,18 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
 		 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
 		 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
-		 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
-		 SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
 		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
 		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
 		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
+	if (AR_SREV_9565(ah)) {
+		regval |= SM(1, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
+			  SM(1, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
+		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
+			      AR_BTCOEX_CTRL2_TX_CHAIN_MASK, 0x1);
+	} else {
+		regval |= SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
+			  SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
+	}
 
 	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
 
-- 
1.7.12.2

