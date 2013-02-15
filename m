Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3BOMLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:11:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC/RFT v2 4/4] cfg80211: comprehensively check station changes
Date: Fri, 15 Feb 2013 13:11:01 +0100
Message-Id: <1360930261-30265-5-git-send-email-johannes@sipsolutions.net> (sfid-20130215_131121_285293_688DE469)
In-Reply-To: <1360930261-30265-1-git-send-email-johannes@sipsolutions.net>
References: <1360930261-30265-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The station change API isn't being checked properly before
drivers are called, and as a result it is difficult to see
what should be allowed and what not.

In order to comprehensively check the API parameters parse
everything first, and then have the driver call a function
(cfg80211_check_station_change()) with the additionally
information about the kind of station that is being changed;
this allows the function to make better decisions than the
old code could.

While at it, also add a few checks, particularly in mesh.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   8 +-
 include/net/cfg80211.h                     |  46 ++++-
 net/mac80211/cfg.c                         | 101 ++++++-----
 net/wireless/nl80211.c                     | 278 +++++++++++++++++------------
 4 files changed, 267 insertions(+), 166 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a7fb442..76e34a8 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2992,13 +2992,15 @@ static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
+	int err;
 
 	if (vif->nw_type != AP_NETWORK)
 		return -EOPNOTSUPP;
 
-	/* Use this only for authorizing/unauthorizing a station */
-	if (!(params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)))
-		return -EOPNOTSUPP;
+	err = cfg80211_check_station_change(wiphy, params,
+					    CFG80211_STA_AP_MLME_CLIENT);
+	if (err)
+		return err;
 
 	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_AUTHORIZED))
 		return ath6kl_wmi_ap_set_mlme(ar->wmi, vif->fw_vif_idx,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4b3b614..078fc05 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -678,6 +678,47 @@ struct station_parameters {
 };
 
 /**
+ * enum cfg80211_station_type - the type of station being modified
+ * @CFG80211_STA_AP_CLIENT: client of an AP interface
+ * @CFG80211_STA_AP_MLME_CLIENT: client of an AP interface that has
+ *	the AP MLME in the device
+ * @CFG80211_STA_AP_STA: AP station on managed interface
+ * @CFG80211_STA_IBSS: IBSS station
+ * @CFG80211_STA_TDLS_PEER_SETUP: TDLS peer on managed interface (dummy entry
+ *	while TDLS setup is in progress)
+ * @CFG80211_STA_TDLS_PEER_ACTIVE: TDLS peer on managed interface (active
+ *	entry that is operating)
+ * @CFG80211_STA_MESH_PEER_NONSEC: peer on mesh interface (non-secured)
+ * @CFG80211_STA_MESH_PEER_SECURE: peer on mesh interface (secured)
+ */
+enum cfg80211_station_type {
+	CFG80211_STA_AP_CLIENT,
+	CFG80211_STA_AP_MLME_CLIENT,
+	CFG80211_STA_AP_STA,
+	CFG80211_STA_IBSS,
+	CFG80211_STA_TDLS_PEER_SETUP,
+	CFG80211_STA_TDLS_PEER_ACTIVE,
+	CFG80211_STA_MESH_PEER_NONSEC,
+	CFG80211_STA_MESH_PEER_SECURE,
+};
+
+/**
+ * cfg80211_check_station_change - validate parameter changes
+ * @wiphy: the wiphy this operates on
+ * @params: the new parameters for a station
+ * @statype: the type of station being modified
+ *
+ * Utility function for the @change_station driver method. Call this function
+ * with the appropriate station type looking up the station (and checking that
+ * it exists). It will verify whether the station change is acceptable, and if
+ * not will return an error code. Note that it may modify the parameters for
+ * backward compatibility reasons, so don't use them before calling this.
+ */
+int cfg80211_check_station_change(struct wiphy *wiphy,
+				  struct station_parameters *params,
+				  enum cfg80211_station_type statype);
+
+/**
  * enum station_info_flags - station information flags
  *
  * Used by the driver to indicate which info in &struct station_info
@@ -1770,9 +1811,8 @@ struct cfg80211_gtk_rekey_data {
  * @change_station: Modify a given station. Note that flags changes are not much
  *	validated in cfg80211, in particular the auth/assoc/authorized flags
  *	might come to the driver in invalid combinations -- make sure to check
- *	them, also against the existing state! Also, supported_rates changes are
- *	not checked in station mode -- drivers need to reject (or ignore) them
- *	for anything but TDLS peers.
+ *	them, also against the existing state! Drivers must call
+ *	cfg80211_check_station_change() to validate the information.
  * @get_station: get station information for the station identified by @mac
  * @dump_station: dump station callback -- resume dump at index @idx
  *
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8e1a03e..674efe7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1261,9 +1261,8 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		u32 changed = 0;
-		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED &&
-		    (params->sta_modify_mask &
-					STATION_PARAM_APPLY_PLINK_STATE)) {
+
+		if (params->sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE) {
 			switch (params->plink_state) {
 			case NL80211_PLINK_ESTAB:
 				if (sta->plink_state != NL80211_PLINK_ESTAB)
@@ -1294,21 +1293,18 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				/*  nothing  */
 				break;
 			}
