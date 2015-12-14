Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19953 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbbLNMRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:23 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECGb8j027452
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:22 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng024-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:22 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 09/14] mwifiex: add debugfs file for testing reset of card
Date: Mon, 14 Dec 2015 04:15:10 -0800
Message-ID: <1450095315-19927-10-git-send-email-akarwar@marvell.com> (sfid-20151214_131728_282285_41F182C0)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This provides an option for user to power cycle the card.
It will be used to change the firmware without actually
rebooting the system.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/debugfs.c | 30 ++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index 9824d8d..5e55629 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -906,6 +906,34 @@ mwifiex_timeshare_coex_write(struct file *file, const char __user *ubuf,
 		return count;
 }
 
+static ssize_t
+mwifiex_reset_write(struct file *file,
+		    const char __user *ubuf, size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv = file->private_data;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	char cmd;
+	bool result;
+
+	if (copy_from_user(&cmd, ubuf, sizeof(cmd)))
+		return -EFAULT;
+
+	if (strtobool(&cmd, &result))
+		return -EINVAL;
+
+	if (!result)
+		return -EINVAL;
+
+	if (adapter->if_ops.card_reset) {
+		dev_info(adapter->dev, "Resetting per request\n");
+		adapter->hw_status = MWIFIEX_HW_STATUS_RESET;
+		mwifiex_cancel_all_pending_cmd(adapter);
+		adapter->if_ops.card_reset(adapter);
+	}
+
+	return count;
+}
+
 #define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
 	if (!debugfs_create_file(#name, 0644, priv->dfs_dev_dir,        \
 			priv, &mwifiex_dfs_##name##_fops))              \
@@ -943,6 +971,7 @@ MWIFIEX_DFS_FILE_OPS(hscfg);
 MWIFIEX_DFS_FILE_OPS(histogram);
 MWIFIEX_DFS_FILE_OPS(debug_mask);
 MWIFIEX_DFS_FILE_OPS(timeshare_coex);
+MWIFIEX_DFS_FILE_WRITE_OPS(reset);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -970,6 +999,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(histogram);
 	MWIFIEX_DFS_ADD_FILE(debug_mask);
 	MWIFIEX_DFS_ADD_FILE(timeshare_coex);
+	MWIFIEX_DFS_ADD_FILE(reset);
 }
 
 /*
-- 
1.8.1.4

