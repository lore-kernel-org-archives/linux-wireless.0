Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1133 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab1H2M2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:28:01 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 05/20] ath6kl: Add new WMI commands and events for P2P
Date: Mon, 29 Aug 2011 15:23:46 +0300
Message-ID: <1314620641-24257-6-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_142805_179905_801C8D88)
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |  293 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |  184 ++++++++++++++++++++-
 2 files changed, 469 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 5c6688b..261ccff 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -425,6 +425,148 @@ static int ath6kl_wmi_tx_complete_event_rx(u8 *datap, int len)
 	return 0;
 }
 
+static int ath6kl_wmi_remain_on_chnl_event_rx(u8 *datap, int len)
+{
+	struct wmi_remain_on_chnl_event *ev;
+	u32 freq;
+	u32 dur;
+
+	if (len < sizeof(*ev))
+		return -EINVAL;
+
+	ev = (struct wmi_remain_on_chnl_event *) datap;
+	freq = le32_to_cpu(ev->freq);
+	dur = le32_to_cpu(ev->duration);
+	ath6kl_dbg(ATH6KL_DBG_WMI, "remain_on_chnl: freq=%u dur=%u\n",
+		   freq, dur);
+
+	return 0;
+}
+
+static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(u8 *datap, int len)
+{
+	struct wmi_cancel_remain_on_chnl_event *ev;
+	u32 freq;
+	u32 dur;
+
+	if (len < sizeof(*ev))
+		return -EINVAL;
+
+	ev = (struct wmi_cancel_remain_on_chnl_event *) datap;
+	freq = le32_to_cpu(ev->freq);
+	dur = le32_to_cpu(ev->duration);
+	ath6kl_dbg(ATH6KL_DBG_WMI, "cancel_remain_on_chnl: freq=%u dur=%u "
+		   "status=%u\n", freq, dur, ev->status);
+
+	return 0;
+}
+
+static int ath6kl_wmi_tx_status_event_rx(u8 *datap, int len)
+{
+	struct wmi_tx_status_event *ev;
+	u32 id;
+
+	if (len < sizeof(*ev))
+		return -EINVAL;
+
+	ev = (struct wmi_tx_status_event *) datap;
+	id = le32_to_cpu(ev->id);
+	ath6kl_dbg(ATH6KL_DBG_WMI, "tx_status: id=%x ack_status=%u\n",
+		   id, ev->ack_status);
+
+	return 0;
+}
+
+static int ath6kl_wmi_rx_probe_req_event_rx(u8 *datap, int len)
+{
+	struct wmi_p2p_rx_probe_req_event *ev;
+	u16 dlen;
+
+	if (len < sizeof(*ev))
+		return -EINVAL;
+
+	ev = (struct wmi_p2p_rx_probe_req_event *) datap;
+	dlen = le16_to_cpu(ev->len);
+	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_probe_req: len=%u\n",
+		   dlen);
+
+	return 0;
+}
+
+static int ath6kl_wmi_p2p_capabilities_event_rx(u8 *datap, int len)
+{
+	struct wmi_p2p_capabilities_event *ev;
+	u16 dlen;
+
+	if (len < sizeof(*ev))
+		return -EINVAL;
+
+	ev = (struct wmi_p2p_capabilities_event *) datap;
+	dlen = le16_to_cpu(ev->len);
+	ath6kl_dbg(ATH6KL_DBG_WMI, "p2p_capab: len=%u\n", dlen);
+
+	return 0;
+}
+
+static int ath6kl_wmi_rx_action_event_rx(u8 *datap, int len)
+{
+	struct wmi_rx_action_event *ev;
+	u16 dlen;
+
+	if (len < sizeof(*ev))
+		return -EINVAL;
+
+	ev = (struct wmi_rx_action_event *) datap;
+	dlen = le16_to_cpu(ev->len);
+	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_action: len=%u\n", dlen);
+
+	return 0;
+}
+
+static int ath6kl_wmi_p2p_info_event_rx(u8 *datap, int len)
+{
+	struct wmi_p2p_info_event *ev;
+	u32 flags;
+	u16 dlen;
+
+	if (len < sizeof(*ev))
+		return -EINVAL;
+
+	ev = (struct wmi_p2p_info_event *) datap;
+	flags = le32_to_cpu(ev->info_req_flags);
+	dlen = le16_to_cpu(ev->len);
+	ath6kl_dbg(ATH6KL_DBG_WMI, "p2p_info: flags=%x len=%d\n", flags, dlen);
+
+	if (flags & P2P_FLAG_CAPABILITIES_REQ) {
+		struct wmi_p2p_capabilities *cap;
+		if (dlen < sizeof(*cap))
+			return -EINVAL;
+		cap = (struct wmi_p2p_capabilities *) ev->data;
+		ath6kl_dbg(ATH6KL_DBG_WMI, "p2p_info: GO Power Save = %d\n",
+			   cap->go_power_save);
+	}
+
+	if (flags & P2P_FLAG_MACADDR_REQ) {
+		struct wmi_p2p_macaddr *mac;
+		if (dlen < sizeof(*mac))
+			return -EINVAL;
+		mac = (struct wmi_p2p_macaddr *) ev->data;
+		ath6kl_dbg(ATH6KL_DBG_WMI, "p2p_info: MAC Address = %pM\n",
+			   mac->mac_addr);
+	}
+
+	if (flags & P2P_FLAG_HMODEL_REQ) {
+		struct wmi_p2p_hmodel *mod;
+		if (dlen < sizeof(*mod))
+			return -EINVAL;
+		mod = (struct wmi_p2p_hmodel *) ev->data;
+		ath6kl_dbg(ATH6KL_DBG_WMI, "p2p_info: P2P Model = %d (%s)\n",
+			   mod->p2p_model,
+			   mod->p2p_model ? "host" : "firmware");
+	}
+	return 0;
+}
+
 static inline struct sk_buff *ath6kl_wmi_get_new_buf(u32 size)
 {
 	struct sk_buff *skb;
@@ -2523,6 +2665,128 @@ int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 mgmt_frm_type, const u8 *ie,
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_disable_11b_rates_cmd(struct wmi *wmi, bool disable)
+{
+	struct sk_buff *skb;
+	struct wmi_disable_11b_rates_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "disable_11b_rates_cmd: disable=%u\n",
+		   disable);
+	cmd = (struct wmi_disable_11b_rates_cmd *) skb->data;
+	cmd->disable = disable ? 1 : 0;
+
+	return ath6kl_wmi_cmd_send(wmi, skb, WMI_DISABLE_11B_RATES_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
+int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u32 freq, u32 dur)
+{
+	struct sk_buff *skb;
+	struct wmi_remain_on_chnl_cmd *p;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*p));
+	if (!skb)
+		return -ENOMEM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "remain_on_chnl_cmd: freq=%u dur=%u\n",
+		   freq, dur);
+	p = (struct wmi_remain_on_chnl_cmd *) skb->data;
+	p->freq = cpu_to_le32(freq);
+	p->duration = cpu_to_le32(dur);
+	return ath6kl_wmi_cmd_send(wmi, skb, WMI_REMAIN_ON_CHNL_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
+int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u32 id, u32 freq, u32 wait,
+			       const u8 *data, u16 data_len)
+{
+	struct sk_buff *skb;
+	struct wmi_send_action_cmd *p;
+
+	if (wait)
+		return -EINVAL; /* Offload for wait not supported */
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*p) + data_len);
+	if (!skb)
+		return -ENOMEM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "send_action_cmd: id=%u freq=%u wait=%u "
+		   "len=%u\n", id, freq, wait, data_len);
+	p = (struct wmi_send_action_cmd *) skb->data;
+	p->id = cpu_to_le32(id);
+	p->freq = cpu_to_le32(freq);
+	p->wait = cpu_to_le32(wait);
+	p->len = cpu_to_le16(data_len);
+	memcpy(p->data, data, data_len);
+	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SEND_ACTION_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
+int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u32 freq,
+				       const u8 *dst,
+				       const u8 *data, u16 data_len)
+{
+	struct sk_buff *skb;
+	struct wmi_p2p_probe_response_cmd *p;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*p) + data_len);
+	if (!skb)
+		return -ENOMEM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "send_probe_response_cmd: freq=%u dst=%pM "
+		   "len=%u\n", freq, dst, data_len);
+	p = (struct wmi_p2p_probe_response_cmd *) skb->data;
+	p->freq = cpu_to_le32(freq);
+	memcpy(p->destination_addr, dst, ETH_ALEN);
+	p->len = cpu_to_le16(data_len);
+	memcpy(p->data, data, data_len);
+	return ath6kl_wmi_cmd_send(wmi, skb, WMI_SEND_PROBE_RESPONSE_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
+int ath6kl_wmi_probe_report_req_cmd(struct wmi *wmi, bool enable)
+{
+	struct sk_buff *skb;
+	struct wmi_probe_req_report_cmd *p;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*p));
+	if (!skb)
+		return -ENOMEM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "probe_report_req_cmd: enable=%u\n",
+		   enable);
+	p = (struct wmi_probe_req_report_cmd *) skb->data;
+	p->enable = enable ? 1 : 0;
+	return ath6kl_wmi_cmd_send(wmi, skb, WMI_PROBE_REQ_REPORT_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
+int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u32 info_req_flags)
+{
+	struct sk_buff *skb;
+	struct wmi_get_p2p_info *p;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*p));
+	if (!skb)
+		return -ENOMEM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "info_req_cmd: flags=%x\n",
+		   info_req_flags);
+	p = (struct wmi_get_p2p_info *) skb->data;
+	p->info_req_flags = cpu_to_le32(info_req_flags);
+	return ath6kl_wmi_cmd_send(wmi, skb, WMI_GET_P2P_INFO_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
+int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi)
+{
+	ath6kl_dbg(ATH6KL_DBG_WMI, "cancel_remain_on_chnl_cmd\n");
+	return ath6kl_wmi_simple_cmd(wmi, WMI_CANCEL_REMAIN_ON_CHNL_CMDID);
+}
 
 static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 {
@@ -2743,6 +3007,35 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TX_COMPLETE_EVENTID\n");
 		ret = ath6kl_wmi_tx_complete_event_rx(datap, len);
 		break;
+	case WMI_REMAIN_ON_CHNL_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REMAIN_ON_CHNL_EVENTID\n");
+		ret = ath6kl_wmi_remain_on_chnl_event_rx(datap, len);
+		break;
+	case WMI_CANCEL_REMAIN_ON_CHNL_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "WMI_CANCEL_REMAIN_ON_CHNL_EVENTID\n");
+		ret = ath6kl_wmi_cancel_remain_on_chnl_event_rx(datap, len);
+		break;
+	case WMI_TX_STATUS_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TX_STATUS_EVENTID\n");
+		ret = ath6kl_wmi_tx_status_event_rx(datap, len);
+		break;
+	case WMI_RX_PROBE_REQ_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_PROBE_REQ_EVENTID\n");
+		ret = ath6kl_wmi_rx_probe_req_event_rx(datap, len);
+		break;
+	case WMI_P2P_CAPABILITIES_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_P2P_CAPABILITIES_EVENTID\n");
+		ret = ath6kl_wmi_p2p_capabilities_event_rx(datap, len);
+		break;
+	case WMI_RX_ACTION_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_ACTION_EVENTID\n");
+		ret = ath6kl_wmi_rx_action_event_rx(datap, len);
+		break;
+	case WMI_P2P_INFO_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_P2P_INFO_EVENTID\n");
+		ret = ath6kl_wmi_p2p_info_event_rx(datap, len);
+		break;
 	default:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "unknown cmd id 0x%x\n", id);
 		wmi->stat.cmd_id_err++;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 2d22c7f9..9a01d38 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -490,17 +490,52 @@ enum wmi_cmd_id {
 	WMI_SET_PASSPHRASE_CMDID,
 	WMI_SEND_ASSOC_RES_CMDID,
 	WMI_SET_ASSOC_REQ_RELAY_CMDID,
-	WMI_GET_RFKILL_MODE_CMDID,
 
 	/* ACS command, consists of sub-commands */
 	WMI_ACS_CTRL_CMDID,
+	WMI_SET_EXCESS_TX_RETRY_THRES_CMDID,
+	WMI_SET_TBD_TIME_CMDID, /*added for wmiconfig command for TBD */
+
+	/* Pktlog cmds */
+	WMI_PKTLOG_ENABLE_CMDID,
+	WMI_PKTLOG_DISABLE_CMDID,
+
+	/* More P2P Cmds */
+	WMI_P2P_GO_NEG_REQ_RSP_CMDID,
+	WMI_P2P_GRP_INIT_CMDID,
+	WMI_P2P_GRP_FORMATION_DONE_CMDID,
+	WMI_P2P_INVITE_CMDID,
+	WMI_P2P_INVITE_REQ_RSP_CMDID,
+	WMI_P2P_PROV_DISC_REQ_CMDID,
+	WMI_P2P_SET_CMDID,
 
+	WMI_GET_RFKILL_MODE_CMDID,
+	WMI_SET_RFKILL_MODE_CMDID,
+	WMI_AP_SET_APSD_CMDID,
+	WMI_AP_APSD_BUFFERED_TRAFFIC_CMDID,
+
+	WMI_P2P_SDPD_TX_CMDID, /* F05C */
+	WMI_P2P_STOP_SDPD_CMDID,
+	WMI_P2P_CANCEL_CMDID,
 	/* Ultra low power store / recall commands */
 	WMI_STORERECALL_CONFIGURE_CMDID,
 	WMI_STORERECALL_RECALL_CMDID,
 	WMI_STORERECALL_HOST_READY_CMDID,
 	WMI_FORCE_TARGET_ASSERT_CMDID,
-	WMI_SET_EXCESS_TX_RETRY_THRES_CMDID,
+
+	WMI_SET_PROBED_SSID_EX_CMDID,
+	WMI_SET_NETWORK_LIST_OFFLOAD_CMDID,
+	WMI_SET_ARP_NS_OFFLOAD_CMDID,
+	WMI_ADD_WOW_EXT_PATTERN_CMDID,
+	WMI_GTK_OFFLOAD_OP_CMDID,
+	WMI_REMAIN_ON_CHNL_CMDID,
+	WMI_CANCEL_REMAIN_ON_CHNL_CMDID,
+	WMI_SEND_ACTION_CMDID,
+	WMI_PROBE_REQ_REPORT_CMDID,
+	WMI_DISABLE_11B_RATES_CMDID,
+	WMI_SEND_PROBE_RESPONSE_CMDID,
+	WMI_GET_P2P_INFO_CMDID,
+	WMI_AP_JOIN_BSS_CMDID,
 };
 
 enum wfi_mgmt_frame_type {
@@ -1188,15 +1223,26 @@ enum wmi_event_id {
 	WMI_WAC_START_WPS_EVENTID,
 	WMI_WAC_CTRL_REQ_REPLY_EVENTID,
 
+	WMI_REPORT_WMM_PARAMS_EVENTID,
+	WMI_WAC_REJECT_WPS_EVENTID,
+
+	/* More P2P Events */
+	WMI_P2P_GO_NEG_REQ_EVENTID,
+	WMI_P2P_INVITE_REQ_EVENTID,
+	WMI_P2P_INVITE_RCVD_RESULT_EVENTID,
+	WMI_P2P_INVITE_SENT_RESULT_EVENTID,
+	WMI_P2P_PROV_DISC_RESP_EVENTID,
+	WMI_P2P_PROV_DISC_REQ_EVENTID,
+
 	/* RFKILL Events */
 	WMI_RFKILL_STATE_CHANGE_EVENTID,
 	WMI_RFKILL_GET_MODE_CMD_EVENTID,
-	WMI_THIN_RESERVED_START_EVENTID = 0x8000,
 
-	/*
-	 * Events in this range are reserved for thinmode
-	 * See wmi_thin.h for actual definitions
-	 */
+	WMI_P2P_START_SDPD_EVENTID,
+	WMI_P2P_SDPD_RX_EVENTID,
+
+	WMI_THIN_RESERVED_START_EVENTID = 0x8000,
+	/* Events in this range are reserved for thinmode */
 	WMI_THIN_RESERVED_END_EVENTID = 0x8fff,
 
 	WMI_SET_CHANNEL_EVENTID,
@@ -1204,7 +1250,17 @@ enum wmi_event_id {
 
 	/* Generic ACS event */
 	WMI_ACS_EVENTID,
-	WMI_REPORT_WMM_PARAMS_EVENTID
+	WMI_STORERECALL_STORE_EVENTID,
+	WMI_WOW_EXT_WAKE_EVENTID,
+	WMI_GTK_OFFLOAD_STATUS_EVENTID,
+	WMI_NETWORK_LIST_OFFLOAD_EVENTID,
+	WMI_REMAIN_ON_CHNL_EVENTID,
+	WMI_CANCEL_REMAIN_ON_CHNL_EVENTID,
+	WMI_TX_STATUS_EVENTID,
+	WMI_RX_PROBE_REQ_EVENTID,
+	WMI_P2P_CAPABILITIES_EVENTID,
+	WMI_RX_ACTION_EVENTID,
+	WMI_P2P_INFO_EVENTID,
 };
 
 struct wmi_ready_event_2 {
@@ -1870,6 +1926,100 @@ struct wmi_ap_mode_stat {
 
 /* End of AP mode definitions */
 
+struct wmi_remain_on_chnl_cmd {
+	__le32 freq;
+	__le32 duration;
+} __packed;
+
+struct wmi_send_action_cmd {
+	__le32 id;
+	__le32 freq;
+	__le32 wait;
+	__le16 len;
+	u8 data[0];
+} __packed;
+
+struct wmi_tx_status_event {
+	__le32 id;
+	u8 ack_status;
+} __packed;
+
+struct wmi_probe_req_report_cmd {
+	u8 enable;
+} __packed;
+
+struct wmi_disable_11b_rates_cmd {
+	u8 disable;
+} __packed;
+
+struct wmi_set_appie_extended_cmd {
+	u8 role_id;
+	u8 mgmt_frm_type;
+	u8 ie_len;
+	u8 ie_info[0];
+} __packed;
+
+struct wmi_remain_on_chnl_event {
+	__le32 freq;
+	__le32 duration;
+} __packed;
+
+struct wmi_cancel_remain_on_chnl_event {
+	__le32 freq;
+	__le32 duration;
+	u8 status;
+} __packed;
+
+struct wmi_rx_action_event {
+	__le32 freq;
+	__le16 len;
+	u8 data[0];
+} __packed;
+
+struct wmi_p2p_capabilities_event {
+	__le16 len;
+	u8 data[0];
+} __packed;
+
+struct wmi_p2p_rx_probe_req_event {
+	__le32 freq;
+	__le16 len;
+	u8 data[0];
+} __packed;
+
+#define P2P_FLAG_CAPABILITIES_REQ   (0x00000001)
+#define P2P_FLAG_MACADDR_REQ        (0x00000002)
+#define P2P_FLAG_HMODEL_REQ         (0x00000002)
+
+struct wmi_get_p2p_info {
+	__le32 info_req_flags;
+} __packed;
+
+struct wmi_p2p_info_event {
+	__le32 info_req_flags;
+	__le16 len;
+	u8 data[0];
+} __packed;
+
+struct wmi_p2p_capabilities {
+	u8 go_power_save;
+} __packed;
+
+struct wmi_p2p_macaddr {
+	u8 mac_addr[ETH_ALEN];
+} __packed;
+
+struct wmi_p2p_hmodel {
+	u8 p2p_model;
+} __packed;
+
+struct wmi_p2p_probe_response_cmd {
+	__le32 freq;
+	u8 destination_addr[ETH_ALEN];
+	__le16 len;
+	u8 data[0];
+} __packed;
+
 /* Extended WMI (WMIX)
  *
  * Extended WMIX commands are encapsulated in a WMI message with
@@ -2048,6 +2198,24 @@ int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_version,
 int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 mgmt_frm_type, const u8 *ie,
 			     u8 ie_len);
 
+/* P2P */
+int ath6kl_wmi_disable_11b_rates_cmd(struct wmi *wmi, bool disable);
+
+int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u32 freq, u32 dur);
+
+int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u32 id, u32 freq, u32 wait,
+			       const u8 *data, u16 data_len);
+
+int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u32 freq,
+				       const u8 *dst,
+				       const u8 *data, u16 data_len);
+
+int ath6kl_wmi_probe_report_req_cmd(struct wmi *wmi, bool enable);
+
+int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u32 info_req_flags);
+
+int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi);
+
 void *ath6kl_wmi_init(struct ath6kl *devt);
 void ath6kl_wmi_shutdown(struct wmi *wmi);
 
-- 
1.7.4.1

