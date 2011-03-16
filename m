Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38848 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1CPCmw (ORCPT
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
Subject: [PATCH 4/6] mwifiex: remove txaggrprio command from debugfs
Date: Tue, 15 Mar 2011 19:46:08 -0700
Message-Id: <1300243570-6798-5-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
References: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kiran Divekar <dkiran@marvell.com>

This patch removes the user configuration of the priority table for
AMPDU/AMSDU traffic per tid.

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c       |   54 ----------------
 drivers/net/wireless/mwifiex/11n.h       |    3 -
 drivers/net/wireless/mwifiex/README      |   38 -----------
 drivers/net/wireless/mwifiex/debugfs.c   |  103 ------------------------------
 drivers/net/wireless/mwifiex/ioctl.h     |    5 --
 drivers/net/wireless/mwifiex/main.h      |    5 --
 drivers/net/wireless/mwifiex/sta_ioctl.c |   53 ---------------
 7 files changed, 0 insertions(+), 261 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 8b58863..156582f 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -96,60 +96,6 @@ int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to set/get aggregated priority table configuration.
- *
- * The configuration can only be set in disconnected state.
- * Setting of both AMPDU and AMSDU priority tables are supported.
- */
-int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
-				    struct mwifiex_ds_11n_aggr_prio_tbl
-				    *aggr_prio_tbl, u16 action)
-{
-	int i = 0;
-	int ret = 0;
-
-	if (action == HostCmd_ACT_GEN_GET) {
-		for (i = 0; i < MAX_NUM_TID; i++) {
-			aggr_prio_tbl->ampdu[i] =
-				priv->aggr_prio_tbl[i].ampdu_user;
-			aggr_prio_tbl->amsdu[i] = priv->aggr_prio_tbl[i].amsdu;
-		}
-		return 0;
-	}
-
-	/* action == SET */
-	if (priv->media_connected) {
-		dev_err(priv->adapter->dev, "cannot set aggr priority"
-				" table in connected state\n");
-		return -1;
-	}
-
-	for (i = 0; i < MAX_NUM_TID; i++) {
-		/* For AMPDU */
-		if ((aggr_prio_tbl->ampdu[i] > HIGH_PRIO_TID)
-		    && (aggr_prio_tbl->ampdu[i] != BA_STREAM_NOT_ALLOWED)) {
-			ret = -1;
-			break;
-		}
-
-		priv->aggr_prio_tbl[i].ampdu_ap =
-			priv->aggr_prio_tbl[i].ampdu_user =
-			aggr_prio_tbl->ampdu[i];
-
-		/* For AMSDU */
-		if ((aggr_prio_tbl->amsdu[i] > HIGH_PRIO_TID
-		     && aggr_prio_tbl->amsdu[i] != BA_STREAM_NOT_ALLOWED)) {
-			ret = -1;
-			break;
-		} else {
-			priv->aggr_prio_tbl[i].amsdu = aggr_prio_tbl->amsdu[i];
-		}
-	}
-
-	return ret;
-}
-
-/*
  * Fills HT capability information field, AMPDU Parameters field, HT extended
  * capability field, and supported MCS set fields.
  *
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 87c7958..c06e620 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -54,9 +54,6 @@ int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
 				u16 action);
 int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv,
 				  u16 action, int *htcap_cfg);
-int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
-				    struct mwifiex_ds_11n_aggr_prio_tbl
-				    *aggr_prio_tbl, u16 action);
 int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
 				      struct mwifiex_wait_queue *wait_queue,
 				      struct mwifiex_ds_11n_amsdu_aggr_ctrl
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 288605c..54ef654 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -207,44 +207,6 @@ antcfg
 		echo "1" > antcfg		     : Set Tx/Rx antenna 1
 		echo "65535" > antcfg		     : Set Tx/Rx antenna diversity
 
-txaggrprio
-	This command is used set/get the priority table for AMPDU/AMSDU traffic per tid.
-	This command can also be used to disable AMPDU/AMSDU for a given tid.
-	In case of AMPDU this priority table will be used to setup block ack (to make
-	sure the highest priority tid always uses AMPDU as we have limited AMPDU streams)
-
-	Usage:
-	echo "<m0><n0>...<m7><n7>" > txaggrprio
-	cat txaggrprio
-
-	where
-
-	<mx> - This is priority for Tid0 for AMPDU packet. A priority could be any
-		   values between 0 - 7, 0xff to disable aggregation.
-	<nx> - This is priority for Tid0 for AMSDU packet. A priority could be any
-		   values between 0 - 7, 0xff to disable aggregation.
-
-	eg:
-	cat txaggrprio   - This command will get the current Priority table for AMPDU and AMSDU.
-						  <2 2 0 0 1 1 3 3 4 4 5 5 255 255 255 255>. This is read as
-						  <"Prio for AMPDU for Tid0" "Prio for AMSDU for Tid0"
-						   "Prio for AMPDU for Tid1" "Prio for AMSDU for Tid1" and so on
-	echo "2 2 0 0 1 1 3 3 4 4 5 5 255 255 255 255" > txaggrprio  -
-						This will set the priority table for AMPDU and AMSDU
-						Priority for Tid0/AMPDU = 2, Tid0/AMSDU = 2, Tid1/AMPDU = 0, Tid1/AMSDU = 0
-						and so on. Aggregation for Tid6 and Tid7 are disabled.
-						Here higher the priority number, higher the priority (i.e. 7
-						has higher priority than 6). Similarly for AMSDU.
-	echo "0xff 2 0xff 0 0xff 1 0xff 3 0xff 4 0xff 5 0xff 0xff 0xff 0xff" > txaggrprio  - This will disable
-						AMPDU for all the TIDs but will still keep AMSDU enabled to Tid0 to Tid5
-
-	The default setting is 2 2 0 0 1 1 3 3 4 4 5 5 255 255 255 255.
-
-	A delBA should be seen in case a disable happens on a TID for which AMPDU stream
-	is currently setup.
-
-	Note:- This command should only be issue in disconnected state.
-
 txbufcfg
 	This command can be used to set max transmit buffer size of firmware. Increasing this
 	buffer size is recommended for AMSDU packets. (Default is 2048)
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index b0fa226..0bcedde 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -492,107 +492,6 @@ free_and_exit:
 }
 
 /*
- * Proc txaggrpio file write handler.
- *
- * This function is called when the 'txaggrprio' file is opened for writing
- *
- * This function can be used to set the Tx aggregation parameters.
- */
-static ssize_t
-mwifiex_txaggrprio_write(struct file *file, const char __user *ubuf,
-			 size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int ret = 0, i = 0;
-	int *data = NULL;
-	char *p = NULL;
-
-	if (!buf)
-		return -ENOMEM;
-
-	data = kzalloc((sizeof(int) * MAX_NUM_TID * 2), GFP_KERNEL);
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
-		sscanf(p, "%d", (data + i));
-		i++;
-
-	}
-	if (i != (MAX_NUM_TID * 2)) {
-		dev_err(priv->adapter->dev,
-				"invalid number of parameters %d\n", i);
-		ret = -EINVAL;
-		goto done;
-	}
-
-	ret = mwifiex_tx_aggr_prio_tbl(priv, data, (MAX_NUM_TID * 2));
-	if (ret) {
-		ret = -EINVAL;
-		dev_dbg(priv->adapter->dev,
-				"info: Failed setting tx aggr parameters\n");
-	} else {
-		ret = count;
-		dev_dbg(priv->adapter->dev,
-				"info: Successfully set tx aggr parameters\n");
-	}
-done:
-	kfree(data);
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc txaggrpio file read handler.
- *
- * This function is called when the 'txaggrprio' file is opened for reading
- *
- * This function can be used to get the Tx aggregation parameters.
- */
-static ssize_t
-mwifiex_txaggrprio_read(struct file *file, char __user *ubuf,
-			   size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0, i;
-	int *data = kzalloc(sizeof(int) * MAX_NUM_TID * 2, GFP_KERNEL);
-
-	if (!data) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-
-	mwifiex_get_tx_aggr_prio_tbl(priv, data);
-
-	for (i = 0; i < (MAX_NUM_TID * 2); i++)
-		pos += snprintf(buf + strlen(buf), PAGE_SIZE, "%d ", data[i]);
-
-	pos += snprintf(buf + strlen(buf), PAGE_SIZE, "\n");
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-
-done:
-	free_page(addr);
-	kfree(data);
-	return ret;
-}
-
-/*
  * Proc amsduaggrctrl file write handler.
  *
  * This function is called when the 'amsduaggrctr' file is opened for writing
@@ -1883,7 +1782,6 @@ MWIFIEX_DFS_FILE_READ_OPS(debug);
 MWIFIEX_DFS_FILE_OPS(deepsleep);
 MWIFIEX_DFS_FILE_OPS(hscfg);
 MWIFIEX_DFS_FILE_OPS(amsduaggrctrl);
-MWIFIEX_DFS_FILE_OPS(txaggrprio);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_OPS(mpactrl);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
@@ -1918,7 +1816,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(deepsleep);
 	MWIFIEX_DFS_ADD_FILE(hscfg);
 	MWIFIEX_DFS_ADD_FILE(amsduaggrctrl);
-	MWIFIEX_DFS_ADD_FILE(txaggrprio);
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
 	MWIFIEX_DFS_ADD_FILE(mpactrl);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 7be79ea..d4e895d 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -423,11 +423,6 @@ struct mwifiex_ds_11n_amsdu_aggr_ctrl {
 	u16 curr_buf_size;
 };
 
-struct mwifiex_ds_11n_aggr_prio_tbl {
-	u8 ampdu[MAX_NUM_TID];
-	u8 amsdu[MAX_NUM_TID];
-};
-
 #define MWIFIEX_NUM_OF_CMD_BUFFER	20
 #define MWIFIEX_SIZE_OF_CMD_BUFFER	2048
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 035c01a..c4685f3 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1084,11 +1084,6 @@ int mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable);
 int mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv,
 				 int *amsdu_enable, int *curr_buf_size);
 
-int mwifiex_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data,
-			     int length);
-
-int mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data);
-
 int mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on);
 
 int mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index f176168..77bc4ec 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -2467,59 +2467,6 @@ mwifiex_get_drv_txbuf_cfg(struct mwifiex_private *priv, int *max_tx_buf_size)
 }
 
 /*
- * Sends IOCTL request to get aggregation priority table.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data)
-{
-	struct mwifiex_ds_11n_aggr_prio_tbl aggr_prio_tbl;
-	int status = 0;
-	int i, j;
-
-	status = mwifiex_11n_ioctl_aggr_prio_tbl(priv, &aggr_prio_tbl,
-						 HostCmd_ACT_GEN_GET);
-
-	if (status)
-		return -EFAULT;
-
-	for (i = 0, j = 0; i < (MAX_NUM_TID * 2); i = i + 2, ++j) {
-		data[i] = aggr_prio_tbl.ampdu[j];
-		data[i + 1] = aggr_prio_tbl.amsdu[j];
-	}
-
-	return 0;
-}
-
-/*
- * Sends IOCTL request to set aggregation priority table.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data, int length)
-{
-	struct mwifiex_ds_11n_aggr_prio_tbl aggr_prio_tbl;
-	int status = 0;
-	int i, j;
-
-	for (i = 0, j = 0; i < (length); i = i + 2, ++j) {
-		aggr_prio_tbl.ampdu[j] = data[i];
-		aggr_prio_tbl.amsdu[j] = data[i + 1];
-	}
-
-	status = mwifiex_11n_ioctl_aggr_prio_tbl(priv, &aggr_prio_tbl,
-						 HostCmd_ACT_GEN_SET);
-	if (status)
-		return -EFAULT;
-
-	return 0;
-}
-
-/*
  * Sends IOCTL request to set sleep period.
  *
  * This function allocates the IOCTL request buffer, fills it
-- 
1.7.0.2

