Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58915 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaKXOfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:36 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so5951629wiv.13
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:34 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/75] iwlwifi: mvm: implement UMAC scan API
Date: Mon, 24 Nov 2014 16:33:59 +0200
Message-Id: <1416839691-28533-23-git-send-email-egrumbach@gmail.com> (sfid-20141124_154411_974348_07DBB511)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

This API uses second CPU scan commands, and can support multiple
simultaneous scans.

Adding the new API, and adding new mechanisms to deal with up to
8 simultaneous scans instead of the old scan status.

New scan API requires scan configuration for default scan parameters,
adding it in _up flow. Also updating scan configuration after updating
valid scan antennas via debugfs.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h          |   2 +
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     |   6 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 253 ++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h      |   6 +
 drivers/net/wireless/iwlwifi/mvm/fw.c          |   6 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  25 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  16 +
 drivers/net/wireless/iwlwifi/mvm/ops.c         |  17 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 669 +++++++++++++++++++++++--
 9 files changed, 942 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 598065b..133022a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -145,6 +145,7 @@ enum iwl_ucode_tlv_api {
 /**
  * enum iwl_ucode_tlv_capa - ucode capabilities
  * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
+ * @IWL_UCODE_TLV_CAPA_UMAC_SCAN: supports UMAC scan.
  * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
  *	tx power value into TPC Report action frame and Link Measurement Report
  *	action frame
@@ -158,6 +159,7 @@ enum iwl_ucode_tlv_api {
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
+	IWL_UCODE_TLV_CAPA_UMAC_SCAN			= BIT(2),
 	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= BIT(8),
 	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= BIT(9),
 	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= BIT(10),
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 51b7116..8212b00 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -936,7 +936,11 @@ iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 	if (scan_rx_ant & ~mvm->fw->valid_rx_ant)
 		return -EINVAL;
 
-	mvm->scan_rx_ant = scan_rx_ant;
+	if (mvm->scan_rx_ant != scan_rx_ant) {
+		mvm->scan_rx_ant = scan_rx_ant;
+		if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+			iwl_mvm_config_scan(mvm);
+	}
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 1354c68..7163eb3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -794,4 +794,257 @@ struct iwl_periodic_scan_complete {
 	__le32 reserved;
 } __packed;
 
+/* UMAC Scan API */
+
+/**
+ * struct iwl_mvm_umac_cmd_hdr - Command header for UMAC commands
+ * @size:	size of the command (not including header)
+ * @reserved0:	for future use and alignment
+ * @ver:	API version number
+ */
+struct iwl_mvm_umac_cmd_hdr {
+	__le16 size;
+	u8 reserved0;
+	u8 ver;
+} __packed;
+
+#define IWL_MVM_MAX_SIMULTANEOUS_SCANS 8
+
+enum scan_config_flags {
+	SCAN_CONFIG_FLAG_ACTIVATE			= BIT(0),
+	SCAN_CONFIG_FLAG_DEACTIVATE			= BIT(1),
+	SCAN_CONFIG_FLAG_FORBID_CHUB_REQS		= BIT(2),
+	SCAN_CONFIG_FLAG_ALLOW_CHUB_REQS		= BIT(3),
+	SCAN_CONFIG_FLAG_SET_TX_CHAINS			= BIT(8),
+	SCAN_CONFIG_FLAG_SET_RX_CHAINS			= BIT(9),
+	SCAN_CONFIG_FLAG_SET_AUX_STA_ID			= BIT(10),
+	SCAN_CONFIG_FLAG_SET_ALL_TIMES			= BIT(11),
+	SCAN_CONFIG_FLAG_SET_EFFECTIVE_TIMES		= BIT(12),
+	SCAN_CONFIG_FLAG_SET_CHANNEL_FLAGS		= BIT(13),
+	SCAN_CONFIG_FLAG_SET_LEGACY_RATES		= BIT(14),
+	SCAN_CONFIG_FLAG_SET_MAC_ADDR			= BIT(15),
+	SCAN_CONFIG_FLAG_SET_FRAGMENTED			= BIT(16),
+	SCAN_CONFIG_FLAG_CLEAR_FRAGMENTED		= BIT(17),
+	SCAN_CONFIG_FLAG_SET_CAM_MODE			= BIT(18),
+	SCAN_CONFIG_FLAG_CLEAR_CAM_MODE			= BIT(19),
+	SCAN_CONFIG_FLAG_SET_PROMISC_MODE		= BIT(20),
+	SCAN_CONFIG_FLAG_CLEAR_PROMISC_MODE		= BIT(21),
+
+	/* Bits 26-31 are for num of channels in channel_array */
+#define SCAN_CONFIG_N_CHANNELS(n) ((n) << 26)
+};
+
+enum scan_config_rates {
+	/* OFDM basic rates */
+	SCAN_CONFIG_RATE_6M	= BIT(0),
+	SCAN_CONFIG_RATE_9M	= BIT(1),
+	SCAN_CONFIG_RATE_12M	= BIT(2),
+	SCAN_CONFIG_RATE_18M	= BIT(3),
+	SCAN_CONFIG_RATE_24M	= BIT(4),
+	SCAN_CONFIG_RATE_36M	= BIT(5),
+	SCAN_CONFIG_RATE_48M	= BIT(6),
+	SCAN_CONFIG_RATE_54M	= BIT(7),
+	/* CCK basic rates */
+	SCAN_CONFIG_RATE_1M	= BIT(8),
+	SCAN_CONFIG_RATE_2M	= BIT(9),
+	SCAN_CONFIG_RATE_5M	= BIT(10),
+	SCAN_CONFIG_RATE_11M	= BIT(11),
+
+	/* Bits 16-27 are for supported rates */
+#define SCAN_CONFIG_SUPPORTED_RATE(rate)	((rate) << 16)
+};
+
+enum iwl_channel_flags {
+	IWL_CHANNEL_FLAG_EBS				= BIT(0),
+	IWL_CHANNEL_FLAG_ACCURATE_EBS			= BIT(1),
+	IWL_CHANNEL_FLAG_EBS_ADD			= BIT(2),
+	IWL_CHANNEL_FLAG_PRE_SCAN_PASSIVE2ACTIVE	= BIT(3),
+};
+
+/**
+ * struct iwl_scan_config
+ * @hdr: umac command header
+ * @flags:			enum scan_config_flags
+ * @tx_chains:			valid_tx antenna - ANT_* definitions
+ * @rx_chains:			valid_rx antenna - ANT_* definitions
+ * @legacy_rates:		default legacy rates - enum scan_config_rates
+ * @out_of_channel_time:	default max out of serving channel time
+ * @suspend_time:		default max suspend time
+ * @dwell_active:		default dwell time for active scan
+ * @dwell_passive:		default dwell time for passive scan
+ * @dwell_fragmented:		default dwell time for fragmented scan
+ * @reserved:			for future use and alignment
+ * @mac_addr:			default mac address to be used in probes
+ * @bcast_sta_id:		the index of the station in the fw
+ * @channel_flags:		default channel flags - enum iwl_channel_flags
+ *				scan_config_channel_flag
+ * @channel_array:		default supported channels
+ */
+struct iwl_scan_config {
+	struct iwl_mvm_umac_cmd_hdr hdr;
+	__le32 flags;
+	__le32 tx_chains;
+	__le32 rx_chains;
+	__le32 legacy_rates;
+	__le32 out_of_channel_time;
+	__le32 suspend_time;
+	u8 dwell_active;
+	u8 dwell_passive;
+	u8 dwell_fragmented;
+	u8 reserved;
+	u8 mac_addr[ETH_ALEN];
+	u8 bcast_sta_id;
+	u8 channel_flags;
+	u8 channel_array[];
+} __packed; /* SCAN_CONFIG_DB_CMD_API_S */
+
+/**
+ * iwl_umac_scan_flags
+ *@IWL_UMAC_SCAN_FLAG_PREEMPTIVE: scan process triggered by this scan request
+ *	can be preempted by other scan requests with higher priority.
+ *	The low priority scan is aborted.
+ *@IWL_UMAC_SCAN_FLAG_START_NOTIF: notification will be sent to the driver
+ *	when scan starts.
+ */
+enum iwl_umac_scan_flags {
+	IWL_UMAC_SCAN_FLAG_PREEMPTIVE		= BIT(0),
+	IWL_UMAC_SCAN_FLAG_START_NOTIF		= BIT(1),
+};
+
+enum iwl_umac_scan_uid_offsets {
+	IWL_UMAC_SCAN_UID_TYPE_OFFSET		= 0,
+	IWL_UMAC_SCAN_UID_SEQ_OFFSET		= 8,
+};
+
+enum iwl_umac_scan_general_flags {
+	IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC	= BIT(0),
+	IWL_UMAC_SCAN_GEN_FLAGS_OVER_BT		= BIT(1),
+	IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL	= BIT(2),
+	IWL_UMAC_SCAN_GEN_FLAGS_PASSIVE		= BIT(3),
+	IWL_UMAC_SCAN_GEN_FLAGS_PRE_CONNECT	= BIT(4),
+	IWL_UMAC_SCAN_GEN_FLAGS_ITER_COMPLETE	= BIT(5),
+	IWL_UMAC_SCAN_GEN_FLAGS_MULTIPLE_SSID	= BIT(6),
+	IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED	= BIT(7),
+	IWL_UMAC_SCAN_GEN_FLAGS_RRM_ENABLED	= BIT(8),
+	IWL_UMAC_SCAN_GEN_FLAGS_MATCH		= BIT(9)
+};
+
+/**
+ * struct iwl_scan_channel_cfg_umac
+ * @flags:		bitmap - 0-19:	directed scan to i'th ssid.
+ * @channel_num:	channel number 1-13 etc.
+ * @iter_count:		repetition count for the channel.
+ * @iter_interval:	interval between two scan interations on one channel.
+ */
+struct iwl_scan_channel_cfg_umac {
+	__le32 flags;
+	u8 channel_num;
+	u8 iter_count;
+	__le16 iter_interval;
+} __packed; /* SCAN_CHANNEL_CFG_S_VER2 */
+
+/**
+ * struct iwl_scan_umac_schedule
+ * @interval: interval in seconds between scan iterations
+ * @iter_count: num of scan iterations for schedule plan, 0xff for infinite loop
+ * @reserved: for alignment and future use
+ */
+struct iwl_scan_umac_schedule {
+	__le16 interval;
+	u8 iter_count;
+	u8 reserved;
+} __packed; /* SCAN_SCHED_PARAM_API_S_VER_1 */
+
+/**
+ * struct iwl_scan_req_umac_tail - the rest of the UMAC scan request command
+ *      parameters following channels configuration array.
+ * @schedule: two scheduling plans.
+ * @delay: delay in TUs before starting the first scan iteration
+ * @reserved: for future use and alignment
+ * @preq: probe request with IEs blocks
+ * @direct_scan: list of SSIDs for directed active scan
+ */
+struct iwl_scan_req_umac_tail {
+	/* SCAN_PERIODIC_PARAMS_API_S_VER_1 */
+	struct iwl_scan_umac_schedule schedule[2];
+	__le16 delay;
+	__le16 reserved;
+	/* SCAN_PROBE_PARAMS_API_S_VER_1 */
+	struct iwl_scan_probe_req preq;
+	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
+} __packed;
+
+/**
+ * struct iwl_scan_req_umac
+ * @hdr: umac command header
+ * @flags: &enum iwl_umac_scan_flags
+ * @uid: scan id, &enum iwl_umac_scan_uid_offsets
+ * @ooc_priority: out of channel priority - &enum iwl_scan_priority
+ * @general_flags: &enum iwl_umac_scan_general_flags
+ * @reserved1: for future use and alignment
+ * @active_dwell: dwell time for active scan
+ * @passive_dwell: dwell time for passive scan
+ * @fragmented_dwell: dwell time for fragmented passive scan
+ * @max_out_time: max out of serving channel time
+ * @suspend_time: max suspend time
+ * @scan_priority: scan internal prioritization &enum iwl_scan_priority
+ * @channel_flags: &enum iwl_scan_channel_flags
+ * @n_channels: num of channels in scan request
+ * @reserved2: for future use and alignment
+ * @data: &struct iwl_scan_channel_cfg_umac and
+ *	&struct iwl_scan_req_umac_tail
+ */
+struct iwl_scan_req_umac {
+	struct iwl_mvm_umac_cmd_hdr hdr;
+	__le32 flags;
+	__le32 uid;
+	__le32 ooc_priority;
+	/* SCAN_GENERAL_PARAMS_API_S_VER_1 */
+	__le32 general_flags;
+	u8 reserved1;
+	u8 active_dwell;
+	u8 passive_dwell;
+	u8 fragmented_dwell;
+	__le32 max_out_time;
+	__le32 suspend_time;
+	__le32 scan_priority;
+	/* SCAN_CHANNEL_PARAMS_API_S_VER_1 */
+	u8 channel_flags;
+	u8 n_channels;
+	__le16 reserved2;
+	u8 data[];
+} __packed; /* SCAN_REQUEST_CMD_UMAC_API_S_VER_1 */
+
+/**
+ * struct iwl_umac_scan_abort
+ * @hdr: umac command header
+ * @uid: scan id, &enum iwl_umac_scan_uid_offsets
+ * @flags: reserved
+ */
+struct iwl_umac_scan_abort {
+	struct iwl_mvm_umac_cmd_hdr hdr;
+	__le32 uid;
+	__le32 flags;
+} __packed; /* SCAN_ABORT_CMD_UMAC_API_S_VER_1 */
+
+/**
+ * struct iwl_umac_scan_complete
+ * @uid: scan id, &enum iwl_umac_scan_uid_offsets
+ * @last_schedule: last scheduling line
+ * @last_iter:	last scan iteration number
+ * @scan status: &enum iwl_scan_offload_complete_status
+ * @ebs_status: &enum iwl_scan_ebs_status
+ * @time_from_last_iter: time elapsed from last iteration
+ * @reserved: for future use
+ */
+struct iwl_umac_scan_complete {
+	__le32 uid;
+	u8 last_schedule;
+	u8 last_iter;
+	u8 status;
+	u8 ebs_status;
+	__le32 time_from_last_iter;
+	__le32 reserved;
+} __packed; /* SCAN_COMPLETE_NTF_UMAC_API_S_VER_1 */
+
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index c62575d..1a67788 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -106,6 +106,12 @@ enum {
 	DBG_CFG = 0x9,
 	ANTENNA_COUPLING_NOTIFICATION = 0xa,
 
+	/* UMAC scan commands */
+	SCAN_CFG_CMD = 0xc,
+	SCAN_REQ_UMAC = 0xd,
+	SCAN_ABORT_UMAC = 0xe,
+	SCAN_COMPLETE_UMAC = 0xf,
+
 	/* station table */
 	ADD_STA_KEY = 0x17,
 	ADD_STA = 0x18,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index f12b43d..b4f244f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -505,6 +505,12 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		goto error;
 
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+		ret = iwl_mvm_config_scan(mvm);
+		if (ret)
+			goto error;
+	}
+
 	/* allow FW/transport low power modes if not during restart */
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
 		iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e3259b6..79ad695 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -343,7 +343,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 	}
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN ||
+	    mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
 		hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
 
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
@@ -1935,9 +1936,11 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 	    req->n_channels > mvm->fw->ucode_capa.n_scan_channels)
 		return -EINVAL;
 
