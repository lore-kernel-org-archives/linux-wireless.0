Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2IKNZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 09:25:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 09/12] mac80211: use channel contexts
Date: Tue, 11 Sep 2012 15:26:20 +0200
Message-Id: <1347369983-12459-10-git-send-email-johannes@sipsolutions.net> (sfid-20120911_152601_257650_34F62911)
In-Reply-To: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
References: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
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

Right now this disables both TX power settings
and spatial multiplexing powersave. Both need
to be re-enabled on a channel context basis.

Additionally, when channel contexts are used
drop the connection when channel switch is
received rather than trying to handle it. This
will have to be improved later.

[With a fix from Eliad incorporated]
Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  248 +++++++++++++++++++++++---------------------
 net/mac80211/chan.c        |  151 +++++----------------------
 net/mac80211/ibss.c        |   70 ++++++-------
 net/mac80211/ieee80211_i.h |   36 ++++---
 net/mac80211/iface.c       |   28 +++--
 net/mac80211/main.c        |   43 +++++---
 net/mac80211/mesh.c        |   41 ++++++--
 net/mac80211/mesh_plink.c  |   10 +-
 net/mac80211/mlme.c        |  123 +++++++++++++++-------
 net/mac80211/rate.h        |   12 ++-
 net/mac80211/scan.c        |    2 +-
 net/mac80211/sta_info.c    |   12 ++-
 net/mac80211/tx.c          |  188 +++++++++++++++++++++------------
 net/mac80211/util.c        |   34 +++++-
 14 files changed, 545 insertions(+), 453 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7e9b5d4..d251ddb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -371,10 +371,11 @@ static int ieee80211_config_default_mgmt_key(struct wiphy *wiphy,
 
 static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, int idx)
 {
+	enum ieee80211_band band = ieee80211_get_sdata_band(sta->sdata);
+
 	if (!(rate->flags & RATE_INFO_FLAGS_MCS)) {
 		struct ieee80211_supported_band *sband;
-		sband = sta->local->hw.wiphy->bands[
-				sta->local->oper_channel->band];
+		sband = sta->local->hw.wiphy->bands[band];
 		rate->legacy = sband->bitrates[idx].bitrate;
 	} else
 		rate->mcs = idx;
@@ -531,6 +532,8 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 				   u64 *data)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *channel;
 	struct sta_info *sta;
 	struct ieee80211_local *local = sdata->local;
 	struct station_info sinfo;
@@ -606,19 +609,26 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 do_survey:
 	i = STA_STATS_LEN - STA_STATS_SURVEY_LEN;
 	/* Get survey stats for current channel */
-	q = 0;
-	while (true) {
-		survey.filled = 0;
-		if (drv_get_survey(local, q, &survey) != 0) {
-			survey.filled = 0;
-			break;
-		}
+	survey.filled = 0;
 
-		if (survey.channel &&
-		    (local->oper_channel->center_freq ==
-		     survey.channel->center_freq))
-			break;
-		q++;
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (chanctx_conf)
+		channel = chanctx_conf->channel;
+	else
+		channel = NULL;
+	rcu_read_unlock();
+
+	if (channel) {
+		q = 0;
+		do {
+			survey.filled = 0;
+			if (drv_get_survey(local, q, &survey) != 0) {
+				survey.filled = 0;
+				break;
+			}
+			q++;
+		} while (channel != survey.channel);
 	}
 
 	if (survey.filled)
@@ -723,47 +733,42 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
-static int ieee80211_set_channel(struct wiphy *wiphy,
-				 struct net_device *netdev,
-				 struct ieee80211_channel *chan,
-				 enum nl80211_channel_type channel_type)
+static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
+					 struct ieee80211_channel *chan,
+					 enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
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
+	struct ieee80211_sub_if_data *sdata;
+	int ret = 0;
 
-	local->oper_channel = chan;
+	if (local->monitor_channel == chan &&
+	    local->monitor_channel_type == channel_type)
+		return 0;
 
-	/* auto-detects changes */
-	ieee80211_hw_config(local, 0);
+	mutex_lock(&local->iflist_mtx);
+	if (local->use_chanctx) {
+		sdata = rcu_dereference_protected(
+				local->monitor_sdata,
+				lockdep_is_held(&local->iflist_mtx));
+		if (sdata) {
+			ieee80211_vif_release_channel(sdata);
+			ret = ieee80211_vif_use_channel(
+					sdata, chan, channel_type,
+					IEEE80211_CHANCTX_EXCLUSIVE);
+		}
+	} else if (local->open_count == local->monitors) {
+		local->_oper_channel = chan;
+		local->_oper_channel_type = channel_type;
+		ieee80211_hw_config(local, 0);
+	}
 
-	return 0;
-}
+	if (ret == 0) {
+		local->monitor_channel = chan;
+		local->monitor_channel_type = channel_type;
+	}
+	mutex_unlock(&local->iflist_mtx);
 
-static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
-					 struct ieee80211_channel *chan,
-					 enum nl80211_channel_type channel_type)
-{
-	return ieee80211_set_channel(wiphy, NULL, chan, channel_type);
+	return ret;
 }
 
 static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
@@ -878,8 +883,9 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (old)
 		return -EALREADY;
 
-	err = ieee80211_set_channel(wiphy, dev, params->channel,
-				    params->channel_type);
+	err = ieee80211_vif_use_channel(sdata, params->channel,
+					params->channel_type,
+					IEEE80211_CHANCTX_SHARED);
 	if (err)
 		return err;
 
@@ -962,6 +968,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	sta_info_flush(sdata->local, sdata);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
+	ieee80211_vif_release_channel(sdata);
+
 	return 0;
 }
 
@@ -1018,9 +1026,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	int i, j;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	u32 mask, set;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[band];
 
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
@@ -1135,7 +1144,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 					rates |= BIT(j);
 			}
 		}
