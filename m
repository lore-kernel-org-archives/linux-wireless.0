Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44049 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaHSJgD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 05:36:03 -0400
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH v3] cfg80211: Reorder wiphy_register/unregister() notifications relevantly
Date: Tue, 19 Aug 2014 12:35:57 +0300
Message-Id: <1408440957-3870-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20140819_113607_635942_2A48EC59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently it can send regulatory domain change notification before any
NEW_WIPHY notification. Moreover, if rfill_register() fails, calling
wiphy_unregister() will send a DEL_WIPHY though no NEW_WIPHY had been
sent previously.

Thus reordering so it properly notifies NEW_WIPHY before any other.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---

Reusing "registered" marker to know whether it sent NEW_WIPHY yet or not.
Thus if wiphy_unregister() is called du to rfkill registration failure, it
won't send DEL_WIPHY.

 net/wireless/core.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index afee5e0..08162e8 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -635,6 +635,21 @@ int wiphy_register(struct wiphy *wiphy)
 	if (IS_ERR(rdev->wiphy.debugfsdir))
 		rdev->wiphy.debugfsdir = NULL;
 
+	cfg80211_debugfs_rdev_add(rdev);
+	rtnl_unlock();
+
+	res = rfkill_register(rdev->rfkill);
+	if (res) {
+		rfkill_destroy(rdev->rfkill);
+		rdev->rfkill = NULL;
+		wiphy_unregister(&rdev->wiphy);
+		return res;
+	}
+
+	rtnl_lock();
+
+	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
+
 	if (wiphy->regulatory_flags & REGULATORY_CUSTOM_REG) {
 		struct regulatory_request request;
 
@@ -646,21 +661,9 @@ int wiphy_register(struct wiphy *wiphy)
 		nl80211_send_reg_change_event(&request);
 	}
 
-	cfg80211_debugfs_rdev_add(rdev);
-
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 
-	res = rfkill_register(rdev->rfkill);
-	if (res) {
-		rfkill_destroy(rdev->rfkill);
-		rdev->rfkill = NULL;
-		wiphy_unregister(&rdev->wiphy);
-		return res;
-	}
-
-	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
-
 	return 0;
 }
 EXPORT_SYMBOL(wiphy_register);
@@ -699,8 +702,10 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rfkill_unregister(rdev->rfkill);
 
 	rtnl_lock();
-	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
-	rdev->wiphy.registered = false;
+	if (rdev->wiphy.registered) {
+		nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
+		rdev->wiphy.registered = false;
+	}
 
 	WARN_ON(!list_empty(&rdev->wdev_list));
 
-- 
1.8.5.5

