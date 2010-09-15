Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0IOL2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 07:28:19 -0400
Subject: [PATCH] cfg80211/mac80211: use lockdep_assert_held
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 13:28:15 +0200
Message-ID: <1284550096.3842.66.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of using a WARN_ON(!mutex_is_locked())
use lockdep_assert_held() which compiles away
completely when lockdep isn't enabled, and
also is a more accurate assertion since it
checks that the current thread is holding the
mutex.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c     |    2 +-
 net/mac80211/key.c      |    2 +-
 net/mac80211/mlme.c     |    2 +-
 net/mac80211/sta_info.c |    2 +-
 net/mac80211/util.c     |    4 ++--
 net/wireless/core.h     |    9 ++++++---
 net/wireless/reg.c      |    6 +++++-
 7 files changed, 17 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/mac80211/chan.c	2010-09-15 13:16:28.000000000 +0200
+++ wireless-testing/net/mac80211/chan.c	2010-09-15 13:17:15.000000000 +0200
@@ -11,7 +11,7 @@ __ieee80211_get_channel_mode(struct ieee
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	WARN_ON(!mutex_is_locked(&local->iflist_mtx));
+	lockdep_assert_held(&local->iflist_mtx);
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata == ignore)
--- wireless-testing.orig/net/mac80211/key.c	2010-09-15 13:16:30.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2010-09-15 13:17:40.000000000 +0200
@@ -49,7 +49,7 @@ static const u8 bcast_addr[ETH_ALEN] = {
 
 static void assert_key_lock(struct ieee80211_local *local)
 {
-	WARN_ON(!mutex_is_locked(&local->key_mtx));
+	lockdep_assert_held(&local->key_mtx);
 }
 
 static struct ieee80211_sta *get_sta_for_key(struct ieee80211_key *key)
--- wireless-testing.orig/net/mac80211/mlme.c	2010-09-15 13:16:28.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-09-15 13:17:15.000000000 +0200
@@ -92,7 +92,7 @@ enum rx_mgmt_action {
 /* utils */
 static inline void ASSERT_MGD_MTX(struct ieee80211_if_managed *ifmgd)
 {
-	WARN_ON(!mutex_is_locked(&ifmgd->mtx));
+	lockdep_assert_held(&ifmgd->mtx);
 }
 
 /*
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-09-15 13:16:29.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-09-15 13:17:40.000000000 +0200
@@ -280,7 +280,7 @@ static int sta_info_finish_insert(struct
 	unsigned long flags;
 	int err = 0;
 
-	WARN_ON(!mutex_is_locked(&local->sta_mtx));
+	lockdep_assert_held(&local->sta_mtx);
 
 	/* notify driver */
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
--- wireless-testing.orig/net/mac80211/util.c	2010-09-15 13:17:08.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-09-15 13:17:36.000000000 +0200
@@ -1296,9 +1296,9 @@ void ieee80211_recalc_smps(struct ieee80
 	int count = 0;
 
 	if (forsdata)
-		WARN_ON(!mutex_is_locked(&forsdata->u.mgd.mtx));
+		lockdep_assert_held(&forsdata->u.mgd.mtx);
 
-	WARN_ON(!mutex_is_locked(&local->iflist_mtx));
+	lockdep_assert_held(&local->iflist_mtx);
 
 	/*
 	 * This function could be improved to handle multiple
--- wireless-testing.orig/net/wireless/core.h	2010-09-15 13:19:31.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2010-09-15 13:21:19.000000000 +0200
@@ -95,7 +95,10 @@ extern struct mutex cfg80211_mutex;
 extern struct list_head cfg80211_rdev_list;
 extern int cfg80211_rdev_list_generation;
 
-#define assert_cfg80211_lock() WARN_ON(!mutex_is_locked(&cfg80211_mutex))
+static inline void assert_cfg80211_lock(void)
+{
+	lockdep_assert_held(&cfg80211_mutex);
+}
 
 /*
  * You can use this to mark a wiphy_idx as not having an associated wiphy.
@@ -202,8 +205,8 @@ static inline void wdev_unlock(struct wi
 	mutex_unlock(&wdev->mtx);
 }
 
-#define ASSERT_RDEV_LOCK(rdev) WARN_ON(!mutex_is_locked(&(rdev)->mtx));
-#define ASSERT_WDEV_LOCK(wdev) WARN_ON(!mutex_is_locked(&(wdev)->mtx));
+#define ASSERT_RDEV_LOCK(rdev) lockdep_assert_held(&(rdev)->mtx)
+#define ASSERT_WDEV_LOCK(wdev) lockdep_assert_held(&(wdev)->mtx)
 
 enum cfg80211_event_type {
 	EVENT_CONNECT_RESULT,
--- wireless-testing.orig/net/wireless/reg.c	2010-09-15 13:19:31.000000000 +0200
+++ wireless-testing/net/wireless/reg.c	2010-09-15 13:20:18.000000000 +0200
@@ -74,7 +74,11 @@ const struct ieee80211_regdomain *cfg802
  *     - last_request
  */
 static DEFINE_MUTEX(reg_mutex);
-#define assert_reg_lock() WARN_ON(!mutex_is_locked(&reg_mutex))
+
+static inline void assert_reg_lock(void)
+{
+	lockdep_assert_held(&reg_mutex);
+}
 
 /* Used to queue up regulatory hints */
 static LIST_HEAD(reg_requests_list);


