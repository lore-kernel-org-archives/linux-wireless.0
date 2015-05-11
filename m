Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56358 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391AbbEKNsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 09:48:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4BDmoWY004693
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:48:50 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1u9729wwwd-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:48:50 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/4] mwifiex: add support for FW memory read/write operations
Date: Tue, 12 May 2015 00:48:17 +0530
Message-ID: <1431371900-7260-1-git-send-email-patila@marvell.com> (sfid-20150511_154920_450304_4B609E5F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chin-ran Lo <crlo@marvell.com>

This patch adds support for FW memory read/write operations via debugfs.
This is useful during debugging FW issues.

Examples:

For reading FW memory location:
echo r 0x01ac > /sys/kernel/debug/mwifiex/mlan0/memrw
cat /sys/kernel/debug/mwifiex/mlan0/memrw

For writing FW memory location:
echo w 0x01ac 0x55aa > /sys/kernel/debug/mwifiex/mlan0/memrw

Signed-off-by: Chin-ran Lo <crlo@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c     | 79 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h          |  9 ++++
 drivers/net/wireless/mwifiex/ioctl.h       |  5 ++
 drivers/net/wireless/mwifiex/main.h        |  1 +
 drivers/net/wireless/mwifiex/sta_cmd.c     | 23 +++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 16 ++++++
 6 files changed, 133 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 1fb329d..414ee2d 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -535,6 +535,83 @@ done:
 	return ret;
 }
 
