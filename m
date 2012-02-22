Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29275 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2BVHMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:12:19 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38218.252732.925600@gargle.gargle.HOWL> (sfid-20120222_081223_230409_B8C786F5)
Date: Wed, 22 Feb 2012 12:42:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 23/26] ath9k_hw: Cleanup MCI reset routine
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Use a separate function to enable/disable
  OneStepLookAhead.

* Remove unnecessary hardware SREV checks.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   91 ++++++++++++++-------------
 1 files changed, 47 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 4079676..8d3659c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -902,20 +902,46 @@ static void ar9003_mci_mute_bt(struct ath_hw *ah)
 	ar9003_mci_send_sys_sleeping(ah, true);
 }
 
+static void ar9003_mci_osla_setup(struct ath_hw *ah, bool enable)
+{
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+	u32 thresh;
+
+	if (enable) {
+		REG_RMW_FIELD(ah, AR_MCI_SCHD_TABLE_2,
+			      AR_MCI_SCHD_TABLE_2_HW_BASED, 1);
+		REG_RMW_FIELD(ah, AR_MCI_SCHD_TABLE_2,
+			      AR_MCI_SCHD_TABLE_2_MEM_BASED, 1);
+
+		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_AGGR_THRESH)) {
+			thresh = MS(mci->config, ATH_MCI_CONFIG_AGGR_THRESH);
+			REG_RMW_FIELD(ah, AR_BTCOEX_CTRL,
+				      AR_BTCOEX_CTRL_AGGR_THRESH, thresh);
+			REG_RMW_FIELD(ah, AR_BTCOEX_CTRL,
+				      AR_BTCOEX_CTRL_TIME_TO_NEXT_BT_THRESH_EN, 1);
+		} else {
+			REG_RMW_FIELD(ah, AR_BTCOEX_CTRL,
+				      AR_BTCOEX_CTRL_TIME_TO_NEXT_BT_THRESH_EN, 0);
+		}
+
+		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL,
+			      AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN, 1);
+	} else {
+		REG_CLR_BIT(ah, AR_BTCOEX_CTRL,
+			    AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
+	}
+}
+
 void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		      bool is_full_sleep)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
-	u32 regval, thresh;
+	u32 regval;
 
-	ath_dbg(common, MCI, "MCI full_sleep = %d, is_2g = %d\n",
+	ath_dbg(common, MCI, "MCI Reset (full_sleep = %d, is_2g = %d)\n",
 		is_full_sleep, is_2g);
 
-	/*
-	 * GPM buffer and scheduling message buffer are not allocated
-	 */
-
 	if (!mci->gpm_addr && !mci->sched_addr) {
 		ath_dbg(common, MCI,
 			"MCI GPM and schedule buffers are not allocated\n");
@@ -923,7 +949,7 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	}
 
 	if (REG_READ(ah, AR_BTCOEX_CTRL) == 0xdeadbeef) {
-		ath_dbg(common, MCI, "MCI it's deadbeef, quit mci_reset\n");
+		ath_dbg(common, MCI, "BTCOEX control register is dead\n");
 		return;
 	}
 
@@ -947,46 +973,23 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
 		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
 
-	if (is_2g && (AR_SREV_9462_20(ah)) &&
-		!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA)) {
-
-		regval |= SM(1, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
-		ath_dbg(common, MCI, "MCI sched one step look ahead\n");
-
-		if (!(mci->config &
-		      ATH_MCI_CONFIG_DISABLE_AGGR_THRESH)) {
-
-			thresh = MS(mci->config,
-				    ATH_MCI_CONFIG_AGGR_THRESH);
-			thresh &= 7;
-			regval |= SM(1,
-				     AR_BTCOEX_CTRL_TIME_TO_NEXT_BT_THRESH_EN);
-			regval |= SM(thresh, AR_BTCOEX_CTRL_AGGR_THRESH);
-
-			REG_RMW_FIELD(ah, AR_MCI_SCHD_TABLE_2,
-				      AR_MCI_SCHD_TABLE_2_HW_BASED, 1);
-			REG_RMW_FIELD(ah, AR_MCI_SCHD_TABLE_2,
-				      AR_MCI_SCHD_TABLE_2_MEM_BASED, 1);
-
-		} else
-			ath_dbg(common, MCI, "MCI sched aggr thresh: off\n");
-	} else
-		ath_dbg(common, MCI, "MCI SCHED one step look ahead off\n");
-
 	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
 
-	if (AR_SREV_9462_20(ah)) {
-		REG_SET_BIT(ah, AR_PHY_GLB_CONTROL,
-			    AR_BTCOEX_CTRL_SPDT_ENABLE);
-		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL3,
-			      AR_BTCOEX_CTRL3_CONT_INFO_TIMEOUT, 20);
-	}
+	if (is_2g && !(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
+		ar9003_mci_osla_setup(ah, true);
+	else
+		ar9003_mci_osla_setup(ah, false);
+
+	REG_SET_BIT(ah, AR_PHY_GLB_CONTROL,
+		    AR_BTCOEX_CTRL_SPDT_ENABLE);
+	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL3,
+		      AR_BTCOEX_CTRL3_CONT_INFO_TIMEOUT, 20);
 
 	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2, AR_BTCOEX_CTRL2_RX_DEWEIGHT, 1);
 	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
 
-	thresh = MS(mci->config, ATH_MCI_CONFIG_CLK_DIV);
-	REG_RMW_FIELD(ah, AR_MCI_TX_CTRL, AR_MCI_TX_CTRL_CLK_DIV, thresh);
+	regval = MS(mci->config, ATH_MCI_CONFIG_CLK_DIV);
+	REG_RMW_FIELD(ah, AR_MCI_TX_CTRL, AR_MCI_TX_CTRL_CLK_DIV, regval);
 	REG_SET_BIT(ah, AR_BTCOEX_CTRL, AR_BTCOEX_CTRL_MCI_MODE_EN);
 
 	/* Resetting the Rx and Tx paths of MCI */
@@ -1011,15 +1014,15 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	REG_WRITE(ah, AR_MCI_COMMAND2, regval);
 
 	ar9003_mci_state(ah, MCI_STATE_INIT_GPM_OFFSET, NULL);
+
 	REG_WRITE(ah, AR_MCI_MSG_ATTRIBUTES_TABLE,
 		  (SM(0xe801, AR_MCI_MSG_ATTRIBUTES_TABLE_INVALID_HDR) |
 		   SM(0x0000, AR_MCI_MSG_ATTRIBUTES_TABLE_CHECKSUM)));
 
 	REG_CLR_BIT(ah, AR_MCI_TX_CTRL,
-			AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
+		    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
 
-	if (AR_SREV_9462_20_OR_LATER(ah))
-		ar9003_mci_observation_set_up(ah);
+	ar9003_mci_observation_set_up(ah);
 
 	mci->ready = true;
 	ar9003_mci_prep_interface(ah);
-- 
1.7.9.1