-		sta->sta.supp_rates[local->oper_channel->band] = rates;
+		sta->sta.supp_rates[band] = rates;
 	}
 
 	if (params->ht_capa)
@@ -1663,8 +1672,9 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	if (err)
 		return err;
 
-	err = ieee80211_set_channel(wiphy, dev, setup->channel,
-				    setup->channel_type);
+	err = ieee80211_vif_use_channel(sdata, setup->channel,
+					setup->channel_type,
+					IEEE80211_CHANCTX_SHARED);
 	if (err)
 		return err;
 
@@ -1678,6 +1688,7 @@ static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	ieee80211_stop_mesh(sdata);
+	ieee80211_vif_release_channel(sdata);
 
 	return 0;
 }
@@ -1687,10 +1698,14 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct bss_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	enum ieee80211_band band;
 	u32 changed = 0;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (!rtnl_dereference(sdata->u.ap.beacon))
+		return -ENOENT;
+
+	band = ieee80211_get_sdata_band(sdata);
 
 	if (params->use_cts_prot >= 0) {
 		sdata->vif.bss_conf.use_cts_prot = params->use_cts_prot;
@@ -1703,7 +1718,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}
 
 	if (!sdata->vif.bss_conf.use_short_slot &&
-	    sdata->local->oper_channel->band == IEEE80211_BAND_5GHZ) {
+	    band == IEEE80211_BAND_5GHZ) {
 		sdata->vif.bss_conf.use_short_slot = true;
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
@@ -1717,9 +1732,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	if (params->basic_rates) {
 		int i, j;
 		u32 rates = 0;
-		struct ieee80211_local *local = wiphy_priv(wiphy);
-		struct ieee80211_supported_band *sband =
-			wiphy->bands[local->oper_channel->band];
+		struct ieee80211_supported_band *sband = wiphy->bands[band];
 
 		for (i = 0; i < params->basic_rates_len; i++) {
 			int rate = (params->basic_rates[i] & 0x7f) * 5;
@@ -1871,20 +1884,6 @@ static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
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
 
@@ -1903,30 +1902,12 @@ static int ieee80211_disassoc(struct wiphy *wiphy, struct net_device *dev,
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
@@ -1970,9 +1951,13 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
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
@@ -2517,10 +2502,20 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	/* Check if the operating channel is the requested channel */
 	if (!need_offchan) {
-		need_offchan = chan != local->oper_channel;
-		if (channel_type_valid &&
-		    channel_type != local->_oper_channel_type)
+		struct ieee80211_chanctx_conf *chanctx_conf;
+
+		rcu_read_lock();
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+
+		if (chanctx_conf) {
+			need_offchan = chan != chanctx_conf->channel;
+			if (channel_type_valid &&
+			    channel_type != chanctx_conf->channel_type)
+				need_offchan = true;
+		} else {
 			need_offchan = true;
+		}
+		rcu_read_unlock();
 	}
 
 	if (need_offchan && !offchan) {
@@ -2669,7 +2664,7 @@ static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
 	u16 capab;
 
 	capab = 0;
-	if (local->oper_channel->band != IEEE80211_BAND_2GHZ)
+	if (ieee80211_get_sdata_band(sdata) != IEEE80211_BAND_2GHZ)
 		return capab;
 
 	if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
@@ -2701,7 +2696,7 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 			       u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_tdls_data *tf;
 
 	tf = (void *)skb_put(skb, offsetof(struct ieee80211_tdls_data, u));
@@ -2721,10 +2716,8 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_req.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(sdata, skb, false,
-					local->oper_channel->band);
-		ieee80211_add_ext_srates_ie(sdata, skb, false,
-					    local->oper_channel->band);
+		ieee80211_add_srates_ie(sdata, skb, false, band);
+		ieee80211_add_ext_srates_ie(sdata, skb, false, band);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
@@ -2737,10 +2730,8 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(sdata, skb, false,
-					local->oper_channel->band);
-		ieee80211_add_ext_srates_ie(sdata, skb, false,
-					    local->oper_channel->band);
+		ieee80211_add_srates_ie(sdata, skb, false, band);
+		ieee80211_add_ext_srates_ie(sdata, skb, false, band);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
@@ -2778,7 +2769,7 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 			   u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_mgmt *mgmt;
 
 	mgmt = (void *)skb_put(skb, 24);
@@ -2801,10 +2792,8 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 		mgmt->u.action.u.tdls_discover_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(sdata, skb, false,
-					local->oper_channel->band);
-		ieee80211_add_ext_srates_ie(sdata, skb, false,
-					    local->oper_channel->band);
+		ieee80211_add_srates_ie(sdata, skb, false, band);
+		ieee80211_add_ext_srates_ie(sdata, skb, false, band);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	default:
@@ -2984,12 +2973,19 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	bool qos;
 	struct ieee80211_tx_info *info;
 	struct sta_info *sta;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	enum ieee80211_band band;
 
 	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON(!chanctx_conf)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	band = chanctx_conf->channel->band;
 	sta = sta_info_get(sdata, peer);
 	if (sta) {
 		qos = test_sta_flag(sta, WLAN_STA_WME);
-		rcu_read_unlock();
 	} else {
 		rcu_read_unlock();
 		return -ENOLINK;
@@ -3007,8 +3003,10 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + size);
-	if (!skb)
+	if (!skb) {
+		rcu_read_unlock();
 		return -ENOMEM;
+	}
 
 	skb->dev = dev;
 
@@ -3033,8 +3031,9 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 		nullfunc->qos_ctrl = cpu_to_le16(7);
 
 	local_bh_disable();
-	ieee80211_xmit(sdata, skb);
+	ieee80211_xmit(sdata, skb, band);
 	local_bh_enable();
+	rcu_read_unlock();
 
 	*cookie = (unsigned long) skb;
 	return 0;
@@ -3044,10 +3043,19 @@ static struct ieee80211_channel *
 ieee80211_cfg_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 			  enum nl80211_channel_type *type)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *chan = NULL;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (chanctx_conf) {
+		*type = chanctx_conf->channel_type;
+		chan = chanctx_conf->channel;
+	}
+	rcu_read_unlock();
 
-	*type = local->_oper_channel_type;
-	return local->oper_channel;
+	return chan;
 }
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 94ed9e7..fd0116d 100644
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
-	enum nl80211_channel_type compatchan;
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
 	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_CHANNEL_TYPE);
+
+	if (!local->use_chanctx) {
+		local->_oper_channel_type = chantype;
+		ieee80211_hw_config(local, 0);
+	}
 }
 
 static struct ieee80211_chanctx *
@@ -235,10 +120,16 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->conf.channel_type = channel_type;
 	ctx->mode = mode;
 
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
 
 	list_add(&ctx->list, &local->chanctx_list);
@@ -253,7 +144,12 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 
 	WARN_ON_ONCE(ctx->refcount != 0);
 
-	drv_remove_chanctx(local, ctx);
+	if (!local->use_chanctx) {
+		local->_oper_channel_type = NL80211_CHAN_NO_HT;
+		ieee80211_hw_config(local, 0);
+	} else {
+		drv_remove_chanctx(local, ctx);
+	}
 
 	list_del(&ctx->list);
 	kfree_rcu(ctx, rcu_head);
@@ -353,6 +249,8 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx *ctx;
 
+	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
+
 	mutex_lock(&local->chanctx_mtx);
 	__ieee80211_vif_release_channel(sdata);
 
@@ -364,6 +262,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 		return PTR_ERR(ctx);
 	}
 
