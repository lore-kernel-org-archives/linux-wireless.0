Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbbCATcW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:22 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/31] iwlwifi: mvm: remove deprecated scan API code
Date: Sun,  1 Mar 2015 21:31:28 +0200
Message-Id: <1425238304-498-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203419_361251_AA1D82C1)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The legacy scan API is deprecated and not used anymore with 10 and
higher firmware versions.  Since we deprecated firmware version 9, we
can remove a whole lot of unused code.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h     |   2 -
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 191 --------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  23 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  16 -
 drivers/net/wireless/iwlwifi/mvm/ops.c         |   2 -
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 585 +------------------------
 drivers/net/wireless/iwlwifi/mvm/utils.c       |  19 -
 7 files changed, 20 insertions(+), 818 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 8b9040ef..be4393e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -237,7 +237,6 @@ enum iwl_ucode_tlv_flag {
  * enum iwl_ucode_tlv_api - ucode api
  * @IWL_UCODE_TLV_API_BT_COEX_SPLIT: new API for BT Coex
  * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
- * @IWL_UCODE_TLV_API_LMAC_SCAN: This ucode uses LMAC unified scan API.
  * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
@@ -255,7 +254,6 @@ enum iwl_ucode_tlv_flag {
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
 	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
-	IWL_UCODE_TLV_API_LMAC_SCAN		= BIT(6),
 	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
 	IWL_UCODE_TLV_API_HDC_PHASE_0		= BIT(10),
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index cfc0e65..a5fbbd6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -70,55 +70,10 @@
 
 /* Scan Commands, Responses, Notifications */
 
-/* Masks for iwl_scan_channel.type flags */
-#define SCAN_CHANNEL_TYPE_ACTIVE	BIT(0)
-#define SCAN_CHANNEL_NARROW_BAND	BIT(22)
-
 /* Max number of IEs for direct SSID scans in a command */
 #define PROBE_OPTION_MAX		20
 
 /**
- * struct iwl_scan_channel - entry in REPLY_SCAN_CMD channel table
- * @channel: band is selected by iwl_scan_cmd "flags" field
- * @tx_gain: gain for analog radio
- * @dsp_atten: gain for DSP
- * @active_dwell: dwell time for active scan in TU, typically 5-50
- * @passive_dwell: dwell time for passive scan in TU, typically 20-500
- * @type: type is broken down to these bits:
- *	bit 0: 0 = passive, 1 = active
- *	bits 1-20: SSID direct bit map. If any of these bits is set then
- *		the corresponding SSID IE is transmitted in probe request
- *		(bit i adds IE in position i to the probe request)
- *	bit 22: channel width, 0 = regular, 1 = TGj narrow channel
- *
- * @iteration_count:
- * @iteration_interval:
- * This struct is used once for each channel in the scan list.
- * Each channel can independently select:
- * 1)  SSID for directed active scans
- * 2)  Txpower setting (for rate specified within Tx command)
- * 3)  How long to stay on-channel (behavior may be modified by quiet_time,
- *     quiet_plcp_th, good_CRC_th)
- *
- * To avoid uCode errors, make sure the following are true (see comments
- * under struct iwl_scan_cmd about max_out_time and quiet_time):
- * 1)  If using passive_dwell (i.e. passive_dwell != 0):
- *     active_dwell <= passive_dwell (< max_out_time if max_out_time != 0)
- * 2)  quiet_time <= active_dwell
- * 3)  If restricting off-channel time (i.e. max_out_time !=0):
- *     passive_dwell < max_out_time
- *     active_dwell < max_out_time
- */
-struct iwl_scan_channel {
-	__le32 type;
-	__le16 channel;
-	__le16 iteration_count;
-	__le32 iteration_interval;
-	__le16 active_dwell;
-	__le16 passive_dwell;
-} __packed; /* SCAN_CHANNEL_CONTROL_API_S_VER_1 */
-
-/**
  * struct iwl_ssid_ie - directed scan network information element
  *
  * Up to 20 of these may appear in REPLY_SCAN_CMD,
@@ -132,152 +87,6 @@ struct iwl_ssid_ie {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 } __packed; /* SCAN_DIRECT_SSID_IE_API_S_VER_1 */
 
-/**
- * iwl_scan_flags - masks for scan command flags
- *@SCAN_FLAGS_PERIODIC_SCAN:
- *@SCAN_FLAGS_P2P_PUBLIC_ACTION_FRAME_TX:
- *@SCAN_FLAGS_DELAYED_SCAN_LOWBAND:
- *@SCAN_FLAGS_DELAYED_SCAN_HIGHBAND:
- *@SCAN_FLAGS_FRAGMENTED_SCAN:
- *@SCAN_FLAGS_PASSIVE2ACTIVE: use active scan on channels that was active
- *	in the past hour, even if they are marked as passive.
- */
-enum iwl_scan_flags {
-	SCAN_FLAGS_PERIODIC_SCAN		= BIT(0),
-	SCAN_FLAGS_P2P_PUBLIC_ACTION_FRAME_TX	= BIT(1),
-	SCAN_FLAGS_DELAYED_SCAN_LOWBAND		= BIT(2),
-	SCAN_FLAGS_DELAYED_SCAN_HIGHBAND	= BIT(3),
-	SCAN_FLAGS_FRAGMENTED_SCAN		= BIT(4),
-	SCAN_FLAGS_PASSIVE2ACTIVE		= BIT(5),
-};
-
-/**
- * enum iwl_scan_type - Scan types for scan command
- * @SCAN_TYPE_FORCED:
- * @SCAN_TYPE_BACKGROUND:
- * @SCAN_TYPE_OS:
- * @SCAN_TYPE_ROAMING:
- * @SCAN_TYPE_ACTION:
- * @SCAN_TYPE_DISCOVERY:
- * @SCAN_TYPE_DISCOVERY_FORCED:
- */
-enum iwl_scan_type {
-	SCAN_TYPE_FORCED		= 0,
-	SCAN_TYPE_BACKGROUND		= 1,
-	SCAN_TYPE_OS			= 2,
-	SCAN_TYPE_ROAMING		= 3,
-	SCAN_TYPE_ACTION		= 4,
-	SCAN_TYPE_DISCOVERY		= 5,
-	SCAN_TYPE_DISCOVERY_FORCED	= 6,
-}; /* SCAN_ACTIVITY_TYPE_E_VER_1 */
-
-/**
- * struct iwl_scan_cmd - scan request command
- * ( SCAN_REQUEST_CMD = 0x80 )
- * @len: command length in bytes
- * @scan_flags: scan flags from SCAN_FLAGS_*
- * @channel_count: num of channels in channel list
- *	(1 - ucode_capa.n_scan_channels)
- * @quiet_time: in msecs, dwell this time for active scan on quiet channels
- * @quiet_plcp_th: quiet PLCP threshold (channel is quiet if less than
- *	this number of packets were received (typically 1)
- * @passive2active: is auto switching from passive to active during scan allowed
- * @rxchain_sel_flags: RXON_RX_CHAIN_*
- * @max_out_time: in TUs, max out of serving channel time
- * @suspend_time: how long to pause scan when returning to service channel:
- *	bits 0-19: beacon interal in TUs (suspend before executing)
- *	bits 20-23: reserved
- *	bits 24-31: number of beacons (suspend between channels)
- * @rxon_flags: RXON_FLG_*
- * @filter_flags: RXON_FILTER_*
- * @tx_cmd: for active scans (zero for passive), w/o payload,
- *	no RS so specify TX rate
- * @direct_scan: direct scan SSIDs
- * @type: one of SCAN_TYPE_*
- * @repeats: how many time to repeat the scan
- */
-struct iwl_scan_cmd {
-	__le16 len;
-	u8 scan_flags;
-	u8 channel_count;
-	__le16 quiet_time;
-	__le16 quiet_plcp_th;
-	__le16 passive2active;
-	__le16 rxchain_sel_flags;
-	__le32 max_out_time;
-	__le32 suspend_time;
-	/* RX_ON_FLAGS_API_S_VER_1 */
-	__le32 rxon_flags;
-	__le32 filter_flags;
-	struct iwl_tx_cmd tx_cmd;
-	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
-	__le32 type;
-	__le32 repeats;
-
-	/*
-	 * Probe request frame, followed by channel list.
-	 *
-	 * Size of probe request frame is specified by byte count in tx_cmd.
-	 * Channel list follows immediately after probe request frame.
-	 * Number of channels in list is specified by channel_count.
-	 * Each channel in list is of type:
-	 *
-	 * struct iwl_scan_channel channels[0];
-	 *
-	 * NOTE:  Only one band of channels can be scanned per pass.  You
-	 * must not mix 2.4GHz channels and 5.2GHz channels, and you must wait
-	 * for one scan to complete (i.e. receive SCAN_COMPLETE_NOTIFICATION)
-	 * before requesting another scan.
-	 */
-	u8 data[0];
-} __packed; /* SCAN_REQUEST_FIXED_PART_API_S_VER_5 */
-
-/* Response to scan request contains only status with one of these values */
-#define SCAN_RESPONSE_OK	0x1
-#define SCAN_RESPONSE_ERROR	0x2
-
-/*
- * SCAN_ABORT_CMD = 0x81
- * When scan abort is requested, the command has no fields except the common
- * header. The response contains only a status with one of these values.
- */
-#define SCAN_ABORT_POSSIBLE	0x1
-#define SCAN_ABORT_IGNORED	0x2 /* no pending scans */
-
-/* TODO: complete documentation */
-#define  SCAN_OWNER_STATUS 0x1
-#define  MEASURE_OWNER_STATUS 0x2
-
-/**
- * struct iwl_scan_start_notif - notifies start of scan in the device
- * ( SCAN_START_NOTIFICATION = 0x82 )
- * @tsf_low: TSF timer (lower half) in usecs
- * @tsf_high: TSF timer (higher half) in usecs
- * @beacon_timer: structured as follows:
- *	bits 0:19 - beacon interval in usecs
- *	bits 20:23 - reserved (0)
- *	bits 24:31 - number of beacons
- * @channel: which channel is scanned
- * @band: 0 for 5.2 GHz, 1 for 2.4 GHz
- * @status: one of *_OWNER_STATUS
- */
-struct iwl_scan_start_notif {
-	__le32 tsf_low;
-	__le32 tsf_high;
-	__le32 beacon_timer;
-	u8 channel;
-	u8 band;
-	u8 reserved[2];
-	__le32 status;
-} __packed; /* SCAN_START_NTF_API_S_VER_1 */
-
-/* scan results probe_status first bit indicates success */
-#define SCAN_PROBE_STATUS_OK		0
-#define SCAN_PROBE_STATUS_TX_FAILED	BIT(0)
-/* error statuses combined with TX_FAILED */
-#define SCAN_PROBE_STATUS_FAIL_TTL	BIT(1)
-#define SCAN_PROBE_STATUS_FAIL_BT	BIT(2)
-
 /* How many statistics are gathered for each channel */
 #define SCAN_RESULTS_STATISTICS 1
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 20e1e89..0f986d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -339,13 +339,10 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    !iwlwifi_mod_params.sw_crypto)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN ||
-	    mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
-		hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
-		hw->wiphy->features |=
-			NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
-			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
-	}
+	hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
+	hw->wiphy->features |=
+		NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
+		NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
@@ -2204,10 +2201,8 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
 		ret = iwl_mvm_scan_umac(mvm, vif, hw_req);
