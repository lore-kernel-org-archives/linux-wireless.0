Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64211 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1HXOZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:25:41 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH 3/3] ath6kl: Add debugfs file entry to dump credit distribution stats
Date: Wed, 24 Aug 2011 19:55:36 +0530
Message-ID: <1314195936-25227-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110824_162544_533985_073BA4FA)
In-Reply-To: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   65 +++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 014cc18..a729793 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -293,6 +293,68 @@ static const struct file_operations fops_tgt_stats = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_credit_dist_stats(struct file *file,
+					   char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	struct htc_target *target = ar->htc_target;
+	struct htc_endpoint_credit_dist *ep_list;
+	char *buf;
+	unsigned int buf_len = 128, len = 0;
+	ssize_t ret_cnt;
+
+	buf_len += get_queue_depth(&target->cred_dist_list) * 128;
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len += scnprintf(buf + len, buf_len - len,
+			 " Epid  Flags    Cred_norm  Cred_min  Credits  Cred_assngd"
+			 "  Seek_cred  Cred_sz  Cred_per_msg  Cred_to_dist"
+			 "  qdepth\n");
+
+	list_for_each_entry(ep_list, &target->cred_dist_list, list) {
+		len += scnprintf(buf + len, buf_len - len, "  %2d",
+				 ep_list->endpoint);
+		len += scnprintf(buf + len, buf_len - len, "%10x",
+				 ep_list->dist_flags);
+		len += scnprintf(buf + len, buf_len - len, "%8d",
+				 ep_list->cred_norm);
+		len += scnprintf(buf + len, buf_len - len, "%9d",
+				 ep_list->cred_min);
+		len += scnprintf(buf + len, buf_len - len, "%9d",
+				 ep_list->credits);
+		len += scnprintf(buf + len, buf_len - len, "%10d",
+				 ep_list->cred_assngd);
+		len += scnprintf(buf + len, buf_len - len, "%13d",
+				 ep_list->seek_cred);
+		len += scnprintf(buf + len, buf_len - len, "%12d",
+				 ep_list->cred_sz);
+		len += scnprintf(buf + len, buf_len - len, "%9d",
+				 ep_list->cred_per_msg);
+		len += scnprintf(buf + len, buf_len - len, "%14d",
+				 ep_list->cred_to_dist);
+		len += scnprintf(buf + len, buf_len - len, "%12d\n",
+				 get_queue_depth(&((struct htc_endpoint *)
+						 ep_list->htc_rsvd)->txq));
+	}
+
+	if (len > buf_len)
+		len = buf_len;
+
+	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+	return ret_cnt;
+}
+
+static const struct file_operations fops_credit_dist_stats = {
+	.read = read_file_credit_dist_stats,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_init_debugfs(struct ath6kl *ar)
 {
 	ar->debugfs_phy = debugfs_create_dir("ath6kl",
@@ -303,6 +365,9 @@ int ath6kl_init_debugfs(struct ath6kl *ar)
 	debugfs_create_file("tgt_stats", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_tgt_stats);
 
+	debugfs_create_file("credit_dist_stats", S_IRUSR, ar->debugfs_phy, ar,
+			    &fops_credit_dist_stats);
+
 	return 0;
 }
 #endif
-- 
1.7.0.4

