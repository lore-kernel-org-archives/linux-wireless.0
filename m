Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50967 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbbBNTw0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2015 14:52:26 -0500
From: Christian Engelmayer <cengelma@gmx.at>
To: johannes@sipsolutions.net
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] nl80211: Fix possible leak in nl80211_new_interface on MONITOR_FLAG_ACTIVE
Date: Sat, 14 Feb 2015 20:52:01 +0100
Message-Id: <1423943521-2896-1-git-send-email-cengelma@gmx.at> (sfid-20150214_205305_479140_60C5A3FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of NL80211_IFTYPE_MONITOR and flag MONITOR_FLAG_ACTIVE, the already
allocated sk_buff 'msg' is not freed, when the function exits in case the
feature is not supported. Detected by Coverity CID 1269116.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested only. Applies against linux-next.
---
 net/wireless/nl80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d78fd8b54515..38a7477dda81 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2663,8 +2663,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 				  &flags);
 
 	if (!err && (flags & MONITOR_FLAG_ACTIVE) &&
-	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
+	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR)) {
+		nlmsg_free(msg);
 		return -EOPNOTSUPP;
+	}
 
 	wdev = rdev_add_virtual_intf(rdev,
 				nla_data(info->attrs[NL80211_ATTR_IFNAME]),
-- 
1.9.1

