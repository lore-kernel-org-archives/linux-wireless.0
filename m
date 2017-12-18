Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50966 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759285AbdLRMiX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 07:38:23 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 14:38:06 +0200
Message-Id: <20171218123815.3968-3-luca@coelho.fi> (sfid-20171218_133838_987948_A3E80B73)
In-Reply-To: <20171218123815.3968-1-luca@coelho.fi>
References: <20171218123815.3968-1-luca@coelho.fi>
Subject: [PATCH 02/11] iwlwifi: avoid duplicate sw reset executions in the code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Most of the sw resets in the code are done by one function,
which writes to the relevant CSR.

Use the common function to perform the only reset which was
done separately, redundant to the common code.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       |  7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  3 +--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |  7 -------
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c |  4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 18 +++++++++++++-----
 5 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 05382031f3ae..09f392969fd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -577,6 +577,7 @@ struct iwl_trans_ops {
 	void (*configure)(struct iwl_trans *trans,
 			  const struct iwl_trans_config *trans_cfg);
 	void (*set_pmi)(struct iwl_trans *trans, bool state);
+	void (*sw_reset)(struct iwl_trans *trans);
 	bool (*grab_nic_access)(struct iwl_trans *trans, unsigned long *flags);
 	void (*release_nic_access)(struct iwl_trans *trans,
 				   unsigned long *flags);
@@ -1122,6 +1123,12 @@ static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
 		trans->ops->set_pmi(trans, state);
 }
 
+static inline void iwl_trans_sw_reset(struct iwl_trans *trans)
+{
+	if (trans->ops->sw_reset)
+		trans->ops->sw_reset(trans);
+}
+
 static inline void
 iwl_trans_set_bits_mask(struct iwl_trans *trans, u32 reg, u32 mask, u32 value)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index b7fc1b9fb605..b2410eb68123 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -516,8 +516,7 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
 		IWL_ERR(trans, "HW error, resetting before reading\n");
 
 		/* reset the device */
-		iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-		usleep_range(5000, 6000);
+		iwl_trans_sw_reset(trans);
 
 		/* set INIT_DONE flag */
 		iwl_set_bit(trans, CSR_GP_CNTRL,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index d749abeca3ae..5b15abdc740c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -658,13 +658,6 @@ static inline void iwl_enable_fw_load_int(struct iwl_trans *trans)
 	}
 }
 
-static inline void iwl_pcie_sw_reset(struct iwl_trans *trans)
-{
-	/* Reset entire device - do controller reset (results in SHRD_HW_RST) */
-	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-	usleep_range(5000, 6000);
-}
-
 static inline u8 iwl_pcie_get_cmd_index(struct iwl_txq *q, u32 index)
 {
 	return index & (q->n_window - 1);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index c59f4581e972..e8b9e98f0e49 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -136,7 +136,7 @@ static void iwl_pcie_gen2_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 	/* Stop device's DMA activity */
 	iwl_pcie_apm_stop_master(trans);
 
-	iwl_pcie_sw_reset(trans);
+	iwl_trans_sw_reset(trans);
 
 	/*
 	 * Clear "initialization complete" bit to move adapter from
@@ -186,7 +186,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
 	/* Stop the device, and put it in low power state */
 	iwl_pcie_gen2_apm_stop(trans, false);
 
-	iwl_pcie_sw_reset(trans);
+	iwl_trans_sw_reset(trans);
 
 	/*
 	 * Upon stop, the IVAR table gets erased, so msi-x won't
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ef27463344d6..9642e8f9968e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -175,6 +175,13 @@ static void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
 	kfree(buf);
 }
 
+static void iwl_trans_pcie_sw_reset(struct iwl_trans *trans)
+{
+	/* Reset entire device - do controller reset (results in SHRD_HW_RST) */
+	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	usleep_range(5000, 6000);
+}
+
 static void iwl_pcie_free_fw_monitor(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -445,7 +452,7 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 	__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
 				 CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
 
-	iwl_pcie_sw_reset(trans);
+	iwl_trans_pcie_sw_reset(trans);
 
 	/*
 	 * Set "initialization complete" bit to move adapter from
@@ -486,7 +493,7 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 				 apmg_xtal_cfg_reg |
 				 SHR_APMG_XTAL_CFG_XTAL_ON_REQ);
 
-	iwl_pcie_sw_reset(trans);
+	iwl_trans_pcie_sw_reset(trans);
 
 	/* Enable LP XTAL by indirect access through CSR */
 	apmg_gp1_reg = iwl_trans_pcie_read_shr(trans, SHR_APMG_GP1_REG);
@@ -579,7 +586,7 @@ static void iwl_pcie_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 		return;
 	}
 
-	iwl_pcie_sw_reset(trans);
+	iwl_trans_pcie_sw_reset(trans);
 
 	/*
 	 * Clear "initialization complete" bit to move adapter from
@@ -1255,7 +1262,7 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 	/* Stop the device, and put it in low power state */
 	iwl_pcie_apm_stop(trans, false);
 
-	iwl_pcie_sw_reset(trans);
+	iwl_trans_pcie_sw_reset(trans);
 
 	/*
 	 * Upon stop, the IVAR table gets erased, so msi-x won't
@@ -1729,7 +1736,7 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 		return err;
 	}
 
-	iwl_pcie_sw_reset(trans);
+	iwl_trans_pcie_sw_reset(trans);
 
 	err = iwl_pcie_apm_init(trans);
 	if (err)
@@ -3034,6 +3041,7 @@ static void iwl_trans_pcie_resume(struct iwl_trans *trans)
 	.write_mem = iwl_trans_pcie_write_mem,				\
 	.configure = iwl_trans_pcie_configure,				\
 	.set_pmi = iwl_trans_pcie_set_pmi,				\
+	.sw_reset = iwl_trans_pcie_sw_reset,				\
 	.grab_nic_access = iwl_trans_pcie_grab_nic_access,		\
 	.release_nic_access = iwl_trans_pcie_release_nic_access,	\
 	.set_bits_mask = iwl_trans_pcie_set_bits_mask,			\
-- 
2.15.1
