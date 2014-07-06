Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:59379 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaGFJgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:54 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so3074455wes.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:52 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/40] iwlwifi: mvm: add unified LMAC scan API
Date: Sun,  6 Jul 2014 12:35:56 +0300
Message-Id: <1404639376-3792-20-git-send-email-egrumbach@gmail.com> (sfid-20140706_115953_769111_805B3C5D)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Add new scan API that uses the same command 0x51 for both regular and
sched scan.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h          |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 207 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h      |   1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  29 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  19 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c         |  18 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 447 ++++++++++++++++++++++---
 7 files changed, 653 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 79b0508..1bb5193 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -124,6 +124,7 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_BT_COEX_SPLIT: new API for BT Coex
  * @IWL_UCODE_TLV_API_CSA_FLOW: ucode can do unbind-bind flow for CSA.
  * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
+ * @IWL_UCODE_TLV_API_LMAC_SCAN: This ucode uses LMAC unified scan API.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
@@ -131,6 +132,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
 	IWL_UCODE_TLV_API_CSA_FLOW		= BIT(4),
 	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
+	IWL_UCODE_TLV_API_LMAC_SCAN		= BIT(6),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 1d58692..48a1d8f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -582,4 +582,211 @@ struct iwl_sched_scan_results {
 	u8 reserved;
 };
 