+/* Proc memrw file write handler.
+ * This function is called when the 'memrw' file is opened for writing
+ * This function can be used to write to a memory location.
+ */
+static ssize_t
+mwifiex_memrw_write(struct file *file, const char __user *ubuf, size_t count,
+		    loff_t *ppos)
+{
+	int ret;
+	char cmd;
+	struct mwifiex_ds_mem_rw mem_rw;
+	u16 cmd_action;
+	struct mwifiex_private *priv = (void *)file->private_data;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (void *)addr;
+	size_t buf_size = min(count, (size_t)(PAGE_SIZE - 1));
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, ubuf, buf_size)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	ret = sscanf(buf, "%c %x %x", &cmd, &mem_rw.addr, &mem_rw.value);
+	if (ret != 3) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	if ((cmd == 'r') || (cmd == 'R')) {
+		cmd_action = HostCmd_ACT_GEN_GET;
+		mem_rw.value = 0;
+	} else if ((cmd == 'w') || (cmd == 'W')) {
+		cmd_action = HostCmd_ACT_GEN_SET;
+	} else {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	memcpy(&priv->mem_rw, &mem_rw, sizeof(mem_rw));
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_MEM_ACCESS, cmd_action, 0,
+			     &mem_rw, true))
+		ret = -1;
+	else
+		ret = count;
+
+done:
+	free_page(addr);
+	return ret;
+}
+
+/* Proc memrw file read handler.
+ * This function is called when the 'memrw' file is opened for reading
+ * This function can be used to read from a memory location.
+ */
+static ssize_t
+mwifiex_memrw_read(struct file *file, char __user *ubuf,
+		   size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv = (void *)file->private_data;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+	int ret, pos = 0;
+
+	if (!buf)
+		return -ENOMEM;
+
+	pos += snprintf(buf, PAGE_SIZE, "0x%x 0x%x\n", priv->mem_rw.addr,
+			priv->mem_rw.value);
+	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
+
+	free_page(addr);
+	return ret;
+}
+
 static u32 saved_offset = -1, saved_bytes = -1;
 
 /*
@@ -749,6 +826,7 @@ MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_READ_OPS(fw_dump);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
+MWIFIEX_DFS_FILE_OPS(memrw);
 MWIFIEX_DFS_FILE_OPS(hscfg);
 MWIFIEX_DFS_FILE_OPS(histogram);
 
@@ -773,6 +851,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
 	MWIFIEX_DFS_ADD_FILE(fw_dump);
+	MWIFIEX_DFS_ADD_FILE(memrw);
 	MWIFIEX_DFS_ADD_FILE(hscfg);
 	MWIFIEX_DFS_ADD_FILE(histogram);
 }
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 59d8964..c404390 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -323,6 +323,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_802_11_SUBSCRIBE_EVENT            0x0075
 #define HostCmd_CMD_802_11_TX_RATE_QUERY              0x007f
 #define HostCmd_CMD_802_11_IBSS_COALESCING_STATUS     0x0083
+#define HostCmd_CMD_MEM_ACCESS                        0x0086
 #define HostCmd_CMD_CFG_DATA                          0x008f
 #define HostCmd_CMD_VERSION_EXT                       0x0097
 #define HostCmd_CMD_MEF_CFG                           0x009a
@@ -1576,6 +1577,13 @@ struct mwifiex_ie_types_extcap {
 	u8 ext_capab[0];
 } __packed;
 
+struct host_cmd_ds_mem_access {
+	__le16 action;
+	__le16 reserved;
+	__le32 addr;
+	__le32 value;
+};
+
 struct mwifiex_ie_types_qos_info {
 	struct mwifiex_ie_types_header header;
 	u8 qos_info;
@@ -1958,6 +1966,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_p2p_mode_cfg mode_cfg;
 		struct host_cmd_ds_802_11_ibss_status ibss_coalescing;
 		struct host_cmd_ds_mef_cfg mef_cfg;
+		struct host_cmd_ds_mem_access mem;
 		struct host_cmd_ds_mac_reg_access mac_reg;
 		struct host_cmd_ds_bbp_reg_access bbp_reg;
 		struct host_cmd_ds_rf_reg_access rf_reg;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index d2b05c3..224c993 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -342,6 +342,11 @@ struct mwifiex_ds_read_eeprom {
 	u8 value[MAX_EEPROM_DATA];
 };
 
+struct mwifiex_ds_mem_rw {
+	u32 addr;
+	u32 value;
+};
+
 #define IEEE_MAX_IE_SIZE		256
 
 #define MWIFIEX_IE_HDR_SIZE	(sizeof(struct mwifiex_ie) - IEEE_MAX_IE_SIZE)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index fe12560..b387d5a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -611,6 +611,7 @@ struct mwifiex_private {
 	struct delayed_work dfs_chan_sw_work;
 	struct cfg80211_beacon_data beacon_after;
 	struct mwifiex_11h_intf_state state_11h;
+	struct mwifiex_ds_mem_rw mem_rw;
 };
 
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 49422f2..a76d6a4 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1071,6 +1071,26 @@ static int mwifiex_cmd_ibss_coalescing_status(struct host_cmd_ds_command *cmd,
 	return 0;
 }
 
+/* This function prepares command buffer to get/set memory location value.
+ */
+static int
+mwifiex_cmd_mem_access(struct host_cmd_ds_command *cmd, u16 cmd_action,
+		       void *pdata_buf)
+{
+	struct mwifiex_ds_mem_rw *mem_rw = (void *)pdata_buf;
+	struct host_cmd_ds_mem_access *mem_access = (void *)&cmd->params.mem;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_MEM_ACCESS);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_mem_access) +
+				S_DS_GEN);
+
+	mem_access->action = cpu_to_le16(cmd_action);
+	mem_access->addr = cpu_to_le32(mem_rw->addr);
+	mem_access->value = cpu_to_le32(mem_rw->value);
+
+	return 0;
+}
+
 /*
  * This function prepares command to set/get register value.
  *
@@ -1885,6 +1905,9 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_802_11_SCAN_EXT:
 		ret = mwifiex_cmd_802_11_scan_ext(priv, cmd_ptr, data_buf);
 		break;
+	case HostCmd_CMD_MEM_ACCESS:
+		ret = mwifiex_cmd_mem_access(cmd_ptr, cmd_action, data_buf);
+		break;
 	case HostCmd_CMD_MAC_REG_ACCESS:
 	case HostCmd_CMD_BBP_REG_ACCESS:
 	case HostCmd_CMD_RF_REG_ACCESS:
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 88dc6b6..efe31a2 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -741,6 +741,19 @@ mwifiex_ret_p2p_mode_cfg(struct mwifiex_private *priv,
 	return 0;
 }
 
+/* This function handles the command response of mem_access command
+ */
+static int
+mwifiex_ret_mem_access(struct mwifiex_private *priv,
+		       struct host_cmd_ds_command *resp, void *pioctl_buf)
+{
+	struct host_cmd_ds_mem_access *mem = (void *)&resp->params.mem;
+
+	priv->mem_rw.addr = le32_to_cpu(mem->addr);
+	priv->mem_rw.value = le32_to_cpu(mem->value);
+
+	return 0;
+}
 /*
  * This function handles the command response of register access.
  *
@@ -1103,6 +1116,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_802_11_IBSS_COALESCING_STATUS:
 		ret = mwifiex_ret_ibss_coalescing_status(priv, resp);
 		break;
+	case HostCmd_CMD_MEM_ACCESS:
+		ret = mwifiex_ret_mem_access(priv, resp, data_buf);
+		break;
 	case HostCmd_CMD_MAC_REG_ACCESS:
 	case HostCmd_CMD_BBP_REG_ACCESS:
 	case HostCmd_CMD_RF_REG_ACCESS:
-- 
1.8.1.4