-		} else if (params->sta_modify_mask &
-					STATION_PARAM_APPLY_PLINK_STATE) {
-			return -EINVAL;
-		} else {
-			switch (params->plink_action) {
-			case NL80211_PLINK_ACTION_NO_ACTION:
-				/* nothing */
-				break;
-			case NL80211_PLINK_ACTION_OPEN:
-				changed |= mesh_plink_open(sta);
-				break;
-			case NL80211_PLINK_ACTION_BLOCK:
-				changed |= mesh_plink_block(sta);
-				break;
-			}
+		}
+
+		switch (params->plink_action) {
+		case NL80211_PLINK_ACTION_NO_ACTION:
+			/* nothing */
+			break;
+		case NL80211_PLINK_ACTION_OPEN:
+			changed |= mesh_plink_open(sta);
+			break;
+		case NL80211_PLINK_ACTION_BLOCK:
+			changed |= mesh_plink_block(sta);
+			break;
 		}
 
 		if (params->local_pm)
@@ -1402,50 +1398,69 @@ static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_change_station(struct wiphy *wiphy,
-				    struct net_device *dev,
-				    u8 *mac,
+				    struct net_device *dev, u8 *mac,
 				    struct station_parameters *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
+	enum cfg80211_station_type statype;
 	int err;
 
 	mutex_lock(&local->sta_mtx);
 
 	sta = sta_info_get_bss(sdata, mac);
 	if (!sta) {
-		mutex_unlock(&local->sta_mtx);
-		return -ENOENT;
+		err = -ENOENT;
+		goto out_err;
 	}
 
-	/* in station mode, some updates are only valid with TDLS */
-	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    (params->supported_rates || params->ht_capa || params->vht_capa ||
-	     params->sta_modify_mask ||
-	     (params->sta_flags_mask & BIT(NL80211_STA_FLAG_WME))) &&
-	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
-		mutex_unlock(&local->sta_mtx);
-		return -EINVAL;
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_MESH_POINT:
+		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
+			statype = CFG80211_STA_MESH_PEER_SECURE;
+		else
+			statype = CFG80211_STA_MESH_PEER_NONSEC;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		statype = CFG80211_STA_IBSS;
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
+			statype = CFG80211_STA_AP_STA;
+			break;
+		}
+		/* if we already have supported rates */
+		if (sta->sta.supp_rates[band])
+			statype = CFG80211_STA_TDLS_PEER_ACTIVE;
+		else
+			statype = CFG80211_STA_TDLS_PEER_SETUP;
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		statype = CFG80211_STA_AP_CLIENT;
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		goto out_err;
 	}
 
