Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42474 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1CQAGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:06:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 04/11] mwifiex: remove antcfg command from debugfs
Date: Wed, 16 Mar 2011 17:09:27 -0700
Message-Id: <1300320574-10793-5-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Mode 1 is selected for using Tx/Rx antenna 1 by default.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README        |   16 ----
 drivers/net/wireless/mwifiex/debugfs.c     |   73 -------------------
 drivers/net/wireless/mwifiex/fw.h          |    7 --
 drivers/net/wireless/mwifiex/main.h        |    7 --
 drivers/net/wireless/mwifiex/sta_cmd.c     |   32 --------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   27 -------
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  106 ----------------------------
 7 files changed, 0 insertions(+), 268 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index d51830a..7f25d1a 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -163,22 +163,6 @@ info
 
 
 3) FOR DRIVER CONFIGURATION
-antcfg
-	This command is used to set/get the mode of Tx/Rx antenna.
-	Usage:
-		echo "[m]" > antcfg
-		cat antcfg
-
-	where value of m is:
-		1       -- Tx/Rx antenna 1.
-		2       -- Tx/Rx antenna 2.
-		65535   -- Tx/Rx antenna diversity.
-
-	Examples:
-		cat antcfg		             : Get Tx/Rx antenna mode
-		echo "1" > antcfg		     : Set Tx/Rx antenna 1
-		echo "65535" > antcfg		     : Set Tx/Rx antenna diversity
-
 txbufcfg
 	This command can be used to set max transmit buffer size of firmware. Increasing this
 	buffer size is recommended for AMSDU packets. (Default is 2048)
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index f5ad86e..cccaf93 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -810,77 +810,6 @@ mwifiex_qoscfg_read(struct file *file, char __user *ubuf,
 	return ret;
 }
 
