Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50096 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753257AbdBTNYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 08:24:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/6] cfg80211: combine two nested ifs into a single condition
Date: Mon, 20 Feb 2017 14:24:34 +0100
Message-Id: <20170220132439.16064-1-johannes@sipsolutions.net> (sfid-20170220_142500_455118_A7A8CD0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Combine two instances of having two nested if statements
into a single one with a combined condition to reduce the
indentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 12 ++++++------
 net/wireless/util.c | 10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 04143df20f7f..76e664144c8e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1216,12 +1216,12 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 */
 		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
 		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
-		    rdev->ops->set_power_mgmt)
-			if (rdev_set_power_mgmt(rdev, dev, wdev->ps,
-						wdev->ps_timeout)) {
-				/* assume this means it's off */
-				wdev->ps = false;
-			}
+		    rdev->ops->set_power_mgmt &&
+		    rdev_set_power_mgmt(rdev, dev, wdev->ps,
+					wdev->ps_timeout)) {
+			/* assume this means it's off */
+			wdev->ps = false;
+		}
 		break;
 	case NETDEV_UNREGISTER:
 		/*
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 68e5f2ecee1a..daef500a7b64 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -914,11 +914,11 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 			netdev_err(dev, "failed to set key %d\n", i);
 			continue;
 		}
-		if (wdev->connect_keys->def == i)
-			if (rdev_set_default_key(rdev, dev, i, true, true)) {
-				netdev_err(dev, "failed to set defkey %d\n", i);
-				continue;
-			}
+		if (wdev->connect_keys->def == i &&
+		    rdev_set_default_key(rdev, dev, i, true, true)) {
+			netdev_err(dev, "failed to set defkey %d\n", i);
+			continue;
+		}
 	}
 
 	kzfree(wdev->connect_keys);
-- 
2.9.3
