Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:53622 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbdLVNik (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 08:38:40 -0500
Subject: [PATCH v2 1/6] ath10k: remove deprecated fw_crash_dump debugfs file
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 22 Dec 2017 15:38:29 +0200
Message-ID: <151394990944.9382.5479713630153339961.stgit@potku.adurom.net> (sfid-20171222_143848_618677_ECEBD6D8)
In-Reply-To: <151394982311.9382.1300230032038350642.stgit@potku.adurom.net>
References: <151394982311.9382.1300230032038350642.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fw_crash_dump file was deprecated by commmit 727000e6af34 ("ath10k: support
dev_coredump for crash dump") in v4.11 in favor of dev_coredump interface,
remove it now for good. Everyone should use dev_coredump now.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   46 -------------------------------
 1 file changed, 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 181fd8e2e615..358c34eeb2d2 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -851,49 +851,6 @@ int ath10k_debug_fw_devcoredump(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_fw_crash_dump_open(struct inode *inode, struct file *file)
-{
-	struct ath10k *ar = inode->i_private;
-	struct ath10k_dump_file_data *dump;
-
-	ath10k_warn(ar, "fw_crash_dump debugfs file is deprecated, please use /sys/class/devcoredump instead.");
-
-	dump = ath10k_build_dump_file(ar, true);
-	if (!dump)
-		return -ENODATA;
-
-	file->private_data = dump;
-
-	return 0;
-}
-
-static ssize_t ath10k_fw_crash_dump_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct ath10k_dump_file_data *dump_file = file->private_data;
-
-	return simple_read_from_buffer(user_buf, count, ppos,
-				       dump_file,
-				       le32_to_cpu(dump_file->len));
-}
-
-static int ath10k_fw_crash_dump_release(struct inode *inode,
-					struct file *file)
-{
-	vfree(file->private_data);
-
-	return 0;
-}
-
-static const struct file_operations fops_fw_crash_dump = {
-	.open = ath10k_fw_crash_dump_open,
-	.read = ath10k_fw_crash_dump_read,
-	.release = ath10k_fw_crash_dump_release,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 static ssize_t ath10k_reg_addr_read(struct file *file,
 				    char __user *user_buf,
 				    size_t count, loff_t *ppos)
@@ -2460,9 +2417,6 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("simulate_fw_crash", 0600, ar->debug.debugfs_phy, ar,
 			    &fops_simulate_fw_crash);
 
-	debugfs_create_file("fw_crash_dump", 0400, ar->debug.debugfs_phy, ar,
-			    &fops_fw_crash_dump);
-
 	debugfs_create_file("reg_addr", 0600, ar->debug.debugfs_phy, ar,
 			    &fops_reg_addr);
 
