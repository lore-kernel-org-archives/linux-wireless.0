Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51472 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab1CQWNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 18:13:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: remove sleeppd from debugfs
Date: Thu, 17 Mar 2011 15:17:12 -0700
Message-Id: <1300400232-13424-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300400232-13424-1-git-send-email-bzhao@marvell.com>
References: <1300400232-13424-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove debugfs API for sleep period configuration and its
ioctl and macros

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README        |   14 -----
 drivers/net/wireless/mwifiex/debugfs.c     |   74 ------------------------
 drivers/net/wireless/mwifiex/fw.h          |    7 --
 drivers/net/wireless/mwifiex/ioctl.h       |    3 -
 drivers/net/wireless/mwifiex/main.h        |    4 -
 drivers/net/wireless/mwifiex/sta_cmd.c     |   31 ----------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   39 -------------
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   85 ----------------------------
 8 files changed, 0 insertions(+), 257 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 0bf442a..338377f 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -195,20 +195,6 @@ rdeeprom
 	Example:
 		echo "0 20" > rdeeprom      : Read 20 bytes of EEPROM data from offset 0
 
-sleeppd
-	This command is used to configure the sleep period of the WLAN device.
-
-	Usage:
-		echo "<period>" > sleeppd
-		cat sleeppd
-
-	Where the parameter is:
-		period: sleep period in milliseconds. Range 10~60. 0 for disable.
-
-	Examples:
-		cat sleeppd 	                : Get sleep period configuration
-		echo "10" > sleeppd             : Set sleep period to 10 ms
-
 getlog
         This command is used to get the statistics available in the station.
 	Usage:
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 462a8a4..63b0969 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -491,78 +491,6 @@ free_and_exit:
 	return ret;
 }
 
