Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030320Ab2GLQA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 12:00:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: allow enabling WoWLAN without triggers
Date: Thu, 12 Jul 2012 18:00:22 +0200
Message-Id: <1342108822-27724-1-git-send-email-johannes@sipsolutions.net> (sfid-20120712_180036_764559_5D3231BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It may be desirable to use WoWLAN without triggers to
keep the connection alive to the AP while suspended.
Allow this use by enabling WoWLAN without triggers if
no triggers were requested.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6472c7f..079fc49 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6466,8 +6466,8 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct nlattr *tb[NUM_NL80211_WOWLAN_TRIG];
-	struct cfg80211_wowlan no_triggers = {};
 	struct cfg80211_wowlan new_triggers = {};
+	struct cfg80211_wowlan *ntrig;
 	struct wiphy_wowlan_support *wowlan = &rdev->wiphy.wowlan;
 	int err, i;
 	bool prev_enabled = rdev->wowlan;
@@ -6475,8 +6475,11 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->wiphy.wowlan.flags && !rdev->wiphy.wowlan.n_patterns)
 		return -EOPNOTSUPP;
 
-	if (!info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS])
-		goto no_triggers;
+	if (!info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]) {
+		cfg80211_rdev_free_wowlan(rdev);
+		rdev->wowlan = NULL;
+		goto set_wakeup;
+	}
 
 	err = nla_parse(tb, MAX_NL80211_WOWLAN_TRIG,
 			nla_data(info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]),
@@ -6587,22 +6590,15 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	if (memcmp(&new_triggers, &no_triggers, sizeof(new_triggers))) {
-		struct cfg80211_wowlan *ntrig;
-		ntrig = kmemdup(&new_triggers, sizeof(new_triggers),
-				GFP_KERNEL);
-		if (!ntrig) {
-			err = -ENOMEM;
-			goto error;
-		}
-		cfg80211_rdev_free_wowlan(rdev);
-		rdev->wowlan = ntrig;
-	} else {
- no_triggers:
-		cfg80211_rdev_free_wowlan(rdev);
-		rdev->wowlan = NULL;
+	ntrig = kmemdup(&new_triggers, sizeof(new_triggers), GFP_KERNEL);
+	if (!ntrig) {
+		err = -ENOMEM;
+		goto error;
 	}
+	cfg80211_rdev_free_wowlan(rdev);
+	rdev->wowlan = ntrig;
 
+ set_wakeup:
 	if (rdev->ops->set_wakeup && prev_enabled != !!rdev->wowlan)
 		rdev->ops->set_wakeup(&rdev->wiphy, rdev->wowlan);
 
-- 
1.7.10.4