+/* Unified LMAC scan API */
+
+#define IWL_MVM_BASIC_PASSIVE_DWELL 110
+
+/**
+ * iwl_scan_req_tx_cmd - SCAN_REQ_TX_CMD_API_S
+ * @tx_flags: combination of TX_CMD_FLG_*
+ * @rate_n_flags: rate for *all* Tx attempts, if TX_CMD_FLG_STA_RATE_MSK is
+ *	cleared. Combination of RATE_MCS_*
+ * @sta_id: index of destination station in FW station table
+ * @reserved: for alignment and future use
+ */
+struct iwl_scan_req_tx_cmd {
+	__le32 tx_flags;
+	__le32 rate_n_flags;
+	u8 sta_id;
+	u8 reserved[3];
+} __packed;
+
+enum iwl_scan_channel_flags_lmac {
+	IWL_UNIFIED_SCAN_CHANNEL_FULL		= BIT(27),
+	IWL_UNIFIED_SCAN_CHANNEL_PARTIAL	= BIT(28),
+};
+
+/**
+ * iwl_scan_channel_cfg_lmac - SCAN_CHANNEL_CFG_S_VER2
+ * @flags:		bits 1-20: directed scan to i'th ssid
+ *			other bits &enum iwl_scan_channel_flags_lmac
+ * @channel_number:	channel number 1-13 etc
+ * @iter_count:		scan iteration on this channel
+ * @iter_interval:	interval in seconds between iterations on one channel
+ */
+struct iwl_scan_channel_cfg_lmac {
+	__le32 flags;
+	__le16 channel_num;
+	__le16 iter_count;
+	__le32 iter_interval;
+} __packed;
+
+/*
+ * iwl_scan_probe_segment - PROBE_SEGMENT_API_S_VER_1
+ * @offset: offset in the data block
+ * @len: length of the segment
+ */
+struct iwl_scan_probe_segment {
+	__le16 offset;
+	__le16 len;
+} __packed;
+
+/* iwl_scan_probe_req - PROBE_REQUEST_FRAME_API_S_VER_2
+ * @mac_header: first (and common) part of the probe
+ * @band_data: band specific data
+ * @common_data: last (and common) part of the probe
+ * @buf: raw data block
+ */
+struct iwl_scan_probe_req {
+	struct iwl_scan_probe_segment mac_header;
+	struct iwl_scan_probe_segment band_data[2];
+	struct iwl_scan_probe_segment common_data;
+	u8 buf[SCAN_OFFLOAD_PROBE_REQ_SIZE];
+} __packed;
+
+enum iwl_scan_channel_flags {
+	IWL_SCAN_CHANNEL_FLAG_EBS		= BIT(0),
+	IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE	= BIT(1),
+	IWL_SCAN_CHANNEL_FLAG_CACHE_ADD		= BIT(2),
+};
+
+/* iwl_scan_channel_opt - CHANNEL_OPTIMIZATION_API_S
+ * @flags: enum iwl_scan_channel_flgs
+ * @non_ebs_ratio: how many regular scan iteration before EBS
+ */
+struct iwl_scan_channel_opt {
+	__le16 flags;
+	__le16 non_ebs_ratio;
+} __packed;
+
+/**
+ * iwl_mvm_lmac_scan_flags
+ * @IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL: pass all beacons and probe responses
+ *	without filtering.
+ * @IWL_MVM_LMAC_SCAN_FLAG_PASSIVE: force passive scan on all channels
+ * @IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION: single channel scan
+ * @IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE: send iteration complete notification
+ * @IWL_MVM_LMAC_SCAN_FLAG_MULTIPLE_SSIDS multiple SSID matching
+ * @IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED: all passive scans will be fragmented
+ */
+enum iwl_mvm_lmac_scan_flags {
+	IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL		= BIT(0),
+	IWL_MVM_LMAC_SCAN_FLAG_PASSIVE		= BIT(1),
+	IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION	= BIT(2),
+	IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE	= BIT(3),
+	IWL_MVM_LMAC_SCAN_FLAG_MULTIPLE_SSIDS	= BIT(4),
+	IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED	= BIT(5),
+};
+
+enum iwl_scan_priority {
+	IWL_SCAN_PRIORITY_LOW,
+	IWL_SCAN_PRIORITY_MEDIUM,
+	IWL_SCAN_PRIORITY_HIGH,
+};
+
+/**
+ * iwl_scan_req_unified_lmac - SCAN_REQUEST_CMD_API_S_VER_1
+ * @reserved1: for alignment and future use
+ * @channel_num: num of channels to scan
+ * @active-dwell: dwell time for active channels
+ * @passive-dwell: dwell time for passive channels
+ * @fragmented-dwell: dwell time for fragmented passive scan
+ * @reserved2: for alignment and future use
+ * @rx_chain_selct: PHY_RX_CHAIN_* flags
+ * @scan_flags: &enum iwl_mvm_lmac_scan_flags
+ * @max_out_time: max time (in TU) to be out of associated channel
+ * @suspend_time: pause scan this long (TUs) when returning to service channel
+ * @flags: RXON flags
+ * @filter_flags: RXON filter
+ * @tx_cmd: tx command for active scan; for 2GHz and for 5GHz
+ * @direct_scan: list of SSIDs for directed active scan
+ * @scan_prio: enum iwl_scan_priority
+ * @iter_num: number of scan iterations
+ * @delay: delay in seconds before first iteration
+ * @schedule: two scheduling plans. The first one is finite, the second one can
+ *	be infinite.
+ * @channel_opt: channel optimization options, for full and partial scan
+ * @data: channel configuration and probe request packet.
+ */
+struct iwl_scan_req_unified_lmac {
+	/* SCAN_REQUEST_FIXED_PART_API_S_VER_7 */
+	__le32 reserved1;
+	u8 n_channels;
+	u8 active_dwell;
+	u8 passive_dwell;
+	u8 fragmented_dwell;
+	__le16 reserved2;
+	__le16 rx_chain_select;
+	__le32 scan_flags;
+	__le32 max_out_time;
+	__le32 suspend_time;
+	/* RX_ON_FLAGS_API_S_VER_1 */
+	__le32 flags;
+	__le32 filter_flags;
+	struct iwl_scan_req_tx_cmd tx_cmd[2];
+	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
+	__le32 scan_prio;
+	/* SCAN_REQ_PERIODIC_PARAMS_API_S */
+	__le32 iter_num;
+	__le32 delay;
+	struct iwl_scan_offload_schedule schedule[2];
+	struct iwl_scan_channel_opt channel_opt[2];
+	u8 data[];
+} __packed;
+
+/**
+ * struct iwl_lmac_scan_results_notif - scan results for one channel -
+ *	SCAN_RESULT_NTF_API_S_VER_3
+ * @channel: which channel the results are from
+ * @band: 0 for 5.2 GHz, 1 for 2.4 GHz
+ * @probe_status: SCAN_PROBE_STATUS_*, indicates success of probe request
+ * @num_probe_not_sent: # of request that weren't sent due to not enough time
+ * @duration: duration spent in channel, in usecs
+ */
+struct iwl_lmac_scan_results_notif {
+	u8 channel;
+	u8 band;
+	u8 probe_status;
+	u8 num_probe_not_sent;
+	__le32 duration;
+} __packed;
+
+/**
+ * struct iwl_lmac_scan_complete_notif - notifies end of scanning (all channels)
+ *	SCAN_COMPLETE_NTF_API_S_VER_3
+ * @scanned_channels: number of channels scanned (and number of valid results)
+ * @status: one of SCAN_COMP_STATUS_*
+ * @bt_status: BT on/off status
+ * @last_channel: last channel that was scanned
+ * @tsf_low: TSF timer (lower half) in usecs
+ * @tsf_high: TSF timer (higher half) in usecs
+ * @results: an array of scan results, only "scanned_channels" of them are valid
+ */
+struct iwl_lmac_scan_complete_notif {
+	u8 scanned_channels;
+	u8 status;
+	u8 bt_status;
+	u8 last_channel;
+	__le32 tsf_low;
+	__le32 tsf_high;
+	struct iwl_scan_results_notif results[];
+} __packed;
+
+/**
+ * iwl_scan_offload_complete - PERIODIC_SCAN_COMPLETE_NTF_API_S_VER_2
+ * @last_schedule_line: last schedule line executed (fast or regular)
+ * @last_schedule_iteration: last scan iteration executed before scan abort
+ * @status: enum iwl_scan_offload_complete_status
+ * @ebs_status: EBS success status &enum iwl_scan_ebs_status
+ * @time_after_last_iter; time in seconds elapsed after last iteration
+ */
+struct iwl_periodic_scan_complete {
+	u8 last_schedule_line;
+	u8 last_schedule_iteration;
+	u8 status;
+	u8 ebs_status;
+	__le32 time_after_last_iter;
+	__le32 reserved;
+} __packed;
+
 #endif
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 3983a2b..6c479de 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -135,6 +135,7 @@ enum {
 	SCAN_OFFLOAD_UPDATE_PROFILES_CMD = 0x6E,
 	SCAN_OFFLOAD_CONFIG_CMD = 0x6f,
 	MATCH_FOUND_NOTIFICATION = 0xd9,
+	SCAN_ITERATION_COMPLETE = 0xe7,
 
 	/* Phy */
 	PHY_CONFIGURATION_CMD = 0x6a,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7dde944..522aa03 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -327,6 +327,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 	}
 
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
+		hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
+
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
 	hw->chanctx_data_size = sizeof(u16);
