Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935182Ab3BOAKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 19:10:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC/RFT 2/4] cfg80211: clean up station WME attribute parsing
Date: Fri, 15 Feb 2013 01:10:31 +0100
Message-Id: <1360887033-21167-3-git-send-email-johannes@sipsolutions.net> (sfid-20130215_011046_928679_6508DC79)
In-Reply-To: <1360887033-21167-1-git-send-email-johannes@sipsolutions.net>
References: <1360887033-21167-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Parse the attributes first, and then disable the apply
flag if needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 68 +++++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5523150..a8ae6419 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3839,6 +3839,9 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 
 	memset(&params, 0, sizeof(params));
 
+	if (!rdev->ops->add_station)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
@@ -3891,8 +3894,30 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
-	if (!rdev->ops->add_station)
-		return -EOPNOTSUPP;
+	if (info->attrs[NL80211_ATTR_STA_WME]) {
+		struct nlattr *tb[NL80211_STA_WME_MAX + 1];
+		struct nlattr *nla;
+
+		nla = info->attrs[NL80211_ATTR_STA_WME];
+		err = nla_parse_nested(tb, NL80211_STA_WME_MAX, nla,
+				       nl80211_sta_wme_policy);
+		if (err)
+			return err;
+
+		if (tb[NL80211_STA_WME_UAPSD_QUEUES])
+			params.uapsd_queues =
+			     nla_get_u8(tb[NL80211_STA_WME_UAPSD_QUEUES]);
+		if (params.uapsd_queues & ~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
+			return -EINVAL;
+
+		if (tb[NL80211_STA_WME_MAX_SP])
+			params.max_sp = nla_get_u8(tb[NL80211_STA_WME_MAX_SP]);
+
+		if (params.max_sp & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
+			return -EINVAL;
+
+		params.sta_modify_mask |= STATION_PARAM_APPLY_UAPSD;
+	}
 
 	if (parse_station_flags(info, dev->ieee80211_ptr->iftype, &params))
 		return -EINVAL;
@@ -3901,36 +3926,11 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
-		/* parse WME attributes if sta is WME capable */
-		if ((rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) &&
-		    (params.sta_flags_set & BIT(NL80211_STA_FLAG_WME)) &&
-		    info->attrs[NL80211_ATTR_STA_WME]) {
-			struct nlattr *tb[NL80211_STA_WME_MAX + 1];
-			struct nlattr *nla;
-
-			nla = info->attrs[NL80211_ATTR_STA_WME];
-			err = nla_parse_nested(tb, NL80211_STA_WME_MAX, nla,
-					       nl80211_sta_wme_policy);
-			if (err)
-				return err;
-
-			if (tb[NL80211_STA_WME_UAPSD_QUEUES])
-				params.uapsd_queues =
-				     nla_get_u8(tb[NL80211_STA_WME_UAPSD_QUEUES]);
-			if (params.uapsd_queues &
-					~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
-				return -EINVAL;
+		/* ignore WME attributes if iface/sta is not capable */
+		if (!(rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) ||
+		    !(params.sta_flags_set & BIT(NL80211_STA_FLAG_WME)))
+			params.sta_modify_mask &= ~STATION_PARAM_APPLY_UAPSD;
 
-			if (tb[NL80211_STA_WME_MAX_SP])
-				params.max_sp =
-				     nla_get_u8(tb[NL80211_STA_WME_MAX_SP]);
-
-			if (params.max_sp &
-					~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
-				return -EINVAL;
-
-			params.sta_modify_mask |= STATION_PARAM_APPLY_UAPSD;
-		}
 		/* TDLS peers cannot be added */
 		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 			return -EINVAL;
@@ -3951,6 +3951,9 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.vlan);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
+		/* ignore uAPSD data */
+		params.sta_modify_mask &= ~STATION_PARAM_APPLY_UAPSD;
+
 		/* associated is disallowed */
 		if (params.sta_flags_mask & BIT(NL80211_STA_FLAG_ASSOCIATED))
 			return -EINVAL;
@@ -3959,6 +3962,9 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		break;
 	case NL80211_IFTYPE_STATION:
+		/* ignore uAPSD data */
+		params.sta_modify_mask &= ~STATION_PARAM_APPLY_UAPSD;
+
 		/* associated is disallowed */
 		if (params.sta_flags_mask & BIT(NL80211_STA_FLAG_ASSOCIATED))
 			return -EINVAL;
-- 
1.8.0

