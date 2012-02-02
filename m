Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab2BCAQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/28] iwlwifi: move the bus configuration to transport
Date: Thu,  2 Feb 2012 15:08:57 -0800
Message-Id: <1328224159-18134-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011750_466852_54BC3ED4)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the bus configuration is now done in the transport
allocation fucntion.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h            |    2 -
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   93 +-----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    6 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  169 +++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    5 +
 5 files changed, 158 insertions(+), 117 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 941b9cb..37ed7b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -148,7 +148,6 @@ struct iwl_bus_ops {
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  *	NB: for the time being this needs to be set by the upper layer since
  *	it allocates the shared data
- * @irq - the irq number for the device
  * @reg_lock - protect hw register access
  */
 struct iwl_bus {
@@ -156,7 +155,6 @@ struct iwl_bus {
 	const struct iwl_bus_ops *ops;
 	struct iwl_shared *shrd;
 
-	unsigned int irq;
 	spinlock_t reg_lock;
 
 	/* pointer to bus specific struct */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index c0d62e7..631b67c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -367,7 +367,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	struct iwl_bus *bus;
 	struct iwl_pci_bus *pci_bus;
-	u16 pci_cmd;
 	int err;
 
 	bus = kzalloc(sizeof(*bus) + sizeof(*pci_bus), GFP_KERNEL);
@@ -382,7 +381,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "Couldn't allocate iwl_shared");
 		err = -ENOMEM;
-		goto out_no_pci;
+		goto out_free_bus;
 	}
 
 	bus->shrd->bus = bus;
@@ -391,82 +390,14 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata(pdev, bus);
 
-	/* W/A - seems to solve weird behavior. We need to remove this if we
-	 * don't want to stay in L1 all the time. This wastes a lot of power */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
-				PCIE_LINK_STATE_CLKPM);
-
-	if (pci_enable_device(pdev)) {
-		err = -ENODEV;
-		goto out_no_pci;
-	}
-
-	pci_set_master(pdev);
-
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
-	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(36));
-	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (!err)
-			err = pci_set_consistent_dma_mask(pdev,
-							DMA_BIT_MASK(32));
-		/* both attempts failed: */
-		if (err) {
-			dev_printk(KERN_ERR, bus->dev,
-				   "No suitable DMA available.\n");
-			goto out_pci_disable_device;
-		}
-	}
-
-	err = pci_request_regions(pdev, DRV_NAME);
-	if (err) {
-		dev_printk(KERN_ERR, bus->dev, "pci_request_regions failed");
-		goto out_pci_disable_device;
-	}
-
-	pci_bus->hw_base = pci_iomap(pdev, 0, 0);
-	if (!pci_bus->hw_base) {
-		dev_printk(KERN_ERR, bus->dev, "pci_iomap failed");
-		err = -ENODEV;
-		goto out_pci_release_regions;
-	}
-
-	dev_printk(KERN_INFO, &pdev->dev,
-		"pci_resource_len = 0x%08llx\n",
-		(unsigned long long) pci_resource_len(pdev, 0));
-	dev_printk(KERN_INFO, &pdev->dev,
-		"pci_resource_base = %p\n", pci_bus->hw_base);
-
-	dev_printk(KERN_INFO, &pdev->dev,
-		"HW Revision ID = 0x%X\n", pdev->revision);
-
-	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state */
-	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
-
-	err = pci_enable_msi(pdev);
-	if (err)
-		dev_printk(KERN_ERR, &pdev->dev,
-			"pci_enable_msi failed(0X%x)", err);
-
-	/* TODO: Move this away, not needed if not MSI */
-	/* enable rfkill interrupt: hw bug w/a */
-	pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
-	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
-		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
-		pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
-	}
-
 	bus->dev = &pdev->dev;
-	bus->irq = pdev->irq;
 	bus->ops = &bus_ops_pci;
 
 #ifdef CONFIG_IWLWIFI_IDI
 	trans(bus) = iwl_trans_idi_alloc(bus->shrd, pdev, ent);
 	if (trans(bus) == NULL) {
 		err = -ENOMEM;
-		goto out_disable_msi;
+		goto out_free_bus;
 	}
 
 	err = iwl_probe(bus, &trans_ops_idi, cfg);
@@ -474,26 +405,20 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	trans(bus) = iwl_trans_pcie_alloc(bus->shrd, pdev, ent);
 	if (trans(bus) == NULL) {
 		err = -ENOMEM;
-		goto out_disable_msi;
+		goto out_free_bus;
 	}
 
 	err = iwl_probe(bus, &trans_ops_pcie, cfg);
 #endif
 	if (err)
 		goto out_free_trans;
+
 	return 0;
 
 out_free_trans:
 	iwl_trans_free(trans(bus));