@@ -1658,7 +1661,7 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_lock(&mvm->mutex);
 
 	if (changes & BSS_CHANGED_IDLE && !bss_conf->idle)
-		iwl_mvm_sched_scan_stop(mvm, true);
+		iwl_mvm_scan_offload_stop(mvm, true);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -1692,7 +1695,7 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	switch (mvm->scan_status) {
 	case IWL_MVM_SCAN_SCHED:
-		ret = iwl_mvm_sched_scan_stop(mvm, true);
+		ret = iwl_mvm_scan_offload_stop(mvm, true);
 		if (ret) {
 			ret = -EBUSY;
 			goto out;
@@ -1707,7 +1710,11 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
-	ret = iwl_mvm_scan_request(mvm, vif, req);
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
+		ret = iwl_mvm_unified_scan_lmac(mvm, vif, hw_req);
+	else
+		ret = iwl_mvm_scan_request(mvm, vif, req);
+
 	if (ret)
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 out:
@@ -2008,15 +2015,21 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 
 	mvm->scan_status = IWL_MVM_SCAN_SCHED;
 
-	ret = iwl_mvm_config_sched_scan(mvm, vif, req, ies);
-	if (ret)
-		goto err;
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
+		ret = iwl_mvm_config_sched_scan(mvm, vif, req, ies);
+		if (ret)
+			goto err;
+	}
 
 	ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 	if (ret)
 		goto err;
 
-	ret = iwl_mvm_sched_scan_start(mvm, req);
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
+		ret = iwl_mvm_unified_sched_scan_lmac(mvm, vif, req, ies);
+	else
+		ret = iwl_mvm_sched_scan_start(mvm, req);
+
 	if (!ret)
 		goto out;
 err:
@@ -2035,7 +2048,7 @@ static int iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
 	int ret;
 
 	mutex_lock(&mvm->mutex);
-	ret = iwl_mvm_sched_scan_stop(mvm, false);
+	ret = iwl_mvm_scan_offload_stop(mvm, false);
 	mutex_unlock(&mvm->mutex);
 	iwl_mvm_wait_for_async_handlers(mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index fbe93a1..927346e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -533,7 +533,7 @@ struct iwl_mvm {
 
 	/* Scan status, cmd (pre-allocated) and auxiliary station */
 	enum iwl_scan_status scan_status;
-	struct iwl_scan_cmd *scan_cmd;
+	void *scan_cmd;
 	struct iwl_mcast_filter_cmd *mcast_filter_cmd;
 
 	/* rx chain antennas set through debugfs for the scan command */
@@ -868,10 +868,19 @@ int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 				       struct cfg80211_sched_scan_request *req);
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct cfg80211_sched_scan_request *req);
-int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify);
-int iwl_mvm_rx_sched_scan_results(struct iwl_mvm *mvm,
-				  struct iwl_rx_cmd_buffer *rxb,
-				  struct iwl_device_cmd *cmd);
+int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify);
+int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
+				    struct iwl_rx_cmd_buffer *rxb,
+				    struct iwl_device_cmd *cmd);
+
+/* Unified scan */
+int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_scan_request *req);
+int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif,
+				    struct cfg80211_sched_scan_request *req,
+				    struct ieee80211_scan_ies *ies);
 
 /* MVM debugfs */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index b843870..4e2823f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -233,7 +233,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(SCAN_COMPLETE_NOTIFICATION, iwl_mvm_rx_scan_complete, true),
 	RX_HANDLER(SCAN_OFFLOAD_COMPLETE,
 		   iwl_mvm_rx_scan_offload_complete_notif, true),
-	RX_HANDLER(MATCH_FOUND_NOTIFICATION, iwl_mvm_rx_sched_scan_results,
+	RX_HANDLER(MATCH_FOUND_NOTIFICATION, iwl_mvm_rx_scan_offload_results,
 		   false),
 
 	RX_HANDLER(RADIO_VERSION_NOTIFICATION, iwl_mvm_rx_radio_ver, false),
@@ -284,6 +284,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(SCAN_OFFLOAD_ABORT_CMD),
 	CMD(SCAN_OFFLOAD_COMPLETE),
 	CMD(SCAN_OFFLOAD_UPDATE_PROFILES_CMD),
+	CMD(SCAN_ITERATION_COMPLETE),
 	CMD(POWER_TABLE_CMD),
 	CMD(WEP_KEY),
 	CMD(REPLY_RX_PHY_CMD),
@@ -505,10 +506,17 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		}
 	}
 
