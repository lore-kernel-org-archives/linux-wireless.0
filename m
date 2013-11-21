Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55843 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3KUOfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 09:35:22 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [RFC 1/3] mac80211: modify beacon using sdata/wdev-lock, not rtnl lock
Date: Thu, 21 Nov 2013 15:34:20 +0100
Message-Id: <1385044462-23046-2-git-send-email-sw@simonwunderlich.de> (sfid-20131121_153528_151774_0D5F34F6)
In-Reply-To: <1385044462-23046-1-git-send-email-sw@simonwunderlich.de>
References: <1385044462-23046-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The csa finalize worker needs to change the beacon information (for
different modes). These are normally protected under rtnl lock, but the
csa finalize worker is called by drivers and should not acquire the RTNL
lock. Therefore change access protection for beacons to sdata/wdev lock.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/cfg.c         |  114 +++++++++++++++++++++++++++++---------------
 net/mac80211/ieee80211_i.h |    3 ++
 2 files changed, 78 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1f07aa6..433d5cd 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -857,7 +857,7 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	if (!resp || !resp_len)
 		return 1;
 
-	old = rtnl_dereference(sdata->u.ap.probe_resp);
+	old = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
 	new = kzalloc(sizeof(struct probe_resp) + resp_len, GFP_KERNEL);
 	if (!new)
@@ -881,7 +881,8 @@ int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	int size, err;
 	u32 changed = BSS_CHANGED_BEACON;
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
+	old = sdata_dereference(sdata->u.ap.beacon, sdata);
+
 
 	/* Need to have a beacon head if we don't have one yet */
 	if (!params->head && !old)
@@ -958,9 +959,12 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		      BSS_CHANGED_P2P_PS;
 	int err;
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
-	if (old)
-		return -EALREADY;
+	sdata_lock(sdata);
+	old = sdata_dereference(sdata->u.ap.beacon, sdata);
+	if (old) {
+		err = -EALREADY;
+		goto out;
+	}
 
 	/* TODO: make hostapd tell us what it wants */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
@@ -970,7 +974,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
 	if (err)
-		return err;
+		goto out;
 	ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
 
 	/*
@@ -1015,16 +1019,17 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	err = ieee80211_assign_beacon(sdata, &params->beacon);
 	if (err < 0)
-		return err;
+		goto out;
 	changed |= err;
 
 	err = drv_start_ap(sdata->local, sdata);
 	if (err) {
-		old = rtnl_dereference(sdata->u.ap.beacon);
+		old = sdata_dereference(sdata->u.ap.beacon, sdata);
+
 		if (old)
 			kfree_rcu(old, rcu_head);
 		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
-		return err;
+		goto out;
 	}
 
 	ieee80211_bss_info_change_notify(sdata, changed);
@@ -1033,7 +1038,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		netif_carrier_on(vlan->dev);
 
-	return 0;
+	err = 0;
+out:
+	sdata_unlock(sdata);
+	return err;
 }
 
 static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
@@ -1045,21 +1053,30 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	sdata_lock(sdata);
 	/* don't allow changing the beacon while CSA is in place - offset
 	 * of channel switch counter may change
 	 */
-	if (sdata->vif.csa_active)
-		return -EBUSY;
+	if (sdata->vif.csa_active) {
+		err = -EBUSY;
+		goto out;
+	}
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
-	if (!old)
-		return -ENOENT;
+	old = sdata_dereference(sdata->u.ap.beacon, sdata);
+	if (!old) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	err = ieee80211_assign_beacon(sdata, params);
 	if (err < 0)
-		return err;
+		goto out;
 	ieee80211_bss_info_change_notify(sdata, err);
-	return 0;
+
+	err = 0;
+out:
+	sdata_unlock(sdata);
+	return err;
 }
 
 static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
@@ -1071,10 +1088,10 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	struct probe_resp *old_probe_resp;
 	struct cfg80211_chan_def chandef;
 
-	old_beacon = rtnl_dereference(sdata->u.ap.beacon);
+	old_beacon = sdata_dereference(sdata->u.ap.beacon, sdata);
 	if (!old_beacon)
 		return -ENOENT;
-	old_probe_resp = rtnl_dereference(sdata->u.ap.probe_resp);
+	old_probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
 	/* abort any running channel switch */
 	sdata->vif.csa_active = false;
@@ -1974,9 +1991,13 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	enum ieee80211_band band;
 	u32 changed = 0;
+	int ret;
 