-/*
- * Proc sleeppd file write handler.
- *
- * This function is called when the 'sleeppd' file is opened for writing
- *
- * This function can be used to set the sleep period.
- */
-static ssize_t
-mwifiex_sleeppd_write(struct file *file,
-		      const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int sleeppd = 0;
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
-	sscanf(buf, "%d", &sleeppd);
-
-	ret = mwifiex_set_sleep_pd(priv, sleeppd);
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
- * Proc sleeppd file read handler.
- *
- * This function is called when the 'sleeppd' file is opened for reading
- *
- * This function can be used to get the sleep period.
- */
-static ssize_t
-mwifiex_sleeppd_read(struct file *file, char __user *ubuf,
-		     size_t count, loff_t *ppos)
-{
-	int sleeppd = 0;
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	mwifiex_get_sleep_pd(priv, &sleeppd);
-
-	pos += snprintf(buf, PAGE_SIZE, "%d\n", sleeppd);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-
-	return ret;
-}
-
 static u32 saved_reg_type, saved_reg_offset, saved_reg_value;
 
 /*
@@ -783,7 +711,6 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 
 MWIFIEX_DFS_FILE_READ_OPS(info);
 MWIFIEX_DFS_FILE_READ_OPS(debug);
-MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
@@ -805,7 +732,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 
 	MWIFIEX_DFS_ADD_FILE(info);
 	MWIFIEX_DFS_ADD_FILE(debug);
-	MWIFIEX_DFS_ADD_FILE(sleeppd);
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index a5a9547..e5dae45 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -307,7 +307,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define HostCmd_CMD_802_11_MAC_ADDRESS                0x004D
 #define HostCmd_CMD_802_11D_DOMAIN_INFO               0x005b
 #define HostCmd_CMD_802_11_KEY_MATERIAL               0x005e
-#define HostCmd_CMD_802_11_SLEEP_PERIOD               0x0068
 #define HostCmd_CMD_802_11_BG_SCAN_QUERY              0x006c
 #define HostCmd_CMD_WMM_GET_STATUS                    0x0071
 #define HostCmd_CMD_802_11_TX_RATE_QUERY              0x007f
@@ -642,11 +641,6 @@ struct host_cmd_ds_gen {
 
 #define S_DS_GEN        sizeof(struct host_cmd_ds_gen)
 
-struct host_cmd_ds_802_11_sleep_period {
-	__le16 action;
-	__le16 sleep_pd;
-} __packed;
-
 enum sleep_resp_ctrl {
 	RESP_NOT_NEEDED = 0,
 	RESP_NEEDED,
@@ -1363,7 +1357,6 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_pmic_reg_access pmic_reg;
 		struct host_cmd_ds_set_bss_mode bss_mode;
 		struct host_cmd_ds_802_11_eeprom_access eeprom;
-		struct host_cmd_ds_802_11_sleep_period sleep_pd;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 158664b..d6babfb 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -341,9 +341,6 @@ struct mwifiex_ds_auto_ds {
 	u16 idle_time;
 };
 
-#define MIN_SLEEP_PERIOD			10
-#define MAX_SLEEP_PERIOD			60
-#define SLEEP_PERIOD_RESERVED_FF		0xFF
 #define PS_MODE_UNCHANGED			0
 #define PS_MODE_AUTO				1
 #define PS_MODE_POLL				2
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6250724..2b0ad8e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1046,10 +1046,6 @@ int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
 
 int mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on);
 
-int mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd);
-
-int mwifiex_set_sleep_pd(struct mwifiex_private *priv, int sleeppd);
-
 int mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter,
 				   char *version, int max_len);
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index d4befb9..795b1ea 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -400,32 +400,6 @@ static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
 }
 
 /*
- * This function prepares command to set/get sleep period.
- *
- * Preparation includes -
- *      - Setting command ID, action and proper size
- *      - Setting sleep period value (for SET only)
- *      - Ensuring correct endian-ness
- */
-static int mwifiex_cmd_802_11_sleep_period(struct mwifiex_private *priv,
-					   struct host_cmd_ds_command *cmd,
-					   u16 cmd_action, u16 *data_buf)
-{
-	struct host_cmd_ds_802_11_sleep_period *cmd_sleep_pd =
-		&cmd->params.sleep_pd;
-
-	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SLEEP_PERIOD);
-	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_sleep_period) +
-				S_DS_GEN);
-	if (cmd_action == HostCmd_ACT_GEN_SET)
-		cmd_sleep_pd->sleep_pd = cpu_to_le16(*(u16 *) data_buf);
-
-	cmd_sleep_pd->action = cpu_to_le16(cmd_action);
-
-	return 0;
-}
-
-/*
  * This function prepares command to set MAC multicast address.
  *
  * Preparation includes -
@@ -992,11 +966,6 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_802_11_hs_cfg(priv, cmd_ptr, cmd_action,
 				(struct mwifiex_hs_config_param *) data_buf);
 		break;
-	case HostCmd_CMD_802_11_SLEEP_PERIOD:
-		ret = mwifiex_cmd_802_11_sleep_period(priv, cmd_ptr,
-						      cmd_action,
-						      (u16 *) data_buf);
-		break;
 	case HostCmd_CMD_802_11_SCAN:
 		ret = mwifiex_cmd_802_11_scan(priv, cmd_ptr, data_buf);
 		break;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 15a306c..ae960dd 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -479,42 +479,6 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 }
 
 /*
- * This function handles the command response of a Host Sleep configuration
- * command.
- *
- * Handling includes changing the header fields into CPU format
- * and setting the current sleep period and associated parameters
- * in driver.
- */
-static int mwifiex_ret_802_11_sleep_period(struct mwifiex_private *priv,
-					   struct host_cmd_ds_command *resp,
-					   void *data_buf)
-{
-	struct host_cmd_ds_802_11_sleep_period *cmd_sleep_pd =
-		&resp->params.sleep_pd;
-	u32 *sleep_period;
-	u16 sleep_pd = 0;
-
-	sleep_pd = le16_to_cpu(cmd_sleep_pd->sleep_pd);
-	if (data_buf) {
-		sleep_period = (u32 *) data_buf;
-		*sleep_period = (u32) sleep_pd;
-	}
-	priv->adapter->sleep_period.period = sleep_pd;
-	priv->adapter->pps_uapsd_mode = false;
-	if ((priv->adapter->sleep_period.period != 0) &&
-	    (priv->adapter->sleep_period.period !=
-	     SLEEP_PERIOD_RESERVED_FF)) {
-		priv->adapter->gen_null_pkt = true;
-	} else {
-		priv->adapter->delay_null_pkt = false;
-		priv->adapter->gen_null_pkt = false;
-	}
-
-	return 0;
-}
-
-/*
  * This function handles the command response of set/get MAC address.
  *
  * Handling includes saving the MAC address in driver.
@@ -923,9 +887,6 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 	case HostCmd_CMD_802_11_HS_CFG_ENH:
 		ret = mwifiex_ret_802_11_hs_cfg(priv, resp);
 		break;
-	case HostCmd_CMD_802_11_SLEEP_PERIOD:
-		ret = mwifiex_ret_802_11_sleep_period(priv, resp, data_buf);
-		break;
 	case HostCmd_CMD_802_11_ASSOCIATE:
 		ret = mwifiex_ret_802_11_associate(priv, resp, wait_queue);
 		break;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 97dea98..665a519 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1594,27 +1594,6 @@ static int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to set/get sleep period.
- *
- * This function prepares the correct firmware command and
- * issues it.
- */
-static int mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *priv,
-				     struct mwifiex_wait_queue *wait,
-				     u32 *sleep_period, u16 action)
-{
-	int ret = 0;
-
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SLEEP_PERIOD,
-				  action, 0, wait, sleep_period);
-
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/reset WPA IE.
  *
  * The supplied WPA IE is treated as a opaque buffer. Only the first field
@@ -1893,70 +1872,6 @@ mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
 }
 
 /*
- * Sends IOCTL request to set sleep period.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_sleep_pd(struct mwifiex_private *priv, int sleeppd)
-{
-	int ret = 0;
-	int status = 0;
-	u32 sleep_period;
-	struct mwifiex_wait_queue *wait = NULL;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	if ((sleeppd <= MAX_SLEEP_PERIOD && sleeppd >= MIN_SLEEP_PERIOD)
-	    || (sleeppd == 0) || (sleeppd == SLEEP_PERIOD_RESERVED_FF)) {
-		sleep_period = sleeppd;
-	} else {
-		ret = -EINVAL;
-		goto done;
-	}
-	status = mwifiex_pm_ioctl_sleep_pd(priv, wait, &sleep_period,
-					   HostCmd_ACT_GEN_SET);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-done:
-	kfree(wait);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get sleep period.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd)
-{
-	int ret = 0;
-	int status = 0;
-	u32 sleep_period;
-	struct mwifiex_wait_queue *wait = NULL;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_pm_ioctl_sleep_pd(priv, wait, &sleep_period,
-					   HostCmd_ACT_GEN_GET);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-
-	if (!ret)
-		*sleeppd = sleep_period;
-
-	kfree(wait);
-	return ret;
-}
-
-/*
  * This function returns the driver version.
  */
 int
-- 
1.7.0.2