+	sdata->vif.bss_conf.channel_type = channel_type;
 	ieee80211_assign_vif_chanctx(sdata, ctx);
 	mutex_unlock(&local->chanctx_mtx);
 	return 0;
@@ -371,6 +270,8 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 {
+	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
+
 	mutex_lock(&sdata->local->chanctx_mtx);
 	__ieee80211_vif_release_channel(sdata);
 	mutex_unlock(&sdata->local->chanctx_mtx);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 7c08251..934d94b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -26,7 +26,6 @@
 #include "rate.h"
 
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
-#define IEEE80211_SCAN_INTERVAL_SLOW (15 * HZ)
 #define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
 
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
@@ -76,21 +75,22 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IBSS);
 	}
 
-	memcpy(ifibss->bssid, bssid, ETH_ALEN);
-
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
+
+	ieee80211_vif_release_channel(sdata);
+	if (ieee80211_vif_use_channel(sdata, chan, channel_type,
+				      ifibss->fixed_channel ?
+					IEEE80211_CHANCTX_SHARED :
+					IEEE80211_CHANCTX_EXCLUSIVE)) {
+		sdata_info(sdata, "Failed to join IBSS, no channel context\n");
+		return;
 	}
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	memcpy(ifibss->bssid, bssid, ETH_ALEN);
 
 	sband = local->hw.wiphy->bands[chan->band];
 
@@ -294,7 +294,8 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	int band = local->oper_channel->band;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	int band;
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -317,6 +318,13 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 		return NULL;
 	}
 
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON_ONCE(!chanctx_conf))
+		return NULL;
+	band = chanctx_conf->channel->band;
+	rcu_read_unlock();
+
 	sta = sta_info_alloc(sdata, addr, GFP_KERNEL);
 	if (!sta) {
 		rcu_read_lock();
@@ -517,7 +525,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		goto put_bss;
 
 	/* different channel */
-	if (cbss->channel != local->oper_channel)
+	if (sdata->u.ibss.fixed_channel &&
+	    sdata->u.ibss.channel != cbss->channel)
 		goto put_bss;
 
 	/* different SSID */
@@ -592,7 +601,8 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	int band = local->oper_channel->band;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	int band;
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -610,6 +620,15 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	if (!ether_addr_equal(bssid, sdata->u.ibss.bssid))
 		return;
 
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON_ONCE(!chanctx_conf)) {
+		rcu_read_unlock();
+		return;
+	}
+	band = chanctx_conf->channel->band;
+	rcu_read_unlock();
+
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
 	if (!sta)
 		return;
@@ -784,18 +803,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
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
@@ -1086,17 +1095,6 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
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
index 8fa00ad..e023092 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -773,6 +773,21 @@ struct ieee80211_sub_if_data *vif_to_sdata(struct ieee80211_vif *p)
 	return container_of(p, struct ieee80211_sub_if_data, vif);
 }
 
+static inline enum ieee80211_band
+ieee80211_get_sdata_band(struct ieee80211_sub_if_data *sdata)
+{
+	enum ieee80211_band band = IEEE80211_BAND_2GHZ;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!WARN_ON(!chanctx_conf))
+		band = chanctx_conf->channel->band;
+	rcu_read_unlock();
+
+	return band;
+}
+
 enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
 	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
@@ -1006,8 +1021,10 @@ struct ieee80211_local {
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
@@ -1121,6 +1138,8 @@ struct ieee80211_local {
 
 	/* virtual monitor interface */
 	struct ieee80211_sub_if_data __rcu *monitor_sdata;
+	struct ieee80211_channel *monitor_channel;
+	enum nl80211_channel_type monitor_channel_type;
 };
 
 static inline struct ieee80211_sub_if_data *
@@ -1423,7 +1442,8 @@ void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int ke
 				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify);
-void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
+void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		    enum ieee80211_band band);
 
 void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid);
@@ -1525,18 +1545,6 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
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
index 6f8a73c..7cb8382 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -380,6 +380,15 @@ static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 		goto out_unlock;
 	}
 
+	ret = ieee80211_vif_use_channel(sdata, local->monitor_channel,
+					local->monitor_channel_type,
+					IEEE80211_CHANCTX_EXCLUSIVE);
+	if (ret) {
+		drv_remove_interface(local, sdata);
+		kfree(sdata);
+		goto out_unlock;
+	}
+
 	rcu_assign_pointer(local->monitor_sdata, sdata);
  out_unlock:
 	mutex_unlock(&local->iflist_mtx);
