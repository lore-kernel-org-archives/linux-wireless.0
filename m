Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out-171.synserver.de ([212.40.185.171]:1036 "EHLO
	smtp-out-171.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbbEPMf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 08:35:59 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] cfg80211: Switch to PM ops
Date: Sat, 16 May 2015 14:35:54 +0200
Message-Id: <1431779754-12106-1-git-send-email-lars@metafoo.de> (sfid-20150516_143604_721610_63156145)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dev_pm_ops instead of the legacy suspend/resume callbacks for the wiphy
class suspend and resume operations.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 net/wireless/sysfs.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 9ee6bc1..9cee022 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -86,7 +86,7 @@ static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
 {
 	struct wireless_dev *wdev;
@@ -95,7 +95,7 @@ static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
 		cfg80211_leave(rdev, wdev);
 }
 
-static int wiphy_suspend(struct device *dev, pm_message_t state)
+static int wiphy_suspend(struct device *dev)
 {
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
 	int ret = 0;
@@ -136,6 +136,11 @@ static int wiphy_resume(struct device *dev)
 
 	return ret;
 }
+
+static SIMPLE_DEV_PM_OPS(wiphy_pm_ops, wiphy_suspend, wiphy_resume);
+#define WIPHY_PM_OPS (&wiphy_pm_ops)
+#else
+#define WIPHY_PM_OPS NULL
 #endif
 
 static const void *wiphy_namespace(struct device *d)
@@ -151,10 +156,7 @@ struct class ieee80211_class = {
 	.dev_release = wiphy_dev_release,
 	.dev_groups = ieee80211_groups,
 	.dev_uevent = wiphy_uevent,
-#ifdef CONFIG_PM
-	.suspend = wiphy_suspend,
-	.resume = wiphy_resume,
-#endif
+	.pm = WIPHY_PM_OPS,
 	.ns_type = &net_ns_type_operations,
 	.namespace = wiphy_namespace,
 };
-- 
1.8.0

