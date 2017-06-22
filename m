Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34444 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753374AbdFVVWn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:22:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:53 +0300
Message-Id: <20170622212101.16422-18-luca@coelho.fi> (sfid-20170622_232254_045689_352C7F5F)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 17/25] iwlwifi: pcie: pull out common rfkill IRQ handling code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no point in duplicating exactly the same code here
for legacy and MSI-X interrupts, so pull it out into a new
function to call in both places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 82 +++++++++++-----------------
 1 file changed, 33 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 293f4b2c1955..c27d6f711abf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1509,6 +1509,36 @@ static u32 iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 	return inta;
 }
 
+static void iwl_pcie_handle_rfkill_irq(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
+	bool hw_rfkill;
+
+	mutex_lock(&trans_pcie->mutex);
+	hw_rfkill = iwl_is_rfkill_set(trans);
+	if (hw_rfkill)
+		set_bit(STATUS_RFKILL, &trans->status);
+
+	IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
+		 hw_rfkill ? "disable radio" : "enable radio");
+
+	isr_stats->rfkill++;
+
+	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+	mutex_unlock(&trans_pcie->mutex);
+
+	if (hw_rfkill) {
+		if (test_and_clear_bit(STATUS_SYNC_HCMD_ACTIVE,
+				       &trans->status))
+			IWL_DEBUG_RF_KILL(trans,
+					  "Rfkill while SYNC HCMD in flight\n");
+		wake_up(&trans_pcie->wait_command_queue);
+	} else {
+		clear_bit(STATUS_RFKILL, &trans->status);
+	}
+}
+
 irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 {
 	struct iwl_trans *trans = dev_id;
@@ -1632,30 +1662,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 
 	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
-		bool hw_rfkill;
-
-		mutex_lock(&trans_pcie->mutex);
-		hw_rfkill = iwl_is_rfkill_set(trans);
-		if (hw_rfkill)
-			set_bit(STATUS_RFKILL, &trans->status);
-
-		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
-			 hw_rfkill ? "disable radio" : "enable radio");
-
-		isr_stats->rfkill++;
-
-		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
-		mutex_unlock(&trans_pcie->mutex);
-		if (hw_rfkill) {
-			if (test_and_clear_bit(STATUS_SYNC_HCMD_ACTIVE,
-					       &trans->status))
-				IWL_DEBUG_RF_KILL(trans,
-						  "Rfkill while SYNC HCMD in flight\n");
-			wake_up(&trans_pcie->wait_command_queue);
-		} else {
-			clear_bit(STATUS_RFKILL, &trans->status);
-		}
-
+		iwl_pcie_handle_rfkill_irq(trans);
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
 
@@ -1982,31 +1989,8 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 	}
 
 	/* HW RF KILL switch toggled */
-	if (inta_hw & MSIX_HW_INT_CAUSES_REG_RF_KILL) {
-		bool hw_rfkill;
-
-		mutex_lock(&trans_pcie->mutex);
-		hw_rfkill = iwl_is_rfkill_set(trans);
-		if (hw_rfkill)
-			set_bit(STATUS_RFKILL, &trans->status);
-
-		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
-			 hw_rfkill ? "disable radio" : "enable radio");
-
-		isr_stats->rfkill++;
-
-		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
-		mutex_unlock(&trans_pcie->mutex);
-		if (hw_rfkill) {
-			if (test_and_clear_bit(STATUS_SYNC_HCMD_ACTIVE,
-					       &trans->status))
-				IWL_DEBUG_RF_KILL(trans,
-						  "Rfkill while SYNC HCMD in flight\n");
-			wake_up(&trans_pcie->wait_command_queue);
-		} else {
-			clear_bit(STATUS_RFKILL, &trans->status);
-		}
-	}
+	if (inta_hw & MSIX_HW_INT_CAUSES_REG_RF_KILL)
+		iwl_pcie_handle_rfkill_irq(trans);
 
 	if (inta_hw & MSIX_HW_INT_CAUSES_REG_HW_ERR) {
 		IWL_ERR(trans,
-- 
2.11.0
