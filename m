Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52036 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab3KMSNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:13:08 -0500
Received: by mail-wg0-f51.google.com with SMTP id m15so783887wgh.18
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 10:13:07 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 2/5] cfg80211: make cfg80211_leave_all() available outside of sysfs
Date: Wed, 13 Nov 2013 19:12:56 +0100
Message-Id: <1384366379-25301-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191314_599501_030380C0)
In-Reply-To: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used later.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/core.c  | 8 ++++++++
 net/wireless/core.h  | 2 ++
 net/wireless/sysfs.c | 8 --------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5d53e49..818871e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -783,6 +783,14 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 	wdev->beacon_interval = 0;
 }
 
+void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
+{
+	struct wireless_dev *wdev;
+
+	list_for_each_entry(wdev, &rdev->wdev_list, list)
+		cfg80211_leave(rdev, wdev);
+}
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state, void *ptr)
 {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5390aeb..1ee0c01 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -459,6 +459,8 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		    struct wireless_dev *wdev);
 
+void cfg80211_leave_all(struct cfg80211_registered_device *rdev);
+
 void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
 
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 9ee6bc1..de9adcf 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -87,14 +87,6 @@ static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 }
 
 #ifdef CONFIG_PM
-static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
-{
-	struct wireless_dev *wdev;
-
-	list_for_each_entry(wdev, &rdev->wdev_list, list)
-		cfg80211_leave(rdev, wdev);
-}
-
 static int wiphy_suspend(struct device *dev, pm_message_t state)
 {
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
-- 
1.8.4.rc3

