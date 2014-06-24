Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47195 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaFXTwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:35 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so895550wgg.20
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:33 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/27] iwlwifi: mvm: don't use hardcoded num of scan channels
Date: Tue, 24 Jun 2014 22:51:58 +0300
Message-Id: <1403639541-4621-4-git-send-email-egrumbach@gmail.com> (sfid-20140624_215243_913281_01BFB1A7)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Use num of scan channels as advertised by fw TLV.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c         |  9 +++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h     |  1 +
 drivers/net/wireless/iwlwifi/iwl-fw.h          |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 47 ++++++++------------------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  3 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c         |  3 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 43 ++++++++++++++---------
 7 files changed, 56 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index f2a5c12..bf584d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -155,6 +155,8 @@ static struct iwlwifi_opmode_table {
 	[MVM_OP_MODE] = { .name = "iwlmvm", .ops = NULL },
 };
 
+#define IWL_DEFAULT_SCAN_CHANNELS 40
+
 /*
  * struct fw_sec: Just for the image parsing proccess.
  * For the fw storage we are using struct fw_desc.
@@ -819,6 +821,12 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			if (iwl_store_cscheme(&drv->fw, tlv_data, tlv_len))
 				goto invalid_tlv_len;
 			break;
+		case IWL_UCODE_TLV_N_SCAN_CHANNELS:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			capa->n_scan_channels =
+				le32_to_cpup((__le32 *)tlv_data);
+			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
@@ -973,6 +981,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
 			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE;
+	fw->ucode_capa.n_scan_channels = IWL_DEFAULT_SCAN_CHANNELS;
 
 	if (!api_ok)
 		api_ok = api_max;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index b45e576..9e6ba1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -128,6 +128,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_CSCHEME		= 28,
 	IWL_UCODE_TLV_API_CHANGES_SET	= 29,
 	IWL_UCODE_TLV_ENABLED_CAPABILITIES	= 30,
+	IWL_UCODE_TLV_N_SCAN_CHANNELS		= 31,
 };
 
 struct iwl_ucode_tlv {
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 0aa7c00..de975cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -178,6 +178,7 @@ enum iwl_ucode_sec {
 
 struct iwl_ucode_capabilities {
 	u32 max_probe_length;
+	u32 n_scan_channels;
 	u32 standard_phy_calibration_size;
 	u32 flags;
 	u32 api[IWL_API_ARRAY_SIZE];
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 6959fda..1d58692 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -170,18 +170,12 @@ enum iwl_scan_type {
 }; /* SCAN_ACTIVITY_TYPE_E_VER_1 */
 
 /**
- * Maximal number of channels to scan
- * it should be equal to:
- * max(IWL_NUM_CHANNELS, IWL_NUM_CHANNELS_FAMILY_8000)
- */
-#define MAX_NUM_SCAN_CHANNELS 50
-
-/**
  * struct iwl_scan_cmd - scan request command
  * ( SCAN_REQUEST_CMD = 0x80 )
  * @len: command length in bytes
  * @scan_flags: scan flags from SCAN_FLAGS_*
- * @channel_count: num of channels in channel list (1 - MAX_NUM_SCAN_CHANNELS)
+ * @channel_count: num of channels in channel list
+ *	(1 - ucode_capa.n_scan_channels)
  * @quiet_time: in msecs, dwell this time for active scan on quiet channels
  * @quiet_plcp_th: quiet PLCP threshold (channel is quiet if less than
  *	this number of packets were received (typically 1)
@@ -345,7 +339,7 @@ struct iwl_scan_results_notif {
  * @last_channel: last channel that was scanned
  * @tsf_low: TSF timer (lower half) in usecs
  * @tsf_high: TSF timer (higher half) in usecs
- * @results: all scan results, only "scanned_channels" of them are valid
+ * @results: array of scan results, only "scanned_channels" of them are valid
  */
 struct iwl_scan_complete_notif {
 	u8 scanned_channels;
@@ -354,11 +348,10 @@ struct iwl_scan_complete_notif {
 	u8 last_channel;
 	__le32 tsf_low;
 	__le32 tsf_high;
-	struct iwl_scan_results_notif results[MAX_NUM_SCAN_CHANNELS];
+	struct iwl_scan_results_notif results[];
 } __packed; /* SCAN_COMPLETE_NTF_API_S_VER_2 */
 
 /* scan offload */
-#define IWL_MAX_SCAN_CHANNELS		40
 #define IWL_SCAN_MAX_BLACKLIST_LEN	64
 #define IWL_SCAN_SHORT_BLACKLIST_LEN	16
 #define IWL_SCAN_MAX_PROFILES		11
@@ -423,36 +416,24 @@ enum iwl_scan_offload_channel_flags {
 	IWL_SCAN_OFFLOAD_CHANNEL_PARTIAL	= BIT(25),
 };
 
-/**
- * iwl_scan_channel_cfg - SCAN_CHANNEL_CFG_S
- * @type:		bitmap - see enum iwl_scan_offload_channel_flags.
- *			0:	passive (0) or active (1) scan.
- *			1-20:	directed scan to i'th ssid.
- *			22:	channel width configuation - 1 for narrow.
- *			24:	full scan.
- *			25:	partial scan.
- * @channel_number:	channel number 1-13 etc.
- * @iter_count:		repetition count for the channel.
- * @iter_interval:	interval between two innteration on one channel.
- * @dwell_time:	entry 0 - active scan, entry 1 - passive scan.
+/* channel configuration for struct iwl_scan_offload_cfg. Each channels needs:
+ * __le32 type:	bitmap; bits 1-20 are for directed scan to i'th ssid and
+ *	see enum iwl_scan_offload_channel_flags.
+ * __le16 channel_number: channel number 1-13 etc.
+ * __le16 iter_count: repetition count for the channel.
+ * __le32 iter_interval: interval between two innteration on one channel.
+ * u8 active_dwell.
+ * u8 passive_dwell.
  */
-struct iwl_scan_channel_cfg {
-	__le32 type[IWL_MAX_SCAN_CHANNELS];
-	__le16 channel_number[IWL_MAX_SCAN_CHANNELS];
-	__le16 iter_count[IWL_MAX_SCAN_CHANNELS];
-	__le32 iter_interval[IWL_MAX_SCAN_CHANNELS];
-	u8 dwell_time[IWL_MAX_SCAN_CHANNELS][2];
-} __packed;
+#define IWL_SCAN_CHAN_SIZE 14
 
 /**
  * iwl_scan_offload_cfg - SCAN_OFFLOAD_CONFIG_API_S
  * @scan_cmd:		scan command fixed part
- * @channel_cfg:	scan channel configuration
- * @data:		probe request frames (one per band)
+ * @data:		scan channel configuration and probe request frames
  */
 struct iwl_scan_offload_cfg {
 	struct iwl_scan_offload_cmd scan_cmd;
-	struct iwl_scan_channel_cfg channel_cfg;
 	u8 data[0];
 } __packed;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 41c0aac..f22be88 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1543,7 +1543,8 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 
-	if (req->n_channels == 0 || req->n_channels > MAX_NUM_SCAN_CHANNELS)
+	if (req->n_channels == 0 ||
+	    req->n_channels > mvm->fw->ucode_capa.n_scan_channels)
 		return -EINVAL;
 
 	mutex_lock(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index cc2f7de..a46f028 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -504,7 +504,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	scan_size = sizeof(struct iwl_scan_cmd) +
 		mvm->fw->ucode_capa.max_probe_length +
-		(MAX_NUM_SCAN_CHANNELS * sizeof(struct iwl_scan_channel));
+		(mvm->fw->ucode_capa.n_scan_channels *
+					sizeof(struct iwl_scan_channel));
 	mvm->scan_cmd = kmalloc(scan_size, GFP_KERNEL);
 	if (!mvm->scan_cmd)
 		goto out_free;
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 40c112f..349d8e6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -666,12 +666,19 @@ static void iwl_scan_offload_build_ssid(struct cfg80211_sched_scan_request *req,
 
 static void iwl_build_channel_cfg(struct iwl_mvm *mvm,
 				  struct cfg80211_sched_scan_request *req,
-				  struct iwl_scan_channel_cfg *channels,
+				  u8 *channels_buffer,
 				  enum ieee80211_band band,
 				  int *head,
 				  u32 ssid_bitmap,
 				  struct iwl_mvm_scan_params *params)
 {
+	u32 n_channels = mvm->fw->ucode_capa.n_scan_channels;
+	__le32 *type = (__le32 *)channels_buffer;
+	__le16 *channel_number = (__le16 *)(type + n_channels);
+	__le16 *iter_count = channel_number + n_channels;
+	__le32 *iter_interval = (__le32 *)(iter_count + n_channels);
+	u8 *active_dwell = (u8 *)(iter_interval + n_channels);
+	u8 *passive_dwell = active_dwell + n_channels;
 	int i, index = 0;
 
 	for (i = 0; i < req->n_channels; i++) {
@@ -683,27 +690,26 @@ static void iwl_build_channel_cfg(struct iwl_mvm *mvm,
 		index = *head;
 		(*head)++;
 
-		channels->channel_number[index] = cpu_to_le16(chan->hw_value);
-		channels->dwell_time[index][0] = params->dwell[band].active;
-		channels->dwell_time[index][1] = params->dwell[band].passive;
+		channel_number[index] = cpu_to_le16(chan->hw_value);
+		active_dwell[index] = params->dwell[band].active;
+		passive_dwell[index] = params->dwell[band].passive;
 
-		channels->iter_count[index] = cpu_to_le16(1);
-		channels->iter_interval[index] = 0;
+		iter_count[index] = cpu_to_le16(1);
+		iter_interval[index] = 0;
 
 		if (!(chan->flags & IEEE80211_CHAN_NO_IR))
-			channels->type[index] |=
+			type[index] |=
 				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_ACTIVE);
 
-		channels->type[index] |=
-				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_FULL |
-					    IWL_SCAN_OFFLOAD_CHANNEL_PARTIAL);
+		type[index] |= cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_FULL |
+					   IWL_SCAN_OFFLOAD_CHANNEL_PARTIAL);
 
 		if (chan->flags & IEEE80211_CHAN_NO_HT40)
-			channels->type[index] |=
+			type[index] |=
 				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_NARROW);
 
 		/* scan for all SSIDs from req->ssids */
-		channels->type[index] |= cpu_to_le32(ssid_bitmap);
+		type[index] |= cpu_to_le32(ssid_bitmap);
 	}
 }
 