-	if (!rtnl_dereference(sdata->u.ap.beacon))
-		return -ENOENT;
+	sdata_lock(sdata);
+	if (!sdata_dereference(sdata->u.ap.beacon, sdata)) {
+		ret = -ENOENT;
+		goto out;
+	}
 
 	band = ieee80211_get_sdata_band(sdata);
 
@@ -2043,8 +2064,11 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}
 
 	ieee80211_bss_info_change_notify(sdata, changed);
+	ret = 0;
+out:
+	sdata_unlock(sdata);
 
-	return 0;
+	return ret;
 }
 
 static int ieee80211_set_txq_params(struct wiphy *wiphy,
@@ -3077,8 +3101,11 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return -EBUSY;
 
 	/* don't allow another channel switch if one is already active. */
-	if (sdata->vif.csa_active)
-		return -EBUSY;
+	sdata_lock(sdata);
+	if (sdata->vif.csa_active) {
+		err = -EBUSY;
+		goto out;
+	}
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
@@ -3087,59 +3114,63 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		sdata->csa_counter_offset_presp = params->counter_offset_presp;
 		sdata->u.ap.next_beacon =
 			cfg80211_beacon_dup(&params->beacon_after);
-		if (!sdata->u.ap.next_beacon)
-			return -ENOMEM;
+		if (!sdata->u.ap.next_beacon) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
 		if (err < 0) {
 			kfree(sdata->u.ap.next_beacon);
-			return err;
+			goto out;
 		}
 		break;
 	case NL80211_IFTYPE_ADHOC:
+		err = -EINVAL;
 		if (!sdata->vif.bss_conf.ibss_joined)
-			return -EINVAL;
+			goto out;
 
 		if (params->chandef.width != sdata->u.ibss.chandef.width)
-			return -EINVAL;
+			goto out;
 
 		switch (params->chandef.width) {
 		case NL80211_CHAN_WIDTH_40:
 			if (cfg80211_get_chandef_type(&params->chandef) !=
 			    cfg80211_get_chandef_type(&sdata->u.ibss.chandef))
-				return -EINVAL;
+				goto out;
 		case NL80211_CHAN_WIDTH_5:
 		case NL80211_CHAN_WIDTH_10:
 		case NL80211_CHAN_WIDTH_20_NOHT:
 		case NL80211_CHAN_WIDTH_20:
 			break;
 		default:
-			return -EINVAL;
+			goto out;
 		}
 
 		/* changes into another band are not supported */
 		if (sdata->u.ibss.chandef.chan->band !=
 		    params->chandef.chan->band)
-			return -EINVAL;
+			goto out;
 
 		err = ieee80211_ibss_csa_beacon(sdata, params);
 		if (err < 0)
-			return err;
+			goto out;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 		ifmsh = &sdata->u.mesh;
 
+		err = -EINVAL;
 		if (!ifmsh->mesh_id)
-			return -EINVAL;
+			goto out;
 
 		if (params->chandef.width != sdata->vif.bss_conf.chandef.width)
-			return -EINVAL;
+			goto out;
 
 		/* changes into another band are not supported */
 		if (sdata->vif.bss_conf.chandef.chan->band !=
 		    params->chandef.chan->band)
-			return -EINVAL;
+			goto out;
 
 		ifmsh->chsw_init = true;
 		if (!ifmsh->pre_value)
@@ -3150,12 +3181,13 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		err = ieee80211_mesh_csa_beacon(sdata, params, true);
 		if (err < 0) {
 			ifmsh->chsw_init = false;
-			return err;
+			goto out;
 		}
 		break;
 #endif
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto out;
 	}
 
 	sdata->csa_radar_required = params->radar_required;
@@ -3171,7 +3203,11 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	ieee80211_bss_info_change_notify(sdata, err);
 	drv_channel_switch_beacon(sdata, &params->chandef);
 
-	return 0;
+	err = 0;
+out:
+	sdata_unlock(sdata);
+
+	return err;
 }
 
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 61ccf0d..01e4d9b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -812,6 +812,9 @@ static inline void sdata_unlock(struct ieee80211_sub_if_data *sdata)
 	__release(&sdata->wdev.mtx);
 }
 
+#define sdata_dereference(p, sdata) \
+	rcu_dereference_protected(p, &sdata->wdev.mtx)
+
 static inline void
 sdata_assert_lock(struct ieee80211_sub_if_data *sdata)
 {
-- 
1.7.10.4

