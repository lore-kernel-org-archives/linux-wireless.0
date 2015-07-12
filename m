Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20159 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbbGLRId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 04/10] iwlwifi: pcie: don't panic if pcie transport alloc fails
Date: Sun, 12 Jul 2015 20:08:14 +0300
Message-Id: <1436720900-18588-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_190838_536851_50DF0B38)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_trans_pcie_alloc needs to return a non-zero value
if it fails. Otherwise the iwl_drv_start will think that
the allocation succeeded.
Remove the duplication of err and ret variable and use ret
which is the name we usually use in other places of the
driver.

Fixes: c278754a21e6 ("iwlwifi: mvm: support family 8000 B2/C steps")
CC: <stable@vger.kernel.org> [4.1]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 44 +++++++++++++++----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 608ba1e..fe61d0a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2459,7 +2459,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	struct iwl_trans_pcie *trans_pcie;
 	struct iwl_trans *trans;
 	u16 pci_cmd;
-	int err;
+	int ret;
 
 	trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie),
 				&pdev->dev, cfg, &trans_ops_pcie, 0);
@@ -2474,8 +2474,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	spin_lock_init(&trans_pcie->ref_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
-	err = pci_enable_device(pdev);
-	if (err)
+	ret = pci_enable_device(pdev);
+	if (ret)
 		goto out_no_pci;
 
 	if (!cfg->base_params->pcie_l1_allowed) {
@@ -2491,23 +2491,23 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
-	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(36));
-	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (!err)
-			err = pci_set_consistent_dma_mask(pdev,
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
+	if (!ret)
+		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(36));
+	if (ret) {
+		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (!ret)
+			ret = pci_set_consistent_dma_mask(pdev,
 							  DMA_BIT_MASK(32));
 		/* both attempts failed: */
-		if (err) {
+		if (ret) {
 			dev_err(&pdev->dev, "No suitable DMA available\n");
 			goto out_pci_disable_device;
 		}
 	}
 
-	err = pci_request_regions(pdev, DRV_NAME);
-	if (err) {
+	ret = pci_request_regions(pdev, DRV_NAME);
+	if (ret) {
 		dev_err(&pdev->dev, "pci_request_regions failed\n");
 		goto out_pci_disable_device;
 	}
@@ -2515,7 +2515,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	trans_pcie->hw_base = pci_ioremap_bar(pdev, 0);
 	if (!trans_pcie->hw_base) {
 		dev_err(&pdev->dev, "pci_ioremap_bar failed\n");
-		err = -ENODEV;
+		ret = -ENODEV;
 		goto out_pci_release_regions;
 	}
 
@@ -2527,9 +2527,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	trans_pcie->pci_dev = pdev;
 	iwl_disable_interrupts(trans);
 
-	err = pci_enable_msi(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "pci_enable_msi failed(0X%x)\n", err);
+	ret = pci_enable_msi(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_enable_msi failed(0X%x)\n", ret);
 		/* enable rfkill interrupt: hw bug w/a */
 		pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
 		if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
@@ -2547,7 +2547,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	 */
 	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
 		unsigned long flags;
-		int ret;
 
 		trans->hw_rev = (trans->hw_rev & 0xfff0) |
 				(CSR_HW_REV_STEP(trans->hw_rev << 2) << 2);
@@ -2591,13 +2590,14 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	/* Initialize the wait queue for commands */
 	init_waitqueue_head(&trans_pcie->wait_command_queue);
 
-	if (iwl_pcie_alloc_ict(trans))
+	ret = iwl_pcie_alloc_ict(trans);
+	if (ret)
 		goto out_pci_disable_msi;
 
-	err = request_threaded_irq(pdev->irq, iwl_pcie_isr,
+	ret = request_threaded_irq(pdev->irq, iwl_pcie_isr,
 				   iwl_pcie_irq_handler,
 				   IRQF_SHARED, DRV_NAME, trans);
-	if (err) {
+	if (ret) {
 		IWL_ERR(trans, "Error allocating IRQ %d\n", pdev->irq);
 		goto out_free_ict;
 	}
@@ -2617,5 +2617,5 @@ out_pci_disable_device:
 	pci_disable_device(pdev);
 out_no_pci:
 	iwl_trans_free(trans);
-	return ERR_PTR(err);
+	return ERR_PTR(ret);
 }
-- 
2.1.4

