Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59899 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030285AbXD3Ra6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2007 13:30:58 -0400
Date: Mon, 30 Apr 2007 19:31:33 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: rename remaining mentions of sysfs and procfs
Message-ID: <20070430193133.70479d27@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove or rename references to sysfs and procfs. #ifdef some more code that
is not needed when the debugfs support is not built.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/mac80211/debugfs_key.c    |    1 -
 net/mac80211/debugfs_netdev.h |    8 ++++----
 net/mac80211/ieee80211_i.h    |    4 +++-
 net/mac80211/sta_info.c       |   34 ++++++++++++++++++++--------------
 net/mac80211/sta_info.h       |    8 +++++---
 5 files changed, 32 insertions(+), 23 deletions(-)

--- mac80211.orig/net/mac80211/debugfs_key.c
+++ mac80211/net/mac80211/debugfs_key.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/kobject.h>
-#include <linux/sysfs.h>
 #include "ieee80211_i.h"
 #include "ieee80211_key.h"
 #include "debugfs.h"
--- mac80211.orig/net/mac80211/debugfs_netdev.h
+++ mac80211/net/mac80211/debugfs_netdev.h
@@ -1,7 +1,7 @@
-/* routines exported for sysfs handling */
+/* routines exported for debugfs handling */
 
-#ifndef __IEEE80211_SYSFS_H
-#define __IEEE80211_SYSFS_H
+#ifndef __IEEE80211_DEBUGFS_NETDEV_H
+#define __IEEE80211_DEBUGFS_NETDEV_H
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata);
@@ -27,4 +27,4 @@ static inline void ieee80211_debugfs_net
 {}
 #endif
 
-#endif /* __IEEE80211_SYSFS_H */
+#endif /* __IEEE80211_DEBUGFS_NETDEV_H */
--- mac80211.orig/net/mac80211/ieee80211_i.h
+++ mac80211/net/mac80211/ieee80211_i.h
@@ -514,7 +514,9 @@ struct ieee80211_local {
 	u32 stat_time;
 	struct timer_list stat_timer;
 
-	struct work_struct sta_proc_add;
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct work_struct sta_debugfs_add;
+#endif
 
 	enum {
 		STA_ANTENNA_SEL_AUTO = 0,
--- mac80211.orig/net/mac80211/sta_info.c
+++ mac80211/net/mac80211/sta_info.c
@@ -177,16 +177,18 @@ struct sta_info * sta_info_add(struct ie
 	       local->mdev->name, MAC_ARG(addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
+#ifdef CONFIG_MAC80211_DEBUGFS
 	if (!in_interrupt()) {
-		sta->sysfs_registered = 1;
+		sta->debugfs_registered = 1;
 		ieee80211_sta_debugfs_add(sta);
 		rate_control_add_sta_debugfs(sta);
 	} else {
-		/* procfs entry adding might sleep, so schedule process context
-		 * task for adding proc entry for STAs that do not yet have
-		 * one. */
-		queue_work(local->hw.workqueue, &local->sta_proc_add);
+		/* debugfs entry adding might sleep, so schedule process
+		 * context task for adding entry for STAs that do not yet
+		 * have one. */
+		queue_work(local->hw.workqueue, &local->sta_debugfs_add);
 	}
+#endif
 
 	return sta;
 }
@@ -274,10 +276,12 @@ void sta_info_free(struct sta_info *sta,
 		sta->key_idx_compression = HW_KEY_IDX_INVALID;
 	}
 
+#ifdef CONFIG_MAC80211_DEBUGFS
 	if (in_atomic()) {
 		list_add(&sta->list, &local->deleted_sta_list);
-		queue_work(local->hw.workqueue, &local->sta_proc_add);
+		queue_work(local->hw.workqueue, &local->sta_debugfs_add);
 	} else
+#endif
 		finish_sta_info_free(local, sta);
 }
 
@@ -351,11 +355,11 @@ static void sta_info_cleanup(unsigned lo
 	add_timer(&local->sta_cleanup);
 }
 
-
-static void sta_info_proc_add_task(struct work_struct *work)
+#ifdef CONFIG_MAC80211_DEBUGFS
+static void sta_info_debugfs_add_task(struct work_struct *work)
 {
 	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, sta_proc_add);
+		container_of(work, struct ieee80211_local, sta_debugfs_add);
 	struct sta_info *sta, *tmp;
 
 	while (1) {
@@ -376,7 +380,7 @@ static void sta_info_proc_add_task(struc
 		sta = NULL;
 		spin_lock_bh(&local->sta_lock);
 		list_for_each_entry(tmp, &local->sta_list, list) {
-			if (!tmp->sysfs_registered) {
+			if (!tmp->debugfs_registered) {
 				sta = tmp;
 				__sta_info_get(sta);
 				break;
@@ -387,13 +391,13 @@ static void sta_info_proc_add_task(struc
 		if (!sta)
 			break;
 
-		sta->sysfs_registered = 1;
+		sta->debugfs_registered = 1;
 		ieee80211_sta_debugfs_add(sta);
 		rate_control_add_sta_debugfs(sta);
 		sta_info_put(sta);
 	}
 }
-
+#endif
 
 void sta_info_init(struct ieee80211_local *local)
 {
@@ -406,7 +410,9 @@ void sta_info_init(struct ieee80211_loca
 	local->sta_cleanup.data = (unsigned long) local;
 	local->sta_cleanup.function = sta_info_cleanup;
 
-	INIT_WORK(&local->sta_proc_add, sta_info_proc_add_task);
+#ifdef CONFIG_MAC80211_DEBUGFS
+	INIT_WORK(&local->sta_debugfs_add, sta_info_debugfs_add_task);
+#endif
 }
 
 int sta_info_start(struct ieee80211_local *local)
@@ -423,7 +429,7 @@ void sta_info_stop(struct ieee80211_loca
 
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
 		/* sta_info_free must be called with 0 as the last
-		 * parameter to ensure all sysfs sta entries are
+		 * parameter to ensure all debugfs sta entries are
 		 * unregistered. We don't need locking at this
 		 * point. */
 		sta_info_free(sta, 0);
--- mac80211.orig/net/mac80211/sta_info.h
+++ mac80211/net/mac80211/sta_info.h
@@ -99,9 +99,11 @@ struct sta_info {
 				  * filtering; used only if sta->key is not
 				  * set */
 
-	unsigned int sysfs_registered:1;
-	unsigned int assoc_ap:1; /* whether this is an AP that we are
-				  * associated with as a client */
+#ifdef CONFIG_MAC80211_DEBUGFS
+	int debugfs_registered;
+#endif
+	int assoc_ap; /* whether this is an AP that we are
+		       * associated with as a client */
 
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
 	u32 wpa_trigger;


-- 
Jiri Benc
SUSE Labs
