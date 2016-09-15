Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54894 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753700AbcIOSMz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:25 +0300
Message-Id: <20160915181131.32213-19-luca@coelho.fi> (sfid-20160915_201319_514902_2E4207EE)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: pcie: change indentation of iwl_pcie_set_interrupt_capa()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Function is very indented. Go to msi section if needed to avoid
it and by that make the code more readable.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 88 ++++++++++++-------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index d7521c1..43c3915 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1513,57 +1513,57 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 					struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int max_vector, nvec, i;
+	int max_irqs, num_irqs, i, ret;
 	u16 pci_cmd;
 
-	if (trans->cfg->mq_rx_supported) {
-		max_vector = min_t(u32, (num_possible_cpus() + 2),
-				   IWL_MAX_RX_HW_QUEUES);
-		for (i = 0; i < max_vector; i++)
-			trans_pcie->msix_entries[i].entry = i;
-
-		nvec = pci_enable_msix_range(pdev, trans_pcie->msix_entries,
-					     MSIX_MIN_INTERRUPT_VECTORS,
-					     max_vector);
-		if (nvec < 0) {
-			IWL_DEBUG_INFO(trans,
-				       "ret = %d failed to enable msi-x mode move to msi mode\n",
-				       nvec);
-			goto msi;
-		}
+	if (!trans->cfg->mq_rx_supported)
+		goto enable_msi;
+
+	max_irqs = min_t(u32, num_possible_cpus() + 2, IWL_MAX_RX_HW_QUEUES);
+	for (i = 0; i < max_irqs; i++)
+		trans_pcie->msix_entries[i].entry = i;
 
+	num_irqs = pci_enable_msix_range(pdev, trans_pcie->msix_entries,
+					 MSIX_MIN_INTERRUPT_VECTORS,
+					 max_irqs);
+	if (num_irqs < 0) {
 		IWL_DEBUG_INFO(trans,
-			       "Enable MSI-X allocate %d interrupt vector\n",
-			       nvec);
-		trans_pcie->def_irq = (nvec == max_vector) ? nvec - 1 : 0;
-		/*
-		 * In case the OS provides fewer interrupts than requested,
-		 * different causes will share the same interrupt vector
-		 * as follow:
-		 * One interrupt less: non rx causes shared with FBQ.
-		 * Two interrupts less: non rx causes shared with FBQ and RSS.
-		 * More than two interrupts: we will use fewer RSS queues.
-		 */
-		if (nvec <= num_online_cpus()) {
-			trans_pcie->trans->num_rx_queues = nvec + 1;
-			trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX |
-				IWL_SHARED_IRQ_FIRST_RSS;
-		} else if (nvec == num_online_cpus() + 1) {
-			trans_pcie->trans->num_rx_queues = nvec;
-			trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX;
-		} else {
-			trans_pcie->trans->num_rx_queues = nvec - 1;
-		}
+			       "Failed to enable msi-x mode (ret %d). Moving to msi mode.\n",
+			       num_irqs);
+		goto enable_msi;
+	}
+	trans_pcie->def_irq = (num_irqs == max_irqs) ? num_irqs - 1 : 0;
 
-		trans_pcie->alloc_vecs = nvec;
-		trans_pcie->msix_enabled = true;
-		return;
+	IWL_DEBUG_INFO(trans,
+		       "MSI-X enabled. %d interrupt vectors were allocated\n",
+		       num_irqs);
+
+	/*
+	 * In case the OS provides fewer interrupts than requested, different
+	 * causes will share the same interrupt vector as follows:
+	 * One interrupt less: non rx causes shared with FBQ.
+	 * Two interrupts less: non rx causes shared with FBQ and RSS.
+	 * More than two interrupts: we will use fewer RSS queues.
+	 */
+	if (num_irqs <= num_online_cpus()) {
+		trans_pcie->trans->num_rx_queues = num_irqs + 1;
+		trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX |
+			IWL_SHARED_IRQ_FIRST_RSS;
+	} else if (num_irqs == num_online_cpus() + 1) {
+		trans_pcie->trans->num_rx_queues = num_irqs;
+		trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX;
+	} else {
+		trans_pcie->trans->num_rx_queues = num_irqs - 1;
 	}
-msi:
 
-	nvec = pci_enable_msi(pdev);
-	if (nvec) {
-		dev_err(&pdev->dev, "pci_enable_msi failed - %d\n", nvec);
+	trans_pcie->alloc_vecs = num_irqs;
+	trans_pcie->msix_enabled = true;
+	return;
+
+enable_msi:
+	ret = pci_enable_msi(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_enable_msi failed - %d\n", ret);
 		/* enable rfkill interrupt: hw bug w/a */
 		pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
 		if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
-- 
2.9.3
