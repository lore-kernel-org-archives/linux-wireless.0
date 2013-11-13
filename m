Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58758 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab3KMRy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:54:26 -0500
Received: by mail-wi0-f172.google.com with SMTP id i19so1124963wiw.17
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:54:25 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 5/5] cfg80211: add reg_get_dfs_region()
Date: Wed, 13 Nov 2013 18:54:06 +0100
Message-Id: <1384365246-24768-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_185428_979990_9430777C)
In-Reply-To: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be used outside of the regulatory context for any checks
on the DFS region. The central cfg80211 dfs_region is always used
and if it does not match with the wiphy a debug print is issued.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 29 +++++++++++++++++++++++++++++
 net/wireless/reg.h |  1 +
 2 files changed, 30 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ec54e1a..4bfbeaa 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -135,6 +135,35 @@ static const char *reg_dfs_region_str(enum nl80211_dfs_regions dfs_region)
 	return "Unknown";
 }
 
+enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy)
+{
+	const struct ieee80211_regdomain *regd = NULL;
+	const struct ieee80211_regdomain *wiphy_regd = NULL;
+
+	ASSERT_RTNL();
+
+	regd = get_cfg80211_regdom();
+	if (!wiphy)
+		goto out;
+
+	wiphy_regd = get_wiphy_regdom(wiphy);
+	if (!wiphy_regd)
+		goto out;
+
+	if (wiphy_regd->dfs_region == regd->dfs_region)
+		goto out;
+
+	REG_DBG_PRINT("%s: device specific dfs_region "
+		      "(%s) disagrees with cfg80211's "
+		      "central dfs_region (%s)\n",
+		      dev_name(&wiphy->dev),
+		      reg_dfs_region_str(wiphy_regd->dfs_region),
+		      reg_dfs_region_str(regd->dfs_region));
+
+out:
+	return regd->dfs_region;
+}
+
 static void rcu_free_regdom(const struct ieee80211_regdomain *r)
 {
 	if (!r)
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index cc4c2c0..02bd8f4 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -21,6 +21,7 @@ extern const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 bool reg_is_valid_request(const char *alpha2);
 bool is_world_regdom(const char *alpha2);
 bool reg_supported_dfs_region(enum nl80211_dfs_regions dfs_region);
+enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy);
 
 int regulatory_hint_user(const char *alpha2,
 			 enum nl80211_user_reg_hint_type user_reg_hint_type);
-- 
1.8.4.rc3

