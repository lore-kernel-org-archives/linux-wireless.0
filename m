Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12306 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbaBHAXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:23:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 08/30] mwifiex: implement extended scan feature
Date: Fri, 7 Feb 2014 16:23:37 -0800
Message-ID: <1391819017-20995-4-git-send-email-bzhao@marvell.com> (sfid-20140208_012349_202451_83D3CF20)
In-Reply-To: <1391819017-20995-1-git-send-email-bzhao@marvell.com>
References: <1391819017-20995-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In extended scan, host gets scan results through one or
multiple events instead of scan command response. Host will
send next scan command when all the events are received.

Legacy scan sometimes truncates scan results in a noisy
environment due to buffer length limitation. This issue
is addressed in extended scan.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c      |   3 +-
 drivers/net/wireless/mwifiex/fw.h          |  43 +++++++
 drivers/net/wireless/mwifiex/init.c        |   1 +
 drivers/net/wireless/mwifiex/main.h        |   9 +-
 drivers/net/wireless/mwifiex/scan.c        | 191 ++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/sta_cmd.c     |   3 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   5 +
 drivers/net/wireless/mwifiex/sta_event.c   |   8 ++
 8 files changed, 255 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 1ddc8b2..556cb2c 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -595,7 +595,8 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 	}
 
 	/* Send command */
