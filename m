Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45468 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1034487AbcIVUwZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:52:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:52:07 +0300
Message-Id: <20160922205210.1778-8-luca@coelho.fi> (sfid-20160922_225241_957047_CFD6CD25)
In-Reply-To: <20160922205210.1778-1-luca@coelho.fi>
References: <20160922205210.1778-1-luca@coelho.fi>
Subject: [PATCH 07/10] iwlwifi: remove support for fw older than -17 and -22
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

FW versions older than -17 for 3160 and 7260 and older than -22 for
newer NICs are not supported anymore.  Don't load these versions
and remove code that handles them.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c      |  6 ++---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   | 24 +------------------
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  3 +--
 .../net/wireless/intel/iwlwifi/mvm/fw-api-power.h  | 21 +++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  2 --
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 10 +-------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 24 ++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  2 --
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  6 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     | 15 ++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 27 ++++------------------
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        | 10 ++------
 14 files changed, 36 insertions(+), 118 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index aa575fb..d4b73de 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -77,9 +77,9 @@
 #define IWL3168_UCODE_API_MAX	26
 
 /* Lowest firmware API version supported */
-#define IWL7260_UCODE_API_MIN	16
-#define IWL7265_UCODE_API_MIN	16
-#define IWL7265D_UCODE_API_MIN	16
+#define IWL7260_UCODE_API_MIN	17
+#define IWL7265_UCODE_API_MIN	17
+#define IWL7265D_UCODE_API_MIN	17
 #define IWL3168_UCODE_API_MIN	20
 
 /* NVM versions */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 990cf2b..d02ca14 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -74,7 +74,7 @@
 #define IWL8265_UCODE_API_MAX	26
 
 /* Lowest firmware API version supported */
-#define IWL8000_UCODE_API_MIN	16
+#define IWL8000_UCODE_API_MIN	17
 #define IWL8265_UCODE_API_MIN	20
 
 /* NVM versions */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index a2c7946..ff85041 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -58,7 +58,7 @@
 #define IWL9000_UCODE_API_MAX	26
 
 /* Lowest firmware API version supported */
-#define IWL9000_UCODE_API_MIN	16
+#define IWL9000_UCODE_API_MIN	17
 
 /* NVM versions */
 #define IWL9000_NVM_VERSION		0x0a1d
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 94423f0..ceec5ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -199,8 +199,6 @@ struct iwl_ucode_capa {
  * @IWL_UCODE_TLV_FLAGS_NEWSCAN: new uCode scan behavior on hidden SSID,
  *	treats good CRC threshold as a boolean
  * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
- * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
- * @IWL_UCODE_TLV_FLAGS_DW_BC_TABLE: The SCD byte count table is in DWORDS
  * @IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT: This uCode image supports uAPSD
  * @IWL_UCODE_TLV_FLAGS_SHORT_BL: 16 entries of black list instead of 64 in scan
  *	offload profile config command.
@@ -210,36 +208,24 @@ struct iwl_ucode_capa {
  *	from the probe request template.
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL: new NS offload (small version)
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE: new NS offload (large version)
- * @IWL_UCODE_TLV_FLAGS_P2P_PM: P2P client supports PM as a stand alone MAC
- * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_DCM: support power save on BSS station and
- *	P2P client interfaces simultaneously if they are in different bindings.
- * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_SCM: support power save on BSS station and
- *	P2P client interfaces simultaneously if they are in same bindings.
  * @IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT: General support for uAPSD
  * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
  * @IWL_UCODE_TLV_FLAGS_BCAST_FILTERING: uCode supports broadcast filtering.
- * @IWL_UCODE_TLV_FLAGS_GO_UAPSD: AP/GO interfaces support uAPSD clients
  * @IWL_UCODE_TLV_FLAGS_EBS_SUPPORT: this uCode image supports EBS.
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
 	IWL_UCODE_TLV_FLAGS_NEWSCAN		= BIT(1),
 	IWL_UCODE_TLV_FLAGS_MFP			= BIT(2),
-	IWL_UCODE_TLV_FLAGS_P2P			= BIT(3),
-	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
 	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
 	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
 	IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID	= BIT(12),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL	= BIT(15),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE	= BIT(16),
-	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
-	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
-	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM	= BIT(23),
 	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 	IWL_UCODE_TLV_FLAGS_EBS_SUPPORT		= BIT(25),
 	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
 	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
-	IWL_UCODE_TLV_FLAGS_GO_UAPSD		= BIT(30),
 };
 
 typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
@@ -249,13 +235,8 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
- * @IWL_UCODE_TLV_API_WIDE_CMD_HDR: ucode supports wide command header
  * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
  * @IWL_UCODE_TLV_API_NEW_VERSION: new versioning format
- * @IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY: scan APIs use 8-level priority
- *	instead of 3.
- * @IWL_UCODE_TLV_API_TX_POWER_CHAIN: TX power API has larger command size
- *	(command version 3) that supports per-chain limits
  * @IWL_UCODE_TLV_API_SCAN_TSF_REPORT: Scan start time reported in scan
  *	iteration complete notification, and the timestamp reported for RX
  *	received during scan, are reported in TSF of the mac specified in the
@@ -266,11 +247,8 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= (__force iwl_ucode_tlv_api_t)8,
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
-	IWL_UCODE_TLV_API_WIDE_CMD_HDR		= (__force iwl_ucode_tlv_api_t)14,
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= (__force iwl_ucode_tlv_api_t)18,
-	IWL_UCODE_TLV_API_NEW_VERSION           = (__force iwl_ucode_tlv_api_t)20,
-	IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY	= (__force iwl_ucode_tlv_api_t)24,
-	IWL_UCODE_TLV_API_TX_POWER_CHAIN	= (__force iwl_ucode_tlv_api_t)27,
+	IWL_UCODE_TLV_API_NEW_VERSION		= (__force iwl_ucode_tlv_api_t)20,
 	IWL_UCODE_TLV_API_SCAN_TSF_REPORT	= (__force iwl_ucode_tlv_api_t)28,
 
 	NUM_IWL_UCODE_TLV_API
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 8ff1921..2d6f44f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -1578,8 +1578,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
 	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
-	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p &&
-	      mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM)))
+	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p)))
 		MVM_DEBUGFS_ADD_FILE_VIF(pm_params, mvmvif->dbgfs_dir, S_IWUSR |
 					 S_IRUSR);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
