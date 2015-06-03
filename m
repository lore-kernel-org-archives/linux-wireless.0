Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13470 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbbFCHbs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:31:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/15] iwlwifi: pcie: Control access to the NIC's PM registers via iwl_cfg
Date: Wed,  3 Jun 2015 10:31:24 +0300
Message-Id: <1433316696-4612-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093152_526055_090C3879)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Allow a cleaner way to access those hw-dependent registers,
instead of using the product family type etc.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   |  3 ++-
 drivers/net/wireless/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c    |  2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c    |  1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c | 16 ++++++++--------
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 5dca838..5c08f70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -163,7 +163,8 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 	.smem_len = IWL8260_SMEM_LEN,					\
 	.default_nvm_file_B_step = DEFAULT_NVM_FILE_FAMILY_8000B,	\
 	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C,	\
-	.thermal_params = &iwl8000_tt_params
+	.thermal_params = &iwl8000_tt_params,				\
+	.apmg_not_supported = true
 
 const struct iwl_cfg iwl8260_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 8260",
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 225b6d6..08c14af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -360,6 +360,7 @@ struct iwl_cfg {
 	const u32 smem_offset;
 	const u32 smem_len;
 	const struct iwl_tt_params *thermal_params;
+	bool apmg_not_supported;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 690b336..91ca626 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -194,7 +194,7 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 	 * (PCIe power is lost before PERST# is asserted), causing ME FW
 	 * to lose ownership and not being able to obtain it back.
 	 */
-	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
+	if (!mvm->trans->cfg->apmg_not_supported)
 		iwl_set_bits_mask_prph(mvm->trans, APMG_PS_CTRL_REG,
 				       APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				       ~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 7ff69c6..adad8d0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -775,6 +775,7 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
 	if (trans->cfg->internal_wimax_coex &&
+	    !trans->cfg->apmg_not_supported &&
 	    (!(iwl_read_prph(trans, APMG_CLK_CTRL_REG) &
 			     APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index a341ed9..dd1b90b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -182,6 +182,9 @@ static void iwl_trans_pcie_write_shr(struct iwl_trans *trans, u32 reg, u32 val)
 
 static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 {
+	if (!trans->cfg->apmg_not_supported)
+		return;
+
 	if (vaux && pci_pme_capable(to_pci_dev(trans->dev), PCI_D3cold))
 		iwl_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
 				       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
@@ -315,7 +318,7 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 	 * bits do not disable clocks.  This preserves any hardware
 	 * bits already set by default in "CLK_CTRL_REG" after reset.
 	 */
-	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+	if (!trans->cfg->apmg_not_supported) {
 		iwl_write_prph(trans, APMG_CLK_EN_REG,
 			       APMG_CLK_VAL_DMA_CLK_RQT);
 		udelay(20);
@@ -515,8 +518,7 @@ static int iwl_pcie_nic_init(struct iwl_trans *trans)
 
 	spin_unlock(&trans_pcie->irq_lock);
 
-	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
-		iwl_pcie_set_pwr(trans, false);
+	iwl_pcie_set_pwr(trans, false);
 
 	iwl_op_mode_nic_config(trans->op_mode);
 
@@ -1063,7 +1065,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 		iwl_pcie_rx_stop(trans);
 
 		/* Power-down device's busmaster DMA clocks */
-		if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+		if (!trans->cfg->apmg_not_supported) {
 			iwl_write_prph(trans, APMG_CLK_DIS_REG,
 				       APMG_CLK_VAL_DMA_CLK_RQT);
 			udelay(5);
@@ -1160,8 +1162,7 @@ static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
 	 */
 	iwl_trans_pcie_tx_reset(trans);
 
-	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
-		iwl_pcie_set_pwr(trans, true);
+	iwl_pcie_set_pwr(trans, true);
 }
 
 static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
@@ -1199,8 +1200,7 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 		return ret;
 	}
 
-	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
-		iwl_pcie_set_pwr(trans, false);
+	iwl_pcie_set_pwr(trans, false);
 
 	iwl_trans_pcie_tx_reset(trans);
 
-- 
2.1.4

