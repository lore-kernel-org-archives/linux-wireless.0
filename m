Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35003 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752923AbdEJQ0R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 12:26:17 -0400
Received: by mail-pf0-f196.google.com with SMTP id u26so69298pfd.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 May 2017 09:26:16 -0700 (PDT)
From: Adrian Chadd <adrian@freebsd.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc: Adrian Chadd <adrian@freebsd.org>,
        Adrian Chadd <adrian@FreeBSD.org>
Subject: [PATCH] ath10k: add configurable debugging.
Date: Wed, 10 May 2017 09:25:46 -0700
Message-Id: <20170510162546.15439-1-adrian@freebsd.org> (sfid-20170510_182621_070686_38D3D65D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a few configurable debugging options:

* driver debugging and tracing is now configurable per device
* driver debugging and tracing is now configurable at runtime
* the debugging / tracing is not run at all (besides a mask check)
  unless the specific debugging bitmap field is configured.

Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>
---
 drivers/net/wireless/ath/ath10k/core.c  |   2 +
 drivers/net/wireless/ath/ath10k/core.h  |   2 +
 drivers/net/wireless/ath/ath10k/debug.c | 101 ++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/debug.h |  44 +++++++++-----
 4 files changed, 125 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index eea111d704c5..fcb068cb0248 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2444,6 +2444,8 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	ar->hw_rev = hw_rev;
 	ar->hif.ops = hif_ops;
 	ar->hif.bus = bus;
+	ar->debug_mask = ath10k_debug_mask;
+	ar->trace_debug_mask = ath10k_debug_mask;
 
 	switch (hw_rev) {
 	case ATH10K_HW_QCA988X:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8fc08a5043db..07e392a377d0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -762,6 +762,8 @@ struct ath10k {
 	struct device *dev;
 	u8 mac_addr[ETH_ALEN];
 
+	u32 debug_mask;
+	u32 trace_debug_mask;
 	enum ath10k_hw_rev hw_rev;
 	u16 dev_id;
 	u32 chip_id;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 389fcb7a9fd0..017360a26b40 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2418,6 +2418,79 @@ int ath10k_debug_create(struct ath10k *ar)
 	return 0;
 }
 
+#ifdef	CONFIG_ATH10K_DEBUGFS
+static ssize_t ath10k_write_debug_mask(struct file *file,
+				       const char __user *ubuf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	int ret;
+	u32 val;
+
+        if (kstrtou32_from_user(ubuf, count, 0, &val))
+                return -EINVAL;
+
+	ar->debug_mask = val;
+	ret = count;
+
+	return ret;
+}
+
+static ssize_t ath10k_read_debug_mask(struct file *file, char __user *ubuf,
+				      size_t count, loff_t *ppos)
+{
+	char buf[32];
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+
+	len = scnprintf(buf, sizeof(buf) - len, "0x%x\n", ar->debug_mask);
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_debug_mask = {
+	.read = ath10k_read_debug_mask,
+	.write = ath10k_write_debug_mask,
+	.open = simple_open
+};
+
+static ssize_t ath10k_write_trace_debug_mask(struct file *file,
+					     const char __user *ubuf,
+					     size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	int ret;
+	u32 val;
+
+        if (kstrtou32_from_user(ubuf, count, 0, &val))
+                return -EINVAL;
+
+	ar->trace_debug_mask = val;
+	ret = count;
+
+	return ret;
+}
+
+static ssize_t ath10k_read_trace_debug_mask(struct file *file,
+					    char __user *ubuf,
+					    size_t count, loff_t *ppos)
+{
+	char buf[32];
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+
+	len = scnprintf(buf, sizeof(buf) - len, "0x%x\n",
+			ar->trace_debug_mask);
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_trace_debug_mask = {
+	.read = ath10k_read_trace_debug_mask,
+	.write = ath10k_write_trace_debug_mask,
+	.open = simple_open
+};
+#endif	/* CONFIG_ATH10K_DEBUGFS */
+
+
 void ath10k_debug_destroy(struct ath10k *ar)
 {
 	vfree(ar->debug.fw_crash_data);
@@ -2448,6 +2521,13 @@ int ath10k_debug_register(struct ath10k *ar)
 	init_completion(&ar->debug.tpc_complete);
 	init_completion(&ar->debug.fw_stats_complete);
 
+#ifdef	CONFIG_ATH10K_DEBUG
+	debugfs_create_file("debug", S_IRUSR, ar->debug.debugfs_phy, ar,
+			    &fops_debug_mask);
+	debugfs_create_file("trace_debug", S_IRUSR, ar->debug.debugfs_phy, ar,
+			    &fops_trace_debug_mask);
+#endif
+
 	debugfs_create_file("fw_stats", 0400, ar->debug.debugfs_phy, ar,
 			    &fops_fw_stats);
 
@@ -2536,7 +2616,7 @@ void ath10k_debug_unregister(struct ath10k *ar)
 #endif /* CONFIG_ATH10K_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
-void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
+void _ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
 		const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -2547,16 +2627,16 @@ void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	if (ath10k_debug_mask & mask)
+	if (ar->debug_mask & mask)
 		dev_printk(KERN_DEBUG, ar->dev, "%pV", &vaf);
-
-	trace_ath10k_log_dbg(ar, mask, &vaf);
+	if (ar->trace_debug_mask & mask)
+		trace_ath10k_log_dbg(ar, mask, &vaf);
 
 	va_end(args);
 }
-EXPORT_SYMBOL(ath10k_dbg);
+EXPORT_SYMBOL(_ath10k_dbg);
 
-void ath10k_dbg_dump(struct ath10k *ar,
+void _ath10k_dbg_dump(struct ath10k *ar,
 		     enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len)
@@ -2565,7 +2645,7 @@ void ath10k_dbg_dump(struct ath10k *ar,
 	size_t linebuflen;
 	const void *ptr;
 
-	if (ath10k_debug_mask & mask) {
+	if (ar->debug_mask & mask) {
 		if (msg)
 			ath10k_dbg(ar, mask, "%s\n", msg);
 
@@ -2584,9 +2664,10 @@ void ath10k_dbg_dump(struct ath10k *ar,
 	}
 
 	/* tracing code doesn't like null strings :/ */
-	trace_ath10k_log_dbg_dump(ar, msg ? msg : "", prefix ? prefix : "",
-				  buf, len);
+	if (ar->trace_debug_mask & mask)
+		trace_ath10k_log_dbg_dump(ar, msg ? msg : "", prefix ? prefix : "",
+					  buf, len);
 }
-EXPORT_SYMBOL(ath10k_dbg_dump);
+EXPORT_SYMBOL(_ath10k_dbg_dump);
 
 #endif /* CONFIG_ATH10K_DEBUG */
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 257d10985c6e..7bd461927029 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -200,27 +200,43 @@ void ath10k_sta_update_rx_duration(struct ath10k *ar,
 #endif /* CONFIG_MAC80211_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
-__printf(3, 4) void ath10k_dbg(struct ath10k *ar,
+static inline int
+_ath10k_do_dbg(struct ath10k *ar, enum ath10k_debug_mask mask)
+{
+	if (ar->trace_debug_mask & mask)
+		return (1);
+	if (ar->debug_mask & mask)
+		return (1);
+	return (0);
+}
+
+void _ath10k_dbg(struct ath10k *ar,
 			       enum ath10k_debug_mask mask,
 			       const char *fmt, ...);
-void ath10k_dbg_dump(struct ath10k *ar,
+
+void _ath10k_dbg_dump(struct ath10k *ar,
 		     enum ath10k_debug_mask mask,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len);
+
+#define	ath10k_dbg(ar, mask, ...)					\
+	do {								\
+		if (_ath10k_do_dbg(ar, mask)) {				\
+			_ath10k_dbg((ar), (mask), __VA_ARGS__);		\
+		};							\
+	} while (0)
+
+#define	ath10k_dbg_dump(ar, mask, msg, pfx, buf, len)			\
+	do {								\
+		if (_ath10k_do_dbg(ar, mask)) {				\
+			_ath10k_dbg_dump((ar), (mask), (msg), (pfx), (buf), (len)); \
+		};							\
+	} while (0)
+
 #else /* CONFIG_ATH10K_DEBUG */
 
-static inline int ath10k_dbg(struct ath10k *ar,
-			     enum ath10k_debug_mask dbg_mask,
-			     const char *fmt, ...)
-{
-	return 0;
-}
+#define	ath10k_dbg(ar, mask, fmt, ...)
+#define	ath10k_dbg_dump(ar, mask, msg, pfx, buf, len)
 
-static inline void ath10k_dbg_dump(struct ath10k *ar,
-				   enum ath10k_debug_mask mask,
-				   const char *msg, const char *prefix,
-				   const void *buf, size_t len)
-{
-}
 #endif /* CONFIG_ATH10K_DEBUG */
 #endif /* _DEBUG_H_ */
-- 
2.12.1
