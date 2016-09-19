Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56028 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934201AbcISHcf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:32:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:21 +0300
Message-Id: <20160919073028.22065-18-luca@coelho.fi> (sfid-20160919_093238_594580_66194710)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 18/25] iwlwifi: migrate to devm_* API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

Change PCIE and trans resource allocations to managed resources.

Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c  |  8 +--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 81 ++++++++++---------------
 2 files changed, 34 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index b42152c..d42cab2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -78,7 +78,7 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 	static struct lock_class_key __key;
 #endif
 
-	trans = kzalloc(sizeof(*trans) + priv_size, GFP_KERNEL);
+	trans = devm_kzalloc(dev, sizeof(*trans) + priv_size, GFP_KERNEL);
 	if (!trans)
 		return NULL;
 
@@ -103,18 +103,14 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  SLAB_HWCACHE_ALIGN,
 				  NULL);
 	if (!trans->dev_cmd_pool)
-		goto free;
+		return NULL;
 
 	return trans;
- free:
-	kfree(trans);
-	return NULL;
 }
 
 void iwl_trans_free(struct iwl_trans *trans)
 {
 	kmem_cache_destroy(trans->dev_cmd_pool);
-	kfree(trans);
 }
 
 int iwl_trans_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 68fa843..ae95533 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1605,24 +1605,22 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 
 	for (i = 0; i < trans_pcie->alloc_vecs; i++) {
 		int ret;
-
-		ret = request_threaded_irq(trans_pcie->msix_entries[i].vector,
-					   iwl_pcie_msix_isr,
-					   (i == trans_pcie->def_irq) ?
-					   iwl_pcie_irq_msix_handler :
-					   iwl_pcie_irq_rx_msix_handler,
-					   IRQF_SHARED,
-					   DRV_NAME,
-					   &trans_pcie->msix_entries[i]);
+		struct msix_entry *msix_entry;
+
+		msix_entry = &trans_pcie->msix_entries[i];
+		ret = devm_request_threaded_irq(&pdev->dev,
+						msix_entry->vector,
+						iwl_pcie_msix_isr,
+						(i == trans_pcie->def_irq) ?
+						iwl_pcie_irq_msix_handler :
+						iwl_pcie_irq_rx_msix_handler,
+						IRQF_SHARED,
+						DRV_NAME,
+						msix_entry);
 		if (ret) {
-			int j;
-
 			IWL_ERR(trans_pcie->trans,
 				"Error allocating IRQ %d\n", i);
-			for (j = 0; j < i; j++)
-				free_irq(trans_pcie->msix_entries[j].vector,
-					 &trans_pcie->msix_entries[j]);
-			pci_disable_msix(pdev);
+
 			return ret;
 		}
 	}
@@ -1789,23 +1787,12 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 			irq_set_affinity_hint(
 				trans_pcie->msix_entries[i].vector,
 				NULL);
-
-			free_irq(trans_pcie->msix_entries[i].vector,
-				 &trans_pcie->msix_entries[i]);
 		}
 
-		pci_disable_msix(trans_pcie->pci_dev);
 		trans_pcie->msix_enabled = false;
 	} else {
-		free_irq(trans_pcie->pci_dev->irq, trans);
-
 		iwl_pcie_free_ict(trans);
-
-		pci_disable_msi(trans_pcie->pci_dev);
 	}
-	iounmap(trans_pcie->hw_base);
-	pci_release_regions(trans_pcie->pci_dev);
-	pci_disable_device(trans_pcie->pci_dev);
 
 	iwl_pcie_free_fw_monitor(trans);
 
@@ -2912,6 +2899,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	struct iwl_trans *trans;
 	int ret, addr_size;
 
+	ret = pcim_enable_device(pdev);
+	if (ret)
+		return ERR_PTR(ret);
+
 	trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie),
 				&pdev->dev, cfg, &trans_ops_pcie, 0);
 	if (!trans)
@@ -2930,9 +2921,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		goto out_no_pci;
 	}
 
-	ret = pci_enable_device(pdev);
-	if (ret)
-		goto out_no_pci;
 
 	if (!cfg->base_params->pcie_l1_allowed) {
 		/*
@@ -2974,21 +2962,21 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		/* both attempts failed: */
 		if (ret) {
 			dev_err(&pdev->dev, "No suitable DMA available\n");
-			goto out_pci_disable_device;
+			goto out_no_pci;
 		}
 	}
 
-	ret = pci_request_regions(pdev, DRV_NAME);
+	ret = pcim_iomap_regions_request_all(pdev, BIT(0), DRV_NAME);
 	if (ret) {
-		dev_err(&pdev->dev, "pci_request_regions failed\n");
-		goto out_pci_disable_device;
+		dev_err(&pdev->dev, "pcim_iomap_regions_request_all failed\n");
+		goto out_no_pci;
 	}
 
-	trans_pcie->hw_base = pci_ioremap_bar(pdev, 0);
+	trans_pcie->hw_base = pcim_iomap_table(pdev)[0];
 	if (!trans_pcie->hw_base) {
-		dev_err(&pdev->dev, "pci_ioremap_bar failed\n");
+		dev_err(&pdev->dev, "pcim_iomap_table failed\n");
 		ret = -ENODEV;
-		goto out_pci_release_regions;
+		goto out_no_pci;
 	}
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
@@ -3015,7 +3003,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		ret = iwl_pcie_prepare_card_hw(trans);
 		if (ret) {
 			IWL_WARN(trans, "Exit HW not ready\n");
-			goto out_pci_disable_msi;
+			goto out_no_pci;
 		}
 
 		/*
@@ -3032,7 +3020,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				   25000);
 		if (ret < 0) {
 			IWL_DEBUG_INFO(trans, "Failed to wake up the nic\n");
-			goto out_pci_disable_msi;
+			goto out_no_pci;
 		}
 
 		if (iwl_trans_grab_nic_access(trans, &flags)) {
@@ -3064,15 +3052,16 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 	if (trans_pcie->msix_enabled) {
 		if (iwl_pcie_init_msix_handler(pdev, trans_pcie))
-			goto out_pci_release_regions;
+			goto out_no_pci;
 	 } else {
 		ret = iwl_pcie_alloc_ict(trans);
 		if (ret)
-			goto out_pci_disable_msi;
+			goto out_no_pci;
 
-		ret = request_threaded_irq(pdev->irq, iwl_pcie_isr,
-					   iwl_pcie_irq_handler,
-					   IRQF_SHARED, DRV_NAME, trans);
+		ret = devm_request_threaded_irq(&pdev->dev, pdev->irq,
+						iwl_pcie_isr,
+						iwl_pcie_irq_handler,
+						IRQF_SHARED, DRV_NAME, trans);
 		if (ret) {
 			IWL_ERR(trans, "Error allocating IRQ %d\n", pdev->irq);
 			goto out_free_ict;
@@ -3090,12 +3079,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 out_free_ict:
 	iwl_pcie_free_ict(trans);
-out_pci_disable_msi:
-	pci_disable_msi(pdev);
-out_pci_release_regions:
-	pci_release_regions(pdev);
-out_pci_disable_device:
-	pci_disable_device(pdev);
 out_no_pci:
 	free_percpu(trans_pcie->tso_hdr_page);
 	iwl_trans_free(trans);
-- 
2.9.3
