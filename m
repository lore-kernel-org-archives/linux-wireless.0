Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38853 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1CPCmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 22:42:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/6] mwifiex: remove deepsleep command from debugfs
Date: Tue, 15 Mar 2011 19:46:10 -0700
Message-Id: <1300243570-6798-7-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
References: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

auto deep sleep mode is enabled by default

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/README      |   18 ----
 drivers/net/wireless/mwifiex/debugfs.c   |   82 ------------------
 drivers/net/wireless/mwifiex/main.h      |    8 --
 drivers/net/wireless/mwifiex/sta_ioctl.c |  132 ------------------------------
 4 files changed, 0 insertions(+), 240 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index c82cbc2..aa5ce10 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -306,24 +306,6 @@ amsduaggrctrl
 			association). This feature is enabled by default by the driver during
 			initialization.
 
-deepsleep
-	This command is used to set/get auto deep sleep mode.
-
-	Usage:
-		echo "[n] [m]" > deepsleep
-		cat deepsleep
-
-	where the parameters are:
-		[n]: Enable/disable auto deep sleep mode (1/0)
-		[m]: Idle time in milliseconds after which firmware will put the device
-		     in deep sleep mode. Default value is 100 ms.
-
-	Examples:
-		cat deepsleep	                : Display auto deep sleep mode
-		echo "1" > deepsleep            : Enable auto deep sleep mode, idle time unchanged
-		echo "0" > deepsleep            : Disable auto deep sleep mode
-		echo "1 500" > deepsleep        : Enable auto deep sleep mode with idle time 500 ms
-
 hscfg
 	This command is used to configure the host sleep parameters.
 
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 57a9313..6b3600b 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -668,86 +668,6 @@ mwifiex_hscfg_read(struct file *file, char __user *ubuf,
 }
 
 /*
- * Proc deepsleep file write handler.
- *
- * This function is called when the 'deepsleep' file is opened for writing
- *
- * This function can be used to enable/disable Deep Sleep.
- */
-static ssize_t
-mwifiex_deepsleep_write(struct file *file,
-		       const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int ds = 0;
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
-	sscanf(buf, "%d", &ds);
-
-	if (ds == DEEP_SLEEP_OFF) {
-		dev_dbg(priv->adapter->dev, "info: Exit Deep Sleep\n");
-		mwifiex_drv_set_deep_sleep(priv, MWIFIEX_IOCTL_WAIT, false, 0);
-	} else if (ds == DEEP_SLEEP_ON) {
-		dev_dbg(priv->adapter->dev, "info: Enter Deep Sleep\n");
-		mwifiex_drv_set_deep_sleep(priv, MWIFIEX_IOCTL_WAIT, true, 0);
-	} else {
-		ret = -EINVAL;
-	}
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
- * Proc deepsleep file read handler.
- *
- * This function is called when the 'deepsleep' file is opened for writing
- *
- * This function can be used to get Deep Sleep status.
- */
-static ssize_t
-mwifiex_deepsleep_read(struct file *file, char __user *ubuf,
-		      size_t count, loff_t *ppos)
-{
-	int deep_sleep = 0;
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	mwifiex_drv_get_deep_sleep(priv, (u32 *)&deep_sleep);
-
-	pos += snprintf(buf, PAGE_SIZE, "%d\n", deep_sleep);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-
-	return ret;
-}
-
-/*
  * Proc sleeppd file write handler.
  *
  * This function is called when the 'sleeppd' file is opened for writing
@@ -1709,7 +1629,6 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 
 MWIFIEX_DFS_FILE_READ_OPS(info);
 MWIFIEX_DFS_FILE_READ_OPS(debug);
-MWIFIEX_DFS_FILE_OPS(deepsleep);
 MWIFIEX_DFS_FILE_OPS(hscfg);
 MWIFIEX_DFS_FILE_OPS(amsduaggrctrl);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
@@ -1742,7 +1661,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 
 	MWIFIEX_DFS_ADD_FILE(info);
 	MWIFIEX_DFS_ADD_FILE(debug);
-	MWIFIEX_DFS_ADD_FILE(deepsleep);
 	MWIFIEX_DFS_ADD_FILE(hscfg);
 	MWIFIEX_DFS_ADD_FILE(amsduaggrctrl);
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c4685f3..b34e811 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -994,8 +994,6 @@ int mwifiex_set_get_hs_params(struct mwifiex_private *priv,
 			      struct mwifiex_ds_hs_cfg *hscfg);
 int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option);
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
-int mwifiex_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
-			   bool bdeep_sleep, u16 idletime);
 void mwifiex_process_ioctl_resp(struct mwifiex_private *priv,
 				struct mwifiex_wait_queue *req);
 u32 mwifiex_get_mode(struct mwifiex_private *priv, u8 wait_option);
@@ -1064,12 +1062,6 @@ int mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_index);
 
 int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
 
-int mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
-			       bool bdeep_sleep, u16 idletime);
-
-int mwifiex_drv_get_deep_sleep(struct mwifiex_private *priv,
-			       u32 *deep_sleep);
-
 int mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 		       int data_length, int invoke_hostcmd);
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 77bc4ec..0c72371 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1732,64 +1732,6 @@ static int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to set/get auto deep sleep mode.
- *
- * This function prepares the correct firmware command and
- * issues it.
- */
-static int
-mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
-			    struct mwifiex_wait_queue *wait,
-			    struct mwifiex_ds_auto_ds *auto_deep_sleep,
-			    u16 action)
-{
-	int ret = 0;
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u32 mode;
-
-	if (action == HostCmd_ACT_GEN_GET) {
-		if (adapter->is_deep_sleep)
-			auto_deep_sleep->auto_ds = DEEP_SLEEP_ON;
-		else
-			auto_deep_sleep->auto_ds = DEEP_SLEEP_OFF;
-		return ret;
-	}
-
-	if (adapter->is_deep_sleep && auto_deep_sleep->auto_ds ==
-	    DEEP_SLEEP_ON) {
-		dev_err(adapter->dev, "station already in enhanced deep"
-				" sleep mode\n");
-		return -1;
-	} else if (!adapter->is_deep_sleep && auto_deep_sleep->auto_ds ==
-		   DEEP_SLEEP_OFF) {
-		dev_err(adapter->dev, "station already not in enhanced "
-				"deep sleep mode\n");
-		return -1;
-	}
-
-	if (auto_deep_sleep->auto_ds == DEEP_SLEEP_ON) {
-		auto_deep_sleep->auto_ds = DEEP_SLEEP_ON;
-		dev_dbg(adapter->dev, "info: Auto Deep Sleep: on\n");
-		mode = EN_AUTO_PS;
-	} else {
-		auto_deep_sleep->auto_ds = DEEP_SLEEP_OFF;
-		dev_dbg(adapter->dev,
-			"info: AutoAUTO_DEEP_SLEEP Deep Sleep: off\n");
-		mode = DIS_AUTO_PS;
-	}
-
-	/* note: the command could be queued and executed later if there is
-	   command in progress. */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH, mode,
-				  BITMAP_AUTO_DS, wait, auto_deep_sleep);
-
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/get sleep period.
  *
  * This function prepares the correct firmware command and