-/*
- * Proc antcfg file write handler.
- *
- * This function is called when the 'antcfg' file is opened for writing
- *
- * This function can be used to set the antenna configuration.
- */
-static ssize_t
-mwifiex_antcfg_write(struct file *file,
-		     const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int antcfg = 0;
-	int ret = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, ubuf, buf_size)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	sscanf(buf, "%d", &antcfg);
-
-	ret = mwifiex_set_tx_rx_ant(priv, antcfg);
-
-	if (!ret)
-		ret = count;
-	else
-		ret = -EINVAL;
-done:
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc antcfg file read handler.
- *
- * This function is called when the 'antcfg' file is opened for reading
- *
- * This function can be used to get the antenna configuration.
- */
-static ssize_t
-mwifiex_antcfg_read(struct file *file, char __user *ubuf,
-		    size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	int antcfg;
-
-	if (!buf)
-		return -ENOMEM;
-
-	mwifiex_get_tx_rx_ant(priv, &antcfg);
-
-	pos += snprintf(buf, PAGE_SIZE, "%d\n", antcfg);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-	return ret;
-}
-
 static u32 saved_reg_type, saved_reg_offset, saved_reg_value;
 
 /*
@@ -1391,7 +1320,6 @@ MWIFIEX_DFS_FILE_OPS(amsduaggrctrl);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
-MWIFIEX_DFS_FILE_OPS(antcfg);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
 MWIFIEX_DFS_FILE_OPS(txbufcfg);
@@ -1420,7 +1348,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
 	MWIFIEX_DFS_ADD_FILE(getlog);
-	MWIFIEX_DFS_ADD_FILE(antcfg);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
 	MWIFIEX_DFS_ADD_FILE(txbufcfg);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index eeb2c07..11d2539 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -305,7 +305,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define HostCmd_CMD_RF_REG_ACCESS                     0x001b
 #define HostCmd_CMD_PMIC_REG_ACCESS                   0x00ad
 #define HostCmd_CMD_802_11_RF_CHANNEL                 0x001d
-#define HostCmd_CMD_802_11_RF_ANTENNA                 0x0020
 #define HostCmd_CMD_802_11_DEAUTHENTICATE             0x0024
 #define HostCmd_CMD_MAC_CONTROL                       0x0028
 #define HostCmd_CMD_802_11_AD_HOC_START               0x002b
@@ -1386,11 +1385,6 @@ struct host_cmd_ds_version_ext {
 	char version_str[128];
 } __packed;
 
-struct host_cmd_ds_802_11_rf_antenna {
-	__le16 action;
-	__le16 antenna_mode;
-} __packed;
-
 struct host_cmd_ds_802_11_ibss_status {
 	__le16 action;
 	__le16 enable;
@@ -1426,7 +1420,6 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_tx_rate_cfg tx_rate_cfg;
 		struct host_cmd_ds_txpwr_cfg txp_cfg;
 		struct host_cmd_ds_802_11_ps_mode_enh psmode_enh;
-		struct host_cmd_ds_802_11_rf_antenna antenna;
 		struct host_cmd_ds_802_11_hs_cfg_enh opt_hs_cfg;
 		struct host_cmd_ds_802_11_scan scan;
 		struct host_cmd_ds_802_11_scan_rsp scan_resp;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3be4101..7f29708 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -117,9 +117,6 @@ struct mwifiex_drv_mode {
 #define MWIFIEX_OUI_NOT_PRESENT			0
 #define MWIFIEX_OUI_PRESENT				1
 
-#define RF_ANTENNA_1					0x1
-#define RF_ANTENNA_AUTO					0xFFFF
-
 #define IS_CARD_RX_RCVD(adapter) (adapter->cmd_resp_received || \
 					adapter->event_received || \
 					adapter->data_received)
@@ -1036,10 +1033,6 @@ int mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len);
 
 int mwifiex_get_ver_ext(struct mwifiex_private *priv);
 
-int mwifiex_set_tx_rx_ant(struct mwifiex_private *priv, int antenna);
-
-int mwifiex_get_tx_rx_ant(struct mwifiex_private *priv, int *antenna);
-
 int mwifiex_get_stats_info(struct mwifiex_private *priv,
 			   struct mwifiex_ds_get_stats *log);
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 546f361..1d12fc9 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -933,34 +933,6 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 }
 
 /*
- * This function prepares command to set/get RF antenna.
- *
- * Preparation includes -
- *      - Setting command ID, action and proper size
- *      - Setting antenna mode (for SET only)
- *      - Ensuring correct endian-ness
- */
-static int mwifiex_cmd_802_11_rf_antenna(struct mwifiex_private *priv,
-					 struct host_cmd_ds_command *cmd,
-					 u16 cmd_action, void *data_buf)
-{
-	struct host_cmd_ds_802_11_rf_antenna *antenna = &cmd->params.antenna;
-
-	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_RF_ANTENNA);
-	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rf_antenna) +
-				S_DS_GEN);
-
-	if (cmd_action == HostCmd_ACT_GEN_SET) {
-		antenna->action = cpu_to_le16(HostCmd_ACT_SET_BOTH);
-		antenna->antenna_mode = cpu_to_le16(*(u16 *)data_buf);
-	} else {
-		antenna->action = cpu_to_le16(HostCmd_ACT_GET_BOTH);
-	}
-
-	return 0;
-}
-
-/*
  * This function prepares command to set/get IBSS coalescing status.
  *
  * Preparation includes -
@@ -1148,10 +1120,6 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_tx_power_cfg(priv, cmd_ptr, cmd_action,
 					       data_buf);
 		break;
-	case HostCmd_CMD_802_11_RF_ANTENNA:
-		ret = mwifiex_cmd_802_11_rf_antenna(priv, cmd_ptr, cmd_action,
-						    data_buf);
-		break;
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
 		ret = mwifiex_cmd_enh_power_mode(priv, cmd_ptr, cmd_action,
 						 (uint16_t)cmd_oid, data_buf);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 26e9f1c..6850ea8 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -866,30 +866,6 @@ static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 }
 
 /*
- * This function handles the command response of get RF antenna.
- *
- * Handling includes changing the header fields into CPU format
- * and forwarding the antenna mode to application.
- */
-static int mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
-					 struct host_cmd_ds_command *resp,
-					 void *data_buf)
-{
-	struct host_cmd_ds_802_11_rf_antenna *antenna = &resp->params.antenna;
-	u32 *ant = (u32 *)data_buf;
-
-	dev_dbg(priv->adapter->dev,
-		"info: RF_ANT_RESP: action = 0x%x, Mode = 0x%04x\n",
-		      le16_to_cpu(antenna->action),
-		      le16_to_cpu(antenna->antenna_mode));
-
-	if (data_buf)
-		*ant = (u32)le16_to_cpu(antenna->antenna_mode);
-
-	return 0;
-}
-
-/*
  * This function handles the command response of get extended version.
  *
  * Handling includes forming the extended version string and sending it
@@ -1146,9 +1122,6 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 	case HostCmd_CMD_802_11_RF_CHANNEL:
 		ret = mwifiex_ret_802_11_rf_channel(priv, resp, data_buf);
 		break;
-	case HostCmd_CMD_802_11_RF_ANTENNA:
-		ret = mwifiex_ret_802_11_rf_antenna(priv, resp, data_buf);
-		break;
 	case HostCmd_CMD_VERSION_EXT:
 		ret = mwifiex_ret_ver_ext(priv, resp, data_buf);
 		break;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 3d38e87..5bf005c 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -949,46 +949,6 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to set/get antenna configurations.
- *
- * This function prepares the correct firmware command and
- * issues it. In addition, it performs validity checking on
- * user input data.
- */
-static int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
-				       struct mwifiex_wait_queue *wait,
-				       u16 action, u32 *antenna)
-{
-	int ret = 0;
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u16 antenna_mode;
-
-	if (action == HostCmd_ACT_GEN_SET) {
-		/* User input validation */
-		if ((*antenna < RF_ANTENNA_1 || *antenna >=
-		     (u16) (RF_ANTENNA_1 + adapter->number_of_antenna))
-		    && (*antenna != RF_ANTENNA_AUTO
-			|| adapter->number_of_antenna <= 1)) {
-			dev_err(adapter->dev, "invalid antenna setting\n");
-			return -1;
-		}
-	}
-
-	/* Cast it to u16, antenna mode for command
-	   HostCmd_CMD_802_11_RF_ANTENNA requires 2 bytes */
-	antenna_mode = (u16) *antenna;
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_RF_ANTENNA,
-				  action, 0, wait, &antenna_mode);
-
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/get active channel.
  *
  * This function performs validity checking on channel/frequency
@@ -2585,72 +2545,6 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 }
 
 /*
- * Sends IOCTL request to set Tx and Rx antennas.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_tx_rx_ant(struct mwifiex_private *priv, int antenna)
-{
-	int ret = 0;
-	u32 ant;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	ant = antenna;
-	status = mwifiex_radio_ioctl_ant_cfg(priv, wait, HostCmd_ACT_GEN_SET,
-					     &ant);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (ret)
-		ret = -EFAULT;
-
-	kfree(wait);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get Tx and Rx antennas.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_tx_rx_ant(struct mwifiex_private *priv, int *antenna)
-{
-	int ret = 0;
-	int status = 0;
-	u32 ant;
-	struct mwifiex_wait_queue *wait = NULL;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_radio_ioctl_ant_cfg(priv, wait, HostCmd_ACT_GEN_GET,
-					     &ant);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (ret) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	*antenna = ant;
-
-done:
-	kfree(wait);
-	return ret;
-}
-
-/*
  * Sends IOCTL request to get statistics information.
  *
  * This function allocates the IOCTL request buffer, fills it
-- 
1.7.0.2

