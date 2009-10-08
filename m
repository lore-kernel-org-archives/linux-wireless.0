Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbZJHTEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 15:04:34 -0400
Subject: [PATCH 2.6.32] cfg80211: fix netns error unwinding bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Oct 2009 21:02:02 +0200
Message-Id: <1255028522.3713.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The error unwinding code in set_netns has a bug
that will make it run into a BUG_ON if passed a
bad wiphy index, fix by not trying to unlock a
wiphy that doesn't exist.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-10-06 16:15:18.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-10-06 16:15:28.000000000 +0200
@@ -4031,7 +4031,7 @@ static int nl80211_wiphy_netns(struct sk
 	rdev = cfg80211_get_dev_from_info(info);
 	if (IS_ERR(rdev)) {
 		err = PTR_ERR(rdev);
-		goto out;
+		goto out_rtnl;
 	}
 
 	net = get_net_ns_by_pid(pid);
@@ -4051,6 +4051,7 @@ static int nl80211_wiphy_netns(struct sk
 	put_net(net);
  out:
 	cfg80211_unlock_rdev(rdev);
+ out_rtnl:
 	rtnl_unlock();
 	return err;
 }


