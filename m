Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39170 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753829AbdBHL2a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:28:30 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 13:23:06 +0200
Message-Id: <20170208112322.29413-2-luca@coelho.fi> (sfid-20170208_122840_362684_4AF94A67)
In-Reply-To: <20170208112322.29413-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
Subject: [PATCH 01/17] iwlwifi: pcie: move msix conf functions above other functions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

msix configuration functions should be called by other functions.
For example by pcie_d3_resume, move it above to enable it.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 206 ++++++++++++------------
 1 file changed, 103 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index b28d99f61a35..f795ebea4c4a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1076,6 +1076,109 @@ static bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans)
 	return hw_rfkill;
 }
 
+struct iwl_causes_list {
+	u32 cause_num;
+	u32 mask_reg;
+	u8 addr;
+};
+
+static struct iwl_causes_list causes_list[] = {
+	{MSIX_FH_INT_CAUSES_D2S_CH0_NUM,	CSR_MSIX_FH_INT_MASK_AD, 0},
+	{MSIX_FH_INT_CAUSES_D2S_CH1_NUM,	CSR_MSIX_FH_INT_MASK_AD, 0x1},
+	{MSIX_FH_INT_CAUSES_S2D,		CSR_MSIX_FH_INT_MASK_AD, 0x3},
+	{MSIX_FH_INT_CAUSES_FH_ERR,		CSR_MSIX_FH_INT_MASK_AD, 0x5},
+	{MSIX_HW_INT_CAUSES_REG_ALIVE,		CSR_MSIX_HW_INT_MASK_AD, 0x10},
+	{MSIX_HW_INT_CAUSES_REG_WAKEUP,		CSR_MSIX_HW_INT_MASK_AD, 0x11},
+	{MSIX_HW_INT_CAUSES_REG_CT_KILL,	CSR_MSIX_HW_INT_MASK_AD, 0x16},
+	{MSIX_HW_INT_CAUSES_REG_RF_KILL,	CSR_MSIX_HW_INT_MASK_AD, 0x17},
+	{MSIX_HW_INT_CAUSES_REG_PERIODIC,	CSR_MSIX_HW_INT_MASK_AD, 0x18},
+	{MSIX_HW_INT_CAUSES_REG_SW_ERR,		CSR_MSIX_HW_INT_MASK_AD, 0x29},
+	{MSIX_HW_INT_CAUSES_REG_SCD,		CSR_MSIX_HW_INT_MASK_AD, 0x2A},
+	{MSIX_HW_INT_CAUSES_REG_FH_TX,		CSR_MSIX_HW_INT_MASK_AD, 0x2B},
+	{MSIX_HW_INT_CAUSES_REG_HW_ERR,		CSR_MSIX_HW_INT_MASK_AD, 0x2D},
+	{MSIX_HW_INT_CAUSES_REG_HAP,		CSR_MSIX_HW_INT_MASK_AD, 0x2E},
+};
+
+static void iwl_pcie_map_non_rx_causes(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =  IWL_TRANS_GET_PCIE_TRANS(trans);
+	int val = trans_pcie->def_irq | MSIX_NON_AUTO_CLEAR_CAUSE;
+	int i;
+
+	/*
+	 * Access all non RX causes and map them to the default irq.
+	 * In case we are missing at least one interrupt vector,
+	 * the first interrupt vector will serve non-RX and FBQ causes.
+	 */
+	for (i = 0; i < ARRAY_SIZE(causes_list); i++) {
+		iwl_write8(trans, CSR_MSIX_IVAR(causes_list[i].addr), val);
+		iwl_clear_bit(trans, causes_list[i].mask_reg,
+			      causes_list[i].cause_num);
+	}
+}
+
+static void iwl_pcie_map_rx_causes(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	u32 offset =
+		trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_FIRST_RSS ? 1 : 0;
+	u32 val, idx;
+
+	/*
+	 * The first RX queue - fallback queue, which is designated for
+	 * management frame, command responses etc, is always mapped to the
+	 * first interrupt vector. The other RX queues are mapped to
+	 * the other (N - 2) interrupt vectors.
+	 */
+	val = BIT(MSIX_FH_INT_CAUSES_Q(0));
+	for (idx = 1; idx < trans->num_rx_queues; idx++) {
+		iwl_write8(trans, CSR_MSIX_RX_IVAR(idx),
+			   MSIX_FH_INT_CAUSES_Q(idx - offset));
+		val |= BIT(MSIX_FH_INT_CAUSES_Q(idx));
+	}
+	iwl_write32(trans, CSR_MSIX_FH_INT_MASK_AD, ~val);
+
+	val = MSIX_FH_INT_CAUSES_Q(0);
+	if (trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_NON_RX)
+		val |= MSIX_NON_AUTO_CLEAR_CAUSE;
+	iwl_write8(trans, CSR_MSIX_RX_IVAR(0), val);
+
+	if (trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_FIRST_RSS)
+		iwl_write8(trans, CSR_MSIX_RX_IVAR(1), val);
+}
+
+static void iwl_pcie_init_msix(struct iwl_trans_pcie *trans_pcie)
+{
+	struct iwl_trans *trans = trans_pcie->trans;
+
+	if (!trans_pcie->msix_enabled) {
+		if (trans->cfg->mq_rx_supported)
+			iwl_write_prph(trans, UREG_CHICK,
+				       UREG_CHICK_MSI_ENABLE);
+		return;
+	}
+
+	iwl_write_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
+
+	/*
+	 * Each cause from the causes list above and the RX causes is
+	 * represented as a byte in the IVAR table. The first nibble
+	 * represents the bound interrupt vector of the cause, the second
+	 * represents no auto clear for this cause. This will be set if its
+	 * interrupt vector is bound to serve other causes.
+	 */
+	iwl_pcie_map_rx_causes(trans);
+
+	iwl_pcie_map_non_rx_causes(trans);
+
+	trans_pcie->fh_init_mask =
+		~iwl_read32(trans, CSR_MSIX_FH_INT_MASK_AD);
+	trans_pcie->fh_mask = trans_pcie->fh_init_mask;
+	trans_pcie->hw_init_mask =
+		~iwl_read32(trans, CSR_MSIX_HW_INT_MASK_AD);
+	trans_pcie->hw_mask = trans_pcie->hw_init_mask;
+}
+
 static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1405,109 +1508,6 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	return 0;
 }
 