-	if (cmd_no == HostCmd_CMD_802_11_SCAN) {
+	if (cmd_no == HostCmd_CMD_802_11_SCAN ||
+	    cmd_no == HostCmd_CMD_802_11_SCAN_EXT) {
 		mwifiex_queue_scan_cmd(priv, cmd_node);
 	} else {
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 9b26790..ed41af1 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -132,6 +132,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_RSSI_HIGH          (PROPRIETARY_TLV_BASE_ID + 22)
 #define TLV_TYPE_AUTH_TYPE          (PROPRIETARY_TLV_BASE_ID + 31)
 #define TLV_TYPE_STA_MAC_ADDR       (PROPRIETARY_TLV_BASE_ID + 32)
+#define TLV_TYPE_BSSID              (PROPRIETARY_TLV_BASE_ID + 35)
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
 #define TLV_TYPE_UAP_BEACON_PERIOD  (PROPRIETARY_TLV_BASE_ID + 44)
 #define TLV_TYPE_UAP_DTIM_PERIOD    (PROPRIETARY_TLV_BASE_ID + 45)
@@ -146,6 +147,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_RATE_DROP_CONTROL  (PROPRIETARY_TLV_BASE_ID + 82)
 #define TLV_TYPE_RATE_SCOPE         (PROPRIETARY_TLV_BASE_ID + 83)
 #define TLV_TYPE_POWER_GROUP        (PROPRIETARY_TLV_BASE_ID + 84)
+#define TLV_TYPE_BSS_SCAN_RSP       (PROPRIETARY_TLV_BASE_ID + 86)
+#define TLV_TYPE_BSS_SCAN_INFO      (PROPRIETARY_TLV_BASE_ID + 87)
 #define TLV_TYPE_UAP_RETRY_LIMIT    (PROPRIETARY_TLV_BASE_ID + 93)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
 #define TLV_TYPE_UAP_MGMT_FRAME     (PROPRIETARY_TLV_BASE_ID + 104)
@@ -295,6 +298,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_CAU_REG_ACCESS                    0x00ed
 #define HostCmd_CMD_SET_BSS_MODE                      0x00f7
 #define HostCmd_CMD_PCIE_DESC_DETAILS                 0x00fa
+#define HostCmd_CMD_802_11_SCAN_EXT                   0x0107
 #define HostCmd_CMD_COALESCE_CFG                      0x010a
 #define HostCmd_CMD_MGMT_FRAME_REG                    0x010c
 #define HostCmd_CMD_REMAIN_ON_CHAN                    0x010d
@@ -440,6 +444,7 @@ enum P2P_MODES {
 #define EVENT_UAP_MIC_COUNTERMEASURES   0x0000004c
 #define EVENT_HOSTWAKE_STAIE		0x0000004d
 #define EVENT_CHANNEL_SWITCH_ANN        0x00000050
+#define EVENT_EXT_SCAN_REPORT           0x00000058
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
 
 #define EVENT_ID_MASK                   0xffff
@@ -1053,6 +1058,16 @@ struct mwifiex_fixed_bcn_param {
 	__le16 cap_info_bitmap;
 } __packed;
 
+struct mwifiex_event_scan_result {
+	__le16 event_id;
+	u8 bss_index;
+	u8 bss_type;
+	u8 more_event;
+	u8 reserved[3];
+	__le16 buf_size;
+	u8 num_of_set;
+} __packed;
+
 #define MWIFIEX_USER_SCAN_CHAN_MAX             50
 
 #define MWIFIEX_MAX_SSID_LIST_LENGTH         10
@@ -1122,6 +1137,28 @@ struct host_cmd_ds_802_11_scan_rsp {
 	u8 bss_desc_and_tlv_buffer[1];
 } __packed;
 
+struct host_cmd_ds_802_11_scan_ext {
+	u32   reserved;
+	u8    tlv_buffer[1];
+} __packed;
+
+struct mwifiex_ie_types_bss_scan_rsp {
+	struct mwifiex_ie_types_header header;
+	u8 bssid[ETH_ALEN];
+	u8 frame_body[1];
+} __packed;
+
+struct mwifiex_ie_types_bss_scan_info {
+	struct mwifiex_ie_types_header header;
+	__le16 rssi;
+	__le16 anpi;
+	u8 cca_busy_fraction;
+	u8 radio_type;
+	u8 channel;
+	u8 reserved;
+	__le64 tsf;
+} __packed;
+
 struct host_cmd_ds_802_11_bg_scan_query {
 	u8 flush;
 } __packed;
@@ -1439,6 +1476,11 @@ struct host_cmd_tlv_rates {
 	u8 rates[0];
 } __packed;
 
+struct mwifiex_ie_types_bssid_list {
+	struct mwifiex_ie_types_header header;
+	u8 bssid[ETH_ALEN];
+} __packed;
+
 struct host_cmd_tlv_bcast_ssid {
 	struct mwifiex_ie_types_header header;
 	u8 bcast_ctl;
@@ -1632,6 +1674,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_802_11_ps_mode_enh psmode_enh;
 		struct host_cmd_ds_802_11_hs_cfg_enh opt_hs_cfg;
 		struct host_cmd_ds_802_11_scan scan;
+		struct host_cmd_ds_802_11_scan_ext ext_scan;
 		struct host_cmd_ds_802_11_scan_rsp scan_resp;
 		struct host_cmd_ds_802_11_bg_scan_query bg_scan_query;
 		struct host_cmd_ds_802_11_bg_scan_query_rsp bg_scan_query_resp;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 1d0a817..308c56f 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -281,6 +281,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->arp_filter_size = 0;
 	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
 	adapter->empty_tx_q_cnt = 0;
+	adapter->ext_scan = true;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d8ad554..1076c3f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -59,7 +59,7 @@ enum {
 
 #define MWIFIEX_UPLD_SIZE               (2312)
 
-#define MAX_EVENT_SIZE                  1024
+#define MAX_EVENT_SIZE                  2048
 
 #define ARP_FILTER_MAX_BUF_SIZE         68
 
@@ -753,6 +753,7 @@ struct mwifiex_adapter {
 	atomic_t is_tx_received;
 	atomic_t pending_bridged_pkts;
 	struct semaphore *card_sem;
+	bool ext_scan;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
@@ -938,6 +939,12 @@ mwifiex_set_wmm_params(struct mwifiex_private *priv,
 		       struct cfg80211_ap_settings *params);
 void mwifiex_set_ba_params(struct mwifiex_private *priv);
 void mwifiex_set_11ac_ba_params(struct mwifiex_private *priv);
+int mwifiex_cmd_802_11_scan_ext(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd,
+				void *data_buf);
+int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv);
+int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
+					 void *buf);
 
 /*
  * This function checks if the queuing is RA based or not.
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 3633347..2ed85a3 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -595,7 +595,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 	struct mwifiex_chan_scan_param_set *tmp_chan_list;
 	struct mwifiex_chan_scan_param_set *start_chan;
 
-	u32 tlv_idx, rates_size;
+	u32 tlv_idx, rates_size, cmd_no;
 	u32 total_scan_time;
 	u32 done_early;
 	u8 radio_type;
@@ -733,9 +733,13 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 
 		/* Send the scan command to the firmware with the specified
 		   cfg */
-		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SCAN,
-					     HostCmd_ACT_GEN_SET, 0,
-					     scan_cfg_out);
+		if (priv->adapter->ext_scan)
+			cmd_no = HostCmd_CMD_802_11_SCAN_EXT;
+		else
+			cmd_no = HostCmd_CMD_802_11_SCAN;
+
+		ret = mwifiex_send_cmd_async(priv, cmd_no, HostCmd_ACT_GEN_SET,
+					     0, scan_cfg_out);
 
 		/* rate IE is updated per scan command but same starting
 		 * pointer is used each time so that rate IE from earlier
@@ -786,6 +790,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_ie_types_num_probes *num_probes_tlv;
 	struct mwifiex_ie_types_wildcard_ssid_params *wildcard_ssid_tlv;
+	struct mwifiex_ie_types_bssid_list *bssid_tlv;
 	u8 *tlv_pos;
 	u32 num_probes;
 	u32 ssid_len;
@@ -848,6 +853,17 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 		       user_scan_in->specific_bssid,
 		       sizeof(scan_cfg_out->specific_bssid));
 
+		if (adapter->ext_scan &&
+		    !is_zero_ether_addr(scan_cfg_out->specific_bssid)) {
+			bssid_tlv =
+				(struct mwifiex_ie_types_bssid_list *)tlv_pos;
+			bssid_tlv->header.type = cpu_to_le16(TLV_TYPE_BSSID);
+			bssid_tlv->header.len = cpu_to_le16(ETH_ALEN);
+			memcpy(bssid_tlv->bssid, user_scan_in->specific_bssid,
+			       ETH_ALEN);
+			tlv_pos += sizeof(struct mwifiex_ie_types_bssid_list);
+		}
+
 		for (i = 0; i < user_scan_in->num_ssids; i++) {
 			ssid_len = user_scan_in->ssid_list[i].ssid_len;
 
@@ -1579,7 +1595,7 @@ done:
 static int
 mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 				  u32 *bytes_left, u64 fw_tsf, u8 *radio_type,
-				  bool ext_scan)
+				  bool ext_scan, s32 rssi_val)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_chan_freq_power *cfp;
@@ -1642,6 +1658,8 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 		current_ptr += sizeof(u8);
 		curr_bcn_bytes -= sizeof(u8);
 		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%d\n", rssi);
+	} else {
+		rssi = rssi_val;
 	}
 
 	bcn_param = (struct mwifiex_fixed_bcn_param *)current_ptr;
@@ -1914,7 +1932,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		ret = mwifiex_parse_single_response_buf(priv, &bss_info,
 							&bytes_left,
 							le64_to_cpu(fw_tsf),
-							radio_type, false);
+							radio_type, false, 0);
 		if (ret)
 			goto check_next_scan;
 	}
@@ -1925,6 +1943,167 @@ check_next_scan:
 }
 
 /*
+ * This function prepares an extended scan command to be sent to the firmware
+ *
+ * This uses the scan command configiguration sent to the command processing
+ * module in command preparation stage to configure a extended scan command
+ * structure to send to firmware.
+ */
+int mwifiex_cmd_802_11_scan_ext(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd,
+				void *data_buf)
+{
+	struct host_cmd_ds_802_11_scan_ext *ext_scan = &cmd->params.ext_scan;
+	struct mwifiex_scan_cmd_config *scan_cfg = data_buf;
+
+	memcpy(ext_scan->tlv_buffer, scan_cfg->tlv_buf, scan_cfg->tlv_buf_len);
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SCAN_EXT);
+
+	/* Size is equal to the sizeof(fixed portions) + the TLV len + header */
+	cmd->size = cpu_to_le16((u16)(sizeof(ext_scan->reserved)
+				      + scan_cfg->tlv_buf_len + S_DS_GEN));
+
+	return 0;
+}
+
+/* This function handles the command response of extended scan */
+int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv)
+{
+	dev_dbg(priv->adapter->dev, "info: EXT scan returns successfully\n");
+	return 0;
+}
+
+/* This function This function handles the event extended scan report. It
+ * parses extended scan results and informs to cfg80211 stack.
+ */
+int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
+					 void *buf)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 *bss_info;
+	u32 bytes_left, bytes_left_for_tlv, idx;
+	u16 type, len;
+	struct mwifiex_ie_types_data *tlv;
+	struct mwifiex_ie_types_bss_scan_rsp *scan_rsp_tlv;
+	struct mwifiex_ie_types_bss_scan_info *scan_info_tlv;
+	u8 *radio_type;
+	u64 fw_tsf = 0;
+	s32 rssi = 0;
+	struct mwifiex_event_scan_result *event_scan = buf;
+	u8 num_of_set = event_scan->num_of_set;
+	u8 *scan_resp = buf + sizeof(struct mwifiex_event_scan_result);
+	u16 scan_resp_size = le16_to_cpu(event_scan->buf_size);
+
+	if (num_of_set > MWIFIEX_MAX_AP) {
+		dev_err(adapter->dev,
+			"EXT_SCAN: Invalid number of AP returned (%d)!!\n",
+			num_of_set);
+		ret = -1;
+		goto check_next_scan;
+	}
+
+	bytes_left = scan_resp_size;
+	dev_dbg(adapter->dev,
+		"EXT_SCAN: size %d, returned %d APs...",
+		scan_resp_size, num_of_set);
+
+	tlv = (struct mwifiex_ie_types_data *)scan_resp;
+
+	for (idx = 0; idx < num_of_set && bytes_left; idx++) {
+		type = le16_to_cpu(tlv->header.type);
+		len = le16_to_cpu(tlv->header.len);
+		if (bytes_left < sizeof(struct mwifiex_ie_types_header) + len) {
+			dev_err(adapter->dev, "EXT_SCAN: Error bytes left < TLV length\n");
+			break;
+		}
+		scan_rsp_tlv = NULL;
+		scan_info_tlv = NULL;
+		bytes_left_for_tlv = bytes_left;
+
+		/* BSS response TLV with beacon or probe response buffer
+		 * at the initial position of each descriptor
+		 */
+		if (type != TLV_TYPE_BSS_SCAN_RSP)
+			break;
+
+		bss_info = (u8 *)tlv;
+		scan_rsp_tlv = (struct mwifiex_ie_types_bss_scan_rsp *)tlv;
+		tlv = (struct mwifiex_ie_types_data *)(tlv->data + len);
+		bytes_left_for_tlv -=
+				(len + sizeof(struct mwifiex_ie_types_header));
+
+		while (bytes_left_for_tlv >=
+		       sizeof(struct mwifiex_ie_types_header) &&
+		       le16_to_cpu(tlv->header.type) != TLV_TYPE_BSS_SCAN_RSP) {
+			type = le16_to_cpu(tlv->header.type);
+			len = le16_to_cpu(tlv->header.len);
+			if (bytes_left_for_tlv <
+			    sizeof(struct mwifiex_ie_types_header) + len) {
+				dev_err(adapter->dev,
+					"EXT_SCAN: Error in processing TLV, bytes left < TLV length\n");
+				scan_rsp_tlv = NULL;
+				bytes_left_for_tlv = 0;
+				continue;
+			}
+			switch (type) {
+			case TLV_TYPE_BSS_SCAN_INFO:
+				scan_info_tlv =
+				  (struct mwifiex_ie_types_bss_scan_info *)tlv;
+				if (len !=
+				 sizeof(struct mwifiex_ie_types_bss_scan_info) -
+				 sizeof(struct mwifiex_ie_types_header)) {
+					bytes_left_for_tlv = 0;
+					continue;
+				}
+				break;
+			default:
+				break;
+			}
+			tlv = (struct mwifiex_ie_types_data *)(tlv->data + len);
+			bytes_left -=
+				(len + sizeof(struct mwifiex_ie_types_header));
+			bytes_left_for_tlv -=
+				(len + sizeof(struct mwifiex_ie_types_header));
+		}
+
+		if (!scan_rsp_tlv)
+			break;
+
+		/* Advance pointer to the beacon buffer length and
+		 * update the bytes count so that the function
+		 * wlan_interpret_bss_desc_with_ie() can handle the
+		 * scan buffer withut any change
+		 */
+		bss_info += sizeof(u16);
+		bytes_left -= sizeof(u16);
+
+		if (scan_info_tlv) {
+			rssi = (s32)(s16)(le16_to_cpu(scan_info_tlv->rssi));
+			rssi *= 100;           /* Convert dBm to mBm */
+			dev_dbg(adapter->dev,
+				"info: InterpretIE: RSSI=%d\n", rssi);
+			fw_tsf = le64_to_cpu(scan_info_tlv->tsf);
+			radio_type = &scan_info_tlv->radio_type;
+		} else {
+			radio_type = NULL;
+		}
+		ret = mwifiex_parse_single_response_buf(priv, &bss_info,
+							&bytes_left, fw_tsf,
+							radio_type, true, rssi);
+		if (ret)
+			goto check_next_scan;
+	}
+
+check_next_scan:
+	if (!event_scan->more_event)
+		mwifiex_check_next_scan_command(priv);
+
+	return ret;
+}
+
+/*
  * This function prepares command for background scan query.
  *
  * Preparation includes -
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 9208a88..1b29912 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1472,6 +1472,9 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_ibss_coalescing_status(cmd_ptr, cmd_action,
 							 data_buf);
 		break;
+	case HostCmd_CMD_802_11_SCAN_EXT:
+		ret = mwifiex_cmd_802_11_scan_ext(priv, cmd_ptr, data_buf);
+		break;
 	case HostCmd_CMD_MAC_REG_ACCESS:
 	case HostCmd_CMD_BBP_REG_ACCESS:
 	case HostCmd_CMD_RF_REG_ACCESS:
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 24523e4..95e1358 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -69,6 +69,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 
 		break;
 	case HostCmd_CMD_802_11_SCAN:
+	case HostCmd_CMD_802_11_SCAN_EXT:
 		/* Cancel all pending scan command */
 		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 		list_for_each_entry_safe(cmd_node, tmp_node,
@@ -871,6 +872,10 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		ret = mwifiex_ret_802_11_scan(priv, resp);
 		adapter->curr_cmd->wait_q_enabled = false;
 		break;
+	case HostCmd_CMD_802_11_SCAN_EXT:
+		ret = mwifiex_ret_802_11_scan_ext(priv);
+		adapter->curr_cmd->wait_q_enabled = false;
+		break;
 	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
 		ret = mwifiex_ret_802_11_scan(priv, resp);
 		dev_dbg(adapter->dev,
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 8c351f7..de4a6af 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -331,6 +331,14 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "event: PORT RELEASE\n");
 		break;
 
+	case EVENT_EXT_SCAN_REPORT:
+		dev_dbg(adapter->dev, "event: EXT_SCAN Report\n");
+		if (adapter->ext_scan)
+			ret = mwifiex_handle_event_ext_scan_report(priv,
+						adapter->event_skb->data);
+
+		break;
+
 	case EVENT_WMM_STATUS_CHANGE:
 		dev_dbg(adapter->dev, "event: WMM status changed\n");
 		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_WMM_GET_STATUS,
-- 
1.8.2.3

