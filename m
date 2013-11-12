Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:44932 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3KLNFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 08:05:42 -0500
Received: by mail-ea0-f178.google.com with SMTP id a10so2872584eae.9
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 05:05:41 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 1/3] cfg80211: DFS check dfs_region before CAC
Date: Tue, 12 Nov 2013 14:05:25 +0100
Message-Id: <1384261527-6253-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131112_140549_342930_9C0D484F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before we will start radar detection check
if we have correct DFS region. Fail in case
we don't know DFS region (don't know CAC/NOP
timing and how to configure DFS pattern detector).

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/nl80211.c |    5 +++++
 net/wireless/reg.c     |   16 ++++++++++++++++
 net/wireless/reg.h     |    1 +
 3 files changed, 22 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3f8c364..4669644 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5631,8 +5631,13 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_chan_def chandef;
+	enum nl80211_dfs_regions dfs_region;
 	int err;
 
+	dfs_region = reg_get_dfs_region(wdev->wiphy);
+	if (dfs_region == NL80211_DFS_UNSET)
+		return -EINVAL;
+
 	err = nl80211_parse_chandef(rdev, info, &chandef);
 	if (err)
 		return err;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a75c5ed..bba81c7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2129,6 +2129,22 @@ bool reg_supported_dfs_region(u8 dfs_region)
 	}
 }
 
+enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy)
+{
+	const struct ieee80211_regdomain *regdom = NULL;
+
+	ASSERT_RTNL();
+
+	if (wiphy)
+		regdom = get_wiphy_regdom(wiphy);
+	if (!regdom)
+		regdom = get_cfg80211_regdom();
+	if (!regdom)
+		return NL80211_DFS_UNSET;
+
+	return regdom->dfs_region;
+}
+
 static void print_dfs_region(u8 dfs_region)
 {
 	if (!dfs_region)
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index b4076ba..f8c8a49 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -21,6 +21,7 @@ extern const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 bool reg_is_valid_request(const char *alpha2);
 bool is_world_regdom(const char *alpha2);
 bool reg_supported_dfs_region(u8 dfs_region);
+enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy);
 
 int regulatory_hint_user(const char *alpha2,
 			 enum nl80211_user_reg_hint_type user_reg_hint_type);
-- 
1.7.9.5

