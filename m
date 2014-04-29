Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbaD2P7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 11:59:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: remove BUG_ON usage
Date: Tue, 29 Apr 2014 17:59:39 +0200
Message-Id: <1398787180-6494-1-git-send-email-johannes@sipsolutions.net> (sfid-20140429_175956_612097_DDAB5305)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These really can't trigger unless somebody messes up the code,
but don't make debugging it needlessly complicated, WARN and
return instead of BUG_ON().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 2 +-
 net/wireless/sme.c  | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index b3ff3697239a..f509da4d9be9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -690,7 +690,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	rtnl_lock();
 	rdev->wiphy.registered = false;
 
-	BUG_ON(!list_empty(&rdev->wdev_list));
+	WARN_ON(!list_empty(&rdev->wdev_list));
 
 	/*
 	 * First remove the hardware from everywhere, this makes
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index e2923a3f2e5c..4bc21a2b1989 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -149,7 +149,8 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 	case CFG80211_CONN_SCAN_AGAIN:
 		return cfg80211_conn_scan(wdev);
 	case CFG80211_CONN_AUTHENTICATE_NEXT:
-		BUG_ON(!rdev->ops->auth);
+		if (WARN_ON(!rdev->ops->auth))
+			return -EOPNOTSUPP;
 		wdev->conn->state = CFG80211_CONN_AUTHENTICATING;
 		return cfg80211_mlme_auth(rdev, wdev->netdev,
 					  params->channel, params->auth_type,
@@ -161,7 +162,8 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 	case CFG80211_CONN_AUTH_FAILED:
 		return -ENOTCONN;
 	case CFG80211_CONN_ASSOCIATE_NEXT:
-		BUG_ON(!rdev->ops->assoc);
+		if (WARN_ON(!rdev->ops->assoc))
+			return -EOPNOTSUPP;
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
 		if (wdev->conn->prev_bssid_valid)
 			req.prev_bssid = wdev->conn->prev_bssid;
-- 
1.9.0

