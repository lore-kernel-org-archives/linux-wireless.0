Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38842 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1CPCmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 22:42:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/6] mwifiex: remove addbapara configuration from debugfs
Date: Tue, 15 Mar 2011 19:46:06 -0700
Message-Id: <1300243570-6798-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
References: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kiran Divekar <dkiran@marvell.com>

The default values will be used instead.

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c       |   55 -----------------
 drivers/net/wireless/mwifiex/11n.h       |    4 -
 drivers/net/wireless/mwifiex/README      |   32 ----------
 drivers/net/wireless/mwifiex/debugfs.c   |   94 ------------------------------
 drivers/net/wireless/mwifiex/ioctl.h     |    6 --
 drivers/net/wireless/mwifiex/main.h      |    5 --
 drivers/net/wireless/mwifiex/sta_ioctl.c |   77 ------------------------
 7 files changed, 0 insertions(+), 273 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index bb2e06d..fcf2971 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -96,61 +96,6 @@ int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
 }
 
 /*
- * This function resends add BA requests to all peers in
- * the Tx BA stream table.
- */
-static void mwifiex_11n_update_addba_request(struct mwifiex_private *priv)
-{
-
-	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
-	if (list_empty(&priv->tx_ba_stream_tbl_ptr)) {
-		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
-		return;
-	}
-	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list)
-		mwifiex_send_addba(priv, tx_ba_tsr_tbl->tid, tx_ba_tsr_tbl->ra);
-	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
-
-	mwifiex_main_process(priv->adapter);
-	return;
-}
-
-/*
- * IOCTL request handler to set/get add BA parameters.
- *
- * The following parameters are supported -
- *      - Tx window size
- *      - Rx window size
- *      - Tiemout value
- */
-int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
-				  struct mwifiex_wait_queue *wait_queue,
-				  struct mwifiex_ds_11n_addba_param
-				  *addba_param, u16 action)
-{
-	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
-	u32 timeout;
-
-	if (action == HostCmd_ACT_GEN_GET) {
-		addba_param->timeout = priv->add_ba_param.timeout;
-		addba_param->tx_win_size = priv->add_ba_param.tx_win_size;
-		addba_param->rx_win_size = priv->add_ba_param.rx_win_size;
-	} else {
-		timeout = priv->add_ba_param.timeout;
-		priv->add_ba_param.timeout = addba_param->timeout;
-		priv->add_ba_param.tx_win_size = addba_param->tx_win_size;
-		priv->add_ba_param.rx_win_size = addba_param->rx_win_size;
-		if (timeout != priv->add_ba_param.timeout)
-			mwifiex_11n_update_addba_request(priv);
-	}
-
-	return 0;
-}
-
-/*
  * IOCTL request handler to set/get add BA reject configuration.
  *
  * The configuration can only be set in disconnected state.
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 13bcfd0..2ee940f 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -59,10 +59,6 @@ int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 				    *aggr_prio_tbl, u16 action);
 int mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
 				 u16 action, int *);
-int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
-				  struct mwifiex_wait_queue *wait_queue,
-				  struct mwifiex_ds_11n_addba_param
-				  *addba_param, u16 action);
 int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
 				      struct mwifiex_wait_queue *wait_queue,
 				      struct mwifiex_ds_11n_amsdu_aggr_ctrl
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 1c40cd7..35811d3 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -207,38 +207,6 @@ antcfg
 		echo "1" > antcfg		     : Set Tx/Rx antenna 1
 		echo "65535" > antcfg		     : Set Tx/Rx antenna diversity
 
-addbapara
-	This command can be used to update the default ADDBA parameters.
-
-	Usage:
-
-	echo "<m> <n> <o>" > addbapara
-	cat addbapara
-
-	where <m> is <timeout>
-	<timeout> - This is the block ack timeout for ADDBA request.
-		0 : Disable (recommended for throughput test)
-		1 - 65535 : Block Ack Timeout in us
-
-	where <n> is <txwinsize>
-	<txwinsize> - Window size for ADDBA request. (32 is recommended and default value)
-
-	where <o> is <rxwinsize>
-	<rxwinsize> - Window size for ADDBA response. (16 is recommended value for most APs, 64
-			      is recommended for AP85)
-
-	eg:
-	cat addbapara - This command will get the current addba params
-	echo "1000 64 5" > addbapara (This will change the ADDBA timeout to (1000 * 1024) us,
-			txwinsize to 64 and rxwinsize to 5.
-
-	In case the ADDBA timeout value is updated then a ADDBA is sent for all streams
-	to update the timeout value.
-
-	In case txwinsize and/or rxwinsize is update the effect could only be seen on
-	next ADDBA request/response. The current streams will not be affected with this
-	change.
-
 txaggrprio
 	This command is used set/get the priority table for AMPDU/AMSDU traffic per tid.
 	This command can also be used to disable AMPDU/AMSDU for a given tid.
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index ca105c8..0ff3663 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1165,98 +1165,6 @@ mwifiex_txratecfg_read(struct file *file, char __user *ubuf,
 }
 
 /*
- * Proc addbapara file write handler.
- *
- * This function is called when the 'addbapara' file is opened for writing
- *
- * This function can be used to set the add BA parameters.
- */
-static ssize_t
-mwifiex_addbapara_write(struct file *file, const char __user *ubuf,
-			size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int ret = 0, length = 0;
-	int *data = NULL;
-	char *p = NULL;
-
-	if (!buf)
-		return -ENOMEM;
-
-	data = kzalloc((sizeof(int) * 3), GFP_KERNEL);
-	if (!data) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	if (copy_from_user(buf, ubuf, buf_size)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	while (buf) {
-		p = strsep(&buf, "\t ");
-		if (!p)
-			break;
-		sscanf(p, "%d", (data + length));
-		length++;
-
-	}
-	if (length != 3) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	ret = mwifiex_set_addba_param(priv, data);
-
-	if (!ret)
-		ret = count;
-
-done:
-	kfree(data);
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc addbapara file read handler.
- *
- * This function is called when the 'addbapara' file is opened for reading
- *
- * This function can be used to get the add BA parameters.
- */
-static ssize_t
-mwifiex_addbapara_read(struct file *file, char __user *ubuf,
-		       size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	int addba_timeout = 0, tx_win_sz = 0, rx_win_sz = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	mwifiex_get_addba_param(priv, &addba_timeout, &tx_win_sz, &rx_win_sz);
-
-	pos += snprintf(buf, PAGE_SIZE, "%d ", addba_timeout);
-	pos += snprintf(buf + strlen(buf), PAGE_SIZE, "%d ", tx_win_sz);
-	pos += snprintf(buf + strlen(buf), PAGE_SIZE, "%d ", rx_win_sz);
-	pos += snprintf(buf + strlen(buf), PAGE_SIZE, "\n ");
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-	return ret;
-}
-
-/*
  * Proc httxcfg file write handler.
  *
  * This function is called when the 'httxcfg' file is opened for writing
@@ -2076,7 +1984,6 @@ MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_OPS(mpactrl);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
 MWIFIEX_DFS_FILE_OPS(txratecfg);
-MWIFIEX_DFS_FILE_OPS(addbapara);
 MWIFIEX_DFS_FILE_OPS(addbareject);
 MWIFIEX_DFS_FILE_OPS(httxcfg);
 MWIFIEX_DFS_FILE_OPS(htcapinfo);
@@ -2113,7 +2020,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(mpactrl);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
 	MWIFIEX_DFS_ADD_FILE(txratecfg);
-	MWIFIEX_DFS_ADD_FILE(addbapara);
 	MWIFIEX_DFS_ADD_FILE(addbareject);
 	MWIFIEX_DFS_ADD_FILE(httxcfg);
 	MWIFIEX_DFS_ADD_FILE(htcapinfo);
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 3fd767d..7be79ea 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -413,12 +413,6 @@ struct mwifiex_ds_wmm_queue_status {
 		ac_status[IEEE80211_MAX_QUEUES];
 };
 
-struct mwifiex_ds_11n_addba_param {
-	u32 timeout;
-	u32 tx_win_size;
-	u32 rx_win_size;
-};
-
 struct mwifiex_ds_11n_tx_cfg {
 	u16 tx_htcap;
 	u16 tx_htinfo;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a34edd1..9272fa4 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1065,11 +1065,6 @@ int mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_index);
 
 int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
 
-int mwifiex_get_addba_param(struct mwifiex_private *priv, int *aaddba_timeout,
-			   int *tx_win_sz, int *rx_win_sz);
-
-int mwifiex_set_addba_param(struct mwifiex_private *priv, int *data);
-
 int mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 			       bool bdeep_sleep, u16 idletime);
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 9cc9db9..f176168 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -3320,83 +3320,6 @@ int mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
 }
 
 /*
- * Sends IOCTL request to set Add BA parameters (Timeout, Tx window size,
- * Rx window size).
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_addba_param(struct mwifiex_private *priv, int *data)
-{
-	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_ds_11n_addba_param addba_param;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	addba_param.timeout = data[0];
-	addba_param.tx_win_size = data[1];
-	addba_param.rx_win_size = data[2];
-	dev_dbg(priv->adapter->dev,
-			"info: SET: timeout:%d txwinsize:%d rxwinsize:%d\n",
-			data[0], data[1], data[2]);
-	status = mwifiex_11n_ioctl_addba_param(priv->adapter, wait,
-					       &addba_param,
-					       HostCmd_ACT_GEN_SET);
-
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
-		ret = -EFAULT;
-
-	kfree(wait);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get Add BA parameters (Timeout, Tx window size,
- * Rx window size).
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_addba_param(struct mwifiex_private *priv, int *addba_timeout,
-		       int *tx_win_sz, int *rx_win_sz)
-{
-	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_ds_11n_addba_param addba_param;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_11n_ioctl_addba_param(priv->adapter, wait,
-					       &addba_param,
-					       HostCmd_ACT_GEN_GET);
-
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	*addba_timeout = addba_param.timeout;
-	*tx_win_sz = addba_param.tx_win_size;
-	*rx_win_sz = addba_param.rx_win_size;
-
-	dev_dbg(priv->adapter->dev,
-			"info: GET: timeout:%d txwinsize:%d rxwinsize:%d\n",
-			*addba_timeout, *tx_win_sz, *rx_win_sz);
-done:
-	kfree(wait);
-	return ret;
-}
-
-/*
  * Sends IOCTL request to get/set/clear passphrase for specified SSID.
  *
  * This function allocates the IOCTL request buffer, fills it
-- 
1.7.0.2

