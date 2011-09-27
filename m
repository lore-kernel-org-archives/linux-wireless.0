Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:40381 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1I0Udh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 16:33:37 -0400
Subject: [PATCH] ath6kl: silence "invalid rate" warning
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Sep 2011 23:33:28 +0300
Message-ID: <20110927203328.20742.30194.stgit@localhost6.localdomain6> (sfid-20110927_223350_991455_30FF9B47)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some reason firmware is sending invalid rates when we try to
query current bitrate from ath6kl_get_station() and a warning is issued:

[ 3810.415720] ath6kl: invalid rate: 1935633515
[ 3811.105493] ath6kl: invalid rate: 1935633515
[ 3811.556063] ath6kl: invalid rate: 1935633515

As the warning happens way too often, convert the warning to a debug
message once we have a proper fix. But to make it easy to follow
how often the problem appears, add a debugfs to print
various statistics about workarounds and make this issue the first WAR.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++
 drivers/net/wireless/ath/ath6kl/core.h     |    4 ++
 drivers/net/wireless/ath/ath6kl/debug.c    |   48 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/debug.h    |    9 +++++
 4 files changed, 64 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c84f53d..8d9fbd4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1365,7 +1365,9 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 		sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
 		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
 	} else {
-		ath6kl_warn("invalid rate: %d\n", rate);
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
+			   "invalid rate from stats: %d\n", rate);
+		ath6kl_debug_war(ar, ATH6KL_WAR_INVALID_RATE);
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 9ecf22b..6d8a484 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -525,6 +525,10 @@ struct ath6kl {
 		unsigned int dbgfs_diag_reg;
 		u32 diag_reg_addr_wr;
 		u32 diag_reg_val_wr;
+
+		struct {
+			unsigned int invalid_rate;
+		} war_stats;
 	} debug;
 #endif /* CONFIG_ATH6KL_DEBUG */
 };
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 4fc83cc..5237369 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -192,6 +192,51 @@ static int ath6kl_debugfs_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+void ath6kl_debug_war(struct ath6kl *ar, enum ath6kl_war war)
+{
+	switch (war) {
+	case ATH6KL_WAR_INVALID_RATE:
+		ar->debug.war_stats.invalid_rate++;
+		break;
+	}
+}
+
+static ssize_t read_file_war_stats(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	char *buf;
+	unsigned int len = 0, buf_len = 1500;
+	ssize_t ret_cnt;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%25s\n",
+			 "Workaround stats");
+	len += scnprintf(buf + len, buf_len - len, "%25s\n\n",
+			 "=================");
+	len += scnprintf(buf + len, buf_len - len, "%20s %10u\n",
+			 "Invalid rates", ar->debug.war_stats.invalid_rate);
+
+	if (WARN_ON(len > buf_len))
+		len = buf_len;
+
+	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	kfree(buf);
+	return ret_cnt;
+}
+
+static const struct file_operations fops_war_stats = {
+	.read = read_file_war_stats,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static void ath6kl_debug_fwlog_add(struct ath6kl *ar, const void *buf,
 				   size_t buf_len)
 {
@@ -873,6 +918,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("reg_write", S_IRUSR | S_IWUSR,
 			    ar->debugfs_phy, ar, &fops_diag_reg_write);
 
+	debugfs_create_file("war_stats", S_IRUSR, ar->debugfs_phy, ar,
+			    &fops_war_stats);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 89bf8e1..91f4bc3 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -52,6 +52,10 @@ extern int ath6kl_printk(const char *level, const char *fmt, ...)
 
 #define AR_DBG_LVL_CHECK(mask)	(debug_mask & mask)
 
+enum ath6kl_war {
+	ATH6KL_WAR_INVALID_RATE,
+};
+
 #ifdef CONFIG_ATH6KL_DEBUG
 #define ath6kl_dbg(mask, fmt, ...)					\
 	({								\
@@ -79,6 +83,7 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
 			   struct ath6kl_irq_enable_reg *irq_en_reg);
 void dump_cred_dist_stats(struct htc_target *target);
 void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len);
+void ath6kl_debug_war(struct ath6kl *ar, enum ath6kl_war war);
 int ath6kl_debug_init(struct ath6kl *ar);
 void ath6kl_debug_cleanup(struct ath6kl *ar);
 
@@ -110,6 +115,10 @@ static inline void ath6kl_debug_fwlog_event(struct ath6kl *ar,
 {
 }
 
+static inline void ath6kl_debug_war(struct ath6kl *ar, enum ath6kl_war war)
+{
+}
+
 static inline int ath6kl_debug_init(struct ath6kl *ar)
 {
 	return 0;

