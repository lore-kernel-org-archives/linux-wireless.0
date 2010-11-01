Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:26098 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcF020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:19 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 03/15] nl80211: alloc and free the periodic_req data
Date: Mon,  1 Nov 2010 13:52:04 +0200
Message-Id: <1288612336-2830-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds code to allocate and deallocate the periodic request data
structure.  This structure will be passed down when making the actual scan
call and it is also used to check whether a periodic scan is still running or
not.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 net/wireless/nl80211.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a2293ea..0884464 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3001,6 +3001,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_start_periodic(struct sk_buff *skb,
 				  struct genl_info *info)
 {
+	struct cfg80211_periodic_request *request;
 	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
 	int err;
@@ -3018,6 +3019,22 @@ static int nl80211_start_periodic(struct sk_buff *skb,
 		goto out;
 	}
 
+	if (rdev->periodic_req) {
+		err = -EINPROGRESS;
+		goto out;
+	}
+
+	request = kzalloc(sizeof(*request), GFP_KERNEL);
+	if (!request) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	request->dev = dev;
+	request->wiphy = &rdev->wiphy;
+
+	rdev->periodic_req = request;
+
 	/* add actual calls here */
 
 	if (!err) {
@@ -3055,7 +3072,9 @@ static int nl80211_stop_periodic(struct sk_buff *skb,
 		goto out;
 	}
 
-	/* add actual calls here */
+	if (rdev->periodic_req) {
+		/* add actual calls here */
+	}
 
 	if (!err) {
 		nl80211_send_periodic(rdev, dev,
@@ -3063,6 +3082,13 @@ static int nl80211_stop_periodic(struct sk_buff *skb,
 		dev_hold(dev);
 	}
 
+	/*
+	 * FIXME: Can this stay here? How will the auto-complete and other
+	 * cleanup cases work?
+	 */
+	kfree(rdev->periodic_req);
+	rdev->periodic_req = NULL;
+
 out:
 	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
-- 
1.7.0.4

