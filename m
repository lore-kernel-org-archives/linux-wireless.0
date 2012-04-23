Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab2DWVwx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/29] iwlwifi: make a static inline to read the RF kill register
Date: Mon, 23 Apr 2012 14:47:12 -0700
Message-Id: <1335217660-21950-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235259_323868_CAB0F2B3)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    3 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    9 +++------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index c7f8f40..8a175e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -430,4 +430,10 @@ trans_pcie_get_cmd_string(struct iwl_trans_pcie *trans_pcie, u8 cmd)
 	return trans_pcie->command_names[cmd];
 }
 
+static inline bool iwl_is_rfkill_set(struct iwl_trans *trans)
+{
+	return !(iwl_read32(trans, CSR_GP_CNTRL) &
+		CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
+}
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 47c1f0a..d2239aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -648,8 +648,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		bool hw_rfkill;
 
-		hw_rfkill = !(iwl_read32(trans, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
+		hw_rfkill = iwl_is_rfkill_set(trans);
 		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
 				hw_rfkill ? "disable radio" : "enable radio");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index e6401e8..1d9724d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -981,8 +981,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	hw_rfkill = !(iwl_read32(trans, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
+	hw_rfkill = iwl_is_rfkill_set(trans);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
 	if (hw_rfkill) {
@@ -1422,8 +1421,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 
 	iwl_apm_init(trans);
 
-	hw_rfkill = !(iwl_read32(trans, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
+	hw_rfkill = iwl_is_rfkill_set(trans);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
 	return err;
@@ -1562,8 +1560,7 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 {
 	bool hw_rfkill;
 
-	hw_rfkill = !(iwl_read32(trans, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
+	hw_rfkill = iwl_is_rfkill_set(trans);
 
 	if (hw_rfkill)
 		iwl_enable_rfkill_int(trans);
-- 
1.7.0.4

