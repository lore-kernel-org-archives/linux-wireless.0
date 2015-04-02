Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbbDBGlz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:55 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/31] iwlwifi: drop support for early versions of 8000
Date: Thu,  2 Apr 2015 09:41:02 +0300
Message-Id: <1427956879-11725-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090419_928449_6718EC21)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These early versions are no longer supported.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c      |  3 --
 drivers/net/wireless/iwlwifi/iwl-config.h    |  1 -
 drivers/net/wireless/iwlwifi/iwl-drv.c       | 10 +----
 drivers/net/wireless/iwlwifi/iwl-io.c        | 13 ++-----
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 57 ++++++++--------------------
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h |  3 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h      |  4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 10 -----
 drivers/net/wireless/iwlwifi/mvm/nvm.c       | 20 +++-------
 drivers/net/wireless/iwlwifi/mvm/ops.c       | 11 ++----
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 30 +++++++--------
 11 files changed, 46 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 9c396a4..4ef50cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -94,7 +94,6 @@
 	IWL8000_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_8000		10
-#define DEFAULT_NVM_FILE_FAMILY_8000A		"iwl_nvm_8000.bin"
 #define DEFAULT_NVM_FILE_FAMILY_8000		"iwl_nvm_8000B.bin"
 
 /* Max SDIO RX aggregation size of the ADDBA request/response */
@@ -178,7 +177,6 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
-	.default_nvm_file_8000A = DEFAULT_NVM_FILE_FAMILY_8000A,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 	.disable_dummy_notification = true,
 	.max_ht_ampdu_exponent  = MAX_HT_AMPDU_EXPONENT_8260_SDIO,
@@ -193,7 +191,6 @@ const struct iwl_cfg iwl4165_2ac_sdio_cfg = {
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
-	.default_nvm_file_8000A = DEFAULT_NVM_FILE_FAMILY_8000A,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 	.bt_shared_single_ant = true,
 	.disable_dummy_notification = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 4b190d9..aa41c77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -304,7 +304,6 @@ struct iwl_cfg {
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
 	bool no_power_up_nic_in_init;
 	const char *default_nvm_file;
-	const char *default_nvm_file_8000A;
 	unsigned int max_rx_agg_size;
 	bool disable_dummy_notification;
 	unsigned int max_tx_agg_size;
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 66ca000..885c787 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -241,16 +241,10 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	 * previous name and uses the new format.
 	 */
 	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
-		char rev_step[2] = {
-			'A' + CSR_HW_REV_STEP(drv->trans->hw_rev), 0
-		};
-
-		/* A-step doesn't have an indication */
-		if (CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_A_STEP)
-			rev_step[0] = 0;
+		char rev_step = 'A' + CSR_HW_REV_STEP(drv->trans->hw_rev);
 
 		snprintf(drv->firmware_name, sizeof(drv->firmware_name),
-			 "%s%s-%s.ucode", name_pre, rev_step, tag);
+			 "%s%c-%s.ucode", name_pre, rev_step, tag);
 	}
 
 	IWL_DEBUG_INFO(drv, "attempting to load firmware %s'%s'\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 78cac43..27c66e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -186,21 +186,14 @@ IWL_EXPORT_SYMBOL(iwl_clear_bits_prph);
 
 void iwl_force_nmi(struct iwl_trans *trans)
 {
-	/*
-	 * In HW previous to the 8000 HW family, and in the 8000 HW family
-	 * itself when the revision step==0, the DEVICE_SET_NMI_REG is used
-	 * to force an NMI. Otherwise, a different register -
-	 * DEVICE_SET_NMI_8000B_REG - is used.
-	 */
-	if ((trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) ||
-	    (CSR_HW_REV_STEP(trans->hw_rev) == SILICON_A_STEP)) {
+	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
 		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
 			       DEVICE_SET_NMI_VAL_DRV);
 		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
 			       DEVICE_SET_NMI_VAL_HW);
 	} else {
-		iwl_write_prph(trans, DEVICE_SET_NMI_8000B_REG,
-			       DEVICE_SET_NMI_8000B_VAL);
+		iwl_write_prph(trans, DEVICE_SET_NMI_8000_REG,
+			       DEVICE_SET_NMI_8000_VAL);
 		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
 			       DEVICE_SET_NMI_VAL_DRV);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 7746377..83903a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -99,14 +99,9 @@ enum family_8000_nvm_offsets {
 	/* NVM SW-Section offset (in words) definitions */
 	NVM_SW_SECTION_FAMILY_8000 = 0x1C0,
 	NVM_VERSION_FAMILY_8000 = 0,
-	RADIO_CFG_FAMILY_8000 = 2,
-	SKU_FAMILY_8000 = 4,
-	N_HW_ADDRS_FAMILY_8000 = 5,
-
-	/* NVM PHY-SKU-Section offset (in words) for B0 */
-	RADIO_CFG_FAMILY_8000_B0 = 0,
-	SKU_FAMILY_8000_B0 = 2,
-	N_HW_ADDRS_FAMILY_8000_B0 = 3,
+	RADIO_CFG_FAMILY_8000 = 0,
+	SKU_FAMILY_8000 = 2,
+	N_HW_ADDRS_FAMILY_8000 = 3,
 
 	/* NVM REGULATORY -Section offset (in words) definitions */
 	NVM_CHANNELS_FAMILY_8000 = 0,
@@ -446,22 +441,16 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 			    n_used, n_channels);
 }
 
