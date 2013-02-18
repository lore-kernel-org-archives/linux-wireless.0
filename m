Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3BROCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 09:02:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Larry.Finger@lwfinger.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix station change if TDLS isn't supported
Date: Mon, 18 Feb 2013 15:02:29 +0100
Message-Id: <1361196149-10731-1-git-send-email-johannes@sipsolutions.net> (sfid-20130218_150244_169700_5A9EDDE3)
In-Reply-To: <51207925.5040702@lwfinger.net>
References: <51207925.5040702@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Larry noticed (and bisected) that commit df881293c6ba9a12868491a717b25
"cfg80211: Pass TDLS peer's QoS/HT/VHT information during set_station"
broke secure connections. This is is the case only for drivers that
don't support TDLS, where any kind of change, even just the change of
authorized flag that is required for normal operation, was rejected
now. To fix this, remove the checks. I have some patches that will add
proper verification for all the different cases later.

Cc: Jouni Malinen <j@w1.fi>
Bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 580ffea..d86af75 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3423,14 +3423,6 @@ static int nl80211_set_station_tdls(struct genl_info *info,
 	struct nlattr *nla;
 	int err;
 
-	/* Can only set if TDLS ... */
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS))
-		return -EOPNOTSUPP;
-
-	/* ... with external setup is supported */
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP))
-		return -EOPNOTSUPP;
-
 	/* Dummy STA entry gets updated once the peer capabilities are known */
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
 		params->ht_capa =
-- 
1.8.0

