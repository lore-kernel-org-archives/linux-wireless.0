Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2G0LSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:18:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 20/20] mac80211: use channel contexts
Date: Fri, 27 Jul 2012 13:16:56 +0200
Message-Id: <1343387816-9414-21-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131833_601394_398A8C9E)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of operating on a single channel only,
use the new channel context infrastructure in
all mac80211 code.

This enables drivers that want to use the new
channel context infrastructure to use multiple
channels, while nothing should change for all
the other drivers that don't support it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  169 +++++++++++++++-----------------------------
 net/mac80211/chan.c        |  147 ++++++--------------------------------
 net/mac80211/ibss.c        |   48 +++----------
 net/mac80211/ieee80211_i.h |   16 +----
 net/mac80211/iface.c       |   17 +----
 net/mac80211/main.c        |   34 ++++++---
 net/mac80211/mesh.c        |   11 +--
 net/mac80211/mesh_plink.c  |    6 +-
 net/mac80211/mlme.c        |   57 ++++++++-------
 net/mac80211/rate.h        |    7 +-
 net/mac80211/scan.c        |    2 +-
 net/mac80211/tx.c          |    8 ++-
 net/mac80211/util.c        |    8 ++-
 13 files changed, 173 insertions(+), 357 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7422ebc..90fbb66 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -342,7 +342,7 @@ static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, in
 	if (!(rate->flags & RATE_INFO_FLAGS_MCS)) {
 		struct ieee80211_supported_band *sband;
 		sband = sta->local->hw.wiphy->bands[
-				sta->local->oper_channel->band];
+				sta->sdata->vif.chanctx_conf->channel->band];
 		rate->legacy = sband->bitrates[idx].bitrate;
 	} else
 		rate->mcs = idx;
@@ -574,19 +574,17 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 do_survey:
 	i = STA_STATS_LEN - STA_STATS_SURVEY_LEN;
 	/* Get survey stats for current channel */
-	q = 0;
-	while (true) {
-		survey.filled = 0;
-		if (drv_get_survey(local, q, &survey) != 0) {
+	survey.filled = 0;
+	if (sdata->vif.chanctx_conf) {
+		q = 0;
+		do {
 			survey.filled = 0;
-			break;
-		}
-
-		if (survey.channel &&
-		    (local->oper_channel->center_freq ==
-		     survey.channel->center_freq))
-			break;
-		q++;
+			if (drv_get_survey(local, q, &survey) != 0) {
+				survey.filled = 0;
+				break;
+			}
+			q++;
+		} while (sdata->vif.chanctx_conf->channel != survey.channel);
 	}
 
 	if (survey.filled)
@@ -691,47 +689,12 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
-static int ieee80211_set_channel(struct wiphy *wiphy,
-				 struct net_device *netdev,
-				 struct ieee80211_channel *chan,
-				 enum nl80211_channel_type channel_type)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_sub_if_data *sdata = NULL;
-
-	if (netdev)
-		sdata = IEEE80211_DEV_TO_SUB_IF(netdev);
-
-	switch (ieee80211_get_channel_mode(local, NULL)) {
-	case CHAN_MODE_HOPPING:
-		return -EBUSY;
-	case CHAN_MODE_FIXED:
-		if (local->oper_channel != chan ||
-		    (!sdata && local->_oper_channel_type != channel_type))
-			return -EBUSY;
-		if (!sdata && local->_oper_channel_type == channel_type)
-			return 0;
-		break;
-	case CHAN_MODE_UNDEFINED:
-		break;
-	}
-
-	if (!ieee80211_set_channel_type(local, sdata, channel_type))
-		return -EBUSY;
-
-	local->oper_channel = chan;
-
-	/* auto-detects changes */
-	ieee80211_hw_config(local, 0);
-
-	return 0;
-}
-
 static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 					 struct ieee80211_channel *chan,
 					 enum nl80211_channel_type channel_type)
 {
-	return ieee80211_set_channel(wiphy, NULL, chan, channel_type);
+	return 0;
+//return ieee80211_set_channel(wiphy, NULL, chan, channel_type);
 }
 
 static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
@@ -848,8 +811,9 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (old)
 		return -EALREADY;
 
-	err = ieee80211_set_channel(wiphy, dev, params->channel,
-				    params->channel_type);
+	err = ieee80211_vif_use_channel(sdata, params->channel,
+					params->channel_type,
+					IEEE80211_CHANCTX_SHARED);
 	if (err)
 		return err;
 
