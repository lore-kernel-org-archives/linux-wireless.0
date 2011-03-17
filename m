Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42500 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1CQAGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:06:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 11/11] mwifiex: remove amsduaggrctrl command from debugfs
Date: Wed, 16 Mar 2011 17:09:34 -0700
Message-Id: <1300320574-10793-12-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Removed amsduaggrctrl command from debugfs and its
corresponding IOCTL helper commands.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c       |   23 --------
 drivers/net/wireless/mwifiex/11n.h       |    4 --
 drivers/net/wireless/mwifiex/README      |   76 ---------------------------
 drivers/net/wireless/mwifiex/debugfs.c   |   82 ------------------------------
 drivers/net/wireless/mwifiex/main.h      |    5 --
 drivers/net/wireless/mwifiex/sta_ioctl.c |   71 --------------------------
 6 files changed, 0 insertions(+), 261 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 68de8e7..0e04a21 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -26,29 +26,6 @@
 #include "11n.h"
 
 /*
- * IOCTL request handler to set/get AMSDU aggregation control.
- *
- * This function prepares the correct firmware command and
- * issues it.
- */
-int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
-				      struct mwifiex_wait_queue *wait_queue,
-				      struct mwifiex_ds_11n_amsdu_aggr_ctrl
-				      *amsdu_aggr_ctrl, u16 action)
-{
-	int ret = 0;
-	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_AMSDU_AGGR_CTRL, action, 0,
-				  wait_queue, amsdu_aggr_ctrl);
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
  * Fills HT capability information field, AMPDU Parameters field, HT extended
  * capability field, and supported MCS set fields.
  *
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index d9f03bb..769a27f 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -50,10 +50,6 @@ void mwifiex_fill_cap_info(struct mwifiex_private *,
 			   struct mwifiex_ie_types_htcap *);
 int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv,
 				  u16 action, int *htcap_cfg);
-int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
-				      struct mwifiex_wait_queue *wait_queue,
-				      struct mwifiex_ds_11n_amsdu_aggr_ctrl
-				      *amsdu_aggr_ctrl, u16 action);
 void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 					     struct mwifiex_tx_ba_stream_tbl
 					     *tx_tbl);
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 01a17d4..29bba35 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -163,82 +163,6 @@ info
 
 
 3) FOR DRIVER CONFIGURATION
