Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49593 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756632Ab3ERAzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:55:00 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 08/17] mwifiex: add calibration data download feature
Date: Fri, 17 May 2013 17:50:25 -0700
Message-ID: <1368838234-32585-9-git-send-email-bzhao@marvell.com> (sfid-20130518_025504_228130_79CD897F)
In-Reply-To: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
References: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

User can provide a text file containing calibration data in hex
format while loading mwifiex module. It will be downloaded to
firmware.
eg. insmod mwifiex.ko cal_data_cfg=cal_data.conf

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h          | 10 +++++
 drivers/net/wireless/mwifiex/main.c        | 13 +++++++
 drivers/net/wireless/mwifiex/main.h        |  1 +
 drivers/net/wireless/mwifiex/sta_cmd.c     | 62 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 15 ++++++++
 5 files changed, 101 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index d3c1e01..d6ada73 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -271,6 +271,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_802_11_SUBSCRIBE_EVENT            0x0075
 #define HostCmd_CMD_802_11_TX_RATE_QUERY              0x007f
 #define HostCmd_CMD_802_11_IBSS_COALESCING_STATUS     0x0083
+#define HostCmd_CMD_CFG_DATA                          0x008f
 #define HostCmd_CMD_VERSION_EXT                       0x0097
 #define HostCmd_CMD_MEF_CFG                           0x009a
 #define HostCmd_CMD_RSSI_INFO                         0x00a4