@@ -932,6 +896,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	sta_info_flush(sdata->local, sdata);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
+	ieee80211_vif_release_channel(sdata);
+
 	return 0;
 }
 
@@ -988,9 +954,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	int i, j;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	enum ieee80211_band band = sdata->vif.chanctx_conf->channel->band;
 	u32 mask, set;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[band];
 
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
@@ -1105,7 +1072,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 					rates |= BIT(j);
 			}
 		}
-		sta->sta.supp_rates[local->oper_channel->band] = rates;
+		sta->sta.supp_rates[band] = rates;
 	}
 
 	if (params->ht_capa)
@@ -1633,8 +1600,9 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	if (err)
 		return err;
 
-	err = ieee80211_set_channel(wiphy, dev, setup->channel,
-				    setup->channel_type);
+	err = ieee80211_vif_use_channel(sdata, setup->channel,
+					setup->channel_type,
+					IEEE80211_CHANCTX_SHARED);
 	if (err)
 		return err;
 
@@ -1648,6 +1616,7 @@ static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	ieee80211_stop_mesh(sdata);
+	ieee80211_vif_release_channel(sdata);
 
 	return 0;
 }
@@ -1657,10 +1626,11 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct bss_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	u32 changed = 0;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (!rtnl_dereference(sdata->u.ap.beacon))
+		return -ENOENT;
 
 	if (params->use_cts_prot >= 0) {
 		sdata->vif.bss_conf.use_cts_prot = params->use_cts_prot;
@@ -1673,7 +1643,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}
 
 	if (!sdata->vif.bss_conf.use_short_slot &&
-	    sdata->local->oper_channel->band == IEEE80211_BAND_5GHZ) {
+	    sdata->vif.chanctx_conf->channel->band == IEEE80211_BAND_5GHZ) {
 		sdata->vif.bss_conf.use_short_slot = true;
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
@@ -1687,9 +1657,8 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	if (params->basic_rates) {
 		int i, j;
 		u32 rates = 0;
-		struct ieee80211_local *local = wiphy_priv(wiphy);
 		struct ieee80211_supported_band *sband =
-			wiphy->bands[local->oper_channel->band];
+			wiphy->bands[sdata->vif.chanctx_conf->channel->band];
 
 		for (i = 0; i < params->basic_rates_len; i++) {
 			int rate = (params->basic_rates[i] & 0x7f) * 5;
@@ -1841,20 +1810,6 @@ static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_assoc_request *req)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	switch (ieee80211_get_channel_mode(local, sdata)) {
-	case CHAN_MODE_HOPPING:
-		return -EBUSY;
-	case CHAN_MODE_FIXED:
-		if (local->oper_channel == req->bss->channel)
-			break;
-		return -EBUSY;
-	case CHAN_MODE_UNDEFINED:
-		break;
-	}
-
 	return ieee80211_mgd_assoc(IEEE80211_DEV_TO_SUB_IF(dev), req);
 }
 
@@ -1873,30 +1828,12 @@ static int ieee80211_disassoc(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 			       struct cfg80211_ibss_params *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	switch (ieee80211_get_channel_mode(local, sdata)) {
-	case CHAN_MODE_HOPPING:
-		return -EBUSY;
-	case CHAN_MODE_FIXED:
-		if (!params->channel_fixed)
-			return -EBUSY;
-		if (local->oper_channel == params->channel)
-			break;
-		return -EBUSY;
-	case CHAN_MODE_UNDEFINED:
-		break;
-	}
-
-	return ieee80211_ibss_join(sdata, params);
+	return ieee80211_ibss_join(IEEE80211_DEV_TO_SUB_IF(dev), params);
 }
 
 static int ieee80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	return ieee80211_ibss_leave(sdata);
+	return ieee80211_ibss_leave(IEEE80211_DEV_TO_SUB_IF(dev));
 }
 
 static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
@@ -1940,9 +1877,13 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 				  enum nl80211_tx_power_setting type, int mbm)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_channel *chan = local->oper_channel;
+	struct ieee80211_channel *chan = local->_oper_channel;
 	u32 changes = 0;
 
+	/* FIXME */
+	if (local->use_chanctx)
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case NL80211_TX_POWER_AUTOMATIC:
 		local->user_power_level = -1;
