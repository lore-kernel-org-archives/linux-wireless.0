Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1LNLX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 06:23:57 -0500
Message-Id: <20111214112312.753668087@sipsolutions.net> (sfid-20111214_122403_836385_D7B9BE17)
Date: Wed, 14 Dec 2011 12:20:27 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] cfg80211: validate nl80211 station handling better
References: <20111214112026.409514167@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The nl80211 station handling code is a bit messy
and doesn't do a lot of validation. It seems like
this could be an issue for drivers that don't use
mac80211 to validate everything.

As cfg80211 doesn't keep station state, move the
validation of allowing supported_rates to change
for TDLS only in station mode to mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    6 +
 include/net/cfg80211.h  |    7 +
 net/mac80211/cfg.c      |    8 +
 net/wireless/nl80211.c  |  205 ++++++++++++++++++++++++++----------------------
 4 files changed, 134 insertions(+), 92 deletions(-)

--- a/net/wireless/nl80211.c	2011-12-14 09:27:34.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-12-14 11:32:00.000000000 +0100
@@ -2579,6 +2579,9 @@ static int nl80211_set_station(struct sk
 		params.ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
 
+	if (!rdev->ops->change_station)
+		return -EOPNOTSUPP;
+
 	if (parse_station_flags(info, &params))
 		return -EINVAL;
 
@@ -2590,73 +2593,84 @@ static int nl80211_set_station(struct sk
 		params.plink_state =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
 
-	params.vlan = get_vlan(info, rdev);
-	if (IS_ERR(params.vlan))
-		return PTR_ERR(params.vlan);
-
-	/* validate settings */
-	err = 0;
-
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
 		/* disallow mesh-specific things */
 		if (params.plink_action)
-			err = -EINVAL;
+			return -EINVAL;
+
+		/* TDLS can't be set, ... */
+		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
+			return -EINVAL;
+		/*
+		 * ... but don't bother the driver with it. This works around
+		 * a hostapd/wpa_supplicant issue -- it always includes the
+		 * TLDS_PEER flag in the mask even for AP mode.
+		 */
+		params.sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
+
+		/* accept only the listed bits */
+		if (params.sta_flags_mask &
+				~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
+				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
+				  BIT(NL80211_STA_FLAG_WME) |
+				  BIT(NL80211_STA_FLAG_MFP)))
+			return -EINVAL;
+
+		/* must be last in here for error handling */
+		params.vlan = get_vlan(info, rdev);
+		if (IS_ERR(params.vlan))
+			return PTR_ERR(params.vlan);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
 		/* disallow things sta doesn't support */
 		if (params.plink_action)
-			err = -EINVAL;
-		if (params.vlan)
-			err = -EINVAL;
-		if (params.supported_rates &&
-		    !(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
-			err = -EINVAL;
+			return -EINVAL;
 		if (params.ht_capa)
-			err = -EINVAL;
+			return -EINVAL;
 		if (params.listen_interval >= 0)
-			err = -EINVAL;
-		if (params.sta_flags_mask &
-				~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
-				  BIT(NL80211_STA_FLAG_TDLS_PEER)))
-			err = -EINVAL;
-		/* can't change the TDLS bit */
-		if (!(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
-		    (params.sta_flags_mask & BIT(NL80211_STA_FLAG_TDLS_PEER)))
-			err = -EINVAL;
+			return -EINVAL;
+		/*
+		 * Don't allow userspace to change the TDLS_PEER flag,
+		 * but silently ignore attempts to change it since we
+		 * don't have state here to verify that it doesn't try
+		 * to change the flag.
+		 */
+		params.sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
+
+		/* reject any changes other than AUTHORIZED */
+		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
+			return -EINVAL;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		/* disallow things mesh doesn't support */
 		if (params.vlan)
-			err = -EINVAL;
+			return -EINVAL;
 		if (params.ht_capa)
-			err = -EINVAL;
+			return -EINVAL;
 		if (params.listen_interval >= 0)
-			err = -EINVAL;
+			return -EINVAL;
+		/*
+		 * No special handling for TDLS here -- the userspace
+		 * mesh code doesn't have this bug.
+		 */
 		if (params.sta_flags_mask &
 				~(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
 				  BIT(NL80211_STA_FLAG_MFP) |
 				  BIT(NL80211_STA_FLAG_AUTHORIZED)))
-			err = -EINVAL;
+			return -EINVAL;
 		break;
 	default:
-		err = -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
-	if (err)
-		goto out;
-
-	if (!rdev->ops->change_station) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	/* be aware of params.vlan when changing code here */
 
 	err = rdev->ops->change_station(&rdev->wiphy, dev, mac_addr, &params);
 
- out:
 	if (params.vlan)
 		dev_put(params.vlan);
 
@@ -2711,70 +2725,81 @@ static int nl80211_new_station(struct sk
 		params.plink_action =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
 
+	if (!rdev->ops->add_station)
+		return -EOPNOTSUPP;
+
 	if (parse_station_flags(info, &params))
 		return -EINVAL;
 
-	/* parse WME attributes if sta is WME capable */
-	if ((rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) &&
-	    (params.sta_flags_set & BIT(NL80211_STA_FLAG_WME)) &&
-	    info->attrs[NL80211_ATTR_STA_WME]) {
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
+	switch (dev->ieee80211_ptr->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_P2P_GO:
+		/* parse WME attributes if sta is WME capable */
+		if ((rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) &&
+		    (params.sta_flags_set & BIT(NL80211_STA_FLAG_WME)) &&
+		    info->attrs[NL80211_ATTR_STA_WME]) {
+			struct nlattr *tb[NL80211_STA_WME_MAX + 1];
+			struct nlattr *nla;
+
+			nla = info->attrs[NL80211_ATTR_STA_WME];
+			err = nla_parse_nested(tb, NL80211_STA_WME_MAX, nla,
+					       nl80211_sta_wme_policy);
+			if (err)
+				return err;
+
+			if (tb[NL80211_STA_WME_UAPSD_QUEUES])
+				params.uapsd_queues =
+				     nla_get_u8(tb[NL80211_STA_WME_UAPSD_QUEUES]);
+			if (params.uapsd_queues &
+					~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
+				return -EINVAL;
+
+			if (tb[NL80211_STA_WME_MAX_SP])
+				params.max_sp =
+				     nla_get_u8(tb[NL80211_STA_WME_MAX_SP]);
+
+			if (params.max_sp &
+					~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
+				return -EINVAL;
+
+			params.sta_modify_mask |= STATION_PARAM_APPLY_UAPSD;
+		}
+		/* TDLS peers cannot be added */
+		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 			return -EINVAL;
+		/* but don't bother the driver with it */
+		params.sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
 
-		if (tb[NL80211_STA_WME_MAX_SP])
-			params.max_sp =
-			     nla_get_u8(tb[NL80211_STA_WME_MAX_SP]);
-
-		if (params.max_sp & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
+		/* must be last in here for error handling */
+		params.vlan = get_vlan(info, rdev);
+		if (IS_ERR(params.vlan))
+			return PTR_ERR(params.vlan);
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		/* TDLS peers cannot be added */
+		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 			return -EINVAL;
-
-		params.sta_modify_mask |= STATION_PARAM_APPLY_UAPSD;
+		break;
+	case NL80211_IFTYPE_STATION:
+		/* Only TDLS peers can be added */
+		if (!(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
+			return -EINVAL;
+		/* Can only add if TDLS ... */
+		if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS))
+			return -EOPNOTSUPP;
+		/* ... with external setup is supported */
+		if (!(rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP))
+			return -EOPNOTSUPP;
+		break;
+	default:
+		return -EOPNOTSUPP;
 	}
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
-		return -EINVAL;
-
-	/*
-	 * Only managed stations can add TDLS peers, and only when the
-	 * wiphy supports external TDLS setup.
-	 */
-	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_STATION &&
-	    !((params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
-	      (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
-	      (rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP)))
-		return -EINVAL;
-
-	params.vlan = get_vlan(info, rdev);
-	if (IS_ERR(params.vlan))
-		return PTR_ERR(params.vlan);
-
-	/* validate settings */
-	err = 0;
-
-	if (!rdev->ops->add_station) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	/* be aware of params.vlan when changing code here */
 
 	err = rdev->ops->add_station(&rdev->wiphy, dev, mac_addr, &params);
 
- out:
 	if (params.vlan)
 		dev_put(params.vlan);
 	return err;
--- a/include/net/cfg80211.h	2011-12-13 21:21:26.000000000 +0100
+++ b/include/net/cfg80211.h	2011-12-14 10:59:23.000000000 +0100
@@ -1346,7 +1346,12 @@ struct cfg80211_gtk_rekey_data {
  *
  * @add_station: Add a new station.
  * @del_station: Remove a station; @mac may be NULL to remove all stations.
- * @change_station: Modify a given station.
+ * @change_station: Modify a given station. Note that flags changes are not much
+ *	validated in cfg80211, in particular the auth/assoc/authorized flags
+ *	might come to the driver in invalid combinations -- make sure to check
+ *	them, also against the existing state! Also, supported_rates changes are
+ *	not checked in station mode -- drivers need to reject (or ignore) them
+ *	for anything but TDLS peers.
  * @get_station: get station information for the station identified by @mac
  * @dump_station: dump station callback -- resume dump at index @idx
  *
--- a/include/linux/nl80211.h	2011-12-14 09:27:34.000000000 +0100
+++ b/include/linux/nl80211.h	2011-12-14 11:38:09.000000000 +0100
@@ -1536,7 +1536,11 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
  * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
- * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer
+ * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer -- this flag should
+ *	only be used in managed mode (even in the flags mask). Note that the
+ *	flag can't be changed, it is only valid while adding a station, and
+ *	attempts to change it will silently be ignored (rather than rejected
+ *	as errors.)
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
--- a/net/mac80211/cfg.c	2011-12-14 10:35:23.000000000 +0100
+++ b/net/mac80211/cfg.c	2011-12-14 11:28:36.000000000 +0100
@@ -976,6 +976,14 @@ static int ieee80211_change_station(stru
 		return -EINVAL;
 	}
 
+	/* in station mode, supported rates are only valid with TDLS */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    params->supported_rates &&
+	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
 	if (params->vlan && params->vlan != sta->sdata->dev) {
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 


