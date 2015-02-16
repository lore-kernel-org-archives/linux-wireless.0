Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37812 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbbBPFRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 00:17:22 -0500
Received: from [117.222.159.239] (port=14037 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YNE3c-000EUz-N5
	for linux-wireless@vger.kernel.org; Mon, 16 Feb 2015 00:17:21 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/9] ath9k: Handle 2-ANT AR9565 in MCI reset
Date: Mon, 16 Feb 2015 10:49:56 +0530
Message-Id: <1424064001-7009-5-git-send-email-sujith@msujith.org> (sfid-20150216_061726_656330_5DDB9597)
In-Reply-To: <1424064001-7009-1-git-send-email-sujith@msujith.org>
References: <1424064001-7009-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The value programmed in the BTCOEX control register
is different for each chip. This patch adds support
for 2-ANT, 1-ANT solutions based on AR9565.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 78 +++++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |  7 +++
 2 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 4aed985..1a48528 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -821,6 +821,61 @@ static void ar9003_mci_osla_setup(struct ath_hw *ah, bool enable)
 		      AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN, 1);
 }
 
+static void ar9003_mci_set_btcoex_ctrl_9565_1ANT(struct ath_hw *ah)
+{
+	u32 regval;
+
+	regval = SM(1, AR_BTCOEX_CTRL_AR9462_MODE) |
+		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
+		 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
+		 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
+		 SM(1, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
+		 SM(1, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
+		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
+		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
+		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
+
+	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
+		      AR_BTCOEX_CTRL2_TX_CHAIN_MASK, 0x1);
+	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
+}
+
+static void ar9003_mci_set_btcoex_ctrl_9565_2ANT(struct ath_hw *ah)
+{
+	u32 regval;
+
+	regval = SM(1, AR_BTCOEX_CTRL_AR9462_MODE) |
+		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
+		 SM(0, AR_BTCOEX_CTRL_PA_SHARED) |
+		 SM(0, AR_BTCOEX_CTRL_LNA_SHARED) |
+		 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
+		 SM(1, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
+		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
+		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
+		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
+
+	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
+		      AR_BTCOEX_CTRL2_TX_CHAIN_MASK, 0x0);
+	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
+}
+
+static void ar9003_mci_set_btcoex_ctrl_9462(struct ath_hw *ah)
+{
+	u32 regval;
+
+        regval = SM(1, AR_BTCOEX_CTRL_AR9462_MODE) |
+		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
+		 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
+		 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
+		 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
+		 SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
+		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
+		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
+		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
+
+	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
+}
+
 int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		     bool is_full_sleep)
 {
@@ -845,26 +900,17 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	* To avoid MCI state machine be affected by incoming remote MCI msgs,
 	* MCI mode will be enabled later, right before reset the MCI TX and RX.
 	*/
-
-	regval = SM(1, AR_BTCOEX_CTRL_AR9462_MODE) |
-		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
-		 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
-		 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
-		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
-		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
-		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
 	if (AR_SREV_9565(ah)) {
-		regval |= SM(1, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
-			  SM(1, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
-		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
-			      AR_BTCOEX_CTRL2_TX_CHAIN_MASK, 0x1);
+		u8 ant = MS(mci->config, ATH_MCI_CONFIG_ANT_ARCH);
+
+		if (ant == ATH_MCI_ANT_ARCH_1_ANT_PA_LNA_SHARED)
+			ar9003_mci_set_btcoex_ctrl_9565_1ANT(ah);
+		else
+			ar9003_mci_set_btcoex_ctrl_9565_2ANT(ah);
 	} else {
-		regval |= SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
-			  SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
+		ar9003_mci_set_btcoex_ctrl_9462(ah);
 	}
 
-	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
-
 	if (is_2g && !(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
 		ar9003_mci_osla_setup(ah, true);
 	else
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index e8b1914..6f305ab 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -109,8 +109,15 @@ enum mci_gpm_coex_bt_update_flags_op {
 #define ATH_MCI_CONFIG_MCI_OBS_MASK     (ATH_MCI_CONFIG_MCI_OBS_MCI  | \
 					 ATH_MCI_CONFIG_MCI_OBS_TXRX | \
 					 ATH_MCI_CONFIG_MCI_OBS_BT)
+
 #define ATH_MCI_CONFIG_MCI_OBS_GPIO     0x0000002F
 
+#define ATH_MCI_ANT_ARCH_1_ANT_PA_LNA_NON_SHARED 0x00
+#define ATH_MCI_ANT_ARCH_1_ANT_PA_LNA_SHARED     0x01
+#define ATH_MCI_ANT_ARCH_2_ANT_PA_LNA_NON_SHARED 0x02
+#define ATH_MCI_ANT_ARCH_2_ANT_PA_LNA_SHARED     0x03
+#define ATH_MCI_ANT_ARCH_3_ANT                   0x04
+
 enum mci_message_header {		/* length of payload */
 	MCI_LNA_CTRL     = 0x10,        /* len = 0 */
 	MCI_CONT_NACK    = 0x20,        /* len = 0 */
-- 
2.3.0

