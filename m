Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50026 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaKXOgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:07 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so12669446wgg.35
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:06 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 42/75] iwlwifi: mvm: add TDLS channel switch FW APIs
Date: Mon, 24 Nov 2014 16:34:18 +0200
Message-Id: <1416839691-28533-42-git-send-email-egrumbach@gmail.com> (sfid-20141124_153901_171332_91AD0B37)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Add a channel-switch command and a switch-start notification. Also add a
FW TLV bit indicating TDLS channel switching support.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h     |  2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 83 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c    |  2 +
 3 files changed, 87 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 78d3e5f..a94d244 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -157,6 +157,7 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT: supports Quiet Period requests
  * @IWL_UCODE_TLV_CAPA_DQA_SUPPORT: supports dynamic queue allocation (DQA),
  *	which also implies support for the scheduler configuration command
+ * @IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH: supports TDLS channel switching
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
@@ -167,6 +168,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= BIT(10),
 	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= BIT(11),
 	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= BIT(12),
+	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= BIT(13),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 1a67788..a71fad2e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -128,6 +128,10 @@ enum {
 	/* global key */
 	WEP_KEY = 0x20,
 
+	/* TDLS */
+	TDLS_CHANNEL_SWITCH_CMD = 0x27,
+	TDLS_CHANNEL_SWITCH_NOTIFICATION = 0xaa,
+
 	/* MAC and Binding commands */
 	MAC_CONTEXT_CMD = 0x28,
 	TIME_EVENT_CMD = 0x29, /* both CMD and response */
@@ -1717,4 +1721,83 @@ struct iwl_scd_txq_cfg_cmd {
 	u8 flags;
 } __packed;
 
+/***********************************
+ * TDLS API
+ ***********************************/
+
+/* Type of TDLS request */
+enum iwl_tdls_channel_switch_type {
+	TDLS_SEND_CHAN_SW_REQ = 0,
+	TDLS_SEND_CHAN_SW_RESP_AND_MOVE_CH,
+	TDLS_MOVE_CH,
+}; /* TDLS_STA_CHANNEL_SWITCH_CMD_TYPE_API_E_VER_1 */
+
+/**
+ * Switch timing sub-element in a TDLS channel-switch command
+ * @frame_timestamp: GP2 timestamp of channel-switch request/response packet
+ *	received from peer
+ * @max_offchan_duration: What amount of microseconds out of a DTIM is given
+ *	to the TDLS off-channel communication. For instance if the DTIM is
+ *	200TU and the TDLS peer is to be given 25% of the time, the value
+ *	given will be 50TU, or 50 * 1024 if translated into microseconds.
+ * @switch_time: switch time the peer sent in its channel switch timing IE
+ * @switch_timout: switch timeout the peer sent in its channel switch timing IE
+ */
+struct iwl_tdls_channel_switch_timing {
+	__le32 frame_timestamp; /* GP2 time of peer packet Rx */
+	__le32 max_offchan_duration; /* given in micro-seconds */
+	__le32 switch_time; /* given in micro-seconds */
+	__le32 switch_timeout; /* given in micro-seconds */
+} __packed; /* TDLS_STA_CHANNEL_SWITCH_TIMING_DATA_API_S_VER_1 */
+
+#define IWL_TDLS_CH_SW_FRAME_MAX_SIZE 200
+
+/**
+ * TDLS channel switch frame template
+ *
+ * A template representing a TDLS channel-switch request or response frame
+ *
+ * @switch_time_offset: offset to the channel switch timing IE in the template
+ * @tx_cmd: Tx parameters for the frame
+ * @data: frame data
+ */
+struct iwl_tdls_channel_switch_frame {
+	__le32 switch_time_offset;
+	struct iwl_tx_cmd tx_cmd;
+	u8 data[IWL_TDLS_CH_SW_FRAME_MAX_SIZE];
+} __packed; /* TDLS_STA_CHANNEL_SWITCH_FRAME_API_S_VER_1 */
+
+/**
+ * TDLS channel switch command
+ *
+ * The command is sent to initiate a channel switch and also in response to
+ * incoming TDLS channel-switch request/response packets from remote peers.
+ *
+ * @switch_type: see &enum iwl_tdls_channel_switch_type
+ * @peer_sta_id: station id of TDLS peer
+ * @ci: channel we switch to
+ * @timing: timing related data for command
+ * @frame: channel-switch request/response template, depending to switch_type
+ */
+struct iwl_tdls_channel_switch_cmd {
+	u8 switch_type;
+	__le32 peer_sta_id;
+	struct iwl_fw_channel_info ci;
+	struct iwl_tdls_channel_switch_timing timing;
+	struct iwl_tdls_channel_switch_frame frame;
+} __packed; /* TDLS_STA_CHANNEL_SWITCH_CMD_API_S_VER_1 */
+
+/**
+ * TDLS channel switch start notification
+ *
+ * @status: non-zero on success
+ * @offchannel_duration: duration given in microseconds
+ * @sta_id: peer currently performing the channel-switch with
+ */
+struct iwl_tdls_channel_switch_notif {
+	__le32 status;
+	__le32 offchannel_duration;
+	__le32 sta_id;
+} __packed; /* TDLS_STA_CHANNEL_SWITCH_NTFY_API_S_VER_1 */
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index b022fc0..8ee7362 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -352,6 +352,8 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(SCAN_REQ_UMAC),
 	CMD(SCAN_ABORT_UMAC),
 	CMD(SCAN_COMPLETE_UMAC),
+	CMD(TDLS_CHANNEL_SWITCH_CMD),
+	CMD(TDLS_CHANNEL_SWITCH_NOTIFICATION),
 };
 #undef CMD
 
-- 
1.9.1

