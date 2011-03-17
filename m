Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42453 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1CQAGP (ORCPT
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
Subject: [PATCH 01/11] mwifiex: remove txratecfg command from debugfs
Date: Wed, 16 Mar 2011 17:09:24 -0700
Message-Id: <1300320574-10793-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

remove the Tx rate configuration API from debugfs

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README      |   45 -------
 drivers/net/wireless/mwifiex/debugfs.c   |   72 ----------
 drivers/net/wireless/mwifiex/decl.h      |    4 -
 drivers/net/wireless/mwifiex/ioctl.h     |    6 -
 drivers/net/wireless/mwifiex/main.c      |    1 -
 drivers/net/wireless/mwifiex/main.h      |    1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |  209 +-----------------------------
 7 files changed, 7 insertions(+), 331 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index aa5ce10..374df48 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -354,51 +354,6 @@ qoscfg
 		echo "15" > qoscfg        : Set WMM IE QOS info to 0x0f
 		cat qoscfg                : Get WMM IE QOS info
 
-txratecfg
-	This command is used to set/get the transmit data rate.
-
-	Note:
-	The data rate can be set only after association.
-
-	Usage:
-	echo "<n> " > txratecfg
-	cat txratecfg
-
-	Where <n>
-		 data rate
-				Data rate
-			0	1 Mbps
-			1	2 Mbps
-			2	5.5 Mbps
-			3	11 Mbps
-			4	6 Mbps
-			5	9 Mbps
-			6	12 Mbps
-			7	18 Mbps
-			8	24 Mbps
-			9	36 Mbps
-			10	48 Mbps
-			11	54 Mbps
-			12	MCS0
-			13	MCS1
-			14	MCS2
-			15	MCS3
-			16	MCS4
-			17	MCS5
-			18	MCS6
-			19	MCS7
-			44	MCS32
-			0xff	Auto
-
-	Examples:
-		echo "3"   >  txratecfg 	     : Set fixed Tx rate to 11 Mbps
-		echo "11"  >  txratecfg	             : Set fixed Tx rate to 54 Mbps
-		echo "15"  >  txratecfg              : Set fixed Tx rate to MCS3
-		echo "255" >  txratecfg 	     : Disable fixed rate and uses auto rate
-		cat txratecfg	                     : Read the current data rate setting
-
-
-
 regrdwr
 	This command is used to read/write the adapter register.
 
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 6b3600b..1809c44 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -914,76 +914,6 @@ mwifiex_qoscfg_read(struct file *file, char __user *ubuf,
 }
 
 /*
- * Proc txratecfg file write handler.
- *
- * This function is called when the 'txratecfg' file is opened for writing
- *
- * This function can be used to set the Tx rate configuration.
- */
-static ssize_t
-mwifiex_txratecfg_write(struct file *file, const char __user *ubuf,
-			size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int txrateindex = 0;
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
-	sscanf(buf, "%d", &txrateindex);
-
-	ret = mwifiex_set_tx_rate_cfg(priv, txrateindex);
-
-	if (!ret)
-		ret = count;
-
-done:
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc txratecfg file read handler.
- *
- * This function is called when the 'txratecfg' file is opened for reading
- *
- * This function can be used to get the Tx rate configuration.
- */
-static ssize_t
-mwifiex_txratecfg_read(struct file *file, char __user *ubuf,
-		       size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	int txrateindex = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	mwifiex_get_tx_rate_cfg(priv, &txrateindex);
-
-	pos += snprintf(buf, PAGE_SIZE, "%d\n", txrateindex);
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
@@ -1634,7 +1564,6 @@ MWIFIEX_DFS_FILE_OPS(amsduaggrctrl);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_OPS(mpactrl);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
-MWIFIEX_DFS_FILE_OPS(txratecfg);
 MWIFIEX_DFS_FILE_OPS(httxcfg);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_OPS(antcfg);
@@ -1666,7 +1595,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
 	MWIFIEX_DFS_ADD_FILE(mpactrl);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
-	MWIFIEX_DFS_ADD_FILE(txratecfg);
 	MWIFIEX_DFS_ADD_FILE(httxcfg);
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(antcfg);
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 37421af..4e1f115 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -39,15 +39,11 @@
 #define MWIFIEX_AMPDU_DEF_RXWINSIZE        16
 #define MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT  0xffff
 
-#define AUTO_RATE			0xff
 #define MWIFIEX_RATE_INDEX_HRDSSS0 0
 #define MWIFIEX_RATE_INDEX_HRDSSS3 3
 #define MWIFIEX_RATE_INDEX_OFDM0   4
 #define MWIFIEX_RATE_INDEX_OFDM7   11
 #define MWIFIEX_RATE_INDEX_MCS0    12
-#define MWIFIEX_RATE_INDEX_MCS7    19
-#define MWIFIEX_RATE_INDEX_MCS32   44
-#define MWIFIEX_RATE_INDEX_MCS127  139
 
 #define MWIFIEX_RATE_BITMAP_OFDM0  16
 #define MWIFIEX_RATE_BITMAP_OFDM7  23
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index d4e895d..115476a 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -339,15 +339,9 @@ struct mwifiex_ds_esupp_mode {
 	u32 act_groupcipher;
 };
 
-enum {
-	MWIFIEX_RATE_INDEX,
-	MWIFIEX_RATE_VALUE
-};
-
 struct mwifiex_rate_cfg {
 	u32 action;
 	u32 is_rate_auto;
-	u32 rate_type;
 	u32 rate;
 };
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index a5a1d78..7b7f344 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -681,7 +681,6 @@ mwifiex_init_priv_params(struct mwifiex_private *priv, struct net_device *dev)
 	init_waitqueue_head(&priv->cmd_wait_q);
 	init_waitqueue_head(&priv->w_stats_wait_q);
 	priv->current_key_index = 0;
-	priv->rate_index = AUTO_RATE;
 	priv->media_connected = false;
 	memset(&priv->nick_name, 0, sizeof(priv->nick_name));
 	priv->num_tx_timeout = 0;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index b34e811..f3626fc 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -495,7 +495,6 @@ struct mwifiex_private {
 	u16 w_stats_wait_q_woken;
 	wait_queue_head_t w_stats_wait_q;
 	u16 current_key_index;
-	u16 rate_index;
 	struct semaphore async_sem;
 	u8 scan_pending_on_block;
 	u8 report_scan_result;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 0c72371..b880a00 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1440,94 +1440,6 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to get rate.
- *
- * This function prepares the correct firmware command and
- * issues it to get the data rate index.
- */
-static int mwifiex_rate_ioctl_get_rate_index(struct mwifiex_private *priv,
-					     struct mwifiex_wait_queue *wait,
-					     struct mwifiex_rate_cfg *rate_cfg)
-{
-	int ret = 0;
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
-				  HostCmd_ACT_GEN_GET, 0, wait, rate_cfg);
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
- * IOCTL request handler to set rate.
- *
- * This function prepares the correct firmware command and
- * issues it to set the data rate index.
- */
-static int mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
-					     struct mwifiex_wait_queue *wait,
-					     struct mwifiex_rate_cfg *rate_cfg)
-{
-	int rate_index;
-	u32 i;
-	int ret = 0;
-	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
-
-	rate_index = rate_cfg->rate;
-	if (rate_cfg->is_rate_auto) {
-		memset(bitmap_rates, 0, sizeof(bitmap_rates));
-		/* Support all HR/DSSS rates */
-		bitmap_rates[0] = 0x000F;
-		/* Support all OFDM rates */
-		bitmap_rates[1] = 0x00FF;
-		/* Support all HT-MCSs rate */
-		for (i = 0; i < ARRAY_SIZE(bitmap_rates) - 3; i++)
-			bitmap_rates[i + 2] = 0xFFFF;
-		bitmap_rates[9] = 0x3FFF;
-	} else {
-		dev_dbg(priv->adapter->dev, "info: Rate index is %d\n",
-			rate_index);
-		memset(bitmap_rates, 0, sizeof(bitmap_rates));
-		/* Bitmap of HR/DSSS rates */
-		if (rate_index >= MWIFIEX_RATE_INDEX_HRDSSS0 &&
-		    rate_index <= MWIFIEX_RATE_INDEX_HRDSSS3)
-			bitmap_rates[0] = 1 << rate_index;
-		/* Bitmap of OFDM rates */
-		if (rate_index >= MWIFIEX_RATE_INDEX_OFDM0 &&
-		    rate_index <= MWIFIEX_RATE_INDEX_OFDM7)
-			bitmap_rates[1] =
-				1 << (rate_index - MWIFIEX_RATE_INDEX_OFDM0);
-		/* Bitmap of HT-MCSs allowed for initial rate */
-		if (rate_index >= MWIFIEX_RATE_INDEX_MCS0 &&
-		    rate_index <= MWIFIEX_RATE_INDEX_MCS32)
-			bitmap_rates[((rate_index -
-				       MWIFIEX_RATE_INDEX_MCS0) / 16) + 2] =
-				1 << ((rate_index - MWIFIEX_RATE_INDEX_MCS0) %
-				      16);
-	}
-
-	dev_dbg(priv->adapter->dev, "info: RateBitmap="
-		"%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x, "
-	       "IsRateAuto=%d, DataRate=%d\n",
-	       bitmap_rates[9], bitmap_rates[8],
-	       bitmap_rates[7], bitmap_rates[6],
-	       bitmap_rates[5], bitmap_rates[4],
-	       bitmap_rates[3], bitmap_rates[2],
-	       bitmap_rates[1], bitmap_rates[0],
-	       priv->is_data_rate_auto, priv->data_rate);
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
-				  HostCmd_ACT_GEN_SET, 0, wait, bitmap_rates);
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/get rate.
  *
  * This function can be used to set/get either the rate value or the
@@ -1541,21 +1453,13 @@ static int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
 
 	if (!rate_cfg)
 		return -1;
-	if (rate_cfg->rate_type == MWIFIEX_RATE_VALUE) {
-		if (rate_cfg->action == HostCmd_ACT_GEN_GET)
-			status = mwifiex_rate_ioctl_get_rate_value(
-					priv, wait, rate_cfg);
-		else
-			status = mwifiex_rate_ioctl_set_rate_value(
-					priv, wait, rate_cfg);
-	} else {
-		if (rate_cfg->action == HostCmd_ACT_GEN_GET)
-			status = mwifiex_rate_ioctl_get_rate_index(
-					priv, wait, rate_cfg);
-		else
-			status = mwifiex_rate_ioctl_set_rate_index(
-					priv, wait, rate_cfg);
-	}
+
+	if (rate_cfg->action == HostCmd_ACT_GEN_GET)
+		status = mwifiex_rate_ioctl_get_rate_value(
+				priv, wait, rate_cfg);
+	else
+		status = mwifiex_rate_ioctl_set_rate_value(
+				priv, wait, rate_cfg);
 
 	return status;
 }
@@ -1580,7 +1484,6 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 
 	memset(rate, 0, sizeof(struct mwifiex_rate_cfg));
 	rate->action = HostCmd_ACT_GEN_GET;
-	rate->rate_type = MWIFIEX_RATE_VALUE;
 	ret = mwifiex_rate_ioctl_cfg(priv, wait, rate);
 
 	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
@@ -3018,104 +2921,6 @@ done:
 }
 
 /*
- * Sends IOCTL request to set Tx rate configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_idx)
-{
-	int ret = 0;
-	struct mwifiex_rate_cfg rate_cfg;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	memset(&rate_cfg, 0, sizeof(struct mwifiex_rate_cfg));
-	rate_cfg.action = HostCmd_ACT_GEN_SET;
-	rate_cfg.rate_type = MWIFIEX_RATE_INDEX;
-	if (tx_rate_idx == AUTO_RATE) {
-		rate_cfg.is_rate_auto = 1;
-	} else {
-		if ((tx_rate_idx != MWIFIEX_RATE_INDEX_MCS32) &&
-		    ((tx_rate_idx < 0)
-		     || (tx_rate_idx > MWIFIEX_RATE_INDEX_MCS7))) {
-			ret = -EINVAL;
-			goto done;
-		}
-		rate_cfg.rate = tx_rate_idx;
-	}
-	status = mwifiex_rate_ioctl_cfg(priv, wait, &rate_cfg);
-
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
-		ret = -EFAULT;
-done:
-	kfree(wait);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get Tx rate configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
-{
-	int ret = 0;
-	struct mwifiex_rate_cfg rate_cfg;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
-
-	/* TX rate configuration can be set only if media connected */
-	if (!priv->media_connected) {
-		dev_dbg(priv->adapter->dev,
-			"info: Can not set txratecfg in disconnected state\n");
-		return -1;
-	}
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	memset(&rate_cfg, 0, sizeof(struct mwifiex_rate_cfg));
-	rate_cfg.action = HostCmd_ACT_GEN_GET;
-	rate_cfg.rate_type = MWIFIEX_RATE_INDEX;
-	status = mwifiex_rate_ioctl_cfg(priv, wait, &rate_cfg);
-
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	if (priv->tx_htinfo & BIT(0))
-		rate_cfg.rate = priv->tx_rate + MWIFIEX_RATE_INDEX_MCS0;
-	else
-		/* For HostCmd_CMD_802_11_TX_RATE_QUERY
-		   , there is a hole in rate table
-		   between HR/DSSS and OFDM rates, so
-		   minus 1 for OFDM rate index */
-		rate_cfg.rate = (priv->tx_rate > MWIFIEX_RATE_INDEX_OFDM0)
-				 ? priv->tx_rate - 1 : priv->tx_rate;
-
-	if (priv->is_data_rate_auto)
-		*tx_rate_idx = AUTO_RATE;
-	else
-		*tx_rate_idx = rate_cfg.rate;
-done:
-	kfree(wait);
-	return ret;
-}
-
-/*
  * Set eWPA mode if passphrase/psk is set
  */
 int mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
-- 
1.7.0.2

