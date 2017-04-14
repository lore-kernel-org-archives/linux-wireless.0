Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51856 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754058AbdDNJEw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:04:52 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:02:09 +0300
Message-Id: <20170414090210.31397-26-luca@coelho.fi> (sfid-20170414_110513_460699_3E5343EA)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 25/26] iwlwifi: pcie: introduce new stop_device
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This function is basically the same as gen1, except for clean
ups of old devices configuration that are never used in a000
configuration.
It will also help with refactoring rf_kill later on.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   5 +
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   | 147 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  18 +--
 3 files changed, 161 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index cdc2b0a938a1..bb7b25976e90 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -767,6 +767,8 @@ void iwl_pcie_synchronize_irqs(struct iwl_trans *trans);
 bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans);
 void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq);
 int iwl_queue_space(const struct iwl_txq *q);
+int iwl_pcie_apm_stop_master(struct iwl_trans *trans);
+void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie);
 
 /* transport gen 2 exported functions */
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
@@ -781,5 +783,8 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			   struct iwl_device_cmd *dev_cmd, int txq_id);
 int iwl_trans_pcie_gen2_send_hcmd(struct iwl_trans *trans,
 				  struct iwl_host_cmd *cmd);
+void iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans,
+				     bool low_power);
+void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power);
 
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 302310dfef9e..4d5d35501fdc 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -111,6 +111,153 @@ static int iwl_pcie_gen2_apm_init(struct iwl_trans *trans)
 	return 0;
 }
 
+static void iwl_pcie_gen2_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
+{
+	IWL_DEBUG_INFO(trans, "Stop card, put in low power state\n");
+
+	if (op_mode_leave) {
+		if (!test_bit(STATUS_DEVICE_ENABLED, &trans->status))
+			iwl_pcie_gen2_apm_init(trans);
+
+		/* inform ME that we are leaving */
+		iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+			    CSR_RESET_LINK_PWR_MGMT_DISABLED);
+		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+			    CSR_HW_IF_CONFIG_REG_PREPARE |
+			    CSR_HW_IF_CONFIG_REG_ENABLE_PME);
+		mdelay(1);
+		iwl_clear_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+			      CSR_RESET_LINK_PWR_MGMT_DISABLED);
+		mdelay(5);
+	}
+
+	clear_bit(STATUS_DEVICE_ENABLED, &trans->status);
+
+	/* Stop device's DMA activity */
+	iwl_pcie_apm_stop_master(trans);
+
+	/* Reset the entire device */
+	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	usleep_range(1000, 2000);
+
+	/*
+	 * Clear "initialization complete" bit to move adapter from
+	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
+	 */
+	iwl_clear_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+}
+
+void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	bool hw_rfkill, was_hw_rfkill;
+
+	lockdep_assert_held(&trans_pcie->mutex);
+
+	if (trans_pcie->is_down)
+		return;
+
+	trans_pcie->is_down = true;
+
+	was_hw_rfkill = iwl_is_rfkill_set(trans);
+
+	/* tell the device to stop sending interrupts */
+	iwl_disable_interrupts(trans);
+
+	/* device going down, Stop using ICT table */
+	iwl_pcie_disable_ict(trans);
+
+	/*
+	 * If a HW restart happens during firmware loading,
+	 * then the firmware loading might call this function
+	 * and later it might be called again due to the
+	 * restart. So don't process again if the device is
+	 * already dead.
+	 */
+	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
+		IWL_DEBUG_INFO(trans,
+			       "DEVICE_ENABLED bit was set and is now cleared\n");
+		iwl_pcie_tx_stop(trans);
+		iwl_pcie_rx_stop(trans);
+	}
+
+	iwl_pcie_ctxt_info_free_paging(trans);
+	iwl_pcie_ctxt_info_free(trans);
+
+	/* Make sure (redundant) we've released our request to stay awake */
+	iwl_clear_bit(trans, CSR_GP_CNTRL,
+		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
+	/* Stop the device, and put it in low power state */
+	iwl_pcie_gen2_apm_stop(trans, false);
+
+	/* stop and reset the on-board processor */
+	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	usleep_range(1000, 2000);
+
+	/*
+	 * Upon stop, the IVAR table gets erased, so msi-x won't
+	 * work. This causes a bug in RF-KILL flows, since the interrupt
+	 * that enables radio won't fire on the correct irq, and the
+	 * driver won't be able to handle the interrupt.
+	 * Configure the IVAR table again after reset.
+	 */
+	iwl_pcie_conf_msix_hw(trans_pcie);
+
+	/*
+	 * Upon stop, the APM issues an interrupt if HW RF kill is set.
+	 * This is a bug in certain verions of the hardware.
+	 * Certain devices also keep sending HW RF kill interrupt all
+	 * the time, unless the interrupt is ACKed even if the interrupt
+	 * should be masked. Re-ACK all the interrupts here.
+	 */
+	iwl_disable_interrupts(trans);
+
+	/* clear all status bits */
+	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
+	clear_bit(STATUS_INT_ENABLED, &trans->status);
+	clear_bit(STATUS_TPOWER_PMI, &trans->status);
+	clear_bit(STATUS_RFKILL, &trans->status);
+
+	/*
+	 * Even if we stop the HW, we still want the RF kill
+	 * interrupt
+	 */
+	iwl_enable_rfkill_int(trans);
+
+	/*
+	 * Check again since the RF kill state may have changed while
+	 * all the interrupts were disabled, in this case we couldn't
+	 * receive the RF kill interrupt and update the state in the
+	 * op_mode.
+	 * Don't call the op_mode if the rkfill state hasn't changed.
+	 * This allows the op_mode to call stop_device from the rfkill
+	 * notification without endless recursion. Under very rare
+	 * circumstances, we might have a small recursion if the rfkill
+	 * state changed exactly now while we were called from stop_device.
+	 * This is very unlikely but can happen and is supported.
+	 */
+	hw_rfkill = iwl_is_rfkill_set(trans);
+	if (hw_rfkill)
+		set_bit(STATUS_RFKILL, &trans->status);
+	else
+		clear_bit(STATUS_RFKILL, &trans->status);
+	if (hw_rfkill != was_hw_rfkill)
+		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+
+	/* re-take ownership to prevent other users from stealing the device */
+	iwl_pcie_prepare_card_hw(trans);
+}
+
+void iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	mutex_lock(&trans_pcie->mutex);
+	_iwl_trans_pcie_gen2_stop_device(trans, low_power);
+	mutex_unlock(&trans_pcie->mutex);
+}
+
 static int iwl_pcie_gen2_nic_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ccc9280d845a..6a565d35f071 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -80,7 +80,6 @@
 #include "iwl-prph.h"
 #include "iwl-scd.h"
 #include "iwl-agn-hw.h"
