Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54900 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753780AbcIOSM7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:18 +0300
Message-Id: <20160915181131.32213-12-luca@coelho.fi> (sfid-20160915_201304_953385_860D0AED)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 12/25] iwlwifi: pcie: Configure shared interrupt vector in MSIX mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

In case the OS provides fewer interrupts than requested, different
causes will share the same interrupt vector as follow:
1.One interrupt less: non rx causes shared with FBQ.
2.Two interrupts less: non rx causes shared with FBQ and RSS.
3.More than two interrupts: we will use fewer RSS queues.

Also make the request depend on the number of online CPUs
instead of possible CPUs.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  21 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  14 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 150 ++++++++++++++-------
 4 files changed, 132 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 871ad02..d73e9d4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -589,6 +589,8 @@ enum dtd_diode_reg {
  * Causes for the FH register interrupts
  */
 enum msix_fh_int_causes {
+	MSIX_FH_INT_CAUSES_Q0			= BIT(0),
+	MSIX_FH_INT_CAUSES_Q1			= BIT(1),
 	MSIX_FH_INT_CAUSES_D2S_CH0_NUM		= BIT(16),
 	MSIX_FH_INT_CAUSES_D2S_CH1_NUM		= BIT(17),
 	MSIX_FH_INT_CAUSES_S2D			= BIT(19),
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index cad2d11..8ad92fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -304,6 +304,16 @@ struct iwl_tso_hdr_page {
 };
 
 /**
+ * enum iwl_shared_irq_flags - level of sharing for irq
+ * @IWL_SHARED_IRQ_NON_RX: interrupt vector serves non rx causes.
+ * @IWL_SHARED_IRQ_FIRST_RSS: interrupt vector serves first RSS queue.
+ */
+enum iwl_shared_irq_flags {
+	IWL_SHARED_IRQ_NON_RX		= BIT(0),
+	IWL_SHARED_IRQ_FIRST_RSS	= BIT(1),
+};
+
+/**
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
  * @rx_pool: initial pool of iwl_rx_mem_buffer for all the queues
@@ -333,8 +343,10 @@ struct iwl_tso_hdr_page {
  * @fw_mon_size: size of the buffer for the firmware monitor
  * @msix_entries: array of MSI-X entries
  * @msix_enabled: true if managed to enable MSI-X
- * @allocated_vector: the number of interrupt vector allocated by the OS
- * @default_irq_num: default irq for non rx interrupt
+ * @shared_vec_mask: the type of causes the shared vector handles
+ *	(see iwl_shared_irq_flags).
+ * @alloc_vecs: the number of interrupt vectors allocated by the OS
+ * @def_irq: default irq for non rx causes
  * @fh_init_mask: initial unmasked fh causes
  * @hw_init_mask: initial unmasked hw causes
  * @fh_mask: current unmasked fh causes
@@ -407,8 +419,9 @@ struct iwl_trans_pcie {
 
 	struct msix_entry msix_entries[IWL_MAX_RX_HW_QUEUES];
 	bool msix_enabled;
-	u32 allocated_vector;
-	u32 default_irq_num;
+	u8 shared_vec_mask;
+	u32 alloc_vecs;
+	u32 def_irq;
 	u32 fh_init_mask;
 	u32 hw_init_mask;
 	u32 fh_mask;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 452387c..0b5b331 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1885,6 +1885,20 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 			      inta_fh,
 			      iwl_read32(trans, CSR_MSIX_FH_INT_MASK_AD));
 
+	if ((trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_NON_RX) &&
+	    inta_fh & MSIX_FH_INT_CAUSES_Q0) {
+		local_bh_disable();
+		iwl_pcie_rx_handle(trans, 0);
+		local_bh_enable();
+	}
+
+	if ((trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_FIRST_RSS) &&
+	    inta_fh & MSIX_FH_INT_CAUSES_Q1) {
+		local_bh_disable();
+		iwl_pcie_rx_handle(trans, 1);
+		local_bh_enable();
+	}
+
 	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta_fh & MSIX_FH_INT_CAUSES_D2S_CH0_NUM) {
 		IWL_DEBUG_ISR(trans, "uCode load interrupt\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 361ccf6..be32fe1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1170,7 +1170,7 @@ static void iwl_pcie_synchronize_irqs(struct iwl_trans *trans)
 	if (trans_pcie->msix_enabled) {
 		int i;
 
-		for (i = 0; i < trans_pcie->allocated_vector; i++)
+		for (i = 0; i < trans_pcie->alloc_vecs; i++)
 			synchronize_irq(trans_pcie->msix_entries[i].vector);
 	} else {
 		synchronize_irq(trans_pcie->pci_dev->irq);
@@ -1429,13 +1429,58 @@ static struct iwl_causes_list causes_list[] = {
 	{MSIX_HW_INT_CAUSES_REG_HAP,		CSR_MSIX_HW_INT_MASK_AD, 0x2E},
 };
 
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
 static void iwl_pcie_init_msix(struct iwl_trans_pcie *trans_pcie)
 {
-	u32 val, max_rx_vector, i;
 	struct iwl_trans *trans = trans_pcie->trans;
 
-	max_rx_vector = trans_pcie->allocated_vector - 1;
-
 	if (!trans_pcie->msix_enabled) {
 		if (trans->cfg->mq_rx_supported)
 			iwl_write_prph(trans, UREG_CHICK,
@@ -1446,25 +1491,16 @@ static void iwl_pcie_init_msix(struct iwl_trans_pcie *trans_pcie)
 	iwl_write_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
 
 	/*
-	 * Each cause from the list above and the RX causes is represented as
-	 * a byte in the IVAR table. We access the first (N - 1) bytes and map
-	 * them to the (N - 1) vectors so these vectors will be used as rx
-	 * vectors. Then access all non rx causes and map them to the
-	 * default queue (N'th queue).
+	 * Each cause from the causes list above and the RX causes is
+	 * represented as a byte in the IVAR table. The first nibble
+	 * represents the bound interrupt vector of the cause, the second
+	 * represents no auto clear for this cause. This will be set if its
+	 * interrupt vector is bound to serve other causes.
 	 */
-	for (i = 0; i < max_rx_vector; i++) {
-		iwl_write8(trans, CSR_MSIX_RX_IVAR(i), MSIX_FH_INT_CAUSES_Q(i));
-		iwl_clear_bit(trans, CSR_MSIX_FH_INT_MASK_AD,
-			      BIT(MSIX_FH_INT_CAUSES_Q(i)));
-	}
+	iwl_pcie_map_rx_causes(trans);
+
+	iwl_pcie_map_non_rx_causes(trans);
 
-	for (i = 0; i < ARRAY_SIZE(causes_list); i++) {
-		val = trans_pcie->default_irq_num |
-			MSIX_NON_AUTO_CLEAR_CAUSE;
-		iwl_write8(trans, CSR_MSIX_IVAR(causes_list[i].addr), val);
-		iwl_clear_bit(trans, causes_list[i].mask_reg,
-			      causes_list[i].cause_num);
-	}
 	trans_pcie->fh_init_mask =
 		~iwl_read32(trans, CSR_MSIX_FH_INT_MASK_AD);
 	trans_pcie->fh_mask = trans_pcie->fh_init_mask;
@@ -1477,9 +1513,8 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 					struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int max_vector, nvec, i;
 	u16 pci_cmd;
-	int max_vector;
-	int ret, i;
 
 	if (trans->cfg->mq_rx_supported) {
 		max_vector = min_t(u32, (num_possible_cpus() + 2),
@@ -1487,33 +1522,48 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 		for (i = 0; i < max_vector; i++)
 			trans_pcie->msix_entries[i].entry = i;
 
-		ret = pci_enable_msix_range(pdev, trans_pcie->msix_entries,
-					    MSIX_MIN_INTERRUPT_VECTORS,
-					    max_vector);
-		if (ret > 1) {
+		nvec = pci_enable_msix_range(pdev, trans_pcie->msix_entries,
+					     MSIX_MIN_INTERRUPT_VECTORS,
+					     max_vector);
+		if (nvec < 0) {
 			IWL_DEBUG_INFO(trans,
-				       "Enable MSI-X allocate %d interrupt vector\n",
-				       ret);
-			trans_pcie->allocated_vector = ret;
-			trans_pcie->default_irq_num =
-				trans_pcie->allocated_vector - 1;
-			trans_pcie->trans->num_rx_queues =
-				trans_pcie->allocated_vector - 1;
-			trans_pcie->msix_enabled = true;
-
-			return;
+				       "ret = %d failed to enable msi-x mode move to msi mode\n",
+				       nvec);
+			goto msi;
 		}
+
 		IWL_DEBUG_INFO(trans,
-			       "ret = %d %s move to msi mode\n", ret,
-			       (ret == 1) ?
-			       "can't allocate more than 1 interrupt vector" :
-			       "failed to enable msi-x mode");
-		pci_disable_msix(pdev);
+			       "Enable MSI-X allocate %d interrupt vector\n",
+			       nvec);
+		trans_pcie->def_irq = (nvec == max_vector) ? nvec - 1 : 0;
+		/*
+		 * In case the OS provides fewer interrupts than requested,
+		 * different causes will share the same interrupt vector
+		 * as follow:
+		 * One interrupt less: non rx causes shared with FBQ.
+		 * Two interrupts less: non rx causes shared with FBQ and RSS.
+		 * More than two interrupts: we will use fewer RSS queues.
+		 */
+		if (nvec <= num_online_cpus()) {
+			trans_pcie->trans->num_rx_queues = nvec + 1;
+			trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX |
+				IWL_SHARED_IRQ_FIRST_RSS;
+		} else if (nvec == num_online_cpus() + 1) {
+			trans_pcie->trans->num_rx_queues = nvec;
+			trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX;
+		} else {
+			trans_pcie->trans->num_rx_queues = nvec - 1;
+		}
+
+		trans_pcie->alloc_vecs = nvec;
+		trans_pcie->msix_enabled = true;
+		return;
 	}
+msi:
 
-	ret = pci_enable_msi(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "pci_enable_msi failed - %d\n", ret);
+	nvec = pci_enable_msi(pdev);
+	if (nvec) {
+		dev_err(&pdev->dev, "pci_enable_msi failed - %d\n", nvec);
 		/* enable rfkill interrupt: hw bug w/a */
 		pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
 		if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
@@ -1526,16 +1576,14 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 				      struct iwl_trans_pcie *trans_pcie)
 {
-	int i, last_vector;
-
-	last_vector = trans_pcie->trans->num_rx_queues;
+	int i;
 
-	for (i = 0; i < trans_pcie->allocated_vector; i++) {
+	for (i = 0; i < trans_pcie->alloc_vecs; i++) {
 		int ret;
 
 		ret = request_threaded_irq(trans_pcie->msix_entries[i].vector,
 					   iwl_pcie_msix_isr,
-					   (i == last_vector) ?
+					   (i == trans_pcie->def_irq) ?
 					   iwl_pcie_irq_msix_handler :
 					   iwl_pcie_irq_rx_msix_handler,
 					   IRQF_SHARED,
@@ -1712,7 +1760,7 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	iwl_pcie_rx_free(trans);
 
 	if (trans_pcie->msix_enabled) {
-		for (i = 0; i < trans_pcie->allocated_vector; i++)
+		for (i = 0; i < trans_pcie->alloc_vecs; i++)
 			free_irq(trans_pcie->msix_entries[i].vector,
 				 &trans_pcie->msix_entries[i]);
 
-- 
2.9.3
