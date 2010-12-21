Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:38943 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab0LUPYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 10:24:18 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id BFFC6664002
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:16 +0100 (CET)
Received: from mail.neratec.ch ([127.0.0.1])
	by localhost (mail.neratec.ch [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KQ3OHRggtn1E for <linux-wireless@vger.kernel.org>;
	Tue, 21 Dec 2010 16:15:14 +0100 (CET)
Received: from mail.neratec.ch (mail.neratec.ch [192.168.11.23])
	by mail.neratec.ch (Postfix) with ESMTP id 57C5E860D0
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:14 +0100 (CET)
Date: Tue, 21 Dec 2010 16:15:14 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Message-ID: <1217548108.11110.1292944514307.JavaMail.root@idefix>
In-Reply-To: <1644423113.11100.1292944104872.JavaMail.root@idefix>
Subject: [PATCH 2/4] DFS: simple pattern detector
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Provides a very basic pattern detector to test the proposed design.

Implements detection for ETSI 1.5.1 single PRI radar test signals. It is
usable only for off-channel-scans, i.e. does not tolerate false pulses.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 net/wireless/Makefile   |    9 +
 net/wireless/core.c     |   47 ++
 .../net/wireless/dfs/dfs_common.h                  |   20 +
 .../net/wireless/dfs/dfs_debug.c                   |   16 +
 .../net/wireless/dfs/dfs_debug.h                   |  107 ++++
 .../net/wireless/dfs/dfs_debugfs.c                 |  301 +++++++++++
 .../net/wireless/dfs/dfs_debugfs.h                 |    9 +
 .../net/wireless/dfs/dfs_handler.c                 |   94 ++++
 .../net/wireless/dfs/dfs_pattern_detector.c        |  559 ++++++++++++++++++++
 .../net/wireless/dfs/dfs_pattern_detector.h        |   46 ++
 .../net/wireless/dfs/dfs_radar_types.h             |   47 ++
 11 files changed, 1255 insertions(+), 0 deletions(-)
 create mode 100644 net/wireless/dfs/dfs_common.h
 create mode 100644 net/wireless/dfs/dfs_debug.c
 create mode 100644 net/wireless/dfs/dfs_debug.h
 create mode 100644 net/wireless/dfs/dfs_debugfs.c
 create mode 100644 net/wireless/dfs/dfs_debugfs.h
 create mode 100644 net/wireless/dfs/dfs_handler.c
 create mode 100644 net/wireless/dfs/dfs_pattern_detector.c
 create mode 100644 net/wireless/dfs/dfs_pattern_detector.h
 create mode 100644 net/wireless/dfs/dfs_radar_types.h

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 37d70ce..3d6207f 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -10,6 +10,15 @@ cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
 
+# DFS detector, to be made configurable
+
+cfg80211-y += \
+	dfs/dfs_pattern_detector.o \
+	dfs/dfs_handler.o \
+	dfs/dfs_debug.o \
+	dfs/dfs_debugfs.o
+
+
 ccflags-y += -D__CHECK_ENDIAN__
 
 $(obj)/regdb.c: $(src)/db.txt $(src)/genregdb.awk
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 79febd2..25cb99b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -28,6 +28,14 @@
 #include "wext-compat.h"
 #include "ethtool.h"
 
+/*
+ * DFS handler
+ *
+ * for this proof-of-concept let's have a global instance of the handler
+ */
+#include "net/dfs.h"
+static struct dfs_handler *cfg80211_dfs_handler;
+
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
 
@@ -886,6 +894,33 @@ static struct pernet_operations cfg80211_pernet_ops = {
 };
 #endif
 
+
+
+/**
+ * DFS
+ */
+
+void ieee80211_add_radar_pulse(u16 freq, u64 ts, u8 rssi, u8 width)
+{
+	if (cfg80211_dfs_handler != NULL) {
+		struct pulse_event event;
+		event.width = width;
+		event.ts = ts;
+		event.rssi = rssi;
+		event.freq = freq;
+		cfg80211_dfs_handler->add_pulse(cfg80211_dfs_handler, &event);
+	}
+}
+EXPORT_SYMBOL(ieee80211_add_radar_pulse);
+
+void ieee80211_radar_detected(u16 freq)
+{
+	printk(KERN_INFO "Radar detected at freq=%d\n", freq);
+	/* TODO: whatever needs to be done after radar detection */
+}
+EXPORT_SYMBOL(ieee80211_radar_detected);
+
+
 static int __init cfg80211_init(void)
 {
 	int err;
@@ -918,6 +953,14 @@ static int __init cfg80211_init(void)
 	if (!cfg80211_wq)
 		goto out_fail_wq;
 
+	/**
+	 * DFS handler initialization
+	 *
+	 * TODO: set the real domain given by countrycode
+	 */
+	cfg80211_dfs_handler = dfs_handler_init(DFS_ETSI_DOMAIN);
+
+
 	return 0;
 
 out_fail_wq:
@@ -939,6 +982,10 @@ subsys_initcall(cfg80211_init);
 
 static void __exit cfg80211_exit(void)
 {
+	/* release DFS handler */
+	if (cfg80211_dfs_handler != NULL)
+		cfg80211_dfs_handler->exit(cfg80211_dfs_handler);
+
 	debugfs_remove(ieee80211_debugfs_dir);
 	nl80211_exit();
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
diff --git a/net/wireless/dfs/dfs_common.h b/net/wireless/dfs/dfs_common.h
new file mode 100644
index 0000000..9b71efd
--- /dev/null
+++ b/net/wireless/dfs/dfs_common.h
@@ -0,0 +1,20 @@
+#ifndef DFS_COMMON_H
+#define DFS_COMMON_H
+
+#include "net/dfs.h"
+
+
+/**
+ * struct dfs_data - DFS handler private data
+ *
+ * @dfs_handler: instance back-reference
+ * @dfs_domain: DFS domain the handler is currently working
+ * @pattern_detector: instance reference to pattern detector
+ */
+struct dfs_data {
+	struct dfs_handler *dfs_handler;
+	enum dfs_domain dfs_domain;
+	struct dfs_pattern_detector *pattern_detector;
+};
+
+#endif  /* DFS_COMMON_H */
diff --git a/net/wireless/dfs/dfs_debug.c b/net/wireless/dfs/dfs_debug.c
new file mode 100644
index 0000000..ba756de
--- /dev/null
+++ b/net/wireless/dfs/dfs_debug.c
@@ -0,0 +1,16 @@
+#include "dfs_debug.h"
+
+#define USE_FULL_DEBUG	0
+
+u32 dfs_debug_level = 0
+	| DFS_DEBUG_ERROR
+	| DFS_DEBUG_WARN
+	| DFS_DEBUG_INFO
+#if USE_FULL_DEBUG
+	| DFS_DEBUG_TRACE
+	| DFS_DEBUG_LOG
+#endif
+;
+
+char dbg_buff[MAX_DEBUG_SPRINTF + 1] = {0};
+
diff --git a/net/wireless/dfs/dfs_debug.h b/net/wireless/dfs/dfs_debug.h
new file mode 100644
index 0000000..eda2735
--- /dev/null
+++ b/net/wireless/dfs/dfs_debug.h
@@ -0,0 +1,107 @@
+#ifndef DFS_DEBUG_H
+#define DFS_DEBUG_H
+
+enum {
+	DFS_DEBUG_ERROR	= 0x000100,
+	DFS_DEBUG_WARN	= 0x000200,
+	DFS_DEBUG_INFO	= 0x000400,
+	DFS_DEBUG_TRACE	= 0x000800,
+	DFS_DEBUG_LOG	= 0x001000,
+};
+
+extern u32 dfs_debug_level;
+#define MAX_DEBUG_SPRINTF 511
+extern char dbg_buff[MAX_DEBUG_SPRINTF + 1];
+
+#define __SHORT_FILE__ \
+	(strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
+
+
+#ifdef __KERNEL__
+#include <linux/kernel.h>
+
+#define DFS_DPRINTK(LEVEL, FMT, ...) \
+do { \
+	if ((LEVEL) & dfs_debug_level)	\
+		printk(FMT, ##__VA_ARGS__); \
+} while (0)
+
+#define ASSERT(expr) \
+if (unlikely(!(expr))) { \
+	panic(KERN_ERR "Assertion failed! %s,%s,%s,line=%d\n", \
+	#expr, __SHORT_FILE__, __func__, __LINE__); \
+}
+
+#else
+#include <stdio.h>
+
+#define DFS_DPRINTK(LEVEL, FMT, ...) \
+do { \
+	if ((LEVEL) & dfs_debug_level)	\
+		printf(FMT, ##__VA_ARGS__);  \
+} while (0)
+
+#define ASSERT(expr) \
+do { \
+	if (!(expr)) { \
+		printf("Assertion failed! %s,%s,%s,line=%d\n", \
+		#expr, __SHORT_FILE__, __func__, __LINE__); \
+	} \
+} while (0)
+
+#endif
+
+#define DTRACE(...) \
+do { \
+	DFS_DPRINTK(DFS_DEBUG_TRACE, "TRACE: %s\n", __func__); \
+} while (0)
+
+#define DLOG(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, "LOG: %s\n", FMT); \
+	DFS_DPRINTK(DFS_DEBUG_LOG, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DINFO(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, "INFO: %s\n", FMT); \
+	DFS_DPRINTK(DFS_DEBUG_INFO, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DWARN(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, \
+			"WARN: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_WARN, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DERROR(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, \
+			"WARN: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_ERROR, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DFATAL(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, \
+			"FATAL: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_ERROR, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+
+#define DINIT(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, \
+			"INIT: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_ERROR, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DINFO_OK(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, "OK: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_INFO, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+
+#endif /* DFS_DEBUG_H */
diff --git a/net/wireless/dfs/dfs_debugfs.c b/net/wireless/dfs/dfs_debugfs.c
new file mode 100644
index 0000000..2610bdb
--- /dev/null
+++ b/net/wireless/dfs/dfs_debugfs.c
@@ -0,0 +1,301 @@
+#include "dfs_common.h"
+
+
+#if defined(__KERNEL__)
+
+#include <linux/debugfs.h>
+
+#include "net/dfs.h"
+#include "net/cfg80211.h"
+#include "dfs_debugfs.h"
+#include "dfs_debug.h"
+
+static int dfs_debugfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+
+/* generic */
+static ssize_t read_dfs_generic(char __user *user_buf, size_t count,
+		loff_t *ppos, const char *fmt, int val)
+{
+	char buf[32];
+	unsigned int len;
+
+	sprintf(buf, fmt, val);
+	strcat(buf, "\n");
+	len = strlen(buf);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_dfs_generic(const char __user *user_buf, size_t count,
+		unsigned int *val)
+{
+	char buf[32];
+	ssize_t len;
+
+	unsigned long my_val;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &my_val))
+		return -EINVAL;
+	*val = my_val;
+	return count;
+}
+
+
+/********* debug_level */
+static ssize_t read_dfs_debug_level(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	return read_dfs_generic(user_buf, count, ppos, "0x%.8x",
+			dfs_debug_level);
+}
+
+static ssize_t write_dfs_debug_level(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	return write_dfs_generic(user_buf, count, &dfs_debug_level);
+}
+
+static const struct file_operations fops_dfs_debug_level = {
+	.read = read_dfs_debug_level,
+	.write = write_dfs_debug_level,
+	.open = dfs_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+
+/********* radar */
+
+#include <linux/ktime.h>
+
+#define R1_WIDTH	1
+#define R1_PPS		700
+#define R1_PPB		18
+#define R1_RSSI		30
+#define R1_FREQ	5500
+
+static int radar_pps = R1_PPS;
+static int radar_ppb = R1_PPB;
+static int radar_width = R1_WIDTH;
+static int radar_rssi = R1_RSSI;
+static int radar_freq = R1_FREQ;
+
+
+/********* radar_width */
+static ssize_t read_dfs_radar_width(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	return read_dfs_generic(user_buf, count, ppos, "%d", radar_width);
+}
+
+static ssize_t write_dfs_radar_width(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	return write_dfs_generic(user_buf, count, &radar_width);
+}
+
+static const struct file_operations fops_dfs_radar_width = {
+	.read = read_dfs_radar_width,
+	.write = write_dfs_radar_width,
+	.open = dfs_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+
+/********* radar_prf */
+static ssize_t read_dfs_radar_pps(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	return read_dfs_generic(user_buf, count, ppos, "%d", radar_pps);
+}
+
+static ssize_t write_dfs_radar_pps(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	return write_dfs_generic(user_buf, count, &radar_pps);
+}
+
+static const struct file_operations fops_dfs_radar_pps = {
+	.read = read_dfs_radar_pps,
+	.write = write_dfs_radar_pps,
+	.open = dfs_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+/********* radar_ppb */
+static ssize_t read_dfs_radar_ppb(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	return read_dfs_generic(user_buf, count, ppos, "%d", radar_ppb);
+}
+
+static ssize_t write_dfs_radar_ppb(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	return write_dfs_generic(user_buf, count, &radar_ppb);
+}
+
+static const struct file_operations fops_dfs_radar_ppb = {
+	.read = read_dfs_radar_ppb,
+	.write = write_dfs_radar_ppb,
+	.open = dfs_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+
+/********* radar_rssi */
+static ssize_t read_dfs_radar_rssi(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	return read_dfs_generic(user_buf, count, ppos, "%d", radar_rssi);
+}
+
+static ssize_t write_dfs_radar_rssi(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	return write_dfs_generic(user_buf, count, &radar_rssi);
+}
+
+static const struct file_operations fops_dfs_radar_rssi = {
+	.read = read_dfs_radar_rssi,
+	.write = write_dfs_radar_rssi,
+	.open = dfs_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+
+/********* radar_freq */
+static ssize_t read_dfs_radar_freq(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	return read_dfs_generic(user_buf, count, ppos, "%d", radar_freq);
+}
+
+static ssize_t write_dfs_radar_freq(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	return write_dfs_generic(user_buf, count, &radar_rssi);
+}
+
+static const struct file_operations fops_dfs_radar_freq = {
+	.read = read_dfs_radar_freq,
+	.write = write_dfs_radar_freq,
+	.open = dfs_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+
+static void generate_radar(void)
+{
+	int i;
+	s64 tsf_sim = ktime_to_us(ktime_get_real());
+	u32 deltaUs = USEC_PER_SEC / radar_pps;
+
+	DTRACE();
+
+	for (i = 0; i < radar_ppb; i++) {
+		ieee80211_add_radar_pulse(radar_freq, tsf_sim,
+				radar_rssi, radar_width);
+		tsf_sim += deltaUs;
+	}
+}
+
+
+static ssize_t write_dfs_generate_radar(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val == 1)
+		generate_radar();
+
+	return count;
+}
+
+static const struct file_operations fops_dfs_generate_radar = {
+	.read = NULL,
+	.write = write_dfs_generate_radar,
+	.open = dfs_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+
+
+static struct dentry *dfs_debugfs_root;
+
+void dfs_debugfs_exit(struct dfs_data *dfs_data)
+{
+	ASSERT(dfs_data != NULL);
+	debugfs_remove_recursive(dfs_debugfs_root);
+	debugfs_remove(dfs_debugfs_root);
+	dfs_debugfs_root = NULL;
+}
+
+int dfs_debugfs_init(struct dfs_data *dfs_data)
+{
+	if (dfs_debugfs_root) {
+		printk(KERN_INFO
+			"dfs_init_debug(): debugfs-root already set\n");
+		dfs_debugfs_exit(dfs_data);
+	}
+
+	dfs_debugfs_root = debugfs_create_dir("dfs", NULL);
+	if (!dfs_debugfs_root)
+		return -ENOENT;
+
+	if (!debugfs_create_file("debug_level", S_IRUSR | S_IWUSR,
+			dfs_debugfs_root, dfs_data, &fops_dfs_debug_level))
+		goto failed0;
+	if (!debugfs_create_file("generate_radar", S_IWUSR, dfs_debugfs_root,
+			dfs_data, &fops_dfs_generate_radar))
+		goto failed0;
+	if (!debugfs_create_file("radar_width", S_IWUSR, dfs_debugfs_root,
+			dfs_data, &fops_dfs_radar_width))
+		goto failed0;
+	if (!debugfs_create_file("radar_pps", S_IWUSR, dfs_debugfs_root,
+			dfs_data, &fops_dfs_radar_pps))
+		goto failed0;
+	if (!debugfs_create_file("radar_ppb", S_IWUSR, dfs_debugfs_root,
+			dfs_data, &fops_dfs_radar_ppb))
+		goto failed0;
+	if (!debugfs_create_file("radar_rssi", S_IWUSR, dfs_debugfs_root,
+			dfs_data, &fops_dfs_radar_rssi))
+		goto failed0;
+	if (!debugfs_create_file("radar_freq", S_IWUSR, dfs_debugfs_root,
+			dfs_data, &fops_dfs_radar_freq))
+		goto failed0;
+	return 0;
+
+failed0:
+	dfs_debugfs_exit(dfs_data);
+	return -ENOMEM;
+}
+
+#else
+void dfs_debugfs_exit(struct dfs_data *dfs_data) {}
+
+int dfs_debugfs_init(struct dfs_data *dfs_data)
+{
+	return 0;
+}
+
+#endif
+
diff --git a/net/wireless/dfs/dfs_debugfs.h b/net/wireless/dfs/dfs_debugfs.h
new file mode 100644
index 0000000..718d9ea
--- /dev/null
+++ b/net/wireless/dfs/dfs_debugfs.h
@@ -0,0 +1,9 @@
+#ifndef DFS_DEBUGFS_H
+#define DFS_DEBUGFS_H
+
+struct dfs_data;
+
+int dfs_debugfs_init(struct dfs_data *dfs_data);
+void dfs_debugfs_exit(struct dfs_data *dfs_data);
+
+#endif  /* DFS_DEBUGFS_H */
diff --git a/net/wireless/dfs/dfs_handler.c b/net/wireless/dfs/dfs_handler.c
new file mode 100644
index 0000000..7e65852
--- /dev/null
+++ b/net/wireless/dfs/dfs_handler.c
@@ -0,0 +1,94 @@
+#include "net/dfs.h"
+#include "net/cfg80211.h"
+#include "dfs_common.h"
+#include "dfs_debug.h"
+#include "dfs_debugfs.h"
+#include "dfs_pattern_detector.h"
+
+
+/* Destructor */
+static void dh_exit(struct dfs_handler *_this)
+{
+	ASSERT(_this != NULL);
+
+	if (_this->data != NULL) {
+		struct dfs_data *dfs_data = _this->data;
+		dfs_debugfs_exit(dfs_data);
+		if (dfs_data->pattern_detector != NULL)
+			dfs_data->pattern_detector->
+				exit(dfs_data->pattern_detector);
+		kfree(dfs_data);
+		_this->data = NULL;
+	}
+	kfree(_this);
+}
+
+static int dh_add_pulse(struct dfs_handler *_this, struct pulse_event *event)
+{
+	int detector_result;
+	struct dfs_data *dfs_data;
+	DTRACE();
+	ASSERT((_this != NULL) && (_this->data != NULL));
+
+	dfs_data = _this->data;
+	detector_result = dfs_data->pattern_detector->
+			add_pulse(dfs_data->pattern_detector, event);
+	if (detector_result == RADAR_DETECTED) {
+		/* DINIT("found radar type %d", radar_type); */
+		ieee80211_radar_detected(event->freq);
+		return 1;
+	}
+	return 0;
+}
+
+static struct dfs_handler default_dfs_handler = {
+	.exit		= dh_exit,
+	.add_pulse	= dh_add_pulse,
+};
+
+/* Constructor */
+struct dfs_handler *dfs_handler_init(enum dfs_domain dfs_domain)
+{
+	struct dfs_handler *_this;
+	struct dfs_data *dfs_data;
+	int sz = sizeof(struct dfs_handler);
+	_this = kmalloc(sz, GFP_KERNEL);
+
+	if (_this == NULL) {
+		DFATAL("dfs_handler allocation failed");
+		return NULL;
+	}
+
+	*_this = default_dfs_handler;
+
+
+	sz = sizeof(struct dfs_data);
+	dfs_data = kmalloc(sz, GFP_KERNEL);
+	if (dfs_data == NULL) {
+		DFATAL("dfs_data allocation failed");
+		goto failed;
+	}
+
+	memset(dfs_data, 0, sz);
+
+	_this->data = dfs_data;
+	dfs_data->pattern_detector = dfs_pattern_detector_init(dfs_domain);
+	if (dfs_data->pattern_detector == NULL) {
+		DFATAL("detector_init() failed!");
+		goto failed;
+	}
+	_this->data->dfs_domain = dfs_domain;
+	_this->data->dfs_handler = _this;
+
+	/* XXX: debug_fs considered as non-critical on failure */
+	dfs_debugfs_init(_this->data);
+	DINIT("ok");
+	return _this;
+
+failed:
+	_this->exit(_this);
+	return NULL;
+}
+EXPORT_SYMBOL(dfs_handler_init);
+
+
diff --git a/net/wireless/dfs/dfs_pattern_detector.c b/net/wireless/dfs/dfs_pattern_detector.c
new file mode 100644
index 0000000..17ab7d6
--- /dev/null
+++ b/net/wireless/dfs/dfs_pattern_detector.c
@@ -0,0 +1,559 @@
+#include "dfs_pattern_detector.h"
+#include "dfs_debug.h"
+#include "net/dfs.h"
+
+#include "dfs_radar_types.h"
+
+/*
+ * Abbreviations used (based on regulatory specs):
+ *  * prf: pulse repetition frequency [Hz]
+ *  * pri: pulse repetition interval = 1/prf, here used as [us]
+ *  * ppb: pulses per burst
+ */
+
+
+#define DELTA(X, Y) ((X < Y) ? (Y-X) : (X-Y))
+
+/* number of deviation of radar time in usecs tolerated on both sides
+ * TODO: this might need to be HW-dependent
+ */
+#define MAX_PRI_TOLERANCE	10
+
+
+/**
+ * struct radar_specs - specifies a radar pattern type
+ *
+ * @type_id: pattern type, as defined by ETSI / FCC
+ * @width_min: minimum radar pulse width in [us]
+ * @width_max: maximum radar pulse width in [us]
+ * @pri_min: minimum pulse repetition interval in [us] (including tolerance)
+ * @pri_max: minimum pri in [us] (including tolerance)
+ * @num_pri: maximum number of different pri for this type
+ * @ppb: pulses per bursts for this type
+ * @ppb_thresh: number of pulses required to trigger detection
+ * @max_dur: absolute max duration of pattern: num_pri * pri_max * ppb
+ *
+ * Characteristics of each radar pattern type are calculated at initialization
+ * based on radar test signal types defined by the chosen regulatory.
+ * They remain unchanged thereafter.
+ */
+struct radar_specs {
+	unsigned int type_id;
+	unsigned int width_min;
+	unsigned int width_max;
+	unsigned int pri_min;
+	unsigned int pri_max;
+	unsigned int num_pri;
+	unsigned int ppb;
+	unsigned int ppb_thresh;
+	unsigned int max_dur;
+};
+
+
+/* so far, maximum prf number is 3 for ETSI types 5 and 6 */
+#define MAX_PRF_NUM 3
+
+/**
+ * struct radar_stats - detector statistics updated on each pulse
+ *
+ * @pri_count: number of pri used for this pattern type so far
+ * @pri: array of pris in use
+ * @matching_pulse_count: number of pulses detected correctly so far
+ * @missed_pulse_count: number of pulses assumed as lost so far
+ * @false_pulse_count: number of invalid / false pulses so far
+ * @first_ts: timestamp of first valid pulse for this type
+ * @last_ts: timestamp of last valid pulse for this type
+ *
+ * The statistics reflect the current state of the related detector line.
+ *
+ * Detection is performed in place updating the affected detector lines
+ * whenever a pulse is added. The algorithm operates without keeping track
+ * of the pulse history but requires only the statistics collected so far.
+ *
+ * Statistical decisions are made based on the numbers for matching,
+ * missed, and false pulses count.
+ */
+struct radar_stats {
+	u32 pri_count;
+	u32 pri[MAX_PRF_NUM];
+	u32 matching_pulse_count;
+	u32 missed_pulse_count;
+	u32 false_pulse_count;
+	u64 first_ts;
+	u64 last_ts;
+};
+
+/**
+ * struct dfs_channels - DFS channels' frequencies, assumed constant
+ */
+static const u16 dfs_channels[] =
+{
+	5260, 5280, 5300, 5320,
+	5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640, 5660, 5680, 5700,
+};
+#define NUM_DFS_CHANNELS (sizeof(dfs_channels)/sizeof(dfs_channels[0]))
+
+
+/**
+ * struct detector_line - detector line for one specific dfs pattern type
+ *
+ * @specs: dfs pattern type specification
+ * @stats: array of statistics for for all DFS channels
+ *
+ * Each detector line consists of a constant radar type specification and
+ * an array of statistics for all DFS channels.
+ */
+struct detector_line {
+	struct radar_specs specs;
+	struct radar_stats stats[NUM_DFS_CHANNELS];
+};
+
+
+/**
+ * struct pattern_detector_data - private instance data
+ *
+ * @num_detector_elements: number of different radar types
+ * @radar_detectors: array of num_detector_elements detector lines
+ * @min_valid_width: combined min of valid pulse widths
+ * @max_valid_width: combined max of valid pulse widths
+ * @min_valid_pri: combined min of valid pris
+ * @max_valid_pri: combined max of valid pris
+ * @max_radar_dur: combined max duration of radar patterns
+ * @first_pulse_ts: timestamp of first pulse after detector reset
+ * @last_pulse_ts: timestamp of last valid pulse
+ * @last_pulse_rssi: rssi of last pulse
+ *
+ * For global range checking dfs_pattern_detector instances are initialized
+ * with a pre-calculated set of global limits that combine the limits of
+ * all detector lines.
+ */
+struct pattern_detector_data {
+	u32 num_detector_elements;
+	struct detector_line *radar_detectors;
+	u32 min_valid_width;
+	u32 max_valid_width;
+	u32 min_valid_pri;
+	u32 max_valid_pri;
+	u32 max_radar_dur;
+	u64 first_pulse_ts;
+	u64 last_pulse_ts;
+	u32 last_pulse_rssi;
+};
+
+/**
+ * get_dfs_channel_idx - (private) find DFS channel index for given frequency
+ *
+ * @freq: frequency to search for
+ *
+ * Returns -1 if not found.
+ */
+static int get_dfs_channel_idx(u16 freq)
+{
+	int i;
+	for (i = 0; i < NUM_DFS_CHANNELS; i++)
+		if (dfs_channels[i] == freq)
+			return i;
+	return -1;
+}
+
+/**
+ * reset_detector_element - (private) reset one detector element
+ *
+ * @rs: radar statistics to reset
+ * @ts: time stamp to be reset to
+ *
+ * Resets the statistics for one pattern type of one channel. Sets the
+ * timestamp for the last valid pulse to given value.
+ */
+static void reset_detector_element(struct radar_stats *rs, u64 ts)
+{
+	memset(rs, 0, sizeof(struct radar_stats));
+	rs->last_ts = ts;
+}
+
+
+/**
+ * detector_reset - (private) reset all detector lines for a given channel
+ *
+ * @pd_data: instance data ptr
+ * @dfs_channel_idx: DFS channel index to be reset
+ *
+ * Resets the statistics for all pattern types of one given channel.
+ */
+static void detector_reset(struct pattern_detector_data *pd_data,
+		int dfs_channel_idx)
+{
+	int i;
+	u64 ts = pd_data->last_pulse_ts;
+	DTRACE();
+	for (i = 0; i < pd_data->num_detector_elements; i++) {
+		struct radar_stats *rs;
+		rs = &pd_data->radar_detectors[i].stats[dfs_channel_idx];
+		reset_detector_element(rs, ts);
+	}
+}
+
+
+/**
+ * check_pulse_lost - (private) check potentially lost pulses
+ *
+ * @rs: radar stats to be checked
+ * @delta_ts: pulse interval to be checked
+ *
+ * In case we missed some pulse '.' in a row of valid pulses '|', we try to
+ * reconstruct them by checking for delta_ts being a multiple of the pri.
+ *
+ * Assume we were fed with a pattern like
+ *    |    |    .    .    |
+ * Evaluating the last pulse we check if the last interval is a multiple of our
+ * pri and in that case return 2 as the number of (potentially) lost pulses.
+ *
+ * The global check if the last interval exceeds the max duration of this
+ * pattern type is performed by the caller.
+ *
+ */
+static int check_pulse_lost(struct radar_stats *rs, u32 delta_ts)
+{
+	int lost_pulses = 0;
+
+	if (rs->pri_count == 1) {
+		/* check constant pri patterns */
+		u32 pri = rs->pri[0];
+		while (delta_ts > pri) {
+			/* we already checked that we are within valid duration
+			 * => won't loop too long */
+			lost_pulses++;
+			delta_ts -= pri;
+		}
+
+		if (DELTA(pri, delta_ts) <= MAX_PRI_TOLERANCE)
+			return lost_pulses;
+
+		return 0;
+	} else {
+		/* TODO: check staggered radar patterns
+			 here we need to support
+			 * single burst / packet based and
+			 * single burst / single pulse
+			 staggered PRF radar test signals
+		 */
+	}
+	return 0;
+}
+
+/**
+ * detector_check_match - (private) check for pattern match
+ *
+ * @rp: radar specs to be checked
+ * @rs: radar stats to be checked
+ * @delta_ts: pulse interval to be checked
+ *
+ * Returns 1 on match
+ */
+static int detector_check_match(struct radar_specs *rp, struct radar_stats *rs)
+{
+
+	if (rs->matching_pulse_count >= rp->ppb_thresh) {
+		DINIT("XXXXXXXXXXXXXXXXXXXXXXX MATCH on type %d", rp->type_id);
+		return 1;
+	}
+	return 0;
+}
+
+static int detector_check_pri(struct radar_specs *rp, struct radar_stats *rs,
+		u32 delta_ts)
+{
+	int lost_pulses;
+
+	int pri_num;
+	DLOG("OK: delta_ts=%d <= max_dur[%d]=%d",
+			delta_ts, rp->type_id, rp->max_dur);
+	for (pri_num = 0; pri_num < rs->pri_count; pri_num++) {
+		if (DELTA(delta_ts, rs->pri[pri_num]) < MAX_PRI_TOLERANCE) {
+			rs->matching_pulse_count++;
+			DLOG("delta_ts=%d matches pri_num[%d][%d] => "
+				"matching_pulse_count = %d", delta_ts,
+				rp->type_id, pri_num, rs->matching_pulse_count);
+			if (detector_check_match(rp, rs))
+				return 1;
+			/* we only take the first match */
+			return 0;
+		}
+		lost_pulses = check_pulse_lost(rs, delta_ts);
+		if (lost_pulses > 0) {
+			rs->matching_pulse_count += lost_pulses + 1;
+			DLOG("[%d] assuming %d lost pulses => "
+					"matching_pulse_count = %d",
+					rp->type_id, lost_pulses,
+					rs->matching_pulse_count);
+			if (detector_check_match(rp, rs))
+				return 1;
+			return 0;
+		}
+		DLOG("delta_ts=%d not multiple of [%d] = %d",
+				delta_ts, rp->type_id, rs->pri[0]);
+		reset_detector_element(rs, rs->last_ts);
+		return 0;
+
+	}
+	if (rs->pri_count >= rp->num_pri) {
+		rs->false_pulse_count++;
+	} else {
+		/* pri was not found in the current array, add it as new */
+		rs->pri[rs->pri_count++] = delta_ts;
+		rs->matching_pulse_count += 2;
+		DLOG("added new pri[%d][%d]=%d",
+				rp->type_id, rs->pri_count-1, delta_ts);
+	}
+	return 0;
+}
+
+static int detector_check_pulse_ts(struct radar_specs *rp,
+		struct radar_stats *rs, u64 ts)
+{
+	u32 delta_ts;
+
+	DTRACE();
+	delta_ts = ts - rs->last_ts;
+	DLOG("[%d]: ts=%llu, last_ts=%llu, delta_ts=%d, pri_min=%d, pri_max=%d,"
+			"max_dur=%d", rp->type_id, ts, rs->last_ts, delta_ts,
+			rp->pri_min, rp->pri_max, rp->max_dur);
+	if (delta_ts >= rp->pri_min) {
+		DLOG("OK: delta_ts >= pri_min");
+		if (delta_ts <= rp->max_dur) {
+			/* this one is for us */
+			rs->last_ts = ts;
+			return detector_check_pri(rp, rs, delta_ts);
+		} else {
+			DLOG("NOK: delta_ts=%d > max_dur[%d]=%d",
+					delta_ts, rp->type_id, rp->max_dur);
+		}
+	} else
+		DLOG("delta_ts=%d < pri_min[%d]=%d",
+				delta_ts, rp->type_id, rp->pri_min);
+	/* if for some reason this radar was not for me, safely reset stats
+	 * since this pulse invalidates all previous
+	 */
+	reset_detector_element(rs, ts);
+	return 0;
+}
+
+
+static u32 freq_to_usec(u32 freq)
+{
+	return (1000000 / freq);
+}
+
+/* percentage of ppb threshold to trigger detection */
+#define MIN_PPB_THRESH	66
+#define PPB_THRESH(X)	((X*MIN_PPB_THRESH + 50) / 100)
+
+static void dpd_exit(struct dfs_pattern_detector *_this)
+{
+	if (_this->data != NULL) {
+		if (_this->data->radar_detectors != NULL)
+			kfree(_this->data->radar_detectors);
+		kfree(_this->data);
+	}
+	kfree(_this);
+}
+
+static enum dfs_detector_result dpd_add_pulse(
+		struct dfs_pattern_detector *_this, struct pulse_event *event)
+{
+	int detector_result = NO_DETECTION;
+	struct pattern_detector_data *pd_data = _this->data;
+	u64 delta_ts = event->ts - pd_data->last_pulse_ts;
+	u32 width = event->width;
+	int dfs_channel_idx;
+	DTRACE();
+
+	DINFO("e->width=%d, e->ts=%llu, delta_ts=%llu, e->rssi=%d, e->freq=%d",
+			event->width, event->ts, delta_ts,
+			event->rssi, event->freq);
+
+	dfs_channel_idx = get_dfs_channel_idx(event->freq);
+	if (dfs_channel_idx < 0) {
+		DERROR("pulse_event.freq=%d is no DFS frequency, dropping");
+		return PULSE_DROPPED;
+	}
+
+	/* global condition checks */
+
+	/* condition: pulse width inside valid range? */
+	if ((width > pd_data->max_valid_width) ||
+			(width < pd_data->min_valid_width)) {
+		DINFO("pulse width %d outside valid range [%d, %d], dropping",
+			width, pd_data->min_valid_pri, pd_data->max_valid_pri);
+		return PULSE_DROPPED;
+	}
+
+	pd_data->last_pulse_ts = event->ts;
+
+	/* condition: pulse interval < max allowed pattern duration */
+	if (delta_ts > pd_data->max_radar_dur) {
+		DINFO("pulse with delta_ts=%llu > max_radar_dur=%d, resetting",
+				delta_ts, pd_data->max_radar_dur);
+		detector_reset(pd_data, dfs_channel_idx);
+		return NO_DETECTION;
+	}
+
+	/* condition: pulse interval larger that min allowed pri
+	 * NOTE: we are not checking against max allowed pri to
+	 *       allow for coverage of multiple pris
+	 */
+	if (delta_ts >= pd_data->min_valid_pri) {
+		int i;
+
+		/* do type individual pattern matching */
+		for (i = 0; i < pd_data->num_detector_elements; i++) {
+			struct radar_specs *rp;
+			rp = &pd_data->radar_detectors[i].specs;
+			/* condition: width within type specific width range */
+			if (width >= rp->width_min && width <= rp->width_max) {
+				struct radar_stats *rs;
+				rs = &pd_data->radar_detectors[i].
+						stats[dfs_channel_idx];
+				if (detector_check_pulse_ts(rp,
+						rs, event->ts)) {
+					detector_result = RADAR_DETECTED;
+					/* stop here, don't care if further
+					 * patterns might also match */
+					break;
+				}
+			}
+		}
+		if (detector_result == RADAR_DETECTED) {
+			/* radar pattern found -> reset detector line */
+			detector_reset(pd_data, dfs_channel_idx);
+		}
+		return detector_result;
+	} else
+		DINFO("pulse with delta_ts=%llu outside valid pri-range "
+			"[%d, %d], resetting", delta_ts,
+			pd_data->min_valid_pri, pd_data->max_valid_pri);
+	return 0;
+}
+
+
+/* our base VFT */
+static struct dfs_pattern_detector dpd_default_vft = {
+	.exit 		= dpd_exit,
+	.add_pulse 	= dpd_add_pulse,
+};
+
+
+static void print_detector_specs(struct pattern_detector_data *pd_data)
+{
+	int i;
+	for (i = 0; i < pd_data->num_detector_elements; i++) {
+		struct radar_specs *rs = &pd_data->radar_detectors[i].specs;
+		DINIT("Initialized radar pattern type %d", i);
+		DINIT("   rs->type_id = %d", rs->type_id);
+		DINIT("   rs->width_min = %d", rs->width_min);
+		DINIT("   rs->width_max = %d", rs->width_max);
+		DINIT("   rs->pri_min = %d", rs->pri_min);
+		DINIT("   rs->pri_max = %d", rs->pri_max);
+		DINIT("   rs->num_pri = %d", rs->num_pri);
+		DINIT("   rs->ppb_thresh = %d", rs->ppb_thresh);
+		DINIT("   rs->max_dur = %d", rs->max_dur);
+	}
+	DINIT("valid ranges: width=[%d, %d], pri=[%d, %d], dur=%d",
+			pd_data->min_valid_width, pd_data->max_valid_width,
+			pd_data->min_valid_pri, pd_data->max_valid_pri,
+			pd_data->max_radar_dur);
+}
+
+
+/* allocate and initialize object data */
+static struct pattern_detector_data *setup_detector_data(struct radar_type *rt)
+{
+	int i;
+	struct pattern_detector_data *pd_data;
+	int sz = sizeof(struct pattern_detector_data);
+	pd_data = kmalloc(sz, GFP_KERNEL);
+	if (pd_data == NULL) {
+		DERROR("allocation of pattern_detector_data failed");
+		return NULL;
+	}
+
+	memset(pd_data, 0, sz);
+
+	sz = sizeof(struct detector_line) * rt->num_radar_types;
+	pd_data->radar_detectors = kmalloc(sz, GFP_KERNEL);
+	if (pd_data->radar_detectors == NULL) {
+		DERROR("allocation of radar_detectors failed");
+		return NULL;
+	}
+	memset(pd_data->radar_detectors, 0, sz);
+
+	pd_data->num_detector_elements = rt->num_radar_types;
+	pd_data->min_valid_width = (u32) -1;
+	pd_data->max_valid_width = 0;
+	pd_data->min_valid_pri = (u32) -1;
+	pd_data->max_valid_pri = 0;
+	pd_data->max_radar_dur = 0;
+
+	for (i = 0; i < rt->num_radar_types; i++) {
+		struct radar_signal_type *rst = &rt->radar_types[i];
+		struct radar_specs *rs = &pd_data->radar_detectors[i].specs;
+		DINIT("Initializing type %d", i);
+		rs->type_id = rst->type_id;
+		rs->width_min = rst->width_min;
+		rs->width_max = rst->width_max;
+		rs->pri_min = freq_to_usec(rst->pps_max) - MAX_PRI_TOLERANCE;
+		rs->pri_max = freq_to_usec(rst->pps_min) + MAX_PRI_TOLERANCE;
+		rs->num_pri = rst->num_pri;
+		rs->ppb = rst->ppb;
+		rs->ppb_thresh = PPB_THRESH(rst->ppb);
+		rs->max_dur = rs->pri_max * rst->ppb * rst->num_pri;
+
+		if (rs->width_min < pd_data->min_valid_width)
+			pd_data->min_valid_width = rs->width_min;
+		if (rs->width_max > pd_data->max_valid_width)
+			pd_data->max_valid_width = rs->width_max;
+		if (rs->pri_min < pd_data->min_valid_pri)
+			pd_data->min_valid_pri = rs->pri_min;
+		if (rs->pri_max > pd_data->max_valid_pri)
+			pd_data->max_valid_pri = rs->pri_max;
+		if (rs->max_dur > pd_data->max_radar_dur)
+			pd_data->max_radar_dur = rs->max_dur;
+	}
+	print_detector_specs(pd_data);
+	return pd_data;
+}
+
+
+struct dfs_pattern_detector *dfs_pattern_detector_init(
+		enum dfs_domain dfs_domain)
+{
+	int i;
+	struct dfs_pattern_detector *_this;
+	struct radar_type *rt;
+
+	/* find supported radar type */
+	for (i = 0; /* nothing */; i++) {
+		rt = supported_radar_types[i];
+		if (rt == NULL) {
+			DERROR("non-supported dfs-domain %d", dfs_domain);
+			return NULL;
+		}
+		if (rt->dfs_id == dfs_domain)
+			break;
+	}
+	/* allocate object instance */
+	_this = kmalloc(sizeof(struct dfs_pattern_detector), GFP_KERNEL);
+	if (_this == NULL) {
+		DERROR("allocation of dfs_pattern_detector failed");
+		return NULL;
+	}
+	*_this = dpd_default_vft;
+
+	/* allocate and initialize object data */
+	_this->data = setup_detector_data(rt);
+	if (_this->data == NULL) {
+		_this->exit(_this);
+		return NULL;
+	}
+	return _this;
+}
diff --git a/net/wireless/dfs/dfs_pattern_detector.h b/net/wireless/dfs/dfs_pattern_detector.h
new file mode 100644
index 0000000..940c8c9
--- /dev/null
+++ b/net/wireless/dfs/dfs_pattern_detector.h
@@ -0,0 +1,46 @@
+#ifndef DFS_PATTERN_DETECTOR_H
+#define DFS_PATTERN_DETECTOR_H
+
+#include "net/dfs.h"
+
+
+/**
+ * enum dfs_detector_result - DFS detector result after adding pulse
+ *
+ * Feeding a potential radar pulse to the detector might result in:
+ * @NO_DETECTION: pulse added, but no detection so far
+ * @RADAR_DETECTED: pulse added, pattern matched => radar detected
+ * @PULSE_DROPPED: pulse not added, outside valid pattern ranges
+ */
+enum dfs_detector_result {
+	NO_DETECTION,
+	RADAR_DETECTED,
+	PULSE_DROPPED,
+};
+
+/**
+ * struct dfs_pattern_detector - pseudo-OO DFS pattern detector class
+ *
+ * A DFS pattern detector object is instantiated with its constructor that
+ * returns ptr to initialized object.
+ *
+ * The VFT so far needs only two public methods:
+ * @exit: destructor
+ * @add_pulse: adds radar pulse to detector
+ *
+ * All data is private.
+ */
+struct dfs_pattern_detector {
+	/* VFT */
+	void (*exit)(struct dfs_pattern_detector *_this);
+	enum dfs_detector_result (*add_pulse)
+		(struct dfs_pattern_detector *_this, struct pulse_event *pe);
+
+	/* private data */
+	struct pattern_detector_data *data;
+};
+
+/* Constructor */
+struct dfs_pattern_detector *dfs_pattern_detector_init(enum dfs_domain);
+
+#endif /* DFS_PATTERN_DETECTOR_H */
diff --git a/net/wireless/dfs/dfs_radar_types.h b/net/wireless/dfs/dfs_radar_types.h
new file mode 100644
index 0000000..329d96c
--- /dev/null
+++ b/net/wireless/dfs/dfs_radar_types.h
@@ -0,0 +1,47 @@
+#ifndef DFS_RADAR_TYPES_H
+#define DFS_RADAR_TYPES_H
+
+#include "net/dfs.h"
+
+struct radar_signal_type {
+	unsigned int type_id;
+	unsigned int width_min;
+	unsigned int width_max;
+	unsigned int pps_min;
+	unsigned int pps_max;
+	unsigned int num_pri;
+	unsigned int ppb;
+};
+
+static struct radar_signal_type etsi_radar_ref_types_v15[] = {
+	{ 0,  0,  1,  700,  700, 1, 18, },
+	{ 1,  0,  5,  200, 1000, 1, 10, },
+	{ 2,  0, 15,  200, 1600, 1, 15, },
+	{ 3,  0, 15, 2300, 4000, 1, 25, },
+	{ 4, 20, 30, 2000, 4000, 1, 20, },
+	{ 5,  0,  2,  300,  400, 3, 10, },
+	{ 6,  0,  2,  400, 1200, 3, 15, },
+};
+
+struct radar_type {
+	u32 dfs_id;
+	u32 num_radar_types;
+	struct radar_signal_type *radar_types;
+};
+
+static struct radar_type etsi_radar_types_v15 = {
+	.dfs_id = DFS_ETSI_DOMAIN,
+	.num_radar_types = sizeof(etsi_radar_ref_types_v15) /
+				sizeof(struct radar_signal_type),
+	.radar_types = etsi_radar_ref_types_v15,
+};
+
+
+static struct radar_type *supported_radar_types[] = {
+	&etsi_radar_types_v15,
+};
+
+
+
+#endif /* DFS_RADAR_TYPES_H */
+
-- 
1.5.4.3