@@ -718,6 +724,7 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 	u32 ssid_bitmap;
 	int cmd_len;
 	int ret;
+	u8 *probes;
 
 	struct iwl_scan_offload_cfg *scan_cfg;
 	struct iwl_host_cmd cmd = {
@@ -728,12 +735,16 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	cmd_len = sizeof(struct iwl_scan_offload_cfg) +
+		  mvm->fw->ucode_capa.n_scan_channels * IWL_SCAN_CHAN_SIZE +
 		  2 * SCAN_OFFLOAD_PROBE_REQ_SIZE;
 
 	scan_cfg = kzalloc(cmd_len, GFP_KERNEL);
 	if (!scan_cfg)
 		return -ENOMEM;
 
+	probes = scan_cfg->data +
+		mvm->fw->ucode_capa.n_scan_channels * IWL_SCAN_CHAN_SIZE;
+
 	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, 0, &params);
 	iwl_build_scan_cmd(mvm, vif, req, &scan_cfg->scan_cmd, &params);
 	scan_cfg->scan_cmd.len = cpu_to_le16(cmd_len);
@@ -744,8 +755,8 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 		iwl_scan_offload_build_tx_cmd(mvm, vif, ies,
 					      IEEE80211_BAND_2GHZ,
 					      &scan_cfg->scan_cmd.tx_cmd[0],
-					      scan_cfg->data);
-		iwl_build_channel_cfg(mvm, req, &scan_cfg->channel_cfg,
+					      probes);
+		iwl_build_channel_cfg(mvm, req, scan_cfg->data,
 				      IEEE80211_BAND_2GHZ, &head,
 				      ssid_bitmap, &params);
 	}
@@ -753,9 +764,9 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 		iwl_scan_offload_build_tx_cmd(mvm, vif, ies,
 					      IEEE80211_BAND_5GHZ,
 					      &scan_cfg->scan_cmd.tx_cmd[1],
-					      scan_cfg->data +
+					      probes +
 						SCAN_OFFLOAD_PROBE_REQ_SIZE);
-		iwl_build_channel_cfg(mvm, req, &scan_cfg->channel_cfg,
+		iwl_build_channel_cfg(mvm, req, scan_cfg->data,
 				      IEEE80211_BAND_5GHZ, &head,
 				      ssid_bitmap, &params);
 	}
-- 
1.8.3.2

