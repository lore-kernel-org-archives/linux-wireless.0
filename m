Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:37692 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788Ab3KMRyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:54:13 -0500
Received: by mail-we0-f181.google.com with SMTP id w61so768245wes.40
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:54:12 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/5] cfg80211: use enum nl80211_dfs_regions for dfs_region everywhere
Date: Wed, 13 Nov 2013 18:54:02 +0100
Message-Id: <1384365246-24768-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_185416_578527_22EC6DF1)
In-Reply-To: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

u8 was used in some other places, just stick to the enum,
this forces us to express the values that are expected.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/regulatory.h | 4 ++--
 net/wireless/nl80211.c   | 2 +-
 net/wireless/reg.c       | 4 ++--
 net/wireless/reg.h       | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 7e49cf6..ab0bee0 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -79,7 +79,7 @@ struct regulatory_request {
 	enum nl80211_reg_initiator initiator;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
 	char alpha2[2];
-	u8 dfs_region;
+	enum nl80211_dfs_regions dfs_region;
 	bool intersect;
 	bool processed;
 	enum environment_cap country_ie_env;
@@ -157,7 +157,7 @@ struct ieee80211_regdomain {
 	struct rcu_head rcu_head;
 	u32 n_reg_rules;
 	char alpha2[2];
-	u8 dfs_region;
+	enum nl80211_dfs_regions dfs_region;
 	struct ieee80211_reg_rule reg_rules[];
 };
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3f8c364..c33b374 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5079,7 +5079,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	char *alpha2 = NULL;
 	int rem_reg_rules = 0, r = 0;
 	u32 num_rules = 0, rule_idx = 0, size_of_regd;
-	u8 dfs_region = 0;
+	enum nl80211_dfs_regions dfs_region = NL80211_DFS_UNSET;
 	struct ieee80211_regdomain *rd = NULL;
 
 	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 067c1f6..2796b62 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2115,7 +2115,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	}
 }
 
-bool reg_supported_dfs_region(u8 dfs_region)
+bool reg_supported_dfs_region(enum nl80211_dfs_regions dfs_region)
 {
 	switch (dfs_region) {
 	case NL80211_DFS_UNSET:
@@ -2130,7 +2130,7 @@ bool reg_supported_dfs_region(u8 dfs_region)
 	}
 }
 
-static void print_dfs_region(u8 dfs_region)
+static void print_dfs_region(enum nl80211_dfs_regions dfs_region)
 {
 	if (!dfs_region)
 		return;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index b4076ba..cc4c2c0 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -20,7 +20,7 @@ extern const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 
 bool reg_is_valid_request(const char *alpha2);
 bool is_world_regdom(const char *alpha2);
-bool reg_supported_dfs_region(u8 dfs_region);
+bool reg_supported_dfs_region(enum nl80211_dfs_regions dfs_region);
 
 int regulatory_hint_user(const char *alpha2,
 			 enum nl80211_user_reg_hint_type user_reg_hint_type);
-- 
1.8.4.rc3

