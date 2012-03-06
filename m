Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031499Ab2CFWni (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:38 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 26/33] iwlwifi: move irq to PCIe
Date: Tue,  6 Mar 2012 13:31:01 -0800
Message-Id: <1331069468-11074-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234358_553588_509312EE)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even if the variable might also be used by other
transports, there's no need for anything outside
of the transport itself to access it, so move it
into the private area.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    2 --
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 93f49ac..d13b8d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -231,6 +231,7 @@ struct iwl_tx_queue {
  * @rxq: all the RX queue data
  * @rx_replenish: work that will be called when buffers need to be allocated
  * @trans: pointer to the generic transport area
+ * @irq - the irq number for the device
  * @irq_requested: true when the irq has been requested
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
@@ -262,6 +263,7 @@ struct iwl_trans_pcie {
 	struct tasklet_struct irq_tasklet;
 	struct isr_statistics isr_stats;
 
+	unsigned int irq;
 	spinlock_t irq_lock;
 	u32 inta_mask;
 	u32 scd_base_addr;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 83143d8..d68dd65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1303,7 +1303,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(trans->irq);
+	synchronize_irq(trans_pcie->irq);
 	tasklet_kill(&trans_pcie->irq_tasklet);
 
 	cancel_work_sync(&trans_pcie->rx_replenish);
@@ -1522,11 +1522,11 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 
 		iwl_alloc_isr_ict(trans);
 
-		err = request_irq(trans->irq, iwl_isr_ict, IRQF_SHARED,
+		err = request_irq(trans_pcie->irq, iwl_isr_ict, IRQF_SHARED,
 			DRV_NAME, trans);
 		if (err) {
 			IWL_ERR(trans, "Error allocating IRQ %d\n",
-				trans->irq);
+				trans_pcie->irq);
 			goto error;
 		}
 
@@ -1549,7 +1549,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 	return err;
 
 err_free_irq:
-	free_irq(trans->irq, trans);
+	free_irq(trans_pcie->irq, trans);
 error:
 	iwl_free_isr_ict(trans);
 	tasklet_kill(&trans_pcie->irq_tasklet);
@@ -1638,7 +1638,7 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 	iwl_trans_pcie_rx_free(trans);
 #endif
 	if (trans_pcie->irq_requested == true) {
-		free_irq(trans->irq, trans);
+		free_irq(trans_pcie->irq, trans);
 		iwl_free_isr_ict(trans);
 	}
 
@@ -2329,7 +2329,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 			"pci_enable_msi failed(0X%x)", err);
 
 	trans->dev = &pdev->dev;
-	trans->irq = pdev->irq;
+	trans_pcie->irq = pdev->irq;
 	trans_pcie->pci_dev = pdev;
 	trans->hw_rev = iwl_read32(trans, CSR_HW_REV);
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index dcad694..a4a9efc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -334,7 +334,6 @@ enum iwl_trans_state {
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  * @reg_lock - protect hw register access
  * @dev - pointer to struct device * that represents the device
- * @irq - the irq number for the device
  * @hw_id: a u32 with the ID of the device / subdevice.
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
@@ -349,7 +348,6 @@ struct iwl_trans {
 	spinlock_t reg_lock;
 
 	struct device *dev;
-	unsigned int irq;
 	u32 hw_rev;
 	u32 hw_id;
 	char hw_id_str[52];
-- 
1.7.0.4