@@ -2256,80 +2198,6 @@ mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
 }
 
 /*
- * Sends IOCTL request to set deep sleep parameters.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- *
- * We can both put the device is deep sleep and wake it up with
- * this function.
- */
-int
-mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
-			   bool bdeep_sleep, u16 idle_time)
-{
-	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_ds_auto_ds auto_deep_sleep;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	if (bdeep_sleep) {
-		dev_dbg(priv->adapter->dev, "cmd: Deep Sleep: sleep\n");
-		auto_deep_sleep.auto_ds = DEEP_SLEEP_ON;
-		if (idle_time)
-			auto_deep_sleep.idle_time = idle_time;
-	} else {
-		dev_dbg(priv->adapter->dev,
-			"cmd: %lu : Deep Sleep: wakeup\n", jiffies);
-		auto_deep_sleep.auto_ds = DEEP_SLEEP_OFF;
-	}
-	status = mwifiex_pm_ioctl_deep_sleep(priv, wait, &auto_deep_sleep,
-					     HostCmd_ACT_GEN_SET);
-
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
-		ret = -EFAULT;
-
-	kfree(wait);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get deep sleep parameters.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_drv_get_deep_sleep(struct mwifiex_private *priv, u32 *deep_sleep)
-{
-	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_ds_auto_ds auto_deep_sleep;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_pm_ioctl_deep_sleep(priv, wait, &auto_deep_sleep,
-					     HostCmd_ACT_GEN_GET);
-
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
-		ret = -EFAULT;
-		goto done;
-	}
-	*deep_sleep = auto_deep_sleep.auto_ds;
-
-done:
-	kfree(wait);
-	return ret;
-}
-
-/*
  * Sends IOCTL request to set host sleep configurations.
  *
  * This function allocates the IOCTL request buffer, fills it
-- 
1.7.0.2

