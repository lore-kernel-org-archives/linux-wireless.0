Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab2BCAQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:57 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/28] iwlwifi: kill bus_is_pm_supported
Date: Thu,  2 Feb 2012 15:09:09 -0800
Message-Id: <1328224159-18134-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011735_031287_E06DC9DE)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Get this information from the transport layer which is now in charge
of the APM too.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h        |    7 -------
 drivers/net/wireless/iwlwifi/iwl-pci.c        |   20 --------------------
 drivers/net/wireless/iwlwifi/iwl-power.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    2 ++
 5 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index d385f69..2b0b48e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -120,12 +120,10 @@ struct iwl_bus;
 
 /**
  * struct iwl_bus_ops - bus specific operations
- * @get_pm_support: must returns true if the bus can go to sleep
  * @get_hw_id_string: prints the hw_id in the provided buffer
  * @get_hw_id: get hw_id in u32
  */
 struct iwl_bus_ops {
-	bool (*get_pm_support)(struct iwl_bus *bus);
 	void (*get_hw_id_string)(struct iwl_bus *bus, char buf[], int buf_len);
 	u32 (*get_hw_id)(struct iwl_bus *bus);
 };
@@ -149,11 +147,6 @@ struct iwl_bus {
 	char bus_specific[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
-static inline bool bus_get_pm_support(struct iwl_bus *bus)
-{
-	return bus->ops->get_pm_support(bus);
-}
-
 static inline void bus_get_hw_id_string(struct iwl_bus *bus, char buf[],
 		int buf_len)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 353022d..0c16efe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -87,25 +87,6 @@ struct iwl_pci_bus {
 #define IWL_BUS_GET_PCI_DEV(_iwl_bus) \
 			((IWL_BUS_GET_PCI_BUS(_iwl_bus))->pci_dev)
 
-static u16 iwl_pciexp_link_ctrl(struct iwl_bus *bus)
-{
-	int pos;
-	u16 pci_lnk_ctl;
-
-	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
-
-	pos = pci_pcie_cap(pci_dev);
-	pci_read_config_word(pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
-	return pci_lnk_ctl;
-}
-
-static bool iwl_pci_is_pm_supported(struct iwl_bus *bus)
-{
-	u16 lctl = iwl_pciexp_link_ctrl(bus);
-
-	return !(lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN);
-}
-
 static void iwl_pci_get_hw_id_string(struct iwl_bus *bus, char buf[],
 			      int buf_len)
 {
@@ -123,7 +104,6 @@ static u32 iwl_pci_get_hw_id(struct iwl_bus *bus)
 }
 
 static const struct iwl_bus_ops bus_ops_pci = {
-	.get_pm_support = iwl_pci_is_pm_supported,
 	.get_hw_id_string = iwl_pci_get_hw_id_string,
 	.get_hw_id = iwl_pci_get_hw_id,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index c7394ef..fd008c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -436,7 +436,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
-	priv->power_data.bus_pm = bus_get_pm_support(bus(priv));
+	priv->power_data.bus_pm = trans(priv)->pm_support;
 
 	priv->power_data.debug_sleep_level_override = -1;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index c9fe888..8ebb5a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -676,6 +676,7 @@ static void iwl_apm_config(struct iwl_trans *trans)
 		dev_printk(KERN_INFO, trans->dev,
 			   "L1 Disabled; Enabling L0S\n");
 	}
+	trans->pm_support = !(lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 4d1ae65..7f6963f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -239,6 +239,7 @@ struct iwl_calib_result {
  * @ucode_init: init ucode image
  * @ucode_wowlan: wake on wireless ucode image (optional)
  * @nvm_device_type: indicates OTP or eeprom
+ * @pm_support: set to true in start_hw if link pm is supported
  * @calib_results: list head for init calibration results
  */
 struct iwl_trans {
@@ -257,6 +258,7 @@ struct iwl_trans {
 
 	/* eeprom related variables */
 	int    nvm_device_type;
+	bool pm_support;
 
 	/* init calibration results */
 	struct list_head calib_results;
-- 
1.7.0.4