@@ -403,6 +412,8 @@ static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 	rcu_assign_pointer(local->monitor_sdata, NULL);
 	synchronize_net();
 
+	ieee80211_vif_release_channel(sdata);
+
 	drv_remove_interface(local, sdata);
 
 	kfree(sdata);
@@ -665,7 +676,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i;
-	enum nl80211_channel_type orig_ct;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -837,14 +847,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
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
@@ -1282,11 +1286,6 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
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
@@ -1298,9 +1297,6 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* reset some values that shouldn't be kept across type changes */
-	sdata->vif.bss_conf.basic_rates =
-		ieee80211_mandatory_rates(sdata->local,
-			sdata->local->oper_channel->band);
 	sdata->drop_unencrypted = 0;
 	if (type == NL80211_IFTYPE_STATION)
 		sdata->u.mgd.use_4addr = false;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0dd1ea2..9cb6280 100644
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
@@ -164,6 +162,21 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
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
@@ -775,12 +788,16 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
+		if (!local->monitor_channel) {
+			local->monitor_channel = &sband->channels[0];
+			local->monitor_channel_type = NL80211_CHAN_NO_HT;
+		}
 		channels += sband->n_channels;
 
 		if (max_bitrates < sband->n_bitrates)
@@ -810,19 +827,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
 	hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
 
-	/*
-	 * mac80211 doesn't support more than 1 channel, and also not more
-	 * than one IBSS interface
-	 */
+	/* mac80211 doesn't support more than one IBSS interface right now */
 	for (i = 0; i < hw->wiphy->n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		int j;
 
 		c = &hw->wiphy->iface_combinations[i];
 
-		if (c->num_different_channels > 1)
-			return -EINVAL;
-
 		for (j = 0; j < c->n_limits; j++)
 			if ((c->limits[j].types & BIT(NL80211_IFTYPE_ADHOC)) &&
 			    c->limits[j].max > 1)
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ff0296c..19725e0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -97,7 +97,7 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	     (ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth)))
 		goto mismatch;
 
-	ieee80211_sta_get_rates(local, ie, local->oper_channel->band,
+	ieee80211_sta_get_rates(local, ie, ieee80211_get_sdata_band(sdata),
 				&basic_rates);
 
 	if (sdata->vif.bss_conf.basic_rates != basic_rates)
@@ -355,12 +355,22 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *chan = local->oper_channel;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *chan;
 	u8 *pos;
 
 	if (skb_tailroom(skb) < 3)
 		return -ENOMEM;
 
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON(!chanctx_conf)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	chan = chanctx_conf->channel;
+	rcu_read_unlock();
+
 	sband = local->hw.wiphy->bands[chan->band];
 	if (sband->band == IEEE80211_BAND_2GHZ) {
 		pos = skb_put(skb, 2 + 1);
@@ -376,10 +386,11 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 		       struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[band];
 	if (!sband->ht_cap.ht_supported ||
 	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT)
 		return 0;
@@ -397,14 +408,26 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_channel *channel = local->oper_channel;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type =
-				sdata->vif.bss_conf.channel_type;
-	struct ieee80211_supported_band *sband =
-				local->hw.wiphy->bands[channel->band];
-	struct ieee80211_sta_ht_cap *ht_cap = &sband->ht_cap;
+		sdata->vif.bss_conf.channel_type;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_sta_ht_cap *ht_cap;
 	u8 *pos;
 
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON(!chanctx_conf)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	channel = chanctx_conf->channel;
+	rcu_read_unlock();
+
+	sband = local->hw.wiphy->bands[channel->band];
+	ht_cap = &sband->ht_cap;
+
 	if (!ht_cap->ht_supported || channel_type == NL80211_CHAN_NO_HT)
 		return 0;
 
@@ -610,7 +633,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata->local,
-					  sdata->local->oper_channel->band);
+					  ieee80211_get_sdata_band(sdata));
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_HT |
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 9d7ad36..c6132ca 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -252,6 +252,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.self_prot.action_code = action;
 
 	if (action != WLAN_SP_MESH_PEERING_CLOSE) {
+		enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+
 		/* capability info */
 		pos = skb_put(skb, 2);
 		memset(pos, 0, 2);
@@ -260,10 +262,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			pos = skb_put(skb, 2);
 			memcpy(pos + 2, &plid, 2);
 		}
-		if (ieee80211_add_srates_ie(sdata, skb, true,
-					    local->oper_channel->band) ||
-		    ieee80211_add_ext_srates_ie(sdata, skb, true,
-						local->oper_channel->band) ||
+		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
+		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata))
@@ -343,7 +343,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 				       struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
-	enum ieee80211_band band = local->oper_channel->band;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
 	u32 rates, basic_rates = 0;
 	struct sta_info *sta;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2dbd9e1..f359af1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -178,20 +178,30 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *chan;
 	struct sta_info *sta;
 	u32 changed = 0;
 	u16 ht_opmode;
 	bool disable_40 = false;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON(!chanctx_conf)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	chan = chanctx_conf->channel;
