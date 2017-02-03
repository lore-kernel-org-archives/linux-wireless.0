Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37886 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752721AbdBCOid (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:33 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:54 +0200
Message-Id: <20170203143812.7525-8-luca@coelho.fi> (sfid-20170203_153837_081868_80F6652D)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: mvm: support new scan API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For CDB devices we will want to configure scan parameters
per band.
Support the new scan API for now. Logic per band will be
added in the future.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   | 106 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 228 +++++++++++++++------
 2 files changed, 238 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
index 0c294c9f98e9..c78a0c499459 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
@@ -453,6 +453,8 @@ enum scan_config_flags {
 	SCAN_CONFIG_FLAG_CLEAR_CAM_MODE			= BIT(19),
 	SCAN_CONFIG_FLAG_SET_PROMISC_MODE		= BIT(20),
 	SCAN_CONFIG_FLAG_CLEAR_PROMISC_MODE		= BIT(21),
+	SCAN_CONFIG_FLAG_SET_LMAC2_FRAGMENTED		= BIT(22),
+	SCAN_CONFIG_FLAG_CLEAR_LMAC2_FRAGMENTED		= BIT(23),
 
 	/* Bits 26-31 are for num of channels in channel_array */
 #define SCAN_CONFIG_N_CHANNELS(n) ((n) << 26)
@@ -486,6 +488,20 @@ enum iwl_channel_flags {
 };
 
 /**
+ * struct iwl_scan_dwell
+ * @active:		default dwell time for active scan
+ * @passive:		default dwell time for passive scan
+ * @fragmented:		default dwell time for fragmented scan
+ * @extended:		default dwell time for channels 1, 6 and 11
+ */
+struct iwl_scan_dwell {
+	u8 active;
+	u8 passive;
+	u8 fragmented;
+	u8 extended;
+} __packed;
+
+/**
  * struct iwl_scan_config
  * @flags:			enum scan_config_flags
  * @tx_chains:			valid_tx antenna - ANT_* definitions
@@ -493,10 +509,7 @@ enum iwl_channel_flags {
  * @legacy_rates:		default legacy rates - enum scan_config_rates
  * @out_of_channel_time:	default max out of serving channel time
  * @suspend_time:		default max suspend time
- * @dwell_active:		default dwell time for active scan
- * @dwell_passive:		default dwell time for passive scan
- * @dwell_fragmented:		default dwell time for fragmented scan
- * @dwell_extended:		default dwell time for channels 1, 6 and 11
+ * @dwell:			dwells for the scan
  * @mac_addr:			default mac address to be used in probes
  * @bcast_sta_id:		the index of the station in the fw
  * @channel_flags:		default channel flags - enum iwl_channel_flags
@@ -510,16 +523,29 @@ struct iwl_scan_config {
 	__le32 legacy_rates;
 	__le32 out_of_channel_time;
 	__le32 suspend_time;
-	u8 dwell_active;
-	u8 dwell_passive;
-	u8 dwell_fragmented;
-	u8 dwell_extended;
+	struct iwl_scan_dwell dwell;
 	u8 mac_addr[ETH_ALEN];
 	u8 bcast_sta_id;
 	u8 channel_flags;
 	u8 channel_array[];
 } __packed; /* SCAN_CONFIG_DB_CMD_API_S */
 
+#define SCAN_TWO_LMACS 2
+
+struct iwl_scan_config_cdb {
+	__le32 flags;
+	__le32 tx_chains;
+	__le32 rx_chains;
+	__le32 legacy_rates;
+	__le32 out_of_channel_time[SCAN_TWO_LMACS];
+	__le32 suspend_time[SCAN_TWO_LMACS];
+	struct iwl_scan_dwell dwell;
+	u8 mac_addr[ETH_ALEN];
+	u8 bcast_sta_id;
+	u8 channel_flags;
+	u8 channel_array[];
+} __packed; /* SCAN_CONFIG_DB_CMD_API_S_3 */
+
 /**
  * iwl_umac_scan_flags
  *@IWL_UMAC_SCAN_FLAG_PREEMPTIVE: scan process triggered by this scan request
@@ -540,17 +566,18 @@ enum iwl_umac_scan_uid_offsets {
 };
 
 enum iwl_umac_scan_general_flags {
-	IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC	= BIT(0),
-	IWL_UMAC_SCAN_GEN_FLAGS_OVER_BT		= BIT(1),
-	IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL	= BIT(2),
-	IWL_UMAC_SCAN_GEN_FLAGS_PASSIVE		= BIT(3),
-	IWL_UMAC_SCAN_GEN_FLAGS_PRE_CONNECT	= BIT(4),
-	IWL_UMAC_SCAN_GEN_FLAGS_ITER_COMPLETE	= BIT(5),
-	IWL_UMAC_SCAN_GEN_FLAGS_MULTIPLE_SSID	= BIT(6),
-	IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED	= BIT(7),
-	IWL_UMAC_SCAN_GEN_FLAGS_RRM_ENABLED	= BIT(8),
-	IWL_UMAC_SCAN_GEN_FLAGS_MATCH		= BIT(9),
-	IWL_UMAC_SCAN_GEN_FLAGS_EXTENDED_DWELL	= BIT(10),
+	IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC		= BIT(0),
+	IWL_UMAC_SCAN_GEN_FLAGS_OVER_BT			= BIT(1),
+	IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL		= BIT(2),
+	IWL_UMAC_SCAN_GEN_FLAGS_PASSIVE			= BIT(3),
+	IWL_UMAC_SCAN_GEN_FLAGS_PRE_CONNECT		= BIT(4),
+	IWL_UMAC_SCAN_GEN_FLAGS_ITER_COMPLETE		= BIT(5),
+	IWL_UMAC_SCAN_GEN_FLAGS_MULTIPLE_SSID		= BIT(6),
+	IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED		= BIT(7),
+	IWL_UMAC_SCAN_GEN_FLAGS_RRM_ENABLED		= BIT(8),
+	IWL_UMAC_SCAN_GEN_FLAGS_MATCH			= BIT(9),
+	IWL_UMAC_SCAN_GEN_FLAGS_EXTENDED_DWELL		= BIT(10),
+	IWL_UMAC_SCAN_GEN_FLAGS_LMAC2_FRAGMENTED	= BIT(11),
 };
 
 /**
@@ -610,8 +637,9 @@ struct iwl_scan_req_umac_tail {
  * @active_dwell: dwell time for active scan
  * @passive_dwell: dwell time for passive scan
  * @fragmented_dwell: dwell time for fragmented passive scan
- * @max_out_time: max out of serving channel time
- * @suspend_time: max suspend time
+ * @max_out_time: max out of serving channel time, per LMAC - for CDB there
+ *	are 2 LMACs
+ * @suspend_time: max suspend time, per LMAC - for CDB there are 2 LMACs
  * @scan_priority: scan internal prioritization &enum iwl_scan_priority
  * @channel_flags: &enum iwl_scan_channel_flags
  * @n_channels: num of channels in scan request
@@ -631,15 +659,33 @@ struct iwl_scan_req_umac {
 	u8 active_dwell;
 	u8 passive_dwell;
 	u8 fragmented_dwell;
-	__le32 max_out_time;
-	__le32 suspend_time;
-	__le32 scan_priority;
-	/* SCAN_CHANNEL_PARAMS_API_S_VER_4 */
-	u8 channel_flags;
-	u8 n_channels;
-	__le16 reserved;
-	u8 data[];
-} __packed; /* SCAN_REQUEST_CMD_UMAC_API_S_VER_1 */
+	union {
+		struct {
+			__le32 max_out_time;
+			__le32 suspend_time;
+			__le32 scan_priority;
+			/* SCAN_CHANNEL_PARAMS_API_S_VER_4 */
+			u8 channel_flags;
+			u8 n_channels;
+			__le16 reserved;
+			u8 data[];
+		} no_cdb; /* SCAN_REQUEST_CMD_UMAC_API_S_VER_1 */
+		struct {
+			__le32 max_out_time[SCAN_TWO_LMACS];
+			__le32 suspend_time[SCAN_TWO_LMACS];
+			__le32 scan_priority;
+			/* SCAN_CHANNEL_PARAMS_API_S_VER_4 */
+			u8 channel_flags;
+			u8 n_channels;
+			__le16 reserved;
+			u8 data[];
+		} cdb; /* SCAN_REQUEST_CMD_UMAC_API_S_VER_5 */
+	};
+} __packed;
+
+#define IWL_SCAN_REQ_UMAC_SIZE_CDB sizeof(struct iwl_scan_req_umac)
+#define IWL_SCAN_REQ_UMAC_SIZE (sizeof(struct iwl_scan_req_umac) - \
+				2 * sizeof(__le32))
 
 /**
  * struct iwl_umac_scan_abort
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 2aaa5ecf97bc..0a64efa844b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -943,18 +943,92 @@ static __le32 iwl_mvm_scan_config_rates(struct iwl_mvm *mvm)
 	return cpu_to_le32(rates);
 }
 
-int iwl_mvm_config_scan(struct iwl_mvm *mvm)
+static void iwl_mvm_fill_scan_dwell(struct iwl_mvm *mvm,
+				    struct iwl_scan_dwell *dwell,
+				    struct iwl_mvm_scan_timing_params *timing)
+{
+	dwell->active = timing->dwell_active;
+	dwell->passive = timing->dwell_passive;
+	dwell->fragmented = timing->dwell_fragmented;
+	dwell->extended = timing->dwell_extended;
+}
+
+static void iwl_mvm_fill_channels(struct iwl_mvm *mvm, u8 *channels)
 {
-	struct iwl_scan_config *scan_config;
 	struct ieee80211_supported_band *band;
-	int num_channels =
-		mvm->nvm_data->bands[NL80211_BAND_2GHZ].n_channels +
-		mvm->nvm_data->bands[NL80211_BAND_5GHZ].n_channels;
-	int ret, i, j = 0, cmd_size;
+	int i, j = 0;
+
+	band = &mvm->nvm_data->bands[NL80211_BAND_2GHZ];
+	for (i = 0; i < band->n_channels; i++, j++)
+		channels[j] = band->channels[i].hw_value;
+	band = &mvm->nvm_data->bands[NL80211_BAND_5GHZ];
+	for (i = 0; i < band->n_channels; i++, j++)
+		channels[j] = band->channels[i].hw_value;
+}
+
+static void iwl_mvm_fill_scan_config(struct iwl_mvm *mvm, void *config,
+				     u32 flags, u8 channel_flags)
+{
+	enum iwl_mvm_scan_type type = iwl_mvm_get_scan_type(mvm, false);
+	struct iwl_scan_config *cfg = config;
+
+	cfg->flags = cpu_to_le32(flags);
+	cfg->tx_chains = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
+	cfg->rx_chains = cpu_to_le32(iwl_mvm_scan_rx_ant(mvm));
+	cfg->legacy_rates = iwl_mvm_scan_config_rates(mvm);
+	cfg->out_of_channel_time = cpu_to_le32(scan_timing[type].max_out_time);
+	cfg->suspend_time = cpu_to_le32(scan_timing[type].suspend_time);
+
+	iwl_mvm_fill_scan_dwell(mvm, &cfg->dwell, &scan_timing[type]);
+
+	memcpy(&cfg->mac_addr, &mvm->addresses[0].addr, ETH_ALEN);
+
+	cfg->bcast_sta_id = mvm->aux_sta.sta_id;
+	cfg->channel_flags = channel_flags;
+
+	iwl_mvm_fill_channels(mvm, cfg->channel_array);
+}
+
+static void iwl_mvm_fill_scan_config_cdb(struct iwl_mvm *mvm, void *config,
+					 u32 flags, u8 channel_flags)
+{
+	enum iwl_mvm_scan_type type = iwl_mvm_get_scan_type(mvm, false);
+	struct iwl_scan_config_cdb *cfg = config;
+
+	cfg->flags = cpu_to_le32(flags);
+	cfg->tx_chains = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
+	cfg->rx_chains = cpu_to_le32(iwl_mvm_scan_rx_ant(mvm));
+	cfg->legacy_rates = iwl_mvm_scan_config_rates(mvm);
+	cfg->out_of_channel_time[0] =
+		cpu_to_le32(scan_timing[type].max_out_time);
+	cfg->out_of_channel_time[1] =
+		cpu_to_le32(scan_timing[type].max_out_time);
+	cfg->suspend_time[0] = cpu_to_le32(scan_timing[type].suspend_time);
+	cfg->suspend_time[1] = cpu_to_le32(scan_timing[type].suspend_time);
+
+	iwl_mvm_fill_scan_dwell(mvm, &cfg->dwell, &scan_timing[type]);
+
+	memcpy(&cfg->mac_addr, &mvm->addresses[0].addr, ETH_ALEN);
+
+	cfg->bcast_sta_id = mvm->aux_sta.sta_id;
+	cfg->channel_flags = channel_flags;
+
+	iwl_mvm_fill_channels(mvm, cfg->channel_array);
+}
+
+int iwl_mvm_config_scan(struct iwl_mvm *mvm)
+{
+	void *cfg;
+	int ret, cmd_size;
 	struct iwl_host_cmd cmd = {
 		.id = iwl_cmd_id(SCAN_CFG_CMD, IWL_ALWAYS_LONG_GROUP, 0),
 	};
 	enum iwl_mvm_scan_type type = iwl_mvm_get_scan_type(mvm, false);
+	int num_channels =
+		mvm->nvm_data->bands[NL80211_BAND_2GHZ].n_channels +
+		mvm->nvm_data->bands[NL80211_BAND_5GHZ].n_channels;
+	u32 flags;
+	u8 channel_flags;
 
 	if (WARN_ON(num_channels > mvm->fw->ucode_capa.n_scan_channels))
 		return -ENOBUFS;
@@ -965,52 +1039,45 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 		return 0;
 	}
 
-	cmd_size = sizeof(*scan_config) + mvm->fw->ucode_capa.n_scan_channels;
+	if (iwl_mvm_is_cdb_supported(mvm))
+		cmd_size = sizeof(struct iwl_scan_config_cdb);
+	else
+		cmd_size = sizeof(struct iwl_scan_config);
+	cmd_size += mvm->fw->ucode_capa.n_scan_channels;
 
-	scan_config = kzalloc(cmd_size, GFP_KERNEL);
-	if (!scan_config)
+	cfg = kzalloc(cmd_size, GFP_KERNEL);
+	if (!cfg)
 		return -ENOMEM;
 
-	scan_config->flags = cpu_to_le32(SCAN_CONFIG_FLAG_ACTIVATE |
-					 SCAN_CONFIG_FLAG_ALLOW_CHUB_REQS |
-					 SCAN_CONFIG_FLAG_SET_TX_CHAINS |
-					 SCAN_CONFIG_FLAG_SET_RX_CHAINS |
-					 SCAN_CONFIG_FLAG_SET_AUX_STA_ID |
-					 SCAN_CONFIG_FLAG_SET_ALL_TIMES |
-					 SCAN_CONFIG_FLAG_SET_LEGACY_RATES |
-					 SCAN_CONFIG_FLAG_SET_MAC_ADDR |
-					 SCAN_CONFIG_FLAG_SET_CHANNEL_FLAGS|
-					 SCAN_CONFIG_N_CHANNELS(num_channels) |
-					 (type == IWL_SCAN_TYPE_FRAGMENTED ?
-					  SCAN_CONFIG_FLAG_SET_FRAGMENTED :
-					  SCAN_CONFIG_FLAG_CLEAR_FRAGMENTED));
-	scan_config->tx_chains = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
-	scan_config->rx_chains = cpu_to_le32(iwl_mvm_scan_rx_ant(mvm));
-	scan_config->legacy_rates = iwl_mvm_scan_config_rates(mvm);
-	scan_config->out_of_channel_time =
-		cpu_to_le32(scan_timing[type].max_out_time);
-	scan_config->suspend_time = cpu_to_le32(scan_timing[type].suspend_time);
-	scan_config->dwell_active = scan_timing[type].dwell_active;
-	scan_config->dwell_passive = scan_timing[type].dwell_passive;
-	scan_config->dwell_fragmented = scan_timing[type].dwell_fragmented;
-	scan_config->dwell_extended = scan_timing[type].dwell_extended;
-
-	memcpy(&scan_config->mac_addr, &mvm->addresses[0].addr, ETH_ALEN);
-
-	scan_config->bcast_sta_id = mvm->aux_sta.sta_id;
-	scan_config->channel_flags = IWL_CHANNEL_FLAG_EBS |
-				     IWL_CHANNEL_FLAG_ACCURATE_EBS |
-				     IWL_CHANNEL_FLAG_EBS_ADD |
-				     IWL_CHANNEL_FLAG_PRE_SCAN_PASSIVE2ACTIVE;
-
-	band = &mvm->nvm_data->bands[NL80211_BAND_2GHZ];
-	for (i = 0; i < band->n_channels; i++, j++)
-		scan_config->channel_array[j] = band->channels[i].hw_value;
-	band = &mvm->nvm_data->bands[NL80211_BAND_5GHZ];
-	for (i = 0; i < band->n_channels; i++, j++)
-		scan_config->channel_array[j] = band->channels[i].hw_value;
+	flags = SCAN_CONFIG_FLAG_ACTIVATE |
+		 SCAN_CONFIG_FLAG_ALLOW_CHUB_REQS |
+		 SCAN_CONFIG_FLAG_SET_TX_CHAINS |
+		 SCAN_CONFIG_FLAG_SET_RX_CHAINS |
+		 SCAN_CONFIG_FLAG_SET_AUX_STA_ID |
+		 SCAN_CONFIG_FLAG_SET_ALL_TIMES |
+		 SCAN_CONFIG_FLAG_SET_LEGACY_RATES |
+		 SCAN_CONFIG_FLAG_SET_MAC_ADDR |
+		 SCAN_CONFIG_FLAG_SET_CHANNEL_FLAGS |
+		 SCAN_CONFIG_N_CHANNELS(num_channels) |
+		 (type == IWL_SCAN_TYPE_FRAGMENTED ?
+		  SCAN_CONFIG_FLAG_SET_FRAGMENTED :
+		  SCAN_CONFIG_FLAG_CLEAR_FRAGMENTED);
+
+	channel_flags = IWL_CHANNEL_FLAG_EBS |
+			IWL_CHANNEL_FLAG_ACCURATE_EBS |
+			IWL_CHANNEL_FLAG_EBS_ADD |
+			IWL_CHANNEL_FLAG_PRE_SCAN_PASSIVE2ACTIVE;
+
+	if (iwl_mvm_is_cdb_supported(mvm)) {
+		flags |= (type == IWL_SCAN_TYPE_FRAGMENTED) ?
+			 SCAN_CONFIG_FLAG_SET_LMAC2_FRAGMENTED :
+			 SCAN_CONFIG_FLAG_CLEAR_LMAC2_FRAGMENTED;
+		iwl_mvm_fill_scan_config_cdb(mvm, cfg, flags, channel_flags);
+	} else {
+		iwl_mvm_fill_scan_config(mvm, cfg, flags, channel_flags);
+	}
 
-	cmd.data[0] = scan_config;
+	cmd.data[0] = cfg;
 	cmd.len[0] = cmd_size;
 	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
 
@@ -1020,7 +1087,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	if (!ret)
 		mvm->scan_type = type;
 
-	kfree(scan_config);
+	kfree(cfg);
 	return ret;
 }
 
@@ -1039,19 +1106,31 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_umac *cmd,
 				    struct iwl_mvm_scan_params *params)
 {
+	struct iwl_mvm_scan_timing_params *timing = &scan_timing[params->type];
+
 	if (params->measurement_dwell) {
 		cmd->active_dwell = params->measurement_dwell;
 		cmd->passive_dwell = params->measurement_dwell;
 		cmd->extended_dwell = params->measurement_dwell;
 	} else {
-		cmd->active_dwell = scan_timing[params->type].dwell_active;
-		cmd->passive_dwell = scan_timing[params->type].dwell_passive;
-		cmd->extended_dwell = scan_timing[params->type].dwell_extended;
+		cmd->active_dwell = timing->dwell_active;
+		cmd->passive_dwell = timing->dwell_passive;
+		cmd->extended_dwell = timing->dwell_extended;
+	}
+	cmd->fragmented_dwell = timing->dwell_fragmented;
+
+	if (iwl_mvm_is_cdb_supported(mvm)) {
+		cmd->cdb.max_out_time[0] = cpu_to_le32(timing->max_out_time);
+		cmd->cdb.suspend_time[0] = cpu_to_le32(timing->suspend_time);
+		cmd->cdb.max_out_time[1] = cpu_to_le32(timing->max_out_time);
+		cmd->cdb.suspend_time[1] = cpu_to_le32(timing->suspend_time);
+		cmd->cdb.scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
+	} else {
+		cmd->no_cdb.max_out_time = cpu_to_le32(timing->max_out_time);
+		cmd->no_cdb.suspend_time = cpu_to_le32(timing->suspend_time);
+		cmd->no_cdb.scan_priority =
+			cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
 	}
-	cmd->fragmented_dwell = scan_timing[params->type].dwell_fragmented;
-	cmd->max_out_time = cpu_to_le32(scan_timing[params->type].max_out_time);
-	cmd->suspend_time = cpu_to_le32(scan_timing[params->type].suspend_time);
-	cmd->scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
 
 	if (iwl_mvm_is_regular_scan(params))
 		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
@@ -1063,9 +1142,8 @@ static void
 iwl_mvm_umac_scan_cfg_channels(struct iwl_mvm *mvm,
 			       struct ieee80211_channel **channels,
 			       int n_channels, u32 ssid_bitmap,
-			       struct iwl_scan_req_umac *cmd)
+			       struct iwl_scan_channel_cfg_umac *channel_cfg)
 {
-	struct iwl_scan_channel_cfg_umac *channel_cfg = (void *)&cmd->data;
 	int i;
 
 	for (i = 0; i < n_channels; i++) {
@@ -1088,8 +1166,11 @@ static u16 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PRE_CONNECT;
 
-	if (params->type == IWL_SCAN_TYPE_FRAGMENTED)
+	if (params->type == IWL_SCAN_TYPE_FRAGMENTED) {
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED;
+		if (iwl_mvm_is_cdb_supported(mvm))
+			flags |= IWL_UMAC_SCAN_GEN_FLAGS_LMAC2_FRAGMENTED;
+	}
 
 	if (iwl_mvm_rrm_scan_needed(mvm))
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_RRM_ENABLED;
@@ -1126,11 +1207,14 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     int type)
 {
 	struct iwl_scan_req_umac *cmd = mvm->scan_cmd;
-	struct iwl_scan_req_umac_tail *sec_part = (void *)&cmd->data +
+	void *cmd_data = iwl_mvm_is_cdb_supported(mvm) ?
+			 (void *)&cmd->cdb.data : (void *)&cmd->no_cdb.data;
+	struct iwl_scan_req_umac_tail *sec_part = cmd_data +
 		sizeof(struct iwl_scan_channel_cfg_umac) *
 			mvm->fw->ucode_capa.n_scan_channels;
 	int uid, i;
 	u32 ssid_bitmap = 0;
+	u8 channel_flags = 0;
 	struct iwl_mvm_vif *scan_vif = iwl_mvm_vif_from_mac80211(vif);
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1157,16 +1241,23 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
 
 	if (iwl_mvm_scan_use_ebs(mvm, vif))
-		cmd->channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
-				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
-				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
+		channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
+				IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
+				IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
 
-	cmd->n_channels = params->n_channels;
+	if (iwl_mvm_is_cdb_supported(mvm)) {
+		cmd->cdb.channel_flags = channel_flags;
+		cmd->cdb.n_channels = params->n_channels;
+	} else {
+		cmd->no_cdb.channel_flags = channel_flags;
+		cmd->no_cdb.n_channels = params->n_channels;
+	}
 
 	iwl_scan_build_ssids(params, sec_part->direct_scan, &ssid_bitmap);
 
 	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
-				       params->n_channels, ssid_bitmap, cmd);
+				       params->n_channels, ssid_bitmap,
+				       cmd_data);
 
 	for (i = 0; i < params->n_scan_plans; i++) {
 		struct cfg80211_sched_scan_plan *scan_plan =
@@ -1601,8 +1692,13 @@ static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 
 int iwl_mvm_scan_size(struct iwl_mvm *mvm)
 {
+	int base_size = IWL_SCAN_REQ_UMAC_SIZE;
+
+	if (iwl_mvm_is_cdb_supported(mvm))
+		base_size = IWL_SCAN_REQ_UMAC_SIZE_CDB;
+
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN))
-		return sizeof(struct iwl_scan_req_umac) +
+		return base_size +
 			sizeof(struct iwl_scan_channel_cfg_umac) *
 				mvm->fw->ucode_capa.n_scan_channels +
 			sizeof(struct iwl_scan_req_umac_tail);
-- 
2.11.0