-static int iwl_get_sku(const struct iwl_cfg *cfg,
-		       const __le16 *nvm_sw, const __le16 *phy_sku,
-		       bool is_family_8000_a_step)
+static int iwl_get_sku(const struct iwl_cfg *cfg, const __le16 *nvm_sw,
+		       const __le16 *phy_sku)
 {
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		return le16_to_cpup(nvm_sw + SKU);
 
-	if (!is_family_8000_a_step)
-		return le32_to_cpup((__le32 *)(phy_sku +
-					       SKU_FAMILY_8000_B0));
-	else
-		return le32_to_cpup((__le32 *)(nvm_sw + SKU_FAMILY_8000));
+	return le32_to_cpup((__le32 *)(phy_sku + SKU_FAMILY_8000));
 }
 
-static int iwl_get_nvm_version(const struct iwl_cfg *cfg,
-			       const __le16 *nvm_sw)
+static int iwl_get_nvm_version(const struct iwl_cfg *cfg, const __le16 *nvm_sw)
 {
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		return le16_to_cpup(nvm_sw + NVM_VERSION);
@@ -470,35 +459,24 @@ static int iwl_get_nvm_version(const struct iwl_cfg *cfg,
 					       NVM_VERSION_FAMILY_8000));
 }
 
-static int iwl_get_radio_cfg(const struct iwl_cfg *cfg,
-			     const __le16 *nvm_sw, const __le16 *phy_sku,
-			     bool is_family_8000_a_step)
+static int iwl_get_radio_cfg(const struct iwl_cfg *cfg, const __le16 *nvm_sw,
+			     const __le16 *phy_sku)
 {
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		return le16_to_cpup(nvm_sw + RADIO_CFG);
 
-	if (!is_family_8000_a_step)
-		return le32_to_cpup((__le32 *)(phy_sku +
-					       RADIO_CFG_FAMILY_8000_B0));
-	else
-		return le32_to_cpup((__le32 *)(nvm_sw + RADIO_CFG_FAMILY_8000));
+	return le32_to_cpup((__le32 *)(nvm_sw + RADIO_CFG_FAMILY_8000));
 
 }
 
-static int iwl_get_n_hw_addrs(const struct iwl_cfg *cfg,
-			      const __le16 *nvm_sw, bool is_family_8000_a_step)
+static int iwl_get_n_hw_addrs(const struct iwl_cfg *cfg, const __le16 *nvm_sw)
 {
 	int n_hw_addr;
 
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		return le16_to_cpup(nvm_sw + N_HW_ADDRS);
 
-	if (!is_family_8000_a_step)
-		n_hw_addr = le32_to_cpup((__le32 *)(nvm_sw +
-						    N_HW_ADDRS_FAMILY_8000_B0));
-	else
-		n_hw_addr = le32_to_cpup((__le32 *)(nvm_sw +
-						    N_HW_ADDRS_FAMILY_8000));
+	n_hw_addr = le32_to_cpup((__le32 *)(nvm_sw + N_HW_ADDRS_FAMILY_8000));
 
 	return n_hw_addr & N_HW_ADDR_MASK;
 }