index 404b0de..3fa43d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h
@@ -313,35 +313,26 @@ enum iwl_dev_tx_power_cmd_mode {
 	IWL_TX_POWER_MODE_SET_ACK = 3,
 }; /* TX_POWER_REDUCED_FLAGS_TYPE_API_E_VER_4 */;
 
+#define IWL_NUM_CHAIN_LIMITS	2
+#define IWL_NUM_SUB_BANDS	5
+
 /**
- * struct iwl_dev_tx_power_cmd_v2 - TX power reduction command
+ * struct iwl_dev_tx_power_cmd - TX power reduction command
  * @set_mode: see &enum iwl_dev_tx_power_cmd_mode
  * @mac_context_id: id of the mac ctx for which we are reducing TX power.
  * @pwr_restriction: TX power restriction in 1/8 dBms.
  * @dev_24: device TX power restriction in 1/8 dBms
  * @dev_52_low: device TX power restriction upper band - low
  * @dev_52_high: device TX power restriction upper band - high
+ * @per_chain_restriction: per chain restrictions
  */
-struct iwl_dev_tx_power_cmd_v2 {
+struct iwl_dev_tx_power_cmd_v3 {
 	__le32 set_mode;
 	__le32 mac_context_id;
 	__le16 pwr_restriction;
 	__le16 dev_24;
 	__le16 dev_52_low;
 	__le16 dev_52_high;
-} __packed; /* TX_REDUCED_POWER_API_S_VER_2 */
-
-#define IWL_NUM_CHAIN_LIMITS	2
-#define IWL_NUM_SUB_BANDS	5
-
-/**
- * struct iwl_dev_tx_power_cmd - TX power reduction command
- * @v2: version 2 of the command, embedded here for easier software handling
- * @per_chain_restriction: per chain restrictions
- */
-struct iwl_dev_tx_power_cmd_v3 {
-	/* v3 is just an extension of v2 - keep this here */
-	struct iwl_dev_tx_power_cmd_v2 v2;
 	__le16 per_chain_restriction[IWL_NUM_CHAIN_LIMITS][IWL_NUM_SUB_BANDS];
 } __packed; /* TX_REDUCED_POWER_API_S_VER_3 */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 0055a96..57d29a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -89,7 +89,6 @@
  * @TX_CMD_FLG_MH_PAD: driver inserted 2 byte padding after MAC header.
  *	Should be set for 26/30 length MAC headers
  * @TX_CMD_FLG_RESP_TO_DRV: zero this if the response should go only to FW
- * @TX_CMD_FLG_CCMP_AGG: this frame uses CCMP for aggregation acceleration
  * @TX_CMD_FLG_TKIP_MIC_DONE: FW already performed TKIP MIC calculation
  * @TX_CMD_FLG_DUR: disable duration overwriting used in PS-Poll Assoc-id
  * @TX_CMD_FLG_FW_DROP: FW should mark frame to be dropped
@@ -116,7 +115,6 @@ enum iwl_tx_flags {
 	TX_CMD_FLG_KEEP_SEQ_CTL		= BIT(18),
 	TX_CMD_FLG_MH_PAD		= BIT(20),
 	TX_CMD_FLG_RESP_TO_DRV		= BIT(21),
-	TX_CMD_FLG_CCMP_AGG		= BIT(22),
 	TX_CMD_FLG_TKIP_MIC_DONE	= BIT(23),
 	TX_CMD_FLG_DUR			= BIT(25),
 	TX_CMD_FLG_FW_DROP		= BIT(26),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 8974120..8720663 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1046,19 +1046,11 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 {
 	struct iwl_mvm_sar_table sar_table;
 	struct iwl_dev_tx_power_cmd cmd = {
-		.v3.v2.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS),
+		.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_CHAINS),
 	};
 	int ret, i, j, idx;
 	int len = sizeof(cmd);
 
-	/* we can't do anything with the table if the FW doesn't support it */
-	if (!fw_has_api(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_API_TX_POWER_CHAIN)) {
-		IWL_DEBUG_RADIO(mvm,
-				"FW doesn't support per-chain TX power settings.\n");
-		return 0;
-	}
-
 	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
 		len = sizeof(cmd.v3);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a5ede8c..318efd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -479,13 +479,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->n_cipher_suites++;
 	}
 
