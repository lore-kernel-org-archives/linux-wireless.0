Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758660Ab2JZNSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 09:18:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 1/4] nl80211: move "can set channel" check
Date: Fri, 26 Oct 2012 15:19:19 +0200
Message-Id: <1351257562-30729-2-git-send-email-johannes@sipsolutions.net> (sfid-20121026_151859_226109_A67DDC86)
In-Reply-To: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net>
References: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Setting the wdev to NULL when the channel can't be
set for that interface type (to treat the channel
setting for the wiphy/monitor) currently works, but
is confusing in the code if netdev/wdev aren't both
set/unset in the same way. Move the check whether
the channel can be set to where it's needed so that
wdev and netdev are always both assigned or NULL.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8c08578..879ca62 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1516,10 +1516,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		result = 0;
 
 		mutex_lock(&rdev->mtx);
-	} else if (nl80211_can_set_dev_channel(netdev->ieee80211_ptr))
+	} else
 		wdev = netdev->ieee80211_ptr;
-	else
-		wdev = NULL;
 
 	/*
 	 * end workaround code, by now the rdev is available
@@ -1579,7 +1577,9 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		result = __nl80211_set_channel(rdev, wdev, info);
+		result = __nl80211_set_channel(rdev,
+				nl80211_can_set_dev_channel(wdev) ? wdev : NULL,
+				info);
 		if (result)
 			goto bad_res;
 	}
-- 
1.7.10.4