-out_disable_msi:
-	pci_disable_msi(pdev);
-	pci_iounmap(pdev, pci_bus->hw_base);
-out_pci_release_regions:
 	pci_set_drvdata(pdev, NULL);
-	pci_release_regions(pdev);
-out_pci_disable_device:
-	pci_disable_device(pdev);
-out_no_pci:
+out_free_bus:
 	kfree(bus->shrd);
 	kfree(bus);
 	return err;
@@ -502,18 +427,12 @@ out_no_pci:
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_bus *bus = pci_get_drvdata(pdev);
-	struct iwl_pci_bus *pci_bus = IWL_BUS_GET_PCI_BUS(bus);
-	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
 	struct iwl_shared *shrd = bus->shrd;
 
 	iwl_remove(shrd->priv);
 	iwl_trans_free(shrd->trans);
 
-	pci_disable_msi(pci_dev);
-	pci_iounmap(pci_dev, pci_bus->hw_base);
-	pci_release_regions(pci_dev);
-	pci_disable_device(pci_dev);
-	pci_set_drvdata(pci_dev, NULL);
+	pci_set_drvdata(pdev, NULL);
 
 	kfree(bus->shrd);
 	kfree(bus);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 0f73778..47d27bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -211,6 +211,8 @@ struct iwl_tx_queue {
  * @txq_ctx_active_msk: what queue is active
  * queue_stopped: tracks what queue is stopped
  * queue_stop_count: tracks what SW queue is stopped
+ * @pci_dev: basic pci-network driver stuff
+ * @hw_base: pci hardware address support
  */
 struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
@@ -241,6 +243,10 @@ struct iwl_trans_pcie {
 #define IWL_MAX_HW_QUEUES	32
 	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
 	atomic_t queue_stop_count[4];
+
+	/* PCI bus related data */
+	struct pci_dev *pci_dev;
+	void __iomem *hw_base;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index f0d8ccc..5d0cfe0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -60,6 +60,8 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+#include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/interrupt.h>
 #include <linux/debugfs.h>
 #include <linux/bitops.h>
@@ -1042,7 +1044,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
 	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(bus(trans)->irq);
+	synchronize_irq(trans->irq);
 	tasklet_kill(&trans_pcie->irq_tasklet);
 
 	/* stop and reset the on-board processor */
@@ -1246,10 +1248,10 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 
 	iwl_alloc_isr_ict(trans);
 
-	err = request_irq(bus(trans)->irq, iwl_isr_ict, IRQF_SHARED,
+	err = request_irq(trans->irq, iwl_isr_ict, IRQF_SHARED,
 		DRV_NAME, trans);
 	if (err) {
-		IWL_ERR(trans, "Error allocating IRQ %d\n", bus(trans)->irq);
+		IWL_ERR(trans, "Error allocating IRQ %d\n", trans->irq);
 		iwl_free_isr_ict(trans);
 		return err;
 	}
@@ -1299,13 +1301,22 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
 	iwl_calib_free_results(trans);
 	iwl_trans_pcie_tx_free(trans);
 #ifndef CONFIG_IWLWIFI_IDI
 	iwl_trans_pcie_rx_free(trans);
 #endif
-	free_irq(bus(trans)->irq, trans);
+	free_irq(trans->irq, trans);
 	iwl_free_isr_ict(trans);
+
+	pci_disable_msi(trans_pcie->pci_dev);
+	pci_iounmap(trans_pcie->pci_dev, trans_pcie->hw_base);
+	pci_release_regions(trans_pcie->pci_dev);
+	pci_disable_device(trans_pcie->pci_dev);
+
 	trans->shrd->trans = NULL;
 	kfree(trans);
 }
@@ -1374,30 +1385,6 @@ static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
 	}
 }
 
-const struct iwl_trans_ops trans_ops_pcie;
-
-struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
-				       struct pci_dev *pdev,
-				       const struct pci_device_id *ent)
-{
-	struct iwl_trans_pcie *trans_pcie;
-	struct iwl_trans *iwl_trans = kzalloc(sizeof(struct iwl_trans) +
-					      sizeof(struct iwl_trans_pcie),
-					      GFP_KERNEL);
-
-	if (WARN_ON(!iwl_trans))
-		return NULL;
-
-	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
-
-	iwl_trans->ops = &trans_ops_pcie;
-	iwl_trans->shrd = shrd;
-	trans_pcie->trans = iwl_trans;
-	spin_lock_init(&iwl_trans->hcmd_lock);
-
-	return iwl_trans;
-}
-
 static void iwl_trans_pcie_stop_queue(struct iwl_trans *trans, int txq_id,
 				      const char *msg)
 {
@@ -1949,3 +1936,129 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.resume = iwl_trans_pcie_resume,
 #endif
 };