-	else if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
-		ret = iwl_mvm_unified_scan_lmac(mvm, vif, hw_req);
 	else
-		ret = iwl_mvm_scan_request(mvm, vif, req);
+		ret = iwl_mvm_unified_scan_lmac(mvm, vif, hw_req);
 
 	if (ret)
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
@@ -2535,13 +2530,7 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	/* Newest FW fixes sched scan while connected on another interface */
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) {
-		if (!vif->bss_conf.idle) {
-			ret = -EBUSY;
-			goto out;
-		}
-	} else if (!iwl_mvm_is_idle(mvm)) {
+	if (!vif->bss_conf.idle) {
 		ret = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d4f3b84..90a1ea3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1080,13 +1080,6 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 
 /* Scanning */
 int iwl_mvm_scan_size(struct iwl_mvm *mvm);
-int iwl_mvm_scan_request(struct iwl_mvm *mvm,
-			 struct ieee80211_vif *vif,
-			 struct cfg80211_scan_request *req);
-int iwl_mvm_rx_scan_response(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			     struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_scan_complete(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			     struct iwl_device_cmd *cmd);
 int iwl_mvm_cancel_scan(struct iwl_mvm *mvm);
 int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan);
 
@@ -1097,14 +1090,8 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
 						struct iwl_rx_cmd_buffer *rxb,
 						struct iwl_device_cmd *cmd);
-int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
-			      struct ieee80211_vif *vif,
-			      struct cfg80211_sched_scan_request *req,
-			      struct ieee80211_scan_ies *ies);
 int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 				       struct cfg80211_sched_scan_request *req);