-	scan_size = sizeof(struct iwl_scan_cmd) +
-		mvm->fw->ucode_capa.max_probe_length +
-		(mvm->fw->ucode_capa.n_scan_channels *
-					sizeof(struct iwl_scan_channel));
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
+		scan_size = sizeof(struct iwl_scan_req_unified_lmac) +
+			sizeof(struct iwl_scan_channel_cfg_lmac) *
+				mvm->fw->ucode_capa.n_scan_channels +
+			sizeof(struct iwl_scan_probe_req);
+	else
+		scan_size = sizeof(struct iwl_scan_cmd) +
+			mvm->fw->ucode_capa.max_probe_length +
+			mvm->fw->ucode_capa.n_scan_channels *
+				sizeof(struct iwl_scan_channel);
+
 	mvm->scan_cmd = kmalloc(scan_size, GFP_KERNEL);
 	if (!mvm->scan_cmd)
 		goto out_free;
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index f2dde56..919ed0e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -97,10 +97,9 @@ static inline __le16 iwl_mvm_scan_rx_chain(struct iwl_mvm *mvm)
 	return cpu_to_le16(rx_chain);
 }
 
-static inline __le32
-iwl_mvm_scan_rxon_flags(struct cfg80211_scan_request *req)
+static __le32 iwl_mvm_scan_rxon_flags(enum ieee80211_band band)
 {
-	if (req->channels[0]->band == IEEE80211_BAND_2GHZ)
+	if (band == IEEE80211_BAND_2GHZ)
 		return cpu_to_le32(PHY_BAND_24);
 	else
 		return cpu_to_le32(PHY_BAND_5);
@@ -130,19 +129,19 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
  * request list, is not copied here, but inserted directly to the probe
  * request.
  */
-static void iwl_mvm_scan_fill_ssids(struct iwl_scan_cmd *cmd,
-				    struct cfg80211_scan_request *req,
-				    int first)
+static void iwl_mvm_scan_fill_ssids(struct iwl_ssid_ie *cmd_ssid,
+				    struct cfg80211_ssid *ssids,
+				    int n_ssids, int first)
 {
 	int fw_idx, req_idx;
 
-	for (req_idx = req->n_ssids - 1, fw_idx = 0; req_idx >= first;
+	for (req_idx = n_ssids - 1, fw_idx = 0; req_idx >= first;
 	     req_idx--, fw_idx++) {
-		cmd->direct_scan[fw_idx].id = WLAN_EID_SSID;
-		cmd->direct_scan[fw_idx].len = req->ssids[req_idx].ssid_len;
-		memcpy(cmd->direct_scan[fw_idx].ssid,
-		       req->ssids[req_idx].ssid,
-		       req->ssids[req_idx].ssid_len);
+		cmd_ssid[fw_idx].id = WLAN_EID_SSID;
+		cmd_ssid[fw_idx].len = ssids[req_idx].ssid_len;
+		memcpy(cmd_ssid[fw_idx].ssid,
+		       ssids[req_idx].ssid,
+		       ssids[req_idx].ssid_len);
 	}
 }
 
@@ -349,7 +348,7 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 	if (params.passive_fragmented)
 		cmd->scan_flags |= SCAN_FLAGS_FRAGMENTED_SCAN;
 
-	cmd->rxon_flags = iwl_mvm_scan_rxon_flags(req);
+	cmd->rxon_flags = iwl_mvm_scan_rxon_flags(req->channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
 
@@ -376,7 +375,8 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 		cmd->scan_flags &= ~SCAN_FLAGS_PASSIVE2ACTIVE;
 	}
 
-	iwl_mvm_scan_fill_ssids(cmd, req, basic_ssid ? 1 : 0);
+	iwl_mvm_scan_fill_ssids(cmd->direct_scan, req->ssids, req->n_ssids,
+				basic_ssid ? 1 : 0);
 
 	cmd->tx_cmd.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
 					   TX_CMD_FLG_BT_DIS);
@@ -450,16 +450,27 @@ int iwl_mvm_rx_scan_complete(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	return 0;
 }
 
-int iwl_mvm_rx_sched_scan_results(struct iwl_mvm *mvm,
-				  struct iwl_rx_cmd_buffer *rxb,
-				  struct iwl_device_cmd *cmd)
+int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
+				    struct iwl_rx_cmd_buffer *rxb,
+				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_sched_scan_results *notif = (void *)pkt->data;
+	u8 client_bitmap = 0;
+
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
+		struct iwl_sched_scan_results *notif = (void *)pkt->data;
 
-	if (notif->client_bitmap & SCAN_CLIENT_SCHED_SCAN) {
-		IWL_DEBUG_SCAN(mvm, "Scheduled scan results\n");
-		ieee80211_sched_scan_results(mvm->hw);
+		client_bitmap = notif->client_bitmap;
+	}
+
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN ||
+	    client_bitmap & SCAN_CLIENT_SCHED_SCAN) {
+		if (mvm->scan_status == IWL_MVM_SCAN_SCHED) {
+			IWL_DEBUG_SCAN(mvm, "Scheduled scan results\n");
+			ieee80211_sched_scan_results(mvm->hw);
+		} else {
+			IWL_DEBUG_SCAN(mvm, "Scan results\n");
+		}
 	}
 
 	return 0;
@@ -503,7 +514,7 @@ static bool iwl_mvm_scan_abort_notif(struct iwl_notif_wait_data *notif_wait,
 	};
 }
 
