Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38827 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab1CPCmw (ORCPT
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
Subject: [PATCH 3/6] mwifiex: remove addbareject configuration from debugfs
Date: Tue, 15 Mar 2011 19:46:07 -0700
Message-Id: <1300243570-6798-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
References: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kiran Divekar <dkiran@marvell.com>

The default values will be used instead.

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   35 ---------
 drivers/net/wireless/mwifiex/11n.h           |    2 -
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    6 +--
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    1 -
 drivers/net/wireless/mwifiex/README          |   25 -------
 drivers/net/wireless/mwifiex/debugfs.c       |   98 --------------------------
 drivers/net/wireless/mwifiex/init.c          |    3 -
 drivers/net/wireless/mwifiex/main.h          |    1 -
 8 files changed, 1 insertions(+), 170 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index fcf2971..8b58863 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -96,41 +96,6 @@ int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to set/get add BA reject configuration.
- *
- * The configuration can only be set in disconnected state.
- */
-int mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
-				 u16 action, int *addba_reject)
-{
-	int i = 0;
-	int ret = 0;
-
-	if (action == HostCmd_ACT_GEN_GET) {
-		dev_dbg(priv->adapter->dev, "info: GET: addba reject\n");
-		memcpy(addba_reject, priv->addba_reject, MAX_NUM_TID);
-	} else {
-		if (priv->media_connected) {
-			dev_err(priv->adapter->dev,
-				"cannot set addba reject in connected state\n");
-			return -1;
-		}
-
-		for (i = 0; i < MAX_NUM_TID; i++) {
-			/* For AMPDU */
-			if (addba_reject[i] > ADDBA_RSP_STATUS_REJECT) {
-				ret = -1;
-				break;
-			}
-
-			priv->addba_reject[i] = addba_reject[i];
-		}
-	}
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/get aggregated priority table configuration.
  *
  * The configuration can only be set in disconnected state.
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 2ee940f..87c7958 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -57,8 +57,6 @@ int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv,
 int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 				    struct mwifiex_ds_11n_aggr_prio_tbl
 				    *aggr_prio_tbl, u16 action);
-int mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
-				 u16 action, int *);
 int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
 				      struct mwifiex_wait_queue *wait_queue,
 				      struct mwifiex_ds_11n_amsdu_aggr_ctrl
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 72c626f..8e94e62 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -368,11 +368,7 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	block_ack_param_set = le16_to_cpu(cmd_addba_req->block_ack_param_set);
 	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
 		>> BLOCKACKPARAM_TID_POS;
-	if (priv->addba_reject[tid])
-		add_ba_rsp->status_code =
-			cpu_to_le16(WLAN_STATUS_REQUEST_DECLINED);
-	else
-		add_ba_rsp->status_code = cpu_to_le16(ADDBA_RSP_STATUS_ACCEPT);
+	add_ba_rsp->status_code = cpu_to_le16(ADDBA_RSP_STATUS_ACCEPT);
 	block_ack_param_set &= ~IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK;
 	/* We donot support AMSDU inside AMPDU, hence reset the bit */
 	block_ack_param_set &= ~BLOCKACKPARAM_AMSDU_SUPP_MASK;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 84f3a3a..42f5690 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -35,7 +35,6 @@
 #define TYPE_DELBA_RECEIVE		2
 #define IMMEDIATE_BLOCK_ACK		0x2
 
-#define ADDBA_RSP_STATUS_REJECT 1
 #define ADDBA_RSP_STATUS_ACCEPT 0
 
 int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *,
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 35811d3..288605c 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -245,31 +245,6 @@ txaggrprio
 
 	Note:- This command should only be issue in disconnected state.
 
