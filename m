Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1IBNqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 09:46:31 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath6kl: Add debugfs support to write a chip register
Date: Fri, 2 Sep 2011 19:16:13 +0530
Message-ID: <1314971173-8966-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110902_154634_884643_D3DC9B12)
In-Reply-To: <1314971173-8966-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1314971173-8966-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To write a value to register:
echo <register_offset>=<register_value> > <degfs_root>/ieee80211/phyX/ath6kl/register_write

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    2 +
 drivers/net/wireless/ath/ath6kl/debug.c |   66 +++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ae2f591..fdb796f 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -478,6 +478,8 @@ struct ath6kl {
 		void *fwlog_tmp;
 		u32 fwlog_mask;
 		unsigned int dbgfs_diag_reg;
+		u32 diag_reg_addr_wr;
+		u32 diag_reg_val_wr;
 	} debug;
 #endif /* CONFIG_ATH6KL_DEBUG */
 };
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 8bc4753..a121c2b 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -759,6 +759,68 @@ static const struct file_operations fops_lrssi_roam_threshold = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_regwrite_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	u8 buf[32];
+	unsigned int len = 0;
+
+	len = scnprintf(buf, sizeof(buf), "Addr: 0x%x Val: 0x%x\n",
+			ar->debug.diag_reg_addr_wr, ar->debug.diag_reg_val_wr);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath6kl_regwrite_write(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	char buf[32];
+	char *sptr, *token;
+	unsigned int len = 0;
+	u32 reg_addr, reg_val;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	sptr = buf;
+
+	token = strsep(&sptr, "=");
+	if (!token)
+		return -EINVAL;
+
+	if (kstrtou32(token, 0, &reg_addr))
+		return -EINVAL;
+
+	if (!ath6kl_dbg_is_diag_reg_valid(reg_addr))
+		return -EINVAL;
+
+	if (kstrtou32(sptr, 0, &reg_val))
+		return -EINVAL;
+
+	ar->debug.diag_reg_addr_wr = reg_addr;
+	ar->debug.diag_reg_val_wr = reg_val;
+
+	if (ath6kl_diag_write32(ar, ar->debug.diag_reg_addr_wr,
+				cpu_to_le32(ar->debug.diag_reg_val_wr)))
+		return -EIO;
+
+	return count;
+}
+
+static const struct file_operations fops_diag_reg_write = {
+	.read = ath6kl_regwrite_read,
+	.write = ath6kl_regwrite_write,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
@@ -807,6 +869,10 @@ int ath6kl_debug_init(struct ath6kl *ar)
 
 	debugfs_create_file("lrssi_roam_threshold", S_IRUSR | S_IWUSR,
 			    ar->debugfs_phy, ar, &fops_lrssi_roam_threshold);
+
+	debugfs_create_file("register_write", S_IRUSR | S_IWUSR,
+			    ar->debugfs_phy, ar, &fops_diag_reg_write);
+
 	return 0;
 }
 
-- 
1.7.0.4