-int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
+static int iwl_mvm_cancel_regular_scan(struct iwl_mvm *mvm)
 {
 	struct iwl_notification_wait wait_scan_abort;
 	static const u8 scan_abort_notif[] = { SCAN_ABORT_CMD,
@@ -544,26 +555,45 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 					   struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_scan_offload_complete *scan_notif = (void *)pkt->data;
+	u8 status, ebs_status;
+
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) {
+		struct iwl_periodic_scan_complete *scan_notif;
 
+		scan_notif = (void *)pkt->data;
+		status = scan_notif->status;
+		ebs_status = scan_notif->ebs_status;
+	} else  {
+		struct iwl_scan_offload_complete *scan_notif;
+
+		scan_notif = (void *)pkt->data;
+		status = scan_notif->status;
+		ebs_status = scan_notif->ebs_status;
+	}
 	/* scan status must be locked for proper checking */
 	lockdep_assert_held(&mvm->mutex);
 
 	IWL_DEBUG_SCAN(mvm,
-		       "Scheduled scan completed, status %s EBS status %s:%d\n",
-		       scan_notif->status == IWL_SCAN_OFFLOAD_COMPLETED ?
-		       "completed" : "aborted", scan_notif->ebs_status ==
-		       IWL_SCAN_EBS_SUCCESS ? "success" : "failed",
-		       scan_notif->ebs_status);
+		       "%s completed, status %s, EBS status %s\n",
+		       mvm->scan_status == IWL_MVM_SCAN_SCHED ?
+				"Scheduled scan" : "Scan",
+		       status == IWL_SCAN_OFFLOAD_COMPLETED ?
+				"completed" : "aborted",
+		       ebs_status == IWL_SCAN_EBS_SUCCESS ?
+				"success" : "failed");
 
 
 	/* only call mac80211 completion if the stop was initiated by FW */
 	if (mvm->scan_status == IWL_MVM_SCAN_SCHED) {
 		mvm->scan_status = IWL_MVM_SCAN_NONE;
 		ieee80211_sched_scan_stopped(mvm->hw);
+	} else if (mvm->scan_status == IWL_MVM_SCAN_OS) {
+		mvm->scan_status = IWL_MVM_SCAN_NONE;
+		ieee80211_scan_completed(mvm->hw,
+					 status == IWL_SCAN_OFFLOAD_ABORTED);
 	}
 
-	mvm->last_ebs_successful = !scan_notif->ebs_status;
+	mvm->last_ebs_successful = !ebs_status;
 
 	return 0;
 }
