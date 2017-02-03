Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37954 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751958AbdBCOjY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:39:24 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:11 +0200
Message-Id: <20170203143812.7525-25-luca@coelho.fi> (sfid-20170203_153926_835261_E892EB41)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 24/25] iwlwifi: pcie: fix another RF-kill race
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When resuming, it's possible for the following scenario to occur:

 * iwl_pci_resume() enables the RF-kill interrupt
 * iwl_pci_resume() reads the RF-kill state (e.g. to 'radio enabled')
 * RF_KILL interrupt triggers, and iwl_pcie_irq_handler() reads the
   state, now 'radio disabled', and acquires the &trans_pcie->mutex.
 * iwl_pcie_irq_handler() further calls iwl_trans_pcie_rf_kill() to
   indicate to the higher layers that the radio is now disabled (and
   stops the device while at it)
 * iwl_pcie_irq_handler() drops the mutex
 * iwl_pci_resume() continues, acquires the mutex and calls the higher
   layers to indicate that the radio is enabled.

At this point, the device is stopped but the higher layers think it's
available, and can call deeply into the driver to try to enable it.
However, this will fail since the device is actually disabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 7 ++++---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 618894ecfd22..ba8a81cb0e2b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -784,13 +784,14 @@ static int iwl_pci_resume(struct device *device)
 
 	/*
 	 * Enable rfkill interrupt (in order to keep track of
-	 * the rfkill status)
+	 * the rfkill status). Must be locked to avoid processing
+	 * a possible rfkill interrupt between reading the state
+	 * and calling iwl_trans_pcie_rf_kill() with it.
 	 */
+	mutex_lock(&trans_pcie->mutex);
 	iwl_enable_rfkill_int(trans);
 
 	hw_rfkill = iwl_is_rfkill_set(trans);
-
-	mutex_lock(&trans_pcie->mutex);
 	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 	mutex_unlock(&trans_pcie->mutex);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index cac6d99012b3..cf5bda06042c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -670,6 +670,8 @@ static inline u8 get_cmd_index(struct iwl_txq *q, u32 index)
 
 static inline bool iwl_is_rfkill_set(struct iwl_trans *trans)
 {
+	lockdep_assert_held(&IWL_TRANS_GET_PCIE_TRANS(trans)->mutex);
+
 	return !(iwl_read32(trans, CSR_GP_CNTRL) &
 		CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 6fe5546dc773..e1bf6da20909 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1607,13 +1607,13 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		bool hw_rfkill;
 
+		mutex_lock(&trans_pcie->mutex);
 		hw_rfkill = iwl_is_rfkill_set(trans);
 		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
 			 hw_rfkill ? "disable radio" : "enable radio");
 
 		isr_stats->rfkill++;
 
-		mutex_lock(&trans_pcie->mutex);
 		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 		mutex_unlock(&trans_pcie->mutex);
 		if (hw_rfkill) {
@@ -1952,13 +1952,13 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 	if (inta_hw & MSIX_HW_INT_CAUSES_REG_RF_KILL) {
 		bool hw_rfkill;
 
+		mutex_lock(&trans_pcie->mutex);
 		hw_rfkill = iwl_is_rfkill_set(trans);
 		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
 			 hw_rfkill ? "disable radio" : "enable radio");
 
 		isr_stats->rfkill++;
 
-		mutex_lock(&trans_pcie->mutex);
 		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 		mutex_unlock(&trans_pcie->mutex);
 		if (hw_rfkill) {
-- 
2.11.0
