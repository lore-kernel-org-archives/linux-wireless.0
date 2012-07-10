Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21441 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2GJKID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 06:08:03 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] nl80211: Avoid checking for empty WoWLAN triggers
Date: Tue, 10 Jul 2012 15:37:55 +0530
Message-ID: <1341914875-14647-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120710_120807_542846_77B1AE35)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Previously we would check in nl80211 with an empty
cfg80211_wowlan structure to check for 'iw phy phyX wowlan enable'
with empty arguments (or) no triggers and disable WoWLAN.
It would be nice to inform the user that the wowlan enable is
provided with zero arugments in userspace itself rather than
disabling it in nl80211/cfg80211. A correspoding patch
was also proposed for 'iw' tool.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/wireless/nl80211.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2a5cdb6..fb63f72 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6363,17 +6363,20 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct nlattr *tb[NUM_NL80211_WOWLAN_TRIG];
-	struct cfg80211_wowlan no_triggers = {};
 	struct cfg80211_wowlan new_triggers = {};
+	struct cfg80211_wowlan *ntrig;
 	struct wiphy_wowlan_support *wowlan = &rdev->wiphy.wowlan;
 	int err, i;
 	bool prev_enabled = rdev->wowlan;
+	bool wow_disabled = false;
 
 	if (!rdev->wiphy.wowlan.flags && !rdev->wiphy.wowlan.n_patterns)
 		return -EOPNOTSUPP;
 
-	if (!info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS])
+	if (!info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]) {
+		wow_disabled = true;
 		goto no_triggers;
+	}
 
 	err = nla_parse(tb, MAX_NL80211_WOWLAN_TRIG,
 			nla_data(info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]),
@@ -6484,18 +6487,18 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
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
+	ntrig = kmemdup(&new_triggers, sizeof(new_triggers),
+			GFP_KERNEL);
+	if (!ntrig) {
+		err = -ENOMEM;
+		goto error;
+	}
+	cfg80211_rdev_free_wowlan(rdev);
+	rdev->wowlan = ntrig;
+
+no_triggers:
+
+	if (wow_disabled) {
 		cfg80211_rdev_free_wowlan(rdev);
 		rdev->wowlan = NULL;
 	}
-- 
1.7.0.4