-int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
-			     struct cfg80211_sched_scan_request *req);
 int iwl_mvm_scan_offload_start(struct iwl_mvm *mvm,
 			       struct ieee80211_vif *vif,
 			       struct cfg80211_sched_scan_request *req,
@@ -1359,9 +1346,6 @@ static inline void iwl_mvm_enable_agg_txq(struct iwl_mvm *mvm, int queue,
 	iwl_mvm_enable_txq(mvm, queue, ssn, &cfg, wdg_timeout);
 }
 
-/* Assoc status */
-bool iwl_mvm_is_idle(struct iwl_mvm *mvm);
-
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
 void iwl_mvm_tt_temp_changed(struct iwl_mvm *mvm, u32 temp);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 7a04533..1f64d23 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -237,8 +237,6 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 
 	RX_HANDLER(EOSP_NOTIFICATION, iwl_mvm_rx_eosp_notif, false),
 
-	RX_HANDLER(SCAN_REQUEST_CMD, iwl_mvm_rx_scan_response, false),
-	RX_HANDLER(SCAN_COMPLETE_NOTIFICATION, iwl_mvm_rx_scan_complete, true),
 	RX_HANDLER(SCAN_ITERATION_COMPLETE,
 		   iwl_mvm_rx_scan_offload_iter_complete_notif, false),
 	RX_HANDLER(SCAN_OFFLOAD_COMPLETE,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 7e9aa3c..ca3a187 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -191,101 +191,6 @@ static u16 iwl_mvm_get_passive_dwell(struct iwl_mvm *mvm,
 	return band == IEEE80211_BAND_2GHZ ? 100 + 20 : 100 + 10;
 }
 
-static void iwl_mvm_scan_fill_channels(struct iwl_scan_cmd *cmd,
-				       struct cfg80211_scan_request *req,
-				       bool basic_ssid,
-				       struct iwl_mvm_scan_params *params)
-{
-	struct iwl_scan_channel *chan = (struct iwl_scan_channel *)
-		(cmd->data + le16_to_cpu(cmd->tx_cmd.len));
-	int i;
-	int type = BIT(req->n_ssids) - 1;
-	enum ieee80211_band band = req->channels[0]->band;
-
-	if (!basic_ssid)
-		type |= BIT(req->n_ssids);
-
-	for (i = 0; i < cmd->channel_count; i++) {
-		chan->channel = cpu_to_le16(req->channels[i]->hw_value);
-		chan->type = cpu_to_le32(type);
-		if (req->channels[i]->flags & IEEE80211_CHAN_NO_IR)
-			chan->type &= cpu_to_le32(~SCAN_CHANNEL_TYPE_ACTIVE);
-		chan->active_dwell = cpu_to_le16(params->dwell[band].active);
-		chan->passive_dwell = cpu_to_le16(params->dwell[band].passive);
-		chan->iteration_count = cpu_to_le16(1);
-		chan++;
-	}
-}
-
-/*
- * Fill in probe request with the following parameters:
- * TA is our vif HW address, which mac80211 ensures we have.
- * Packet is broadcasted, so this is both SA and DA.
- * The probe request IE is made out of two: first comes the most prioritized
- * SSID if a directed scan is requested. Second comes whatever extra
- * information was given to us as the scan request IE.
- */
-static u16 iwl_mvm_fill_probe_req(struct ieee80211_mgmt *frame, const u8 *ta,
-				  int n_ssids, const u8 *ssid, int ssid_len,
-				  const u8 *band_ie, int band_ie_len,
-				  const u8 *common_ie, int common_ie_len,
-				  int left)
-{
-	int len = 0;
-	u8 *pos = NULL;
-
-	/* Make sure there is enough space for the probe request,
-	 * two mandatory IEs and the data */
-	left -= 24;
-	if (left < 0)
-		return 0;
-
-	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	eth_broadcast_addr(frame->da);
-	memcpy(frame->sa, ta, ETH_ALEN);
-	eth_broadcast_addr(frame->bssid);
-	frame->seq_ctrl = 0;
-
-	len += 24;
-
-	/* for passive scans, no need to fill anything */
-	if (n_ssids == 0)
-		return (u16)len;
-
-	/* points to the payload of the request */
-	pos = &frame->u.probe_req.variable[0];
-
-	/* fill in our SSID IE */
-	left -= ssid_len + 2;
-	if (left < 0)
-		return 0;
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = ssid_len;
-	if (ssid && ssid_len) { /* ssid_len may be == 0 even if ssid is valid */
-		memcpy(pos, ssid, ssid_len);
-		pos += ssid_len;
-	}
-
-	len += ssid_len + 2;
-
-	if (WARN_ON(left < band_ie_len + common_ie_len))
-		return len;
-
-	if (band_ie && band_ie_len) {
-		memcpy(pos, band_ie, band_ie_len);
-		pos += band_ie_len;
-		len += band_ie_len;
-	}
-
-	if (common_ie && common_ie_len) {
-		memcpy(pos, common_ie, common_ie_len);
-		pos += common_ie_len;
-		len += common_ie_len;
-	}
-
-	return (u16)len;
-}
-
 static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
 					    struct ieee80211_vif *vif)
 {
@@ -379,20 +284,11 @@ static int iwl_mvm_max_scan_ie_fw_cmd_room(struct iwl_mvm *mvm,
 {
 	int max_probe_len;
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
-		max_probe_len = SCAN_OFFLOAD_PROBE_REQ_SIZE;
-	else
-		max_probe_len = mvm->fw->ucode_capa.max_probe_length;
+	max_probe_len = SCAN_OFFLOAD_PROBE_REQ_SIZE;
 
 	/* we create the 802.11 header and SSID element */
 	max_probe_len -= 24 + 2;
 
-	/* basic ssid is added only for hw_scan with and old api */
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID) &&
-	    !(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) &&
-	    !is_sched_scan)
-		max_probe_len -= 32;
-
 	/* DS parameter set element is added on 2.4GHZ band if required */
 	if (iwl_mvm_rrm_scan_needed(mvm))
 		max_probe_len -= 3;
@@ -404,9 +300,6 @@ int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan)
 {
 	int max_ie_len = iwl_mvm_max_scan_ie_fw_cmd_room(mvm, is_sched_scan);
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN))
-		return max_ie_len;
-
 	/* TODO: [BUG] This function should return the maximum allowed size of
 	 * scan IEs, however the LMAC scan api contains both 2GHZ and 5GHZ IEs
 	 * in the same command. So the correct implementation of this function
@@ -420,129 +313,6 @@ int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan)
 	return max_ie_len;
 }
 
-int iwl_mvm_scan_request(struct iwl_mvm *mvm,
-			 struct ieee80211_vif *vif,
-			 struct cfg80211_scan_request *req)
-{
-	struct iwl_host_cmd hcmd = {
-		.id = SCAN_REQUEST_CMD,
-		.len = { 0, },
-		.data = { mvm->scan_cmd, },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-	};
-	struct iwl_scan_cmd *cmd = mvm->scan_cmd;
-	int ret;
-	u32 status;
-	int ssid_len = 0;
-	u8 *ssid = NULL;
-	bool basic_ssid = !(mvm->fw->ucode_capa.flags &
-			   IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID);
-	struct iwl_mvm_scan_params params = {};
-
-	lockdep_assert_held(&mvm->mutex);
-
-	/* we should have failed registration if scan_cmd was NULL */
-	if (WARN_ON(mvm->scan_cmd == NULL))
-		return -ENOMEM;
-
-	IWL_DEBUG_SCAN(mvm, "Handling mac80211 scan request\n");
-	mvm->scan_status = IWL_MVM_SCAN_OS;
-	memset(cmd, 0, ksize(cmd));
-
-	cmd->channel_count = (u8)req->n_channels;
-	cmd->quiet_time = cpu_to_le16(IWL_ACTIVE_QUIET_TIME);
-	cmd->quiet_plcp_th = cpu_to_le16(IWL_PLCP_QUIET_THRESH);
-	cmd->rxchain_sel_flags = iwl_mvm_scan_rx_chain(mvm);
-
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags, &params);
-	cmd->max_out_time = cpu_to_le32(params.max_out_time);
-	cmd->suspend_time = cpu_to_le32(params.suspend_time);
-	if (params.passive_fragmented)
-		cmd->scan_flags |= SCAN_FLAGS_FRAGMENTED_SCAN;
-
-	cmd->rxon_flags = iwl_mvm_scan_rxon_flags(req->channels[0]->band);
-	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
-					MAC_FILTER_IN_BEACON);
-
-	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
-		cmd->type = cpu_to_le32(SCAN_TYPE_DISCOVERY_FORCED);
-	else
-		cmd->type = cpu_to_le32(SCAN_TYPE_FORCED);
-
-	cmd->repeats = cpu_to_le32(1);
-
-	/*
-	 * If the user asked for passive scan, don't change to active scan if
-	 * you see any activity on the channel - remain passive.
-	 */
-	if (req->n_ssids > 0) {
-		cmd->passive2active = cpu_to_le16(1);
-		cmd->scan_flags |= SCAN_FLAGS_PASSIVE2ACTIVE;
-		if (basic_ssid) {
-			ssid = req->ssids[0].ssid;
-			ssid_len = req->ssids[0].ssid_len;
-		}
-	} else {
-		cmd->passive2active = 0;
-		cmd->scan_flags &= ~SCAN_FLAGS_PASSIVE2ACTIVE;
-	}
-
-	iwl_mvm_scan_fill_ssids(cmd->direct_scan, req->ssids, req->n_ssids,
-				basic_ssid ? 1 : 0);
-
-	cmd->tx_cmd.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
-					   3 << TX_CMD_FLG_BT_PRIO_POS);
-
-	cmd->tx_cmd.sta_id = mvm->aux_sta.sta_id;
-	cmd->tx_cmd.life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
-	cmd->tx_cmd.rate_n_flags =
-			iwl_mvm_scan_rate_n_flags(mvm, req->channels[0]->band,
-						  req->no_cck);
-
-	cmd->tx_cmd.len =
-		cpu_to_le16(iwl_mvm_fill_probe_req(
-			    (struct ieee80211_mgmt *)cmd->data,
-			    vif->addr,
-			    req->n_ssids, ssid, ssid_len,
-			    req->ie, req->ie_len, NULL, 0,
-			    mvm->fw->ucode_capa.max_probe_length));
-
-	iwl_mvm_scan_fill_channels(cmd, req, basic_ssid, &params);
-
-	cmd->len = cpu_to_le16(sizeof(struct iwl_scan_cmd) +
-		le16_to_cpu(cmd->tx_cmd.len) +
-		(cmd->channel_count * sizeof(struct iwl_scan_channel)));
-	hcmd.len[0] = le16_to_cpu(cmd->len);
-
-	status = SCAN_RESPONSE_OK;
-	ret = iwl_mvm_send_cmd_status(mvm, &hcmd, &status);
-	if (!ret && status == SCAN_RESPONSE_OK) {
-		IWL_DEBUG_SCAN(mvm, "Scan request was sent successfully\n");
-	} else {
-		/*
-		 * If the scan failed, it usually means that the FW was unable
-		 * to allocate the time events. Warn on it, but maybe we
-		 * should try to send the command again with different params.
-		 */
-		IWL_ERR(mvm, "Scan failed! status 0x%x ret %d\n",
-			status, ret);
-		mvm->scan_status = IWL_MVM_SCAN_NONE;
-		ret = -EIO;
-	}
-	return ret;
-}
-
-int iwl_mvm_rx_scan_response(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_cmd_response *resp = (void *)pkt->data;
-
-	IWL_DEBUG_SCAN(mvm, "Scan response received. status 0x%x\n",
-		       le32_to_cpu(resp->status));
-	return 0;
-}
-
 int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
 						struct iwl_rx_cmd_buffer *rxb,
 						struct iwl_device_cmd *cmd)