@@ -2488,10 +2429,14 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	/* Check if the operating channel is the requested channel */
 	if (!need_offchan) {
-		need_offchan = chan != local->oper_channel;
-		if (channel_type_valid &&
-		    channel_type != local->_oper_channel_type)
+		if (sdata->vif.chanctx_conf) {
+			need_offchan = chan != sdata->vif.chanctx_conf->channel;
+			if (channel_type_valid &&
+			    channel_type != sdata->vif.chanctx_conf->channel_type)
+				need_offchan = true;
+		} else {
 			need_offchan = true;
+		}
 	}
 
 	if (need_offchan && !offchan) {
@@ -2640,7 +2585,7 @@ static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
 	u16 capab;
 
 	capab = 0;
-	if (local->oper_channel->band != IEEE80211_BAND_2GHZ)
+	if (sdata->vif.chanctx_conf->channel->band != IEEE80211_BAND_2GHZ)
 		return capab;
 
 	if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
@@ -2672,7 +2617,6 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 			       u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tdls_data *tf;
 
 	tf = (void *)skb_put(skb, offsetof(struct ieee80211_tdls_data, u));
@@ -2693,9 +2637,9 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
 		ieee80211_add_srates_ie(sdata, skb, false,
-					local->oper_channel->band);
+				sdata->vif.chanctx_conf->channel->band);
 		ieee80211_add_ext_srates_ie(sdata, skb, false,
-					    local->oper_channel->band);
+				sdata->vif.chanctx_conf->channel->band);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
@@ -2709,9 +2653,9 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
 		ieee80211_add_srates_ie(sdata, skb, false,
-					local->oper_channel->band);
+				sdata->vif.chanctx_conf->channel->band);
 		ieee80211_add_ext_srates_ie(sdata, skb, false,
-					    local->oper_channel->band);
+				sdata->vif.chanctx_conf->channel->band);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
@@ -2749,7 +2693,6 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 			   u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgmt *mgmt;
 
 	mgmt = (void *)skb_put(skb, 24);
@@ -2773,9 +2716,9 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
 		ieee80211_add_srates_ie(sdata, skb, false,
-					local->oper_channel->band);
+				sdata->vif.chanctx_conf->channel->band);
 		ieee80211_add_ext_srates_ie(sdata, skb, false,
-					    local->oper_channel->band);
+				sdata->vif.chanctx_conf->channel->band);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	default:
@@ -3015,10 +2958,14 @@ static struct ieee80211_channel *
 ieee80211_cfg_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 			  enum nl80211_channel_type *type)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	if (sdata->vif.chanctx_conf) {
+		*type = sdata->vif.chanctx_conf->channel_type;
+		return sdata->vif.chanctx_conf->channel;
+	}
 
