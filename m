Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43216 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaLSG4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 01:56:45 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 5/8] ath10k: Implement sta_add_debugfs
Date: Fri, 19 Dec 2014 12:24:56 +0530
Message-ID: <1418972099-5296-6-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141219_075648_055212_2FB6023A)
In-Reply-To: <1418972099-5296-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1418972099-5296-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add per station debugfs files when a station is added to mac80211's
station list. This helps to group peer specific debugfs entries
altogether. Right now this callback adds support to test aggregation
procedures (addba/addba_resp/delba) manually.

To enable automatic aggregation in target,
echo 0 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
	stations/XX:XX:XX:XX:XX:XX/aggr_mode

For manual mode,
echo 1 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
	stations/XX:XX:XX:XX:XX:XX/aggr_mode

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/Makefile      |  1 +
 drivers/net/wireless/ath/ath10k/core.h        |  5 ++
 drivers/net/wireless/ath/ath10k/debug.h       | 11 +++-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 89 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c         |  3 +
 5 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/debugfs_sta.c

diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index ffa3b1a..6c0c23e 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -15,6 +15,7 @@ ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
 ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
 ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
 ath10k_core-$(CONFIG_THERMAL) += thermal.o
+ath10k_core-$(CONFIG_MAC80211_DEBUGFS) += debugfs_sta.o
 
 obj-$(CONFIG_ATH10K_PCI) += ath10k_pci.o
 ath10k_pci-y += pci.o \
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b7ba7cf..0ae2253 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -239,6 +239,11 @@ struct ath10k_sta {
 	u32 smps;
 
 	struct work_struct update_wk;
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	/* protected by conf_mutex */
+	bool aggr_mode;
+#endif
 };
 
 #define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5*HZ)
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 1b87a5d..a12b832 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -48,6 +48,12 @@ enum ath10k_pktlog_filter {
 	ATH10K_PKTLOG_ANY        = 0x00000001f,
 };
 
+enum ath10k_dbg_aggr_mode {
+	ATH10K_DBG_AGGR_MODE_AUTO,
+	ATH10K_DBG_AGGR_MODE_MANUAL,
+	ATH10K_DBG_AGGR_MODE_MAX,
+};
+
 extern unsigned int ath10k_debug_mask;
 
 __printf(2, 3) void ath10k_info(struct ath10k *ar, const char *fmt, ...);
@@ -77,7 +83,6 @@ int ath10k_debug_get_et_sset_count(struct ieee80211_hw *hw,
 void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ethtool_stats *stats, u64 *data);
-
 #else
 static inline int ath10k_debug_start(struct ath10k *ar)
 {
@@ -129,6 +134,10 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 #define ath10k_debug_get_et_stats NULL
 
 #endif /* CONFIG_ATH10K_DEBUGFS */
+#ifdef CONFIG_MAC80211_DEBUGFS
+void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta, struct dentry *dir);
+#endif /* CONFIG_MAC80211_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
 __printf(3, 4) void ath10k_dbg(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
new file mode 100644
index 0000000..d5fca70
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -0,0 +1,89 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/utsname.h>
+
+#include "core.h"
+#include "wmi-ops.h"
+#include "debug.h"
+
+static ssize_t ath10k_dbg_sta_read_aggr_mode(struct file *file,
+					     char __user *user_buf,
+					     size_t count, loff_t *ppos)
+{
+	struct ieee80211_sta *sta = file->private_data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arsta->arvif->ar;
+	char buf[32];
+	int len = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf, sizeof(buf) - len, "aggregation mode: %s\n",
+			(arsta->aggr_mode == ATH10K_DBG_AGGR_MODE_AUTO) ?
+			"auto" : "manual");
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_dbg_sta_write_aggr_mode(struct file *file,
+					      const char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	struct ieee80211_sta *sta = file->private_data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arsta->arvif->ar;
+	u32 aggr_mode;
+	int ret;
+
+	if (kstrtouint_from_user(user_buf, count, 0, &aggr_mode))
+		return -EINVAL;
+
+	if (aggr_mode >= ATH10K_DBG_AGGR_MODE_MAX)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+	if ((ar->state != ATH10K_STATE_ON) ||
+	    (aggr_mode == arsta->aggr_mode)) {
+		ret = count;
+		goto out;
+	}
+
+	ret = ath10k_wmi_addba_clear_resp(ar, arsta->arvif->vdev_id, sta->addr);
+	if (ret) {
+		ath10k_warn(ar, "failed to clear addba session ret: %d\n", ret);
+		goto out;
+	}
+
+	arsta->aggr_mode = aggr_mode;
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static const struct file_operations fops_aggr_mode = {
+	.read = ath10k_dbg_sta_read_aggr_mode,
+	.write = ath10k_dbg_sta_write_aggr_mode,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta, struct dentry *dir)
+{
+	debugfs_create_file("aggr_mode", S_IRUGO | S_IWUSR, dir, sta,
+			    &fops_aggr_mode);
+}
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5475f0f..2b6f272 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4678,6 +4678,9 @@ static const struct ieee80211_ops ath10k_ops = {
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
 #endif
+#ifdef CONFIG_MAC80211_DEBUGFS
+	.sta_add_debugfs		= ath10k_sta_add_debugfs,
+#endif
 };
 
 #define RATETAB_ENT(_rate, _rateid, _flags) { \
-- 
2.2.0