@@ -556,130 +326,25 @@ int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
-int iwl_mvm_rx_scan_complete(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_scan_complete_notif *notif = (void *)pkt->data;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	IWL_DEBUG_SCAN(mvm, "Scan complete: status=0x%x scanned channels=%d\n",
-		       notif->status, notif->scanned_channels);
-
-	if (mvm->scan_status == IWL_MVM_SCAN_OS)
-		mvm->scan_status = IWL_MVM_SCAN_NONE;
-	ieee80211_scan_completed(mvm->hw, notif->status != SCAN_COMP_STATUS_OK);
-
-	iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-
-	return 0;
-}
-
 int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
 				    struct iwl_rx_cmd_buffer *rxb,
 				    struct iwl_device_cmd *cmd)
 {
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-
-	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
-	    !(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
-		struct iwl_sched_scan_results *notif = (void *)pkt->data;
-
-		if (!(notif->client_bitmap & SCAN_CLIENT_SCHED_SCAN))
-			return 0;
-	}
-
 	IWL_DEBUG_SCAN(mvm, "Scheduled scan results\n");
 	ieee80211_sched_scan_results(mvm->hw);
 
 	return 0;
 }
 
-static bool iwl_mvm_scan_abort_notif(struct iwl_notif_wait_data *notif_wait,
-				     struct iwl_rx_packet *pkt, void *data)
-{
-	struct iwl_mvm *mvm =
-		container_of(notif_wait, struct iwl_mvm, notif_wait);
-	struct iwl_scan_complete_notif *notif;
-	u32 *resp;
-
-	switch (pkt->hdr.cmd) {
-	case SCAN_ABORT_CMD:
-		resp = (void *)pkt->data;
-		if (*resp == CAN_ABORT_STATUS) {
-			IWL_DEBUG_SCAN(mvm,
-				       "Scan can be aborted, wait until completion\n");
-			return false;
-		}
-
-		/*
-		 * If scan cannot be aborted, it means that we had a
-		 * SCAN_COMPLETE_NOTIFICATION in the pipe and it called
-		 * ieee80211_scan_completed already.
-		 */
-		IWL_DEBUG_SCAN(mvm, "Scan cannot be aborted, exit now: %d\n",
-			       *resp);
-		return true;
-
-	case SCAN_COMPLETE_NOTIFICATION:
-		notif = (void *)pkt->data;
-		IWL_DEBUG_SCAN(mvm, "Scan aborted: status 0x%x\n",
-			       notif->status);
-		return true;
-
-	default:
-		WARN_ON(1);
-		return false;
-	};
-}
-
-static int iwl_mvm_cancel_regular_scan(struct iwl_mvm *mvm)
-{
-	struct iwl_notification_wait wait_scan_abort;
-	static const u8 scan_abort_notif[] = { SCAN_ABORT_CMD,
-					       SCAN_COMPLETE_NOTIFICATION };
-	int ret;
-
-	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_abort,
-				   scan_abort_notif,
-				   ARRAY_SIZE(scan_abort_notif),
-				   iwl_mvm_scan_abort_notif, NULL);
-
-	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_CMD, 0, 0, NULL);
-	if (ret) {
-		IWL_ERR(mvm, "Couldn't send SCAN_ABORT_CMD: %d\n", ret);
-		/* mac80211's state will be cleaned in the nic_restart flow */
-		goto out_remove_notif;
-	}
-
-	return iwl_wait_notification(&mvm->notif_wait, &wait_scan_abort, HZ);
-
-out_remove_notif:
-	iwl_remove_notification(&mvm->notif_wait, &wait_scan_abort);
-	return ret;
-}
-
 int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 					   struct iwl_rx_cmd_buffer *rxb,
 					   struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u8 status, ebs_status;
