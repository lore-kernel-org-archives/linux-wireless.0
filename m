Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50870 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764310AbXFGUVH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 16:21:07 -0400
Date: Thu, 7 Jun 2007 22:21:13 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: allow changing of rate control algorithm
Message-ID: <20070607222113.0f752bf8@griffin.suse.cz>
In-Reply-To: <20070607221939.444e9d74@griffin.suse.cz>
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
	<20070607221939.444e9d74@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Possibility to change rate control algorithm was lost during the conversion
to debugfs. This patch adds it again.

Of course, this should be done by cfg80211. After it's implemented there,
this can go away again.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/mac80211/debugfs.c     |   61 ++++++++++++++++++++++++++++++++++-----------
 net/mac80211/ieee80211_i.h |    1 
 2 files changed, 48 insertions(+), 14 deletions(-)

--- mac80211-dev.orig/net/mac80211/debugfs.c
+++ mac80211-dev/net/mac80211/debugfs.c
@@ -13,6 +13,16 @@
 #include "ieee80211_rate.h"
 #include "debugfs.h"
 
+static inline int rtnl_lock_local(struct ieee80211_local *local)
+{
+	rtnl_lock();
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED)) {
+		rtnl_unlock();
+		return -ENODEV;
+	}
+	return 0;
+}
+
 int mac80211_open_file_generic(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -56,7 +66,7 @@ static const struct file_operations mode
 	.open = mac80211_open_file_generic,
 };
 
-#define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
+#define DEBUGFS_READ(name, buflen, fmt, value...)			\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
 {									\
@@ -67,16 +77,20 @@ static ssize_t name## _read(struct file 
 	res = scnprintf(buf, buflen, fmt "\n", ##value);		\
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
 }									\
-									\
+
+#define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
+DEBUGFS_READ(name, buflen, fmt, ## value)				\
 static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = mac80211_open_file_generic,				\
 };
 
-#define DEBUGFS_ADD(name)						\
-	local->debugfs.name = debugfs_create_file(#name, 0444, phyd,	\
+#define DEBUGFS_ADD_MODE(name, mode)					\
+	local->debugfs.name = debugfs_create_file(#name, mode, phyd,	\
 						  local, &name## _ops);
 
+#define DEBUGFS_ADD(name)	DEBUGFS_ADD_MODE(name, 0444)
+
 #define DEBUGFS_DEL(name)						\
 	debugfs_remove(local->debugfs.name);				\
 	local->debugfs.name = NULL;
@@ -113,21 +127,38 @@ DEBUGFS_READONLY_FILE(wep_iv, 20, "%#06x
 DEBUGFS_READONLY_FILE(tx_power_reduction, 20, "%d.%d dBm",
 		      local->hw.conf.tx_power_reduction / 10,
 		      local->hw.conf.tx_power_reduction & 10);
-DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100, "%s",
-		      local->rate_ctrl ? local->rate_ctrl->ops->name : "<unset>");
 
-/* statistics stuff */
+DEBUGFS_READ(rate_ctrl_alg, 100, "%s",
+	     local->rate_ctrl ? local->rate_ctrl->ops->name : "<unset>");
 
-static inline int rtnl_lock_local(struct ieee80211_local *local)
+static ssize_t rate_ctrl_alg_write(struct file *file, const char __user *userbuf,
+				   size_t count, loff_t *ppos)
 {
-	rtnl_lock();
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED)) {
-		rtnl_unlock();
-		return -ENODEV;
-	}
-	return 0;
+	struct ieee80211_local *local = file->private_data;
+	char buf[64];
+	ssize_t buf_size;
+	int res;
+
+	buf_size = min(count, ARRAY_SIZE(buf) - 1);
+	if (copy_from_user(buf, userbuf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = '\0';
+	res = rtnl_lock_local(local);
+	if (res)
+		return res;
+	res = ieee80211_init_rate_ctrl_alg(local, buf);
+	rtnl_unlock();
+	return res < 0 ? res : buf_size;
 }
 
+static const struct file_operations rate_ctrl_alg_ops = {
+	.read = rate_ctrl_alg_read,
+	.write = rate_ctrl_alg_write,
+	.open = mac80211_open_file_generic,
+};
+
+/* statistics stuff */
+
 #define DEBUGFS_STATS_FILE(name, buflen, fmt, value...)			\
 	DEBUGFS_READONLY_FILE(stats_ ##name, buflen, fmt, ##value)
 
@@ -318,6 +349,7 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_ADD(mode);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(tx_power_reduction);
+	DEBUGFS_ADD_MODE(rate_ctrl_alg, 0644);
 	DEBUGFS_ADD(modes);
 
 	statsd = debugfs_create_dir("statistics", phyd);
@@ -383,6 +415,7 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_DEL(mode);
 	DEBUGFS_DEL(wep_iv);
 	DEBUGFS_DEL(tx_power_reduction);
+	DEBUGFS_DEL(rate_ctrl_alg);
 	DEBUGFS_DEL(modes);
 
 	DEBUGFS_STATS_DEL(transmitted_fragment_count);
--- mac80211-dev.orig/net/mac80211/ieee80211_i.h
+++ mac80211-dev/net/mac80211/ieee80211_i.h
@@ -649,6 +649,7 @@ struct ieee80211_local {
 		struct dentry *total_ps_buffered;
 		struct dentry *mode;
 		struct dentry *wep_iv;
+		struct dentry *rate_ctrl_alg;
 		struct dentry *tx_power_reduction;
 		struct dentry *modes;
 		struct dentry *statistics;


-- 
Jiri Benc
SUSE Labs