@@ -631,8 +661,8 @@ static int iwl_ssid_exist(u8 *ssid, u8 ssid_len, struct iwl_ssid_ie *ssid_list)
 }
 
 static void iwl_scan_offload_build_ssid(struct cfg80211_sched_scan_request *req,
-					struct iwl_scan_offload_cmd *scan,
-					u32 *ssid_bitmap)
+					struct iwl_ssid_ie *direct_scan,
+					u32 *ssid_bitmap, bool basic_ssid)
 {
 	int i, j;
 	int index;
@@ -646,10 +676,10 @@ static void iwl_scan_offload_build_ssid(struct cfg80211_sched_scan_request *req,
 		/* skip empty SSID matchsets */
 		if (!req->match_sets[i].ssid.ssid_len)
 			continue;
-		scan->direct_scan[i].id = WLAN_EID_SSID;
-		scan->direct_scan[i].len = req->match_sets[i].ssid.ssid_len;
-		memcpy(scan->direct_scan[i].ssid, req->match_sets[i].ssid.ssid,
-		       scan->direct_scan[i].len);
+		direct_scan[i].id = WLAN_EID_SSID;
+		direct_scan[i].len = req->match_sets[i].ssid.ssid_len;
+		memcpy(direct_scan[i].ssid, req->match_sets[i].ssid.ssid,
+		       direct_scan[i].len);
 	}
 
 	/* add SSIDs from scan SSID list */
@@ -657,14 +687,14 @@ static void iwl_scan_offload_build_ssid(struct cfg80211_sched_scan_request *req,
 	for (j = 0; j < req->n_ssids && i < PROBE_OPTION_MAX; j++) {
 		index = iwl_ssid_exist(req->ssids[j].ssid,
 				       req->ssids[j].ssid_len,
-				       scan->direct_scan);
+				       direct_scan);
 		if (index < 0) {
-			if (!req->ssids[j].ssid_len)
+			if (!req->ssids[j].ssid_len && basic_ssid)
 				continue;
-			scan->direct_scan[i].id = WLAN_EID_SSID;
-			scan->direct_scan[i].len = req->ssids[j].ssid_len;
-			memcpy(scan->direct_scan[i].ssid, req->ssids[j].ssid,
-			       scan->direct_scan[i].len);
+			direct_scan[i].id = WLAN_EID_SSID;
+			direct_scan[i].len = req->ssids[j].ssid_len;
+			memcpy(direct_scan[i].ssid, req->ssids[j].ssid,
+			       direct_scan[i].len);
 			*ssid_bitmap |= BIT(i + 1);
 			i++;
 		} else {
@@ -734,6 +764,8 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 	int cmd_len;
 	int ret;
 	u8 *probes;
+	bool basic_ssid = !(mvm->fw->ucode_capa.flags &
+			    IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID);
 
 	struct iwl_scan_offload_cfg *scan_cfg;
 	struct iwl_host_cmd cmd = {
@@ -758,7 +790,8 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 	iwl_build_scan_cmd(mvm, vif, req, &scan_cfg->scan_cmd, &params);
 	scan_cfg->scan_cmd.len = cpu_to_le16(cmd_len);
 
-	iwl_scan_offload_build_ssid(req, &scan_cfg->scan_cmd, &ssid_bitmap);
+	iwl_scan_offload_build_ssid(req, scan_cfg->scan_cmd.direct_scan,
+				    &ssid_bitmap, basic_ssid);
 	/* build tx frames for supported bands */
 	if (band_2ghz) {
 		iwl_scan_offload_build_tx_cmd(mvm, vif, ies,
@@ -893,7 +926,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 				    sizeof(scan_req), &scan_req);
 }
 
-static int iwl_mvm_send_sched_scan_abort(struct iwl_mvm *mvm)
+static int iwl_mvm_send_scan_offload_abort(struct iwl_mvm *mvm)
 {
 	int ret;
 	struct iwl_host_cmd cmd = {
@@ -904,7 +937,9 @@ static int iwl_mvm_send_sched_scan_abort(struct iwl_mvm *mvm)
 	/* Exit instantly with error when device is not ready
 	 * to receive scan abort command or it does not perform
 	 * scheduled scan currently */
-	if (mvm->scan_status != IWL_MVM_SCAN_SCHED)
+	if (mvm->scan_status != IWL_MVM_SCAN_SCHED &&
+	    (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) ||
+	     mvm->scan_status != IWL_MVM_SCAN_OS))
 		return -EIO;
 
 	ret = iwl_mvm_send_cmd_status(mvm, &cmd, &status);
@@ -926,16 +961,19 @@ static int iwl_mvm_send_sched_scan_abort(struct iwl_mvm *mvm)
 	return ret;
 }
 
-int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify)
+int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 {
 	int ret;
 	struct iwl_notification_wait wait_scan_done;
 	static const u8 scan_done_notif[] = { SCAN_OFFLOAD_COMPLETE, };
+	bool sched = mvm->scan_status == IWL_MVM_SCAN_SCHED;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (mvm->scan_status != IWL_MVM_SCAN_SCHED) {
-		IWL_DEBUG_SCAN(mvm, "No offloaded scan to stop\n");
+	if (mvm->scan_status != IWL_MVM_SCAN_SCHED &&
+	    (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) ||
+	     mvm->scan_status != IWL_MVM_SCAN_OS)) {
+		IWL_DEBUG_SCAN(mvm, "No scan to stop\n");
 		return 0;
 	}
 
@@ -944,14 +982,16 @@ int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify)
 				   ARRAY_SIZE(scan_done_notif),
 				   NULL, NULL);
 
-	ret = iwl_mvm_send_sched_scan_abort(mvm);
+	ret = iwl_mvm_send_scan_offload_abort(mvm);
 	if (ret) {
-		IWL_DEBUG_SCAN(mvm, "Send stop offload scan failed %d\n", ret);
+		IWL_DEBUG_SCAN(mvm, "Send stop %sscan failed %d\n",
+			       sched ? "offloaded " : "", ret);
 		iwl_remove_notification(&mvm->notif_wait, &wait_scan_done);
 		return ret;
 	}
 
-	IWL_DEBUG_SCAN(mvm, "Successfully sent stop offload scan\n");
+	IWL_DEBUG_SCAN(mvm, "Successfully sent stop %sscan\n",
+		       sched ? "offloaded " : "");
 
 	ret = iwl_wait_notification(&mvm->notif_wait, &wait_scan_done, 1 * HZ);
 	if (ret)
@@ -964,8 +1004,311 @@ int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify)
 	 */
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
 
-	if (notify)
-		ieee80211_sched_scan_stopped(mvm->hw);
+	if (notify) {
+		if (sched)
+			ieee80211_sched_scan_stopped(mvm->hw);
+		else
+			ieee80211_scan_completed(mvm->hw, true);
+	}
 
 	return 0;
 }