-
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) {
-		struct iwl_periodic_scan_complete *scan_notif;
+	struct iwl_periodic_scan_complete *scan_notif;
 
-		scan_notif = (void *)pkt->data;
-		status = scan_notif->status;
-		ebs_status = scan_notif->ebs_status;
-	} else  {
-		struct iwl_scan_offload_complete *scan_notif;
+	scan_notif = (void *)pkt->data;
 
-		scan_notif = (void *)pkt->data;
-		status = scan_notif->status;
-		ebs_status = scan_notif->ebs_status;
-	}
 	/* scan status must be locked for proper checking */
 	lockdep_assert_held(&mvm->mutex);
 
@@ -687,9 +352,9 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 		       "%s completed, status %s, EBS status %s\n",
 		       mvm->scan_status == IWL_MVM_SCAN_SCHED ?
 				"Scheduled scan" : "Scan",
-		       status == IWL_SCAN_OFFLOAD_COMPLETED ?
+		       scan_notif->status == IWL_SCAN_OFFLOAD_COMPLETED ?
 				"completed" : "aborted",
-		       ebs_status == IWL_SCAN_EBS_SUCCESS ?
+		       scan_notif->ebs_status == IWL_SCAN_EBS_SUCCESS ?
 				"success" : "failed");
 
 