+	rcu_read_unlock();
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
@@ -359,11 +369,21 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	int i, count, rates_len, supp_rates_len;
 	u16 capab;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *chan;
 	u32 rates = 0;
 
 	lockdep_assert_held(&ifmgd->mtx);
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON(!chanctx_conf)) {
+		rcu_read_unlock();
+		return;
+	}
+	chan = chanctx_conf->channel;
+	rcu_read_unlock();
+	sband = local->hw.wiphy->bands[chan->band];
 
 	if (assoc_data->supp_rates_len) {
 		/*
@@ -485,7 +505,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		*pos++ = WLAN_EID_PWR_CAPABILITY;
 		*pos++ = 2;
 		*pos++ = 0; /* min tx power */
-		*pos++ = local->oper_channel->max_power; /* max tx power */
+		*pos++ = chan->max_power; /* max tx power */
 
 		/* 2. supported channels */
 		/* TODO: get this in reg domain format */
@@ -523,7 +543,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ap_ht_param,
-				    sband, local->oper_channel, ifmgd->ap_smps);
+				    sband, chan, ifmgd->ap_smps);
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 		ieee80211_add_vht_ie(sdata, skb, sband);
@@ -657,18 +677,18 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	sdata->local->oper_channel = sdata->local->csa_channel;
+	sdata->local->_oper_channel = sdata->local->csa_channel;
 	if (!sdata->local->ops->channel_switch) {
 		/* call "hw_config" only if doing sw channel switch */
 		ieee80211_hw_config(sdata->local,
 			IEEE80211_CONF_CHANGE_CHANNEL);
 	} else {
 		/* update the device channel directly */
-		sdata->local->hw.conf.channel = sdata->local->oper_channel;
+		sdata->local->hw.conf.channel = sdata->local->_oper_channel;
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->local->oper_channel;
+	ifmgd->associated->channel = sdata->local->_oper_channel;
 
 	/* XXX: wait for a beacon first? */
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
@@ -680,11 +700,8 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 {
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_managed *ifmgd;
-
-	sdata = vif_to_sdata(vif);
-	ifmgd = &sdata->u.mgd;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	trace_api_chswitch_done(sdata, success);
 	if (!success) {
@@ -723,6 +740,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
 						      cbss->channel->band);
+	struct ieee80211_chanctx *chanctx;
 
 	ASSERT_MGD_MTX(ifmgd);
 
@@ -748,10 +766,34 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	sdata->local->csa_channel = new_ch;
-
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
 
+	if (sdata->local->use_chanctx) {
+		sdata_info(sdata,
+			   "not handling channel switch with channel contexts\n");
+		ieee80211_queue_work(&sdata->local->hw,
+				     &ifmgd->csa_connection_drop_work);
+	}
+
+	mutex_lock(&sdata->local->chanctx_mtx);
+	if (WARN_ON(!rcu_access_pointer(sdata->vif.chanctx_conf))) {
+		mutex_unlock(&sdata->local->chanctx_mtx);
+		return;
+	}
+	chanctx = container_of(rcu_access_pointer(sdata->vif.chanctx_conf),
+			       struct ieee80211_chanctx, conf);
+	if (chanctx->refcount > 1) {
+		sdata_info(sdata,
+			   "channel switch with multiple interfaces on the same channel, disconnecting\n");
+		ieee80211_queue_work(&sdata->local->hw,
+				     &ifmgd->csa_connection_drop_work);
+		mutex_unlock(&sdata->local->chanctx_mtx);
+		return;
+	}
+	mutex_unlock(&sdata->local->chanctx_mtx);
+
+	sdata->local->csa_channel = new_ch;
+
 	if (sw_elem->mode)
 		ieee80211_stop_queues_by_reason(&sdata->local->hw,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -1280,7 +1322,7 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 	}
 
 	use_short_slot = !!(capab & WLAN_CAPABILITY_SHORT_SLOT_TIME);
-	if (sdata->local->oper_channel->band == IEEE80211_BAND_5GHZ)
+	if (ieee80211_get_sdata_band(sdata) == IEEE80211_BAND_5GHZ)
 		use_short_slot = true;
 
 	if (use_protection != bss_conf->use_cts_prot) {
@@ -1465,9 +1507,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	/* channel(_type) changes are handled by ieee80211_hw_config */
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
-	ieee80211_hw_config(local, 0);
+	ieee80211_vif_release_channel(sdata);
 
 	/* disassociated - set to defaults now */
 	ieee80211_set_wmm_default(sdata, false);
@@ -1692,8 +1732,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 		ssid_len = ssid[1];
 
 	skb = ieee80211_build_probe_req(sdata, cbss->bssid,
-					(u32) -1,
-					sdata->local->oper_channel,
+					(u32) -1, cbss->channel,
 					ssid + 2, ssid_len,
 					NULL, 0, true);
 
@@ -1804,6 +1843,7 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+		ieee80211_vif_release_channel(sdata);
 	}
 
 	cfg80211_put_bss(auth_data->bss);
@@ -2030,6 +2070,7 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+		ieee80211_vif_release_channel(sdata);
 	}
 
 	kfree(assoc_data);
@@ -2091,7 +2132,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		return false;
 	}
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[ieee80211_get_sdata_band(sdata)];
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
@@ -2369,6 +2410,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	size_t baselen;
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	enum ieee80211_band band;
 	u32 changed = 0;
 	bool erp_valid, directed_tim = false;
 	u8 erp_value = 0;
@@ -2382,8 +2425,19 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	if (rx_status->freq != local->oper_channel->center_freq)
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		rcu_read_unlock();
 		return;
+	}
+
+	if (rx_status->freq != chanctx_conf->channel->center_freq) {
+		rcu_read_unlock();
+		return;
+	}
+	band = chanctx_conf->channel->band;
+	rcu_read_unlock();
 
 	if (ifmgd->assoc_data && !ifmgd->assoc_data->have_beacon &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->assoc_data->bss->bssid)) {
@@ -2546,7 +2600,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
 		struct ieee80211_supported_band *sband;
 
-		sband = local->hw.wiphy->bands[local->oper_channel->band];
+		sband = local->hw.wiphy->bands[band];
 
 		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
 						  bssid, true);
@@ -3118,20 +3172,9 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
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
@@ -3201,7 +3244,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.basic_rates = basic_rates;
 
 		/* cf. IEEE 802.11 9.2.12 */
-		if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
+		if (cbss->channel->band == IEEE80211_BAND_2GHZ &&
 		    have_higher_than_11mbit)
 			sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 		else
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 10de668..ec198ef 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -52,11 +52,21 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 
 	if (!ref)
 		return;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	rcu_read_lock();
