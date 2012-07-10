Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2GJRmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:42:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix locking and lockdep complaints
Date: Tue, 10 Jul 2012 19:41:56 +0200
Message-Id: <1341942116-17307-1-git-send-email-johannes@sipsolutions.net> (sfid-20120710_194205_535365_EF406882)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To call cfg80211_get_chan_state() we need to lock
the wdev, so we need to lock the wdev_iter mutex
in cfg80211_can_use_iftype_chan(). This needs to
use nested locking for lockdep.

Also, cfg80211_get_chan_state() doesn't actually
use the rdev, so remove that completely including
the lock assertion that isn't needed.

Reported-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/chan.c |    4 +---
 net/wireless/core.h |    3 +--
 net/wireless/util.c |   11 ++++++++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 434c56b..1cc4b7c 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -103,15 +103,13 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 }
 
 void
-cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
-		        struct wireless_dev *wdev,
+cfg80211_get_chan_state(struct wireless_dev *wdev,
 		        struct ieee80211_channel **chan,
 		        enum cfg80211_chan_mode *chanmode)
 {
 	*chan = NULL;
 	*chanmode = CHAN_MODE_UNDEFINED;
 
-	ASSERT_RDEV_LOCK(rdev);
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (!netif_running(wdev->netdev))
diff --git a/net/wireless/core.h b/net/wireless/core.h
index eae5a25..bac97da 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -463,8 +463,7 @@ cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
 }
 
 void
-cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
-		        struct wireless_dev *wdev,
+cfg80211_get_chan_state(struct wireless_dev *wdev,
 		        struct ieee80211_channel **chan,
 		        enum cfg80211_chan_mode *chanmode);
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f7a0647..26f8cd3 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1059,7 +1059,16 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		if (rdev->wiphy.software_iftypes & BIT(wdev_iter->iftype))
 			continue;
 
-		cfg80211_get_chan_state(rdev, wdev_iter, &ch, &chmode);
+		/*
+		 * We may be holding the "wdev" mutex, but now need to lock
+		 * wdev_iter. This is OK because once we get here wdev_iter
+		 * is not wdev (tested above), but we need to use the nested
+		 * locking for lockdep.
+		 */
+		mutex_lock_nested(&wdev_iter->mtx, 1);
+		__acquire(wdev_iter->mtx);
+		cfg80211_get_chan_state(wdev_iter, &ch, &chmode);
+		wdev_unlock(wdev_iter);
 
 		switch (chmode) {
 		case CHAN_MODE_UNDEFINED:
-- 
1.7.10.4