-struct iwl_causes_list {
-	u32 cause_num;
-	u32 mask_reg;
-	u8 addr;
-};
-
-static struct iwl_causes_list causes_list[] = {
-	{MSIX_FH_INT_CAUSES_D2S_CH0_NUM,	CSR_MSIX_FH_INT_MASK_AD, 0},
-	{MSIX_FH_INT_CAUSES_D2S_CH1_NUM,	CSR_MSIX_FH_INT_MASK_AD, 0x1},
-	{MSIX_FH_INT_CAUSES_S2D,		CSR_MSIX_FH_INT_MASK_AD, 0x3},
-	{MSIX_FH_INT_CAUSES_FH_ERR,		CSR_MSIX_FH_INT_MASK_AD, 0x5},
-	{MSIX_HW_INT_CAUSES_REG_ALIVE,		CSR_MSIX_HW_INT_MASK_AD, 0x10},
-	{MSIX_HW_INT_CAUSES_REG_WAKEUP,		CSR_MSIX_HW_INT_MASK_AD, 0x11},
-	{MSIX_HW_INT_CAUSES_REG_CT_KILL,	CSR_MSIX_HW_INT_MASK_AD, 0x16},
-	{MSIX_HW_INT_CAUSES_REG_RF_KILL,	CSR_MSIX_HW_INT_MASK_AD, 0x17},
-	{MSIX_HW_INT_CAUSES_REG_PERIODIC,	CSR_MSIX_HW_INT_MASK_AD, 0x18},
-	{MSIX_HW_INT_CAUSES_REG_SW_ERR,		CSR_MSIX_HW_INT_MASK_AD, 0x29},
-	{MSIX_HW_INT_CAUSES_REG_SCD,		CSR_MSIX_HW_INT_MASK_AD, 0x2A},
-	{MSIX_HW_INT_CAUSES_REG_FH_TX,		CSR_MSIX_HW_INT_MASK_AD, 0x2B},
-	{MSIX_HW_INT_CAUSES_REG_HW_ERR,		CSR_MSIX_HW_INT_MASK_AD, 0x2D},
-	{MSIX_HW_INT_CAUSES_REG_HAP,		CSR_MSIX_HW_INT_MASK_AD, 0x2E},
-};
-
-static void iwl_pcie_map_non_rx_causes(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie =  IWL_TRANS_GET_PCIE_TRANS(trans);
-	int val = trans_pcie->def_irq | MSIX_NON_AUTO_CLEAR_CAUSE;
-	int i;
-
-	/*
-	 * Access all non RX causes and map them to the default irq.
-	 * In case we are missing at least one interrupt vector,
-	 * the first interrupt vector will serve non-RX and FBQ causes.
-	 */
-	for (i = 0; i < ARRAY_SIZE(causes_list); i++) {
-		iwl_write8(trans, CSR_MSIX_IVAR(causes_list[i].addr), val);
-		iwl_clear_bit(trans, causes_list[i].mask_reg,
-			      causes_list[i].cause_num);
-	}
-}
-
-static void iwl_pcie_map_rx_causes(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 offset =
-		trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_FIRST_RSS ? 1 : 0;
-	u32 val, idx;
-
-	/*
-	 * The first RX queue - fallback queue, which is designated for
-	 * management frame, command responses etc, is always mapped to the
-	 * first interrupt vector. The other RX queues are mapped to
-	 * the other (N - 2) interrupt vectors.
-	 */
-	val = BIT(MSIX_FH_INT_CAUSES_Q(0));
-	for (idx = 1; idx < trans->num_rx_queues; idx++) {
-		iwl_write8(trans, CSR_MSIX_RX_IVAR(idx),
-			   MSIX_FH_INT_CAUSES_Q(idx - offset));
-		val |= BIT(MSIX_FH_INT_CAUSES_Q(idx));
-	}
-	iwl_write32(trans, CSR_MSIX_FH_INT_MASK_AD, ~val);
-
-	val = MSIX_FH_INT_CAUSES_Q(0);
-	if (trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_NON_RX)
-		val |= MSIX_NON_AUTO_CLEAR_CAUSE;
-	iwl_write8(trans, CSR_MSIX_RX_IVAR(0), val);
-
-	if (trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_FIRST_RSS)
-		iwl_write8(trans, CSR_MSIX_RX_IVAR(1), val);
-}
-
-static void iwl_pcie_init_msix(struct iwl_trans_pcie *trans_pcie)
-{
-	struct iwl_trans *trans = trans_pcie->trans;
-
-	if (!trans_pcie->msix_enabled) {
-		if (trans->cfg->mq_rx_supported)
-			iwl_write_prph(trans, UREG_CHICK,
-				       UREG_CHICK_MSI_ENABLE);
-		return;
-	}
-
-	iwl_write_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
-
-	/*
-	 * Each cause from the causes list above and the RX causes is
-	 * represented as a byte in the IVAR table. The first nibble
-	 * represents the bound interrupt vector of the cause, the second
-	 * represents no auto clear for this cause. This will be set if its
-	 * interrupt vector is bound to serve other causes.
-	 */
-	iwl_pcie_map_rx_causes(trans);
-
-	iwl_pcie_map_non_rx_causes(trans);
-
-	trans_pcie->fh_init_mask =
-		~iwl_read32(trans, CSR_MSIX_FH_INT_MASK_AD);
-	trans_pcie->fh_mask = trans_pcie->fh_init_mask;
-	trans_pcie->hw_init_mask =
-		~iwl_read32(trans, CSR_MSIX_HW_INT_MASK_AD);
-	trans_pcie->hw_mask = trans_pcie->hw_init_mask;
-}
-
 static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 					struct iwl_trans *trans)
 {
-- 
2.11.0