+
+	chanctx_conf = rcu_dereference(sta->sdata->vif.chanctx_conf);
+	if (WARN_ON(!chanctx_conf)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	sband = local->hw.wiphy->bands[chanctx_conf->channel->band];
+	rcu_read_unlock();
 
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
 	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fdaa505..5671fe5 100644
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
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9c8cd8b..944c8c3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1008,6 +1008,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	__le16 fc;
 	bool qos = test_sta_flag(sta, WLAN_STA_WME);
 	struct ieee80211_tx_info *info;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 
 	if (qos) {
 		fc = cpu_to_le16(IEEE80211_FTYPE_DATA |
@@ -1057,7 +1058,16 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 
 	drv_allow_buffered_frames(local, sta, BIT(tid), 1, reason, false);
 
-	ieee80211_xmit(sdata, skb);
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON(!chanctx_conf)) {
+		rcu_read_unlock();
+		kfree_skb(skb);
+		return;
+	}
+
+	ieee80211_xmit(sdata, skb, chanctx_conf->channel->band);
+	rcu_read_unlock();
 }
 
 static void
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e0e0d1d..61ee077 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -324,11 +324,6 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
-	/*
-	 * virtual interfaces are protected by RCU
-	 */
-	rcu_read_lock();
-
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		struct ieee80211_if_ap *ap;
 		if (sdata->vif.type != NL80211_IFTYPE_AP)
@@ -360,8 +355,6 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 		}
 	}
 
-	rcu_read_unlock();
-
 	local->total_ps_buffered = total;
 	ps_dbg_hw(&local->hw, "PS buffers full - purged %d frames\n", purged);
 }
@@ -1372,7 +1365,8 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
 static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
-			 struct sk_buff *skb, bool txpending)
+			 struct sk_buff *skb, bool txpending,
+			 enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_data tx;
@@ -1386,20 +1380,18 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 		return true;
 	}
 
-	rcu_read_lock();
-
 	/* initialises tx */
 	led_len = skb->len;
 	res_prepare = ieee80211_tx_prepare(sdata, &tx, skb);
 
 	if (unlikely(res_prepare == TX_DROP)) {
 		dev_kfree_skb(skb);
-		goto out;
+		return true;
 	} else if (unlikely(res_prepare == TX_QUEUED)) {
-		goto out;
+		return true;
 	}
 
-	info->band = local->hw.conf.channel->band;
+	info->band = band;
 
 	/* set up hw_queue value early */
 	if (!(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) ||
@@ -1410,8 +1402,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	if (!invoke_tx_handlers(&tx))
 		result = __ieee80211_tx(local, &tx.skbs, led_len,
 					tx.sta, txpending);
- out:
-	rcu_read_unlock();
+
 	return result;
 }
 
@@ -1446,7 +1437,8 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		    enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1454,8 +1446,6 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	int headroom;
 	bool may_encrypt;
 
-	rcu_read_lock();
-
 	may_encrypt = !(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT);
 
 	headroom = local->tx_headroom;
@@ -1466,7 +1456,6 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 
 	if (ieee80211_skb_resize(sdata, skb, headroom, may_encrypt)) {
 		dev_kfree_skb(skb);
-		rcu_read_unlock();
 		return;
 	}
 
@@ -1478,13 +1467,11 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	    !is_multicast_ether_addr(hdr->addr1) &&
 	    mesh_nexthop_resolve(skb, sdata)) {
 		/* skb queued: don't free */
-		rcu_read_unlock();
 		return;
 	}
 
 	ieee80211_set_qos_hdr(sdata, skb);
-	ieee80211_tx(sdata, skb, false);
-	rcu_read_unlock();
+	ieee80211_tx(sdata, skb, false, band);
 }
 
 static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
@@ -1574,7 +1561,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_channel *chan = local->hw.conf.channel;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *chan;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1583,26 +1571,6 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	u16 len_rthdr;
 	int hdrlen;
 
-	/*
-	 * Frame injection is not allowed if beaconing is not allowed
-	 * or if we need radar detection. Beaconing is usually not allowed when
-	 * the mode or operation (Adhoc, AP, Mesh) does not support DFS.
-	 * Passive scan is also used in world regulatory domains where
-	 * your country is not known and as such it should be treated as
-	 * NO TX unless the channel is explicitly allowed in which case
-	 * your current regulatory domain would not have the passive scan
-	 * flag.
-	 *
-	 * Since AP mode uses monitor interfaces to inject/TX management
-	 * frames we can make AP mode the exception to this rule once it
-	 * supports radar detection as its implementation can deal with
-	 * radar detection by itself. We can do that later by adding a
-	 * monitor flag interfaces used for AP support.
-	 */
-	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
-	     IEEE80211_CHAN_PASSIVE_SCAN)))
-		goto fail;
-
 	/* check for not even having the fixed radiotap header part */
 	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
 		goto fail; /* too short to be possibly valid */
@@ -1688,11 +1656,45 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 		}
 	}
 
-	ieee80211_xmit(sdata, skb);
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		tmp_sdata = rcu_dereference(local->monitor_sdata);
+		if (tmp_sdata)
+			chanctx_conf =
+				rcu_dereference(tmp_sdata->vif.chanctx_conf);
+	}
+	if (!chanctx_conf)
+		goto fail_rcu;
+
+	chan = chanctx_conf->channel;
+
+	/*
+	 * Frame injection is not allowed if beaconing is not allowed
+	 * or if we need radar detection. Beaconing is usually not allowed when
+	 * the mode or operation (Adhoc, AP, Mesh) does not support DFS.
+	 * Passive scan is also used in world regulatory domains where
+	 * your country is not known and as such it should be treated as
+	 * NO TX unless the channel is explicitly allowed in which case
+	 * your current regulatory domain would not have the passive scan
+	 * flag.
+	 *
+	 * Since AP mode uses monitor interfaces to inject/TX management
+	 * frames we can make AP mode the exception to this rule once it
+	 * supports radar detection as its implementation can deal with
+	 * radar detection by itself. We can do that later by adding a
+	 * monitor flag interfaces used for AP support.
+	 */
+	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
+			    IEEE80211_CHAN_PASSIVE_SCAN)))
+		goto fail_rcu;
+
+	ieee80211_xmit(sdata, skb, chan->band);
 	rcu_read_unlock();
 
 	return NETDEV_TX_OK;
 
