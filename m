Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23977 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbcAGHnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 02:43:13 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u077e73U016039
	for <linux-wireless@vger.kernel.org>; Wed, 6 Jan 2016 23:43:13 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 209g1d8je0-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2016 23:43:12 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 3/3] mwifiex: add debugfs file to read chip information
Date: Wed, 6 Jan 2016 23:40:49 -0800
Message-ID: <1452152449-29803-3-git-send-email-akarwar@marvell.com> (sfid-20160107_084317_444564_C256C940)
In-Reply-To: <1452152449-29803-1-git-send-email-akarwar@marvell.com>
References: <1452152449-29803-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add 'verext' debugfs item, which can be used to
get detailed chip specific information from our firmware.

Examples:
echo "1" > /sys/kernel/debug/mwifiex/mlan0/verext
cat /sys/kernel/debug/mwifiex/mlan0/verext

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/README      | 10 +++++
 drivers/net/wireless/marvell/mwifiex/debugfs.c   | 51 +++++++++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/main.h      |  3 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |  3 +-
 4 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/README b/drivers/net/wireless/marvell/mwifiex/README
index 2f0f9b5..24e649b 100644
--- a/drivers/net/wireless/marvell/mwifiex/README
+++ b/drivers/net/wireless/marvell/mwifiex/README
@@ -237,4 +237,14 @@ device_dump
 
 	cat fw_dump
 
+verext
+	This command is used to get extended firmware version string using
+	different configuration parameters.
+
+	Usage:
+		echo "[version_str_sel]" > verext
+		cat verext
+
+		[version_str_sel]: firmware support several extend version
+				   string cases, include 0/1/10/20/21/99
 ===============================================================================
diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index 5e55629..13fe384 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -95,8 +95,7 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 
 	mwifiex_drv_get_driver_version(priv->adapter, fmt, sizeof(fmt) - 1);
 
-	if (!priv->version_str[0])
-		mwifiex_get_ver_ext(priv);
+	mwifiex_get_ver_ext(priv, 0);
 
 	p += sprintf(p, "driver_name = " "\"mwifiex\"\n");
 	p += sprintf(p, "driver_version = %s", fmt);
@@ -596,6 +595,52 @@ done:
 	return ret;
 }
 
+/* debugfs verext file write handler.
+ * This function is called when the 'verext' file is opened for write
+ */
+static ssize_t
+mwifiex_verext_write(struct file *file, const char __user *ubuf,
+		     size_t count, loff_t *ppos)
+{
+	int ret;
+	u32 versionstrsel;
+	struct mwifiex_private *priv = (void *)file->private_data;
+	char buf[16];
+
+	memset(buf, 0, sizeof(buf));
+
+	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
+		return -EFAULT;
+
+	ret = kstrtou32(buf, 10, &versionstrsel);
+	if (ret)
+		return ret;
+
+	priv->versionstrsel = versionstrsel;
+
+	return count;
+}
+
+/* Proc verext file read handler.
+ * This function is called when the 'verext' file is opened for reading
+ * This function can be used read driver exteneed verion string.
+ */
+static ssize_t
+mwifiex_verext_read(struct file *file, char __user *ubuf,
+		    size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv =
+		(struct mwifiex_private *)file->private_data;
+	char buf[256];
+	int ret;
+
+	mwifiex_get_ver_ext(priv, priv->versionstrsel);
+	ret = snprintf(buf, sizeof(buf), "version string: %s\n",
+		       priv->version_str);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, ret);
+}
+
 /* Proc memrw file write handler.
  * This function is called when the 'memrw' file is opened for writing
  * This function can be used to write to a memory location.
@@ -972,6 +1017,7 @@ MWIFIEX_DFS_FILE_OPS(histogram);
 MWIFIEX_DFS_FILE_OPS(debug_mask);
 MWIFIEX_DFS_FILE_OPS(timeshare_coex);
 MWIFIEX_DFS_FILE_WRITE_OPS(reset);
+MWIFIEX_DFS_FILE_OPS(verext);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -1000,6 +1046,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(debug_mask);
 	MWIFIEX_DFS_ADD_FILE(timeshare_coex);
 	MWIFIEX_DFS_ADD_FILE(reset);
+	MWIFIEX_DFS_ADD_FILE(verext);
 }
 
 /*
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index c08be79..35ab052 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -616,6 +616,7 @@ struct mwifiex_private {
 	spinlock_t curr_bcn_buf_lock;
 	struct wireless_dev wdev;
 	struct mwifiex_chan_freq_power cfp;
+	u32 versionstrsel;
 	char version_str[128];
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dfs_dev_dir;
@@ -1418,7 +1419,7 @@ int mwifiex_set_encode(struct mwifiex_private *priv, struct key_params *kp,
 
 int mwifiex_set_gen_ie(struct mwifiex_private *priv, const u8 *ie, int ie_len);
 
-int mwifiex_get_ver_ext(struct mwifiex_private *priv);
+int mwifiex_get_ver_ext(struct mwifiex_private *priv, u32 version_str_sel);
 
 int mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 			       struct ieee80211_channel *chan,
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 6a4fc5d..210b257 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1114,11 +1114,12 @@ int mwifiex_set_encode(struct mwifiex_private *priv, struct key_params *kp,
  * with requisite parameters and calls the IOCTL handler.
  */
 int
-mwifiex_get_ver_ext(struct mwifiex_private *priv)
+mwifiex_get_ver_ext(struct mwifiex_private *priv, u32 version_str_sel)
 {
 	struct mwifiex_ver_ext ver_ext;
 
 	memset(&ver_ext, 0, sizeof(struct host_cmd_ds_version_ext));
+	ver_ext.version_str_sel = version_str_sel;
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_VERSION_EXT,
 			     HostCmd_ACT_GEN_GET, 0, &ver_ext, true))
 		return -1;
-- 
1.8.1.4