-#include "iwl-context-info.h"
 #include "iwl-fw-error-dump.h"
 #include "internal.h"
 #include "iwl-fh.h"
@@ -449,7 +448,7 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 				 ~SHR_APMG_XTAL_CFG_XTAL_ON_REQ);
 }
 
-static int iwl_pcie_apm_stop_master(struct iwl_trans *trans)
+int iwl_pcie_apm_stop_master(struct iwl_trans *trans)
 {
 	int ret = 0;
 
@@ -1126,7 +1125,7 @@ static void iwl_pcie_map_rx_causes(struct iwl_trans *trans)
 		iwl_write8(trans, CSR_MSIX_RX_IVAR(1), val);
 }
 
-static void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie)
+void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie)
 {
 	struct iwl_trans *trans = trans_pcie->trans;
 
@@ -1213,9 +1212,6 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 		}
 	}
 
-	iwl_pcie_ctxt_info_free_paging(trans);
-	iwl_pcie_ctxt_info_free(trans);
-
 	/* Make sure (redundant) we've released our request to stay awake */
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
 		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
@@ -1405,8 +1401,12 @@ void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state)
 
 	lockdep_assert_held(&trans_pcie->mutex);
 
-	if (iwl_op_mode_hw_rf_kill(trans->op_mode, state))
-		_iwl_trans_pcie_stop_device(trans, true);
+	if (iwl_op_mode_hw_rf_kill(trans->op_mode, state)) {
+		if (trans->cfg->gen2)
+			_iwl_trans_pcie_gen2_stop_device(trans, true);
+		else
+			_iwl_trans_pcie_stop_device(trans, true);
+	}
 }
 
 static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test,
@@ -2916,7 +2916,7 @@ static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
 	.start_hw = iwl_trans_pcie_start_hw,
 	.fw_alive = iwl_trans_pcie_gen2_fw_alive,
 	.start_fw = iwl_trans_pcie_gen2_start_fw,
-	.stop_device = iwl_trans_pcie_stop_device,
+	.stop_device = iwl_trans_pcie_gen2_stop_device,
 
 	.send_cmd = iwl_trans_pcie_gen2_send_hcmd,
 
-- 
2.11.0
