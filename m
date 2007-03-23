Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48999 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934194AbXCWUnj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:39 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/19] mac80211 debugfs Kconfig
Message-Id: <20070323204455.0B92548582@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:55 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: johannes@sipsolutions.net <johannes@sipsolutions.net>

This patch adds a configuration option to mac80211 that lets you
enable or disable the debugfs internal state export.

I intentionally made this option not depend on MAC80211_DEBUG
because that option always generates debug messages in the kernel
log; this way you can see the internal state without seeing any
debugging message.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/Kconfig          |    9 +++++++++
 net/mac80211/Makefile         |    2 +-
 net/mac80211/debugfs.h        |    2 +-
 net/mac80211/debugfs_key.h    |    2 +-
 net/mac80211/debugfs_netdev.h |    2 +-
 net/mac80211/debugfs_sta.h    |    2 +-
 net/mac80211/ieee80211_i.h    |    4 ++--
 net/mac80211/ieee80211_key.h  |    2 +-
 net/mac80211/ieee80211_rate.h |    4 ++--
 net/mac80211/rc80211_simple.c |    6 +++---
 net/mac80211/sta_info.h       |    2 +-
 11 files changed, 23 insertions(+), 14 deletions(-)

7eb09815b60aba14a6e3e4bafb5841f13ae75c0f
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index a4f282b..ff2eca3 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -18,6 +18,15 @@ config MAC80211_LEDS
 	This option enables a few LED triggers for different
 	packet receive/transmit events.
 
+config MAC80211_DEBUGFS
+	bool "Export mac80211 internals in DebugFS"
+	depends on MAC80211 && DEBUG_FS
+	---help---
+	  Select this to see extensive information about
+	  the internal state of mac80211 in debugfs.
+
+	  Say N unless you know you need this.
+
 config MAC80211_DEBUG
 	bool "Enable debugging output"
 	depends on MAC80211
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 15eff76..37f6f4c 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -1,7 +1,7 @@
 obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
-mac80211-objs-$(CONFIG_DEBUG_FS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
+mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
 
 mac80211-objs := \
 	ieee80211.o \
diff --git a/net/mac80211/debugfs.h b/net/mac80211/debugfs.h
index e2c7cbb..dd25419 100644
--- a/net/mac80211/debugfs.h
+++ b/net/mac80211/debugfs.h
@@ -1,7 +1,7 @@
 #ifndef __MAC80211_DEBUGFS_H
 #define __MAC80211_DEBUGFS_H
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 extern void debugfs_hw_add(struct ieee80211_local *local);
 extern void debugfs_hw_del(struct ieee80211_local *local);
 extern int mac80211_open_file_generic(struct inode *inode, struct file *file);
diff --git a/net/mac80211/debugfs_key.h b/net/mac80211/debugfs_key.h
index 5de3546..aecfce3 100644
--- a/net/mac80211/debugfs_key.h
+++ b/net/mac80211/debugfs_key.h
@@ -1,7 +1,7 @@
 #ifndef __MAC80211_DEBUGFS_KEY_H
 #define __MAC80211_DEBUGFS_KEY_H
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_key_add(struct ieee80211_local *local,
 			       struct ieee80211_key *key);
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key);
diff --git a/net/mac80211/debugfs_netdev.h b/net/mac80211/debugfs_netdev.h
index 308a52a..96ebbdd 100644
--- a/net/mac80211/debugfs_netdev.h
+++ b/net/mac80211/debugfs_netdev.h
@@ -3,7 +3,7 @@
 #ifndef __IEEE80211_SYSFS_H
 #define __IEEE80211_SYSFS_H
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_change_if_type(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/debugfs_sta.h b/net/mac80211/debugfs_sta.h
index 5a60cd5..574a1cd 100644
--- a/net/mac80211/debugfs_sta.h
+++ b/net/mac80211/debugfs_sta.h
@@ -1,7 +1,7 @@
 #ifndef __MAC80211_DEBUGFS_STA_H
 #define __MAC80211_DEBUGFS_STA_H
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_sta_debugfs_add(struct sta_info *sta);
 void ieee80211_sta_debugfs_remove(struct sta_info *sta);
 #else
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index baf927f..3c10152 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -337,7 +337,7 @@ #define NUM_DEFAULT_KEYS 4
 	int channel_use;
 	int channel_use_raw;
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *debugfsdir;
 	union {
 		struct {
@@ -596,7 +596,7 @@ #endif /* CONFIG_MAC80211_DEBUG_COUNTERS
 
 	int user_space_mlme;
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
 		struct dentry *channel;
 		struct dentry *frequency;
diff --git a/net/mac80211/ieee80211_key.h b/net/mac80211/ieee80211_key.h
index cde2974..c333849 100644
--- a/net/mac80211/ieee80211_key.h
+++ b/net/mac80211/ieee80211_key.h
@@ -83,7 +83,7 @@ #endif
 					* (used only for broadcast keys). */
 	s8 keyidx; /* WEP key index */
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct {
 		struct dentry *stalink;
 		struct dentry *dir;
diff --git a/net/mac80211/ieee80211_rate.h b/net/mac80211/ieee80211_rate.h
index c0c32ae..f021a02 100644
--- a/net/mac80211/ieee80211_rate.h
+++ b/net/mac80211/ieee80211_rate.h
@@ -124,7 +124,7 @@ static inline void rate_control_free_sta
 
 static inline void rate_control_add_sta_debugfs(struct sta_info *sta)
 {
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct rate_control_ref *ref = sta->rate_ctrl;
 	if (sta->debugfs.dir && ref->ops->add_sta_debugfs)
 		ref->ops->add_sta_debugfs(ref->priv, sta->rate_ctrl_priv,
@@ -134,7 +134,7 @@ #endif
 
 static inline void rate_control_remove_sta_debugfs(struct sta_info *sta)
 {
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct rate_control_ref *ref = sta->rate_ctrl;
 	if (ref->ops->remove_sta_debugfs)
 		ref->ops->remove_sta_debugfs(ref->priv, sta->rate_ctrl_priv);
diff --git a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simple.c
index 9702eae..2048cfd 100644
--- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -123,7 +123,7 @@ struct sta_rate_control {
 	u32 tx_avg_rate_sum;
 	u32 tx_avg_rate_num;
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *tx_avg_rate_sum_dentry;
 	struct dentry *tx_avg_rate_num_dentry;
 #endif
@@ -333,7 +333,7 @@ static void rate_control_simple_free_sta
 	kfree(rctrl);
 }
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 
 static int open_file_generic(struct inode *inode, struct file *file)
 {
@@ -406,7 +406,7 @@ static struct rate_control_ops rate_cont
 	.free = rate_control_simple_free,
 	.alloc_sta = rate_control_simple_alloc_sta,
 	.free_sta = rate_control_simple_free_sta,
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	.add_sta_debugfs = rate_control_simple_add_sta_debugfs,
 	.remove_sta_debugfs = rate_control_simple_remove_sta_debugfs,
 #endif
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5213d2c..ed7ca59 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -115,7 +115,7 @@ #endif /* CONFIG_MAC80211_DEBUG_COUNTERS
 
 	u16 listen_interval;
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct sta_info_debugfsdentries {
 		struct dentry *dir;
 		struct dentry *flags;
-- 
1.3.0

