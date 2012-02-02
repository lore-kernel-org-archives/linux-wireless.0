Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab2BCAQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/28] iwlwifi: rename trans_ops->request_irq to trans_ops->start_hw
Date: Thu,  2 Feb 2012 15:09:02 -0800
Message-Id: <1328224159-18134-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011757_569037_6DD22782)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This handler will become thicker, reflect its real role now.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   36 +++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    8 ++--
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8b1839a..1c00691 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1829,7 +1829,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		cfg(priv)->name, hw_rev);
 
-	err = iwl_trans_request_irq(trans(priv));
+	err = iwl_trans_start_hw(trans(priv));
 	if (err)
 		goto out_free_traffic_mem;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 555175f..561865f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -201,6 +201,7 @@ struct iwl_tx_queue {
  * @rxq: all the RX queue data
  * @rx_replenish: work that will be called when buffers need to be allocated
  * @trans: pointer to the generic transport area
+ * @irq_requested: true when the irq has been requested
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
  * @kw: keep warm address
@@ -225,6 +226,7 @@ struct iwl_trans_pcie {
 	int ict_index;
 	u32 inta;
 	bool use_ict;
+	bool irq_requested;
 	struct tasklet_struct irq_tasklet;
 	struct isr_statistics isr_stats;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index a1ee2e4..ffbafb9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1235,7 +1235,7 @@ static void iwl_trans_pcie_kick_nic(struct iwl_trans *trans)
 	iwl_write32(trans, CSR_RESET, 0);
 }
 
-static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
+static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1243,20 +1243,26 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 
 	trans_pcie->inta_mask = CSR_INI_SET_MASK;
 
-	tasklet_init(&trans_pcie->irq_tasklet, (void (*)(unsigned long))
-		iwl_irq_tasklet, (unsigned long)trans);
+	if (!trans_pcie->irq_requested) {
+		tasklet_init(&trans_pcie->irq_tasklet, (void (*)(unsigned long))
+			iwl_irq_tasklet, (unsigned long)trans);
 
-	iwl_alloc_isr_ict(trans);
+		iwl_alloc_isr_ict(trans);
 
-	err = request_irq(trans->irq, iwl_isr_ict, IRQF_SHARED,
-		DRV_NAME, trans);
-	if (err) {
-		IWL_ERR(trans, "Error allocating IRQ %d\n", trans->irq);
-		iwl_free_isr_ict(trans);
-		return err;
+		err = request_irq(trans->irq, iwl_isr_ict, IRQF_SHARED,
+			DRV_NAME, trans);
+		if (err) {
+			IWL_ERR(trans, "Error allocating IRQ %d\n",
+				trans->irq);
+			iwl_free_isr_ict(trans);
+			tasklet_kill(&trans_pcie->irq_tasklet);
+			return err;
+		}
+
+		INIT_WORK(&trans_pcie->rx_replenish, iwl_bg_rx_replenish);
+		trans_pcie->irq_requested = true;
 	}
 
-	INIT_WORK(&trans_pcie->rx_replenish, iwl_bg_rx_replenish);
 	return 0;
 }
 
@@ -1325,8 +1331,10 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 #ifndef CONFIG_IWLWIFI_IDI
 	iwl_trans_pcie_rx_free(trans);
 #endif
-	free_irq(trans->irq, trans);
-	iwl_free_isr_ict(trans);
+	if (trans_pcie->irq_requested == true) {
+		free_irq(trans->irq, trans);
+		iwl_free_isr_ict(trans);
+	}
 
 	pci_disable_msi(trans_pcie->pci_dev);
 	pci_iounmap(trans_pcie->pci_dev, trans_pcie->hw_base);
@@ -1920,7 +1928,7 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 #endif /*CONFIG_IWLWIFI_DEBUGFS */
 
 const struct iwl_trans_ops trans_ops_pcie = {
-	.request_irq = iwl_trans_pcie_request_irq,
+	.start_hw = iwl_trans_pcie_start_hw,
 	.fw_alive = iwl_trans_pcie_fw_alive,
 	.start_device = iwl_trans_pcie_start_device,
 	.prepare_card_hw = iwl_trans_pcie_prepare_card_hw,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index d519599..ddc3a06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -133,7 +133,7 @@ struct iwl_host_cmd {
 
 /**
  * struct iwl_trans_ops - transport specific operations
- * @request_irq: requests IRQ - will be called before the FW load in probe flow
+ * @start_hw: starts the HW- from that point on, the HW can send interrupts
  * @start_device: allocates and inits all the resources for the transport
  *                layer.
  * @prepare_card_hw: claim the ownership on the HW. Will be called during
@@ -164,7 +164,7 @@ struct iwl_host_cmd {
  */
 struct iwl_trans_ops {
 
-	int (*request_irq)(struct iwl_trans *iwl_trans);
+	int (*start_hw)(struct iwl_trans *iwl_trans);
 	int (*start_device)(struct iwl_trans *trans);
 	void (*fw_alive)(struct iwl_trans *trans);
 	int (*prepare_card_hw)(struct iwl_trans *trans);
@@ -269,9 +269,9 @@ struct iwl_trans {
 	char trans_specific[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
-static inline int iwl_trans_request_irq(struct iwl_trans *trans)
+static inline int iwl_trans_start_hw(struct iwl_trans *trans)
 {
-	return trans->ops->request_irq(trans);
+	return trans->ops->start_hw(trans);
 }
 
 static inline void iwl_trans_fw_alive(struct iwl_trans *trans)
-- 
1.7.0.4

