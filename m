Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.neomailbox.net ([5.148.176.60]:14275 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935733AbeFNC0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 22:26:17 -0400
From: Antonio Quartulli <a@unstable.cc>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH] nl80211: report 4ADDR status with GET_INTERFACE
Date: Thu, 14 Jun 2018 09:43:06 +0800
Message-Id: <20180614014306.6702-1-a@unstable.cc> (sfid-20180614_042641_836282_4F87DDDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User space tools might be interested in knowing the current
status of the 4ADDR property of an interface (when supported).

Send the status along with the other attributes when replying
to a GET_INTERFACE netlink query.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 07514ca011b2..cfed20dbaa7e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2757,7 +2757,8 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, wdev_address(wdev)) ||
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION,
 			rdev->devlist_generation ^
-			(cfg80211_rdev_list_generation << 2)))
+			(cfg80211_rdev_list_generation << 2)) ||
+	    nla_put_u8(msg, NL80211_ATTR_4ADDR, wdev->use_4addr))
 		goto nla_put_failure;
 
 	if (rdev->ops->get_channel) {
-- 
2.17.1