+	err = cfg80211_check_station_change(wiphy, params, statype);
+	if (err)
+		goto out_err;
+
 	if (params->vlan && params->vlan != sta->sdata->dev) {
 		bool prev_4addr = false;
 		bool new_4addr = false;
 
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
-		if (vlansdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    vlansdata->vif.type != NL80211_IFTYPE_AP) {
-			mutex_unlock(&local->sta_mtx);
-			return -EINVAL;
-		}
-
 		if (params->vlan->ieee80211_ptr->use_4addr) {
 			if (vlansdata->u.vlan.sta) {
-				mutex_unlock(&local->sta_mtx);
-				return -EBUSY;
+				err = -EBUSY;
+				goto out_err;
 			}
 
 			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
@@ -1472,10 +1487,8 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	}
 
 	err = sta_apply_parameters(local, sta, params);
-	if (err) {
-		mutex_unlock(&local->sta_mtx);
-		return err;
-	}
+	if (err)
+		goto out_err;
 
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) && params->supported_rates)
 		rate_control_rate_init(sta);
@@ -1487,7 +1500,11 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		ieee80211_recalc_ps(local, -1);
 		ieee80211_recalc_ps_vif(sdata);
 	}
+
 	return 0;
+out_err:
+	mutex_unlock(&local->sta_mtx);
+	return err;
 }
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 148053c..b52fd9b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3531,6 +3531,141 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 	return genlmsg_reply(msg, info);
 }
 
+int cfg80211_check_station_change(struct wiphy *wiphy,
+				  struct station_parameters *params,
+				  enum cfg80211_station_type statype)
+{
+	if (params->listen_interval != -1)
+		return -EINVAL;
+	if (params->aid)
+		return -EINVAL;
+	/* only these flags exist at all */
+	if (params->sta_flags_mask & ~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
+				       BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
+				       BIT(NL80211_STA_FLAG_WME) |
+				       BIT(NL80211_STA_FLAG_MFP) |
+				       BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				       BIT(NL80211_STA_FLAG_TDLS_PEER) |
+				       BIT(NL80211_STA_FLAG_ASSOCIATED)))
+		return -EINVAL;
+	if (params->sta_flags_set & ~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
+				      BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
+				      BIT(NL80211_STA_FLAG_WME) |
+				      BIT(NL80211_STA_FLAG_MFP) |
+				      BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				      BIT(NL80211_STA_FLAG_TDLS_PEER) |
+				      BIT(NL80211_STA_FLAG_ASSOCIATED)))
+		return -EINVAL;
+
+	switch (statype) {
+	case CFG80211_STA_MESH_PEER_NONSEC:
+	case CFG80211_STA_MESH_PEER_SECURE:
+		/*
+		 * No ignoring the TDLS flag here -- the userspace mesh
+		 * code doesn't have the bug of including TDLS in the
+		 * mask everywhere.
+		 */
+		if (params->sta_flags_mask &
+				~(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				  BIT(NL80211_STA_FLAG_MFP) |
+				  BIT(NL80211_STA_FLAG_AUTHORIZED)))
+			return -EINVAL;
+		break;
+	default:
+		/* disallow mesh-specific things */
+		if (params->plink_action != NL80211_PLINK_ACTION_NO_ACTION)
+			return -EINVAL;
+		if (params->local_pm)
+			return -EINVAL;
+		if (params->sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE)
+			return -EINVAL;
+	}
+
+	if (statype != CFG80211_STA_TDLS_PEER_SETUP &&
+	    statype != CFG80211_STA_TDLS_PEER_ACTIVE) {
+		/* TDLS can't be set, ... */
+		if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
+			return -EINVAL;
+		/*
+		 * ... but don't bother the driver with it. This works around
+		 * a hostapd/wpa_supplicant issue -- it always includes the
+		 * TLDS_PEER flag in the mask even for AP mode.
+		 */
+		params->sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
+	}
+
+	if (statype != CFG80211_STA_TDLS_PEER_SETUP) {
+		/* reject other things that can't change */
+		if (params->sta_modify_mask & STATION_PARAM_APPLY_UAPSD)
+			return -EINVAL;
+		if (params->sta_modify_mask & STATION_PARAM_APPLY_CAPABILITY)
+			return -EINVAL;
+		if (params->supported_rates)
+			return -EINVAL;
+		if (params->ext_capab || params->ht_capa || params->vht_capa)
+			return -EINVAL;
+	}
+
+	if (statype != CFG80211_STA_AP_CLIENT) {
+		if (params->vlan)
+			return -EINVAL;
+	}
+
+	switch (statype) {
+	case CFG80211_STA_AP_MLME_CLIENT:
+		/* Use this only for authorizing/unauthorizing a station */
+		if (!(params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)))
+			return -EOPNOTSUPP;
+		break;
+	case CFG80211_STA_AP_CLIENT:
+		/* accept only the listed bits */
+		if (params->sta_flags_mask &
+				~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
+				  BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				  BIT(NL80211_STA_FLAG_ASSOCIATED) |
+				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
+				  BIT(NL80211_STA_FLAG_WME) |
+				  BIT(NL80211_STA_FLAG_MFP)))
+			return -EINVAL;
+
+		/* but authenticated/associated only if driver handles it */
+		if (!(wiphy->features & NL80211_FEATURE_FULL_AP_CLIENT_STATE) &&
+		    params->sta_flags_mask &
+				(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				 BIT(NL80211_STA_FLAG_ASSOCIATED)))
+			return -EINVAL;
+		break;
+	case CFG80211_STA_IBSS:
+	case CFG80211_STA_AP_STA:
+		/* reject any changes other than AUTHORIZED */
+		if (params->sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
+			return -EINVAL;
+		break;
+	case CFG80211_STA_TDLS_PEER_SETUP:
+		/* reject any changes other than AUTHORIZED or WME */
+		if (params->sta_flags_mask & ~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
+					       BIT(NL80211_STA_FLAG_WME)))
+			return -EINVAL;
+		break;
+	case CFG80211_STA_TDLS_PEER_ACTIVE:
+		/* reject any changes other than AUTHORIZED */
+		if (params->sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
+			return -EINVAL;
+		break;
+	case CFG80211_STA_MESH_PEER_NONSEC:
+		if (params->sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE)
+			return -EINVAL;
+		break;
+	case CFG80211_STA_MESH_PEER_SECURE:
+		if (params->plink_action != NL80211_PLINK_ACTION_NO_ACTION)
+			return -EINVAL;
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_check_station_change);
+
 /*
  * Get vlan interface making sure it is running and on the right wiphy.
  */
