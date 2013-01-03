Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3ACOpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/12] iwlwifi: request IRQ only once
Date: Thu,  3 Jan 2013 15:46:13 +0100
Message-Id: <1357224376-27803-9-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154607_585240_71A92F79)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to request the IRQ every time the
device is started, we can request it just once.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |  4 --
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 62 +++++++++++-----------------
 2 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 15f7975..8f017c3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -222,8 +222,6 @@ struct iwl_txq {
  * @rx_replenish: work that will be called when buffers need to be allocated
  * @drv - pointer to iwl_drv
  * @trans: pointer to the generic transport area
- * @irq - the irq number for the device
- * @irq_requested: true when the irq has been requested
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
  * @kw: keep warm address
@@ -250,11 +248,9 @@ struct iwl_trans_pcie {
 	int ict_index;
 	u32 inta;
 	bool use_ict;
-	bool irq_requested;
 	struct tasklet_struct irq_tasklet;
 	struct isr_statistics isr_stats;
 
-	unsigned int irq;
 	spinlock_t irq_lock;
 	u32 inta_mask;
 	u32 scd_base_addr;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 3a40607..48cd65e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -535,7 +535,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	iwl_enable_rfkill_int(trans);
 
 	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(trans_pcie->irq);
+	synchronize_irq(trans_pcie->pci_dev->irq);
 	tasklet_kill(&trans_pcie->irq_tasklet);
 
 	cancel_work_sync(&trans_pcie->rx_replenish);
@@ -564,33 +564,13 @@ static void iwl_trans_pcie_wowlan_suspend(struct iwl_trans *trans)
 
 static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int err;
 	bool hw_rfkill;
-
-	trans_pcie->inta_mask = CSR_INI_SET_MASK;
-
-	if (!trans_pcie->irq_requested) {
-		tasklet_init(&trans_pcie->irq_tasklet, (void (*)(unsigned long))
-			iwl_pcie_tasklet, (unsigned long)trans);
-
-		iwl_pcie_alloc_ict(trans);
-
-		err = request_irq(trans_pcie->irq, iwl_pcie_isr_ict,
-				  IRQF_SHARED, DRV_NAME, trans);
-		if (err) {
-			IWL_ERR(trans, "Error allocating IRQ %d\n",
-				trans_pcie->irq);
-			goto error;
-		}
-
-		trans_pcie->irq_requested = true;
-	}
+	int err;
 
 	err = iwl_pcie_prepare_card_hw(trans);
 	if (err) {
 		IWL_ERR(trans, "Error while preparing HW: %d\n", err);
-		goto err_free_irq;
+		return err;
 	}
 
 	iwl_pcie_apm_init(trans);
@@ -601,15 +581,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
-	return err;
-
-err_free_irq:
-	trans_pcie->irq_requested = false;
-	free_irq(trans_pcie->irq, trans);
-error:
-	iwl_pcie_free_ict(trans);
-	tasklet_kill(&trans_pcie->irq_tasklet);
-	return err;
+	return 0;
 }
 
 static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans,
@@ -713,10 +685,8 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	iwl_pcie_tx_free(trans);
 	iwl_pcie_rx_free(trans);
 
-	if (trans_pcie->irq_requested == true) {
-		free_irq(trans_pcie->irq, trans);
-		iwl_pcie_free_ict(trans);
-	}
+	free_irq(trans_pcie->pci_dev->irq, trans);
+	iwl_pcie_free_ict(trans);
 
 	pci_disable_msi(trans_pcie->pci_dev);
 	iounmap(trans_pcie->hw_base);
@@ -1424,7 +1394,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	}
 
 	trans->dev = &pdev->dev;
-	trans_pcie->irq = pdev->irq;
 	trans_pcie->pci_dev = pdev;
 	trans->hw_rev = iwl_read32(trans, CSR_HW_REV);
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
@@ -1450,8 +1419,27 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	if (!trans->dev_cmd_pool)
 		goto out_pci_disable_msi;
 
+	trans_pcie->inta_mask = CSR_INI_SET_MASK;
+
+	tasklet_init(&trans_pcie->irq_tasklet, (void (*)(unsigned long))
+		     iwl_pcie_tasklet, (unsigned long)trans);
+
+	if (iwl_pcie_alloc_ict(trans))
+		goto out_free_cmd_pool;
+
+	err = request_irq(pdev->irq, iwl_pcie_isr_ict,
+			  IRQF_SHARED, DRV_NAME, trans);
+	if (err) {
+		IWL_ERR(trans, "Error allocating IRQ %d\n", pdev->irq);
+		goto out_free_ict;
+	}
+
 	return trans;
 
+out_free_ict:
+	iwl_pcie_free_ict(trans);
+out_free_cmd_pool:
+	kmem_cache_destroy(trans->dev_cmd_pool);
 out_pci_disable_msi:
 	pci_disable_msi(pdev);
 out_pci_release_regions:
-- 
1.8.0