-addbareject
-	This command is used set/get the addbareject table for all the TIDs.
-	This command can also be used to enable rejection of ADDBA requests for a given tid.
-
-	Usage:
-	echo "<m0>...<m7>" > addbareject
-	cat addbareject
-
-	where
-
-	<mX> - This can be 0/1 for TidX. 1 enables rejection of ADDBA request for TidX and
-		   0 would accept any ADDBAs for TidX.
-
-	eg:
-	cat addbareject - This command will get the current table.
-	    [0 0 0 0 0 0 0 0]. ADDBA would be accepted for all TIDs. This is the default state.
-
-	echo "0 0 1 1 0 0 0 0" > addbareject - This command will accept ADDBA requests for
-		Tid [0,1,4,5,6,7] and reject ADDBA requests for Tid [2,3]
-
-	echo "1 1 1 1 1 1 1 1" > addbareject - This will enable rejection of ADDBA requests for
-		all Tids.
-
-	Note:- This command should only be issue in disconnected state.
-
 txbufcfg
 	This command can be used to set max transmit buffer size of firmware. Increasing this
 	buffer size is recommended for AMSDU packets. (Default is 2048)
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 0ff3663..b0fa226 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1305,102 +1305,6 @@ mwifiex_htcapinfo_read(struct file *file, char __user *ubuf,
 }
 
 /*
- * Proc addbareject file write handler.
- *
- * This function is called when the 'addbareject' file is opened for writing
- *
- * This function can be used to set the add BA reject parameters.
- */
-static ssize_t
-mwifiex_addbareject_write(struct file *file, const char __user *ubuf,
-			  size_t count, loff_t *ppos)
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
-	data = kzalloc((sizeof(int) * 8), GFP_KERNEL);
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
-	if (length != 8) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	ret = mwifiex_set_get_addba_reject(priv, HostCmd_ACT_GEN_SET, data);
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
- * Proc addbareject file read handler.
- *
- * This function is called when the 'addbareject' file is opened for reading
- *
- * This function can be used to get the add BA reject parameters.
- */
-static ssize_t
-mwifiex_addbareject_read(struct file *file, char __user *ubuf,
-			 size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int ret = 0, i = 0, pos = 0;
-	int *data = kzalloc((sizeof(int) * 8), GFP_KERNEL);
-
-	if (!buf) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	mwifiex_set_get_addba_reject(priv, HostCmd_ACT_GEN_GET, data);
-
-	for (i = 0; i < 8; i++)
-		pos += snprintf(buf + strlen(buf), PAGE_SIZE, "%d ", data[i]);
-
-	pos += snprintf(buf + strlen(buf), PAGE_SIZE, "\n ");
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-done:
-	kfree(data);
-	free_page(addr);
-	return ret;
-}
-
-/*
  * Proc antcfg file write handler.
  *
  * This function is called when the 'antcfg' file is opened for writing
@@ -1984,7 +1888,6 @@ MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_OPS(mpactrl);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
 MWIFIEX_DFS_FILE_OPS(txratecfg);
-MWIFIEX_DFS_FILE_OPS(addbareject);
 MWIFIEX_DFS_FILE_OPS(httxcfg);
 MWIFIEX_DFS_FILE_OPS(htcapinfo);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
@@ -2020,7 +1923,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(mpactrl);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
 	MWIFIEX_DFS_ADD_FILE(txratecfg);
-	MWIFIEX_DFS_ADD_FILE(addbareject);
 	MWIFIEX_DFS_ADD_FILE(httxcfg);
 	MWIFIEX_DFS_ADD_FILE(htcapinfo);
 	MWIFIEX_DFS_ADD_FILE(getlog);
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 48c84d5..0dfc147 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -139,9 +139,6 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->curr_bcn_buf = NULL;
 	priv->curr_bcn_size = 0;
 
-	for (i = 0; i < MAX_NUM_TID; i++)
-		priv->addba_reject[i] = ADDBA_RSP_STATUS_ACCEPT;
-
 	priv->scan_block = false;
 
 	ret = mwifiex_add_bss_prio_tbl(priv);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 9272fa4..035c01a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -454,7 +454,6 @@ struct mwifiex_private {
 	/* spin lock for tx_ba_stream_tbl_ptr queue */
 	spinlock_t tx_ba_stream_tbl_lock;
 	struct mwifiex_tx_aggr aggr_prio_tbl[MAX_NUM_TID];
-	u8 addba_reject[MAX_NUM_TID];
 	struct mwifiex_add_ba_param add_ba_param;
 	u16 rx_seq[MAX_NUM_TID];
 	struct list_head rx_reorder_tbl_ptr;
-- 
1.7.0.2

