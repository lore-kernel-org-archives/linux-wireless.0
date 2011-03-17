Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42468 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1CQAGP (ORCPT
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
Subject: [PATCH 02/11] mwifiex: remove httxcfg command from debugfs
Date: Wed, 16 Mar 2011 17:09:25 -0700
Message-Id: <1300320574-10793-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

The default setting is 0x20:
Bit 5: Short GI in 20 MHz enabled

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c       |   22 ---------
 drivers/net/wireless/mwifiex/11n.h       |    4 --
 drivers/net/wireless/mwifiex/README      |   35 --------------
 drivers/net/wireless/mwifiex/debugfs.c   |   72 ------------------------------
 drivers/net/wireless/mwifiex/sta_ioctl.c |   59 ------------------------
 5 files changed, 0 insertions(+), 192 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index c118669..68de8e7 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -49,28 +49,6 @@ int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to set/get 11n Tx configuration.
- *
- * This function prepares the correct firmware command and
- * issues it.
- */
-int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
-				struct mwifiex_wait_queue *wait_queue,
-				struct mwifiex_ds_11n_tx_cfg *tx_cfg,
-				u16 action)
-{
-	int ret = 0;
-	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
-
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_CFG, action, 0,
-				  wait_queue, tx_cfg);
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
index c06e620..d9f03bb 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -48,10 +48,6 @@ void mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 			struct mwifiex_bssdescriptor *bss_desc);
 void mwifiex_fill_cap_info(struct mwifiex_private *,
 			   struct mwifiex_ie_types_htcap *);
-int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
-				struct mwifiex_wait_queue *wait_queue,
-				struct mwifiex_ds_11n_tx_cfg *tx_cfg,
-				u16 action);
 int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv,
 				  u16 action, int *htcap_cfg);
 int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 374df48..366338c 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -399,41 +399,6 @@ sleeppd
 		cat sleeppd 	                : Get sleep period configuration
 		echo "10" > sleeppd             : Set sleep period to 10 ms
 
-
-httxcfg
-        This command is used to configure various 11n specific configration
-        for transmit (such as Short GI, Channel BW and Green field support)
-	Usage:
-
-	echo "<m>" > httxcfg
-	cat httxcfg
-
-        where <m>
-        This is a bitmap and should be used as following
-                Bit 15-7: Reserved set to 0
-                Bit 6: Short GI in 40 Mhz enable/disable
-                Bit 5: Short GI in 20 Mhz enable/disable
-                Bit 4: Green field enable/disble
-                Bit 3-2: Reserved set to 0
-                Bit 1: 20/40 Mhz enable disable.
-                Bit 0: Reserved set to 0
-
-        When Bit 1 is set then firmware could transmit in 20Mhz or 40Mhz based
-        on rate adaptation. When this bit is reset then firmware will only
-        transmit in 20Mhz.
-
-        echo "0x62" > httxcfg
-        This will enable 20/40 and Short GI but will disable Green field.
-
-        echo "0x30" > httxcfg
-        This will enable Short GI and Green field.
-
-        The default value is 0x20
-
-        Note:- If 20/40 MHz support is disabled in htcapinfo, device will not transmit
-        in 40 MHz even 20/40 MHz is enabled in httxcfg.
-
-
 getlog
         This command is used to get the statistics available in the station.
 	Usage:
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 1809c44..d01a1fc 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -914,76 +914,6 @@ mwifiex_qoscfg_read(struct file *file, char __user *ubuf,
 }
 
 /*
- * Proc httxcfg file write handler.
- *
- * This function is called when the 'httxcfg' file is opened for writing
- *
- * This function can be used to set the HT Tx configuration parameters.
- */
-static ssize_t
-mwifiex_httxcfg_write(struct file *file,
-		      const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int httxcfg = 0;
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
-	sscanf(buf, "%x", &httxcfg);
-
-	ret = mwifiex_set_11n_httx_cfg(priv, httxcfg);
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
- * Proc httxcfg file read handler.
- *
- * This function is called when the 'httxcfg' file is opened for reading
- *
- * This function can be used to get the HT Tx configuration parameters.
- */
-static ssize_t
-mwifiex_httxcfg_read(struct file *file, char __user *ubuf,
-		     size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	int httxcfg = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	mwifiex_get_11n_httx_cfg(priv, &httxcfg);
-
-	pos += snprintf(buf, PAGE_SIZE, "%x\n", httxcfg);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-	return ret;
-}
-
-/*
  * Proc antcfg file write handler.
  *
  * This function is called when the 'antcfg' file is opened for writing
@@ -1564,7 +1494,6 @@ MWIFIEX_DFS_FILE_OPS(amsduaggrctrl);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_OPS(mpactrl);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
-MWIFIEX_DFS_FILE_OPS(httxcfg);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_OPS(antcfg);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
@@ -1595,7 +1524,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
 	MWIFIEX_DFS_ADD_FILE(mpactrl);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
-	MWIFIEX_DFS_ADD_FILE(httxcfg);
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(antcfg);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index b880a00..3d38e87 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -2862,65 +2862,6 @@ done:
 }
 
 /*
- * Sends IOCTL request to set 11n HT Tx configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_11n_httx_cfg(struct mwifiex_private *priv, int data)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_ds_11n_tx_cfg tx_cfg;
-	int status = 0;
-	int ret = 0;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	tx_cfg.tx_htcap = data;
-	status = mwifiex_11n_ioctl_ht_tx_cfg(priv->adapter, wait, &tx_cfg,
-					     HostCmd_ACT_GEN_SET);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-
-	kfree(wait);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get 11n HT Tx configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_11n_httx_cfg(struct mwifiex_private *priv, int *data)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_ds_11n_tx_cfg tx_cfg;
-	int status = 0;
-	int ret = 0;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_11n_ioctl_ht_tx_cfg(priv->adapter, wait, &tx_cfg,
-					     HostCmd_ACT_GEN_GET);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-	if (ret)
-		goto done;
-
-	*data = tx_cfg.tx_htcap;
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