-	*type = local->_oper_channel_type;
-	return local->oper_channel;
+	return NULL;
 }
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 0542123..88bae9e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -7,106 +7,6 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
-static enum ieee80211_chan_mode
-__ieee80211_get_channel_mode(struct ieee80211_local *local,
-			     struct ieee80211_sub_if_data *ignore)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	lockdep_assert_held(&local->iflist_mtx);
-
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata == ignore)
-			continue;
-
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		switch (sdata->vif.type) {
-		case NL80211_IFTYPE_MONITOR:
-			continue;
-		case NL80211_IFTYPE_STATION:
-			if (!sdata->u.mgd.associated)
-				continue;
-			break;
-		case NL80211_IFTYPE_ADHOC:
-			if (!sdata->u.ibss.ssid_len)
-				continue;
-			if (!sdata->u.ibss.fixed_channel)
-				return CHAN_MODE_HOPPING;
-			break;
-		case NL80211_IFTYPE_AP_VLAN:
-			/* will also have _AP interface */
-			continue;
-		case NL80211_IFTYPE_AP:
-			if (!sdata->u.ap.beacon)
-				continue;
-			break;
-		case NL80211_IFTYPE_MESH_POINT:
-			if (!sdata->wdev.mesh_id_len)
-				continue;
-			break;
-		default:
-			break;
-		}
-
-		return CHAN_MODE_FIXED;
-	}
-
-	return CHAN_MODE_UNDEFINED;
-}
-
-enum ieee80211_chan_mode
-ieee80211_get_channel_mode(struct ieee80211_local *local,
-			   struct ieee80211_sub_if_data *ignore)
-{
-	enum ieee80211_chan_mode mode;
-
-	mutex_lock(&local->iflist_mtx);
-	mode = __ieee80211_get_channel_mode(local, ignore);
-	mutex_unlock(&local->iflist_mtx);
-
-	return mode;
-}
-
-static enum nl80211_channel_type
-ieee80211_get_superchan(struct ieee80211_local *local,
-			struct ieee80211_sub_if_data *sdata)
-{
-	enum nl80211_channel_type superchan = NL80211_CHAN_NO_HT;
-	struct ieee80211_sub_if_data *tmp;
-
-	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(tmp, &local->interfaces, list) {
-		if (tmp == sdata)
-			continue;
-
-		if (!ieee80211_sdata_running(tmp))
-			continue;
-
-		switch (tmp->vif.bss_conf.channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
-			if (superchan > tmp->vif.bss_conf.channel_type)
-				break;
-
-			superchan = tmp->vif.bss_conf.channel_type;
-			break;
-		case NL80211_CHAN_HT40PLUS:
-			WARN_ON(superchan == NL80211_CHAN_HT40MINUS);
-			superchan = NL80211_CHAN_HT40PLUS;
-			break;
-		case NL80211_CHAN_HT40MINUS:
-			WARN_ON(superchan == NL80211_CHAN_HT40PLUS);
-			superchan = NL80211_CHAN_HT40MINUS;
-			break;
-		}
-	}
-	mutex_unlock(&local->iflist_mtx);
-
-	return superchan;
-}
-
 static bool
 ieee80211_channel_types_are_compatible(enum nl80211_channel_type chantype1,
 				       enum nl80211_channel_type chantype2,
@@ -149,26 +49,6 @@ ieee80211_channel_types_are_compatible(enum nl80211_channel_type chantype1,
 	return true;
 }
 
-bool ieee80211_set_channel_type(struct ieee80211_local *local,
-				struct ieee80211_sub_if_data *sdata,
-				enum nl80211_channel_type chantype)
-{
-	enum nl80211_channel_type superchan;
-	enum nl80211_channel_type compatchan = NL80211_CHAN_NO_HT;
-
-	superchan = ieee80211_get_superchan(local, sdata);
-	if (!ieee80211_channel_types_are_compatible(superchan, chantype,
-						    &compatchan))
-		return false;
-
-	local->_oper_channel_type = compatchan;
-
-	if (sdata)
-		sdata->vif.bss_conf.channel_type = chantype;
-
-	return true;
-}
-
 static void ieee80211_change_chantype(struct ieee80211_local *local,
 				      struct ieee80211_chanctx *ctx,
 				      enum nl80211_channel_type chantype)
@@ -178,6 +58,11 @@ static void ieee80211_change_chantype(struct ieee80211_local *local,
 
 	ctx->conf.channel_type = chantype;
 	drv_change_chantype(local, ctx);
+
+	if (!local->use_chanctx) {
+		local->_oper_channel_type = chantype;
+		ieee80211_hw_config(local, 0);
+	}
 }
 
 static struct ieee80211_chanctx *
@@ -238,10 +123,16 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 
 	list_add(&ctx->list, &local->chanctx_list);
 
-	err = drv_add_chanctx(local, ctx);
-	if (err) {
-		kfree(ctx);
-		return ERR_PTR(err);
+	if (!local->use_chanctx) {
+		local->_oper_channel_type = channel_type;
+		local->_oper_channel = channel;
+		ieee80211_hw_config(local, 0);
+	} else {
+		err = drv_add_chanctx(local, ctx);
+		if (err) {
+			kfree(ctx);
+			return ERR_PTR(err);
+		}
 	}
 
 	return ctx;
@@ -254,7 +145,12 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 
 	WARN_ON_ONCE(ctx->refcount != 0);
 
-	drv_remove_chanctx(ctx->local, ctx);
+	if (!local->use_chanctx) {
+		local->_oper_channel_type = NL80211_CHAN_NO_HT;
+		ieee80211_hw_config(local, 0);
+	} else {
+		drv_remove_chanctx(ctx->local, ctx);
+	}
 
 	list_del(&ctx->list);
 	kfree(ctx);
@@ -361,6 +257,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 		return PTR_ERR(ctx);
 	}
 
+	sdata->vif.bss_conf.channel_type = channel_type;
 	ieee80211_assign_vif_chanctx(sdata, ctx);
 	mutex_unlock(&local->chanctx_mtx);
 	return 0;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d062085..bf2bc19 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -26,7 +26,6 @@
 #include "rate.h"
 
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
-#define IEEE80211_SCAN_INTERVAL_SLOW (15 * HZ)
 #define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
 
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
@@ -80,17 +79,15 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	local->oper_channel = chan;
 	channel_type = ifibss->channel_type;
 	if (!cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
 		channel_type = NL80211_CHAN_HT20;
-	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
-		/* can only fail due to HT40+/- mismatch */
-		channel_type = NL80211_CHAN_HT20;
-		WARN_ON(!ieee80211_set_channel_type(local, sdata,
-						    NL80211_CHAN_HT20));
-	}
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	ieee80211_vif_release_channel(sdata);
+	ieee80211_vif_use_channel(sdata, chan, channel_type,
+				  ifibss->fixed_channel ?
+					IEEE80211_CHANCTX_SHARED :
+					IEEE80211_CHANCTX_EXCLUSIVE);
 
 	sband = local->hw.wiphy->bands[chan->band];
 
@@ -294,7 +291,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	int band = local->oper_channel->band;
+	int band = sdata->vif.chanctx_conf->channel->band;
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -485,10 +482,6 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	if (!(cbss->capability & WLAN_CAPABILITY_IBSS))
 		goto put_bss;
 
-	/* different channel */
-	if (cbss->channel != local->oper_channel)
-		goto put_bss;
-
 	/* different SSID */
 	if (elems->ssid_len != sdata->u.ibss.ssid_len ||
 	    memcmp(elems->ssid, sdata->u.ibss.ssid,
@@ -561,7 +554,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	int band = local->oper_channel->band;
+	int band = sdata->vif.chanctx_conf->channel->band;
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -753,18 +746,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		int interval = IEEE80211_SCAN_INTERVAL;
 
 		if (time_after(jiffies, ifibss->ibss_join_req +
-			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
-			if (!(local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)) {
-				ieee80211_sta_create_ibss(sdata);
-				return;
-			}
-			sdata_info(sdata, "IBSS not allowed on %d MHz\n",
-				   local->oper_channel->center_freq);
-
-			/* No IBSS found - decrease scan interval and continue
-			 * scanning. */
-			interval = IEEE80211_SCAN_INTERVAL_SLOW;
-		}
+			       IEEE80211_IBSS_JOIN_TIMEOUT))
+			ieee80211_sta_create_ibss(sdata);
 
 		mod_timer(&ifibss->timer,
 			  round_jiffies(jiffies + interval));
@@ -1052,17 +1035,6 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->u.ibss.channel_type = params->channel_type;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
-	/* fix ourselves to that channel now already */
-	if (params->channel_fixed) {
-		sdata->local->oper_channel = params->channel;
-		if (!ieee80211_set_channel_type(sdata->local, sdata,
-					       params->channel_type)) {
-			mutex_unlock(&sdata->u.ibss.mtx);
-			kfree_skb(skb);
-			return -EINVAL;
-		}
-	}
-
 	if (params->ie) {
 		sdata->u.ibss.ie = kmemdup(params->ie, params->ie_len,
 					   GFP_KERNEL);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f8cce7d..7c79be8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -998,8 +998,10 @@ struct ieee80211_local {
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data __rcu *scan_sdata;
+	struct ieee80211_channel *csa_channel;
+	/* For backward compatibility only -- do not use */
+	struct ieee80211_channel *_oper_channel;
 	enum nl80211_channel_type _oper_channel_type;
-	struct ieee80211_channel *oper_channel, *csa_channel;
 
 	/* Temporary remain-on-channel for off-channel operations */
 	struct ieee80211_channel *tmp_channel;
@@ -1528,18 +1530,6 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 				enum ieee80211_band band);
 
 /* channel management */
-enum ieee80211_chan_mode {
-	CHAN_MODE_UNDEFINED,
-	CHAN_MODE_HOPPING,
-	CHAN_MODE_FIXED,
-};
-
-enum ieee80211_chan_mode
-ieee80211_get_channel_mode(struct ieee80211_local *local,
-			   struct ieee80211_sub_if_data *ignore);
-bool ieee80211_set_channel_type(struct ieee80211_local *local,
-				struct ieee80211_sub_if_data *sdata,
-				enum nl80211_channel_type chantype);
 enum nl80211_channel_type
 ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ced8c6c..fa04d31 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -650,7 +650,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i;
-	enum nl80211_channel_type orig_ct;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -821,14 +820,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		hw_reconf_flags = 0;
 	}
 
-	/* Re-calculate channel-type, in case there are multiple vifs
-	 * on different channel types.
-	 */
-	orig_ct = local->_oper_channel_type;
-	ieee80211_set_channel_type(local, NULL, NL80211_CHAN_NO_HT);
-
 	/* do after stop to avoid reconfiguring when we stop anyway */
-	if (hw_reconf_flags || (orig_ct != local->_oper_channel_type))
+	if (hw_reconf_flags)
 		ieee80211_hw_config(local, hw_reconf_flags);
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
@@ -1278,11 +1271,6 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 	if (type == ieee80211_vif_type_p2p(&sdata->vif))
 		return 0;
 
-	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
-	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
-	    type == NL80211_IFTYPE_ADHOC)
-		return -EOPNOTSUPP;
-
 	if (ieee80211_sdata_running(sdata)) {
 		ret = ieee80211_runtime_change_iftype(sdata, type);
 		if (ret)
@@ -1294,9 +1282,6 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* reset some values that shouldn't be kept across type changes */
-	sdata->vif.bss_conf.basic_rates =
-		ieee80211_mandatory_rates(sdata->local,
-			sdata->local->oper_channel->band);
 	sdata->drop_unencrypted = 0;
 	if (type == NL80211_IFTYPE_STATION)
 		sdata->u.mgd.use_4addr = false;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c58b339..7e31c19 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -93,23 +93,21 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 	ieee80211_configure_filter(local);
 }
 
-int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
+static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 {
 	struct ieee80211_channel *chan;
-	int ret = 0;
+	u32 changed = 0;
 	int power;
 	enum nl80211_channel_type channel_type;
 	u32 offchannel_flag;
 
-	might_sleep();
-
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 	if (local->scan_channel) {
 		chan = local->scan_channel;
 		/* If scanning on oper channel, use whatever channel-type
 		 * is currently in use.
 		 */
-		if (chan == local->oper_channel)
+		if (chan == local->_oper_channel)
 			channel_type = local->_oper_channel_type;
 		else
 			channel_type = NL80211_CHAN_NO_HT;
@@ -117,11 +115,11 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
 	} else {
-		chan = local->oper_channel;
+		chan = local->_oper_channel;
 		channel_type = local->_oper_channel_type;
 	}
 
-	if (chan != local->oper_channel ||
+	if (chan != local->_oper_channel ||
 	    channel_type != local->_oper_channel_type)
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
 	else
@@ -155,7 +153,8 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	else
 		power = local->power_constr_level ?
 			min(chan->max_power,
-				(chan->max_reg_power  - local->power_constr_level)) :
+				(chan->max_reg_power -
+				 local->power_constr_level)) :
 			chan->max_power;
 
 	if (local->user_power_level >= 0)
@@ -166,6 +165,21 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		local->hw.conf.power_level = power;
 	}
 
+	return changed;
+}
+
+int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
+{
+	int ret = 0;
+
+	might_sleep();
+
+	if (!local->use_chanctx)
+		changed |= ieee80211_hw_conf_chan(local);
+	else
+		changed &= ~(IEEE80211_CONF_CHANGE_CHANNEL |
+			     IEEE80211_CONF_CHANGE_POWER);
+
 	if (changed && local->open_count) {
 		ret = drv_config(local, changed);
 		/*
@@ -771,10 +785,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		sband = local->hw.wiphy->bands[band];
 		if (!sband)
 			continue;
-		if (!local->oper_channel) {
+		if (!local->use_chanctx && !local->_oper_channel) {
 			/* init channel we're on */
 			local->hw.conf.channel =
-			local->oper_channel = &sband->channels[0];
+			local->_oper_channel = &sband->channels[0];
 			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
 		}
 		channels += sband->n_channels;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 62d93ab..751b264 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -97,7 +97,8 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	     (ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth)))
 		goto mismatch;
 
