Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31538 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131Ab3LNCdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 21:33:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: remove cfg_data construction
Date: Fri, 13 Dec 2013 18:33:00 -0800
Message-ID: <1386988382-30023-2-git-send-email-bzhao@marvell.com> (sfid-20131214_033347_106651_CF18E7D7)
In-Reply-To: <1386988382-30023-1-git-send-email-bzhao@marvell.com>
References: <1386988382-30023-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cfg_data buffer will include the cfg_data structure header
(action, type, data_len). This makes it work for all data types
without extra parsing.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h      |  9 ---------
 drivers/net/wireless/mwifiex/sta_cmd.c | 20 ++++++--------------
 2 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 8fcb500..4cee6ce 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -468,8 +468,6 @@ enum P2P_MODES {
 #define MWIFIEX_CRITERIA_UNICAST	BIT(1)
 #define MWIFIEX_CRITERIA_MULTICAST	BIT(3)
 
-#define CFG_DATA_TYPE_CAL		2
-
 struct mwifiex_ie_types_header {
 	__le16 type;
 	__le16 len;
@@ -1592,12 +1590,6 @@ struct mwifiex_ie_list {
 	struct mwifiex_ie ie_list[MAX_MGMT_IE_INDEX];
 } __packed;
 
-struct host_cmd_ds_802_11_cfg_data {
-	__le16 action;
-	__le16 type;
-	__le16 data_len;
-} __packed;
-
 struct coalesce_filt_field_param {
 	u8 operation;
 	u8 operand_len;
@@ -1678,7 +1670,6 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_sys_config uap_sys_config;
 		struct host_cmd_ds_sta_deauth sta_deauth;
 		struct host_cmd_11ac_vht_cfg vht_cfg;
-		struct host_cmd_ds_802_11_cfg_data cfg_data;
 		struct host_cmd_ds_coalesce_cfg coalesce_cfg;
 	} params;
 } __packed;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 1efa43e..2368c7f 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1158,28 +1158,20 @@ static u32 mwifiex_parse_cal_cfg(u8 *src, size_t len, u8 *dst)
 
 /* This function prepares command of set_cfg_data. */
 static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *cmd,
-				u16 cmd_action)
+				struct host_cmd_ds_command *cmd)
 {
-	struct host_cmd_ds_802_11_cfg_data *cfg_data = &cmd->params.cfg_data;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	u32 len, cal_data_offset;
-	u8 *tmp_cmd = (u8 *)cmd;
+	u32 len;
+	u8 *data = (u8 *)cmd + S_DS_GEN;
 
-	cal_data_offset = S_DS_GEN + sizeof(*cfg_data);
 	if ((adapter->cal_data->data) && (adapter->cal_data->size > 0))
 		len = mwifiex_parse_cal_cfg((u8 *)adapter->cal_data->data,
-					    adapter->cal_data->size,
-					    (u8 *)(tmp_cmd + cal_data_offset));
+					    adapter->cal_data->size, data);
 	else
 		return -1;
 
-	cfg_data->action = cpu_to_le16(cmd_action);
-	cfg_data->type = cpu_to_le16(CFG_DATA_TYPE_CAL);
-	cfg_data->data_len = cpu_to_le16(len);
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_CFG_DATA);
-	cmd->size = cpu_to_le16(S_DS_GEN + sizeof(*cfg_data) + len);
+	cmd->size = cpu_to_le16(S_DS_GEN + len);
 
 	return 0;
 }
@@ -1267,7 +1259,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_get_hw_spec(priv, cmd_ptr);
 		break;
 	case HostCmd_CMD_CFG_DATA:
-		ret = mwifiex_cmd_cfg_data(priv, cmd_ptr, cmd_action);
+		ret = mwifiex_cmd_cfg_data(priv, cmd_ptr);
 		break;
 	case HostCmd_CMD_MAC_CONTROL:
 		ret = mwifiex_cmd_mac_control(priv, cmd_ptr, cmd_action,
-- 
1.8.2.3

