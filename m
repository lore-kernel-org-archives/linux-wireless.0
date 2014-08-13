Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaHMNEy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 09:04:54 -0400
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH] wireless: core: Reorder wiphy_register() notifications relevantly
Date: Wed, 13 Aug 2014 16:04:51 +0300
Message-Id: <1407935091-28516-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20140813_150457_552550_15CAEAC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently it can send regulatory domain change notification before any
NEW_WIPHY notification. Moreover, if rfill_register() fails, calling
wiphy_unregister() will send a DEL_WIPHY though no NEW_WIPHY had been
sent previously.

Thus reordering so it properly notifies NEW_WIPHY before any other.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/wireless/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index afee5e0..682babd 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -635,6 +635,9 @@ int wiphy_register(struct wiphy *wiphy)
 	if (IS_ERR(rdev->wiphy.debugfsdir))
 		rdev->wiphy.debugfsdir = NULL;
 
+	cfg80211_debugfs_rdev_add(rdev);
+	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
+
 	if (wiphy->regulatory_flags & REGULATORY_CUSTOM_REG) {
 		struct regulatory_request request;
 
@@ -646,8 +649,6 @@ int wiphy_register(struct wiphy *wiphy)
 		nl80211_send_reg_change_event(&request);
 	}
 
-	cfg80211_debugfs_rdev_add(rdev);
-
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 
@@ -659,8 +660,6 @@ int wiphy_register(struct wiphy *wiphy)
 		return res;
 	}
 
-	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
-
 	return 0;
 }
 EXPORT_SYMBOL(wiphy_register);
-- 
1.8.5.5

