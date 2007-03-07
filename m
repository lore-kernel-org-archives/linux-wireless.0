Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565AbXCGQvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 11:51:48 -0500
Message-Id: <20070307164647.839947000@sipsolutions.net>
References: <20070307164531.910923000@sipsolutions.net>
Date: Wed, 07 Mar 2007 17:45:35 +0100
From: johannes@sipsolutions.net
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH (v3) 4/4] mac80211 debugfs Kconfig
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a configuration option to mac80211 that lets you
enable or disable the debugfs internal state export.

I intentionally made this option not depend on MAC80211_DEBUG
because that option always generates debug messages in the kernel
log; this way you can see the internal state without seeing any
debugging message.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

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

--- wireless-dev.orig/net/mac80211/Kconfig	2007-03-07 13:03:43.954710923 +0100
+++ wireless-dev/net/mac80211/Kconfig	2007-03-07 13:04:00.514710923 +0100
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
--- wireless-dev.orig/net/mac80211/Makefile	2007-03-07 13:03:58.974710923 +0100
+++ wireless-dev/net/mac80211/Makefile	2007-03-07 13:04:00.514710923 +0100
@@ -1,7 +1,7 @@
 obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
-mac80211-objs-$(CONFIG_DEBUG_FS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
+mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
 
 mac80211-objs := \
 	ieee80211.o \
--- wireless-dev.orig/net/mac80211/debugfs.h	2007-03-07 13:03:56.054710923 +0100
+++ wireless-dev/net/mac80211/debugfs.h	2007-03-07 13:04:00.514710923 +0100
@@ -1,7 +1,7 @@
 #ifndef __MAC80211_DEBUGFS_H
 #define __MAC80211_DEBUGFS_H
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 extern void debugfs_hw_add(struct ieee80211_local *local);
 extern void debugfs_hw_del(struct ieee80211_local *local);
 extern int mac80211_open_file_generic(struct inode *inode, struct file *file);
--- wireless-dev.orig/net/mac80211/debugfs_key.h	2007-03-07 13:03:58.994710923 +0100
+++ wireless-dev/net/mac80211/debugfs_key.h	2007-03-07 13:04:00.514710923 +0100
@@ -1,7 +1,7 @@
 #ifndef __MAC80211_DEBUGFS_KEY_H
 #define __MAC80211_DEBUGFS_KEY_H
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_key_add(struct ieee80211_local *local,
 			       struct ieee80211_key *key);
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key);
--- wireless-dev.orig/net/mac80211/debugfs_netdev.h	2007-03-07 13:03:58.974710923 +0100
+++ wireless-dev/net/mac80211/debugfs_netdev.h	2007-03-07 13:04:00.514710923 +0100
@@ -3,7 +3,7 @@
 #ifndef __IEEE80211_SYSFS_H
 #define __IEEE80211_SYSFS_H
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_change_if_type(struct ieee80211_sub_if_data *sdata,
--- wireless-dev.orig/net/mac80211/debugfs_sta.h	2007-03-07 13:03:56.074710923 +0100
+++ wireless-dev/net/mac80211/debugfs_sta.h	2007-03-07 13:04:00.514710923 +0100
@@ -1,7 +1,7 @@
 #ifndef __MAC80211_DEBUGFS_STA_H
 #define __MAC80211_DEBUGFS_STA_H
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_sta_debugfs_add(struct sta_info *sta);
 void ieee80211_sta_debugfs_remove(struct sta_info *sta);
 #else
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-03-07 13:03:58.984710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-03-07 13:04:00.514710923 +0100
@@ -337,7 +337,7 @@ struct ieee80211_sub_if_data {
 	int channel_use;
 	int channel_use_raw;
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *debugfsdir;
 	union {
 		struct {
@@ -595,7 +595,7 @@ struct ieee80211_local {
 
 	int user_space_mlme;
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
 		struct dentry *channel;
 		struct dentry *frequency;
--- wireless-dev.orig/net/mac80211/ieee80211_key.h	2007-03-07 13:03:58.984710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_key.h	2007-03-07 13:04:00.514710923 +0100
@@ -83,7 +83,7 @@ struct ieee80211_key {
 					* (used only for broadcast keys). */
 	s8 keyidx; /* WEP key index */
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct {
 		struct dentry *stalink;
 		struct dentry *dir;
--- wireless-dev.orig/net/mac80211/rc80211_simple.c	2007-03-07 13:03:56.084710923 +0100
+++ wireless-dev/net/mac80211/rc80211_simple.c	2007-03-07 13:04:00.514710923 +0100
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
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-03-07 13:03:56.074710923 +0100
+++ wireless-dev/net/mac80211/sta_info.h	2007-03-07 13:04:00.524710923 +0100
@@ -115,7 +115,7 @@ struct sta_info {
 
 	u16 listen_interval;
 
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct sta_info_debugfsdentries {
 		struct dentry *dir;
 		struct dentry *flags;
--- wireless-dev.orig/net/mac80211/ieee80211_rate.h	2007-03-07 13:03:56.084710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_rate.h	2007-03-07 13:04:00.524710923 +0100
@@ -124,7 +124,7 @@ static inline void rate_control_free_sta
 
 static inline void rate_control_add_sta_debugfs(struct sta_info *sta)
 {
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct rate_control_ref *ref = sta->rate_ctrl;
 	if (sta->debugfs.dir && ref->ops->add_sta_debugfs)
 		ref->ops->add_sta_debugfs(ref->priv, sta->rate_ctrl_priv,
@@ -134,7 +134,7 @@ static inline void rate_control_add_sta_
 
 static inline void rate_control_remove_sta_debugfs(struct sta_info *sta)
 {
-#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	struct rate_control_ref *ref = sta->rate_ctrl;
 	if (ref->ops->remove_sta_debugfs)
 		ref->ops->remove_sta_debugfs(ref->priv, sta->rate_ctrl_priv);

--

