Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab2BCAQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:57 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/28] iwlwifi: kill bus_apm_config
Date: Thu,  2 Feb 2012 15:09:08 -0800
Message-Id: <1328224159-18134-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011730_198758_221434A8)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This handler was called from the transport layer only. Merge it
to the transport's apm_init.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h        |    7 ---
 drivers/net/wireless/iwlwifi/iwl-pci.c        |   29 --------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   50 +++++++++++++++++++++++--
 3 files changed, 46 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 2065c5b..d385f69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -121,13 +121,11 @@ struct iwl_bus;
 /**
  * struct iwl_bus_ops - bus specific operations
  * @get_pm_support: must returns true if the bus can go to sleep
- * @apm_config: will be called during the config of the APM
  * @get_hw_id_string: prints the hw_id in the provided buffer
  * @get_hw_id: get hw_id in u32
  */
 struct iwl_bus_ops {
 	bool (*get_pm_support)(struct iwl_bus *bus);
-	void (*apm_config)(struct iwl_bus *bus);
 	void (*get_hw_id_string)(struct iwl_bus *bus, char buf[], int buf_len);
 	u32 (*get_hw_id)(struct iwl_bus *bus);
 };
@@ -156,11 +154,6 @@ static inline bool bus_get_pm_support(struct iwl_bus *bus)
 	return bus->ops->get_pm_support(bus);
 }
 
-static inline void bus_apm_config(struct iwl_bus *bus)
-{
-	bus->ops->apm_config(bus);
-}
-
 static inline void bus_get_hw_id_string(struct iwl_bus *bus, char buf[],
 		int buf_len)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 6451739..353022d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -106,34 +106,6 @@ static bool iwl_pci_is_pm_supported(struct iwl_bus *bus)
 	return !(lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN);
 }
 
-static void iwl_pci_apm_config(struct iwl_bus *bus)
-{
-	/*
-	 * HW bug W/A for instability in PCIe bus L0S->L1 transition.
-	 * Check if BIOS (or OS) enabled L1-ASPM on this device.
-	 * If so (likely), disable L0S, so device moves directly L0->L1;
-	 *    costs negligible amount of power savings.
-	 * If not (unlikely), enable L0S, so there is at least some
-	 *    power savings, even without L1.
-	 */
-	u16 lctl = iwl_pciexp_link_ctrl(bus);
-
-	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
-				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
-		/* L1-ASPM enabled; disable(!) L0S */
-		iwl_set_bit(trans(bus), CSR_GIO_REG,
-				CSR_GIO_REG_VAL_L0S_ENABLED);
-		dev_printk(KERN_INFO, trans(bus)->dev,
-			   "L1 Enabled; Disabling L0S\n");
-	} else {
-		/* L1-ASPM disabled; enable(!) L0S */
-		iwl_clear_bit(trans(bus), CSR_GIO_REG,
-				CSR_GIO_REG_VAL_L0S_ENABLED);
-		dev_printk(KERN_INFO, trans(bus)->dev,
-			   "L1 Disabled; Enabling L0S\n");
-	}
-}
-
 static void iwl_pci_get_hw_id_string(struct iwl_bus *bus, char buf[],
 			      int buf_len)
 {
@@ -152,7 +124,6 @@ static u32 iwl_pci_get_hw_id(struct iwl_bus *bus)
 
 static const struct iwl_bus_ops bus_ops_pci = {
 	.get_pm_support = iwl_pci_is_pm_supported,
-	.apm_config = iwl_pci_apm_config,
 	.get_hw_id_string = iwl_pci_get_hw_id_string,
 	.get_hw_id = iwl_pci_get_hw_id,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 1030a25..c9fe888 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -633,6 +633,51 @@ static void iwl_set_pwr_vmain(struct iwl_trans *trans)
 			       ~APMG_PS_CTRL_MSK_PWR_SRC);
 }
 
+/* PCI registers */
+#define PCI_CFG_RETRY_TIMEOUT	0x041
+#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
+#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
+
+static u16 iwl_pciexp_link_ctrl(struct iwl_trans *trans)
+{
+	int pos;
+	u16 pci_lnk_ctl;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	struct pci_dev *pci_dev = trans_pcie->pci_dev;
+
+	pos = pci_pcie_cap(pci_dev);
+	pci_read_config_word(pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
+	return pci_lnk_ctl;
+}
+
+static void iwl_apm_config(struct iwl_trans *trans)
+{
+	/*
+	 * HW bug W/A for instability in PCIe bus L0S->L1 transition.
+	 * Check if BIOS (or OS) enabled L1-ASPM on this device.
+	 * If so (likely), disable L0S, so device moves directly L0->L1;
+	 *    costs negligible amount of power savings.
+	 * If not (unlikely), enable L0S, so there is at least some
+	 *    power savings, even without L1.
+	 */
+	u16 lctl = iwl_pciexp_link_ctrl(trans);
+
+	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
+				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
+		/* L1-ASPM enabled; disable(!) L0S */
+		iwl_set_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
+		dev_printk(KERN_INFO, trans->dev,
+			   "L1 Enabled; Disabling L0S\n");
+	} else {
+		/* L1-ASPM disabled; enable(!) L0S */
+		iwl_clear_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
+		dev_printk(KERN_INFO, trans->dev,
+			   "L1 Disabled; Enabling L0S\n");
+	}
+}
+
 /*
  * Start up NIC's basic functionality after it has been reset
  * (e.g. after platform boot, or shutdown via iwl_apm_stop())
@@ -669,7 +714,7 @@ static int iwl_apm_init(struct iwl_trans *trans)
 	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
 				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
 
-	bus_apm_config(bus(trans));
+	iwl_apm_config(trans);
 
 	/* Configure analog phase-lock-loop before activating to D0A */
 	if (cfg(trans)->base_params->pll_cfg_val)
@@ -2187,9 +2232,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.read32 = iwl_trans_pcie_read32,
 };
 
-/* PCI registers */
-#define PCI_CFG_RETRY_TIMEOUT	0x041
-
 struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 				       struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
-- 
1.7.0.4

