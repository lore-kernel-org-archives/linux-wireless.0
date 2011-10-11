Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56047 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1JKOcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 10:32:21 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 1/5] ath6kl: Add endpoint_stats debugfs file
Date: Tue, 11 Oct 2011 17:31:53 +0300
Message-ID: <1318343517-15292-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20111011_163225_169553_715FF648)
In-Reply-To: <1318343517-15292-1-git-send-email-jouni@qca.qualcomm.com>
References: <1318343517-15292-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file can be used to fetch endpoint statistics counters and
to clear them by writing 0 to it.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |  102 +++++++++++++++++++++++++++++++
 1 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index ba3f23d..b9bf28d 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -595,6 +595,105 @@ static const struct file_operations fops_credit_dist_stats = {
 	.llseek = default_llseek,
 };
 
+static unsigned int print_endpoint_stat(struct htc_target *target, char *buf,
+					unsigned int buf_len, unsigned int len,
+					int offset, const char *name)
+{
+	int i;
+	struct htc_endpoint_stats *ep_st;
+	u32 *counter;
+
+	len += scnprintf(buf + len, buf_len - len, "%s:", name);
+	for (i = 0; i < ENDPOINT_MAX; i++) {
+		ep_st = &target->endpoint[i].ep_st;
+		counter = ((u32 *) ep_st) + (offset / 4);
+		len += scnprintf(buf + len, buf_len - len, " %u", *counter);
+	}
+	len += scnprintf(buf + len, buf_len - len, "\n");
+
+	return len;
+}
+
+static ssize_t ath6kl_endpoint_stats_read(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	struct htc_target *target = ar->htc_target;
+	char *buf;
+	unsigned int buf_len, len = 0;
+	ssize_t ret_cnt;
+
+	buf_len = 1000 + ENDPOINT_MAX * 100;
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+#define EPSTAT(name)							\
+	len = print_endpoint_stat(target, buf, buf_len, len,		\
+				  offsetof(struct htc_endpoint_stats, name), \
+				  #name)
+	EPSTAT(cred_low_indicate);
+	EPSTAT(tx_issued);
+	EPSTAT(tx_pkt_bundled);
+	EPSTAT(tx_bundles);
+	EPSTAT(tx_dropped);
+	EPSTAT(tx_cred_rpt);
+	EPSTAT(cred_rpt_from_rx);
+	EPSTAT(cred_rpt_ep0);
+	EPSTAT(cred_from_rx);
+	EPSTAT(cred_from_other);
+	EPSTAT(cred_from_ep0);
+	EPSTAT(cred_cosumd);
+	EPSTAT(cred_retnd);
+	EPSTAT(rx_pkts);
+	EPSTAT(rx_lkahds);
+	EPSTAT(rx_bundl);
+	EPSTAT(rx_bundle_lkahd);
+	EPSTAT(rx_bundle_from_hdr);
+	EPSTAT(rx_alloc_thresh_hit);
+	EPSTAT(rxalloc_thresh_byte);
+#undef EPSTAT
+
+	if (len > buf_len)
+		len = buf_len;
+
+	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+	return ret_cnt;
+}
+
+static ssize_t ath6kl_endpoint_stats_write(struct file *file,
+					   const char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	struct htc_target *target = ar->htc_target;
+	int ret, i;
+	u32 val;
+	struct htc_endpoint_stats *ep_st;
+
+	ret = kstrtou32_from_user(user_buf, count, 0, &val);
+	if (ret)
+		return ret;
+	if (val == 0) {
+		for (i = 0; i < ENDPOINT_MAX; i++) {
+			ep_st = &target->endpoint[i].ep_st;
+			memset(ep_st, 0, sizeof(*ep_st));
+		}
+	}
+
+	return count;
+}
+
+static const struct file_operations fops_endpoint_stats = {
+	.open = ath6kl_debugfs_open,
+	.read = ath6kl_endpoint_stats_read,
+	.write = ath6kl_endpoint_stats_write,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static unsigned long ath6kl_get_num_reg(void)
 {
 	int i;
@@ -901,6 +1000,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("credit_dist_stats", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_credit_dist_stats);
 
+	debugfs_create_file("endpoint_stats", S_IRUSR | S_IWUSR,
+			    ar->debugfs_phy, ar, &fops_endpoint_stats);
+
 	debugfs_create_file("fwlog", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_fwlog);
 
-- 
1.7.4.1