-	ret = iwl_mvm_cancel_scan_wait_notif(mvm, IWL_MVM_SCAN_SCHED);
-	if (ret)
-		return ret;
+	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
+		ret = iwl_mvm_cancel_scan_wait_notif(mvm, IWL_MVM_SCAN_SCHED);
+		if (ret)
+			return ret;
+	}
 
 	mutex_lock(&mvm->mutex);
 
@@ -1950,6 +1953,8 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
 		ret = iwl_mvm_unified_scan_lmac(mvm, vif, hw_req);
+	else if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		ret = iwl_mvm_scan_umac(mvm, vif, hw_req);
 	else
 		ret = iwl_mvm_scan_request(mvm, vif, req);
 
@@ -2247,9 +2252,11 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 
-	ret = iwl_mvm_cancel_scan_wait_notif(mvm, IWL_MVM_SCAN_OS);
-	if (ret)
-		return ret;
+	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
+		ret = iwl_mvm_cancel_scan_wait_notif(mvm, IWL_MVM_SCAN_OS);
+		if (ret)
+			return ret;
+	}
 
 	mutex_lock(&mvm->mutex);
 
@@ -2269,11 +2276,10 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	mvm->scan_status = IWL_MVM_SCAN_SCHED;
-
 	ret = iwl_mvm_scan_offload_start(mvm, vif, req, ies);
 	if (ret)
 		mvm->scan_status = IWL_MVM_SCAN_NONE;
