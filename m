Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031471Ab2CFWnb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:31 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 08/33] iwlwifi: move rfkill status handling out of transport
Date: Tue,  6 Mar 2012 13:30:43 -0800
Message-Id: <1331069468-11074-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234337_645073_2FC773E2)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The transport layer should only check the
hardware RF kill status, not impose any
policy or reaction based on it, so move
that out of it into the op_mode.

For now keep the restriction on loading
firmware, that will have to be removed
later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c          |    5 +++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   24 +++----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |   39 +++++++---------------
 3 files changed, 22 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 88842de..c5fcbdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1470,6 +1470,11 @@ void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
+	if (state)
+		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
+	else
+		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
+
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index c3c2de3..e8d3129 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1016,30 +1016,16 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 
 	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
-		int hw_rf_kill = 0;
-		if (!(iwl_read32(trans, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
-			hw_rf_kill = 1;
+		bool hw_rfkill;
 
+		hw_rfkill = !(iwl_read32(trans, CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
-				hw_rf_kill ? "disable radio" : "enable radio");
+				hw_rfkill ? "disable radio" : "enable radio");
 
 		isr_stats->rfkill++;
 
-		/* driver only loads ucode once setting the interface up.
-		 * the driver allows loading the ucode even if the radio
-		 * is killed. Hence update the killswitch state here. The
-		 * rfkill handler will care about restarting if needed.
-		 */
-		if (!test_bit(STATUS_ALIVE, &trans->shrd->status)) {
-			if (hw_rf_kill)
-				set_bit(STATUS_RF_KILL_HW,
-					&trans->shrd->status);
-			else
-				clear_bit(STATUS_RF_KILL_HW,
-					  &trans->shrd->status);
-			iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rf_kill);
-		}
+		iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index d7dbd80..4a05216 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1021,6 +1021,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	int ret;
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
+	bool hw_rfkill;
 
 	trans->shrd->ucode_owner = IWL_OWNERSHIP_DRIVER;
 	trans_pcie->ac_to_queue[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_queue;
@@ -1039,14 +1040,11 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(trans, CSR_GP_CNTRL) &
-			CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-	else
-		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+	hw_rfkill = !(iwl_read32(trans, CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
+	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
-	if (iwl_is_rfkill(trans->shrd)) {
-		iwl_op_mode_hw_rf_kill(trans->op_mode, true);
+	if (hw_rfkill) {
 		iwl_enable_interrupts(trans);
 		return -ERFKILL;
 	}
@@ -1506,6 +1504,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 	int err;
+	bool hw_rfkill;
 
 	trans_pcie->inta_mask = CSR_INI_SET_MASK;
 
@@ -1535,16 +1534,9 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 
 	iwl_apm_init(trans);
 
-	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(trans,
-			CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-	else
-		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-
-	iwl_op_mode_hw_rf_kill(trans->op_mode,
-				test_bit(STATUS_RF_KILL_HW,
-					 &trans->shrd->status));
+	hw_rfkill = !(iwl_read32(trans, CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
+	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
 	return err;
 
@@ -1659,19 +1651,12 @@ static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 
 static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 {
-	bool hw_rfkill = false;
+	bool hw_rfkill;
 
 	iwl_enable_interrupts(trans);
 
-	if (!(iwl_read32(trans, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
-		hw_rfkill = true;
-
-	if (hw_rfkill)
-		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-	else
-		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
-
+	hw_rfkill = !(iwl_read32(trans, CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
 	return 0;
-- 
1.7.0.4

