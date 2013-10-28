Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3J1OIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:08:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: don't allow drivers to unset NL80211_FEATURE_SCAN_FLUSH
Date: Mon, 28 Oct 2013 15:08:50 +0100
Message-Id: <1382969330-25707-1-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150857_467838_FE7E36B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As the flag is entirely implemented in cfg80211, it should
have been a global feature flag (which I believe didn't
exist at the time). However, there's no reason to allow
drivers to unset the flag, so don't allow it and remove
the validation of NL80211_SCAN_FLAG_FLUSH.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    |  3 +--
 net/wireless/nl80211.c | 12 ++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6715396..93d367c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -357,8 +357,6 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy.rts_threshold = (u32) -1;
 	rdev->wiphy.coverage_class = 0;
 
-	rdev->wiphy.features = NL80211_FEATURE_SCAN_FLUSH;
-
 	return &rdev->wiphy;
 }
 EXPORT_SYMBOL(wiphy_new);
@@ -566,6 +564,7 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
+	rdev->wiphy.features |= NL80211_FEATURE_SCAN_FLUSH;
 
 	res = device_add(&rdev->wiphy.dev);
 	if (res)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 99dc3f3..2c4ac01 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5342,10 +5342,8 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
-		if (((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
-		     !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) ||
-		    ((request->flags & NL80211_SCAN_FLAG_FLUSH) &&
-		     !(wiphy->features & NL80211_FEATURE_SCAN_FLUSH))) {
+		if ((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+		    !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) {
 			err = -EOPNOTSUPP;
 			goto out_free;
 		}
@@ -5585,10 +5583,8 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
-		if (((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
-		     !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) ||
-		    ((request->flags & NL80211_SCAN_FLAG_FLUSH) &&
-		     !(wiphy->features & NL80211_FEATURE_SCAN_FLUSH))) {
+		if ((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+		    !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) {
 			err = -EOPNOTSUPP;
 			goto out_free;
 		}
-- 
1.8.4.rc3

