Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:40259 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2BFGXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 01:23:46 -0500
Subject: [PATCH 2/2] ath6kl: add blocking debugfs file for retrieving firmware
	logs
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Mon, 06 Feb 2012 08:23:40 +0200
Message-ID: <20120206062340.20231.55630.stgit@localhost6.localdomain6> (sfid-20120206_072349_386776_9B0E85F3)
In-Reply-To: <20120206062327.20231.11602.stgit@localhost6.localdomain6>
References: <20120206062327.20231.11602.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When debugging firmware issues it's not always enough to get
the latest firmware logs, sometimes we need to get logs from a longer
period. To make this possible, add a debugfs file named fwlog_block. When
reading from this file ath6kl will send firmware logs whenever available
and otherwise it will block and wait for new logs.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    3 +
 drivers/net/wireless/ath/ath6kl/debug.c |  104 +++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 9a58214..4ff06a3 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -653,6 +653,9 @@ struct ath6kl {
 #ifdef CONFIG_ATH6KL_DEBUG
 	struct {
 		struct sk_buff_head fwlog_queue;
+		struct completion fwlog_completion;
+		bool fwlog_open;
+
 		u32 fwlog_mask;
 
 		unsigned int dbgfs_diag_reg;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 9b25cbd..7f94eda 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -290,6 +290,7 @@ void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len)
 	spin_lock(&ar->debug.fwlog_queue.lock);
 
 	__skb_queue_tail(&ar->debug.fwlog_queue, skb);
+	complete(&ar->debug.fwlog_completion);
 
 	/* drop oldest entries */
 	while (skb_queue_len(&ar->debug.fwlog_queue) >
@@ -303,6 +304,28 @@ void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len)
 	return;
 }
 
+static int ath6kl_fwlog_open(struct inode *inode, struct file *file)
+{
+	struct ath6kl *ar = inode->i_private;
+
+	if (ar->debug.fwlog_open)
+		return -EBUSY;
+
+	ar->debug.fwlog_open = true;
+
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static int ath6kl_fwlog_release(struct inode *inode, struct file *file)
+{
+	struct ath6kl *ar = inode->i_private;
+
+	ar->debug.fwlog_open = false;
+
+	return 0;
+}
+
 static ssize_t ath6kl_fwlog_read(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
@@ -347,12 +370,87 @@ static ssize_t ath6kl_fwlog_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations fops_fwlog = {
-	.open = ath6kl_debugfs_open,
+	.open = ath6kl_fwlog_open,
+	.release = ath6kl_fwlog_release,
 	.read = ath6kl_fwlog_read,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_fwlog_block_read(struct file *file,
+				       char __user *user_buf,
+				       size_t count,
+				       loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	struct sk_buff *skb;
+	ssize_t ret_cnt;
+	size_t len = 0, not_copied;
+	char *buf;
+	int ret;
+
+	buf = vmalloc(count);
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock(&ar->debug.fwlog_queue.lock);
+
+	if (skb_queue_len(&ar->debug.fwlog_queue) == 0) {
+		/* we must init under queue lock */
+		init_completion(&ar->debug.fwlog_completion);
+
+		spin_unlock(&ar->debug.fwlog_queue.lock);
+
+		ret = wait_for_completion_interruptible(
+			&ar->debug.fwlog_completion);
+		if (ret == -ERESTARTSYS)
+			return ret;
+
+		spin_lock(&ar->debug.fwlog_queue.lock);
+	}
+
+	while ((skb = __skb_dequeue(&ar->debug.fwlog_queue))) {
+		if (skb->len > count - len) {
+			/* not enough space, put skb back and leave */
+			__skb_queue_head(&ar->debug.fwlog_queue, skb);
+			break;
+		}
+
+
+		memcpy(buf + len, skb->data, skb->len);
+		len += skb->len;
+
+		kfree_skb(skb);
+	}
+
+	spin_unlock(&ar->debug.fwlog_queue.lock);
+
+	/* FIXME: what to do if len == 0? */
+
+	not_copied = copy_to_user(user_buf, buf, len);
+	if (not_copied != 0) {
+		ret_cnt = -EFAULT;
+		goto out;
+	}
+
+	*ppos = *ppos + len;
+
+	ret_cnt = len;
+
+out:
+	vfree(buf);
+
+	return ret_cnt;
+}
+
+static const struct file_operations fops_fwlog_block = {
+	.open = ath6kl_fwlog_open,
+	.release = ath6kl_fwlog_release,
+	.read = ath6kl_fwlog_block_read,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t ath6kl_fwlog_mask_read(struct file *file, char __user *user_buf,
 				      size_t count, loff_t *ppos)
 {
@@ -1621,6 +1719,7 @@ static const struct file_operations fops_power_params = {
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	skb_queue_head_init(&ar->debug.fwlog_queue);
+	init_completion(&ar->debug.fwlog_completion);
 
 	/*
 	 * Actually we are lying here but don't know how to read the mask
@@ -1645,6 +1744,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("fwlog", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_fwlog);
 
+	debugfs_create_file("fwlog_block", S_IRUSR, ar->debugfs_phy, ar,
+			    &fops_fwlog_block);
+
 	debugfs_create_file("fwlog_mask", S_IRUSR | S_IWUSR, ar->debugfs_phy,
 			    ar, &fops_fwlog_mask);
 

