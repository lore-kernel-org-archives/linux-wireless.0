Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:39017 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882Ab3KMRyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:54:23 -0500
Received: by mail-we0-f170.google.com with SMTP id p61so790072wes.15
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:54:22 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 4/5] cfg80211: replace print_dfs_region() with reg_dfs_region_str() helper
Date: Wed, 13 Nov 2013 18:54:05 +0100
Message-Id: <1384365246-24768-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_185426_711648_3BF926D2)
In-Reply-To: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets us later reuse the more generic reg_dfs_region_str().

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 740eccb..ec54e1a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -120,6 +120,21 @@ static const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
 	return rtnl_dereference(wiphy->regd);
 }
 
+static const char *reg_dfs_region_str(enum nl80211_dfs_regions dfs_region)
+{
+	switch (dfs_region) {
+	case NL80211_DFS_UNSET:
+		return "unset";
+	case NL80211_DFS_FCC:
+		return "FCC";
+	case NL80211_DFS_ETSI:
+		return "ETSI";
+	case NL80211_DFS_JP:
+		return "JP";
+	}
+	return "Unknown";
+}
+
 static void rcu_free_regdom(const struct ieee80211_regdomain *r)
 {
 	if (!r)
@@ -2146,30 +2161,6 @@ bool reg_supported_dfs_region(enum nl80211_dfs_regions dfs_region)
 	}
 }
 
-static void print_dfs_region(enum nl80211_dfs_regions dfs_region)
-{
-	if (!dfs_region)
-		return;
-
-	switch (dfs_region) {
-	case NL80211_DFS_UNSET:
-		pr_info(" DFS Master region unset");
-		break;
-	case NL80211_DFS_FCC:
-		pr_info(" DFS Master region FCC");
-		break;
-	case NL80211_DFS_ETSI:
-		pr_info(" DFS Master region ETSI");
-		break;
-	case NL80211_DFS_JP:
-		pr_info(" DFS Master region JP");
-		break;
-	default:
-		pr_info(" DFS Master region Unknown");
-		break;
-	}
-}
-
 static void print_regdomain(const struct ieee80211_regdomain *rd)
 {
 	struct regulatory_request *lr = get_last_request();
@@ -2201,7 +2192,7 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 		}
 	}
 
-	print_dfs_region(rd->dfs_region);
+	pr_info(" DFS Master region: %s", reg_dfs_region_str(rd->dfs_region));
 	print_rd_rules(rd);
 }
 
-- 
1.8.4.rc3

