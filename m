Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27786 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab1DOGNv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 02:13:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 23:13:25 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/2] ath9k_htc: Add debugfs support to change debug mask
Date: Fri, 15 Apr 2011 11:43:52 +0530
Message-ID: <1302848033-7072-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h           |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   48 ++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index cc5d0a4..852cdcf 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -366,6 +366,7 @@ struct ath9k_debug {
 	struct dentry *debugfs_recv;
 	struct dentry *debugfs_slot;
 	struct dentry *debugfs_queue;
+	struct dentry *debugfs_debug;
 	struct ath_tx_stats tx_stats;
 	struct ath_rx_stats rx_stats;
 };
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 8d0de60..3899eaa 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -435,6 +435,47 @@ static const struct file_operations fops_queue = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_debug(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "0x%08x\n", common->debug_mask);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	unsigned long mask;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &mask))
+		return -EINVAL;
+
+	common->debug_mask = mask;
+	return count;
+}
+
+static const struct file_operations fops_debug = {
+	.read = read_file_debug,
+	.write = write_file_debug,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath9k_htc_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -493,6 +534,12 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 	if (!priv->debug.debugfs_queue)
 		goto err;
 
+	priv->debug.debugfs_debug = debugfs_create_file("debug", S_IRUSR,
+							priv->debug.debugfs_phy,
+							priv, &fops_debug);
+	if (!priv->debug.debugfs_debug)
+		goto err;
+
 	return 0;
 
 err:
@@ -512,6 +559,7 @@ void ath9k_htc_exit_debug(struct ath_hw *ah)
 	debugfs_remove(priv->debug.debugfs_tgt_int_stats);
 	debugfs_remove(priv->debug.debugfs_tgt_tx_stats);
 	debugfs_remove(priv->debug.debugfs_tgt_rx_stats);
+	debugfs_remove(priv->debug.debugfs_debug);
 	debugfs_remove(priv->debug.debugfs_phy);
 }
 
-- 
1.7.4.4

