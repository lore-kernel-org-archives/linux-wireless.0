Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42502 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1CQAGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:06:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 10/11] mwifiex: remove txbufcfg command from debugfs
Date: Wed, 16 Mar 2011 17:09:33 -0700
Message-Id: <1300320574-10793-11-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

The default setting for Tx buffer size is 2K.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README      |   23 ---------
 drivers/net/wireless/mwifiex/debugfs.c   |   72 ------------------------------
 drivers/net/wireless/mwifiex/main.h      |    6 ---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   34 --------------
 4 files changed, 0 insertions(+), 135 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 91fe1f9..01a17d4 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -163,29 +163,6 @@ info
 
 
 3) FOR DRIVER CONFIGURATION
-txbufcfg
-	This command can be used to set max transmit buffer size of firmware. Increasing this
-	buffer size is recommended for AMSDU packets. (Default is 2048)
-
-	Usage:
-	echo "<n>" > txbufcfg
-	cat txbufcfg
-
-	where <n> is <buffer size in byte>
-
-	<buffer size> - This can be 2048/4096/8192.
-
-	eg:
-	cat txbufcfg 	  	- This will display the current buffer size.
-	echo "8192" > txbufcfg  - This will change the tx buffer size of 8192.
-
-	For AMSDU for work for multiple packets we may need the max tx buffer size to be
-	4096/8192.
-
-	Note:- This command should be issue in disconnected state.
-           Otherwise, new setting will be effected in next time associate.
-           The actual tx buf size will depends on AP's capability and max transmit buffer size.
-
 amsduaggrctrl
 	This command could be used to enable/disable a feature where firmware gives feedback to driver
 	regarding the optimal AMSDU buffer size to use with the current rate. Firmware will use the
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 48e3f72..37576b4 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1001,76 +1001,6 @@ done:
 	return ret;
 }
 
-/*
- * Proc txbufcfg file write handler.
- *
- * This function is called when the 'txbufcfg' file is opened for writing
- *
- * This function can be used to set the Tx buffer size.
- */
-static ssize_t
-mwifiex_txbufcfg_write(struct file *file, const char __user *ubuf,
-		       size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int txbufcfg = 0;
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
-	ret = sscanf(buf, "%d", &txbufcfg);
-
-	ret = mwifiex_set_drv_txbuf_cfg(priv, txbufcfg);
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
- * Proc txbufcfg file read handler.
- *
- * This function is called when the 'txbufcfg' file is opened for reading
- *
- * This function can be used to get the Tx buffer size.
- */
-static ssize_t
-mwifiex_txbufcfg_read(struct file *file, char __user *ubuf,
-			    size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	int txbufcfg;
-
-	if (!buf)
-		return -ENOMEM;
-
-	mwifiex_get_drv_txbuf_cfg(priv, &txbufcfg);
-
-	pos += snprintf(buf, PAGE_SIZE, "%d\n", txbufcfg);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-	return ret;
-}
 
 #define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
 	if (!debugfs_create_file(#name, 0644, priv->dfs_dev_dir,        \
@@ -1107,7 +1037,6 @@ MWIFIEX_DFS_FILE_OPS(qoscfg);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
-MWIFIEX_DFS_FILE_OPS(txbufcfg);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -1133,7 +1062,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
-	MWIFIEX_DFS_ADD_FILE(txbufcfg);
 
 	return;
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f13ae51..d2848c8 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1047,12 +1047,6 @@ int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
 int mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 		       int data_length, int invoke_hostcmd);
 
-int mwifiex_set_drv_txbuf_cfg(struct mwifiex_private *priv,
-			      int max_tx_buf_size);
-
-int mwifiex_get_drv_txbuf_cfg(struct mwifiex_private *priv,
-			      int *max_tx_buf_size);
-
 int mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable);
 
 int mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 0fd24cb..bfe2fd4 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1997,40 +1997,6 @@ mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
 }
 
 /*
- * Sends IOCTL request to set driver Tx buffer size.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_drv_txbuf_cfg(struct mwifiex_private *priv, int max_tx_buf_size)
-{
-	int status = 0;
-
-	if ((max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_2K) ||
-	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_4K) ||
-	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_8K))
-		priv->adapter->max_tx_buf_size = (u16) max_tx_buf_size;
-	else
-		status = -1;
-
-	return status;
-}
-
-/*
- * Sends IOCTL request to get driver Tx buffer size.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_drv_txbuf_cfg(struct mwifiex_private *priv, int *max_tx_buf_size)
-{
-	*max_tx_buf_size = (u32) priv->adapter->max_tx_buf_size;
-	return 0;
-}
-
-/*
  * Sends IOCTL request to set sleep period.
  *
  * This function allocates the IOCTL request buffer, fills it
-- 
1.7.0.2

