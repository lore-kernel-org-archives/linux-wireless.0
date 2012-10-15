Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52773 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2JOGo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 02:44:57 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Set appropriate bit for AR9565 in btc control register
Date: Mon, 15 Oct 2012 11:58:33 +0530
Message-ID: <1350282513-3869-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121015_084506_175357_A079BB8E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   30 ++++++++++++++++++--------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 44c202c..841f2b9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -843,15 +843,27 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	* MCI mode will be enabled later, right before reset the MCI TX and RX.
 	*/
 
-	regval = SM(1, AR_BTCOEX_CTRL_AR9462_MODE) |
-		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
-		 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
-		 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
-		 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
-		 SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
-		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
-		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
-		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
+	if (AR_SREV_9565(ah)) {
+		regval = SM(1, AR_BTCOEX_CTRL_AR9462_MODE) |
+			 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
+			 SM(0, AR_BTCOEX_CTRL_PA_SHARED) |
+			 SM(0, AR_BTCOEX_CTRL_LNA_SHARED) |
+			 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
+			 SM(1, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
+			 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
+			 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
+			 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
+	} else {
+		regval = SM(1, AR_BTCOEX_CTRL_AR9462_MODE) |
+			 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
+			 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
+			 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
+			 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
+			 SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
+			 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
+			 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
+			 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
+	}
 
 	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
 
-- 
1.7.4.1

