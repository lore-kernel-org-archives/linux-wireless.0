Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33242 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeBBJPs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 04:15:48 -0500
From: Jouni Malinen <jouni@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH] nl80211: Fix external_auth check for offloaded authentication
Date: Fri,  2 Feb 2018 11:15:27 +0200
Message-Id: <1517562927-6193-1-git-send-email-jouni@codeaurora.org> (sfid-20180202_101556_308663_28A5F459)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Srinivas Dasari <dasaris@codeaurora.org>

Unfortunately removal of the ext_feature flag in the last revision of
the patch ended up negating the comparison and prevented the command
from being processed (either nl80211_external_auth() or
rdev_external_auth() returns -EOPNOTSUPP). Fix this by adding back the
lost '!'.

Fixes: 40cbfa90218b ("cfg80211/nl80211: Optional authentication offload to userspace")
Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cc6ec5b..3b6dbc1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12486,7 +12486,7 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct cfg80211_external_auth_params params;
 
-	if (rdev->ops->external_auth)
+	if (!rdev->ops->external_auth)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[NL80211_ATTR_SSID])
-- 
2.7.4