@@ -594,8 +572,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
-		   u8 tx_chains, u8 rx_chains,
-		   bool lar_fw_supported, bool is_family_8000_a_step,
+		   u8 tx_chains, u8 rx_chains, bool lar_fw_supported,
 		   u32 mac_addr0, u32 mac_addr1)
 {
 	struct iwl_nvm_data *data;
@@ -618,15 +595,14 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 
 	data->nvm_version = iwl_get_nvm_version(cfg, nvm_sw);
 
-	radio_cfg =
-		iwl_get_radio_cfg(cfg, nvm_sw, phy_sku, is_family_8000_a_step);
+	radio_cfg = iwl_get_radio_cfg(cfg, nvm_sw, phy_sku);
 	iwl_set_radio_cfg(cfg, data, radio_cfg);
 	if (data->valid_tx_ant)
 		tx_chains &= data->valid_tx_ant;
 	if (data->valid_rx_ant)
 		rx_chains &= data->valid_rx_ant;
 
-	sku = iwl_get_sku(cfg, nvm_sw, phy_sku, is_family_8000_a_step);
+	sku = iwl_get_sku(cfg, nvm_sw, phy_sku);
 	data->sku_cap_band_24GHz_enable = sku & NVM_SKU_CAP_BAND_24GHZ;
 	data->sku_cap_band_52GHz_enable = sku & NVM_SKU_CAP_BAND_52GHZ;
 	data->sku_cap_11n_enable = sku & NVM_SKU_CAP_11N_ENABLE;
@@ -635,8 +611,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 	data->sku_cap_11ac_enable = data->sku_cap_11n_enable &&
 				    (sku & NVM_SKU_CAP_11AC_ENABLE);
 
-	data->n_hw_addrs =
-		iwl_get_n_hw_addrs(cfg, nvm_sw, is_family_8000_a_step);
+	data->n_hw_addrs = iwl_get_n_hw_addrs(cfg, nvm_sw);
 
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
 		/* Checking for required sections */
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index c995d2c..822ba52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -78,8 +78,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
-		   u8 tx_chains, u8 rx_chains,
-		   bool lar_fw_supported, bool is_family_8000_a_step,
+		   u8 tx_chains, u8 rx_chains, bool lar_fw_supported,
 		   u32 mac_addr0, u32 mac_addr1);
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 467c4bc..88a57e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -110,8 +110,8 @@
 #define DEVICE_SET_NMI_REG 0x00a01c30
 #define DEVICE_SET_NMI_VAL_HW BIT(0)
 #define DEVICE_SET_NMI_VAL_DRV BIT(7)
-#define DEVICE_SET_NMI_8000B_REG 0x00a01c24
-#define DEVICE_SET_NMI_8000B_VAL 0x1000000
+#define DEVICE_SET_NMI_8000_REG 0x00a01c24
+#define DEVICE_SET_NMI_8000_VAL 0x1000000
 
 /* Shared registers (0x0..0x3ff, via target indirect or periphery */
 #define SHR_BASE	0x00a10000
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b4e28ff..213bd72 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1025,16 +1025,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* W/A for 8000 HW family A-step */
-	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
-	    CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_A_STEP) {
-		if (smem_len)
-			smem_len = 0x38000;
-
-		if (sram2_len)
-			sram2_len = 0x10000;
-	}
-
 	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
 	if (!fw_error_dump)
 		return;
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 123e0a1..675197d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -77,8 +77,7 @@
 /* Default NVM size to read */
 #define IWL_NVM_DEFAULT_CHUNK_SIZE (2*1024)
 #define IWL_MAX_NVM_SECTION_SIZE	0x1b58
-#define IWL_MAX_NVM_8000A_SECTION_SIZE	0xffc
-#define IWL_MAX_NVM_8000B_SECTION_SIZE	0x1ffc
+#define IWL_MAX_NVM_8000_SECTION_SIZE	0x1ffc
 
 #define NVM_WRITE_OPCODE 1
 #define NVM_READ_OPCODE 0
@@ -267,7 +266,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 {
 	struct iwl_nvm_section *sections = mvm->nvm_sections;
 	const __le16 *hw, *sw, *calib, *regulatory, *mac_override, *phy_sku;
-	bool is_family_8000_a_step = false, lar_enabled;
+	bool lar_enabled;
 	u32 mac_addr0, mac_addr1;
 
 	/* Checking for required sections */
@@ -293,12 +292,8 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 			return NULL;
 		}
 
-		if (CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_A_STEP)
-			is_family_8000_a_step = true;
-
 		/* PHY_SKU section is mandatory in B0 */
