Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40864 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752795AbcEJUbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:31:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:14 +0300
Message-Id: <1462910797-20303-18-git-send-email-luca@coelho.fi> (sfid-20160510_223104_776754_6E61B0CF)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 18/41] iwlwifi: allow combining different phy images with mac images
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Currently there is one to one function between device id to it's ucode.
The new generation devices allows to combine different phy and mac images.
Now we have two different ucode images with the same device id.
Read RF ID to identify phy image and overwrite it if needed.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   | 29 ++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  3 +++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h    | 15 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h  |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 10 +++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  2 ++
 6 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 86a5599..a0eeb53 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -72,9 +72,15 @@
 #define IWL9000_SMEM_OFFSET		0x400000
 #define IWL9000_SMEM_LEN		0x68000
 
-#define  IWL9000_FW_PRE "iwlwifi-9000-"
+#define  IWL9000_FW_PRE "iwlwifi-9000-pu-a0-lc-a0-"
+#define  IWL9260_FW_PRE "iwlwifi-9260-th-a0-jf-a0-"
+#define  IWL9260LC_FW_PRE "iwlwifi-9260-th-a0-lc-a0-"
 #define IWL9000_MODULE_FIRMWARE(api) \
 	IWL9000_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL9260_MODULE_FIRMWARE(api) \
+	IWL9260_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL9260LC_MODULE_FIRMWARE(api) \
+	IWL9260LC_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_9000		10
 
@@ -138,11 +144,26 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.apmg_not_supported = true,					\
 	.mq_rx_supported = true,					\
 	.vht_mu_mimo_supported = true,					\
-	.mac_addr_from_csr = true
+	.mac_addr_from_csr = true,					\
+	.rf_id = true
 
 const struct iwl_cfg iwl9260_2ac_cfg = {
 		.name = "Intel(R) Dual Band Wireless AC 9260",
-		.fw_name_pre = IWL9000_FW_PRE,
+		.fw_name_pre = IWL9260_FW_PRE,
+		IWL_DEVICE_9000,
+		.ht_params = &iwl9000_ht_params,
+		.nvm_ver = IWL9000_NVM_VERSION,
+		.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
+/*
+ * TODO the struct below is for internal testing only this should be
+ * removed by EO 2016~
+ */
+const struct iwl_cfg iwl9260lc_2ac_cfg = {
+		.name = "Intel(R) Dual Band Wireless AC 9260",
+		.fw_name_pre = IWL9260LC_FW_PRE,
 		IWL_DEVICE_9000,
 		.ht_params = &iwl9000_ht_params,
 		.nvm_ver = IWL9000_NVM_VERSION,
@@ -161,3 +182,5 @@ const struct iwl_cfg iwl5165_2ac_cfg = {
 };
 
 MODULE_FIRMWARE(IWL9000_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL9260_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL9260LC_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 2e71e88..6eef5dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -314,6 +314,7 @@ struct iwl_pwr_tx_backoff {
  * @smem_len: the length of SMEM
  * @mq_rx_supported: multi-queue rx support
  * @vht_mu_mimo_supported: VHT MU-MIMO support
+ * @rf_id: need to read rf_id to determine the firmware image
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -367,6 +368,7 @@ struct iwl_cfg {
 	bool apmg_not_supported;
 	bool mq_rx_supported;
 	bool vht_mu_mimo_supported;
+	bool rf_id;
 };
 
 /*
@@ -440,6 +442,7 @@ extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl8265_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl9260_2ac_cfg;
+extern const struct iwl_cfg iwl9260lc_2ac_cfg;
 extern const struct iwl_cfg iwl5165_2ac_cfg;
 #endif /* CONFIG_IWLMVM */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index b978f6c..b5291344 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -108,6 +108,17 @@
 #define CSR_HW_REV              (CSR_BASE+0x028)
 
 /*
+ * RF ID revision info
+ * Bit fields:
+ * 31:24: Reserved (set to 0x0)
+ * 23:12: Type
+ * 11:8:  Step (A - 0x0, B - 0x1, etc)
+ * 7:4:   Dash
+ * 3:0:   Flavor
+ */
+#define CSR_HW_RF_ID		(CSR_BASE+0x09c)
+
+/*
  * EEPROM and OTP (one-time-programmable) memory reads
  *
  * NOTE:  Device must be awake, initialized via apm_ops.init(),
@@ -333,6 +344,10 @@ enum {
 #define CSR_HW_REV_TYPE_7265D		(0x0000210)
 #define CSR_HW_REV_TYPE_NONE		(0x00001F0)
 
+/* RF_ID value */
+#define CSR_HW_RF_ID_TYPE_JF		(0x00105000)
+#define CSR_HW_RF_ID_TYPE_LC		(0x00101000)
+
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
 #define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index fa4ab4b..8193d36 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -753,6 +753,7 @@ enum iwl_plat_pm_mode {
  * @dev - pointer to struct device * that represents the device
  * @max_skb_frags: maximum number of fragments an SKB can have when transmitted.
  *	0 indicates that frag SKBs (NETIF_F_SG) aren't supported.
+ * @hw_rf_id a u32 with the device RF ID
  * @hw_id: a u32 with the ID of the device / sub-device.
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
@@ -797,6 +798,7 @@ struct iwl_trans {
 	struct device *dev;
 	u32 max_skb_frags;
 	u32 hw_rev;
+	u32 hw_rf_id;
 	u32 hw_id;
 	char hw_id_str[52];
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 8f139d0..a588b05 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -596,6 +596,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	const struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	const struct iwl_cfg *cfg_7265d __maybe_unused = NULL;
+	const struct iwl_cfg *cfg_9260lc __maybe_unused = NULL;
 	struct iwl_trans *iwl_trans;
 	struct iwl_trans_pcie *trans_pcie;
 	int ret;
@@ -623,6 +624,15 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		cfg = cfg_7265d;
 		iwl_trans->cfg = cfg_7265d;
 	}
+
+	if (iwl_trans->cfg->rf_id) {
+		if (cfg == &iwl9260_2ac_cfg)
+			cfg_9260lc = &iwl9260lc_2ac_cfg;
+		if (cfg_9260lc && iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_LC) {
+			cfg = cfg_9260lc;
+			iwl_trans->cfg = cfg_9260lc;
+		}
+	}
 #endif
 
 	pci_set_drvdata(pdev, iwl_trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 37e134d..eb9bdf0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2907,6 +2907,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	}
 
+	trans->hw_rf_id = iwl_read32(trans, CSR_HW_RF_ID);
+
 	iwl_pcie_set_interrupt_capa(pdev, trans);
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
 	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
-- 
2.8.1

