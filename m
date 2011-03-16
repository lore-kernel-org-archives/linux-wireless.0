Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38832 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1CPCmw (ORCPT
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
Subject: [PATCH 1/6] mwifiex: remove atimwindow command from debugfs
Date: Tue, 15 Mar 2011 19:46:05 -0700
Message-Id: <1300243570-6798-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
References: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable 'atim_window' in 'struct mwifiex_bssdescriptor'
becomes redundant afterwards. So it's also removed.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/README        |   15 ------
 drivers/net/wireless/mwifiex/debugfs.c     |   72 ----------------------------
 drivers/net/wireless/mwifiex/join.c        |    1 -
 drivers/net/wireless/mwifiex/main.h        |    5 --
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    4 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   26 ----------
 6 files changed, 1 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index cc6969d..1c40cd7 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -401,21 +401,6 @@ amsduaggrctrl
 			association). This feature is enabled by default by the driver during
 			initialization.
 
-atimwindow
-	This command is used to set/get the ATIM window value in the station.
-	The range of ATIM window is 0 - 50.
-	Note: This command should be issued before ad-hoc start/join and ad-hoc
-	power save on.
-	Usage:
-	echo "<n>" > atimwindow
-
-	where <n> is the ATIM window value to be set
-
-
-	Examples:
-		echo "20" > atimwindow          : Set atimwindow to 20
-		cat atimwindow 		        : Get atimwindow
-
 deepsleep
 	This command is used to set/get auto deep sleep mode.
 
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index c9dcc61..ca105c8 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1095,76 +1095,6 @@ mwifiex_qoscfg_read(struct file *file, char __user *ubuf,
 }
 
 /*
- * Proc atimwindow file write handler.
- *
- * This function is called when the 'atimwindow' file is opened for writing
- *
- * This function can be used to set the ATIM window parameter.
- */
-static ssize_t
-mwifiex_atimwindow_write(struct file *file,
-		   const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int atim = 0;
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
-	sscanf(buf, "%d", &atim);
-
-	mwifiex_set_atim_window(priv, atim);
-
-	ret = count;
-
-done:
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc atimwindow file read handler.
- *
- * This function is called when the 'atimwindow' file is opened for reading
- *
- * This function can be used to get the ATIM window parameter.
- */
-static ssize_t
-mwifiex_atimwindow_read(struct file *file, char __user *ubuf,
-		  size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	int atim = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	mwifiex_get_atim_window(priv, &atim);
-
-	pos += snprintf(buf, PAGE_SIZE, "%d\n", atim);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-
-	return ret;
-}
-
-/*
  * Proc txratecfg file write handler.
  *
  * This function is called when the 'txratecfg' file is opened for writing
@@ -2145,7 +2075,6 @@ MWIFIEX_DFS_FILE_OPS(txaggrprio);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_OPS(mpactrl);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
-MWIFIEX_DFS_FILE_OPS(atimwindow);
 MWIFIEX_DFS_FILE_OPS(txratecfg);
 MWIFIEX_DFS_FILE_OPS(addbapara);
 MWIFIEX_DFS_FILE_OPS(addbareject);
@@ -2183,7 +2112,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
 	MWIFIEX_DFS_ADD_FILE(mpactrl);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
-	MWIFIEX_DFS_ADD_FILE(atimwindow);
 	MWIFIEX_DFS_ADD_FILE(txratecfg);
 	MWIFIEX_DFS_ADD_FILE(addbapara);
 	MWIFIEX_DFS_ADD_FILE(addbareject);
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index f2c027d..34623d1 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -943,7 +943,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	adhoc_start->ss_param_set.ibss_param_set.len = IBSS_PARA_IE_LEN;
 	adhoc_start->ss_param_set.ibss_param_set.atim_window
 		= cpu_to_le16(priv->atim_window);
-	bss_desc->atim_window = priv->atim_window;
 	memcpy(&bss_desc->ss_param_set, &adhoc_start->ss_param_set,
 	       sizeof(union ieee_types_ss_param_set));
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 75dddbc..a34edd1 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -284,7 +284,6 @@ struct mwifiex_bssdescriptor {
 	u32 channel;
 	u32 freq;
 	u16 beacon_period;
-	u32 atim_window;
 	u8 erp_flags;
 	u32 bss_mode;
 	u8 supported_rates[MWIFIEX_SUPPORTED_RATES];
@@ -1062,10 +1061,6 @@ int mwifiex_set_11n_httx_cfg(struct mwifiex_private *priv, int data);
 
 int mwifiex_get_11n_httx_cfg(struct mwifiex_private *priv, int *data);
 
-void mwifiex_set_atim_window(struct mwifiex_private *priv, int atim);
-
-void mwifiex_get_atim_window(struct mwifiex_private *priv, int *atim);
-
 int mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_index);
 
 int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 0b4c093..26e9f1c 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1044,11 +1044,9 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 		memcpy(priv->curr_bss_params.bss_descriptor.mac_address,
 		       ibss_coal_resp->bssid, ETH_ALEN);
 
-		/* Beacon Interval and ATIM window */
+		/* Beacon Interval */
 		priv->curr_bss_params.bss_descriptor.beacon_period
 			= le16_to_cpu(ibss_coal_resp->beacon_interval);
-		priv->curr_bss_params.bss_descriptor.atim_window
-			= le16_to_cpu(ibss_coal_resp->atim_window);
 
 		/* ERP Information */
 		priv->curr_bss_params.bss_descriptor.erp_flags =
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 71beb9b..9cc9db9 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -3203,32 +3203,6 @@ done:
 }
 
 /*
- * Sends IOCTL request to set ATIM window.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-void
-mwifiex_set_atim_window(struct mwifiex_private *priv, int atim)
-{
-	priv->atim_window = (u16) atim;
-}
-
-/*
- * Sends IOCTL request to get ATIM window.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-void
-mwifiex_get_atim_window(struct mwifiex_private *priv, int *atim)
-{
-	*atim = priv->atim_window;
-	if (priv->media_connected)
-		*atim = priv->curr_bss_params.bss_descriptor.atim_window;
-}
-
-/*
  * Sends IOCTL request to set Tx rate configurations.
  *
  * This function allocates the IOCTL request buffer, fills it
-- 
1.7.0.2

