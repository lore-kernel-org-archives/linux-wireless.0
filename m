Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55062 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbeIDLHP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:07:15 -0400
From: akolli@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCHv2 2/4] ath10k: add debugfs entry to enable extended tx stats
Date: Tue,  4 Sep 2018 12:15:14 +0530
Message-Id: <1536043516-12462-3-git-send-email-akolli@codeaurora.org> (sfid-20180904_084336_927884_382B129E)
In-Reply-To: <1536043516-12462-1-git-send-email-akolli@codeaurora.org>
References: <1536043516-12462-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@codeaurora.org>

This patch adds debugfs entry to enable/disable extended
tx statistics. Extended tx statistics are from peer stats
feature.

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
V2:
  - fix kbuild error: 'struct ath10k' has no member named 'debug'

 drivers/net/wireless/ath/ath10k/core.h  |    1 +
 drivers/net/wireless/ath/ath10k/debug.c |   62 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/debug.h |    9 +++++
 3 files changed, 71 insertions(+), 1 deletion(-)

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
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 0afca5c106b6..3a6191cff2f9 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -128,6 +128,10 @@ static inline u32 ath10k_debug_get_fw_dbglog_level(struct ath10k *ar)
 	return ar->debug.fw_dbglog_level;
 }
 
+static inline int ath10k_debug_is_extd_tx_stats_enabled(struct ath10k *ar)
+{
+	return ar->debug.enable_extd_tx_stats;
+}
 #else
 
 static inline int ath10k_debug_start(struct ath10k *ar)
@@ -190,6 +194,11 @@ static inline u32 ath10k_debug_get_fw_dbglog_level(struct ath10k *ar)
 	return 0;
 }
 
+static inline int ath10k_debug_is_extd_tx_stats_enabled(struct ath10k *ar)
+{
+	return 0;
+}
+
 #define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
 
 #define ath10k_debug_get_et_strings NULL
-- 
1.7.9.5