-	ieee80211_sta_get_rates(local, ie, local->oper_channel->band,
+	ieee80211_sta_get_rates(local, ie,
+				sdata->vif.chanctx_conf->channel->band,
 				&basic_rates);
 
 	if (sdata->vif.bss_conf.basic_rates != basic_rates)
@@ -349,7 +350,7 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *chan = local->oper_channel;
+	struct ieee80211_channel *chan = sdata->vif.chanctx_conf->channel;
 	u8 *pos;
 
 	if (skb_tailroom(skb) < 3)
@@ -373,7 +374,7 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[sdata->vif.chanctx_conf->channel->band];
 	if (!sband->ht_cap.ht_supported ||
 	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT)
 		return 0;
@@ -391,7 +392,7 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_channel *channel = local->oper_channel;
+	struct ieee80211_channel *channel = sdata->vif.chanctx_conf->channel;
 	enum nl80211_channel_type channel_type =
 				sdata->vif.bss_conf.channel_type;
 	struct ieee80211_supported_band *sband =
@@ -605,7 +606,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata->local,
-					  sdata->local->oper_channel->band);
+				sdata->vif.chanctx_conf->channel->band);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_HT |
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a203166..50436a0 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -260,9 +260,9 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			memcpy(pos + 2, &plid, 2);
 		}
 		if (ieee80211_add_srates_ie(sdata, skb, true,
-					    local->oper_channel->band) ||
+				sdata->vif.chanctx_conf->channel->band) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true,
-						local->oper_channel->band) ||
+		    		sdata->vif.chanctx_conf->channel->band) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata))
@@ -336,7 +336,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 				       struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
-	enum ieee80211_band band = local->oper_channel->band;
+	enum ieee80211_band band = sdata->vif.chanctx_conf->channel->band;
 	struct ieee80211_supported_band *sband;
 	u32 rates, basic_rates = 0;
 	struct sta_info *sta;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1ff157e..09bd992 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -180,20 +180,21 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan = sdata->vif.chanctx_conf->channel;
 	struct sta_info *sta;
 	u32 changed = 0;
 	u16 ht_opmode;
 	bool disable_40 = false;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[chan->band];
 
 	switch (sdata->vif.bss_conf.channel_type) {
 	case NL80211_CHAN_HT40PLUS:
-		if (local->oper_channel->flags & IEEE80211_CHAN_NO_HT40PLUS)
+		if (chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
 			disable_40 = true;
 		break;
 	case NL80211_CHAN_HT40MINUS:
-		if (local->oper_channel->flags & IEEE80211_CHAN_NO_HT40MINUS)
+		if (chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
 			disable_40 = true;
 		break;
 	default:
@@ -361,11 +362,12 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	int i, count, rates_len, supp_rates_len;
 	u16 capab;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan = sdata->vif.chanctx_conf->channel;
 	u32 rates = 0;
 
 	lockdep_assert_held(&ifmgd->mtx);
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[chan->band];
 
 	if (assoc_data->supp_rates_len) {
 		/*
@@ -487,7 +489,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		*pos++ = WLAN_EID_PWR_CAPABILITY;
 		*pos++ = 2;
 		*pos++ = 0; /* min tx power */
-		*pos++ = local->oper_channel->max_power; /* max tx power */
+		*pos++ = chan->max_power; /* max tx power */
 
 		/* 2. supported channels */
 		/* TODO: get this in reg domain format */
@@ -525,7 +527,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ap_ht_param,
-				    sband, local->oper_channel, ifmgd->ap_smps);
+				    sband, chan, ifmgd->ap_smps);
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 		ieee80211_add_vht_ie(sdata, skb, sband);
@@ -688,6 +690,7 @@ static void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
 /* spectrum management related things */
 static void ieee80211_chswitch_work(struct work_struct *work)
 {
+#if TODO
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -717,10 +720,12 @@ static void ieee80211_chswitch_work(struct work_struct *work)
  out:
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	mutex_unlock(&ifmgd->mtx);
+#endif
 }
 
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 {
+#if TODO
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_managed *ifmgd;
 
@@ -739,6 +744,7 @@ void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 	}
 
 	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
+#endif
 }
 EXPORT_SYMBOL(ieee80211_chswitch_done);
 
@@ -1264,7 +1270,7 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 	}
 
 	use_short_slot = !!(capab & WLAN_CAPABILITY_SHORT_SLOT_TIME);
