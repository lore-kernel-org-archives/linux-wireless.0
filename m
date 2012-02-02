Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab2BCAQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/28] iwlwifi: allocate the transport from the bus layer
Date: Thu,  2 Feb 2012 15:08:56 -0800
Message-Id: <1328224159-18134-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011659_835832_33F497E0)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Change the way we alloc the transport on the way.
Since the transport is allocated from a bus specific area, we can
give the bus specific parameters (i.e. pci_dev for PCI) to the
transport. This will be useful when the bus layer will be killed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   16 +++-------------
 drivers/net/wireless/iwlwifi/iwl-pci.c        |   17 ++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   24 ++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   21 +++++++++++++++------
 4 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b42be30..1a4ba9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1783,12 +1783,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	priv->shrd = bus->shrd;
 	priv->shrd->priv = priv;
 
-	priv->shrd->trans = trans_ops->alloc(priv->shrd);
-	if (priv->shrd->trans == NULL) {
-		err = -ENOMEM;
-		goto out_free_traffic_mem;
-	}
-
 	/* At this point both hw and priv are allocated. */
 
 	SET_IEEE80211_DEV(hw, bus(priv)->dev);
@@ -1835,12 +1829,12 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 
 	err = iwl_trans_request_irq(trans(priv));
 	if (err)
-		goto out_free_trans;
+		goto out_free_traffic_mem;
 
 	if (iwl_trans_prepare_card_hw(trans(priv))) {
 		err = -EIO;
 		IWL_WARN(priv, "Failed, HW not ready\n");
-		goto out_free_trans;
+		goto out_free_traffic_mem;
 	}
 
 	/*****************
@@ -1854,7 +1848,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	iwl_apm_stop(priv);
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
-		goto out_free_trans;
+		goto out_free_traffic_mem;
 	}
 	err = iwl_eeprom_check_version(priv);
 	if (err)
@@ -1935,8 +1929,6 @@ out_destroy_workqueue:
 	iwl_uninit_drv(priv);
 out_free_eeprom:
 	iwl_eeprom_free(priv->shrd);
-out_free_trans:
-	iwl_trans_free(trans(priv));
 out_free_traffic_mem:
 	iwl_free_traffic_mem(priv);
 	ieee80211_free_hw(priv->hw);
@@ -1980,8 +1972,6 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	priv->shrd->workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
-	iwl_trans_free(trans(priv));
-
 	iwl_uninit_drv(priv);
 
 	dev_kfree_skb(priv->beacon_skb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index a3ca0a7..c0d62e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -463,14 +463,28 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bus->ops = &bus_ops_pci;
 
 #ifdef CONFIG_IWLWIFI_IDI
+	trans(bus) = iwl_trans_idi_alloc(bus->shrd, pdev, ent);
+	if (trans(bus) == NULL) {
+		err = -ENOMEM;
+		goto out_disable_msi;
+	}
+
 	err = iwl_probe(bus, &trans_ops_idi, cfg);
 #else
+	trans(bus) = iwl_trans_pcie_alloc(bus->shrd, pdev, ent);
+	if (trans(bus) == NULL) {
+		err = -ENOMEM;
+		goto out_disable_msi;
+	}
+
 	err = iwl_probe(bus, &trans_ops_pcie, cfg);
 #endif
 	if (err)
-		goto out_disable_msi;
+		goto out_free_trans;
 	return 0;
 
+out_free_trans:
+	iwl_trans_free(trans(bus));
 out_disable_msi:
 	pci_disable_msi(pdev);
 	pci_iounmap(pdev, pci_bus->hw_base);
@@ -493,6 +507,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	struct iwl_shared *shrd = bus->shrd;
 
 	iwl_remove(shrd->priv);
+	iwl_trans_free(shrd->trans);
 
 	pci_disable_msi(pci_dev);
 	pci_iounmap(pci_dev, pci_bus->hw_base);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 0b4280c..f0d8ccc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1376,19 +1376,24 @@ static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
 
 const struct iwl_trans_ops trans_ops_pcie;
 
-static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
+struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
+				       struct pci_dev *pdev,
+				       const struct pci_device_id *ent)
 {
+	struct iwl_trans_pcie *trans_pcie;
 	struct iwl_trans *iwl_trans = kzalloc(sizeof(struct iwl_trans) +
 					      sizeof(struct iwl_trans_pcie),
 					      GFP_KERNEL);
-	if (iwl_trans) {
-		struct iwl_trans_pcie *trans_pcie =
-			IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
-		iwl_trans->ops = &trans_ops_pcie;
-		iwl_trans->shrd = shrd;
-		trans_pcie->trans = iwl_trans;
-		spin_lock_init(&iwl_trans->hcmd_lock);
-	}
+
+	if (WARN_ON(!iwl_trans))
+		return NULL;
+
+	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
+
+	iwl_trans->ops = &trans_ops_pcie;
+	iwl_trans->shrd = shrd;
+	trans_pcie->trans = iwl_trans;
+	spin_lock_init(&iwl_trans->hcmd_lock);
 
 	return iwl_trans;
 }
@@ -1912,7 +1917,6 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 #endif /*CONFIG_IWLWIFI_DEBUGFS */
 
 const struct iwl_trans_ops trans_ops_pcie = {
-	.alloc = iwl_trans_pcie_alloc,
 	.request_irq = iwl_trans_pcie_request_irq,
 	.fw_alive = iwl_trans_pcie_fw_alive,
 	.start_device = iwl_trans_pcie_start_device,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 2a6649c..b1a7af2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -133,7 +133,6 @@ struct iwl_host_cmd {
 
 /**
  * struct iwl_trans_ops - transport specific operations
- * @alloc: allocates the meta data (not the queues themselves)
  * @request_irq: requests IRQ - will be called before the FW load in probe flow
  * @start_device: allocates and inits all the resources for the transport
  *                layer.
@@ -162,7 +161,6 @@ struct iwl_host_cmd {
  */
 struct iwl_trans_ops {
 
-	struct iwl_trans *(*alloc)(struct iwl_shared *shrd);
 	int (*request_irq)(struct iwl_trans *iwl_trans);
 	int (*start_device)(struct iwl_trans *trans);
 	void (*fw_alive)(struct iwl_trans *trans);
@@ -380,11 +378,8 @@ static inline int iwl_trans_resume(struct iwl_trans *trans)
 #endif
 
 /*****************************************************
-* Transport layers implementations
+* Utils functions
 ******************************************************/
-extern const struct iwl_trans_ops trans_ops_pcie;
-extern const struct iwl_trans_ops trans_ops_idi;
-
 int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
 		      const void *data, size_t len);
 void iwl_dealloc_ucode(struct iwl_trans *trans);
@@ -394,4 +389,18 @@ int iwl_calib_set(struct iwl_trans *trans,
 		  const struct iwl_calib_hdr *cmd, int len);
 void iwl_calib_free_results(struct iwl_trans *trans);
 
+/*****************************************************
+* Transport layers implementations + their allocation function
+******************************************************/
+struct pci_dev;
+struct pci_device_id;
+extern const struct iwl_trans_ops trans_ops_pcie;
+struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
+				       struct pci_dev *pdev,
+				       const struct pci_device_id *ent);
+
+extern const struct iwl_trans_ops trans_ops_idi;
+struct iwl_trans *iwl_trans_idi_alloc(struct iwl_shared *shrd,
+				      void *pdev_void,
+				      const void *ent_void);
 #endif /* __iwl_trans_h__ */
-- 
1.7.0.4

