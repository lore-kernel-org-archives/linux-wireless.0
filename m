Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab3FKOxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 10:53:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix rtnl leak in wiphy dump error cases
Date: Tue, 11 Jun 2013 16:53:09 +0200
Message-Id: <1370962389-21224-1-git-send-email-johannes@sipsolutions.net> (sfid-20130611_165317_192718_79F3696C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In two wiphy dump error cases, most often when the dump allocation
must be increased, the RTNL is leaked. This quickly results in a
complete system lockup. Release the RTNL correctly.

Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 398ce2c..e402819 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1541,8 +1541,10 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 			int ifidx = nla_get_u32(tb[NL80211_ATTR_IFINDEX]);
 
 			netdev = dev_get_by_index(sock_net(skb->sk), ifidx);
-			if (!netdev)
+			if (!netdev) {
+				rtnl_unlock();
 				return -ENODEV;
+			}
 			if (netdev->ieee80211_ptr) {
 				dev = wiphy_to_dev(
 					netdev->ieee80211_ptr->wiphy);
@@ -1586,6 +1588,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 				    !skb->len &&
 				    cb->min_dump_alloc < 4096) {
 					cb->min_dump_alloc = 4096;
+					rtnl_unlock();
 					return 1;
 				}
 				idx--;
-- 
1.8.0

