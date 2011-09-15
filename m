Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934534Ab1IOTcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/27] iwlagn: remove drvdata support from bus layer
Date: Thu, 15 Sep 2011 11:46:49 -0700
Message-Id: <1316112414-6341-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213232_718378_AC8266C0)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the removal of the sysfs files, it is no
longer necessary to have upper layers control
the drvdata, so let the PCI driver have it for
itself completely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 +---
 drivers/net/wireless/iwlwifi/iwl-bus.h |   10 ++--------
 drivers/net/wireless/iwlwifi/iwl-pci.c |   19 ++++++++-----------
 3 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 84ba428..1d53eb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3186,9 +3186,9 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	priv = hw->priv;
 	priv->bus = bus;
 	priv->shrd = &priv->_shrd;
+	bus->shrd = priv->shrd;
 	priv->shrd->bus = bus;
 	priv->shrd->priv = priv;
-	bus_set_drv_data(priv->bus, priv->shrd);
 
 	priv->shrd->trans = trans_ops->alloc(priv->shrd);
 	if (priv->shrd->trans == NULL) {
@@ -3387,8 +3387,6 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 
 	iwl_trans_free(trans(priv));
 
-	bus_set_drv_data(priv->bus, NULL);
-
 	iwl_uninit_drv(priv);
 
 	dev_kfree_skb(priv->beacon_skb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 98535df..08b9759 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -122,7 +122,6 @@ struct iwl_bus;
  * struct iwl_bus_ops - bus specific operations
  * @get_pm_support: must returns true if the bus can go to sleep
  * @apm_config: will be called during the config of the APM
- * @set_drv_data: set the shared data pointer to the bus layer
  * @get_hw_id: prints the hw_id in the provided buffer
  * @write8: write a byte to register at offset ofs
  * @write32: write a dword to register at offset ofs
@@ -131,7 +130,6 @@ struct iwl_bus;
 struct iwl_bus_ops {
 	bool (*get_pm_support)(struct iwl_bus *bus);
 	void (*apm_config)(struct iwl_bus *bus);
-	void (*set_drv_data)(struct iwl_bus *bus, struct iwl_shared *shrd);
 	void (*get_hw_id)(struct iwl_bus *bus, char buf[], int buf_len);
 	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
 	void (*write32)(struct iwl_bus *bus, u32 ofs, u32 val);
@@ -146,6 +144,8 @@ struct iwl_bus_ops {
  * @dev - pointer to struct device * that represents the device
  * @ops - pointer to iwl_bus_ops
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
+ *	NB: for the time being this needs to be set by the upper layer since
+ *	it allocates the shared data
  * @irq - the irq number for the device
  * @reg_lock - protect hw register access
  */
@@ -172,12 +172,6 @@ static inline void bus_apm_config(struct iwl_bus *bus)
 	bus->ops->apm_config(bus);
 }
 
-static inline void bus_set_drv_data(struct iwl_bus *bus,
-				struct iwl_shared *shrd)
-{
-	bus->ops->set_drv_data(bus, shrd);
-}
-
 static inline void bus_get_hw_id(struct iwl_bus *bus, char buf[], int buf_len)
 {
 	bus->ops->get_hw_id(bus, buf, buf_len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 849b5ef..23b5f78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -134,12 +134,6 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 	}
 }
 
-static void iwl_pci_set_drv_data(struct iwl_bus *bus, struct iwl_shared *shrd)
-{
-	bus->shrd = shrd;
-	pci_set_drvdata(IWL_BUS_GET_PCI_DEV(bus), shrd);
-}
-
 static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
 			      int buf_len)
 {
@@ -168,7 +162,6 @@ static u32 iwl_pci_read32(struct iwl_bus *bus, u32 ofs)
 static const struct iwl_bus_ops bus_ops_pci = {
 	.get_pm_support = iwl_pci_is_pm_supported,
 	.apm_config = iwl_pci_apm_config,
-	.set_drv_data = iwl_pci_set_drv_data,
 	.get_hw_id = iwl_pci_get_hw_id,
 	.write8 = iwl_pci_write8,
 	.write32 = iwl_pci_write32,
@@ -393,6 +386,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_bus = IWL_BUS_GET_PCI_BUS(bus);
 	pci_bus->pci_dev = pdev;
 
+	pci_set_drvdata(pdev, bus);
+
 	/* W/A - seems to solve weird behavior. We need to remove this if we
 	 * don't want to stay in L1 all the time. This wastes a lot of power */
 	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
@@ -486,9 +481,9 @@ out_no_pci:
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_shared *shrd = pci_get_drvdata(pdev);
-	struct iwl_bus *bus = shrd->bus;
+	struct iwl_bus *bus = pci_get_drvdata(pdev);
 	struct iwl_pci_bus *pci_bus = IWL_BUS_GET_PCI_BUS(bus);
+	struct iwl_shared *shrd = bus->shrd;
 
 	iwl_remove(shrd->priv);
 
@@ -506,7 +501,8 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 static int iwl_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_shared *shrd = pci_get_drvdata(pdev);
+	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_shared *shrd = bus->shrd;
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
@@ -519,7 +515,8 @@ static int iwl_pci_suspend(struct device *device)
 static int iwl_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_shared *shrd = pci_get_drvdata(pdev);
+	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_shared *shrd = bus->shrd;
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
-- 
1.7.0.4