@@ -700,64 +365,16 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 	} else if (mvm->scan_status == IWL_MVM_SCAN_OS) {
 		mvm->scan_status = IWL_MVM_SCAN_NONE;
 		ieee80211_scan_completed(mvm->hw,
-					 status == IWL_SCAN_OFFLOAD_ABORTED);
+				scan_notif->status == IWL_SCAN_OFFLOAD_ABORTED);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 	}
 
-	if (ebs_status)
+	if (scan_notif->ebs_status)
 		mvm->last_ebs_successful = false;
 
 	return 0;
 }
 
-static void iwl_scan_offload_build_tx_cmd(struct iwl_mvm *mvm,
-					  struct ieee80211_vif *vif,
-					  struct ieee80211_scan_ies *ies,
-					  enum ieee80211_band band,
-					  struct iwl_tx_cmd *cmd,
-					  u8 *data)
-{
-	u16 cmd_len;
-
-	cmd->tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL);
-	cmd->life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
-	cmd->sta_id = mvm->aux_sta.sta_id;
-
-	cmd->rate_n_flags = iwl_mvm_scan_rate_n_flags(mvm, band, false);
-
-	cmd_len = iwl_mvm_fill_probe_req((struct ieee80211_mgmt *)data,
-					 vif->addr,
-					 1, NULL, 0,
-					 ies->ies[band], ies->len[band],
-					 ies->common_ies, ies->common_ie_len,
-					 SCAN_OFFLOAD_PROBE_REQ_SIZE);
-	cmd->len = cpu_to_le16(cmd_len);
-}
-
-static void iwl_build_scan_cmd(struct iwl_mvm *mvm,
-			       struct ieee80211_vif *vif,
-			       struct cfg80211_sched_scan_request *req,
-			       struct iwl_scan_offload_cmd *scan,
-			       struct iwl_mvm_scan_params *params)
-{
-	scan->channel_count = req->n_channels;
-	scan->quiet_time = cpu_to_le16(IWL_ACTIVE_QUIET_TIME);
-	scan->quiet_plcp_th = cpu_to_le16(IWL_PLCP_QUIET_THRESH);
-	scan->good_CRC_th = IWL_GOOD_CRC_TH_DEFAULT;
-	scan->rx_chain = iwl_mvm_scan_rx_chain(mvm);
-
-	scan->max_out_time = cpu_to_le32(params->max_out_time);
-	scan->suspend_time = cpu_to_le32(params->suspend_time);
-
-	scan->filter_flags |= cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
-					  MAC_FILTER_IN_BEACON);
-	scan->scan_type = cpu_to_le32(SCAN_TYPE_BACKGROUND);
-	scan->rep_count = cpu_to_le32(1);
-
-	if (params->passive_fragmented)
-		scan->scan_flags |= SCAN_FLAGS_FRAGMENTED_SCAN;
-}
-
 static int iwl_ssid_exist(u8 *ssid, u8 ssid_len, struct iwl_ssid_ie *ssid_list)
 {
 	int i;
@@ -815,127 +432,6 @@ static void iwl_scan_offload_build_ssid(struct cfg80211_sched_scan_request *req,
 	}
 }
 
