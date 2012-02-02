Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25779 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab2BCAQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/28] iwlwifi: the read / write register ops move to transport
Date: Thu,  2 Feb 2012 15:08:58 -0800
Message-Id: <1328224159-18134-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011749_878448_DD2FC2D8)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Most of the accesses to the registers are done from the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h        |   21 --------------
 drivers/net/wireless/iwlwifi/iwl-io.h         |   11 +++++--
 drivers/net/wireless/iwlwifi/iwl-pci.c        |   22 ---------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   37 +++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   21 ++++++++++++++
 5 files changed, 48 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 37ed7b6..981f7b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -124,18 +124,12 @@ struct iwl_bus;
  * @apm_config: will be called during the config of the APM
  * @get_hw_id_string: prints the hw_id in the provided buffer
  * @get_hw_id: get hw_id in u32
- * @write8: write a byte to register at offset ofs
- * @write32: write a dword to register at offset ofs
- * @wread32: read a dword at register at offset ofs
  */
 struct iwl_bus_ops {
 	bool (*get_pm_support)(struct iwl_bus *bus);
 	void (*apm_config)(struct iwl_bus *bus);
 	void (*get_hw_id_string)(struct iwl_bus *bus, char buf[], int buf_len);
 	u32 (*get_hw_id)(struct iwl_bus *bus);
-	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
-	void (*write32)(struct iwl_bus *bus, u32 ofs, u32 val);
-	u32 (*read32)(struct iwl_bus *bus, u32 ofs);
 };
 
 /**
@@ -183,21 +177,6 @@ static inline u32 bus_get_hw_id(struct iwl_bus *bus)
 	return bus->ops->get_hw_id(bus);
 }
 
-static inline void bus_write8(struct iwl_bus *bus, u32 ofs, u8 val)
-{
-	bus->ops->write8(bus, ofs, val);
-}
-
-static inline void bus_write32(struct iwl_bus *bus, u32 ofs, u32 val)
-{
-	bus->ops->write32(bus, ofs, val);
-}
-
-static inline u32 bus_read32(struct iwl_bus *bus, u32 ofs)
-{
-	return bus->ops->read32(bus, ofs);
-}
-
 /*****************************************************
 * Bus layer registration functions
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 427d065..b8e00cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -31,23 +31,28 @@
 
 #include "iwl-devtrace.h"
 #include "iwl-shared.h"
+/* TODO: remove when not needed any more */
 #include "iwl-bus.h"
+#include "iwl-trans.h"
 
 static inline void iwl_write8(struct iwl_bus *bus, u32 ofs, u8 val)
 {
+	/* TODO: get trans instead of bus */
 	trace_iwlwifi_dev_iowrite8(priv(bus), ofs, val);
-	bus_write8(bus, ofs, val);
+	iwl_trans_write8(trans(bus), ofs, val);
 }
 
 static inline void iwl_write32(struct iwl_bus *bus, u32 ofs, u32 val)
 {
+	/* TODO: get trans instead of bus */
 	trace_iwlwifi_dev_iowrite32(priv(bus), ofs, val);
-	bus_write32(bus, ofs, val);
+	iwl_trans_write32(trans(bus), ofs, val);
 }
 
 static inline u32 iwl_read32(struct iwl_bus *bus, u32 ofs)
 {
-	u32 val = bus_read32(bus, ofs);
+	/* TODO: get trans instead of bus */
+	u32 val = iwl_trans_read32(trans(bus), ofs);
 	trace_iwlwifi_dev_ioread32(priv(bus), ofs, val);
 	return val;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 631b67c..ab46233 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -79,9 +79,6 @@
 struct iwl_pci_bus {
 	/* basic pci-network driver stuff */
 	struct pci_dev *pci_dev;
-
-	/* pci hardware address support */
-	void __iomem *hw_base;
 };
 
 #define IWL_BUS_GET_PCI_BUS(_iwl_bus) \
@@ -151,30 +148,11 @@ static u32 iwl_pci_get_hw_id(struct iwl_bus *bus)
 	return (pci_dev->device << 16) + pci_dev->subsystem_device;
 }
 