-		if (!is_family_8000_a_step &&
-		    !mvm->nvm_sections[NVM_SECTION_TYPE_PHY_SKU].data) {
+		if (!mvm->nvm_sections[NVM_SECTION_TYPE_PHY_SKU].data) {
 			IWL_ERR(mvm,
 				"Can't parse phy_sku in B0, empty sections\n");
 			return NULL;
@@ -327,8 +322,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
 				  regulatory, mac_override, phy_sku,
 				  mvm->fw->valid_tx_ant, mvm->fw->valid_rx_ant,
-				  lar_enabled, is_family_8000_a_step,
-				  mac_addr0, mac_addr1);
+				  lar_enabled, mac_addr0, mac_addr1);
 }
 
 #define MAX_NVM_FILE_LEN	16384
@@ -381,10 +375,8 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 	/* Maximal size depends on HW family and step */
 	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		max_section_size = IWL_MAX_NVM_SECTION_SIZE;
-	else if (CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_A_STEP)
-		max_section_size = IWL_MAX_NVM_8000A_SECTION_SIZE;
-	else /* Family 8000 B-step or C-step */
-		max_section_size = IWL_MAX_NVM_8000B_SECTION_SIZE;
+	else
+		max_section_size = IWL_MAX_NVM_8000_SECTION_SIZE;
 
 	/*
 	 * Obtain NVM image via request_firmware. Since we already used
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a28080e..91361be 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -522,15 +522,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	min_backoff = calc_min_backoff(trans, cfg);
 	iwl_mvm_tt_initialize(mvm, min_backoff);
 	/* set the nvm_file_name according to priority */
-	if (iwlwifi_mod_params.nvm_file) {
+	if (iwlwifi_mod_params.nvm_file)
 		mvm->nvm_file_name = iwlwifi_mod_params.nvm_file;
-	} else {
-		if ((trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) &&
-		    (CSR_HW_REV_STEP(trans->hw_rev) == SILICON_A_STEP))
-			mvm->nvm_file_name = mvm->cfg->default_nvm_file_8000A;
-		else
-			mvm->nvm_file_name = mvm->cfg->default_nvm_file;
-	}
+	else
+		mvm->nvm_file_name = mvm->cfg->default_nvm_file;
 
 	if (WARN(cfg->no_power_up_nic_in_init && !mvm->nvm_file_name,
 		 "not allowing power-up and not having nvm_file\n"))
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 39e3cf0..d8984fb 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -719,10 +719,10 @@ static int iwl_pcie_rsa_race_bug_wa(struct iwl_trans *trans)
 	return -EIO;
 }
 
-static int iwl_pcie_load_cpu_sections_8000b(struct iwl_trans *trans,
-					    const struct fw_img *image,
-					    int cpu,
-					    int *first_ucode_section)
+static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
+					   const struct fw_img *image,
+					   int cpu,
+					   int *first_ucode_section)
 {
 	int shift_param;
 	int i, ret = 0, sec_num = 0x1;
@@ -917,16 +917,13 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 	}
 
 	/* release CPU reset */
-	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
-		iwl_write_prph(trans, RELEASE_CPU_RESET, RELEASE_CPU_RESET_BIT);
-	else
-		iwl_write32(trans, CSR_RESET, 0);
+	iwl_write32(trans, CSR_RESET, 0);
 
 	return 0;
 }
 
-static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
-					   const struct fw_img *image)
+static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
+					  const struct fw_img *image)
 {
 	int ret = 0;
 	int first_ucode_section;
@@ -947,14 +944,14 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 	iwl_write_prph(trans, RELEASE_CPU_RESET, RELEASE_CPU_RESET_BIT);
 
 	/* load to FW the binary Secured sections of CPU1 */
-	ret = iwl_pcie_load_cpu_sections_8000b(trans, image, 1,
-					       &first_ucode_section);
+	ret = iwl_pcie_load_cpu_sections_8000(trans, image, 1,
+					      &first_ucode_section);
 	if (ret)
 		return ret;
 
 	/* load to FW the binary sections of CPU2 */
-	ret = iwl_pcie_load_cpu_sections_8000b(trans, image, 2,
-					       &first_ucode_section);
+	ret = iwl_pcie_load_cpu_sections_8000(trans, image, 2,
+					      &first_ucode_section);
 	if (ret)
 		return ret;
 
@@ -1007,9 +1004,8 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* Load the given image to the HW */
-	if ((trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) &&
-	    (CSR_HW_REV_STEP(trans->hw_rev) != SILICON_A_STEP))
-		return iwl_pcie_load_given_ucode_8000b(trans, fw);
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		return iwl_pcie_load_given_ucode_8000(trans, fw);
 	else
 		return iwl_pcie_load_given_ucode(trans, fw);
 }
-- 
1.9.1