+
 out:
 	mutex_unlock(&mvm->mutex);
 	return ret;
@@ -2291,6 +2297,7 @@ static int iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
 	iwl_mvm_wait_for_async_handlers(mvm);
 
 	return ret;
+
 }
 
 static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 09b49b4..cbfba80 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -588,6 +588,10 @@ struct iwl_mvm {
 	void *scan_cmd;
 	struct iwl_mcast_filter_cmd *mcast_filter_cmd;
 
+	/* UMAC scan tracking */
+	u32 scan_uid[IWL_MVM_MAX_SIMULTANEOUS_SCANS];
+	u8 scan_seq_num, sched_scan_seq_num;
+
 	/* rx chain antennas set through debugfs for the scan command */
 	u8 scan_rx_ant;
 
@@ -943,6 +947,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 			  struct ieee80211_vif *disabled_vif);
 
 /* Scanning */
+int iwl_mvm_scan_size(struct iwl_mvm *mvm);
 int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 			 struct ieee80211_vif *vif,
 			 struct cfg80211_scan_request *req);
@@ -983,6 +988,17 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 				    struct cfg80211_sched_scan_request *req,
 				    struct ieee80211_scan_ies *ies);
 
+/* UMAC scan */
+int iwl_mvm_config_scan(struct iwl_mvm *mvm);
+int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+		      struct ieee80211_scan_request *req);
+int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			    struct cfg80211_sched_scan_request *req,
+			    struct ieee80211_scan_ies *ies);
+int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
+					struct iwl_rx_cmd_buffer *rxb,
+					struct iwl_device_cmd *cmd);
+
 /* MVM debugfs */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 53a5a29..5ab10fb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -244,6 +244,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   iwl_mvm_rx_scan_offload_complete_notif, true),
 	RX_HANDLER(MATCH_FOUND_NOTIFICATION, iwl_mvm_rx_scan_offload_results,
 		   false),
+	RX_HANDLER(SCAN_COMPLETE_UMAC, iwl_mvm_rx_umac_scan_complete_notif,
+		   true),
 
 	RX_HANDLER(RADIO_VERSION_NOTIFICATION, iwl_mvm_rx_radio_ver, false),
 	RX_HANDLER(CARD_STATE_NOTIFICATION, iwl_mvm_rx_card_state_notif, false),