-	/*
-	 * Enable 11w if advertised by firmware and software crypto
-	 * is not enabled (as the firmware will interpret some mgmt
-	 * packets, so enabling it with software crypto isn't safe)
+	/* Enable 11w if software crypto is not enabled (as the
+	 * firmware will interpret some mgmt packets, so enabling it
+	 * with software crypto isn't safe).
 	 */
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_MFP &&
-	    !iwlwifi_mod_params.sw_crypto) {
+	if (!iwlwifi_mod_params.sw_crypto) {
 		ieee80211_hw_set(hw, MFP_CAPABLE);
 		mvm->ciphers[hw->wiphy->n_cipher_suites] =
 			WLAN_CIPHER_SUITE_AES_CMAC;
@@ -547,9 +545,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
 					       REGULATORY_DISABLE_BEACON_HINTS;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_GO_UAPSD)
-		hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
-
+	hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	hw->wiphy->iface_combinations = iwl_mvm_iface_combinations;
@@ -1273,20 +1269,18 @@ static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				s16 tx_power)
 {
 	struct iwl_dev_tx_power_cmd cmd = {
-		.v3.v2.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_MAC),
-		.v3.v2.mac_context_id =
+		.v3.set_mode = cpu_to_le32(IWL_TX_POWER_MODE_SET_MAC),
+		.v3.mac_context_id =
 			cpu_to_le32(iwl_mvm_vif_from_mac80211(vif)->id),
-		.v3.v2.pwr_restriction = cpu_to_le16(8 * tx_power),
+		.v3.pwr_restriction = cpu_to_le16(8 * tx_power),
 	};
 	int len = sizeof(cmd);
 
 	if (tx_power == IWL_DEFAULT_MAX_TX_POWER)
-		cmd.v3.v2.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
+		cmd.v3.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
 
 	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TX_POWER_ACK))
 		len = sizeof(cmd.v3);
-	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_TX_POWER_CHAIN))
-		len = sizeof(cmd.v3.v2);
 
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b7cfdcb..d17cbf6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1305,8 +1305,6 @@ static inline void iwl_mvm_set_tx_cmd_ccmp(struct ieee80211_tx_info *info,
 
 	tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
 	memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
-	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		tx_cmd->tx_flags |= cpu_to_le32(TX_CMD_FLG_CCMP_AGG);
 }
 
 static inline void iwl_mvm_wait_for_async_handlers(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 6c08aa3..05fe6dd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -653,11 +653,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	/* the hardware splits the A-MSDU */
 	if (mvm->cfg->mq_rx_supported)
 		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
-	trans->wide_cmd_header = fw_has_api(&mvm->fw->ucode_capa,
-					    IWL_UCODE_TLV_API_WIDE_CMD_HDR);
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DW_BC_TABLE)
-		trans_cfg.bc_table_dword = true;
+	trans->wide_cmd_header = true;
+	trans_cfg.bc_table_dword = true;
 
 	trans_cfg.command_groups = iwl_mvm_groups;
 	trans_cfg.command_groups_size = ARRAY_SIZE(iwl_mvm_groups);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index ff85865..af6d10c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -694,8 +694,7 @@ static void iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 
 	/* enable PM on p2p if p2p stand alone */
 	if (vifs->p2p_active && !vifs->bss_active && !vifs->ap_active) {
-		if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PM)
-			p2p_mvmvif->pm_enabled = true;
+		p2p_mvmvif->pm_enabled = true;
 		return;
 	}
 
