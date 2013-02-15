Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3BOMLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:11:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC/RFT v2 3/4] cfg80211: unify station WME parsing
Date: Fri, 15 Feb 2013 13:11:00 +0100
Message-Id: <1360930261-30265-4-git-send-email-johannes@sipsolutions.net> (sfid-20130215_131114_248352_998C4EA3)
In-Reply-To: <1360930261-30265-1-git-send-email-johannes@sipsolutions.net>
References: <1360930261-30265-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of copying the code, create a new function
to parse the station's WME information.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 72 ++++++++++++++++++++------------------------------
 1 file changed, 29 insertions(+), 43 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a8ae6419..148053c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3570,30 +3570,13 @@ nl80211_sta_wme_policy[NL80211_STA_WME_MAX + 1] __read_mostly = {
 	[NL80211_STA_WME_MAX_SP] = { .type = NLA_U8 },
 };
 
-static int nl80211_set_station_tdls(struct genl_info *info,
-				    struct station_parameters *params)
+static int nl80211_parse_sta_wme(struct genl_info *info,
+				 struct station_parameters *params)
 {
-	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct nlattr *tb[NL80211_STA_WME_MAX + 1];
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
-	/* Dummy STA entry gets updated once the peer capabilities are known */
-	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
-		params->ht_capa =
-			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
-	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY])
-		params->vht_capa =
-			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
-
 	/* parse WME attributes if present */
 	if (!info->attrs[NL80211_ATTR_STA_WME])
 		return 0;
@@ -3621,6 +3604,30 @@ static int nl80211_set_station_tdls(struct genl_info *info,
 	return 0;
 }
 
+static int nl80211_set_station_tdls(struct genl_info *info,
+				    struct station_parameters *params)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+
+	/* Can only set if TDLS ... */
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS))
+		return -EOPNOTSUPP;
+
+	/* ... with external setup is supported */
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP))
+		return -EOPNOTSUPP;
+
+	/* Dummy STA entry gets updated once the peer capabilities are known */
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
+		params->ht_capa =
+			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
+	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY])
+		params->vht_capa =
+			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
+
+	return nl80211_parse_sta_wme(info, params);
+}
+
 static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -3894,30 +3901,9 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
-	if (info->attrs[NL80211_ATTR_STA_WME]) {
-		struct nlattr *tb[NL80211_STA_WME_MAX + 1];
-		struct nlattr *nla;
-
-		nla = info->attrs[NL80211_ATTR_STA_WME];
-		err = nla_parse_nested(tb, NL80211_STA_WME_MAX, nla,
-				       nl80211_sta_wme_policy);
-		if (err)
-			return err;
-
-		if (tb[NL80211_STA_WME_UAPSD_QUEUES])
-			params.uapsd_queues =
-			     nla_get_u8(tb[NL80211_STA_WME_UAPSD_QUEUES]);
-		if (params.uapsd_queues & ~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
-			return -EINVAL;
-
-		if (tb[NL80211_STA_WME_MAX_SP])
-			params.max_sp = nla_get_u8(tb[NL80211_STA_WME_MAX_SP]);
-
-		if (params.max_sp & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
-			return -EINVAL;
-
-		params.sta_modify_mask |= STATION_PARAM_APPLY_UAPSD;
-	}
+	err = nl80211_parse_sta_wme(info, &params);
+	if (err)
+		return err;
 
 	if (parse_station_flags(info, dev->ieee80211_ptr->iftype, &params))
 		return -EINVAL;
-- 
1.8.0