@@ -346,6 +348,10 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION),
 	CMD(ANTENNA_COUPLING_NOTIFICATION),
 	CMD(SCD_QUEUE_CFG),
+	CMD(SCAN_CFG_CMD),
+	CMD(SCAN_REQ_UMAC),
+	CMD(SCAN_ABORT_UMAC),
+	CMD(SCAN_COMPLETE_UMAC),
 };
 #undef CMD
 
@@ -537,16 +543,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		}
 	}
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
-		scan_size = sizeof(struct iwl_scan_req_unified_lmac) +
-			sizeof(struct iwl_scan_channel_cfg_lmac) *
-				mvm->fw->ucode_capa.n_scan_channels +
-			sizeof(struct iwl_scan_probe_req);
-	else
-		scan_size = sizeof(struct iwl_scan_cmd) +
-			mvm->fw->ucode_capa.max_probe_length +
-			mvm->fw->ucode_capa.n_scan_channels *
-				sizeof(struct iwl_scan_channel);
+	scan_size = iwl_mvm_scan_size(mvm);
 
 	mvm->scan_cmd = kmalloc(scan_size, GFP_KERNEL);
 	if (!mvm->scan_cmd)
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 8a1f4a8..c440b7b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -83,15 +83,29 @@ struct iwl_mvm_scan_params {
 	} dwell[IEEE80211_NUM_BANDS];
 };
 
+enum iwl_umac_scan_uid_type {
+	IWL_UMAC_SCAN_UID_REG_SCAN	= BIT(0),
+	IWL_UMAC_SCAN_UID_SCHED_SCAN	= BIT(1),
+	IWL_UMAC_SCAN_UID_ALL		= IWL_UMAC_SCAN_UID_REG_SCAN |
+					  IWL_UMAC_SCAN_UID_SCHED_SCAN,
+};
+
+static int iwl_umac_scan_stop(struct iwl_mvm *mvm,
+			      enum iwl_umac_scan_uid_type type, bool notify);
+
+static u8 iwl_mvm_scan_rx_ant(struct iwl_mvm *mvm)
+{
+	if (mvm->scan_rx_ant != ANT_NONE)
+		return mvm->scan_rx_ant;
+	return mvm->fw->valid_rx_ant;
+}
+
 static inline __le16 iwl_mvm_scan_rx_chain(struct iwl_mvm *mvm)
 {
 	u16 rx_chain;
 	u8 rx_ant;
 
-	if (mvm->scan_rx_ant != ANT_NONE)
-		rx_ant = mvm->scan_rx_ant;
-	else
-		rx_ant = mvm->fw->valid_rx_ant;
+	rx_ant = iwl_mvm_scan_rx_ant(mvm);
 	rx_chain = rx_ant << PHY_RX_CHAIN_VALID_POS;
 	rx_chain |= rx_ant << PHY_RX_CHAIN_FORCE_MIMO_SEL_POS;
 	rx_chain |= rx_ant << PHY_RX_CHAIN_FORCE_SEL_POS;
@@ -541,23 +555,17 @@ int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
 				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u8 client_bitmap = 0;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
+	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
+	    !(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
 		struct iwl_sched_scan_results *notif = (void *)pkt->data;
 
-		client_bitmap = notif->client_bitmap;
+		if (!(notif->client_bitmap & SCAN_CLIENT_SCHED_SCAN))
+			return 0;
 	}
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN ||
-	    client_bitmap & SCAN_CLIENT_SCHED_SCAN) {
-		if (mvm->scan_status == IWL_MVM_SCAN_SCHED) {
-			IWL_DEBUG_SCAN(mvm, "Scheduled scan results\n");
-			ieee80211_sched_scan_results(mvm->hw);
-		} else {
-			IWL_DEBUG_SCAN(mvm, "Scan results\n");
-		}
-	}
+	IWL_DEBUG_SCAN(mvm, "Scheduled scan results\n");
+	ieee80211_sched_scan_results(mvm->hw);
 
 	return 0;
 }
@@ -969,6 +977,20 @@ free_blacklist:
 	return ret;
 }
 
+static bool iwl_mvm_scan_pass_all(struct iwl_mvm *mvm,
+				  struct cfg80211_sched_scan_request *req)
+{
+	if (req->n_match_sets && req->match_sets[0].ssid.ssid_len) {
+		IWL_DEBUG_SCAN(mvm,
+			       "Sending scheduled scan with filtering, n_match_sets %d\n",
+			       req->n_match_sets);
+		return false;
+	}
+
+	IWL_DEBUG_SCAN(mvm, "Sending Scheduled scan without filtering\n");
+	return true;
+}
+
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct cfg80211_sched_scan_request *req)
 {
@@ -984,15 +1006,8 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		.schedule_line[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER,
 	};
 
-	if (req->n_match_sets && req->match_sets[0].ssid.ssid_len) {
-		IWL_DEBUG_SCAN(mvm,
-			       "Sending scheduled scan with filtering, filter len %d\n",
-			       req->n_match_sets);
-	} else {
-		IWL_DEBUG_SCAN(mvm,
-			       "Sending Scheduled scan without filtering\n");
+	if (iwl_mvm_scan_pass_all(mvm, req))
 		scan_req.flags |= cpu_to_le16(IWL_SCAN_OFFLOAD_FLAG_PASS_ALL);
-	}
 
 	if (mvm->last_ebs_successful &&
 	    mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT)
@@ -1011,11 +1026,18 @@ int iwl_mvm_scan_offload_start(struct iwl_mvm *mvm,
 	int ret;
 
 	if ((mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
+		mvm->scan_status = IWL_MVM_SCAN_SCHED;
 		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 		if (ret)
 			return ret;
 		ret = iwl_mvm_unified_sched_scan_lmac(mvm, vif, req, ies);
+	} else if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
+		if (ret)
+			return ret;
+		ret = iwl_mvm_sched_scan_umac(mvm, vif, req, ies);
 	} else {
+		mvm->scan_status = IWL_MVM_SCAN_SCHED;
 		ret = iwl_mvm_config_sched_scan(mvm, vif, req, ies);
 		if (ret)
 			return ret;
@@ -1072,6 +1094,10 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		return iwl_umac_scan_stop(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN,
+					  notify);
+
 	if (mvm->scan_status != IWL_MVM_SCAN_SCHED &&
 	    (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) ||
 	     mvm->scan_status != IWL_MVM_SCAN_OS)) {
@@ -1198,11 +1224,8 @@ static u8 *iwl_mvm_copy_and_insert_ds_elem(struct iwl_mvm *mvm, const u8 *ies,
 static void
 iwl_mvm_build_unified_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				 struct ieee80211_scan_ies *ies,
-				 struct iwl_scan_req_unified_lmac *cmd)
+				 struct iwl_scan_probe_req *preq)
 {
-	struct iwl_scan_probe_req *preq = (void *)(cmd->data +
-		sizeof(struct iwl_scan_channel_cfg_lmac) *
-			mvm->fw->ucode_capa.n_scan_channels);
 	struct ieee80211_mgmt *frame = (struct ieee80211_mgmt *)preq->buf;
 	u8 *pos, *newpos;
 
@@ -1287,6 +1310,7 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
 	};
 	struct iwl_scan_req_unified_lmac *cmd = mvm->scan_cmd;
+	struct iwl_scan_probe_req *preq;
 	struct iwl_mvm_scan_params params = {};
 	u32 flags;
 	int ssid_bitmap = 0;
@@ -1348,7 +1372,10 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 				       req->req.n_channels, ssid_bitmap,
 				       cmd);
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, cmd);
+	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
+			mvm->fw->ucode_capa.n_scan_channels);
+
+	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, preq);
 
 	ret = iwl_mvm_send_cmd(mvm, &hcmd);
 	if (!ret) {
@@ -1381,6 +1408,7 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
 	};
 	struct iwl_scan_req_unified_lmac *cmd = mvm->scan_cmd;
