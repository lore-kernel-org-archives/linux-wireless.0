Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48348 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbaCROp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:57 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so5464006eek.4
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:56 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/35] iwlwifi: return whether to stop from rfkill method
Date: Tue, 18 Mar 2014 16:45:12 +0200
Message-Id: <1395153939-23897-8-git-send-email-egrumbach@gmail.com> (sfid-20140318_154604_561485_756D6F3D)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When indicating RF-kill toggle to the higher layer, that
may in turn call back to the transport (for MVM at least)
to turn off the device quickly. Instead of that, allow it
to return whether or not the device should be turned off,
this gets rid of the call indirection and will help make
the API more consistent when we go back to non-threaded
interrupts again for PCIe.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c      |  4 +++-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h   | 11 ++++++-----
 drivers/net/wireless/iwlwifi/mvm/ops.c       |  6 +++---
 drivers/net/wireless/iwlwifi/pcie/drv.c      |  2 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h |  2 ++
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 12 +++++++++---
 7 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index ba1b1ea..4a5cacc 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -2035,7 +2035,7 @@ static void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 	ieee80211_free_txskb(priv->hw, skb);
 }
 
-static void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
+static bool iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
@@ -2045,6 +2045,8 @@ static void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
+
+	return false;
 }
 
 static const struct iwl_op_mode_ops iwl_dvm_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 5d78207..ea29504 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -119,7 +119,8 @@ struct iwl_cfg;
  * @queue_not_full: notifies that a HW queue is not full any more.
  *	Must be atomic and called with BH disabled.
  * @hw_rf_kill:notifies of a change in the HW rf kill switch. True means that
- *	the radio is killed. May sleep.
+ *	the radio is killed. Return %true if the device should be stopped by
+ *	the transport immediately after the call. May sleep.
  * @free_skb: allows the transport layer to free skbs that haven't been
  *	reclaimed by the op_mode. This can happen when the driver is freed and
  *	there are Tx packets pending in the transport layer.
@@ -144,7 +145,7 @@ struct iwl_op_mode_ops {
 		  struct iwl_device_cmd *cmd);
 	void (*queue_full)(struct iwl_op_mode *op_mode, int queue);
 	void (*queue_not_full)(struct iwl_op_mode *op_mode, int queue);
-	void (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
+	bool (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
 	void (*free_skb)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 	void (*nic_error)(struct iwl_op_mode *op_mode);
 	void (*cmd_queue_full)(struct iwl_op_mode *op_mode);
@@ -195,11 +196,11 @@ static inline void iwl_op_mode_queue_not_full(struct iwl_op_mode *op_mode,
 	op_mode->ops->queue_not_full(op_mode, queue);
 }
 
-static inline void iwl_op_mode_hw_rf_kill(struct iwl_op_mode *op_mode,
-					  bool state)
+static inline bool __must_check
+iwl_op_mode_hw_rf_kill(struct iwl_op_mode *op_mode, bool state)
 {
 	might_sleep();
-	op_mode->ops->hw_rf_kill(op_mode, state);
+	return op_mode->ops->hw_rf_kill(op_mode, state);
 }
 
 static inline void iwl_op_mode_free_skb(struct iwl_op_mode *op_mode,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index ae347fb..05f6355 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -690,7 +690,7 @@ void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state)
 	wiphy_rfkill_set_hw_state(mvm->hw->wiphy, iwl_mvm_is_radio_killed(mvm));
 }
 
-static void iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
+static bool iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
@@ -699,9 +699,9 @@ static void iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 	else
 		clear_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
 
-	if (state && mvm->cur_ucode != IWL_UCODE_INIT)
-		iwl_trans_stop_device(mvm->trans);
 	wiphy_rfkill_set_hw_state(mvm->hw->wiphy, iwl_mvm_is_radio_killed(mvm));
+
+	return state && mvm->cur_ucode != IWL_UCODE_INIT;
 }
 
 static void iwl_mvm_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 22b6b7e..e530055 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -561,7 +561,7 @@ static int iwl_pci_resume(struct device *device)
 	iwl_enable_rfkill_int(trans);
 
 	hw_rfkill = iwl_is_rfkill_set(trans);
-	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
+	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 3120bc5..9091513 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -488,4 +488,6 @@ static inline void __iwl_trans_pcie_set_bit(struct iwl_trans *trans,
 	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, mask);
 }
 
+void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state);
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index cf49f6c..fdfa396 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -994,7 +994,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 
 		isr_stats->rfkill++;
 
-		iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
+		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 		if (hw_rfkill) {
 			set_bit(STATUS_RFKILL, &trans->status);
 			if (test_and_clear_bit(STATUS_SYNC_HCMD_ACTIVE,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 32a5a9a..dcfd6d8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -770,7 +770,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		set_bit(STATUS_RFKILL, &trans->status);
 	else
 		clear_bit(STATUS_RFKILL, &trans->status);
-	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
+	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 	if (hw_rfkill && !run_in_rfkill)
 		return -ERFKILL;
 
@@ -885,7 +885,13 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	else
 		clear_bit(STATUS_RFKILL, &trans->status);
 	if (hw_rfkill != was_hw_rfkill)
-		iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
+		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+}
+
+void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state)
+{
+	if (iwl_op_mode_hw_rf_kill(trans->op_mode, state))
+		iwl_trans_pcie_stop_device(trans);
 }
 
 static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
@@ -994,7 +1000,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 		set_bit(STATUS_RFKILL, &trans->status);
 	else
 		clear_bit(STATUS_RFKILL, &trans->status);
-	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
+	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 
 	return 0;
 }
-- 
1.8.3.2