-amsduaggrctrl
-	This command could be used to enable/disable a feature where firmware gives feedback to driver
-	regarding the optimal AMSDU buffer size to use with the current rate. Firmware will use the
-	current rate to decide the buffer size we could transmit. The max buffer size will still be
-	limited by buffer size provided in txbufcfg. (i.e. if the txbufcfg is 4K, then we could only transmit
-	4K/2K AMSDU packets, if the txbufcfg is 8K then we could transmit 8k/4k/2k based on current rate)
-
-	Usage:
-	echo "<n>" > amsduaggrctrl
-	cat amsduaggrctrl
-
-	where <n> is 0/1 (for disable/enable)
-
-	If enabled AMSDU buffer size at various rates will be as follows
-
-	1.	Legacy B/G rate.
-		No AMSDU aggregation.
-
-	2.	BW20 HT Rate:
-		When TX rate goes down,
-		MCS 7, 6, 5, 4:
-			a	8K aggregation size (if TX buffer size is 8K)
-			b	4K aggregation size (if TX buffer size is 4K)
-			c	2K aggregation size (if TX buffer size is 2K)
-
-		MCS 3, 2:
-			a	4K aggregation size (if TX buffer size is 8K/4K)
-			b	2K aggregation size (if TX buffer size is 2K)
-
-		MCS 1, 0:
-			a	No aggregation
-
-		When TX rate goes up,
-		MCS 7, 6, 5:
-			a	8K aggregation size (if TX buffer size is 8K)
-			b	4K aggregation size (if TX buffer size is 4K)
-			c	2K aggregation size (if TX buffer size is 2K)
-
-		MCS 4, 3:
-			a	4K aggregation size (if TX buffer size is 8K/4K)
-			b	2K aggregation size (if TX buffer size is 2K)
-
-		MCS 2, 1, 0:
-			a	No aggregation
-
-	3.	BW40 HT Rate:
-		When TX rate goes down,
-		MCS 7, 6, 5, 4, 3, 2, 1:
-			a	8K aggregation size (if TX buffer size is 8K)
-			b	4K aggregation size (if TX buffer size is 4K)
-			c	2K aggregation size (if TX buffer size is 2K)
-
-		MCS 0:
-			a	No aggregation
-
-		When TX rate goes up,
-		MCS 7, 6, 5, 4, 3:
-			a	8K aggregation size (if TX buffer size is 8K)
-			b	4K aggregation size (if TX buffer size is 4K)
-			c	2K aggregation size (if TX buffer size is 2K)
-
-		MCS 2, 1, 0:
-			a	No aggregation
-
-
-	eg:
-	echo "1" > amsduaggrctrl - Enable this feature
-	echo "0" > amsduaggrctrl - Disable this feature
-	cat amsduaggrctrl (This will get the enable/disable flag
-	and the current AMSDU buffer size). The AMSDU buffer size returned is only
-	valid after association as before association there is no rate info.
-
-	Note:- This command to enable/disable could be given anytime (before/after
-			association). This feature is enabled by default by the driver during
-			initialization.
-
 hscfg
 	This command is used to configure the host sleep parameters.
 
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 37576b4..72f8b3b 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -492,86 +492,6 @@ free_and_exit:
 }
 
 /*
- * Proc amsduaggrctrl file write handler.
- *
- * This function is called when the 'amsduaggrctr' file is opened for writing
- *
- * This function can be used to set the AMSDU aggregation control parameters.
- */
-static ssize_t
-mwifiex_amsduaggrctrl_write(struct file *file, const char __user *ubuf,
-			    size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int amsdu_enable = 0;
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
-	ret = sscanf(buf, "%d", &amsdu_enable);
-
-	if (amsdu_enable != 0 && amsdu_enable != 1) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	ret = mwifiex_11n_amsdu_aggr_ctrl(priv, amsdu_enable);
-
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
- * Proc amsduaggrctrl file read handler.
- *
- * This function is called when the 'amsduaggrctr' file is opened for reading
- *
- * This function can be used to get the AMSDU aggregation control parameters.
- */
-static ssize_t
-mwifiex_amsduaggrctrl_read(struct file *file, char __user *ubuf,
-			 size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	int amsdu_enable, curr_buf_size;
-
-	if (!buf)
-		return -ENOMEM;
-
-	ret = mwifiex_11n_get_amsdu_params(priv, &amsdu_enable, &curr_buf_size);
-	if (ret)
-		goto done;
-
-	pos += snprintf(buf, PAGE_SIZE, "%d %d\n", amsdu_enable, curr_buf_size);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-done:
-	free_page(addr);
-	return ret;
-}
-
-/*
  * Proc hscfg file write handler.
  *
  * This function is called when the 'hscfg' file is opened for writing
@@ -1031,7 +951,6 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 MWIFIEX_DFS_FILE_READ_OPS(info);
 MWIFIEX_DFS_FILE_READ_OPS(debug);
 MWIFIEX_DFS_FILE_OPS(hscfg);
-MWIFIEX_DFS_FILE_OPS(amsduaggrctrl);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
@@ -1056,7 +975,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(info);
 	MWIFIEX_DFS_ADD_FILE(debug);
 	MWIFIEX_DFS_ADD_FILE(hscfg);
-	MWIFIEX_DFS_ADD_FILE(amsduaggrctrl);
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
 	MWIFIEX_DFS_ADD_FILE(getlog);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d2848c8..aee19a9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1047,11 +1047,6 @@ int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
 int mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 		       int data_length, int invoke_hostcmd);
 
-int mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable);
-
-int mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv,
-				 int *amsdu_enable, int *curr_buf_size);
-
 int mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on);
 
 int mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index bfe2fd4..f446a5a 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1926,77 +1926,6 @@ mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 }
 
 /*
- * Sends IOCTL request to get AMSDU parameters.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv, int *amsdu_enable,
-			     int *curr_buf_size)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
-	int status = 0;
-	int ret = 0;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_11n_ioctl_amsdu_aggr_ctrl(priv->adapter, wait,
-						   &amsdu_aggr_ctrl,
-						   HostCmd_ACT_GEN_GET);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-
-	if (!ret) {
-		*amsdu_enable = amsdu_aggr_ctrl.enable;
-		*curr_buf_size = amsdu_aggr_ctrl.curr_buf_size;
-	}
-
-	kfree(wait);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to set enable/disable AMSDU aggregation feature.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
-	int status = 0;
-	int ret = 0;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	amsdu_aggr_ctrl.enable = amsdu_enable;
-
-	status = mwifiex_11n_ioctl_amsdu_aggr_ctrl(priv->adapter, wait,
-						   &amsdu_aggr_ctrl,
-						   HostCmd_ACT_GEN_SET);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-
-	if (ret)
-		dev_err(priv->adapter->dev,
-			"failed enabling amsdu aggr feature\n");
-	else
-		dev_dbg(priv->adapter->dev,
-			"info: Successfully enabled amsdu aggregation feature\n");
-
-	kfree(wait);
-	return ret;
-}
-
-/*
  * Sends IOCTL request to set sleep period.
  *
  * This function allocates the IOCTL request buffer, fills it
-- 
1.7.0.2

