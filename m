Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34706 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754410AbcKUMzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 07:55:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: fix logic inversion in start_nan()
Date: Mon, 21 Nov 2016 13:55:48 +0100
Message-Id: <20161121125548.4730-1-johannes@sipsolutions.net> (sfid-20161121_135604_965419_A153336A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Arend inadvertedly inverted the logic while converting to
wdev_running(), fix that.

Fixes: 73c7da3dae1e ("cfg80211: add generic helper to check interface is running")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4e9bda49e957..e4f718e956d7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10625,7 +10625,7 @@ static int nl80211_start_nan(struct sk_buff *skb, struct genl_info *info)
 	if (wdev->iftype != NL80211_IFTYPE_NAN)
 		return -EOPNOTSUPP;
 
-	if (!wdev_running(wdev))
+	if (wdev_running(wdev))
 		return -EEXIST;
 
 	if (rfkill_blocked(rdev->rfkill))
-- 
2.9.3
