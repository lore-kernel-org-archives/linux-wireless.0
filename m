Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54731 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932883AbXBSWjS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:18 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/12] d80211: trivial cleanups in ieee80211_i.h
Message-Id: <20070219223947.98494484A7@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:47 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This removes some unused things and fixes a typo.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/d80211/ieee80211.c   |    1 -
 net/d80211/ieee80211_i.h |    5 +----
 2 files changed, 1 insertions(+), 5 deletions(-)

35b4c9eca49e0464592bebdf36989d77f928ebc5
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 82daeb8..bbcefa9 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -4559,7 +4559,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	spin_lock_init(&local->sub_if_lock);
 	INIT_LIST_HEAD(&local->sub_if_list);
 
-        spin_lock_init(&local->generic_lock);
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
 	init_timer(&local->stat_timer);
 	local->stat_timer.function = ieee80211_stat_refresh;
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 5ab9eb5..bb8fc83 100644
--- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -350,7 +350,7 @@ struct ieee80211_local {
 	struct class_device class_dev;
 
 	enum {
-		IEEE80211_DEV_UNITIALIZED = 0,
+		IEEE80211_DEV_UNINITIALIZED = 0,
 		IEEE80211_DEV_REGISTERED,
 		IEEE80211_DEV_UNREGISTERED,
 	} reg_state;
@@ -368,7 +368,6 @@ #define IEEE80211_IRQSAFE_QUEUE_LIMIT 12
 		ieee80211_tx_status_msg = 2
 	} ieee80211_msg_enum;
 
-        spinlock_t generic_lock;
 	/* Station data structures */
 	struct kset sta_kset;
 	spinlock_t sta_lock; /* mutex for STA data structures */
@@ -479,8 +478,6 @@ #endif
         u32 stat_time;
         struct timer_list stat_timer;
 
-        struct proc_dir_entry *proc, *proc_sta, *proc_iface;
-
 	struct work_struct sta_proc_add;
 
 	enum {
-- 
1.3.0

