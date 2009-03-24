Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZCXIfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 04:35:52 -0400
Subject: [PATCH] cfg80211: fix locking in nl80211_set_wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 09:35:46 +0100
Message-Id: <1237883746.4320.0.camel@johannes.local> (sfid-20090324_093555_946774_B8648E1A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis reports that there's a circular locking dependency;
this is because cfg80211_dev_rename() will acquire the
cfg80211_mutex while the device mutex is held, while
this normally is done the other way around. The solution
is to open-code the device-getting in nl80211_set_wiphy
and require holding the mutex around cfg80211_dev_rename
rather than acquiring it within.

Also fix a bug -- rtnl locking is expected by drivers so
we need to provide it.

Reported-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c    |   30 ++++++++++--------------------
 net/wireless/core.h    |    3 +++
 net/wireless/nl80211.c |   28 ++++++++++++++++++++--------
 3 files changed, 33 insertions(+), 28 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-03-24 09:20:35.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-03-24 09:34:50.000000000 +0100
@@ -366,16 +366,26 @@ static int nl80211_set_wiphy(struct sk_b
 	int result = 0, rem_txq_params = 0;
 	struct nlattr *nl_txq_params;
 
-	rdev = cfg80211_get_dev_from_info(info);
-	if (IS_ERR(rdev))
-		return PTR_ERR(rdev);
+	rtnl_lock();
+
+	mutex_lock(&cfg80211_mutex);
+
+	rdev = __cfg80211_drv_from_info(info);
+	if (IS_ERR(rdev)) {
+		result = PTR_ERR(rdev);
+		goto unlock;
+	}
 
-	if (info->attrs[NL80211_ATTR_WIPHY_NAME]) {
+	mutex_lock(&rdev->mtx);
+
+	if (info->attrs[NL80211_ATTR_WIPHY_NAME])
 		result = cfg80211_dev_rename(
 			rdev, nla_data(info->attrs[NL80211_ATTR_WIPHY_NAME]));
-		if (result)
-			goto bad_res;
-	}
+
+	mutex_unlock(&cfg80211_mutex);
+
+	if (result)
+		goto bad_res;
 
 	if (info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS]) {
 		struct ieee80211_txq_params txq_params;
@@ -471,7 +481,9 @@ static int nl80211_set_wiphy(struct sk_b
 
 
  bad_res:
-	cfg80211_put_dev(rdev);
+	mutex_unlock(&rdev->mtx);
+ unlock:
+	rtnl_unlock();
 	return result;
 }
 
--- wireless-testing.orig/net/wireless/core.c	2009-03-24 09:20:34.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2009-03-24 09:20:53.000000000 +0100
@@ -87,7 +87,7 @@ struct wiphy *wiphy_idx_to_wiphy(int wip
 }
 
 /* requires cfg80211_mutex to be held! */
-static struct cfg80211_registered_device *
+struct cfg80211_registered_device *
 __cfg80211_drv_from_info(struct genl_info *info)
 {
 	int ifindex;
@@ -176,13 +176,14 @@ void cfg80211_put_dev(struct cfg80211_re
 	mutex_unlock(&drv->mtx);
 }
 
+/* requires cfg80211_mutex to be held */
 int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			char *newname)
 {
 	struct cfg80211_registered_device *drv;
 	int wiphy_idx, taken = -1, result, digits;
 
-	mutex_lock(&cfg80211_mutex);
+	assert_cfg80211_lock();
 
 	/* prohibit calling the thing phy%d when %d is not its number */
 	sscanf(newname, PHY_NAME "%d%n", &wiphy_idx, &taken);
@@ -195,30 +196,23 @@ int cfg80211_dev_rename(struct cfg80211_
 		 * deny the name if it is phy<idx> where <idx> is printed
 		 * without leading zeroes. taken == strlen(newname) here
 		 */
-		result = -EINVAL;
 		if (taken == strlen(PHY_NAME) + digits)
-			goto out_unlock;
+			return -EINVAL;
 	}
 
 
 	/* Ignore nop renames */
-	result = 0;
 	if (strcmp(newname, dev_name(&rdev->wiphy.dev)) == 0)
-		goto out_unlock;
+		return 0;
 
 	/* Ensure another device does not already have this name. */
-	list_for_each_entry(drv, &cfg80211_drv_list, list) {
-		result = -EINVAL;
+	list_for_each_entry(drv, &cfg80211_drv_list, list)
 		if (strcmp(newname, dev_name(&drv->wiphy.dev)) == 0)
-			goto out_unlock;
-	}
+			return -EINVAL;
 
-	/* this will only check for collisions in sysfs
-	 * which is not even always compiled in.
-	 */
 	result = device_rename(&rdev->wiphy.dev, newname);
 	if (result)
-		goto out_unlock;
+		return result;
 
 	if (rdev->wiphy.debugfsdir &&
 	    !debugfs_rename(rdev->wiphy.debugfsdir->d_parent,
@@ -228,13 +222,9 @@ int cfg80211_dev_rename(struct cfg80211_
 		printk(KERN_ERR "cfg80211: failed to rename debugfs dir to %s!\n",
 		       newname);
 
-	result = 0;
-out_unlock:
-	mutex_unlock(&cfg80211_mutex);
-	if (result == 0)
-		nl80211_notify_dev_rename(rdev);
+	nl80211_notify_dev_rename(rdev);
 
-	return result;
+	return 0;
 }
 
 /* exported functions */
--- wireless-testing.orig/net/wireless/core.h	2009-03-24 09:20:34.000000000 +0100
+++ wireless-testing/net/wireless/core.h	2009-03-24 09:20:53.000000000 +0100
@@ -99,6 +99,9 @@ struct cfg80211_internal_bss {
 struct cfg80211_registered_device *cfg80211_drv_by_wiphy_idx(int wiphy_idx);
 int get_wiphy_idx(struct wiphy *wiphy);
 
+struct cfg80211_registered_device *
+__cfg80211_drv_from_info(struct genl_info *info);
+
 /*
  * This function returns a pointer to the driver
  * that the genl_info item that is passed refers to.


