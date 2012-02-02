Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7687 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab2BCAQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/28] iwlwifi: kill bus_get_hw_id_string
Date: Thu,  2 Feb 2012 15:09:10 -0800
Message-Id: <1328224159-18134-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011715_340642_4FCE47CD)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Get this information from the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h        |    8 --------
 drivers/net/wireless/iwlwifi/iwl-core.c       |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-pci.c        |   10 ----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    2 ++
 5 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 2b0b48e..6113089 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -120,11 +120,9 @@ struct iwl_bus;
 
 /**
  * struct iwl_bus_ops - bus specific operations
- * @get_hw_id_string: prints the hw_id in the provided buffer
  * @get_hw_id: get hw_id in u32
  */
 struct iwl_bus_ops {
-	void (*get_hw_id_string)(struct iwl_bus *bus, char buf[], int buf_len);
 	u32 (*get_hw_id)(struct iwl_bus *bus);
 };
 
@@ -147,12 +145,6 @@ struct iwl_bus {
 	char bus_specific[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
-static inline void bus_get_hw_id_string(struct iwl_bus *bus, char buf[],
-		int buf_len)
-{
-	bus->ops->get_hw_id_string(bus, buf, buf_len);
-}
-
 static inline u32 bus_get_hw_id(struct iwl_bus *bus)
 {
 	return bus->ops->get_hw_id(bus);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 95f2c33..0677b3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -203,10 +203,9 @@ int iwl_init_geos(struct iwl_priv *priv)
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     cfg(priv)->sku & EEPROM_SKU_CAP_BAND_52GHZ) {
-		char buf[32];
-		bus_get_hw_id_string(bus(priv), buf, sizeof(buf));
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
-			"Please send your %s to maintainer.\n", buf);
+			"Please send your %s to maintainer.\n",
+			trans(priv)->hw_id_str);
 		cfg(priv)->sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 0c16efe..1586476 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -87,15 +87,6 @@ struct iwl_pci_bus {
 #define IWL_BUS_GET_PCI_DEV(_iwl_bus) \
 			((IWL_BUS_GET_PCI_BUS(_iwl_bus))->pci_dev)
 
-static void iwl_pci_get_hw_id_string(struct iwl_bus *bus, char buf[],
-			      int buf_len)
-{
-	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
-
-	snprintf(buf, buf_len, "PCI ID: 0x%04X:0x%04X", pci_dev->device,
-		 pci_dev->subsystem_device);
-}
-
 static u32 iwl_pci_get_hw_id(struct iwl_bus *bus)
 {
 	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
@@ -104,7 +95,6 @@ static u32 iwl_pci_get_hw_id(struct iwl_bus *bus)
 }
 
 static const struct iwl_bus_ops bus_ops_pci = {
-	.get_hw_id_string = iwl_pci_get_hw_id_string,
 	.get_hw_id = iwl_pci_get_hw_id,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 8ebb5a5..73ff68a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -2317,6 +2317,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 	trans->dev = &pdev->dev;
 	trans->irq = pdev->irq;
 	trans_pcie->pci_dev = pdev;
+	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
+		 "PCI ID: 0x%04X:0x%04X", pdev->device, pdev->subsystem_device);
 
 	/* TODO: Move this away, not needed if not MSI */
 	/* enable rfkill interrupt: hw bug w/a */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7f6963f..593102d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -234,6 +234,7 @@ struct iwl_calib_result {
  * @reg_lock - protect hw register access
  * @dev - pointer to struct device * that represents the device
  * @irq - the irq number for the device
+ * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @ucode_write_complete: indicates that the ucode has been copied.
  * @ucode_rt: run time ucode image
  * @ucode_init: init ucode image
@@ -250,6 +251,7 @@ struct iwl_trans {
 
 	struct device *dev;
 	unsigned int irq;
+	char hw_id_str[52];
 
 	u8 ucode_write_complete;	/* the image write is complete */
 	struct fw_img ucode_rt;
-- 
1.7.0.4

