Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51471 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab1CQWNy (ORCPT
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
Subject: [PATCH 2/3] mwifiex: remove qoscfg from debugfs
Date: Thu, 17 Mar 2011 15:17:11 -0700
Message-Id: <1300400232-13424-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300400232-13424-1-git-send-email-bzhao@marvell.com>
References: <1300400232-13424-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove the debugfs API for WMM IE QOS info configuration

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README    |   14 ------
 drivers/net/wireless/mwifiex/debugfs.c |   73 --------------------------------
 2 files changed, 0 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 37ed4a2..0bf442a 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -164,20 +164,6 @@ info
 
 3) FOR DRIVER CONFIGURATION
 
-qoscfg
-	This command sets WMM IE QOS info when an argument is given, and gets current WMM
-	IE QOS info when no argument is given.
-
-	Usage:
-	echo "<n>" > qoscfg
-	cat qoscfg
-
-	where <n> is the qos info value
-
-	Examples:
-		echo "15" > qoscfg        : Set WMM IE QOS info to 0x0f
-		cat qoscfg                : Get WMM IE QOS info
-
 regrdwr
 	This command is used to read/write the adapter register.
 
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index d07c399..462a8a4 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -563,77 +563,6 @@ mwifiex_sleeppd_read(struct file *file, char __user *ubuf,
 	return ret;
 }
 
-/*
- * Proc qoscfg file write handler.
- *
- * This function is called when the 'qoscfg' file is opened for writing
- *
- * This function can be used to set the QoS configuration parameters.
- */
-static ssize_t
-mwifiex_qoscfg_write(struct file *file,
-		     const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int qoscfg = 0;
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
-	sscanf(buf, "%d", &qoscfg);
-
-	priv->wmm_qosinfo = qoscfg;
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
- * Proc qoscfg file read handler.
- *
- * This function is called when the 'qoscfg' file is opened for reading
- *
- * This function can be used to get the QoS configuration parameters.
- */
-static ssize_t
-mwifiex_qoscfg_read(struct file *file, char __user *ubuf,
-		    size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	int qoscfg = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	qoscfg = priv->wmm_qosinfo;
-
-	pos += snprintf(buf, PAGE_SIZE, "%d\n", qoscfg);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-
-	return ret;
-}
-
 static u32 saved_reg_type, saved_reg_offset, saved_reg_value;
 
 /*
@@ -855,7 +784,6 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 MWIFIEX_DFS_FILE_READ_OPS(info);
 MWIFIEX_DFS_FILE_READ_OPS(debug);
 MWIFIEX_DFS_FILE_OPS(sleeppd);
-MWIFIEX_DFS_FILE_OPS(qoscfg);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
@@ -878,7 +806,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(info);
 	MWIFIEX_DFS_ADD_FILE(debug);
 	MWIFIEX_DFS_ADD_FILE(sleeppd);
-	MWIFIEX_DFS_ADD_FILE(qoscfg);
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
-- 
1.7.0.2

