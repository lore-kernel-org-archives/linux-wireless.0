Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59104 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529AbaCSJEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 05:04:49 -0400
Received: by mail-pb0-f52.google.com with SMTP id rr13so8660070pbb.11
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 02:04:49 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/3] cfg80211: remove macro ASSERT_RDEV_LOCK(rdev)
Date: Wed, 19 Mar 2014 17:04:36 +0800
Message-Id: <c7fac3c56875d3466c480456b092ef4bac7a75c8.1395219362.git.gamerh2o@gmail.com> (sfid-20140319_100455_212693_B747C5C4)
In-Reply-To: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
References: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
In-Reply-To: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
References: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Macro ASSERT_RDEV_LOCK(rdev) is equal to ASSERT_RTNL(), so replace it
with ASSERT_RTNL() and remove it.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/core.h     | 1 -
 net/wireless/sme.c      | 1 -
 net/wireless/util.c     | 3 +--
 net/wireless/wext-sme.c | 2 +-
 4 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 766aabc..6ef60d3 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -166,7 +166,6 @@ static inline void wdev_unlock(struct wireless_dev *wdev)
 	mutex_unlock(&wdev->mtx);
 }
 
-#define ASSERT_RDEV_LOCK(rdev) ASSERT_RTNL()
 #define ASSERT_WDEV_LOCK(wdev) lockdep_assert_held(&(wdev)->mtx)
 
 static inline bool cfg80211_has_monitors_only(struct cfg80211_registered_device *rdev)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f04d4c3..acdcb4a8 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -64,7 +64,6 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	int n_channels, err;
 
 	ASSERT_RTNL();
-	ASSERT_RDEV_LOCK(rdev);
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (rdev->scan_req || rdev->scan_msg)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 57b3ce7..114bbdf 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -838,7 +838,6 @@ void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev)
 	struct wireless_dev *wdev;
 
 	ASSERT_RTNL();
-	ASSERT_RDEV_LOCK(rdev);
 
 	list_for_each_entry(wdev, &rdev->wdev_list, list)
 		cfg80211_process_wdev_events(wdev);
@@ -851,7 +850,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	int err;
 	enum nl80211_iftype otype = dev->ieee80211_ptr->iftype;
 
-	ASSERT_RDEV_LOCK(rdev);
+	ASSERT_RTNL();
 
 	/* don't support changing VLANs, you just re-create them */
 	if (otype == NL80211_IFTYPE_AP_VLAN)
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 14c9a25..86c331a 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -21,7 +21,7 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 	const u8 *prev_bssid = NULL;
 	int err, i;
 
-	ASSERT_RDEV_LOCK(rdev);
+	ASSERT_RTNL();
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (!netif_running(wdev->netdev))
-- 
1.8.5.3