-static void iwl_build_channel_cfg(struct iwl_mvm *mvm,
-				  struct cfg80211_sched_scan_request *req,
-				  u8 *channels_buffer,
-				  enum ieee80211_band band,
-				  int *head,
-				  u32 ssid_bitmap,
-				  struct iwl_mvm_scan_params *params)
-{
-	u32 n_channels = mvm->fw->ucode_capa.n_scan_channels;
-	__le32 *type = (__le32 *)channels_buffer;
-	__le16 *channel_number = (__le16 *)(type + n_channels);
-	__le16 *iter_count = channel_number + n_channels;
-	__le32 *iter_interval = (__le32 *)(iter_count + n_channels);
-	u8 *active_dwell = (u8 *)(iter_interval + n_channels);
-	u8 *passive_dwell = active_dwell + n_channels;
-	int i, index = 0;
-
-	for (i = 0; i < req->n_channels; i++) {
-		struct ieee80211_channel *chan = req->channels[i];
-
-		if (chan->band != band)
-			continue;
-
-		index = *head;
-		(*head)++;
-
-		channel_number[index] = cpu_to_le16(chan->hw_value);
-		active_dwell[index] = params->dwell[band].active;
-		passive_dwell[index] = params->dwell[band].passive;
-
-		iter_count[index] = cpu_to_le16(1);
-		iter_interval[index] = 0;
-
-		if (!(chan->flags & IEEE80211_CHAN_NO_IR))
-			type[index] |=
-				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_ACTIVE);
-
-		type[index] |= cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_FULL |
-					   IWL_SCAN_OFFLOAD_CHANNEL_PARTIAL);
-
-		if (chan->flags & IEEE80211_CHAN_NO_HT40)
-			type[index] |=
-				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_NARROW);
-
-		/* scan for all SSIDs from req->ssids */
-		type[index] |= cpu_to_le32(ssid_bitmap);
-	}
-}
-
-int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
-			      struct ieee80211_vif *vif,
-			      struct cfg80211_sched_scan_request *req,
-			      struct ieee80211_scan_ies *ies)
-{
-	int band_2ghz = mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels;
-	int band_5ghz = mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
-	int head = 0;
-	u32 ssid_bitmap;
-	int cmd_len;
-	int ret;
-	u8 *probes;
-	bool basic_ssid = !(mvm->fw->ucode_capa.flags &
-			    IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID);
-
-	struct iwl_scan_offload_cfg *scan_cfg;
-	struct iwl_host_cmd cmd = {
-		.id = SCAN_OFFLOAD_CONFIG_CMD,
-	};
-	struct iwl_mvm_scan_params params = {};
-
-	lockdep_assert_held(&mvm->mutex);
-
-	cmd_len = sizeof(struct iwl_scan_offload_cfg) +
-		  mvm->fw->ucode_capa.n_scan_channels * IWL_SCAN_CHAN_SIZE +
-		  2 * SCAN_OFFLOAD_PROBE_REQ_SIZE;
-
-	scan_cfg = kzalloc(cmd_len, GFP_KERNEL);
-	if (!scan_cfg)
-		return -ENOMEM;
-
-	probes = scan_cfg->data +
-		mvm->fw->ucode_capa.n_scan_channels * IWL_SCAN_CHAN_SIZE;
-
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, 0, &params);
-	iwl_build_scan_cmd(mvm, vif, req, &scan_cfg->scan_cmd, &params);
-	scan_cfg->scan_cmd.len = cpu_to_le16(cmd_len);
-
-	iwl_scan_offload_build_ssid(req, scan_cfg->scan_cmd.direct_scan,
-				    &ssid_bitmap, basic_ssid);
-	/* build tx frames for supported bands */
-	if (band_2ghz) {
-		iwl_scan_offload_build_tx_cmd(mvm, vif, ies,
-					      IEEE80211_BAND_2GHZ,
-					      &scan_cfg->scan_cmd.tx_cmd[0],
-					      probes);
-		iwl_build_channel_cfg(mvm, req, scan_cfg->data,
-				      IEEE80211_BAND_2GHZ, &head,
-				      ssid_bitmap, &params);
-	}
-	if (band_5ghz) {
-		iwl_scan_offload_build_tx_cmd(mvm, vif, ies,
-					      IEEE80211_BAND_5GHZ,
-					      &scan_cfg->scan_cmd.tx_cmd[1],
-					      probes +
-						SCAN_OFFLOAD_PROBE_REQ_SIZE);
-		iwl_build_channel_cfg(mvm, req, scan_cfg->data,
-				      IEEE80211_BAND_5GHZ, &head,
-				      ssid_bitmap, &params);
-	}
-
-	cmd.data[0] = scan_cfg;
-	cmd.len[0] = cmd_len;
-	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-
-	IWL_DEBUG_SCAN(mvm, "Sending scheduled scan config\n");
-
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
-	kfree(scan_cfg);
-	return ret;
-}
-
 int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 				       struct cfg80211_sched_scan_request *req)
 {
@@ -1018,33 +514,6 @@ static bool iwl_mvm_scan_pass_all(struct iwl_mvm *mvm,
 	return true;
 }
 
-int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
-			     struct cfg80211_sched_scan_request *req)
-{
-	struct iwl_scan_offload_req scan_req = {
-		.watchdog = IWL_SCHED_SCAN_WATCHDOG,
-
-		.schedule_line[0].iterations = IWL_FAST_SCHED_SCAN_ITERATIONS,
-		.schedule_line[0].delay = cpu_to_le16(req->interval / 1000),
-		.schedule_line[0].full_scan_mul = 1,
-
-		.schedule_line[1].iterations = 0xff,
-		.schedule_line[1].delay = cpu_to_le16(req->interval / 1000),
-		.schedule_line[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER,
-	};
-
-	if (iwl_mvm_scan_pass_all(mvm, req))
-		scan_req.flags |= cpu_to_le16(IWL_SCAN_OFFLOAD_FLAG_PASS_ALL);
-
-	if (mvm->last_ebs_successful &&
-	    mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT)
-		scan_req.flags |=
-			cpu_to_le16(IWL_SCAN_OFFLOAD_FLAG_EBS_ACCURATE_MODE);
-
-	return iwl_mvm_send_cmd_pdu(mvm, SCAN_OFFLOAD_REQUEST_CMD, 0,
-				    sizeof(scan_req), &scan_req);
-}
-
 int iwl_mvm_scan_offload_start(struct iwl_mvm *mvm,
 			       struct ieee80211_vif *vif,
 			       struct cfg80211_sched_scan_request *req,
@@ -1057,21 +526,12 @@ int iwl_mvm_scan_offload_start(struct iwl_mvm *mvm,
 		if (ret)
 			return ret;
 		ret = iwl_mvm_sched_scan_umac(mvm, vif, req, ies);
-	} else if ((mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
-		mvm->scan_status = IWL_MVM_SCAN_SCHED;
-		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
-		if (ret)
-			return ret;
-		ret = iwl_mvm_unified_sched_scan_lmac(mvm, vif, req, ies);
 	} else {
 		mvm->scan_status = IWL_MVM_SCAN_SCHED;
-		ret = iwl_mvm_config_sched_scan(mvm, vif, req, ies);
-		if (ret)
-			return ret;
 		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 		if (ret)
 			return ret;
-		ret = iwl_mvm_sched_scan_start(mvm, req);
+		ret = iwl_mvm_unified_sched_scan_lmac(mvm, vif, req, ies);
 	}
 
 	return ret;
@@ -1088,9 +548,7 @@ static int iwl_mvm_send_scan_offload_abort(struct iwl_mvm *mvm)
 	/* Exit instantly with error when device is not ready
 	 * to receive scan abort command or it does not perform
 	 * scheduled scan currently */
-	if (mvm->scan_status != IWL_MVM_SCAN_SCHED &&
-	    (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) ||
-	     mvm->scan_status != IWL_MVM_SCAN_OS))
+	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
 		return -EIO;
 
 	ret = iwl_mvm_send_cmd_status(mvm, &cmd, &status);
@@ -1131,13 +589,6 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 	if (iwl_mvm_is_radio_killed(mvm))
 		goto out;
 
-	if (mvm->scan_status != IWL_MVM_SCAN_SCHED &&
-	    (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) ||
-	     mvm->scan_status != IWL_MVM_SCAN_OS)) {
-		IWL_DEBUG_SCAN(mvm, "No scan to stop\n");
-		return 0;
-	}
-
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_done,
 				   scan_done_notif,
 				   ARRAY_SIZE(scan_done_notif),
@@ -1580,9 +1031,7 @@ int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 		return 0;
 	}
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
-		return iwl_mvm_scan_offload_stop(mvm, true);
-	return iwl_mvm_cancel_regular_scan(mvm);
+	return iwl_mvm_scan_offload_stop(mvm, true);
 }
 
 /* UMAC scan API */