+fail_rcu:
+	rcu_read_unlock();
 fail:
 	dev_kfree_skb(skb);
 	return NETDEV_TX_OK; /* meaning, we dealt with the skb */
@@ -1734,6 +1736,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	bool multicast;
 	u32 info_flags = 0;
 	u16 info_id = 0;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_sub_if_data *ap_sdata;
+	enum ieee80211_band band;
 
 	if (unlikely(skb->len < ETH_HLEN))
 		goto fail;
@@ -1743,9 +1748,10 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	ethertype = (skb->data[12] << 8) | skb->data[13];
 	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA);
 
+	rcu_read_lock();
+
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
-		rcu_read_lock();
 		sta = rcu_dereference(sdata->u.vlan.sta);
 		if (sta) {
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
@@ -1758,7 +1764,12 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			wme_sta = test_sta_flag(sta, WLAN_STA_WME);
 		}
-		rcu_read_unlock();
+		ap_sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
+					u.ap);
+		chanctx_conf = rcu_dereference(ap_sdata->vif.chanctx_conf);
+		if (!chanctx_conf)
+			goto fail_rcu;
+		band = chanctx_conf->channel->band;
 		if (sta)
 			break;
 		/* fall through */
@@ -1769,6 +1780,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 24;
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
+			chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (!chanctx_conf)
+			goto fail_rcu;
+		band = chanctx_conf->channel->band;
 		break;
 	case NL80211_IFTYPE_WDS:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
@@ -1778,15 +1794,20 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 30;
+		/*
+		 * This is the exception! WDS style interfaces are prohibited
+		 * when channel contexts are in used so this must be valid
+		 */
+		band = local->hw.conf.channel->band;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 		if (!sdata->u.mesh.mshcfg.dot11MeshTTL) {
 			/* Do not send frames with mesh_ttl == 0 */
 			sdata->u.mesh.mshstats.dropped_frames_ttl++;
-			goto fail;
+			goto fail_rcu;
 		}
-		rcu_read_lock();
+
 		if (!is_multicast_ether_addr(skb->data)) {
 			mpath = mesh_path_lookup(skb->data, sdata);
 			if (!mpath)
@@ -1803,7 +1824,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		    !(mppath && !ether_addr_equal(mppath->mpp, skb->data))) {
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
 					skb->data, skb->data + ETH_ALEN);
-			rcu_read_unlock();
 			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
 					sdata, NULL, NULL);
 		} else {
@@ -1819,7 +1839,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				mesh_da = mppath->mpp;
 			else if (mpath)
 				mesh_da = mpath->dst;
-			rcu_read_unlock();
 
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
 					mesh_da, sdata->vif.addr);
@@ -1839,13 +1858,16 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 							skb->data + ETH_ALEN);
 
 		}
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (!chanctx_conf)
+			goto fail_rcu;
+		band = chanctx_conf->channel->band;
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
 		if (sdata->wdev.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) {
 			bool tdls_peer = false;
 
-			rcu_read_lock();
 			sta = sta_info_get(sdata, skb->data);
 			if (sta) {
 				authorized = test_sta_flag(sta,
@@ -1856,7 +1878,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				tdls_auth = test_sta_flag(sta,
 						WLAN_STA_TDLS_PEER_AUTH);
 			}
-			rcu_read_unlock();
 
 			/*
 			 * If the TDLS link is enabled, send everything
@@ -1871,7 +1892,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		if (tdls_direct) {
 			/* link during setup - throw out frames to peer */
 			if (!tdls_auth)
-				goto fail;
+				goto fail_rcu;
 
 			/* DA SA BSSID */
 			memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -1896,6 +1917,10 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			hdrlen = 24;
 		}
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (!chanctx_conf)
+			goto fail_rcu;
+		band = chanctx_conf->channel->band;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		/* DA SA BSSID */
@@ -1903,9 +1928,13 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
 		memcpy(hdr.addr3, sdata->u.ibss.bssid, ETH_ALEN);
 		hdrlen = 24;
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (!chanctx_conf)
+			goto fail_rcu;
+		band = chanctx_conf->channel->band;
 		break;
 	default:
-		goto fail;
+		goto fail_rcu;
 	}
 
 	/*
@@ -1915,13 +1944,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 */
 	multicast = is_multicast_ether_addr(hdr.addr1);
 	if (!multicast) {
-		rcu_read_lock();
 		sta = sta_info_get(sdata, hdr.addr1);
 		if (sta) {
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			wme_sta = test_sta_flag(sta, WLAN_STA_WME);
 		}
-		rcu_read_unlock();
 	}
 
 	/* For mesh, the use of the QoS header is mandatory */
@@ -1949,7 +1976,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 		I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);
 
