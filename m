Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7336 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab3BNTLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 14:11:14 -0500
Date: Thu, 14 Feb 2013 21:10:54 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] cfg80211: Pass TDLS peer's QoS/HT/VHT information during
 set_station
Message-ID: <20130214191054.GA29004@jouni.qca.qualcomm.com> (sfid-20130214_201117_553578_DCE88630)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The information of the peer's capabilities is required for the driver
to perform TDLS Peer UAPSD operations. This information of the peer is
passed by the supplicant using NL80211_CMD_SET_STATION command. This
commit enhances the function nl80211_set_station to pass this
information of the peer to the driver in case this command is used
with the TDLS peer STA.

In addition, make the HT/VHT capability configuration handled more
consistently for other STA cases (reject both instead of just HT).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/cfg.c     |    6 ++--
 net/wireless/nl80211.c |   89 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 85 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a4c0a0d..76107a2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1411,9 +1411,11 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		return -ENOENT;
 	}
 
-	/* in station mode, supported rates are only valid with TDLS */
+	/* in station mode, some updates are only valid with TDLS */
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    params->supported_rates &&
+	    (params->supported_rates || params->ht_capa || params->vht_capa ||
+	     params->sta_modify_mask ||
+	     (params->sta_flags_mask & BIT(NL80211_STA_FLAG_WME))) &&
 	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
 		mutex_unlock(&local->sta_mtx);
 		return -EINVAL;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1216573..ee59443 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3302,6 +3302,63 @@ static struct net_device *get_vlan(struct genl_info *info,
 	return ERR_PTR(ret);
 }
 
+static struct nla_policy
+nl80211_sta_wme_policy[NL80211_STA_WME_MAX + 1] __read_mostly = {
+	[NL80211_STA_WME_UAPSD_QUEUES] = { .type = NLA_U8 },
+	[NL80211_STA_WME_MAX_SP] = { .type = NLA_U8 },
+};
+
+static int nl80211_set_station_tdls(struct genl_info *info,
+				    struct station_parameters *params)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct nlattr *tb[NL80211_STA_WME_MAX + 1];
+	struct nlattr *nla;
+	int err;
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
+	/* parse WME attributes if present */
+	if (!info->attrs[NL80211_ATTR_STA_WME])
+		return 0;
+
+	nla = info->attrs[NL80211_ATTR_STA_WME];
+	err = nla_parse_nested(tb, NL80211_STA_WME_MAX, nla,
+			       nl80211_sta_wme_policy);
+	if (err)
+		return err;
+
+	if (tb[NL80211_STA_WME_UAPSD_QUEUES])
+		params->uapsd_queues = nla_get_u8(
+			tb[NL80211_STA_WME_UAPSD_QUEUES]);
+	if (params->uapsd_queues & ~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
+		return -EINVAL;
+
+	if (tb[NL80211_STA_WME_MAX_SP])
+		params->max_sp = nla_get_u8(tb[NL80211_STA_WME_MAX_SP]);
+
+	if (params->max_sp & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
+		return -EINVAL;
+
+	params->sta_modify_mask |= STATION_PARAM_APPLY_UAPSD;
+
+	return 0;
+}
+
 static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -3343,8 +3400,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_len(info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY]);
 	}
 
-	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL] ||
-	    info->attrs[NL80211_ATTR_HT_CAPABILITY])
+	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
 		return -EINVAL;
 
 	if (!rdev->ops->change_station)
@@ -3417,6 +3473,9 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		if (info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY])
 			return -EINVAL;
+		if (info->attrs[NL80211_ATTR_HT_CAPABILITY] ||
+		    info->attrs[NL80211_ATTR_VHT_CAPABILITY])
+			return -EINVAL;
 
 		/* must be last in here for error handling */
 		params.vlan = get_vlan(info, rdev);
@@ -3432,13 +3491,29 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		 * to change the flag.
 		 */
 		params.sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
-		/* fall through */
+		/* Include parameters for TDLS peer (driver will check) */
+		err = nl80211_set_station_tdls(info, &params);
+		if (err)
+			return err;
+		/* disallow things sta doesn't support */
+		if (params.plink_action)
+			return -EINVAL;
+		if (params.local_pm)
+			return -EINVAL;
+		/* reject any changes other than AUTHORIZED or WME (for TDLS) */
+		if (params.sta_flags_mask & ~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
+					      BIT(NL80211_STA_FLAG_WME)))
+			return -EINVAL;
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		/* disallow things sta doesn't support */
 		if (params.plink_action)
 			return -EINVAL;
 		if (params.local_pm)
 			return -EINVAL;
+		if (info->attrs[NL80211_ATTR_HT_CAPABILITY] ||
+		    info->attrs[NL80211_ATTR_VHT_CAPABILITY])
+			return -EINVAL;
 		/* reject any changes other than AUTHORIZED */
 		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
 			return -EINVAL;
@@ -3453,6 +3528,9 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		if (info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY])
 			return -EINVAL;
+		if (info->attrs[NL80211_ATTR_HT_CAPABILITY] ||
+		    info->attrs[NL80211_ATTR_VHT_CAPABILITY])
+			return -EINVAL;
 		/*
 		 * No special handling for TDLS here -- the userspace
 		 * mesh code doesn't have this bug.
@@ -3477,11 +3555,6 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static struct nla_policy
-nl80211_sta_wme_policy[NL80211_STA_WME_MAX + 1] __read_mostly = {
-	[NL80211_STA_WME_UAPSD_QUEUES] = { .type = NLA_U8 },
-	[NL80211_STA_WME_MAX_SP] = { .type = NLA_U8 },
-};
 
 static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 {
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
