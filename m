Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab3BAK1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 05:27:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Lilach Edelstein <lilach.edelstein@intel.com>
Subject: [PATCH 2/3] iwlwifi: add iwl_set_bits_mask to transport API
Date: Fri,  1 Feb 2013 11:27:35 +0100
Message-Id: <1359714456-15427-2-git-send-email-johannes@sipsolutions.net> (sfid-20130201_112722_859060_78B502F8)
In-Reply-To: <1359714456-15427-1-git-send-email-johannes@sipsolutions.net>
References: <1359714456-15427-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lilach Edelstein <lilach.edelstein@intel.com>

Express iwl_set_bit() and iwl_clear_bit() through iwl_set_bits_mask()
and add the latter to the transport's API in order to allow different
implementation for different transport types in the future.

Signed-off-by: Lilach Edelstein <lilach.edelstein@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c   | 23 ++++++++-------
 drivers/net/wireless/iwlwifi/iwl-io.c     | 48 -------------------------------
 drivers/net/wireless/iwlwifi/iwl-io.h     | 13 +++++----
 drivers/net/wireless/iwlwifi/iwl-trans.h  |  9 ++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c    | 18 ++++++------
 drivers/net/wireless/iwlwifi/pcie/trans.c | 48 +++++++++++++++++++++++++++----
 6 files changed, 81 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 04b467f..f5f9164 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1991,13 +1991,13 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
 	/* SKU Control */
-	iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
-			  CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH |
-			  CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP,
-			  (CSR_HW_REV_STEP(priv->trans->hw_rev) <<
-				CSR_HW_IF_CONFIG_REG_POS_MAC_STEP) |
-			  (CSR_HW_REV_DASH(priv->trans->hw_rev) <<
-				CSR_HW_IF_CONFIG_REG_POS_MAC_DASH));
+	iwl_trans_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH |
+				CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP,
+				(CSR_HW_REV_STEP(priv->trans->hw_rev) <<
+					CSR_HW_IF_CONFIG_REG_POS_MAC_STEP) |
+				(CSR_HW_REV_DASH(priv->trans->hw_rev) <<
+					CSR_HW_IF_CONFIG_REG_POS_MAC_DASH));
 
 	/* write radio config values to register */
 	if (priv->nvm_data->radio_cfg_type <= EEPROM_RF_CONFIG_TYPE_MAX) {
@@ -2009,10 +2009,11 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 			priv->nvm_data->radio_cfg_dash <<
 				CSR_HW_IF_CONFIG_REG_POS_PHY_DASH;
 
-		iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
-				  CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE |
-				  CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
-				  CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH, reg_val);
+		iwl_trans_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
+					CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE |
+					CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
+					CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH,
+					reg_val);
 
 		IWL_INFO(priv, "Radio type=0x%x-0x%x-0x%x\n",
 			 priv->nvm_data->radio_cfg_type,
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index dbc0122..7ef4738 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -35,54 +35,6 @@
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
-void __iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
-{
-	iwl_write32(trans, reg, iwl_read32(trans, reg) | mask);
-}
-
-void __iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
-{
-	iwl_write32(trans, reg, iwl_read32(trans, reg) & ~mask);
-}
-
-void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	__iwl_set_bit(trans, reg, mask);
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
-}
-EXPORT_SYMBOL_GPL(iwl_set_bit);
-
-void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	__iwl_clear_bit(trans, reg, mask);
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
-}
-EXPORT_SYMBOL_GPL(iwl_clear_bit);
-
-void iwl_set_bits_mask(struct iwl_trans *trans, u32 reg, u32 mask, u32 value)
-{
-	unsigned long flags;
-	u32 v;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	WARN_ON_ONCE(value & ~mask);
-#endif
-
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	v = iwl_read32(trans, reg);
-	v &= ~mask;
-	v |= value;
-	iwl_write32(trans, reg, v);
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
-}
-EXPORT_SYMBOL_GPL(iwl_set_bits_mask);
-
 int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 		 u32 bits, u32 mask, int timeout)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 5d0ce43..fd9f5b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -51,12 +51,15 @@ static inline u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
 	return val;
 }
 
-void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask);
-void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask);
-void __iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask);
-void __iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask);
+static inline void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
+{
+	iwl_trans_set_bits_mask(trans, reg, mask, mask);
+}
 