-	if (sdata->local->oper_channel->band == IEEE80211_BAND_5GHZ)
+	if (sdata->vif.chanctx_conf->channel->band == IEEE80211_BAND_5GHZ)
 		use_short_slot = true;
 
 	if (use_protection != bss_conf->use_cts_prot) {
@@ -1444,9 +1450,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	/* channel(_type) changes are handled by ieee80211_hw_config */
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
-	ieee80211_hw_config(local, 0);
+	ieee80211_vif_release_channel(sdata);
 
 	/* disassociated - set to defaults now */
 	ieee80211_set_wmm_default(sdata, false);
@@ -1669,7 +1673,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 
 	skb = ieee80211_build_probe_req(sdata, cbss->bssid,
 					(u32) -1,
-					sdata->local->oper_channel,
+					sdata->vif.chanctx_conf->channel,
 					ssid + 2, ssid_len,
 					NULL, 0, true);
 
@@ -1769,6 +1773,7 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+		ieee80211_vif_release_channel(sdata);
 	}
 
 	cfg80211_put_bss(auth_data->bss);
@@ -1995,6 +2000,7 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+		ieee80211_vif_release_channel(sdata);
 	}
 
 	kfree(assoc_data);
@@ -2056,7 +2062,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		return false;
 	}
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[sdata->vif.chanctx_conf->channel->band];
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
@@ -2351,7 +2357,10 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	if (rx_status->freq != local->oper_channel->center_freq)
+	if (!sdata->vif.chanctx_conf)
+		return;
+
+	if (rx_status->freq != sdata->vif.chanctx_conf->channel->center_freq)
 		return;
 
 	if (ifmgd->assoc_data && !ifmgd->assoc_data->have_beacon &&
@@ -2515,7 +2524,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
 		struct ieee80211_supported_band *sband;
 
-		sband = local->hw.wiphy->bands[local->oper_channel->band];
+		sband = local->hw.wiphy->bands[
+				sdata->vif.chanctx_conf->channel->band];
 
 		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
 						  bssid, true);
