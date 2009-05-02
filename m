Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZEBEjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 00:39:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] mac80211/cfg80211: move wiphy specific debugfs entries to cfg80211
Date: Sat,  2 May 2009 00:39:29 -0400
Message-Id: <1241239170-11443-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1241239170-11443-1-git-send-email-lrodriguez@atheros.com>
References: <1241239170-11443-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves the cfg80211 specific stuff to new cfg80211 debugfs
entries. Non-mac80211 will also get these entries now. There were
only 4 which we take:

rts_threshold
fragmentation_threshold
short_retry_limit
long_retry_limit

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/debugfs.c     |   16 ----------
 net/mac80211/ieee80211_i.h |    4 --
 net/wireless/Kconfig       |    8 +++++
 net/wireless/Makefile      |    1 +
 net/wireless/core.c        |    5 +++
 net/wireless/core.h        |   11 +++++++
 net/wireless/debugfs.c     |   70 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/debugfs.h     |   14 +++++++++
 8 files changed, 109 insertions(+), 20 deletions(-)
 create mode 100644 net/wireless/debugfs.c
 create mode 100644 net/wireless/debugfs.h

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index ac79320..e83c029 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -52,14 +52,6 @@ static const struct file_operations name## _ops = {			\
 
 DEBUGFS_READONLY_FILE(frequency, 20, "%d",
 		      local->hw.conf.channel->center_freq);
-DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
-		      local->hw.wiphy->rts_threshold);
-DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
-		      local->hw.wiphy->frag_threshold);
-DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
-		      local->hw.wiphy->retry_short);
-DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
-		      local->hw.wiphy->retry_long);
 DEBUGFS_READONLY_FILE(total_ps_buffered, 20, "%d",
 		      local->total_ps_buffered);
 DEBUGFS_READONLY_FILE(wep_iv, 20, "%#08x",
@@ -267,10 +259,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	local->debugfs.keys = debugfs_create_dir("keys", phyd);
 
 	DEBUGFS_ADD(frequency);
-	DEBUGFS_ADD(rts_threshold);
-	DEBUGFS_ADD(fragmentation_threshold);
-	DEBUGFS_ADD(short_retry_limit);
-	DEBUGFS_ADD(long_retry_limit);
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(tsf);
@@ -322,10 +310,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 void debugfs_hw_del(struct ieee80211_local *local)
 {
 	DEBUGFS_DEL(frequency);
-	DEBUGFS_DEL(rts_threshold);
-	DEBUGFS_DEL(fragmentation_threshold);
-	DEBUGFS_DEL(short_retry_limit);
-	DEBUGFS_DEL(long_retry_limit);
 	DEBUGFS_DEL(total_ps_buffered);
 	DEBUGFS_DEL(wep_iv);
 	DEBUGFS_DEL(tsf);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 03e0d22..15e8242 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -752,10 +752,6 @@ struct ieee80211_local {
 		struct dentry *rcdir;
 		struct dentry *rcname;
 		struct dentry *frequency;
-		struct dentry *rts_threshold;
-		struct dentry *fragmentation_threshold;
-		struct dentry *short_retry_limit;
-		struct dentry *long_retry_limit;
 		struct dentry *total_ps_buffered;
 		struct dentry *wep_iv;
 		struct dentry *tsf;
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 3c3bc9e..4500549 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -10,6 +10,14 @@ config CFG80211_REG_DEBUG
 
 	  If unsure, say N.
 
+config CFG80211_DEBUGFS
+	bool "cfg80211 DebugFS entries"
+	depends on CFG80211 && DEBUG_FS
+	---help---
+	  You can enable this if you want to debugfs entries for cfg80211.
+
+	  If unsure, say N.
+
 config WIRELESS_OLD_REGULATORY
 	bool "Old wireless static regulatory definitions"
 	default n
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 14ea01c..f78c483 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o
+cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2006a4e..b07e630 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -17,6 +17,7 @@
 #include "nl80211.h"
 #include "core.h"
 #include "sysfs.h"
+#include "debugfs.h"
 
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
@@ -375,6 +376,8 @@ int wiphy_register(struct wiphy *wiphy)
 		nl80211_send_reg_change_event(&request);
 	}
 
+	cfg80211_debugfs_drv_add(drv);
+
 	res = 0;
 out_unlock:
 	mutex_unlock(&cfg80211_mutex);
@@ -405,6 +408,8 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* unlock again before freeing */
 	mutex_unlock(&drv->mtx);
 
+	cfg80211_debugfs_drv_del(drv);
+
 	/* If this device got a regulatory hint tell core its
 	 * free to listen now to a new shiny device regulatory hint */
 	reg_device_remove(wiphy);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3e49d33..5756e80 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 #include <linux/kref.h>
 #include <linux/rbtree.h>
+#include <linux/debugfs.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "reg.h"
@@ -50,6 +51,16 @@ struct cfg80211_registered_device {
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	unsigned long suspend_at;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	/* Debugfs entries */
+	struct wiphy_debugfsdentries {
+		struct dentry *rts_threshold;
+		struct dentry *fragmentation_threshold;
+		struct dentry *short_retry_limit;
+		struct dentry *long_retry_limit;
+	} debugfs;
+#endif
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
new file mode 100644
index 0000000..3211e0e
--- /dev/null
+++ b/net/wireless/debugfs.c
@@ -0,0 +1,70 @@
+/*
+ * cfg80211 debugfs
+ *
+ * Copyright 2009	Luis R. Rodriguez <lrodriguez@atheros.com>
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "core.h"
+#include "debugfs.h"
+
+static int cfg80211_open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+#define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
+static ssize_t name## _read(struct file *file, char __user *userbuf,	\
+			    size_t count, loff_t *ppos)			\
+{									\
+	struct wiphy *wiphy= file->private_data;		\
+	char buf[buflen];						\
+	int res;							\
+									\
+	res = scnprintf(buf, buflen, fmt "\n", ##value);		\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}									\
+									\
+static const struct file_operations name## _ops = {			\
+	.read = name## _read,						\
+	.open = cfg80211_open_file_generic,				\
+};
+
+DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
+		      wiphy->rts_threshold)
+DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
+		      wiphy->frag_threshold);
+DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
+		      wiphy->retry_short)
+DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
+		      wiphy->retry_long);
+
+#define DEBUGFS_ADD(name)						\
+	drv->debugfs.name = debugfs_create_file(#name, S_IRUGO, phyd,	\
+						  &drv->wiphy, &name## _ops);
+#define DEBUGFS_DEL(name)						\
+	debugfs_remove(drv->debugfs.name);				\
+	drv->debugfs.name = NULL;
+
+void cfg80211_debugfs_drv_add(struct cfg80211_registered_device *drv)
+{
+	struct dentry *phyd = drv->wiphy.debugfsdir;
+
+	DEBUGFS_ADD(rts_threshold);
+	DEBUGFS_ADD(fragmentation_threshold);
+	DEBUGFS_ADD(short_retry_limit);
+	DEBUGFS_ADD(long_retry_limit);
+}
+
+void cfg80211_debugfs_drv_del(struct cfg80211_registered_device *drv)
+{
+	DEBUGFS_DEL(rts_threshold);
+	DEBUGFS_DEL(fragmentation_threshold);
+	DEBUGFS_DEL(short_retry_limit);
+	DEBUGFS_DEL(long_retry_limit);
+}
diff --git a/net/wireless/debugfs.h b/net/wireless/debugfs.h
new file mode 100644
index 0000000..c226983
--- /dev/null
+++ b/net/wireless/debugfs.h
@@ -0,0 +1,14 @@
+#ifndef __CFG80211_DEBUGFS_H
+#define __CFG80211_DEBUGFS_H
+
+#ifdef CONFIG_CFG80211_DEBUGFS
+void cfg80211_debugfs_drv_add(struct cfg80211_registered_device *drv);
+void cfg80211_debugfs_drv_del(struct cfg80211_registered_device *drv);
+#else
+static inline
+void cfg80211_debugfs_drv_add(struct cfg80211_registered_device *drv) {}
+static inline
+void cfg80211_debugfs_drv_del(struct cfg80211_registered_device *drv) {}
+#endif
+
+#endif /* __CFG80211_DEBUGFS_H */
-- 
1.6.0.6