-		goto fail;
+		goto fail_rcu;
 	}
 
 	if (unlikely(!multicast && skb->sk &&
@@ -2004,7 +2031,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		kfree_skb(tmp_skb);
 
 		if (!skb)
-			goto fail;
+			goto fail_rcu;
 	}
 
 	hdr.frame_control = fc;
@@ -2051,7 +2078,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
 		if (ieee80211_skb_resize(sdata, skb, head_need, true))
-			goto fail;
+			goto fail_rcu;
 	}
 
 	if (encaps_data) {
@@ -2102,10 +2129,13 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	info->flags = info_flags;
 	info->ack_frame_id = info_id;
 
-	ieee80211_xmit(sdata, skb);
+	ieee80211_xmit(sdata, skb, band);
+	rcu_read_unlock();
 
 	return NETDEV_TX_OK;
 
+ fail_rcu:
+	rcu_read_unlock();
  fail:
 	dev_kfree_skb(skb);
 	return NETDEV_TX_OK;
@@ -2137,11 +2167,18 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr;
 	bool result;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 
 	sdata = vif_to_sdata(info->control.vif);
 
 	if (info->flags & IEEE80211_TX_INTFL_NEED_TXPROCESSING) {
-		result = ieee80211_tx(sdata, skb, true);
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (unlikely(!chanctx_conf)) {
+			dev_kfree_skb(skb);
+			return true;
+		}
+		result = ieee80211_tx(sdata, skb, true,
+				      chanctx_conf->channel->band);
 	} else {
 		struct sk_buff_head skbs;
 
@@ -2283,14 +2320,16 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
 	struct beacon_data *beacon;
-	enum ieee80211_band band = local->oper_channel->band;
+	enum ieee80211_band band;
 	struct ieee80211_tx_rate_control txrc;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 
 	rcu_read_lock();
 
 	sdata = vif_to_sdata(vif);
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (!ieee80211_sdata_running(sdata))
+	if (!ieee80211_sdata_running(sdata) || !chanctx_conf)
 		goto out;
 
 	if (tim_offset)
@@ -2407,6 +2446,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
 
+		band = chanctx_conf->channel->band;
+
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_ds_params_ie(skb, sdata) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
@@ -2424,6 +2465,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	band = chanctx_conf->channel->band;
+
 	info = IEEE80211_SKB_CB(skb);
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
@@ -2654,14 +2697,17 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	struct ieee80211_if_ap *bss = NULL;
 	struct beacon_data *beacon;
 	struct ieee80211_tx_info *info;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 
 	sdata = vif_to_sdata(vif);
 	bss = &sdata->u.ap;
 
 	rcu_read_lock();
 	beacon = rcu_dereference(bss->beacon);
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (sdata->vif.type != NL80211_IFTYPE_AP || !beacon || !beacon->head)
+	if (sdata->vif.type != NL80211_IFTYPE_AP || !beacon || !beacon->head ||
+	    !chanctx_conf)
 		goto out;
 
 	if (bss->dtim_count != 0 || !bss->dtim_bc_mc)
@@ -2691,7 +2737,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	info = IEEE80211_SKB_CB(skb);
 
 	tx.flags |= IEEE80211_TX_PS_BUFFERED;
-	info->band = local->oper_channel->band;
+	info->band = chanctx_conf->channel->band;
 
 	if (invoke_tx_handlers(&tx))
 		skb = NULL;
@@ -2705,6 +2751,7 @@ EXPORT_SYMBOL(ieee80211_get_buffered_bc);
 void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid)
 {
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	int ac = ieee802_1d_to_ac[tid & 7];
 
 	skb_set_mac_header(skb, 0);
@@ -2714,12 +2761,21 @@ void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 	skb_set_queue_mapping(skb, ac);
 	skb->priority = tid;
 
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON(!chanctx_conf)) {
+		rcu_read_unlock();
+		kfree_skb(skb);
+		return;
+	}
+
 	/*
 	 * The other path calling ieee80211_xmit is from the tasklet,
 	 * and while we can handle concurrent transmissions locking
 	 * requirements are that we do not come into tx with bhs on.
 	 */
 	local_bh_disable();
-	ieee80211_xmit(sdata, skb);
+	ieee80211_xmit(sdata, skb, chanctx_conf->channel->band);
 	local_bh_enable();
+	rcu_read_unlock();
 }
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 22ca350..9dde8db 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -832,6 +832,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_queue_params qparam;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	int ac;
 	bool use_11b, enable_qos;
 	int aCWmin, aCWmax;
@@ -844,8 +845,12 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 
 	memset(&qparam, 0, sizeof(qparam));
 
-	use_11b = (local->oper_channel->band == IEEE80211_BAND_2GHZ) &&
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	use_11b = (chanctx_conf &&
+		   chanctx_conf->channel->band == IEEE80211_BAND_2GHZ) &&
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
+	rcu_read_unlock();
 
 	/*
 	 * By default disable QoS in STA mode for old access points, which do
@@ -924,7 +929,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
 				  const u8 *supp_rates)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	int i, have_higher_than_11mbit = 0;
 
 	/* cf. IEEE 802.11 9.2.12 */
@@ -932,11 +937,16 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 		if ((supp_rates[i] & 0x7f) * 5 > 110)
 			have_higher_than_11mbit = 1;
 
-	if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+
+	if (chanctx_conf &&
+	    chanctx_conf->channel->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
 		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
+	rcu_read_unlock();
 
 	ieee80211_set_wmm_default(sdata, true);
 }
@@ -1280,6 +1290,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_chanctx *ctx;
 	struct sta_info *sta;
 	int res, i;
 
@@ -1352,6 +1363,12 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			res = drv_add_interface(local, sdata);
 	}
 
+	/* add channel contexts */
+	mutex_lock(&local->chanctx_mtx);
+	list_for_each_entry(ctx, &local->chanctx_list, list)
+		WARN_ON(drv_add_chanctx(local, ctx));
+	mutex_unlock(&local->chanctx_mtx);
+
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -1392,11 +1409,22 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 
 	/* Finally also reconfigure all the BSS information */
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		struct ieee80211_chanctx_conf *ctx_conf;
 		u32 changed;
 
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
+		mutex_lock(&local->chanctx_mtx);
+		ctx_conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+				lockdep_is_held(&local->chanctx_mtx));
+		if (ctx_conf) {
+			ctx = container_of(ctx_conf, struct ieee80211_chanctx,
+					   conf);
+			drv_assign_vif_chanctx(local, sdata, ctx);
+		}
+		mutex_unlock(&local->chanctx_mtx);
+
 		/* common change flags for all interface types */
 		changed = BSS_CHANGED_ERP_CTS_PROT |
 			  BSS_CHANGED_ERP_PREAMBLE |
-- 
1.7.10.4