@@ -465,6 +466,8 @@ enum P2P_MODES {
 #define MWIFIEX_CRITERIA_UNICAST	BIT(1)
 #define MWIFIEX_CRITERIA_MULTICAST	BIT(3)
 
+#define CFG_DATA_TYPE_CAL		2
+
 struct mwifiex_ie_types_header {
 	__le16 type;
 	__le16 len;
@@ -1579,6 +1582,12 @@ struct mwifiex_ie_list {
 	struct mwifiex_ie ie_list[MAX_MGMT_IE_INDEX];
 } __packed;
 
+struct host_cmd_ds_802_11_cfg_data {
+	__le16 action;
+	__le16 type;
+	__le16 data_len;
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -1638,6 +1647,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_sys_config uap_sys_config;
 		struct host_cmd_ds_sta_deauth sta_deauth;
 		struct host_cmd_11ac_vht_cfg vht_cfg;
+		struct host_cmd_ds_802_11_cfg_data cfg_data;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 4e7270c..5bc7ef8 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -25,6 +25,8 @@
 #define VERSION	"1.0"
 
 const char driver_version[] = "mwifiex " VERSION " (%s) ";
+static char *cal_data_cfg;
+module_param(cal_data_cfg, charp, 0);
 
 /*
  * This function registers the device and performs all the necessary
@@ -336,6 +338,13 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 
 	dev_notice(adapter->dev, "WLAN FW is active\n");
 
+	if (cal_data_cfg) {
+		if ((request_firmware(&adapter->cal_data, cal_data_cfg,
+				      adapter->dev)) < 0)
+			dev_err(adapter->dev,
+				"Cal data request_firmware() failed\n");
+	}
+
 	adapter->init_wait_q_woken = false;
 	ret = mwifiex_init_fw(adapter);
 	if (ret == -1) {
@@ -390,6 +399,10 @@ err_init_fw:
 	pr_debug("info: %s: unregister device\n", __func__);
 	adapter->if_ops.unregister_dev(adapter);
 done:
+	if (adapter->cal_data) {
+		release_firmware(adapter->cal_data);
+		adapter->cal_data = NULL;
+	}
 	release_firmware(adapter->firmware);
 	complete(&adapter->fw_load);
 	return;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 9cf6852..0832c24 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -730,6 +730,7 @@ struct mwifiex_adapter {
 	u16 max_mgmt_ie_index;
 	u8 scan_delay_cnt;
 	u8 empty_tx_q_cnt;
+	const struct firmware *cal_data;
 
 	/* 11AC */
 	u32 is_hw_11ac_capable;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index b193e25..8ece485 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1134,6 +1134,55 @@ mwifiex_cmd_mef_cfg(struct mwifiex_private *priv,
 	return 0;
 }
 
+/* This function parse cal data from ASCII to hex */
+static u32 mwifiex_parse_cal_cfg(u8 *src, size_t len, u8 *dst)
+{
+	u8 *s = src, *d = dst;
+
+	while (s - src < len) {
+		if (*s && (isspace(*s) || *s == '\t')) {
+			s++;
+			continue;
+		}
+		if (isxdigit(*s)) {
+			*d++ = simple_strtol(s, NULL, 16);
+			s += 2;
+		} else {
+			s++;
+		}
+	}
+
+	return d - dst;
+}
+
+/* This function prepares command of set_cfg_data. */
+static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd,
+				u16 cmd_action)
+{
+	struct host_cmd_ds_802_11_cfg_data *cfg_data = &cmd->params.cfg_data;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u32 len, cal_data_offset;
+	u8 *tmp_cmd = (u8 *)cmd;
+
+	cal_data_offset = S_DS_GEN + sizeof(*cfg_data);
+	if ((adapter->cal_data->data) && (adapter->cal_data->size > 0))
+		len = mwifiex_parse_cal_cfg((u8 *)adapter->cal_data->data,
+					    adapter->cal_data->size,
+					    (u8 *)(tmp_cmd + cal_data_offset));
+	else
+		return -1;
+
+	cfg_data->action = cpu_to_le16(cmd_action);
+	cfg_data->type = cpu_to_le16(CFG_DATA_TYPE_CAL);
+	cfg_data->data_len = cpu_to_le16(len);
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_CFG_DATA);
+	cmd->size = cpu_to_le16(S_DS_GEN + sizeof(*cfg_data) + len);
+
+	return 0;
+}
+
 /*
  * This function prepares the commands before sending them to the firmware.
  *
@@ -1152,6 +1201,9 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_GET_HW_SPEC:
 		ret = mwifiex_cmd_get_hw_spec(priv, cmd_ptr);
 		break;
+	case HostCmd_CMD_CFG_DATA:
+		ret = mwifiex_cmd_cfg_data(priv, cmd_ptr, cmd_action);
+		break;
 	case HostCmd_CMD_MAC_CONTROL:
 		ret = mwifiex_cmd_mac_control(priv, cmd_ptr, cmd_action,
 					      data_buf);
@@ -1384,6 +1436,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
  */
 int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret;
 	u16 enable = true;
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
@@ -1404,6 +1457,15 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 					    HostCmd_ACT_GEN_SET, 0, NULL);
 		if (ret)
 			return -1;
+
+		/* Download calibration data to firmware */
+		if (adapter->cal_data) {
+			ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_CFG_DATA,
+						HostCmd_ACT_GEN_SET, 0, NULL);
+			if (ret)
+				return -1;
+		}
+
 		/* Read MAC address from HW */
 		ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_GET_HW_SPEC,
 					    HostCmd_ACT_GEN_GET, 0, NULL);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index c710a1b..d85df15 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -818,6 +818,18 @@ static int mwifiex_ret_subsc_evt(struct mwifiex_private *priv,
 	return 0;
 }
 
+/* This function handles the command response of set_cfg_data */
+static int mwifiex_ret_cfg_data(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *resp)
+{
+	if (resp->result != HostCmd_RESULT_OK) {
+		dev_err(priv->adapter->dev, "Cal data cmd resp failed\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 /*
  * This function handles the command responses.
  *
@@ -841,6 +853,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_GET_HW_SPEC:
 		ret = mwifiex_ret_get_hw_spec(priv, resp);
 		break;
+	case HostCmd_CMD_CFG_DATA:
+		ret = mwifiex_ret_cfg_data(priv, resp);
+		break;
 	case HostCmd_CMD_MAC_CONTROL:
 		break;
 	case HostCmd_CMD_802_11_MAC_ADDRESS:
-- 
1.8.2.3

