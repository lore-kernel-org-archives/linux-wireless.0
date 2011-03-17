Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42471 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab1CQAGP (ORCPT
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
Subject: [PATCH 03/11] mwifiex: remove mpactrl command from debugfs
Date: Wed, 16 Mar 2011 17:09:26 -0700
Message-Id: <1300320574-10793-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The following default settings for SDIO Multiple Port Aggregation
will be used:
 1) Default Tx and Rx buffer size is 4096 bytes
 2) MP aggregation for Tx/Rx will be disabled
 3) Default maximum TX and Rx ports are 8

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README    |   28 --------
 drivers/net/wireless/mwifiex/debugfs.c |  105 ----------------------------
 drivers/net/wireless/mwifiex/main.h    |    1 -
 drivers/net/wireless/mwifiex/sdio.c    |  119 --------------------------------
 4 files changed, 0 insertions(+), 253 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 366338c..d51830a 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -163,34 +163,6 @@ info
 
 
 3) FOR DRIVER CONFIGURATION
-mpactrl
-	This command is used to set/get the Tx, Rx SDIO aggregation parameters
-	Note: The parameters can be set only in disconnected state.
-
-	The following parameters are provided in /debugfs/mwifiex/mlanX/mpactrl:
-	Usage:
-
-	echo "[tx_ena][rx_ena][tx_size][rx_size][tx_ports][rx_ports]" > mpactrl
-	where
-
-	[tx_ena]  - Enable MP aggregation for Tx
-	[rx_ena]  - Enable MP aggregation for Rx
-	[tx_size] - Set Tx buffer size
-	[rx_size] - Set Rx buffer size
-	[tx_ports]- Maximum Tx ports,
-	[rx_ports]- Maximum Rx ports,
-
-	Examples:
-		cat mpactrl       : Get MP aggregation parameters
-		echo "0 0" > mpactrl
-		                  : Disable MP aggregation for Tx, Rx respectively
-		echo "1 1 2048 2048 5 7" > mpactrl
-		                  : Enable MP aggregation for Tx, Rx
-		                  : Set Tx, Rx buffer size to 2048 bytes
-		                  : Set maximum Tx ports to 5 and maximum Rx ports to 7
-
-	Default values are 0 0 4096 4096 8 8. Enable MP-A for throughput tests.
-
 antcfg
 	This command is used to set/get the mode of Tx/Rx antenna.
 	Usage:
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index d01a1fc..f5ad86e 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -740,109 +740,6 @@ mwifiex_sleeppd_read(struct file *file, char __user *ubuf,
 }
 
 /*
- * Proc mpactrl file write handler.
- *
- * This function is called when the 'mpactrl' file is opened for writing
- *
- * This function can be used to set the mpa control parameters.
- */
-static ssize_t
-mwifiex_mpactrl_write(struct file *file,
-		      const char __user *ubuf, size_t count, loff_t *ppos)
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
-	if (!priv->adapter->if_ops.sdio_mpa_ctrl) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	data = kzalloc((sizeof(int) * 6), GFP_KERNEL);
-	if (!data) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	if (!buf) {
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
-	}
-
-	ret = priv->adapter->if_ops.sdio_mpa_ctrl(priv, 1, data, length);
-
-	if (!ret)
-		ret = count;
-done:
-	kfree(data);
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc mpactrl file read handler.
- *
- * This function is called when the 'mpactrl' file is opened for reading
- *
- * This function can be used to get the mpa control parameters.
- */
-static ssize_t
-mwifiex_mpactrl_read(struct file *file, char __user *ubuf,
-		     size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0, i = 0;
-	int *data = kzalloc(sizeof(int) * 6, GFP_KERNEL);
-
-	if (!priv->adapter->if_ops.sdio_mpa_ctrl) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	if (!buf || !data) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	if (priv->adapter->if_ops.sdio_mpa_ctrl(priv, 0, data, count))
-		goto done;
-
-	for (i = 0; i < 6; i++)
-		pos += snprintf(buf + strlen(buf), PAGE_SIZE, "%d ", data[i]);
-
-	pos += snprintf(buf + strlen(buf), PAGE_SIZE, "\n");
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-done:
-	free_page(addr);
-	kfree(data);
-	return ret;
-}
-
-/*
  * Proc qoscfg file write handler.
  *
  * This function is called when the 'qoscfg' file is opened for writing
@@ -1492,7 +1389,6 @@ MWIFIEX_DFS_FILE_READ_OPS(debug);
 MWIFIEX_DFS_FILE_OPS(hscfg);
 MWIFIEX_DFS_FILE_OPS(amsduaggrctrl);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
-MWIFIEX_DFS_FILE_OPS(mpactrl);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_OPS(antcfg);
@@ -1522,7 +1418,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(hscfg);
 	MWIFIEX_DFS_ADD_FILE(amsduaggrctrl);
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
-	MWIFIEX_DFS_ADD_FILE(mpactrl);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(antcfg);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f3626fc..3be4101 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -584,7 +584,6 @@ struct mwifiex_if_ops {
 	int (*wakeup_complete) (struct mwifiex_adapter *);
 
 	void (*update_mp_end_port) (struct mwifiex_adapter *, u16);
-	int (*sdio_mpa_ctrl) (struct mwifiex_private *, u8, int *, int);
 	void (*cleanup_mpa_buf) (struct mwifiex_adapter *);
 };
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 313cf0a..f21e5cd 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1682,124 +1682,6 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 	       port, card->mp_data_port_mask);
 }
 
-/*
- * This function sets/gets the mpa Tx/Rx parameters.
- *
- * For GET operation, the following parameters are returned -
- *      - MPA Tx status (enabled or disabled)
- *      - MPA Rx status (enabled or disabled)
- *      - MPA Tx buffer size
- *      - MPA Rx buffer size
- *      - MPA Tx packet aggregation limit
- *      - MPA Rx packet aggregation limit
- *
- * SET operation can only be performed in disconnected state. In SET,
- * the parameters are saved in the card structure. If MPA Tx/Rx buffer
- * size has changed, the old buffers are discarded and new buffers
- * are allocated of new sizes.
- */
-static int
-mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
-		     int length)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct sdio_mmc_card *card = adapter->card;
-
-	if (!write) {
-		data[0] = card->mpa_tx.enabled;
-		data[1] = card->mpa_rx.enabled;
-		data[2] = card->mpa_tx.buf_size;
-		data[3] = card->mpa_rx.buf_size;
-		data[4] = card->mpa_tx.pkt_aggr_limit;
-		data[5] = card->mpa_rx.pkt_aggr_limit;
-
-		dev_dbg(adapter->dev, "info: Get Param: %d %d %d %d %d %d\n",
-		       data[0], data[1], data[2], data[3], data[4], data[5]);
-	} else {
-		if (priv->media_connected) {
-			dev_err(adapter->dev, "SDIO MPA CTRL: not allowed "
-			       "in connected state\n");
-			return -EINVAL;
-		}
-
-		if (length > 6)
-			return -EINVAL;
-
-		/* mpa_tx enabled */
-		if (length > 0) {
-			if (data[0] > 1)
-				return -EINVAL;
-		}
-
-		/* mpa_rx enabled */
-		if (length > 1) {
-			if (data[1] > 1)
-				return -EINVAL;
-		}
-
-		/* mpa_tx port limit */
-		if (length > 4) {
-			if (data[4] > SDIO_MP_AGGR_DEF_PKT_LIMIT)
-				return -EINVAL;
-		}
-
-		/* mpa_rx port limit */
-		if (length > 5) {
-			if (data[5] > SDIO_MP_AGGR_DEF_PKT_LIMIT)
-				return -EINVAL;
-		}
-
-		if (((length > 2) && data[2]) || ((length > 3) && data[3])) {
-			/* free old buffers */
-			kfree(card->mpa_tx.buf);
-			kfree(card->mpa_rx.buf);
-
-			/* mpa_tx buf size */
-			if ((length > 2) && data[2])
-				card->mpa_tx.buf_size = data[2];
-
-			/* mpa_rx buf size */
-			if ((length > 3) && data[3])
-				card->mpa_rx.buf_size = data[3];
-
-			if (mwifiex_alloc_sdio_mpa_buffers(adapter,
-						       card->mpa_tx.buf_size,
-						       card->mpa_rx.buf_size)) {
-				dev_err(adapter->dev, "failed to alloc "
-				       "sdio mp-a buffers\n");
-				return -EINVAL;
-			}
-		}
-
-		/* We have validated the data. Now we save them in adapter */
-		switch (length) {
-		case 6:
-			card->mpa_rx.pkt_aggr_limit = data[5];
-		case 5:
-			card->mpa_tx.pkt_aggr_limit = data[4];
-		case 4:
-			card->mpa_rx.buf_size = data[3];
-		case 3:
-			card->mpa_tx.buf_size = data[2];
-		case 2:
-			card->mpa_rx.enabled = data[1];
-		case 1:
-			card->mpa_tx.enabled = data[0];
-			break;
-		default:
-			return -EINVAL;
-		}
-
-		dev_dbg(adapter->dev, "info: new param: %d %d %d %d %d %d\n",
-			card->mpa_tx.enabled, card->mpa_rx.enabled,
-			card->mpa_tx.buf_size, card->mpa_rx.buf_size,
-			card->mpa_tx.pkt_aggr_limit,
-			card->mpa_rx.pkt_aggr_limit);
-	}
-
-	return 0;
-}
-
 static struct mwifiex_if_ops sdio_ops = {
 	.init_if = mwifiex_init_sdio,
 	.cleanup_if = mwifiex_cleanup_sdio,
@@ -1815,7 +1697,6 @@ static struct mwifiex_if_ops sdio_ops = {
 
 	/* SDIO specific */
 	.update_mp_end_port = mwifiex_update_mp_end_port,
-	.sdio_mpa_ctrl = mwifiex_sdio_mpactrl,
 	.cleanup_mpa_buf = mwifiex_cleanup_mpa_buf,
 };
 
-- 
1.7.0.2

