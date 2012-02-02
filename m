Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab2BCAQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/28] iwlwifi: kill bus_get_hw_id
Date: Thu,  2 Feb 2012 15:09:11 -0800
Message-Id: <1328224159-18134-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011705_800183_351517FA)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Get this information from the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h        |   14 ---------
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c        |   37 +++----------------------
 drivers/net/wireless/iwlwifi/iwl-testmode.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    3 ++
 6 files changed, 10 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 6113089..30965e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -119,14 +119,6 @@ struct iwl_shared;
 struct iwl_bus;
 
 /**
- * struct iwl_bus_ops - bus specific operations
- * @get_hw_id: get hw_id in u32
- */
-struct iwl_bus_ops {
-	u32 (*get_hw_id)(struct iwl_bus *bus);
-};
-
-/**
  * struct iwl_bus - bus common data
  *
  * This data is common to all bus layer implementations.
@@ -137,7 +129,6 @@ struct iwl_bus_ops {
  *	it allocates the shared data
  */
 struct iwl_bus {
-	const struct iwl_bus_ops *ops;
 	struct iwl_shared *shrd;
 
 	/* pointer to bus specific struct */
@@ -145,11 +136,6 @@ struct iwl_bus {
 	char bus_specific[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
-static inline u32 bus_get_hw_id(struct iwl_bus *bus)
-{
-	return bus->ops->get_hw_id(bus);
-}
-
 /*****************************************************
 * Bus layer registration functions
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index b911837..78bc1e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -234,7 +234,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&priv->bands[IEEE80211_BAND_5GHZ];
 
-	hw->wiphy->hw_version = bus_get_hw_id(bus(priv));
+	hw->wiphy->hw_version = trans(priv)->hw_id;
 
 	iwl_leds_init(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 1586476..3e2fce4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -71,33 +71,6 @@
 #include "iwl-csr.h"
 #include "iwl-cfg.h"
 
-/* PCI registers */
-#define PCI_CFG_RETRY_TIMEOUT	0x041
-#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
-#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
-
-struct iwl_pci_bus {
-	/* basic pci-network driver stuff */
-	struct pci_dev *pci_dev;
-};
-
-#define IWL_BUS_GET_PCI_BUS(_iwl_bus) \
-			((struct iwl_pci_bus *) ((_iwl_bus)->bus_specific))
-
-#define IWL_BUS_GET_PCI_DEV(_iwl_bus) \
-			((IWL_BUS_GET_PCI_BUS(_iwl_bus))->pci_dev)
-
-static u32 iwl_pci_get_hw_id(struct iwl_bus *bus)
-{
-	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
-
-	return (pci_dev->device << 16) + pci_dev->subsystem_device;
-}
-
-static const struct iwl_bus_ops bus_ops_pci = {
-	.get_hw_id = iwl_pci_get_hw_id,
-};
-
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
@@ -283,14 +256,16 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 };
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 
+/* PCI registers */
+#define PCI_CFG_RETRY_TIMEOUT	0x041
+
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	struct iwl_bus *bus;
-	struct iwl_pci_bus *pci_bus;
 	int err;
 
-	bus = kzalloc(sizeof(*bus) + sizeof(*pci_bus), GFP_KERNEL);
+	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
 	if (!bus) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "Couldn't allocate iwl_pci_bus");
@@ -306,13 +281,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	bus->shrd->bus = bus;
-	pci_bus = IWL_BUS_GET_PCI_BUS(bus);
-	pci_bus->pci_dev = pdev;
 
 	pci_set_drvdata(pdev, bus);
 
-	bus->ops = &bus_ops_pci;
-
 #ifdef CONFIG_IWLWIFI_IDI
 	trans(bus) = iwl_trans_idi_alloc(bus->shrd, pdev, ent);
 	if (trans(bus) == NULL) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 922d841..7c17b9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -536,7 +536,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
-		devid = bus_get_hw_id(bus(priv));
+		devid = trans(priv)->hw_id;
 		IWL_INFO(priv, "hw version: 0x%x\n", devid);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 73ff68a..4b711b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -2317,6 +2317,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 	trans->dev = &pdev->dev;
 	trans->irq = pdev->irq;
 	trans_pcie->pci_dev = pdev;
+	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
 	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
 		 "PCI ID: 0x%04X:0x%04X", pdev->device, pdev->subsystem_device);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 593102d..0359d71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -234,6 +234,8 @@ struct iwl_calib_result {
  * @reg_lock - protect hw register access
  * @dev - pointer to struct device * that represents the device
  * @irq - the irq number for the device
+ * @hw_id: a u32 with the ID of the device / subdevice.
+  *	Set during transport alloaction.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @ucode_write_complete: indicates that the ucode has been copied.
  * @ucode_rt: run time ucode image
@@ -251,6 +253,7 @@ struct iwl_trans {
 
 	struct device *dev;
 	unsigned int irq;
+	u32 hw_id;
 	char hw_id_str[52];
 
 	u8 ucode_write_complete;	/* the image write is complete */
-- 
1.7.0.4

