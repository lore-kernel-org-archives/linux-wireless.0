Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51478 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab1CQWNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 18:13:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: remove hscfg command from debugfs
Date: Thu, 17 Mar 2011 15:17:10 -0700
Message-Id: <1300400232-13424-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300400232-13424-1-git-send-email-bzhao@marvell.com>
References: <1300400232-13424-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove the API for host sleep parameter configurations

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README      |   33 ----------
 drivers/net/wireless/mwifiex/debugfs.c   |   98 ------------------------------
 drivers/net/wireless/mwifiex/main.h      |    5 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |   41 +-----------
 4 files changed, 5 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 29bba35..37ed4a2 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -163,39 +163,6 @@ info
 
 
 3) FOR DRIVER CONFIGURATION
-hscfg
-	This command is used to configure the host sleep parameters.
-
-	Usage:
-		echo "[condition] [gap] [action]" > hscfg
-		cat hscfg
-
-	where condition is:
-		bit 0 = 1   -- broadcast data
-		bit 1 = 1   -- unicast data
-		bit 2 = 1   -- mac event
-		bit 3 = 1   -- multicast packet
-		bit 4 - 1   -- Wakeup when all the 16 STAs with special IE added to database.
-		bit 5 - 1   -- Wakeup when a new STA is added to the database.
-
-	where Gap is the gap in milliseconds between wakeup signal and wakeup event
-	or 0xff for special setting. The default is 0.
-
-	where action is:
-		1          -- configure and activate host sleep
-		0          -- just configure host sleep without activation. The activation will be
-			      done by suspend handler when system sleeps. This is the default setting.
-
-	The host sleep mode will be cancelled if condition is set to -1. The default is 0xf.
-
-	Examples:
-		cat hscfg	                : Get current host sleep mode
-		echo "-1" > hscfg               : Cancel host sleep mode
-		echo "3" > hscfg                : configure broadcast and unicast data
-		                                  Use gap set previously
-		echo "2 3" > hscfg              : Configure unicast data, gap 3ms
-		echo "2 3 1" > hscfg            : Configure unicast data, gap 3ms and activate host
-						  sleep right away.
 
 qoscfg
 	This command sets WMM IE QOS info when an argument is given, and gets current WMM
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 72f8b3b..d07c399 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -492,102 +492,6 @@ free_and_exit:
 }
 
 /*
- * Proc hscfg file write handler.
- *
- * This function is called when the 'hscfg' file is opened for writing
- *
- * This function can be used to set the Host Sleep configuration parameters.
- */
-static ssize_t
-mwifiex_hscfg_write(struct file *file,
-		       const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int cond = 0, gap = 0, action = 0;
-	int ret = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-
-	if (copy_from_user(buf, ubuf, buf_size)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	ret = sscanf(buf, "%d %d %d", &cond, &gap, &action);
-
-	if (!ret || ret < 0) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	if (cond == HOST_SLEEP_CFG_CANCEL) {
-		ret = mwifiex_cancel_hs(priv, MWIFIEX_IOCTL_WAIT);
-	} else if (action == 1) {
-		ret = mwifiex_set_hs_cfg(priv, cond, gap, ret, true);
-	} else if (action == 0) {
-		ret = mwifiex_set_hs_cfg(priv, cond, gap, ret, false);
-	} else {
-		ret = -EINVAL;
-		dev_err(priv->adapter->dev, "invalid action argument %d\n",
-							action);
-		goto done;
-	}
-
-	if (ret) {
-		ret = -EINVAL;
-		dev_err(priv->adapter->dev, "host sleep configuration failed\n");
-	} else {
-		ret = count;
-		if (cond == HOST_SLEEP_CFG_CANCEL)
-			dev_dbg(priv->adapter->dev, "info: host sleep cancelled\n");
-		else if (action == 0)
-			dev_dbg(priv->adapter->dev, "info: host sleep configured\n");
-		else
-			dev_dbg(priv->adapter->dev,
-					"info: host sleep configured & activated\n");
-	}
-done:
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc hscfg file read handler.
- *
- * This function is called when the 'hscfg' file is opened for reading
- *
- * This function can be used to get the Host Sleep configuration parameters.
- */
-static ssize_t
-mwifiex_hscfg_read(struct file *file, char __user *ubuf,
-		      size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	struct mwifiex_ds_hs_cfg hscfg;
-
-	mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_GET,
-				  MWIFIEX_IOCTL_WAIT, &hscfg);
-
-	pos += snprintf(buf, PAGE_SIZE, "%d %d\n", hscfg.conditions, hscfg.gap);
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
@@ -950,7 +854,6 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 
 MWIFIEX_DFS_FILE_READ_OPS(info);
 MWIFIEX_DFS_FILE_READ_OPS(debug);
-MWIFIEX_DFS_FILE_OPS(hscfg);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
@@ -974,7 +877,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 
 	MWIFIEX_DFS_ADD_FILE(info);
 	MWIFIEX_DFS_ADD_FILE(debug);
-	MWIFIEX_DFS_ADD_FILE(hscfg);
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
 	MWIFIEX_DFS_ADD_FILE(getlog);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1cccf8e..6250724 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -975,7 +975,7 @@ int mwifiex_disconnect(struct mwifiex_private *, u8, u8 *);
 int mwifiex_bss_start(struct mwifiex_private *priv,
 		      u8 wait_option,
 		      struct mwifiex_ssid_bssid *ssid_bssid);
-int mwifiex_set_get_hs_params(struct mwifiex_private *priv,
+int mwifiex_set_hs_params(struct mwifiex_private *priv,
 			      u16 action, u8 wait_option,
 			      struct mwifiex_ds_hs_cfg *hscfg);
 int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option);
@@ -1044,9 +1044,6 @@ int mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_index);
 
 int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
 
-int mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
-		       int data_length, int invoke_hostcmd);
-
 int mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on);
 
 int mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 1f8d562..97dea98 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -592,12 +592,12 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 }
 
 /*
- * Sends IOCTL request to get Host Sleep parameters.
+ * Sends IOCTL request to set Host Sleep parameters.
  *
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-int mwifiex_set_get_hs_params(struct mwifiex_private *priv, u16 action,
+int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
 			      u8 wait_option,
 			      struct mwifiex_ds_hs_cfg *hscfg)
 {
@@ -620,7 +620,6 @@ int mwifiex_set_get_hs_params(struct mwifiex_private *priv, u16 action,
 		kfree(wait);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mwifiex_set_get_hs_params);
 
 /*
  * Sends IOCTL request to cancel the existing Host Sleep configuration.
@@ -636,7 +635,7 @@ int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option)
 	/* Cancel Host Sleep */
 	hscfg.conditions = HOST_SLEEP_CFG_CANCEL;
 	hscfg.is_invoke_hostcmd = true;
