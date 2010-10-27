Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53804 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab0J0M6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 08:58:24 -0400
Received: by wwe15 with SMTP id 15so748283wwe.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 05:58:23 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: refactor debugfs function generation code
Date: Wed, 27 Oct 2010 14:58:29 +0200
Message-Id: <1288184310-6781-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

refactor mac80211 debugfs code by using a format&copy function, instead of
duplicating the code for each generated function.

this change reduces about 600B from mac80211.ko

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/debugfs.c     |   60 ++++++++++++++++++++++---------------------
 net/mac80211/debugfs.h     |    2 +
 net/mac80211/debugfs_key.c |   19 ++++++-------
 net/mac80211/debugfs_sta.c |   26 +++++++-----------
 4 files changed, 52 insertions(+), 55 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 18260aa..1f02e59 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -21,16 +21,30 @@ int mac80211_open_file_generic(struct inode *inode, struct file *file)
 	return 0;
 }
 
-#define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
+#define DEBUGFS_FORMAT_BUFFER_SIZE 100
+
+int mac80211_format_buffer(char __user *userbuf, size_t count,
+				  loff_t *ppos, char *fmt, ...)
+{
+	va_list args;
+	char buf[DEBUGFS_FORMAT_BUFFER_SIZE];
+	int res;
+
+	va_start(args, fmt);
+	res = vscnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+
+#define DEBUGFS_READONLY_FILE(name, fmt, value...)			\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
 {									\
 	struct ieee80211_local *local = file->private_data;		\
-	char buf[buflen];						\
-	int res;							\
 									\
-	res = scnprintf(buf, buflen, fmt "\n", ##value);		\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+	return mac80211_format_buffer(userbuf, count, ppos, 		\
+				      fmt "\n", ##value);		\
 }									\
 									\
 static const struct file_operations name## _ops = {			\
@@ -46,13 +60,13 @@ static const struct file_operations name## _ops = {			\
 	debugfs_create_file(#name, mode, phyd, local, &name## _ops);
 
 
-DEBUGFS_READONLY_FILE(frequency, 20, "%d",
+DEBUGFS_READONLY_FILE(frequency, "%d",
 		      local->hw.conf.channel->center_freq);
-DEBUGFS_READONLY_FILE(total_ps_buffered, 20, "%d",
+DEBUGFS_READONLY_FILE(total_ps_buffered, "%d",
 		      local->total_ps_buffered);
-DEBUGFS_READONLY_FILE(wep_iv, 20, "%#08x",
+DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
 		      local->wep_iv & 0xffffff);
-DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100, "%s",
+DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
 	local->rate_ctrl ? local->rate_ctrl->ops->name : "hw/driver");
 
 static ssize_t tsf_read(struct file *file, char __user *user_buf,
@@ -60,13 +74,11 @@ static ssize_t tsf_read(struct file *file, char __user *user_buf,
 {
 	struct ieee80211_local *local = file->private_data;
 	u64 tsf;
-	char buf[100];
 
 	tsf = drv_get_tsf(local);
 
-	snprintf(buf, sizeof(buf), "0x%016llx\n", (unsigned long long) tsf);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 19);
+	return mac80211_format_buffer(user_buf, count, ppos, "0x%016llx\n",
+				      (unsigned long long) tsf);
 }
 
 static ssize_t tsf_write(struct file *file,
@@ -131,12 +143,9 @@ static ssize_t noack_read(struct file *file, char __user *user_buf,
 			  size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
-	int res;
-	char buf[10];
 
-	res = scnprintf(buf, sizeof(buf), "%d\n", local->wifi_wme_noack_test);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	return mac80211_format_buffer(user_buf, count, ppos, "%d\n",
+				      local->wifi_wme_noack_test);
 }
 
 static ssize_t noack_write(struct file *file,
@@ -168,12 +177,8 @@ static ssize_t uapsd_queues_read(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
-	int res;
-	char buf[10];
-
-	res = scnprintf(buf, sizeof(buf), "0x%x\n", local->uapsd_queues);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	return mac80211_format_buffer(user_buf, count, ppos, "0x%x\n",
+				      local->uapsd_queues);
 }
 
 static ssize_t uapsd_queues_write(struct file *file,
@@ -215,12 +220,9 @@ static ssize_t uapsd_max_sp_len_read(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
-	int res;
-	char buf[10];
 
-	res = scnprintf(buf, sizeof(buf), "0x%x\n", local->uapsd_max_sp_len);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	return mac80211_format_buffer(user_buf, count, ppos, "0x%x\n",
+				      local->uapsd_max_sp_len);
 }
 
 static ssize_t uapsd_max_sp_len_write(struct file *file,
diff --git a/net/mac80211/debugfs.h b/net/mac80211/debugfs.h
index 09cc9be..7c87529 100644
--- a/net/mac80211/debugfs.h
+++ b/net/mac80211/debugfs.h
@@ -4,6 +4,8 @@
 #ifdef CONFIG_MAC80211_DEBUGFS
 extern void debugfs_hw_add(struct ieee80211_local *local);
 extern int mac80211_open_file_generic(struct inode *inode, struct file *file);
+extern int mac80211_format_buffer(char __user *userbuf, size_t count,
+				  loff_t *ppos, char *fmt, ...);
 #else
 static inline void debugfs_hw_add(struct ieee80211_local *local)
 {
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 4aa47d0..52655d9 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -15,18 +15,17 @@
 #include "debugfs.h"
 #include "debugfs_key.h"
 
-#define KEY_READ(name, prop, buflen, format_string)			\
+#define KEY_READ(name, prop, format_string)				\
 static ssize_t key_##name##_read(struct file *file,			\
 				 char __user *userbuf,			\
 				 size_t count, loff_t *ppos)		\
 {									\
-	char buf[buflen];						\
 	struct ieee80211_key *key = file->private_data;			\
-	int res = scnprintf(buf, buflen, format_string, key->prop);	\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+	return mac80211_format_buffer(userbuf, count, ppos, 		\
+				      format_string, key->prop);	\
 }
-#define KEY_READ_D(name) KEY_READ(name, name, 20, "%d\n")
-#define KEY_READ_X(name) KEY_READ(name, name, 20, "0x%x\n")
+#define KEY_READ_D(name) KEY_READ(name, name, "%d\n")
+#define KEY_READ_X(name) KEY_READ(name, name, "0x%x\n")
 
 #define KEY_OPS(name)							\
 static const struct file_operations key_ ##name## _ops = {		\
@@ -39,9 +38,9 @@ static const struct file_operations key_ ##name## _ops = {		\
 		 KEY_READ_##format(name)				\
 		 KEY_OPS(name)
 
-#define KEY_CONF_READ(name, buflen, format_string)			\
-	KEY_READ(conf_##name, conf.name, buflen, format_string)
-#define KEY_CONF_READ_D(name) KEY_CONF_READ(name, 20, "%d\n")
+#define KEY_CONF_READ(name, format_string)				\
+	KEY_READ(conf_##name, conf.name, format_string)
+#define KEY_CONF_READ_D(name) KEY_CONF_READ(name, "%d\n")
 
 #define KEY_CONF_OPS(name)						\
 static const struct file_operations key_ ##name## _ops = {		\
@@ -59,7 +58,7 @@ KEY_CONF_FILE(keyidx, D);
 KEY_CONF_FILE(hw_key_idx, D);
 KEY_FILE(flags, X);
 KEY_FILE(tx_rx_count, D);
-KEY_READ(ifindex, sdata->name, IFNAMSIZ + 2, "%s\n");
+KEY_READ(ifindex, sdata->name, "%s\n");
 KEY_OPS(ifindex);
 
 static ssize_t key_algorithm_read(struct file *file,
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 4601fea..f0fce37 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -17,20 +17,18 @@
 
 /* sta attributtes */
 
-#define STA_READ(name, buflen, field, format_string)			\
+#define STA_READ(name, field, format_string)				\
 static ssize_t sta_ ##name## _read(struct file *file,			\
 				   char __user *userbuf,		\
 				   size_t count, loff_t *ppos)		\
 {									\
-	int res;							\
 	struct sta_info *sta = file->private_data;			\
-	char buf[buflen];						\
-	res = scnprintf(buf, buflen, format_string, sta->field);	\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+	return mac80211_format_buffer(userbuf, count, ppos, 		\
+				      format_string, sta->field);	\
 }
-#define STA_READ_D(name, field) STA_READ(name, 20, field, "%d\n")
-#define STA_READ_U(name, field) STA_READ(name, 20, field, "%u\n")
-#define STA_READ_S(name, field) STA_READ(name, 20, field, "%s\n")
+#define STA_READ_D(name, field) STA_READ(name, field, "%d\n")
+#define STA_READ_U(name, field) STA_READ(name, field, "%u\n")
+#define STA_READ_S(name, field) STA_READ(name, field, "%s\n")
 
 #define STA_OPS(name)							\
 static const struct file_operations sta_ ##name## _ops = {		\
@@ -79,22 +77,18 @@ static ssize_t sta_num_ps_buf_frames_read(struct file *file,
 					  char __user *userbuf,
 					  size_t count, loff_t *ppos)
 {
-	char buf[20];
 	struct sta_info *sta = file->private_data;
-	int res = scnprintf(buf, sizeof(buf), "%u\n",
-			    skb_queue_len(&sta->ps_tx_buf));
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+	return mac80211_format_buffer(userbuf, count, ppos, "%u\n",
+				      skb_queue_len(&sta->ps_tx_buf));
 }
 STA_OPS(num_ps_buf_frames);
 
 static ssize_t sta_inactive_ms_read(struct file *file, char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	char buf[20];
 	struct sta_info *sta = file->private_data;
-	int res = scnprintf(buf, sizeof(buf), "%d\n",
-			    jiffies_to_msecs(jiffies - sta->last_rx));
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+	return mac80211_format_buffer(userbuf, count, ppos, "%d\n",
+				      jiffies_to_msecs(jiffies - sta->last_rx));
 }
 STA_OPS(inactive_ms);
 
-- 
1.7.0.4