@@ -3085,20 +3095,9 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
-		/* can only fail due to HT40+/- mismatch */
-		channel_type = NL80211_CHAN_HT20;
-		sdata_info(sdata,
-			   "disabling 40 MHz due to multi-vif mismatch\n");
-		ifmgd->flags |= IEEE80211_STA_DISABLE_40MHZ;
-		WARN_ON(!ieee80211_set_channel_type(local, sdata,
-						    channel_type));
-	}
-
-	local->oper_channel = cbss->channel;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-
-	return 0;
+	ieee80211_vif_release_channel(sdata);
+	return ieee80211_vif_use_channel(sdata, cbss->channel, channel_type,
+					 IEEE80211_CHANCTX_SHARED);
 }
 
 static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
@@ -3168,7 +3167,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.basic_rates = basic_rates;
 
 		/* cf. IEEE 802.11 9.2.12 */
-		if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
+		if (cbss->channel->band == IEEE80211_BAND_2GHZ &&
 		    have_higher_than_11mbit)
 			sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 		else
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 10de668..5505450 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -52,11 +52,16 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 
 	if (!ref)
 		return;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	chanctx_conf = sta->sdata->vif.chanctx_conf;
+	if (WARN_ON(!chanctx_conf))
+		return;
+
+	sband = local->hw.wiphy->bands[chanctx_conf->channel->band];
 
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
 	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 7ca3441..bc597d7 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -484,7 +484,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->ops->hw_scan) {
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	} else if ((req->n_channels == 1) &&
-		   (req->channels[0] == local->oper_channel)) {
+		   (req->channels[0] == local->_oper_channel)) {
 		/*
 		 * If we are scanning only on the operating channel
 		 * then we do not need to stop normal activities
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7da1fa5..2bb07f5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2299,7 +2299,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
 	struct beacon_data *beacon;
-	enum ieee80211_band band = local->oper_channel->band;
+	enum ieee80211_band band;
 	struct ieee80211_tx_rate_control txrc;
 
 	rcu_read_lock();
@@ -2423,6 +2423,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
 
+		band = sdata->vif.chanctx_conf->channel->band;
+
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_ds_params_ie(skb, sdata) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
@@ -2440,6 +2442,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	band = sdata->vif.chanctx_conf->channel->band;
+
 	info = IEEE80211_SKB_CB(skb);
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
@@ -2704,7 +2708,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	info = IEEE80211_SKB_CB(skb);
 
 	tx.flags |= IEEE80211_TX_PS_BUFFERED;
-	info->band = local->oper_channel->band;
+	info->band = sdata->vif.chanctx_conf->channel->band;
 
 	if (invoke_tx_handlers(&tx))
 		skb = NULL;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4c8cd99..8cf9d8d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -838,7 +838,9 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 
 	memset(&qparam, 0, sizeof(qparam));
 
-	use_11b = (local->oper_channel->band == IEEE80211_BAND_2GHZ) &&
+	use_11b = (sdata->vif.chanctx_conf &&
+		   sdata->vif.chanctx_conf->channel->band ==
+		   				IEEE80211_BAND_2GHZ) &&
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 
 	/*
@@ -918,7 +920,6 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
 				  const u8 *supp_rates)
 {
-	struct ieee80211_local *local = sdata->local;
 	int i, have_higher_than_11mbit = 0;
 
 	/* cf. IEEE 802.11 9.2.12 */
@@ -926,7 +927,8 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 		if ((supp_rates[i] & 0x7f) * 5 > 110)
 			have_higher_than_11mbit = 1;
 
-	if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
+	if (sdata->vif.chanctx_conf &&
+	    sdata->vif.chanctx_conf->channel->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
 		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 	else
-- 
1.7.10.4