+
+static void iwl_mvm_unified_scan_fill_tx_cmd(struct iwl_mvm *mvm,
+					     struct iwl_scan_req_tx_cmd *tx_cmd,
+					     bool no_cck)
+{
+	tx_cmd[0].tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
+					 TX_CMD_FLG_BT_DIS);
+	tx_cmd[0].rate_n_flags = iwl_mvm_scan_rate_n_flags(mvm,
+							   IEEE80211_BAND_2GHZ,
+							   no_cck);
+	tx_cmd[0].sta_id = mvm->aux_sta.sta_id;
+
+	tx_cmd[1].tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
+					 TX_CMD_FLG_BT_DIS);
+	tx_cmd[1].rate_n_flags = iwl_mvm_scan_rate_n_flags(mvm,
+							   IEEE80211_BAND_5GHZ,
+							   no_cck);
+	tx_cmd[1].sta_id = mvm->aux_sta.sta_id;
+}
+
+static void
+iwl_mvm_lmac_scan_cfg_channels(struct iwl_mvm *mvm,
+			       struct ieee80211_channel **channels,
+			       int n_channels, u32 ssid_bitmap,
+			       struct iwl_scan_req_unified_lmac *cmd)
+{
+	struct iwl_scan_channel_cfg_lmac *channel_cfg = (void *)&cmd->data;
+	int i;
+
+	for (i = 0; i < n_channels; i++) {
+		channel_cfg[i].channel_num =
+			cpu_to_le16(channels[i]->hw_value);
+		channel_cfg[i].iter_count = cpu_to_le16(1);
+		channel_cfg[i].iter_interval = 0;
+		channel_cfg[i].flags =
+			cpu_to_le32(IWL_UNIFIED_SCAN_CHANNEL_PARTIAL |
+				    ssid_bitmap);
+	}
+}
+
+static void
+iwl_mvm_build_unified_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+				 struct ieee80211_scan_ies *ies,
+				 struct iwl_scan_req_unified_lmac *cmd)
+{
+	struct iwl_scan_probe_req *preq = (void *)(cmd->data +
+		sizeof(struct iwl_scan_channel_cfg_lmac) *
+			mvm->fw->ucode_capa.n_scan_channels);
+	struct ieee80211_mgmt *frame = (struct ieee80211_mgmt *)preq->buf;
+	u8 *pos;
+
+	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
+	eth_broadcast_addr(frame->da);
+	memcpy(frame->sa, vif->addr, ETH_ALEN);
+	eth_broadcast_addr(frame->bssid);
+	frame->seq_ctrl = 0;
+
+	pos = frame->u.probe_req.variable;
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0;
+
+	preq->mac_header.offset = 0;
+	preq->mac_header.len = cpu_to_le16(24 + 2);
+
+	memcpy(pos, ies->ies[IEEE80211_BAND_2GHZ],
+	       ies->len[IEEE80211_BAND_2GHZ]);
+	preq->band_data[0].offset = cpu_to_le16(pos - preq->buf);
+	preq->band_data[0].len = cpu_to_le16(ies->len[IEEE80211_BAND_2GHZ]);
+	pos += ies->len[IEEE80211_BAND_2GHZ];
+
+	memcpy(pos, ies->ies[IEEE80211_BAND_5GHZ],
+	       ies->len[IEEE80211_BAND_5GHZ]);
+	preq->band_data[1].offset = cpu_to_le16(pos - preq->buf);
+	preq->band_data[1].len = cpu_to_le16(ies->len[IEEE80211_BAND_5GHZ]);
+	pos += ies->len[IEEE80211_BAND_5GHZ];
+
+	memcpy(pos, ies->common_ies, ies->common_ie_len);
+	preq->common_data.offset = cpu_to_le16(pos - preq->buf);
+	preq->common_data.len = cpu_to_le16(ies->common_ie_len);
+}
+
+static void
+iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
+				       struct iwl_scan_req_unified_lmac *cmd,
+				       struct iwl_mvm_scan_params *params)
+{
+	cmd->active_dwell = (u8)params->dwell[IEEE80211_BAND_2GHZ].active;
+	cmd->passive_dwell = (u8)params->dwell[IEEE80211_BAND_2GHZ].passive;
+	/* TODO: Use params; now fragmented isn't used. */
+	cmd->fragmented_dwell = 0;
+	cmd->rx_chain_select = iwl_mvm_scan_rx_chain(mvm);
+	cmd->max_out_time = cpu_to_le32(params->max_out_time);
+	cmd->suspend_time = cpu_to_le32(params->suspend_time);
+	cmd->scan_prio = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+	cmd->channel_opt[0].flags = mvm->last_ebs_successful ?
+				cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS &
+					    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE &
+					    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD) :
+				0;
+	cmd->channel_opt[0].non_ebs_ratio = 0;
+	cmd->iter_num = cpu_to_le32(1);
+	cmd->delay = 0;
+}
+
+int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_scan_request *req)
+{
+	struct iwl_host_cmd hcmd = {
+		.id = SCAN_OFFLOAD_REQUEST_CMD,
+		.len = { sizeof(struct iwl_scan_req_unified_lmac) +
+			 sizeof(struct iwl_scan_channel_cfg_lmac) *
+				mvm->fw->ucode_capa.n_scan_channels +
+			 sizeof(struct iwl_scan_probe_req), },
+		.data = { mvm->scan_cmd, },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+	};
+	struct iwl_scan_req_unified_lmac *cmd = mvm->scan_cmd;
+	struct iwl_mvm_scan_params params = {};
+	u32 flags;
+	int ssid_bitmap = 0;
+	int ret, i;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* we should have failed registration if scan_cmd was NULL */
+	if (WARN_ON(mvm->scan_cmd == NULL))
+		return -ENOMEM;
+
+	if (WARN_ON_ONCE(req->req.n_ssids > PROBE_OPTION_MAX ||
+			 req->ies.common_ie_len + req->ies.len[0] +
+				req->ies.len[1] + 24 + 2 >
+					SCAN_OFFLOAD_PROBE_REQ_SIZE ||
+			 req->req.n_channels >
+				mvm->fw->ucode_capa.n_scan_channels))
+		return -1;
+
+	mvm->scan_status = IWL_MVM_SCAN_OS;
+
+	iwl_mvm_scan_calc_params(mvm, vif, req->req.n_ssids, req->req.flags,
+				 &params);
+
+	iwl_mvm_build_generic_unified_scan_cmd(mvm, cmd, &params);
+
+	cmd->n_channels = (u8)req->req.n_channels;
+
+	flags = IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
+
+	if (req->req.n_ssids == 1 && req->req.ssids[0].ssid_len != 0)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
+
+	if (params.passive_fragmented)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
+
+	if (req->req.n_ssids == 0)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
+
+	cmd->scan_flags = cpu_to_le32(flags);
+
+	cmd->flags = iwl_mvm_scan_rxon_flags(req->req.channels[0]->band);
+	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
+					MAC_FILTER_IN_BEACON);
+	iwl_mvm_unified_scan_fill_tx_cmd(mvm, cmd->tx_cmd, req->req.no_cck);
+	iwl_mvm_scan_fill_ssids(cmd->direct_scan, req->req.ssids,
+				req->req.n_ssids, 0);
+
+	cmd->schedule[0].delay = 0;
+	cmd->schedule[0].iterations = 1;
+	cmd->schedule[0].full_scan_mul = 0;
+	cmd->schedule[1].delay = 0;
+	cmd->schedule[1].iterations = 0;
+	cmd->schedule[1].full_scan_mul = 0;
+
+	for (i = 1; i <= req->req.n_ssids; i++)
+		ssid_bitmap |= BIT(i);
+
+	iwl_mvm_lmac_scan_cfg_channels(mvm, req->req.channels,
+				       req->req.n_channels, ssid_bitmap,
+				       cmd);
+
+	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, cmd);
+
+	ret = iwl_mvm_send_cmd(mvm, &hcmd);
+	if (!ret) {
+		IWL_DEBUG_SCAN(mvm, "Scan request was sent successfully\n");
+	} else {
+		/*
+		 * If the scan failed, it usually means that the FW was unable
+		 * to allocate the time events. Warn on it, but maybe we
+		 * should try to send the command again with different params.
+		 */
+		IWL_ERR(mvm, "Scan failed! ret %d\n", ret);
+		mvm->scan_status = IWL_MVM_SCAN_NONE;
+		ret = -EIO;
+	}
+	return ret;
+}
+
+int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif,
+				    struct cfg80211_sched_scan_request *req,
+				    struct ieee80211_scan_ies *ies)
+{
+	struct iwl_host_cmd hcmd = {
+		.id = SCAN_OFFLOAD_REQUEST_CMD,
+		.len = { sizeof(struct iwl_scan_req_unified_lmac) +
+			 sizeof(struct iwl_scan_channel_cfg_lmac) *
+				mvm->fw->ucode_capa.n_scan_channels +
+			 sizeof(struct iwl_scan_probe_req), },
+		.data = { mvm->scan_cmd, },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+	};
+	struct iwl_scan_req_unified_lmac *cmd = mvm->scan_cmd;
+	struct iwl_mvm_scan_params params = {};
+	int ret;
+	u32 flags = 0, ssid_bitmap = 0;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* we should have failed registration if scan_cmd was NULL */
+	if (WARN_ON(mvm->scan_cmd == NULL))
+		return -ENOMEM;
+
+	if (WARN_ON_ONCE(req->n_ssids > PROBE_OPTION_MAX ||
+			 ies->common_ie_len + ies->len[0] + ies->len[1] + 24 + 2
+				> SCAN_OFFLOAD_PROBE_REQ_SIZE ||
+			 req->n_channels > mvm->fw->ucode_capa.n_scan_channels))
+		return -ENOBUFS;
+
+	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, 0, &params);
+
+	iwl_mvm_build_generic_unified_scan_cmd(mvm, cmd, &params);
+
+	cmd->n_channels = (u8)req->n_channels;
+
+	if (req->n_match_sets && req->match_sets[0].ssid.ssid_len) {
+		IWL_DEBUG_SCAN(mvm,
+			       "Sending scheduled scan with filtering, n_match_sets %d\n",
+			       req->n_match_sets);
+	} else {
+		IWL_DEBUG_SCAN(mvm,
+			       "Sending Scheduled scan without filtering\n");
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
+	}
+
+	if (req->n_ssids == 1 && req->ssids[0].ssid_len != 0)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
+
+	if (params.passive_fragmented)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
+
+	if (req->n_ssids == 0)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
+
+	cmd->scan_flags = cpu_to_le32(flags);
+
+	cmd->flags = iwl_mvm_scan_rxon_flags(req->channels[0]->band);
+	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
+					MAC_FILTER_IN_BEACON);
+	iwl_mvm_unified_scan_fill_tx_cmd(mvm, cmd->tx_cmd, false);
+	iwl_scan_offload_build_ssid(req, cmd->direct_scan, &ssid_bitmap, false);
+
+	cmd->schedule[0].delay = req->interval / MSEC_PER_SEC;
+	cmd->schedule[0].iterations = IWL_FAST_SCHED_SCAN_ITERATIONS;
+	cmd->schedule[0].full_scan_mul = 1;
+
+	cmd->schedule[1].delay = req->interval / MSEC_PER_SEC;
+	cmd->schedule[1].iterations = 0xff;
+	cmd->schedule[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER;
+
+	iwl_mvm_lmac_scan_cfg_channels(mvm, req->channels, req->n_channels,
+				       ssid_bitmap, cmd);
+
+	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, cmd);
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
+		mvm->scan_status = IWL_MVM_SCAN_NONE;
+		ret = -EIO;
+	}
+	return ret;
+}
+
+
+int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
+{
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
+		return iwl_mvm_scan_offload_stop(mvm, true);
+	return iwl_mvm_cancel_regular_scan(mvm);
+}
-- 
1.8.3.2

