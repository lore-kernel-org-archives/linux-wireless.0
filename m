Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44784 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeHFPVw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 11:21:52 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath10k: add debugfs entry to enable extended tx stats
Date: Mon,  6 Aug 2018 18:43:41 +0530
Message-Id: <1533561223-342-3-git-send-email-akolli@codeaurora.org> (sfid-20180806_151252_012519_064EC416)
In-Reply-To: <1533561223-342-1-git-send-email-akolli@codeaurora.org>
References: <1533561223-342-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds debugfs entry to enable/disable extended
tx statistics. Extended tx statistics are from peer stats
feature.

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h  |    1 +
 drivers/net/wireless/ath/ath10k/debug.c |   62 ++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9feea02e7d37..b5f6940bb102 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -607,6 +607,7 @@ struct ath10k_debug {
 	u32 reg_addr;
 	u32 nf_cal_period;
 	void *cal_data;
+	u32 enable_extd_tx_stats;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 0baaad90b8d1..ada29a4cc9c8 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2042,6 +2042,61 @@ static ssize_t ath10k_read_btcoex(struct file *file, char __user *ubuf,
 	.open = simple_open
 };
 
+static ssize_t ath10k_write_enable_extd_tx_stats(struct file *file,
+						 const char __user *ubuf,
+						 size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u32 filter;
+	int ret;
+
+	if (kstrtouint_from_user(ubuf, count, 0, &filter))
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_ON) {
+		ar->debug.enable_extd_tx_stats = filter;
+		ret = count;
+		goto out;
+	}
+
+	if (filter == ar->debug.enable_extd_tx_stats) {
+		ret = count;
+		goto out;
+	}
+
+	ar->debug.enable_extd_tx_stats = filter;
+	ret = count;
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static ssize_t ath10k_read_enable_extd_tx_stats(struct file *file,
+						char __user *ubuf,
+						size_t count, loff_t *ppos)
+
+{
+	char buf[32];
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf, sizeof(buf) - len, "%08x\n",
+			ar->debug.enable_extd_tx_stats);
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_enable_extd_tx_stats = {
+	.read = ath10k_read_enable_extd_tx_stats,
+	.write = ath10k_write_enable_extd_tx_stats,
+	.open = simple_open
+};
+
 static ssize_t ath10k_write_peer_stats(struct file *file,
 				       const char __user *ubuf,
 				       size_t count, loff_t *ppos)
@@ -2454,10 +2509,15 @@ int ath10k_debug_register(struct ath10k *ar)
 		debugfs_create_file("btcoex", 0644, ar->debug.debugfs_phy, ar,
 				    &fops_btcoex);
 
-	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map))
+	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
 		debugfs_create_file("peer_stats", 0644, ar->debug.debugfs_phy, ar,
 				    &fops_peer_stats);
 
+		debugfs_create_file("enable_extd_tx_stats", 0644,
+				    ar->debug.debugfs_phy, ar,
+				    &fops_enable_extd_tx_stats);
+	}
+
 	debugfs_create_file("fw_checksums", 0400, ar->debug.debugfs_phy, ar,
 			    &fops_fw_checksums);
 
-- 
1.7.9.5
