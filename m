Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:26083 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcH020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:21 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 05/15] nl80211: call periodic_start and periodic_stop
Date: Mon,  1 Nov 2010 13:52:06 +0200
Message-Id: <1288612336-2830-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that cfg80211 has support for periodic scan, we call those ops in the
nl80211 code.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 net/wireless/nl80211.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0884464..fd50186 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3014,6 +3014,11 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 	if (err)
 		goto out_rtnl;
 
+	if (!rdev->ops->periodic_start) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!netif_running(dev)) {
 		err = -ENETDOWN;
 		goto out;
@@ -3035,14 +3040,15 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 
 	rdev->periodic_req = request;
 
-	/* add actual calls here */
-
-	if (!err) {
-		nl80211_send_periodic(rdev, dev,
-				      NL80211_CMD_START_PERIODIC_SCAN);
-		dev_hold(dev);
+	err = rdev->ops->periodic_start(&rdev->wiphy, dev, request);
+	if (err) {
+		kfree(request);
+		rdev->periodic_req = NULL;
+		goto out;
 	}
 
+	nl80211_send_periodic(rdev, dev,
+			      NL80211_CMD_START_PERIODIC_SCAN);
 out:
 	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
@@ -3067,20 +3073,24 @@ static int nl80211_stop_periodic(struct sk_buff *skb,
 	if (err)
 		goto out_rtnl;
 
+	if (!rdev->ops->periodic_stop) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!netif_running(dev)) {
 		err = -ENETDOWN;
 		goto out;
 	}
 
 	if (rdev->periodic_req) {
-		/* add actual calls here */
+		err = rdev->ops->periodic_stop(&rdev->wiphy, dev,
+					       rdev->periodic_req);
 	}
 
-	if (!err) {
+	if (!err)
 		nl80211_send_periodic(rdev, dev,
 				      NL80211_CMD_STOP_PERIODIC_SCAN);
-		dev_hold(dev);
-	}
 
 	/*
 	 * FIXME: Can this stay here? How will the auto-complete and other
-- 
1.7.0.4

