Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28976 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbaDQSrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 14:47:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/5] mwifiex: add fw_dump debugfs file
Date: Thu, 17 Apr 2014 11:46:59 -0700
Message-ID: <1397760423-11455-1-git-send-email-bzhao@marvell.com> (sfid-20140417_204757_712827_BA1837B0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This option be useful to dump firmware memory for debugging
purpose. Actual code to dump firmware momory for SDIO and PCIe
chipsets will be added later.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README    |  7 +++++++
 drivers/net/wireless/mwifiex/debugfs.c | 25 +++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h    |  1 +
 3 files changed, 33 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index b9242c3..3b55ce5 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -200,4 +200,11 @@ getlog
 
 	cat getlog
 
+fw_dump
+	This command is used to dump firmware memory into files.
+	Separate file will be created for each memory segment.
+	Usage:
+
+	cat fw_dump
+
 ===============================================================================
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index b8a49aa..7b419bb 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -257,6 +257,29 @@ free_and_exit:
 }
 
 /*
+ * Proc firmware dump read handler.
+ *
+ * This function is called when the 'fw_dump' file is opened for
+ * reading.
+ * This function dumps firmware memory in different files
+ * (ex. DTCM, ITCM, SQRAM etc.) based on the the segments for
+ * debugging.
+ */
+static ssize_t
+mwifiex_fw_dump_read(struct file *file, char __user *ubuf,
+		     size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv = file->private_data;
+
+	if (!priv->adapter->if_ops.fw_dump)
+		return -EIO;
+
+	priv->adapter->if_ops.fw_dump(priv->adapter);
+
+	return 0;
+}
+
+/*
  * Proc getlog file read handler.
  *
  * This function is called when the 'getlog' file is opened for reading
@@ -699,6 +722,7 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 MWIFIEX_DFS_FILE_READ_OPS(info);
 MWIFIEX_DFS_FILE_READ_OPS(debug);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
+MWIFIEX_DFS_FILE_READ_OPS(fw_dump);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
 
@@ -722,6 +746,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
+	MWIFIEX_DFS_ADD_FILE(fw_dump);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ae8b042..3418119 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -672,6 +672,7 @@ struct mwifiex_if_ops {
 	int (*init_fw_port) (struct mwifiex_adapter *);
 	int (*dnld_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 	void (*card_reset) (struct mwifiex_adapter *);
+	void (*fw_dump)(struct mwifiex_adapter *);
 	int (*clean_pcie_ring) (struct mwifiex_adapter *adapter);
 };
 
-- 
1.8.2.3

