Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3EJNoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 09:44:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 1/4] cfg80211: move cfg80211_get_dev_from_ifindex under wext
Date: Fri, 10 May 2013 15:43:53 +0200
Message-Id: <1368193436-26618-1-git-send-email-johannes@sipsolutions.net> (sfid-20130510_154409_378763_77E240C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function is only used and needed by the wext code
for scanning, so move it there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 21 ---------------------
 net/wireless/core.h |  4 ----
 net/wireless/scan.c | 21 +++++++++++++++++++++
 3 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 68f0c96..4e0b52f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -90,27 +90,6 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 	return &rdev->wiphy;
 }
 
-struct cfg80211_registered_device *
-cfg80211_get_dev_from_ifindex(struct net *net, int ifindex)
-{
-	struct cfg80211_registered_device *rdev = ERR_PTR(-ENODEV);
-	struct net_device *dev;
-
-	mutex_lock(&cfg80211_mutex);
-	dev = dev_get_by_index(net, ifindex);
-	if (!dev)
-		goto out;
-	if (dev->ieee80211_ptr) {
-		rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
-		mutex_lock(&rdev->mtx);
-	} else
-		rdev = ERR_PTR(-ENODEV);
-	dev_put(dev);
- out:
-	mutex_unlock(&cfg80211_mutex);
-	return rdev;
-}
-
 /* requires cfg80211_mutex to be held */
 int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			char *newname)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index fd35dae..95b2907 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -164,10 +164,6 @@ int get_wiphy_idx(struct wiphy *wiphy);
 /* requires cfg80211_rdev_mutex to be held! */
 struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx);
 
-/* identical to cfg80211_get_dev_from_info but only operate on ifindex */
-extern struct cfg80211_registered_device *
-cfg80211_get_dev_from_ifindex(struct net *net, int ifindex);
-
 int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			  struct net *net);
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index fd99ea4..2ce44a7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1040,6 +1040,27 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 
 #ifdef CONFIG_CFG80211_WEXT
+static struct cfg80211_registered_device *
+cfg80211_get_dev_from_ifindex(struct net *net, int ifindex)
+{
+	struct cfg80211_registered_device *rdev = ERR_PTR(-ENODEV);
+	struct net_device *dev;
+
+	mutex_lock(&cfg80211_mutex);
+	dev = dev_get_by_index(net, ifindex);
+	if (!dev)
+		goto out;
+	if (dev->ieee80211_ptr) {
+		rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
+		mutex_lock(&rdev->mtx);
+	} else
+		rdev = ERR_PTR(-ENODEV);
+	dev_put(dev);
+ out:
+	mutex_unlock(&cfg80211_mutex);
+	return rdev;
+}
+
 int cfg80211_wext_siwscan(struct net_device *dev,
 			  struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
-- 
1.8.0

