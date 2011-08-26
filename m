Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41815 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1HZHgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 03:36:55 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH V3 3/3] ath6kl: Add debugfs file entry to dump credit distribution stats
Date: Fri, 26 Aug 2011 13:06:33 +0530
Message-ID: <1314344193-8468-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110826_093657_984453_1E7A3AD7)
In-Reply-To: <1314344193-8468-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1314344193-8468-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It would be at <dbgfs_root>/ieee80211/phyX/ath6kl/credit_dist_stats.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   69 +++++++++++++++++++++++++++++++
 1 files changed, 69 insertions(+), 0 deletions(-)

V3 - Define macros for magic numbers which are used as length
   - Add total available and free credits stats
   - Define and use a macro to print credit stats

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 5a082c0..1cc23c1 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -290,6 +290,72 @@ static const struct file_operations fops_tgt_stats = {
 	.llseek = default_llseek,
 };
 
+#define print_credit_info(fmt_str, ep_list_field)		\
+	(len += scnprintf(buf + len, buf_len - len, fmt_str,	\
+			 ep_list->ep_list_field))
+#define CREDIT_INFO_DISPLAY_STRING_LEN	200
+#define CREDIT_INFO_LEN	128
+
+static ssize_t read_file_credit_dist_stats(struct file *file,
+					   char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	struct htc_target *target = ar->htc_target;
+	struct htc_endpoint_credit_dist *ep_list;
+	char *buf;
+	unsigned int buf_len, len = 0;
+	ssize_t ret_cnt;
+
+	buf_len = CREDIT_INFO_DISPLAY_STRING_LEN +
+		  get_queue_depth(&target->cred_dist_list) * CREDIT_INFO_LEN;
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len += scnprintf(buf + len, buf_len - len, "%25s%5d\n",
+			 "Total Avail Credits: ",
+			 target->cred_dist_cntxt->total_avail_credits);
+	len += scnprintf(buf + len, buf_len - len, "%25s%5d\n",
+			 "Free credits :",
+			 target->cred_dist_cntxt->cur_free_credits);
+
+	len += scnprintf(buf + len, buf_len - len,
+			 " Epid  Flags    Cred_norm  Cred_min  Credits  Cred_assngd"
+			 "  Seek_cred  Cred_sz  Cred_per_msg  Cred_to_dist"
+			 "  qdepth\n");
+
+	list_for_each_entry(ep_list, &target->cred_dist_list, list) {
+		print_credit_info("  %2d", endpoint);
+		print_credit_info("%10x", dist_flags);
+		print_credit_info("%8d", cred_norm);
+		print_credit_info("%9d", cred_min);
+		print_credit_info("%9d", credits);
+		print_credit_info("%10d", cred_assngd);
+		print_credit_info("%13d", seek_cred);
+		print_credit_info("%12d", cred_sz);
+		print_credit_info("%9d", cred_per_msg);
+		print_credit_info("%14d", cred_to_dist);
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
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debugfs_phy = debugfs_create_dir("ath6kl",
@@ -300,6 +366,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
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

