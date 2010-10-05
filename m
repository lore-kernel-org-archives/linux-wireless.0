Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab0JETeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 15:34:11 -0400
Subject: [PATCH] nl80211: fix error in generic netif_running check
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 21:34:11 +0200
Message-ID: <1286307251.3641.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Yikes! The error return keeps a netdev reference
and the rdev mutex locked, fix that!

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/wireless/nl80211.c	2010-10-05 21:32:06.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-10-05 21:33:23.000000000 +0200
@@ -4330,6 +4330,8 @@ static int nl80211_pre_doit(struct genl_
 		}
 		if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP &&
 		    !netif_running(dev)) {
+			cfg80211_unlock_rdev(rdev);
+			dev_put(dev);
 			if (rtnl)
 				rtnl_unlock();
 			return -ENETDOWN;


