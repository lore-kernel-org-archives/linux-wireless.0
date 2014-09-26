Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59725 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaIZXY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 19:24:26 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 1/4] wireless:  expose set-wiphy-name method to other modules.
Date: Fri, 26 Sep 2014 16:24:13 -0700
Message-Id: <1411773856-25042-1-git-send-email-greearb@candelatech.com> (sfid-20140927_012441_483840_20B8643D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This will let hw-sim create wiphy objects with a specific
name.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Fix checkpatch warnings (char * instead of char*)

 include/net/cfg80211.h | 5 +++++
 net/wireless/core.c    | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3a13aab..e1641e6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4854,6 +4854,11 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 gfp_t gfp);
 
+/*
+ * Attempt to rename a device.  Acquire RTNL before calling.
+ */
+int cfg80211_dev_rename_wiphy(struct wiphy *wiphy, char *newname);
+
 /**
  * cfg80211_shutdown_all_interfaces - shut down all interfaces for a wiphy
  * @wiphy: the wiphy to shut down
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f52a4cd..4d7e17c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -86,6 +86,15 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 	return &rdev->wiphy;
 }
 
+int cfg80211_dev_rename_wiphy(struct wiphy *wiphy, char *newname)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = wiphy_to_rdev(wiphy);
+	return cfg80211_dev_rename(rdev, newname);
+}
+EXPORT_SYMBOL_GPL(cfg80211_dev_rename_wiphy);
+
 int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			char *newname)
 {
-- 
1.7.11.7