@@ -707,12 +706,10 @@ static void iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 				   ap_mvmvif->phy_ctxt->id);
 
 	/* clients are not stand alone: enable PM if DCM */
-	if (!(client_same_channel || ap_same_channel) &&
-	    (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM)) {
+	if (!(client_same_channel || ap_same_channel)) {
 		if (vifs->bss_active)
 			bss_mvmvif->pm_enabled = true;
-		if (vifs->p2p_active &&
-		    (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PM))
+		if (vifs->p2p_active)
 			p2p_mvmvif->pm_enabled = true;
 		return;
 	}
@@ -721,12 +718,10 @@ static void iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 	 * There is only one channel in the system and there are only
 	 * bss and p2p clients that share it
 	 */
-	if (client_same_channel && !vifs->ap_active &&
-	    (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM)) {
+	if (client_same_channel && !vifs->ap_active) {
 		/* share same channel*/
 		bss_mvmvif->pm_enabled = true;
-		if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PM)
-			p2p_mvmvif->pm_enabled = true;
+		p2p_mvmvif->pm_enabled = true;
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 00b03fc..f279fdd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -739,22 +739,6 @@ iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params->preq.common_data.len = cpu_to_le16(ies->common_ie_len);
 }
 
-static __le32 iwl_mvm_scan_priority(struct iwl_mvm *mvm,
-				    enum iwl_scan_priority_ext prio)
-{
-	if (fw_has_api(&mvm->fw->ucode_capa,
-		       IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY))
-		return cpu_to_le32(prio);
-
-	if (prio <= IWL_SCAN_PRIORITY_EXT_2)
-		return cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
-
-	if (prio <= IWL_SCAN_PRIORITY_EXT_4)
-		return cpu_to_le32(IWL_SCAN_PRIORITY_MEDIUM);
-
-	return cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
-}
-
 static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_lmac *cmd,
 				    struct iwl_mvm_scan_params *params)
@@ -765,7 +749,7 @@ static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
 	cmd->extended_dwell = scan_timing[params->type].dwell_extended;
 	cmd->max_out_time = cpu_to_le32(scan_timing[params->type].max_out_time);
 	cmd->suspend_time = cpu_to_le32(scan_timing[params->type].suspend_time);
-	cmd->scan_prio = iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
+	cmd->scan_prio = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
 }
 
 static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
@@ -1067,15 +1051,12 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 	cmd->fragmented_dwell = scan_timing[params->type].dwell_fragmented;
 	cmd->max_out_time = cpu_to_le32(scan_timing[params->type].max_out_time);
 	cmd->suspend_time = cpu_to_le32(scan_timing[params->type].suspend_time);
-	cmd->scan_priority =
-		iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
+	cmd->scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
 
 	if (iwl_mvm_is_regular_scan(params))
-		cmd->ooc_priority =
-			iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
+		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
 	else
-		cmd->ooc_priority =
-			iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_2);
+		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_2);
 }
 
 static void
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 58fc7b3..63a051b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -241,11 +241,8 @@ static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
 	};
 	u32 cmdid;
 
-	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_WIDE_CMD_HDR))
-		cmdid = iwl_cmd_id(CMD_DTS_MEASUREMENT_TRIGGER_WIDE,
-				   PHY_OPS_GROUP, 0);
-	else
-		cmdid = CMD_DTS_MEASUREMENT_TRIGGER;
+	cmdid = iwl_cmd_id(CMD_DTS_MEASUREMENT_TRIGGER_WIDE,
+			   PHY_OPS_GROUP, 0);
 
 	if (!fw_has_capa(&mvm->fw->ucode_capa,
 			 IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE))
@@ -261,9 +258,6 @@ int iwl_mvm_get_temp(struct iwl_mvm *mvm, s32 *temp)
 					    DTS_MEASUREMENT_NOTIF_WIDE) };
 	int ret;
 
-	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_WIDE_CMD_HDR))
-		temp_notif[0] = DTS_MEASUREMENT_NOTIFICATION;
-
 	lockdep_assert_held(&mvm->mutex);
 
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_temp_notif,
-- 
2.9.3