-void iwl_set_bits_mask(struct iwl_trans *trans, u32 reg, u32 mask, u32 value);
+static inline void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
+{
+	iwl_trans_set_bits_mask(trans, reg, mask, 0);
+}
 
 int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 		 u32 bits, u32 mask, int timeout);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index d4ab24b..c2b7e85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -418,6 +418,7 @@ struct iwl_trans;
  * @set_pmi: set the power pmi state
  * @grab_nic_access: wake the NIC to be able to access non-HBUS regs
  * @release_nic_access: let the NIC go to sleep
+ * @set_bits_mask - set SRAM register according to value and mask.
  */
 struct iwl_trans_ops {
 
@@ -462,6 +463,8 @@ struct iwl_trans_ops {
 	void (*set_pmi)(struct iwl_trans *trans, bool state);
 	bool (*grab_nic_access)(struct iwl_trans *trans, bool silent);
 	void (*release_nic_access)(struct iwl_trans *trans);
+	void (*set_bits_mask)(struct iwl_trans *trans, u32 reg, u32 mask,
+			      u32 value);
 };
 
 /**
@@ -762,6 +765,12 @@ static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
 	trans->ops->set_pmi(trans, state);
 }
 
+static inline void
+iwl_trans_set_bits_mask(struct iwl_trans *trans, u32 reg, u32 mask, u32 value)
+{
+	trans->ops->set_bits_mask(trans, reg, mask, value);
+}
+
 #define iwl_trans_grab_nic_access(trans, silent)	\
 	__cond_lock(nic_access,				\
 		    likely((trans)->ops->grab_nic_access(trans, silent)))
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index e675e4a..983dca3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -177,15 +177,15 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 	reg_val |= CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI;
 	reg_val |= CSR_HW_IF_CONFIG_REG_BIT_MAC_SI;
 
-	iwl_set_bits_mask(mvm->trans, CSR_HW_IF_CONFIG_REG,
-			  CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH |
-			  CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP |
-			  CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE |
-			  CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
-			  CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH |
-			  CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-			  CSR_HW_IF_CONFIG_REG_BIT_MAC_SI,
-			  reg_val);
+	iwl_trans_set_bits_mask(mvm->trans, CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH |
+				CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP |
+				CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE |
+				CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
+				CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH |
+				CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+				CSR_HW_IF_CONFIG_REG_BIT_MAC_SI,
+				reg_val);
 
 	IWL_DEBUG_INFO(mvm, "Radio type=0x%x-0x%x-0x%x\n", radio_cfg_type,
 		       radio_cfg_step, radio_cfg_dash);
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 35685c5..8692494 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -75,6 +75,33 @@
 #include "iwl-agn-hw.h"
 #include "internal.h"
 
+static void __iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans,
+						  u32 reg, u32 mask, u32 value)
+{
+	u32 v;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	WARN_ON_ONCE(value & ~mask);
+#endif
+
+	v = iwl_read32(trans, reg);
+	v &= ~mask;
+	v |= value;
+	iwl_write32(trans, reg, v);
+}
+
+static inline void __iwl_trans_pcie_clear_bit(struct iwl_trans *trans,
+					      u32 reg, u32 mask)
+{
+	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, 0);
+}
+
+static inline void __iwl_trans_pcie_set_bit(struct iwl_trans *trans,
+					    u32 reg, u32 mask)
+{
+	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, mask);
+}
+
 static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 {
 	if (vaux && pci_pme_capable(to_pci_dev(trans->dev), PCI_D3cold))
@@ -786,8 +813,8 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
 	lockdep_assert_held(&trans->reg_lock);
 
 	/* this bit wakes up the NIC */
-	__iwl_set_bit(trans, CSR_GP_CNTRL,
-		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
+				 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/*
 	 * These bits say the device is running, and should keep running for
@@ -829,8 +856,8 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
 static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
 {
 	lockdep_assert_held(&trans->reg_lock);
-	__iwl_clear_bit(trans, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	/*
 	 * Above we read the CSR_GP_CNTRL register, which will flush
 	 * any previous writes, but we need the write that clears the
@@ -952,6 +979,16 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans)
 	return ret;
 }
 
+static void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
+					 u32 mask, u32 value)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, value);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
+}
+
 static const char *get_fh_string(int cmd)
 {
 #define IWL_CMD(x) case x: return #x
@@ -1405,7 +1442,8 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.configure = iwl_trans_pcie_configure,
 	.set_pmi = iwl_trans_pcie_set_pmi,
 	.grab_nic_access = iwl_trans_pcie_grab_nic_access,
-	.release_nic_access = iwl_trans_pcie_release_nic_access
+	.release_nic_access = iwl_trans_pcie_release_nic_access,
+	.set_bits_mask = iwl_trans_pcie_set_bits_mask,
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
-- 
1.8.0