+
+/* TODO: remove this hack - will be possible when all the io{write/read} ops
+ * will be done through the transport
+ */
+struct iwl_pci_bus {
+	/* basic pci-network driver stuff */
+	struct pci_dev *pci_dev;
+
+	/* pci hardware address support */
+	void __iomem *hw_base;
+};
+
+#define IWL_BUS_GET_PCI_BUS(_iwl_bus) \
+			((struct iwl_pci_bus *) ((_iwl_bus)->bus_specific))
+
+/* PCI registers */
+#define PCI_CFG_RETRY_TIMEOUT	0x041
+
+struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
+				       struct pci_dev *pdev,
+				       const struct pci_device_id *ent)
+{
+	struct iwl_pci_bus *iwl_pci_bus = IWL_BUS_GET_PCI_BUS(shrd->bus);
+	struct iwl_trans_pcie *trans_pcie;
+	struct iwl_trans *trans;
+	u16 pci_cmd;
+	int err;
+
+	trans = kzalloc(sizeof(struct iwl_trans) +
+			     sizeof(struct iwl_trans_pcie), GFP_KERNEL);
+
+	if (WARN_ON(!trans))
+		return NULL;
+
+	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	trans->ops = &trans_ops_pcie;
+	trans->shrd = shrd;
+	trans_pcie->trans = trans;
+	spin_lock_init(&trans->hcmd_lock);
+
+	/* W/A - seems to solve weird behavior. We need to remove this if we
+	 * don't want to stay in L1 all the time. This wastes a lot of power */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				PCIE_LINK_STATE_CLKPM);
+
+	if (pci_enable_device(pdev)) {
+		err = -ENODEV;
+		goto out_no_pci;
+	}
+
+	pci_set_master(pdev);
+
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
+	if (!err)
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(36));
+	if (err) {
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (!err)
+			err = pci_set_consistent_dma_mask(pdev,
+							DMA_BIT_MASK(32));
+		/* both attempts failed: */
+		if (err) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "No suitable DMA available.\n");
+			goto out_pci_disable_device;
+		}
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		dev_printk(KERN_ERR, &pdev->dev, "pci_request_regions failed");
+		goto out_pci_disable_device;
+	}
+
+	trans_pcie->hw_base = pci_iomap(pdev, 0, 0);
+	if (!trans_pcie->hw_base) {
+		dev_printk(KERN_ERR, &pdev->dev, "pci_iomap failed");
+		err = -ENODEV;
+		goto out_pci_release_regions;
+	}
+
+	/* TODO: remove this hack */
+	iwl_pci_bus->hw_base = trans_pcie->hw_base;
+
+	dev_printk(KERN_INFO, &pdev->dev,
+		"pci_resource_len = 0x%08llx\n",
+		(unsigned long long) pci_resource_len(pdev, 0));
+	dev_printk(KERN_INFO, &pdev->dev,
+		"pci_resource_base = %p\n", trans_pcie->hw_base);
+
+	dev_printk(KERN_INFO, &pdev->dev,
+		"HW Revision ID = 0x%X\n", pdev->revision);
+
+	/* We disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state */
+	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
+
+	err = pci_enable_msi(pdev);
+	if (err)
+		dev_printk(KERN_ERR, &pdev->dev,
+			"pci_enable_msi failed(0X%x)", err);
+
+	trans->dev = &pdev->dev;
+	trans->irq = pdev->irq;
+	trans_pcie->pci_dev = pdev;
+
+	/* TODO: Move this away, not needed if not MSI */
+	/* enable rfkill interrupt: hw bug w/a */
+	pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
+	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
+		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
+		pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
+	}
+
+	return trans;
+
+out_pci_release_regions:
+	pci_release_regions(pdev);
+out_pci_disable_device:
+	pci_disable_device(pdev);
+out_no_pci:
+	kfree(trans);
+	return NULL;
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index b1a7af2..9a80761 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -228,6 +228,8 @@ struct iwl_calib_result {
  * @ops - pointer to iwl_trans_ops
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  * @hcmd_lock: protects HCMD
+ * @dev - pointer to struct device * that represents the device
+ * @irq - the irq number for the device
  * @ucode_write_complete: indicates that the ucode has been copied.
  * @ucode_rt: run time ucode image
  * @ucode_init: init ucode image
@@ -240,6 +242,9 @@ struct iwl_trans {
 	struct iwl_shared *shrd;
 	spinlock_t hcmd_lock;
 
+	struct device *dev;
+	unsigned int irq;
+
 	u8 ucode_write_complete;	/* the image write is complete */
 	struct fw_img ucode_rt;
 	struct fw_img ucode_init;
-- 
1.7.0.4