+	struct iwl_scan_probe_req *preq;
 	struct iwl_mvm_scan_params params = {};
 	int ret;
 	u32 flags = 0, ssid_bitmap = 0;
@@ -1404,15 +1432,8 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 
 	cmd->n_channels = (u8)req->n_channels;
 
-	if (req->n_match_sets && req->match_sets[0].ssid.ssid_len) {
-		IWL_DEBUG_SCAN(mvm,
-			       "Sending scheduled scan with filtering, n_match_sets %d\n",
-			       req->n_match_sets);
-	} else {
-		IWL_DEBUG_SCAN(mvm,
-			       "Sending Scheduled scan without filtering\n");
+	if (iwl_mvm_scan_pass_all(mvm, req))
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
-	}
 
 	if (req->n_ssids == 1 && req->ssids[0].ssid_len != 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
@@ -1442,7 +1463,10 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 	iwl_mvm_lmac_scan_cfg_channels(mvm, req->channels, req->n_channels,
 				       ssid_bitmap, cmd);
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, cmd);
+	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
+			mvm->fw->ucode_capa.n_scan_channels);
+
+	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, preq);
 
 	ret = iwl_mvm_send_cmd(mvm, &hcmd);
 	if (!ret) {
@@ -1464,6 +1488,10 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 
 int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 {
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		return iwl_umac_scan_stop(mvm, IWL_UMAC_SCAN_UID_REG_SCAN,
+					  true);
+
 	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
 		return 0;
 
@@ -1478,3 +1506,568 @@ int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 		return iwl_mvm_scan_offload_stop(mvm, true);
 	return iwl_mvm_cancel_regular_scan(mvm);
 }
+
+/* UMAC scan API */
+
+struct iwl_umac_scan_done {
+	struct iwl_mvm *mvm;
+	enum iwl_umac_scan_uid_type type;
+};
+
+static int rate_to_scan_rate_flag(unsigned int rate)
+{
+	static const int rate_to_scan_rate[IWL_RATE_COUNT] = {
+		[IWL_RATE_1M_INDEX]	= SCAN_CONFIG_RATE_1M,
+		[IWL_RATE_2M_INDEX]	= SCAN_CONFIG_RATE_2M,
+		[IWL_RATE_5M_INDEX]	= SCAN_CONFIG_RATE_5M,
+		[IWL_RATE_11M_INDEX]	= SCAN_CONFIG_RATE_11M,
+		[IWL_RATE_6M_INDEX]	= SCAN_CONFIG_RATE_6M,
+		[IWL_RATE_9M_INDEX]	= SCAN_CONFIG_RATE_9M,
+		[IWL_RATE_12M_INDEX]	= SCAN_CONFIG_RATE_12M,
+		[IWL_RATE_18M_INDEX]	= SCAN_CONFIG_RATE_18M,
+		[IWL_RATE_24M_INDEX]	= SCAN_CONFIG_RATE_24M,
+		[IWL_RATE_36M_INDEX]	= SCAN_CONFIG_RATE_36M,
+		[IWL_RATE_48M_INDEX]	= SCAN_CONFIG_RATE_48M,
+		[IWL_RATE_54M_INDEX]	= SCAN_CONFIG_RATE_54M,
+	};
+
+	return rate_to_scan_rate[rate];
+}
+
+static __le32 iwl_mvm_scan_config_rates(struct iwl_mvm *mvm)
+{
+	struct ieee80211_supported_band *band;
+	unsigned int rates = 0;
+	int i;
+
+	band = &mvm->nvm_data->bands[IEEE80211_BAND_2GHZ];
+	for (i = 0; i < band->n_bitrates; i++)
+		rates |= rate_to_scan_rate_flag(band->bitrates[i].hw_value);
+	band = &mvm->nvm_data->bands[IEEE80211_BAND_5GHZ];
+	for (i = 0; i < band->n_bitrates; i++)
+		rates |= rate_to_scan_rate_flag(band->bitrates[i].hw_value);
+
+	/* Set both basic rates and supported rates */
+	rates |= SCAN_CONFIG_SUPPORTED_RATE(rates);
+
+	return cpu_to_le32(rates);
+}
+
+int iwl_mvm_config_scan(struct iwl_mvm *mvm)
+{
+
+	struct iwl_scan_config *scan_config;
+	struct ieee80211_supported_band *band;
+	int num_channels =
+		mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels +
+		mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
+	int ret, i, j = 0, cmd_size, data_size;
+	struct iwl_host_cmd cmd = {
+		.id = SCAN_CFG_CMD,
+	};
+
+	if (WARN_ON(num_channels > mvm->fw->ucode_capa.n_scan_channels))
+		return -ENOBUFS;
+
+	cmd_size = sizeof(*scan_config) + mvm->fw->ucode_capa.n_scan_channels;
+
+	scan_config = kzalloc(cmd_size, GFP_KERNEL);
+	if (!scan_config)
+		return -ENOMEM;
+
+	data_size = cmd_size - sizeof(struct iwl_mvm_umac_cmd_hdr);
+	scan_config->hdr.size = cpu_to_le16(data_size);
+	scan_config->flags = cpu_to_le32(SCAN_CONFIG_FLAG_ACTIVATE |
+					 SCAN_CONFIG_FLAG_ALLOW_CHUB_REQS |
+					 SCAN_CONFIG_FLAG_SET_TX_CHAINS |
+					 SCAN_CONFIG_FLAG_SET_RX_CHAINS |
+					 SCAN_CONFIG_FLAG_SET_ALL_TIMES |
+					 SCAN_CONFIG_FLAG_SET_LEGACY_RATES |
+					 SCAN_CONFIG_FLAG_SET_MAC_ADDR |
+					 SCAN_CONFIG_FLAG_SET_CHANNEL_FLAGS|
+					 SCAN_CONFIG_N_CHANNELS(num_channels));
+	scan_config->tx_chains = cpu_to_le32(mvm->fw->valid_tx_ant);
+	scan_config->rx_chains = cpu_to_le32(iwl_mvm_scan_rx_ant(mvm));
+	scan_config->legacy_rates = iwl_mvm_scan_config_rates(mvm);
+	scan_config->out_of_channel_time = cpu_to_le32(170);
+	scan_config->suspend_time = cpu_to_le32(30);
+	scan_config->dwell_active = 20;
+	scan_config->dwell_passive = 110;
+	scan_config->dwell_fragmented = 20;
+
+	memcpy(&scan_config->mac_addr, &mvm->addresses[0].addr, ETH_ALEN);
+
+	scan_config->bcast_sta_id = mvm->aux_sta.sta_id;
+	scan_config->channel_flags = IWL_CHANNEL_FLAG_EBS |
+				     IWL_CHANNEL_FLAG_ACCURATE_EBS |
+				     IWL_CHANNEL_FLAG_EBS_ADD |
+				     IWL_CHANNEL_FLAG_PRE_SCAN_PASSIVE2ACTIVE;
+
+	band = &mvm->nvm_data->bands[IEEE80211_BAND_2GHZ];
+	for (i = 0; i < band->n_channels; i++, j++)
+		scan_config->channel_array[j] = band->channels[i].center_freq;
+	band = &mvm->nvm_data->bands[IEEE80211_BAND_5GHZ];
+	for (i = 0; i < band->n_channels; i++, j++)
+		scan_config->channel_array[j] = band->channels[i].center_freq;
+
+	cmd.data[0] = scan_config;
+	cmd.len[0] = cmd_size;
+	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
+
+	IWL_DEBUG_SCAN(mvm, "Sending UMAC scan config\n");
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+
+	kfree(scan_config);
+	return ret;
+}
+
+static int iwl_mvm_find_scan_uid(struct iwl_mvm *mvm, u32 uid)
+{
+	int i;
+
+	for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++)
+		if (mvm->scan_uid[i] == uid)
+			return i;
+
+	return i;
+}
+
+static int iwl_mvm_find_free_scan_uid(struct iwl_mvm *mvm)
+{
+	return iwl_mvm_find_scan_uid(mvm, 0);
+}
+
+static bool iwl_mvm_find_scan_type(struct iwl_mvm *mvm,
+				   enum iwl_umac_scan_uid_type type)
+{
+	int i;
+
+	for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++)
+		if (mvm->scan_uid[i] & type)
+			return true;
+
+	return false;
+}
+
+static u32 iwl_generate_scan_uid(struct iwl_mvm *mvm,
+				 enum iwl_umac_scan_uid_type type)
+{
+	u32 uid;
+
+	/* make sure exactly one bit is on in scan type */
+	WARN_ON(hweight8(type) != 1);
+
+	/*
+	 * Make sure scan uids are unique. If one scan lasts long time while
+	 * others are completing frequently, the seq number will wrap up and
+	 * we may have more than one scan with the same uid.
+	 */
+	do {
+		uid = type | (mvm->scan_seq_num <<
+			      IWL_UMAC_SCAN_UID_SEQ_OFFSET);
+		mvm->scan_seq_num++;
+	} while (iwl_mvm_find_scan_uid(mvm, uid) <
+		 IWL_MVM_MAX_SIMULTANEOUS_SCANS);
+
+	IWL_DEBUG_SCAN(mvm, "Generated scan UID %u\n", uid);
+
+	return uid;
+}
+
+static void
+iwl_mvm_build_generic_umac_scan_cmd(struct iwl_mvm *mvm,
+				    struct iwl_scan_req_umac *cmd,
+				    struct iwl_mvm_scan_params *params)
+{
+	memset(cmd, 0, ksize(cmd));
+	cmd->hdr.size = cpu_to_le16(iwl_mvm_scan_size(mvm) -
+				    sizeof(struct iwl_mvm_umac_cmd_hdr));
+	cmd->active_dwell = params->dwell[IEEE80211_BAND_2GHZ].active;
+	cmd->passive_dwell = params->dwell[IEEE80211_BAND_2GHZ].passive;
+	if (params->passive_fragmented)
+		cmd->fragmented_dwell =
+				params->dwell[IEEE80211_BAND_2GHZ].passive;
+	cmd->max_out_time = cpu_to_le32(params->max_out_time);
+	cmd->suspend_time = cpu_to_le32(params->suspend_time);
+	cmd->scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+}
+
+static void
+iwl_mvm_umac_scan_cfg_channels(struct iwl_mvm *mvm,
+			       struct ieee80211_channel **channels,
+			       int n_channels, u32 ssid_bitmap,
+			       struct iwl_scan_req_umac *cmd)
+{
+	struct iwl_scan_channel_cfg_umac *channel_cfg = (void *)&cmd->data;
+	int i;
+
+	for (i = 0; i < n_channels; i++) {
+		channel_cfg[i].flags = cpu_to_le32(ssid_bitmap);
+		channel_cfg[i].channel_num = channels[i]->hw_value;
+		channel_cfg[i].iter_count = 1;
+		channel_cfg[i].iter_interval = 0;
+	}
+}
+
+static u32 iwl_mvm_scan_umac_common_flags(struct iwl_mvm *mvm, int n_ssids,
+					  struct cfg80211_ssid *ssids,
+					  int fragmented)
+{
+	int flags = 0;
+
+	if (n_ssids == 0)
+		flags = IWL_UMAC_SCAN_GEN_FLAGS_PASSIVE;
+
+	if (n_ssids == 1 && ssids[0].ssid_len != 0)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PRE_CONNECT;
+
+	if (fragmented)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED;
+
+	if (iwl_mvm_rrm_scan_needed(mvm))
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_RRM_ENABLED;
+
+	return flags;
+}
+
+int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+		      struct ieee80211_scan_request *req)
+{
+	struct iwl_host_cmd hcmd = {
+		.id = SCAN_REQ_UMAC,
+		.len = { iwl_mvm_scan_size(mvm), },
+		.data = { mvm->scan_cmd, },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+	};
+	struct iwl_scan_req_umac *cmd = mvm->scan_cmd;
+	struct iwl_scan_req_umac_tail *sec_part = (void *)&cmd->data +
+		sizeof(struct iwl_scan_channel_cfg_umac) *
+			mvm->fw->ucode_capa.n_scan_channels;
+	struct iwl_mvm_scan_params params = {};
+	u32 uid, flags;
+	int ssid_bitmap = 0;
+	int ret, i, uid_idx;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	uid_idx = iwl_mvm_find_free_scan_uid(mvm);
+	if (uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS)
+		return -EBUSY;
+
+	/* we should have failed registration if scan_cmd was NULL */
+	if (WARN_ON(mvm->scan_cmd == NULL))
+		return -ENOMEM;
+
+	if (WARN_ON(req->req.n_ssids > PROBE_OPTION_MAX ||
+		    req->ies.common_ie_len +
+		    req->ies.len[NL80211_BAND_2GHZ] +
+		    req->ies.len[NL80211_BAND_5GHZ] + 24 + 2 >
+		    SCAN_OFFLOAD_PROBE_REQ_SIZE || req->req.n_channels >
+		    mvm->fw->ucode_capa.n_scan_channels))
+		return -ENOBUFS;
+
+	iwl_mvm_scan_calc_params(mvm, vif, req->req.n_ssids, req->req.flags,
+				 &params);
+
+	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, &params);
+
+	uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
+	mvm->scan_uid[uid_idx] = uid;
+	cmd->uid = cpu_to_le32(uid);
+
+	cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+
+	flags = iwl_mvm_scan_umac_common_flags(mvm, req->req.n_ssids,
+					       req->req.ssids,
+					       params.passive_fragmented);
+
+	flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
+
+	cmd->general_flags = cpu_to_le32(flags);
+	cmd->n_channels = req->req.n_channels;
+
+	for (i = 0; i < req->req.n_ssids; i++)
+		ssid_bitmap |= BIT(i);
+
+	iwl_mvm_umac_scan_cfg_channels(mvm, req->req.channels,
+				       req->req.n_channels, ssid_bitmap, cmd);
+
+	sec_part->schedule[0].iter_count = 1;
+	sec_part->delay = 0;
+
+	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, &sec_part->preq);
+
+	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, req->req.ssids,
+				req->req.n_ssids, 0);
+
+	ret = iwl_mvm_send_cmd(mvm, &hcmd);
+	if (!ret) {
+		IWL_DEBUG_SCAN(mvm,
+			       "Scan request was sent successfully\n");
+	} else {
+		/*
+		 * If the scan failed, it usually means that the FW was unable
+		 * to allocate the time events. Warn on it, but maybe we
+		 * should try to send the command again with different params.
+		 */
+		IWL_ERR(mvm, "Scan failed! ret %d\n", ret);
+	}
+	return ret;
+}
+
+int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			    struct cfg80211_sched_scan_request *req,
+			    struct ieee80211_scan_ies *ies)
+{
+
+	struct iwl_host_cmd hcmd = {
+		.id = SCAN_REQ_UMAC,
+		.len = { iwl_mvm_scan_size(mvm), },
+		.data = { mvm->scan_cmd, },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+	};
+	struct iwl_scan_req_umac *cmd = mvm->scan_cmd;
+	struct iwl_scan_req_umac_tail *sec_part = (void *)&cmd->data +
+		sizeof(struct iwl_scan_channel_cfg_umac) *
+			mvm->fw->ucode_capa.n_scan_channels;
+	struct iwl_mvm_scan_params params = {};
+	u32 uid, flags;
+	int ssid_bitmap = 0;
+	int ret, uid_idx;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	uid_idx = iwl_mvm_find_free_scan_uid(mvm);
+	if (uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS)
+		return -EBUSY;
+
+	/* we should have failed registration if scan_cmd was NULL */
+	if (WARN_ON(mvm->scan_cmd == NULL))
+		return -ENOMEM;
+
+	if (WARN_ON(req->n_ssids > PROBE_OPTION_MAX ||
+		    ies->common_ie_len + ies->len[NL80211_BAND_2GHZ] +
+		    ies->len[NL80211_BAND_5GHZ] + 24 + 2 >
+		    SCAN_OFFLOAD_PROBE_REQ_SIZE || req->n_channels >
+		    mvm->fw->ucode_capa.n_scan_channels))
+		return -ENOBUFS;
+
+	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
+					 &params);
+
+	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, &params);
+
+	cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
+
+	uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN);
+	mvm->scan_uid[uid_idx] = uid;
+	cmd->uid = cpu_to_le32(uid);
+
+	cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
+
+	flags = iwl_mvm_scan_umac_common_flags(mvm, req->n_ssids, req->ssids,
+					       params.passive_fragmented);
+
+	flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
+
+	if (iwl_mvm_scan_pass_all(mvm, req))
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
+	else
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_MATCH;
+
+	cmd->general_flags = cpu_to_le32(flags);
+
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT &&
+	    mvm->last_ebs_successful)
+		cmd->channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
+				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
+				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
+
+	cmd->n_channels = req->n_channels;
+
+	iwl_scan_offload_build_ssid(req, sec_part->direct_scan, &ssid_bitmap,
+				    false);
+
+	/* This API uses bits 0-19 instead of 1-20. */
+	ssid_bitmap = ssid_bitmap >> 1;
+
+	iwl_mvm_umac_scan_cfg_channels(mvm, req->channels, req->n_channels,
+				       ssid_bitmap, cmd);
+
+	sec_part->schedule[0].interval =
+				cpu_to_le16(req->interval / MSEC_PER_SEC);
+	sec_part->schedule[0].iter_count = 0xff;
+
+	sec_part->delay = 0;
+
+	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, &sec_part->preq);
+
+	ret = iwl_mvm_send_cmd(mvm, &hcmd);
+	if (!ret) {
+		IWL_DEBUG_SCAN(mvm,
+			       "Sched scan request was sent successfully\n");
+	} else {
+		/*
+		 * If the scan failed, it usually means that the FW was unable
+		 * to allocate the time events. Warn on it, but maybe we
+		 * should try to send the command again with different params.
+		 */
+		IWL_ERR(mvm, "Sched scan failed! ret %d\n", ret);
+	}
+	return ret;
+}
+
+int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
+					struct iwl_rx_cmd_buffer *rxb,
+					struct iwl_device_cmd *cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_umac_scan_complete *notif = (void *)pkt->data;
+	u32 uid = __le32_to_cpu(notif->uid);
+	bool sched = !!(uid & IWL_UMAC_SCAN_UID_SCHED_SCAN);
+	int uid_idx = iwl_mvm_find_scan_uid(mvm, uid);
+
+	if (WARN(uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS,
+		 "Scan notification for uknown scan ID\n"))
+		return 0;
+
+	IWL_DEBUG_SCAN(mvm,
+		       "Scan completed, uid %u type %s, status %s, EBS status %s\n",
+		       uid, sched ? "sched" : "regular",
+		       notif->status == IWL_SCAN_OFFLOAD_COMPLETED ?
+				"completed" : "aborted",
+		       notif->ebs_status == IWL_SCAN_EBS_SUCCESS ?
+				"success" : "failed");
+
+	mvm->last_ebs_successful = !notif->ebs_status;
+	mvm->scan_uid[uid_idx] = 0;
+
+	if (!sched) {
+		ieee80211_scan_completed(mvm->hw,
+					 notif->status ==
+						IWL_SCAN_OFFLOAD_ABORTED);
+		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+	} else if (!iwl_mvm_find_scan_type(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN)) {
+		ieee80211_sched_scan_stopped(mvm->hw);
+	} else {
+		IWL_DEBUG_SCAN(mvm, "Another sched scan is running\n");
+	}
+
+	return 0;
+}
+
+static bool iwl_scan_umac_done_check(struct iwl_notif_wait_data *notif_wait,
+				     struct iwl_rx_packet *pkt, void *data)
+{
+	struct iwl_umac_scan_done *scan_done = data;
+	struct iwl_umac_scan_complete *notif = (void *)pkt->data;
+	u32 uid = __le32_to_cpu(notif->uid);
+	int uid_idx = iwl_mvm_find_scan_uid(scan_done->mvm, uid);
+
+	if (WARN_ON(pkt->hdr.cmd != SCAN_COMPLETE_UMAC))
+		return false;
+
+	if (uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS)
+		return false;
+
+	/*
+	 * Clear scan uid of scans that was aborted from above and completed
+	 * in FW so the RX handler does nothing.
+	 */
+	scan_done->mvm->scan_uid[uid_idx] = 0;
+
+	return !iwl_mvm_find_scan_type(scan_done->mvm, scan_done->type);
+}
+
+static int iwl_umac_scan_abort_one(struct iwl_mvm *mvm, u32 uid)
+{
+	struct iwl_umac_scan_abort cmd = {
+		.hdr.size = cpu_to_le16(sizeof(struct iwl_umac_scan_abort) -
+					sizeof(struct iwl_mvm_umac_cmd_hdr)),
+		.uid = cpu_to_le32(uid),
+	};
+
+	lockdep_assert_held(&mvm->mutex);
+
+	IWL_DEBUG_SCAN(mvm, "Sending scan abort, uid %u\n", uid);
+
+	return iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_UMAC, 0, sizeof(cmd), &cmd);
+}
+
+static int iwl_umac_scan_stop(struct iwl_mvm *mvm,
+			      enum iwl_umac_scan_uid_type type, bool notify)
+{
+	struct iwl_notification_wait wait_scan_done;
+	static const u8 scan_done_notif[] = { SCAN_COMPLETE_UMAC, };
+	struct iwl_umac_scan_done scan_done = {
+		.mvm = mvm,
+		.type = type,
+	};
+	int i, ret = -EIO;
+
+	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_done,
+				   scan_done_notif,
+				   ARRAY_SIZE(scan_done_notif),
+				   iwl_scan_umac_done_check, &scan_done);
+
+	IWL_DEBUG_SCAN(mvm, "Preparing to stop scan, type %x\n", type);
+
+	for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++) {
+		if (mvm->scan_uid[i] & type) {
+			int err;
+
+			if (iwl_mvm_is_radio_killed(mvm) &&
+			    (type & IWL_UMAC_SCAN_UID_REG_SCAN)) {
+				ieee80211_scan_completed(mvm->hw, true);
+				iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+				break;
+			}
+
+			err = iwl_umac_scan_abort_one(mvm, mvm->scan_uid[i]);
+			if (!err)
+				ret = 0;
+		}
+	}
+
+	if (ret) {
+		IWL_DEBUG_SCAN(mvm, "Couldn't stop scan\n");
+		iwl_remove_notification(&mvm->notif_wait, &wait_scan_done);
+		return ret;
+	}
+
+	ret = iwl_wait_notification(&mvm->notif_wait, &wait_scan_done, 1 * HZ);
+	if (ret)
+		return ret;
+
+	if (notify) {
+		if (type & IWL_UMAC_SCAN_UID_SCHED_SCAN)
+			ieee80211_sched_scan_stopped(mvm->hw);
+		if (type & IWL_UMAC_SCAN_UID_REG_SCAN) {
+			ieee80211_scan_completed(mvm->hw, true);
+			iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+		}
+	}
+
+	return ret;
+}
+
+int iwl_mvm_scan_size(struct iwl_mvm *mvm)
+{
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		return sizeof(struct iwl_scan_req_umac) +
+			sizeof(struct iwl_scan_channel_cfg_umac) *
+				mvm->fw->ucode_capa.n_scan_channels +
+			sizeof(struct iwl_scan_req_umac_tail);
+
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
+		return sizeof(struct iwl_scan_req_unified_lmac) +
+			sizeof(struct iwl_scan_channel_cfg_lmac) *
+				mvm->fw->ucode_capa.n_scan_channels +
+			sizeof(struct iwl_scan_probe_req);
+
+	return sizeof(struct iwl_scan_cmd) +
+		mvm->fw->ucode_capa.max_probe_length +
+			mvm->fw->ucode_capa.n_scan_channels *
+		sizeof(struct iwl_scan_channel);
+}
-- 
1.9.1