-static void iwl_pci_write8(struct iwl_bus *bus, u32 ofs, u8 val)
-{
-	iowrite8(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
-}
-
-static void iwl_pci_write32(struct iwl_bus *bus, u32 ofs, u32 val)
-{
-	iowrite32(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
-}
-
-static u32 iwl_pci_read32(struct iwl_bus *bus, u32 ofs)
-{
-	u32 val = ioread32(IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
-	return val;
-}
-
 static const struct iwl_bus_ops bus_ops_pci = {
 	.get_pm_support = iwl_pci_is_pm_supported,
 	.apm_config = iwl_pci_apm_config,
 	.get_hw_id_string = iwl_pci_get_hw_id_string,
 	.get_hw_id = iwl_pci_get_hw_id,
-	.write8 = iwl_pci_write8,
-	.write32 = iwl_pci_write32,
-	.read32 = iwl_pci_read32,
 };
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 5d0cfe0..80f5318 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1299,6 +1299,22 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 	return 0;
 }
 
+static void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val)
+{
+	iowrite8(val, IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
+}
+
+static void iwl_trans_pcie_write32(struct iwl_trans *trans, u32 ofs, u32 val)
+{
+	iowrite32(val, IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
+}
+
+static u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs)
+{
+	u32 val = ioread32(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
+	return val;
+}
+
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie =
@@ -1935,22 +1951,11 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.suspend = iwl_trans_pcie_suspend,
 	.resume = iwl_trans_pcie_resume,
 #endif
+	.write8 = iwl_trans_pcie_write8,
+	.write32 = iwl_trans_pcie_write32,
+	.read32 = iwl_trans_pcie_read32,
 };
 
-/* TODO: remove this hack - will be possible when all the io{write/read} ops
- * will be done through the transport
- */
-struct iwl_pci_bus {
-	/* basic pci-network driver stuff */
-	struct pci_dev *pci_dev;
-
-	/* pci hardware address support */
-	void __iomem *hw_base;
-};
-
-#define IWL_BUS_GET_PCI_BUS(_iwl_bus) \
-			((struct iwl_pci_bus *) ((_iwl_bus)->bus_specific))
-
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
 
@@ -1958,7 +1963,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 				       struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
-	struct iwl_pci_bus *iwl_pci_bus = IWL_BUS_GET_PCI_BUS(shrd->bus);
 	struct iwl_trans_pcie *trans_pcie;
 	struct iwl_trans *trans;
 	u16 pci_cmd;
@@ -2018,9 +2022,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 		goto out_pci_release_regions;
 	}
 
-	/* TODO: remove this hack */
-	iwl_pci_bus->hw_base = trans_pcie->hw_base;
-
 	dev_printk(KERN_INFO, &pdev->dev,
 		"pci_resource_len = 0x%08llx\n",
 		(unsigned long long) pci_resource_len(pdev, 0));
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 9a80761..0a3727d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -158,6 +158,9 @@ struct iwl_host_cmd {
  *	automatically deleted.
  * @suspend: stop the device unless WoWLAN is configured
  * @resume: resume activity of the device
+ * @write8: write a u8 to a register at offset ofs from the BAR
+ * @write32: write a u32 to a register at offset ofs from the BAR
+ * @read32: read a u32 register at offset ofs from the BAR
  */
 struct iwl_trans_ops {
 
@@ -201,6 +204,9 @@ struct iwl_trans_ops {
 	int (*suspend)(struct iwl_trans *trans);
 	int (*resume)(struct iwl_trans *trans);
 #endif
+	void (*write8)(struct iwl_trans *trans, u32 ofs, u8 val);
+	void (*write32)(struct iwl_trans *trans, u32 ofs, u32 val);
+	u32 (*read32)(struct iwl_trans *trans, u32 ofs);
 };
 
 /* one for each uCode image (inst/data, boot/init/runtime) */
@@ -382,6 +388,21 @@ static inline int iwl_trans_resume(struct iwl_trans *trans)
 }
 #endif
 
+static inline void iwl_trans_write8(struct iwl_trans *trans, u32 ofs, u8 val)
+{
+	trans->ops->write8(trans, ofs, val);
+}
+
+static inline void iwl_trans_write32(struct iwl_trans *trans, u32 ofs, u32 val)
+{
+	trans->ops->write32(trans, ofs, val);
+}
+
+static inline u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs)
+{
+	return trans->ops->read32(trans, ofs);
+}
+
 /*****************************************************
 * Utils functions
 ******************************************************/
-- 
1.7.0.4

