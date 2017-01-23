Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36226 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751136AbdAWWRu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:17:50 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 24 Jan 2017 00:03:45 +0200
Message-Id: <20170123220350.25305-21-luca@coelho.fi> (sfid-20170123_231753_483496_45D26542)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 20/25] iwlwifi: pcie: cleanup rfkill checks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Move repeating code to a separate function.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 39 ++++++++++++-------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 16790db650c1..c1d99d15796d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1062,6 +1062,20 @@ static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
 					       &first_ucode_section);
 }
 
+static bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans)
+{
+	bool hw_rfkill = iwl_is_rfkill_set(trans);
+
+	if (hw_rfkill)
+		set_bit(STATUS_RFKILL, &trans->status);
+	else
+		clear_bit(STATUS_RFKILL, &trans->status);
+
+	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+
+	return hw_rfkill;
+}
+
 static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1204,12 +1218,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	mutex_lock(&trans_pcie->mutex);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	hw_rfkill = iwl_is_rfkill_set(trans);
-	if (hw_rfkill)
-		set_bit(STATUS_RFKILL, &trans->status);
-	else
-		clear_bit(STATUS_RFKILL, &trans->status);
-	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
 	if (hw_rfkill && !run_in_rfkill) {
 		ret = -ERFKILL;
 		goto out;
@@ -1257,13 +1266,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		ret = iwl_pcie_load_given_ucode(trans, fw);
 
 	/* re-check RF-Kill state since we may have missed the interrupt */
-	hw_rfkill = iwl_is_rfkill_set(trans);
-	if (hw_rfkill)
-		set_bit(STATUS_RFKILL, &trans->status);
-	else
-		clear_bit(STATUS_RFKILL, &trans->status);
-
-	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
 	if (hw_rfkill && !run_in_rfkill)
 		ret = -ERFKILL;
 
@@ -1655,7 +1658,6 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	bool hw_rfkill;
 	int err;
 
 	lockdep_assert_held(&trans_pcie->mutex);
@@ -1679,13 +1681,8 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 	/* Set is_down to false here so that...*/
 	trans_pcie->is_down = false;
 
-	hw_rfkill = iwl_is_rfkill_set(trans);
-	if (hw_rfkill)
-		set_bit(STATUS_RFKILL, &trans->status);
-	else
-		clear_bit(STATUS_RFKILL, &trans->status);
-	/* ... rfkill can call stop_device and set it false if needed */
-	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+	/* ...rfkill can call stop_device and set it false if needed */
+	iwl_trans_check_hw_rf_kill(trans);
 
 	/* Make sure we sync here, because we'll need full access later */
 	if (low_power)
-- 
2.11.0
