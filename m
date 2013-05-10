Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3EJSl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 14:41:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10] cfg80211: fix wiphy_register error path
Date: Fri, 10 May 2013 20:41:50 +0200
Message-Id: <1368211310-6566-1-git-send-email-johannes@sipsolutions.net> (sfid-20130510_204159_573230_3C86E0D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If rfkill_register() fails in wiphy_register() the struct device
is unregistered but everything else isn't (regulatory, debugfs)
and we even leave the wiphy instance on all internal lists even
though it will likely be freed soon, which is clearly a problem.
Fix this by cleaning up properly.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 68f0c96..c498c2b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -639,17 +639,21 @@ int wiphy_register(struct wiphy *wiphy)
 	 * cfg80211_mutex lock
 	 */
 	res = rfkill_register(rdev->rfkill);
-	if (res)
-		goto out_rm_dev;
+	if (res) {
+		device_del(&rdev->wiphy.dev);
+
+		mutex_lock(&cfg80211_mutex);
+		debugfs_remove_recursive(rdev->wiphy.debugfsdir);
+		list_del_rcu(&rdev->list);
+		wiphy_regulatory_deregister(wiphy);
+		mutex_unlock(&cfg80211_mutex);
+		return res;
+	}
 
 	rtnl_lock();
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 	return 0;
-
-out_rm_dev:
-	device_del(&rdev->wiphy.dev);
-	return res;
 }
 EXPORT_SYMBOL(wiphy_register);
 
-- 
1.8.0

