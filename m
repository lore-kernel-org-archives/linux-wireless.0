Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3674 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758106AbbJIL1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 07:27:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t99BPHxW011866
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2015 04:27:09 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 1xaccgxgck-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2015 04:27:09 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2] mwifiex: control WLAN and bluetooth coexistence modes
Date: Fri, 9 Oct 2015 04:26:23 -0700
Message-ID: <1444389983-4827-1-git-send-email-akarwar@marvell.com> (sfid-20151009_132748_381853_9C4AEEF0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By default our chip will be in spatial coexistence mode.
This patch adds a provision to change it to timeshare mode
via debugfs command.

Enable timeshare coexistence mode
   echo 1 > /sys/kernel/debug/mwifiex/mlan0/timeshare_coex

Go back to spacial coexistence mode
   echo 0 > /sys/kernel/debug/mwifiex/mlan0/timeshare_coex

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Used debugfs instead of sysfs to control coexist(Kalle Valo)
---
 drivers/net/wireless/mwifiex/debugfs.c     | 52 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h          | 16 +++++++++
 drivers/net/wireless/mwifiex/sta_cmd.c     | 31 ++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 25 ++++++++++++++
 4 files changed, 124 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 5583856..9824d8d 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -856,6 +856,56 @@ mwifiex_hscfg_read(struct file *file, char __user *ubuf,
 	return ret;
 }
 
+static ssize_t
+mwifiex_timeshare_coex_read(struct file *file, char __user *ubuf,
+			    size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv = file->private_data;
+	char buf[3];
+	bool timeshare_coex;
+	int ret;
+	unsigned int len;
+
+	if (priv->adapter->fw_api_ver != MWIFIEX_FW_V15)
+		return -EOPNOTSUPP;
+
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_ROBUST_COEX,
+			       HostCmd_ACT_GEN_GET, 0, &timeshare_coex, true);
+	if (ret)
+		return ret;
+
+	len = sprintf(buf, "%d\n", timeshare_coex);
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static ssize_t
+mwifiex_timeshare_coex_write(struct file *file, const char __user *ubuf,
+			     size_t count, loff_t *ppos)
+{
+	bool timeshare_coex;
+	struct mwifiex_private *priv = file->private_data;
+	char kbuf[16];
+	int ret;
+
+	if (priv->adapter->fw_api_ver != MWIFIEX_FW_V15)
+		return -EOPNOTSUPP;
+
+	memset(kbuf, 0, sizeof(kbuf));
+
+	if (copy_from_user(&kbuf, ubuf, min_t(size_t, sizeof(kbuf) - 1, count)))
+		return -EFAULT;
+
+	if (strtobool(kbuf, &timeshare_coex))
+		return -EINVAL;
+
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_ROBUST_COEX,
+			       HostCmd_ACT_GEN_SET, 0, &timeshare_coex, true);
+	if (ret)
+		return ret;
+	else
+		return count;
+}
+
 #define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
 	if (!debugfs_create_file(#name, 0644, priv->dfs_dev_dir,        \
 			priv, &mwifiex_dfs_##name##_fops))              \
@@ -892,6 +942,7 @@ MWIFIEX_DFS_FILE_OPS(memrw);
 MWIFIEX_DFS_FILE_OPS(hscfg);
 MWIFIEX_DFS_FILE_OPS(histogram);
 MWIFIEX_DFS_FILE_OPS(debug_mask);
+MWIFIEX_DFS_FILE_OPS(timeshare_coex);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -918,6 +969,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(hscfg);
 	MWIFIEX_DFS_ADD_FILE(histogram);
 	MWIFIEX_DFS_ADD_FILE(debug_mask);
+	MWIFIEX_DFS_ADD_FILE(timeshare_coex);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 0e6f029..1e1e81a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -101,6 +101,9 @@ enum KEY_TYPE_ID {
 #define FIRMWARE_READY_SDIO				0xfedc
 #define FIRMWARE_READY_PCIE				0xfedcba00
 
+#define MWIFIEX_COEX_MODE_TIMESHARE			0x01
+#define MWIFIEX_COEX_MODE_SPATIAL			0x82
+
 enum mwifiex_usb_ep {
 	MWIFIEX_USB_EP_CMD_EVENT = 1,
 	MWIFIEX_USB_EP_DATA = 2,
@@ -163,6 +166,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_CHANRPT_11H_BASIC  (PROPRIETARY_TLV_BASE_ID + 91)
 #define TLV_TYPE_UAP_RETRY_LIMIT    (PROPRIETARY_TLV_BASE_ID + 93)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
+#define TLV_TYPE_ROBUST_COEX        (PROPRIETARY_TLV_BASE_ID + 96)
 #define TLV_TYPE_UAP_MGMT_FRAME     (PROPRIETARY_TLV_BASE_ID + 104)
 #define TLV_TYPE_MGMT_IE            (PROPRIETARY_TLV_BASE_ID + 105)
 #define TLV_TYPE_AUTO_DS_PARAM      (PROPRIETARY_TLV_BASE_ID + 113)
@@ -354,6 +358,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_AMSDU_AGGR_CTRL                   0x00df
 #define HostCmd_CMD_TXPWR_CFG                         0x00d1
 #define HostCmd_CMD_TX_RATE_CFG                       0x00d6
+#define HostCmd_CMD_ROBUST_COEX                       0x00e0
 #define HostCmd_CMD_802_11_PS_MODE_ENH                0x00e4
 #define HostCmd_CMD_802_11_HS_CFG_ENH                 0x00e5
 #define HostCmd_CMD_P2P_MODE_CFG                      0x00eb
@@ -1877,6 +1882,11 @@ struct mwifiex_ie_types_btcoex_aggr_win_size {
 	u8 reserved;
 } __packed;
 
+struct mwifiex_ie_types_robust_coex {
+	struct mwifiex_ie_types_header header;
+	__le32 mode;
+} __packed;
+
 struct host_cmd_ds_version_ext {
 	u8 version_str_sel;
 	char version_str[128];
@@ -2078,6 +2088,11 @@ struct host_cmd_ds_multi_chan_policy {
 	__le16 policy;
 } __packed;
 
+struct host_cmd_ds_robust_coex {
+	__le16 action;
+	__le16 reserved;
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -2147,6 +2162,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_chan_rpt_req chan_rpt_req;
 		struct host_cmd_sdio_sp_rx_aggr_cfg sdio_rx_aggr_cfg;
 		struct host_cmd_ds_multi_chan_policy mc_policy;
+		struct host_cmd_ds_robust_coex coex;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 504b321..e486867 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1531,6 +1531,33 @@ mwifiex_cmd_set_mc_policy(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int mwifiex_cmd_robust_coex(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   u16 cmd_action, bool *is_timeshare)
+{
+	struct host_cmd_ds_robust_coex *coex = &cmd->params.coex;
+	struct mwifiex_ie_types_robust_coex *coex_tlv;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_ROBUST_COEX);
+	cmd->size = cpu_to_le16(sizeof(*coex) + sizeof(*coex_tlv) + S_DS_GEN);
+
+	coex->action = cpu_to_le16(cmd_action);
+	coex_tlv = (struct mwifiex_ie_types_robust_coex *)
+				((u8 *)coex + sizeof(*coex));
+	coex_tlv->header.type = cpu_to_le16(TLV_TYPE_ROBUST_COEX);
+	coex_tlv->header.len = cpu_to_le16(sizeof(coex_tlv->mode));
+
+	if (coex->action == HostCmd_ACT_GEN_GET)
+		return 0;
+
+	if (*is_timeshare)
+		coex_tlv->mode = cpu_to_le32(MWIFIEX_COEX_MODE_TIMESHARE);
+	else
+		coex_tlv->mode = cpu_to_le32(MWIFIEX_COEX_MODE_SPATIAL);
+
+	return 0;
+}
+
 static int
 mwifiex_cmd_coalesce_cfg(struct mwifiex_private *priv,
 			 struct host_cmd_ds_command *cmd,
@@ -2040,6 +2067,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_set_mc_policy(priv, cmd_ptr, cmd_action,
 						data_buf);
 		break;
+	case HostCmd_CMD_ROBUST_COEX:
+		ret = mwifiex_cmd_robust_coex(priv, cmd_ptr, cmd_action,
+					      data_buf);
+		break;
 	default:
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "PREP_CMD: unknown cmd- %#x\n", cmd_no);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index d0961635..9ac7aa2 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1007,6 +1007,28 @@ static int mwifiex_ret_sdio_rx_aggr_cfg(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int mwifiex_ret_robust_coex(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *resp,
+				   bool *is_timeshare)
+{
+	struct host_cmd_ds_robust_coex *coex = &resp->params.coex;
+	struct mwifiex_ie_types_robust_coex *coex_tlv;
+	u16 action = le16_to_cpu(coex->action);
+	u32 mode;
+
+	coex_tlv = (struct mwifiex_ie_types_robust_coex
+		    *)((u8 *)coex + sizeof(struct host_cmd_ds_robust_coex));
+	if (action == HostCmd_ACT_GEN_GET) {
+		mode = le32_to_cpu(coex_tlv->mode);
+		if (mode == MWIFIEX_COEX_MODE_TIMESHARE)
+			*is_timeshare = true;
+		else
+			*is_timeshare = false;
+	}
+
+	return 0;
+}
+
 /*
  * This function handles the command responses.
  *
@@ -1213,6 +1235,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_TDLS_CONFIG:
 		break;
+	case HostCmd_CMD_ROBUST_COEX:
+		ret = mwifiex_ret_robust_coex(priv, resp, data_buf);
+		break;
 	default:
 		mwifiex_dbg(adapter, ERROR,
 			    "CMD_RESP: unknown cmd response %#x\n",
-- 
1.8.1.4

