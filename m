Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40962 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752252AbdG1O0G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:31 +0300
Message-Id: <20170728142337.19183-19-luca@coelho.fi> (sfid-20170728_162611_976938_445AFA73)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 18/24] iwlwifi: pcie: rename iwl_trans_check_hw_rf_kill() to pcie
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Rename this function to the more appropriate iwl_pcie_check_hw_rf_kill()
since it's only a function in the pcie code and cannot be called from
any other place.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        | 4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index f16c1bb9bf94..87712aeac31f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -805,11 +805,11 @@ static int iwl_pci_resume(struct device *device)
 	/*
 	 * Enable rfkill interrupt (in order to keep track of the rfkill
 	 * status). Must be locked to avoid processing a possible rfkill
-	 * interrupt while in iwl_trans_check_hw_rf_kill().
+	 * interrupt while in iwl_pcie_check_hw_rf_kill().
 	 */
 	mutex_lock(&trans_pcie->mutex);
 	iwl_enable_rfkill_int(trans);
-	iwl_trans_check_hw_rf_kill(trans);
+	iwl_pcie_check_hw_rf_kill(trans);
 	mutex_unlock(&trans_pcie->mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index fa315d84e98e..a8ffd4ca8cd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -791,7 +791,7 @@ void iwl_pcie_enable_rx_wake(struct iwl_trans *trans, bool enable);
 void iwl_pcie_apm_config(struct iwl_trans *trans);
 int iwl_pcie_prepare_card_hw(struct iwl_trans *trans);
 void iwl_pcie_synchronize_irqs(struct iwl_trans *trans);
-bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans);
+bool iwl_pcie_check_hw_rf_kill(struct iwl_trans *trans);
 void iwl_trans_pcie_handle_stop_rfkill(struct iwl_trans *trans,
 				       bool was_in_rfkill);
 void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index b84b78293e7b..c59f4581e972 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -307,7 +307,7 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 	mutex_lock(&trans_pcie->mutex);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
+	hw_rfkill = iwl_pcie_check_hw_rf_kill(trans);
 	if (hw_rfkill && !run_in_rfkill) {
 		ret = -ERFKILL;
 		goto out;
@@ -340,7 +340,7 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 		goto out;
 
 	/* re-check RF-Kill state since we may have missed the interrupt */
-	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
+	hw_rfkill = iwl_pcie_check_hw_rf_kill(trans);
 	if (hw_rfkill && !run_in_rfkill)
 		ret = -ERFKILL;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 92b3a55d0fbc..3fac3f29a139 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -986,7 +986,7 @@ static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
 					       &first_ucode_section);
 }
 
-bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans)
+bool iwl_pcie_check_hw_rf_kill(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie =  IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill = iwl_is_rfkill_set(trans);
@@ -1252,7 +1252,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	mutex_lock(&trans_pcie->mutex);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
+	hw_rfkill = iwl_pcie_check_hw_rf_kill(trans);
 	if (hw_rfkill && !run_in_rfkill) {
 		ret = -ERFKILL;
 		goto out;
@@ -1300,7 +1300,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		ret = iwl_pcie_load_given_ucode(trans, fw);
 
 	/* re-check RF-Kill state since we may have missed the interrupt */
-	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
+	hw_rfkill = iwl_pcie_check_hw_rf_kill(trans);
 	if (hw_rfkill && !run_in_rfkill)
 		ret = -ERFKILL;
 
@@ -1663,7 +1663,7 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 	trans_pcie->is_down = false;
 
 	/* ...rfkill can call stop_device and set it false if needed */
-	iwl_trans_check_hw_rf_kill(trans);
+	iwl_pcie_check_hw_rf_kill(trans);
 
 	/* Make sure we sync here, because we'll need full access later */
 	if (low_power)
-- 
2.13.2