-	ret = mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_SET,
+	ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
 					wait_option, &hscfg);
 
 	return ret;
@@ -664,7 +663,7 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	memset(&hscfg, 0, sizeof(struct mwifiex_hs_config_param));
 	hscfg.is_invoke_hostcmd = true;
 
-	if (mwifiex_set_get_hs_params(mwifiex_get_priv(adapter,
+	if (mwifiex_set_hs_params(mwifiex_get_priv(adapter,
 						       MWIFIEX_BSS_ROLE_STA),
 				      HostCmd_ACT_GEN_SET,
 				      MWIFIEX_IOCTL_WAIT, &hscfg)) {
@@ -1894,38 +1893,6 @@ mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
 }
 
 /*
- * Sends IOCTL request to set host sleep configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
-		   int data_length, int invoke_hostcmd)
-{
-	struct mwifiex_ds_hs_cfg hscfg;
-
-	memset(&hscfg, 0, sizeof(struct mwifiex_hs_config_param));
-
-	/* HS config is blocked if HS is already activated */
-	if (priv->adapter->is_hs_configured) {
-		dev_err(priv->adapter->dev, "HS already configured\n");
-		return -EFAULT;
-	}
-
-	hscfg.conditions = cond;
-	if (data_length >= 2)
-		hscfg.gap = gap;
-	hscfg.gpio = HOST_SLEEP_CFG_GPIO_DEF;
-	hscfg.is_invoke_hostcmd = invoke_hostcmd;
-	if (mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_SET,
-				      MWIFIEX_IOCTL_WAIT, &hscfg))
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

