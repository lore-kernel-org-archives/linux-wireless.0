Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:46901 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab3KYT4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 14:56:22 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so2742079ead.8
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 11:56:21 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v3 1/4] cfg80211: add reg_get_dfs_region()
Date: Mon, 25 Nov 2013 20:56:09 +0100
Message-Id: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131125_205626_775294_E10CA0CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This can be used outside of the regulatory context for any checks
on the DFS region. The central cfg80211 dfs_region is always used
and if it does not match with the wiphy a debug print is issued.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c |   27 +++++++++++++++++++++++++++
 net/wireless/reg.h |    1 +
 2 files changed, 28 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ec54e1a..7d20d84 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -135,6 +135,33 @@ static const char *reg_dfs_region_str(enum nl80211_dfs_regions dfs_region)
 	return "Unknown";
 }
 
+enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy)
+{
+	const struct ieee80211_regdomain *regd = NULL;
+	const struct ieee80211_regdomain *wiphy_regd = NULL;
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
1.7.9.5

