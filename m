Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35246 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752737AbdDLLGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 07:06:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: aviya.erenfeld@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/6] cfg80211: refactor nl80211 monitor option parsing
Date: Wed, 12 Apr 2017 13:06:20 +0200
Message-Id: <20170412110621.8981-5-johannes@sipsolutions.net> (sfid-20170412_130635_168453_DDEE6B37)
In-Reply-To: <20170412110621.8981-1-johannes@sipsolutions.net>
References: <20170412110621.8981-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Refactor the parsing of monitor flags and the MU-MIMO options.
This will allow adding more things cleanly in the future and
also allows setting the latter already when creating a monitor
interface.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 126 +++++++++++++++++++++++++++----------------------
 1 file changed, 70 insertions(+), 56 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dd871586cb94..9516840b6e5f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2708,6 +2708,69 @@ static int parse_monitor_flags(struct nlattr *nla, u32 *mntrflags)
 	return 0;
 }
 
+static int nl80211_parse_mon_options(struct cfg80211_registered_device *rdev,
+				     enum nl80211_iftype type,
+				     struct genl_info *info,
+				     struct vif_params *params)
+{
+	bool change = false;
+	int err;
+
+	if (info->attrs[NL80211_ATTR_MNTR_FLAGS]) {
+		if (type != NL80211_IFTYPE_MONITOR)
+			return -EINVAL;
+
+		err = parse_monitor_flags(info->attrs[NL80211_ATTR_MNTR_FLAGS],
+					  &params->flags);
+		if (err)
+			return err;
+
+		change = true;
+	}
+
+	if (params->flags & MONITOR_FLAG_ACTIVE &&
+	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
+		return -EOPNOTSUPP;
+
+	if (info->attrs[NL80211_ATTR_MU_MIMO_GROUP_DATA]) {
+		const u8 *mumimo_groups;
+		u32 cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
+
+		if (type != NL80211_IFTYPE_MONITOR)
+			return -EINVAL;
+
+		if (!wiphy_ext_feature_isset(&rdev->wiphy, cap_flag))
+			return -EOPNOTSUPP;
+
+		mumimo_groups =
+			nla_data(info->attrs[NL80211_ATTR_MU_MIMO_GROUP_DATA]);
+
+		/* bits 0 and 63 are reserved and must be zero */
+		if ((mumimo_groups[0] & BIT(7)) ||
+		    (mumimo_groups[VHT_MUMIMO_GROUPS_DATA_LEN - 1] & BIT(0)))
+			return -EINVAL;
+
+		params->vht_mumimo_groups = mumimo_groups;
+		change = true;
+	}
+
+	if (info->attrs[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR]) {
+		u32 cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
+
+		if (type != NL80211_IFTYPE_MONITOR)
+			return -EINVAL;
+
+		if (!wiphy_ext_feature_isset(&rdev->wiphy, cap_flag))
+			return -EOPNOTSUPP;
+
+		params->vht_mumimo_follow_addr =
+			nla_data(info->attrs[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR]);
+		change = true;
+	}
+
+	return change ? 1 : 0;
+}
+
 static int nl80211_valid_4addr(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u8 use_4addr,
 			       enum nl80211_iftype iftype)
@@ -2783,50 +2846,11 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		params.use_4addr = -1;
 	}
 
-	if (info->attrs[NL80211_ATTR_MNTR_FLAGS]) {
-		if (ntype != NL80211_IFTYPE_MONITOR)
-			return -EINVAL;
-		err = parse_monitor_flags(info->attrs[NL80211_ATTR_MNTR_FLAGS],
-					  &params.flags);
-		if (err)
-			return err;
-
-		change = true;
-	}
-
-	if (params.flags & MONITOR_FLAG_ACTIVE &&
-	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
-		return -EOPNOTSUPP;
-
-	if (info->attrs[NL80211_ATTR_MU_MIMO_GROUP_DATA]) {
-		const u8 *mumimo_groups;
-		u32 cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
-
-		if (!wiphy_ext_feature_isset(&rdev->wiphy, cap_flag))
-			return -EOPNOTSUPP;
-
-		mumimo_groups =
-			nla_data(info->attrs[NL80211_ATTR_MU_MIMO_GROUP_DATA]);
-
-		/* bits 0 and 63 are reserved and must be zero */
-		if ((mumimo_groups[0] & BIT(7)) ||
-		    (mumimo_groups[VHT_MUMIMO_GROUPS_DATA_LEN - 1] & BIT(0)))
-			return -EINVAL;
-
-		params.vht_mumimo_groups = mumimo_groups;
-		change = true;
-	}
-
-	if (info->attrs[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR]) {
-		u32 cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
-
-		if (!wiphy_ext_feature_isset(&rdev->wiphy, cap_flag))
-			return -EOPNOTSUPP;
-
-		params.vht_mumimo_follow_addr =
-			nla_data(info->attrs[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR]);
+	err = nl80211_parse_mon_options(rdev, ntype, info, &params);
+	if (err < 0)
+		return err;
+	if (err > 0)
 		change = true;
-	}
 
 	if (change)
 		err = cfg80211_change_iface(rdev, dev, ntype, &params);
@@ -2882,19 +2906,9 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
-	if (info->attrs[NL80211_ATTR_MNTR_FLAGS]) {
-		if (type != NL80211_IFTYPE_MONITOR)
-			return -EINVAL;
-
-		err = parse_monitor_flags(info->attrs[NL80211_ATTR_MNTR_FLAGS],
-					  &params.flags);
-		if (err)
-			return err;
-	}
-
-	if (params.flags & MONITOR_FLAG_ACTIVE &&
-	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
-		return -EOPNOTSUPP;
+	err = nl80211_parse_mon_options(rdev, type, info, &params);
+	if (err < 0)
+		return err;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
-- 
2.11.0