@@ -2159,14 +1608,8 @@ int iwl_mvm_scan_size(struct iwl_mvm *mvm)
 				mvm->fw->ucode_capa.n_scan_channels +
 			sizeof(struct iwl_scan_req_umac_tail);
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
-		return sizeof(struct iwl_scan_req_unified_lmac) +
-			sizeof(struct iwl_scan_channel_cfg_lmac) *
-				mvm->fw->ucode_capa.n_scan_channels +
-			sizeof(struct iwl_scan_probe_req);
-
-	return sizeof(struct iwl_scan_cmd) +
-		mvm->fw->ucode_capa.max_probe_length +
-			mvm->fw->ucode_capa.n_scan_channels *
-		sizeof(struct iwl_scan_channel);
+	return sizeof(struct iwl_scan_req_unified_lmac) +
+		sizeof(struct iwl_scan_channel_cfg_lmac) *
+		mvm->fw->ucode_capa.n_scan_channels +
+		sizeof(struct iwl_scan_probe_req);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 2b75a0d..8bdfb8b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -746,25 +746,6 @@ bool iwl_mvm_low_latency(struct iwl_mvm *mvm)
 	return result;
 }
 
-static void iwl_mvm_idle_iter(void *_data, u8 *mac, struct ieee80211_vif *vif)
-{
-	bool *idle = _data;
-
-	if (!vif->bss_conf.idle)
-		*idle = false;
-}
-
-bool iwl_mvm_is_idle(struct iwl_mvm *mvm)
-{
-	bool idle = true;
-
-	ieee80211_iterate_active_interfaces_atomic(
-			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-			iwl_mvm_idle_iter, &idle);
-
-	return idle;
-}
-
 struct iwl_bss_iter_data {
 	struct ieee80211_vif *vif;
 	bool error;
-- 
1.9.1