@@ -3553,6 +3688,13 @@ static struct net_device *get_vlan(struct genl_info *info,
 		goto error;
 	}
 
+	if (v->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    v->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    v->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) {
+		ret = -EINVAL;
+		goto error;
+	}
+
 	if (!netif_running(v)) {
 		ret = -ENETDOWN;
 		goto error;
@@ -3631,15 +3773,18 @@ static int nl80211_set_station_tdls(struct genl_info *info,
 static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	int err;
 	struct net_device *dev = info->user_ptr[1];
 	struct station_parameters params;
-	u8 *mac_addr = NULL;
+	u8 *mac_addr;
+	int err;
 
 	memset(&params, 0, sizeof(params));
 
 	params.listen_interval = -1;
 
+	if (!rdev->ops->change_station)
+		return -EOPNOTSUPP;
+
 	if (info->attrs[NL80211_ATTR_STA_AID])
 		return -EINVAL;
 
@@ -3671,9 +3816,6 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
 		return -EINVAL;
 
-	if (!rdev->ops->change_station)
-		return -EOPNOTSUPP;
-
 	if (parse_station_flags(info, dev->ieee80211_ptr->iftype, &params))
 		return -EINVAL;
 
@@ -3703,133 +3845,33 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.local_pm = pm;
 	}
 
+	/* Include parameters for TDLS peer (will check later) */
+	err = nl80211_set_station_tdls(info, &params);
+	if (err)
+		return err;
+
+	params.vlan = get_vlan(info, rdev);
+	if (IS_ERR(params.vlan))
+		return PTR_ERR(params.vlan);
+
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
-		/* disallow mesh-specific things */
-		if (params.plink_action)
-			return -EINVAL;
-		if (params.local_pm)
-			return -EINVAL;
-		if (params.sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE)
-			return -EINVAL;
-
-		/* TDLS can't be set, ... */
-		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
-			return -EINVAL;
-		/*
-		 * ... but don't bother the driver with it. This works around
-		 * a hostapd/wpa_supplicant issue -- it always includes the
-		 * TLDS_PEER flag in the mask even for AP mode.
-		 */
-		params.sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
-
-		/* accept only the listed bits */
-		if (params.sta_flags_mask &
-				~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
-				  BIT(NL80211_STA_FLAG_AUTHENTICATED) |
-				  BIT(NL80211_STA_FLAG_ASSOCIATED) |
-				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
-				  BIT(NL80211_STA_FLAG_WME) |
-				  BIT(NL80211_STA_FLAG_MFP)))
-			return -EINVAL;
-
-		/* but authenticated/associated only if driver handles it */
-		if (!(rdev->wiphy.features &
-				NL80211_FEATURE_FULL_AP_CLIENT_STATE) &&
-		    params.sta_flags_mask &
-				(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
-				 BIT(NL80211_STA_FLAG_ASSOCIATED)))
-			return -EINVAL;
-
-		/* reject other things that can't change */
-		if (params.supported_rates)
-			return -EINVAL;
-		if (info->attrs[NL80211_ATTR_STA_CAPABILITY])
-			return -EINVAL;
-		if (info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY])
-			return -EINVAL;
-		if (info->attrs[NL80211_ATTR_HT_CAPABILITY] ||
-		    info->attrs[NL80211_ATTR_VHT_CAPABILITY])
-			return -EINVAL;
-
-		/* must be last in here for error handling */
-		params.vlan = get_vlan(info, rdev);
-		if (IS_ERR(params.vlan))
-			return PTR_ERR(params.vlan);
-		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		/*
-		 * Don't allow userspace to change the TDLS_PEER flag,
-		 * but silently ignore attempts to change it since we
-		 * don't have state here to verify that it doesn't try
-		 * to change the flag.
-		 */
-		params.sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
-		/* Include parameters for TDLS peer (driver will check) */
-		err = nl80211_set_station_tdls(info, &params);
-		if (err)
-			return err;
-		/* disallow things sta doesn't support */
-		if (params.plink_action)
-			return -EINVAL;
-		if (params.local_pm)
-			return -EINVAL;
-		if (params.sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE)
-			return -EINVAL;
-		/* reject any changes other than AUTHORIZED or WME (for TDLS) */
-		if (params.sta_flags_mask & ~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
-					      BIT(NL80211_STA_FLAG_WME)))
-			return -EINVAL;
-		break;
 	case NL80211_IFTYPE_ADHOC:
-		/* disallow things sta doesn't support */
-		if (params.plink_action)
-			return -EINVAL;
-		if (params.local_pm)
-			return -EINVAL;
-		if (params.sta_modify_mask & STATION_PARAM_APPLY_PLINK_STATE)
-			return -EINVAL;
-		if (info->attrs[NL80211_ATTR_HT_CAPABILITY] ||
-		    info->attrs[NL80211_ATTR_VHT_CAPABILITY])
-			return -EINVAL;
-		/* reject any changes other than AUTHORIZED */
-		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
-			return -EINVAL;
-		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		/* disallow things mesh doesn't support */
-		if (params.vlan)
-			return -EINVAL;
-		if (params.supported_rates)
-			return -EINVAL;
-		if (info->attrs[NL80211_ATTR_STA_CAPABILITY])
-			return -EINVAL;
-		if (info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY])
-			return -EINVAL;
-		if (info->attrs[NL80211_ATTR_HT_CAPABILITY] ||
-		    info->attrs[NL80211_ATTR_VHT_CAPABILITY])
-			return -EINVAL;
-		/*
-		 * No special handling for TDLS here -- the userspace
-		 * mesh code doesn't have this bug.
-		 */
-		if (params.sta_flags_mask &
-				~(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
-				  BIT(NL80211_STA_FLAG_MFP) |
-				  BIT(NL80211_STA_FLAG_AUTHORIZED)))
-			return -EINVAL;
 		break;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto out_put_vlan;
 	}
 
-	/* be aware of params.vlan when changing code here */
-
+	/* driver will call cfg80211_check_station_change() */
 	err = rdev_change_station(rdev, dev, mac_addr, &params);
 
+ out_put_vlan:
 	if (params.vlan)
 		dev_put(params.vlan);
 
-- 
1.8.0

