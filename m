Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2KTVox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:44:53 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/10] mac80211: convert to channel definition struct
Date: Tue, 20 Nov 2012 22:45:11 +0100
Message-Id: <1353447916-17304-6-git-send-email-johannes@sipsolutions.net> (sfid-20121120_224506_729727_C58CB313)
In-Reply-To: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Convert mac80211 (and where necessary, some drivers a
little bit) to the new channel definition struct.

This will allow extending mac80211 for VHT, which is
currently restricted to channel contexts since there
are no drivers using that which makes it easier. As
I also don't care about VHT for drivers not using the
channel context API, I won't convert the previous API
to VHT support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  33 +++++----
 drivers/net/wireless/ti/wlcore/main.c |   9 +--
 include/net/mac80211.h                |  17 ++---
 net/mac80211/cfg.c                    |  41 ++++-------
 net/mac80211/chan.c                   | 129 ++++++++++------------------------
 net/mac80211/debugfs_netdev.c         |   2 -
 net/mac80211/ibss.c                   |  34 ++++-----
 net/mac80211/ieee80211_i.h            |  18 +++--
 net/mac80211/iface.c                  |   5 +-
 net/mac80211/main.c                   |  21 ++++--
 net/mac80211/mesh.c                   |  28 +++-----
 net/mac80211/mesh_plink.c             |  19 ++---
 net/mac80211/mlme.c                   |  26 ++++---
 net/mac80211/rate.c                   |   5 +-
 net/mac80211/rate.h                   |   2 +-
 net/mac80211/sta_info.c               |   2 +-
 net/mac80211/sta_info.h               |   4 +-
 net/mac80211/trace.h                  |  23 +++---
 net/mac80211/tx.c                     |  20 +++---
 net/mac80211/util.c                   |  45 ++++++------
 20 files changed, 221 insertions(+), 262 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b033854..6be3fae 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -681,7 +681,7 @@ static void mac80211_hwsim_tx_iter(void *_data, u8 *addr,
 		return;
 
 	if (!hwsim_chans_compat(data->channel,
-				rcu_dereference(vif->chanctx_conf)->channel))
+				rcu_dereference(vif->chanctx_conf)->def.chan))
 		return;
 
 	data->receive = true;
@@ -832,7 +832,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	} else {
 		chanctx_conf = rcu_dereference(txi->control.vif->chanctx_conf);
 		if (chanctx_conf)
-			channel = chanctx_conf->channel;
+			channel = chanctx_conf->def.chan;
 		else
 			channel = NULL;
 	}
@@ -977,7 +977,7 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 		return;
 
 	mac80211_hwsim_tx_frame(hw, skb,
-				rcu_dereference(vif->chanctx_conf)->channel);
+				rcu_dereference(vif->chanctx_conf)->def.chan);
 }
 
 
@@ -1107,9 +1107,8 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		wiphy_debug(hw->wiphy, "  HT: op_mode=0x%x, chantype=%s\n",
-			    info->ht_operation_mode,
-			    hwsim_chantypes[info->channel_type]);
+		wiphy_debug(hw->wiphy, "  HT: op_mode=0x%x\n",
+			    info->ht_operation_mode);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
@@ -1497,16 +1496,20 @@ static int mac80211_hwsim_add_chanctx(struct ieee80211_hw *hw,
 				      struct ieee80211_chanctx_conf *ctx)
 {
 	hwsim_set_chanctx_magic(ctx);
-	wiphy_debug(hw->wiphy, "add channel context %d MHz/%d\n",
-		    ctx->channel->center_freq, ctx->channel_type);
+	wiphy_debug(hw->wiphy,
+		    "add channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
+		    ctx->def.chan->center_freq, ctx->def.width,
+		    ctx->def.center_freq1, ctx->def.center_freq2);
 	return 0;
 }
 
 static void mac80211_hwsim_remove_chanctx(struct ieee80211_hw *hw,
 					  struct ieee80211_chanctx_conf *ctx)
 {
-	wiphy_debug(hw->wiphy, "remove channel context %d MHz/%d\n",
-		    ctx->channel->center_freq, ctx->channel_type);
+	wiphy_debug(hw->wiphy,
+		    "remove channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
+		    ctx->def.chan->center_freq, ctx->def.width,
+		    ctx->def.center_freq1, ctx->def.center_freq2);
 	hwsim_check_chanctx_magic(ctx);
 	hwsim_clear_chanctx_magic(ctx);
 }
@@ -1516,8 +1519,10 @@ static void mac80211_hwsim_change_chanctx(struct ieee80211_hw *hw,
 					  u32 changed)
 {
 	hwsim_check_chanctx_magic(ctx);
-	wiphy_debug(hw->wiphy, "change channel context %#x (%d MHz/%d)\n",
-		    changed, ctx->channel->center_freq, ctx->channel_type);
+	wiphy_debug(hw->wiphy,
+		    "change channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
+		    ctx->def.chan->center_freq, ctx->def.width,
+		    ctx->def.center_freq1, ctx->def.center_freq2);
 }
 
 static int mac80211_hwsim_assign_vif_chanctx(struct ieee80211_hw *hw,
@@ -1639,7 +1644,7 @@ static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
 
 	rcu_read_lock();
 	mac80211_hwsim_tx_frame(data->hw, skb,
-				rcu_dereference(vif->chanctx_conf)->channel);
+				rcu_dereference(vif->chanctx_conf)->def.chan);
 	rcu_read_unlock();
 }
 
@@ -1671,7 +1676,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 
 	rcu_read_lock();
 	mac80211_hwsim_tx_frame(data->hw, skb,
-				rcu_dereference(vif->chanctx_conf)->channel);
+				rcu_dereference(vif->chanctx_conf)->def.chan);
 	rcu_read_unlock();
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 380cf1f..4f1a05b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3791,7 +3791,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 
 	/* Handle HT information change */
 	if ((changed & BSS_CHANGED_HT) &&
-	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
+	    (bss_conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT)) {
 		ret = wl1271_acx_set_ht_information(wl, wlvif,
 					bss_conf->ht_operation_mode);
 		if (ret < 0) {
@@ -3905,7 +3905,8 @@ sta_not_found:
 			u32 rates;
 			int ieoffset;
 			wlvif->aid = bss_conf->aid;
-			wlvif->channel_type = bss_conf->channel_type;
+			wlvif->channel_type =
+				cfg80211_get_chandef_type(&bss_conf->chandef);
 			wlvif->beacon_int = bss_conf->beacon_int;
 			do_join = true;
 			set_assoc = true;
@@ -4071,7 +4072,7 @@ sta_not_found:
 	/* Handle new association with HT. Do this after join. */
 	if (sta_exists) {
 		if ((changed & BSS_CHANGED_HT) &&
-		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
+		    (bss_conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT)) {
 			ret = wl1271_acx_set_ht_capabilities(wl,
 							     &sta_ht_cap,
 							     true,
@@ -4098,7 +4099,7 @@ sta_not_found:
 
 	/* Handle HT information change. Done after join. */
 	if ((changed & BSS_CHANGED_HT) &&
-	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
+	    (bss_conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT)) {
 		ret = wl1271_acx_set_ht_information(wl, wlvif,
 					bss_conf->ht_operation_mode);
 		if (ret < 0) {
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7e82e26..23e4180 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -145,11 +145,11 @@ struct ieee80211_low_level_stats {
 
 /**
  * enum ieee80211_chanctx_change - change flag for channel context
- * @IEEE80211_CHANCTX_CHANGE_CHANNEL_TYPE: The channel type was changed
+ * @IEEE80211_CHANCTX_CHANGE_WIDTH: The channel width changed
  * @IEEE80211_CHANCTX_CHANGE_RX_CHAINS: The number of RX chains changed
  */
 enum ieee80211_chanctx_change {
-	IEEE80211_CHANCTX_CHANGE_CHANNEL_TYPE	= BIT(0),
+	IEEE80211_CHANCTX_CHANGE_WIDTH		= BIT(0),
 	IEEE80211_CHANCTX_CHANGE_RX_CHAINS	= BIT(1),
 };
 
@@ -159,8 +159,7 @@ enum ieee80211_chanctx_change {
  * This is the driver-visible part. The ieee80211_chanctx
  * that contains it is visible in mac80211 only.
  *
- * @channel: the channel to tune to
- * @channel_type: the channel (HT) type
+ * @def: the channel definition
  * @rx_chains_static: The number of RX chains that must always be
  *	active on the channel to receive MIMO transmissions
  * @rx_chains_dynamic: The number of RX chains that must be enabled
@@ -170,8 +169,7 @@ enum ieee80211_chanctx_change {
  *	sizeof(void *), size is determined in hw information.
  */
 struct ieee80211_chanctx_conf {
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def def;
 
 	u8 rx_chains_static, rx_chains_dynamic;
 
@@ -288,9 +286,8 @@ enum ieee80211_rssi_event {
  * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
  * @bssid: The BSSID for this BSS
  * @enable_beacon: whether beaconing should be enabled or not
- * @channel_type: Channel type for this BSS -- the hardware might be
- *	configured for HT40+ while this BSS only uses no-HT, for
- *	example.
+ * @chandef: Channel definition for this BSS -- the hardware might be
+ *	configured a higher bandwidth than this BSS uses, for example.
  * @ht_operation_mode: HT operation mode like in &struct ieee80211_ht_operation.
  *	This field is only valid when the channel type is one of the HT types.
  * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
@@ -339,7 +336,7 @@ struct ieee80211_bss_conf {
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
 	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
 	u8 arp_addr_cnt;
 	bool arp_filter_enabled;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7136b94..b9702d1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -615,7 +615,7 @@ do_survey:
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (chanctx_conf)
-		channel = chanctx_conf->channel;
+		channel = chanctx_conf->def.chan;
 	else
 		channel = NULL;
 	rcu_read_unlock();
@@ -739,13 +739,9 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
-	enum nl80211_channel_type channel_type;
 	int ret = 0;
 
-	channel_type = cfg80211_get_chandef_type(chandef);
-
-	if (local->monitor_channel == chandef->chan &&
-	    local->monitor_channel_type == channel_type)
+	if (cfg80211_chandef_identical(&local->monitor_chandef, chandef))
 		return 0;
 
 	mutex_lock(&local->iflist_mtx);
@@ -755,20 +751,17 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 				lockdep_is_held(&local->iflist_mtx));
 		if (sdata) {
 			ieee80211_vif_release_channel(sdata);
-			ret = ieee80211_vif_use_channel(
-					sdata, chandef->chan, channel_type,
+			ret = ieee80211_vif_use_channel(sdata, chandef,
 					IEEE80211_CHANCTX_EXCLUSIVE);
 		}
 	} else if (local->open_count == local->monitors) {
 		local->_oper_channel = chandef->chan;
-		local->_oper_channel_type = channel_type;
+		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
 		ieee80211_hw_config(local, 0);
 	}
 
-	if (ret == 0) {
-		local->monitor_channel = chandef->chan;
-		local->monitor_channel_type = channel_type;
-	}
+	if (ret == 0)
+		local->monitor_chandef = *chandef;
 	mutex_unlock(&local->iflist_mtx);
 
 	return ret;
@@ -890,10 +883,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
-	err = ieee80211_vif_use_channel(
-		sdata, params->chandef.chan,
-		cfg80211_get_chandef_type(&params->chandef),
-		IEEE80211_CHANCTX_SHARED);
+	err = ieee80211_vif_use_channel(sdata, &params->chandef,
+					IEEE80211_CHANCTX_SHARED);
 	if (err)
 		return err;
 
@@ -1710,10 +1701,8 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
-	err = ieee80211_vif_use_channel(
-		sdata, setup->chandef.chan,
-		cfg80211_get_chandef_type(&setup->chandef),
-		IEEE80211_CHANCTX_SHARED);
+	err = ieee80211_vif_use_channel(sdata, &setup->chandef,
+					IEEE80211_CHANCTX_SHARED);
 	if (err)
 		return err;
 
@@ -2133,7 +2122,7 @@ int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 	 * the new value until we associate.
 	 */
 	if (!sdata->u.mgd.associated ||
-	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT)
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT)
 		return 0;
 
 	ap = sdata->u.mgd.associated->bssid;
@@ -2589,7 +2578,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
 		if (chanctx_conf)
-			need_offchan = chan != chanctx_conf->channel;
+			need_offchan = chan != chanctx_conf->def.chan;
 		else
 			need_offchan = true;
 		rcu_read_unlock();
@@ -3057,7 +3046,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 		rcu_read_unlock();
 		return -EINVAL;
 	}
-	band = chanctx_conf->channel->band;
+	band = chanctx_conf->def.chan->band;
 	sta = sta_info_get(sdata, peer);
 	if (sta) {
 		qos = test_sta_flag(sta, WLAN_STA_WME);
@@ -3125,9 +3114,7 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (chanctx_conf) {
-		cfg80211_chandef_create(chandef,
-					chanctx_conf->channel,
-					chanctx_conf->channel_type);
+		*chandef = chanctx_conf->def;
 		ret = 0;
 	}
 	rcu_read_unlock();
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index a2b06d4..b3f808a 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -8,93 +8,47 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
-static bool
-ieee80211_channel_types_are_compatible(enum nl80211_channel_type chantype1,
-				       enum nl80211_channel_type chantype2,
-				       enum nl80211_channel_type *compat)
+static void ieee80211_change_chandef(struct ieee80211_local *local,
+				     struct ieee80211_chanctx *ctx,
+				     const struct cfg80211_chan_def *chandef)
 {
-	/*
-	 * start out with chantype1 being the result,
-	 * overwriting later if needed
-	 */
-	if (compat)
-		*compat = chantype1;
-
-	switch (chantype1) {
-	case NL80211_CHAN_NO_HT:
-		if (compat)
-			*compat = chantype2;
-		break;
-	case NL80211_CHAN_HT20:
-		/*
-		 * allow any change that doesn't go to no-HT
-		 * (if it already is no-HT no change is needed)
-		 */
-		if (chantype2 == NL80211_CHAN_NO_HT)
-			break;
-		if (compat)
-			*compat = chantype2;
-		break;
-	case NL80211_CHAN_HT40PLUS:
-	case NL80211_CHAN_HT40MINUS:
-		/* allow smaller bandwidth and same */
-		if (chantype2 == NL80211_CHAN_NO_HT)
-			break;
-		if (chantype2 == NL80211_CHAN_HT20)
-			break;
-		if (chantype2 == chantype1)
-			break;
-		return false;
-	}
-
-	return true;
-}
-
-static void ieee80211_change_chantype(struct ieee80211_local *local,
-				      struct ieee80211_chanctx *ctx,
-				      enum nl80211_channel_type chantype)
-{
-	if (chantype == ctx->conf.channel_type)
+	if (cfg80211_chandef_identical(&ctx->conf.def, chandef))
 		return;
 
-	ctx->conf.channel_type = chantype;
-	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_CHANNEL_TYPE);
+	WARN_ON(!cfg80211_chandef_compatible(&ctx->conf.def, chandef));
+
+	ctx->conf.def = *chandef;
+	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_WIDTH);
 
 	if (!local->use_chanctx) {
-		local->_oper_channel_type = chantype;
+		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
 		ieee80211_hw_config(local, 0);
 	}
 }
 
 static struct ieee80211_chanctx *
 ieee80211_find_chanctx(struct ieee80211_local *local,
-		       struct ieee80211_channel *channel,
-		       enum nl80211_channel_type channel_type,
+		       const struct cfg80211_chan_def *chandef,
 		       enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_chanctx *ctx;
-	enum nl80211_channel_type compat_type;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
 	if (mode == IEEE80211_CHANCTX_EXCLUSIVE)
 		return NULL;
-	if (WARN_ON(!channel))
-		return NULL;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
-		compat_type = ctx->conf.channel_type;
+		const struct cfg80211_chan_def *compat;
 
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
-		if (ctx->conf.channel != channel)
-			continue;
-		if (!ieee80211_channel_types_are_compatible(ctx->conf.channel_type,
-							    channel_type,
-							    &compat_type))
+
+		compat = cfg80211_chandef_compatible(&ctx->conf.def, chandef);
+		if (!compat)
 			continue;
 
-		ieee80211_change_chantype(local, ctx, compat_type);
+		ieee80211_change_chandef(local, ctx, compat);
 
 		return ctx;
 	}
@@ -104,8 +58,7 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 
 static struct ieee80211_chanctx *
 ieee80211_new_chanctx(struct ieee80211_local *local,
-		      struct ieee80211_channel *channel,
-		      enum nl80211_channel_type channel_type,
+		      const struct cfg80211_chan_def *chandef,
 		      enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_chanctx *ctx;
@@ -117,15 +70,15 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	ctx->conf.channel = channel;
-	ctx->conf.channel_type = channel_type;
+	ctx->conf.def = *chandef;
 	ctx->conf.rx_chains_static = 1;
 	ctx->conf.rx_chains_dynamic = 1;
 	ctx->mode = mode;
 
 	if (!local->use_chanctx) {
-		local->_oper_channel_type = channel_type;
-		local->_oper_channel = channel;
+		local->_oper_channel_type =
+			cfg80211_get_chandef_type(chandef);
+		local->_oper_channel = chandef->chan;
 		ieee80211_hw_config(local, 0);
 	} else {
 		err = drv_add_chanctx(local, ctx);
@@ -178,41 +131,38 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static enum nl80211_channel_type
-ieee80211_calc_chantype(struct ieee80211_local *local,
-			struct ieee80211_chanctx *ctx)
+static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
+					      struct ieee80211_chanctx *ctx)
 {
 	struct ieee80211_chanctx_conf *conf = &ctx->conf;
 	struct ieee80211_sub_if_data *sdata;
-	enum nl80211_channel_type result = NL80211_CHAN_NO_HT;
+	const struct cfg80211_chan_def *compat = NULL;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf)
 			continue;
 
-		WARN_ON_ONCE(!ieee80211_channel_types_are_compatible(
-					sdata->vif.bss_conf.channel_type,
-					result, &result));
+		if (!compat)
+			compat = &sdata->vif.bss_conf.chandef;
+
+		compat = cfg80211_chandef_compatible(
+				&sdata->vif.bss_conf.chandef, compat);
+		if (!compat)
+			break;
+		
 	}
 	rcu_read_unlock();
 
-	return result;
-}
-
-static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
-					      struct ieee80211_chanctx *ctx)
-{
-	enum nl80211_channel_type chantype;
-
-	lockdep_assert_held(&local->chanctx_mtx);
+	if (WARN_ON_ONCE(!compat))
+		return;
 
-	chantype = ieee80211_calc_chantype(local, ctx);
-	ieee80211_change_chantype(local, ctx, chantype);
+	ieee80211_change_chandef(local, ctx, compat);
 }
 
 static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
@@ -337,8 +287,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 }
 
 int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
-			      struct ieee80211_channel *channel,
-			      enum nl80211_channel_type channel_type,
+			      const struct cfg80211_chan_def *chandef,
 			      enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -350,15 +299,15 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&local->chanctx_mtx);
 	__ieee80211_vif_release_channel(sdata);
 
-	ctx = ieee80211_find_chanctx(local, channel, channel_type, mode);
+	ctx = ieee80211_find_chanctx(local, chandef, mode);
 	if (!ctx)
-		ctx = ieee80211_new_chanctx(local, channel, channel_type, mode);
+		ctx = ieee80211_new_chanctx(local, chandef, mode);
 	if (IS_ERR(ctx)) {
 		ret = PTR_ERR(ctx);
 		goto out;
 	}
 
-	sdata->vif.bss_conf.channel_type = channel_type;
+	sdata->vif.bss_conf.chandef = *chandef;
 
 	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
 	if (ret) {
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index ba9bd0e..cbde5cc 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -168,7 +168,6 @@ IEEE80211_IF_FILE(rc_rateidx_mcs_mask_5ghz,
 
 IEEE80211_IF_FILE(flags, flags, HEX);
 IEEE80211_IF_FILE(state, state, LHEX);
-IEEE80211_IF_FILE(channel_type, vif.bss_conf.channel_type, DEC);
 IEEE80211_IF_FILE(txpower, vif.bss_conf.txpower, DEC);
 IEEE80211_IF_FILE(ap_power_level, ap_power_level, DEC);
 IEEE80211_IF_FILE(user_power_level, user_power_level, DEC);
@@ -632,7 +631,6 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(state);
-	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(txpower);
 	DEBUGFS_ADD(user_power_level);
 	DEBUGFS_ADD(ap_power_level);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 49a36dc..6270d60 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -52,7 +52,6 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	struct cfg80211_chan_def chandef;
-	enum nl80211_channel_type chan_type;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -80,13 +79,14 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	chan_type = ifibss->channel_type;
-	cfg80211_chandef_create(&chandef, chan, chan_type);
-	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef))
-		chan_type = NL80211_CHAN_HT20;
+	cfg80211_chandef_create(&chandef, chan, ifibss->channel_type);
+	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+		chandef.width = NL80211_CHAN_WIDTH_20;
+		chandef.center_freq1 = chan->center_freq;
+	}
 
 	ieee80211_vif_release_channel(sdata);
-	if (ieee80211_vif_use_channel(sdata, chan, chan_type,
+	if (ieee80211_vif_use_channel(sdata, &chandef,
 				      ifibss->fixed_channel ?
 					IEEE80211_CHANCTX_SHARED :
 					IEEE80211_CHANCTX_EXCLUSIVE)) {
@@ -160,7 +160,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		       ifibss->ie, ifibss->ie_len);
 
 	/* add HT capability and information IEs */
-	if (chan_type != NL80211_CHAN_NO_HT &&
+	if (chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
 	    sband->ht_cap.ht_supported) {
 		pos = skb_put(skb, 4 +
 				   sizeof(struct ieee80211_ht_cap) +
@@ -173,7 +173,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		 * keep them at 0
 		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
-						 chan, chan_type, 0);
+						 &chandef, 0);
 	}
 
 	if (local->hw.queues >= IEEE80211_NUM_ACS) {
@@ -329,7 +329,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (WARN_ON_ONCE(!chanctx_conf))
 		return NULL;
-	band = chanctx_conf->channel->band;
+	band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
 	sta = sta_info_alloc(sdata, addr, GFP_KERNEL);
@@ -476,9 +476,11 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		    sdata->u.ibss.channel_type != NL80211_CHAN_NO_HT) {
 			/* we both use HT */
 			struct ieee80211_sta_ht_cap sta_ht_cap_new;
-			enum nl80211_channel_type channel_type =
-				ieee80211_ht_oper_to_channel_type(
-							elems->ht_operation);
+			struct cfg80211_chan_def chandef;
+
+			ieee80211_ht_oper_to_chandef(channel,
+						     elems->ht_operation,
+						     &chandef);
 
 			ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 							  elems->ht_cap_elem,
@@ -488,9 +490,9 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			 * fall back to HT20 if we don't use or use
 			 * the other extension channel
 			 */
-			if (!(channel_type == NL80211_CHAN_HT40MINUS ||
-			      channel_type == NL80211_CHAN_HT40PLUS) ||
-			    channel_type != sdata->u.ibss.channel_type)
+			if (chandef.width != NL80211_CHAN_WIDTH_40 ||
+			    cfg80211_get_chandef_type(&chandef) !=
+						sdata->u.ibss.channel_type)
 				sta_ht_cap_new.cap &=
 					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
@@ -614,7 +616,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 		return;
 	}
-	band = chanctx_conf->channel->band;
+	band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 21e1134..d6a2dc1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -799,7 +799,7 @@ ieee80211_get_sdata_band(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (!WARN_ON(!chanctx_conf))
-		band = chanctx_conf->channel->band;
+		band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
 	return band;
@@ -1156,8 +1156,7 @@ struct ieee80211_local {
 
 	/* virtual monitor interface */
 	struct ieee80211_sub_if_data __rcu *monitor_sdata;
-	struct ieee80211_channel *monitor_channel;
-	enum nl80211_channel_type monitor_channel_type;
+	struct cfg80211_chan_def monitor_chandef;
 };
 
 static inline struct ieee80211_sub_if_data *
@@ -1514,7 +1513,7 @@ static inline void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 	}
 
 	__ieee80211_tx_skb_tid_band(sdata, skb, tid,
-				    chanctx_conf->channel->band);
+				    chanctx_conf->def.chan->band);
 	rcu_read_unlock();
 }
 
@@ -1603,8 +1602,7 @@ size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap);
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
-			       struct ieee80211_channel *channel,
-			       enum nl80211_channel_type channel_type,
+			       const struct cfg80211_chan_def *chandef,
 			       u16 prot_mode);
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
@@ -1616,13 +1614,13 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 				enum ieee80211_band band);
 
 /* channel management */
-enum nl80211_channel_type
-ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper);
+void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
+				  struct ieee80211_ht_operation *ht_oper,
+				  struct cfg80211_chan_def *chandef);
 
 int __must_check
 ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
-			  struct ieee80211_channel *channel,
-			  enum nl80211_channel_type channel_type,
+			  const struct cfg80211_chan_def *chandef,
 			  enum ieee80211_chanctx_mode mode);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 80ce90b..5331662 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -54,7 +54,7 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 		return false;
 	}
 
-	power = chanctx_conf->channel->max_power;
+	power = chanctx_conf->def.chan->max_power;
 	rcu_read_unlock();
 
 	if (sdata->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
@@ -415,8 +415,7 @@ static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 		goto out_unlock;
 	}
 
-	ret = ieee80211_vif_use_channel(sdata, local->monitor_channel,
-					local->monitor_channel_type,
+	ret = ieee80211_vif_use_channel(sdata, &local->monitor_chandef,
 					IEEE80211_CHANCTX_EXCLUSIVE);
 	if (ret) {
 		drv_remove_interface(local, sdata);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b229cde..6e93340 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -798,10 +798,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			local->_oper_channel = &sband->channels[0];
 			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
 		}
-		if (!local->monitor_channel) {
-			local->monitor_channel = &sband->channels[0];
-			local->monitor_channel_type = NL80211_CHAN_NO_HT;
-		}
+		cfg80211_chandef_create(&local->monitor_chandef,
+					&sband->channels[0],
+					NL80211_CHAN_NO_HT);
 		channels += sband->n_channels;
 
 		if (max_bitrates < sband->n_bitrates)
@@ -884,10 +883,22 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (supp_ht)
 		local->scan_ies_len += 2 + sizeof(struct ieee80211_ht_cap);
 
-	if (supp_vht)
+	if (supp_vht) {
 		local->scan_ies_len +=
 			2 + sizeof(struct ieee80211_vht_cap);
 
+		/*
+		 * (for now at least), drivers wanting to use VHT must
+		 * support channel contexts, as they contain all the
+		 * necessary VHT information and the global hw config
+		 * doesn't (yet)
+		 */
+		if (WARN_ON(!local->use_chanctx)) {
+			result = -EINVAL;
+			goto fail_wiphy_register;
+		}
+	}
+
 	if (!local->ops->hw_scan) {
 		/* For hw_scan, driver needs to set these up. */
 		local->hw.wiphy->max_scan_ssids = 4;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a350cab..50a3b47 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -76,7 +76,7 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
 	u32 basic_rates = 0;
-	enum nl80211_channel_type sta_channel_type = NL80211_CHAN_NO_HT;
+	struct cfg80211_chan_def sta_chan_def;
 
 	/*
 	 * As support for each feature is added, check for matching
@@ -103,17 +103,11 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.bss_conf.basic_rates != basic_rates)
 		goto mismatch;
 
-	if (ie->ht_operation)
-		sta_channel_type =
-			ieee80211_ht_oper_to_channel_type(ie->ht_operation);
-
-	/* Disallow HT40+/- mismatch */
-	if (ie->ht_operation &&
-	    (sdata->vif.bss_conf.channel_type == NL80211_CHAN_HT40MINUS ||
-	     sdata->vif.bss_conf.channel_type == NL80211_CHAN_HT40PLUS) &&
-	    (sta_channel_type == NL80211_CHAN_HT40MINUS ||
-	     sta_channel_type == NL80211_CHAN_HT40PLUS) &&
-	    sdata->vif.bss_conf.channel_type != sta_channel_type)
+	ieee80211_ht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
+				     ie->ht_operation, &sta_chan_def);
+
+	if (!cfg80211_chandef_compatible(&sdata->vif.bss_conf.chandef,
+					 &sta_chan_def))
 		goto mismatch;
 
 	return true;
@@ -368,7 +362,7 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
 		rcu_read_unlock();
 		return -EINVAL;
 	}
-	chan = chanctx_conf->channel;
+	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -392,7 +386,7 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 
 	sband = local->hw.wiphy->bands[band];
 	if (!sband->ht_cap.ht_supported ||
-	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT)
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT)
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_cap))
@@ -411,7 +405,7 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type =
-		sdata->vif.bss_conf.channel_type;
+		cfg80211_get_chandef_type(&sdata->vif.bss_conf.chandef);
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sta_ht_cap *ht_cap;
 	u8 *pos;
@@ -422,7 +416,7 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 		rcu_read_unlock();
 		return -EINVAL;
 	}
-	channel = chanctx_conf->channel;
+	channel = chanctx_conf->def.chan;
 	rcu_read_unlock();
 
 	sband = local->hw.wiphy->bands[channel->band];
@@ -435,7 +429,7 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 		return -ENOMEM;
 
 	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_operation));
-	ieee80211_ie_build_ht_oper(pos, ht_cap, channel, channel_type,
+	ieee80211_ie_build_ht_oper(pos, ht_cap, &sdata->vif.bss_conf.chandef,
 				   sdata->vif.bss_conf.ht_operation_mode);
 
 	return 0;
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 234fe75..676c20d 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -117,7 +117,7 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 	u16 ht_opmode;
 	bool non_ht_sta = false, ht20_sta = false;
 
-	if (sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT)
+	if (sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT)
 		return 0;
 
 	rcu_read_lock();
@@ -126,14 +126,14 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 		    sta->plink_state != NL80211_PLINK_ESTAB)
 			continue;
 
-		switch (sta->ch_type) {
-		case NL80211_CHAN_NO_HT:
+		switch (sta->ch_width) {
+		case NL80211_CHAN_WIDTH_20_NOHT:
 			mpl_dbg(sdata,
 				"mesh_plink %pM: nonHT sta (%pM) is present\n",
 				sdata->vif.addr, sta->sta.addr);
 			non_ht_sta = true;
 			goto out;
-		case NL80211_CHAN_HT20:
+		case NL80211_CHAN_WIDTH_20:
 			mpl_dbg(sdata,
 				"mesh_plink %pM: HT20 sta (%pM) is present\n",
 				sdata->vif.addr, sta->sta.addr);
@@ -148,7 +148,7 @@ out:
 	if (non_ht_sta)
 		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED;
 	else if (ht20_sta &&
-		 sdata->vif.bss_conf.channel_type > NL80211_CHAN_HT20)
+		 sdata->vif.bss_conf.chandef.width > NL80211_CHAN_WIDTH_20)
 		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_20MHZ;
 	else
 		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
@@ -378,7 +378,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 
 	sta->sta.supp_rates[band] = rates;
 	if (elems->ht_cap_elem &&
-	    sdata->vif.bss_conf.channel_type != NL80211_CHAN_NO_HT)
+	    sdata->vif.bss_conf.chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  elems->ht_cap_elem,
 						  &sta->sta.ht_cap);
@@ -386,12 +386,15 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 		memset(&sta->sta.ht_cap, 0, sizeof(sta->sta.ht_cap));
 
 	if (elems->ht_operation) {
+		struct cfg80211_chan_def chandef;
+
 		if (!(elems->ht_operation->ht_param &
 		      IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
 			sta->sta.ht_cap.cap &=
 					    ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-		sta->ch_type =
-			ieee80211_ht_oper_to_channel_type(elems->ht_operation);
+		ieee80211_ht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
+					     elems->ht_operation, &chandef);
+		sta->ch_width = chandef.width;
 	}
 
 	rate_control_rate_init(sta);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6161446..e2b3f55 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -191,17 +191,19 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 		return 0;
 	}
-	chan = chanctx_conf->channel;
+	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
 	sband = local->hw.wiphy->bands[chan->band];
 
-	switch (sdata->vif.bss_conf.channel_type) {
-	case NL80211_CHAN_HT40PLUS:
-		if (chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
+	switch (sdata->vif.bss_conf.chandef.width) {
+	case NL80211_CHAN_WIDTH_40:
+		if (sdata->vif.bss_conf.chandef.chan->center_freq >
+				sdata->vif.bss_conf.chandef.center_freq1 &&
+		    chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
 			disable_40 = true;
-		break;
-	case NL80211_CHAN_HT40MINUS:
-		if (chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+		if (sdata->vif.bss_conf.chandef.chan->center_freq <
+				sdata->vif.bss_conf.chandef.center_freq1 &&
+		    chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
 			disable_40 = true;
 		break;
 	default:
@@ -381,7 +383,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		rcu_read_unlock();
 		return;
 	}
-	chan = chanctx_conf->channel;
+	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
 	sband = local->hw.wiphy->bands[chan->band];
 
@@ -2473,11 +2475,11 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	if (rx_status->freq != chanctx_conf->channel->center_freq) {
+	if (rx_status->freq != chanctx_conf->def.chan->center_freq) {
 		rcu_read_unlock();
 		return;
 	}
-	chan = chanctx_conf->channel;
+	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
 
 	if (ifmgd->assoc_data && !ifmgd->assoc_data->have_beacon &&
@@ -3188,6 +3190,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	const u8 *ht_oper_ie;
 	const struct ieee80211_ht_operation *ht_oper = NULL;
 	struct ieee80211_supported_band *sband;
+	struct cfg80211_chan_def chandef;
 
 	sband = local->hw.wiphy->bands[cbss->channel->band];
 
@@ -3268,7 +3271,8 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 
 	ieee80211_vif_release_channel(sdata);
-	return ieee80211_vif_use_channel(sdata, cbss->channel, channel_type,
+	cfg80211_chandef_create(&chandef, cbss->channel, channel_type);
+	return ieee80211_vif_use_channel(sdata, &chandef,
 					 IEEE80211_CHANCTX_SHARED);
 }
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3313c11..dd88381 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -391,7 +391,7 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 			return;
 
 		/* if HT BSS, and we handle a data frame, also try HT rates */
-		if (txrc->bss_conf->channel_type == NL80211_CHAN_NO_HT)
+		if (txrc->bss_conf->chandef.width == NL80211_CHAN_WIDTH_20_NOHT)
 			return;
 
 		fc = hdr->frame_control;
@@ -408,8 +408,7 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 
 		alt_rate.flags |= IEEE80211_TX_RC_MCS;
 
-		if ((txrc->bss_conf->channel_type == NL80211_CHAN_HT40MINUS) ||
-		    (txrc->bss_conf->channel_type == NL80211_CHAN_HT40PLUS))
+		if (txrc->bss_conf->chandef.width == NL80211_CHAN_WIDTH_40)
 			alt_rate.flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 
 		if (rate_idx_match_mcs_mask(&alt_rate, mcs_mask)) {
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index ec198ef..301386d 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -65,7 +65,7 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 		return;
 	}
 
-	sband = local->hw.wiphy->bands[chanctx_conf->channel->band];
+	sband = local->hw.wiphy->bands[chanctx_conf->def.chan->band];
 	rcu_read_unlock();
 
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a0836d7..dadcfcf 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1087,7 +1087,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	ieee80211_xmit(sdata, skb, chanctx_conf->channel->band);
+	ieee80211_xmit(sdata, skb, chanctx_conf->def.chan->band);
 	rcu_read_unlock();
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 776f3d0..2b2d5aa 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -272,7 +272,7 @@ struct sta_ampdu_mlme {
  * @t_offset: timing offset relative to this host
  * @t_offset_setpoint: reference timing offset of this sta to be used when
  * 	calculating clockdrift
- * @ch_type: peer's channel type
+ * @ch_width: peer's channel width
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -368,7 +368,7 @@ struct sta_info {
 	struct timer_list plink_timer;
 	s64 t_offset;
 	s64 t_offset_setpoint;
-	enum nl80211_channel_type ch_type;
+	enum nl80211_chan_width ch_width;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index bc28346..a8270b4 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -28,16 +28,21 @@
 #define VIF_PR_FMT	" vif:%s(%d%s)"
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 
-#define CHANCTX_ENTRY	__field(int, freq)					\
-			__field(int, chantype)					\
+#define CHANCTX_ENTRY	__field(u32, control_freq)				\
+			__field(u32, chan_width)				\
+			__field(u32, center_freq1)				\
+			__field(u32, center_freq2)				\
 			__field(u8, rx_chains_static)				\
 			__field(u8, rx_chains_dynamic)
-#define CHANCTX_ASSIGN	__entry->freq = ctx->conf.channel->center_freq;		\
-			__entry->chantype = ctx->conf.channel_type;		\
+#define CHANCTX_ASSIGN	__entry->control_freq = ctx->conf.def.chan->center_freq;\
+			__entry->chan_width = ctx->conf.def.width;		\
+			__entry->center_freq1 = ctx->conf.def.center_freq1;	\
+			__entry->center_freq2 = ctx->conf.def.center_freq2;	\
 			__entry->rx_chains_static = ctx->conf.rx_chains_static;	\
 			__entry->rx_chains_dynamic = ctx->conf.rx_chains_dynamic
-#define CHANCTX_PR_FMT	" freq:%d MHz chantype:%d chains:%d/%d"
-#define CHANCTX_PR_ARG	__entry->freq, __entry->chantype,			\
+#define CHANCTX_PR_FMT	" control:%d MHz width:%d center: %d/%d MHz chains:%d/%d"
+#define CHANCTX_PR_ARG	__entry->control_freq, __entry->chan_width,		\
+			__entry->center_freq1, __entry->center_freq2,		\
 			__entry->rx_chains_static, __entry->rx_chains_dynamic
 
 
@@ -334,7 +339,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(u16, ht_operation_mode)
 		__field(s32, cqm_rssi_thold);
 		__field(s32, cqm_rssi_hyst);
-		__field(u32, channel_type);
+		__field(u32, channel_width);
+		__field(u32, channel_cfreq1);
 		__dynamic_array(u32, arp_addr_list, info->arp_addr_cnt);
 		__field(bool, arp_filter_enabled);
 		__field(bool, qos);
@@ -370,7 +376,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->ht_operation_mode = info->ht_operation_mode;
 		__entry->cqm_rssi_thold = info->cqm_rssi_thold;
 		__entry->cqm_rssi_hyst = info->cqm_rssi_hyst;
-		__entry->channel_type = info->channel_type;
+		__entry->channel_width = info->chandef.width;
+		__entry->channel_cfreq1 = info->chandef.center_freq1;
 		memcpy(__get_dynamic_array(arp_addr_list), info->arp_addr_list,
 		       sizeof(u32) * info->arp_addr_cnt);
 		__entry->arp_filter_enabled = info->arp_filter_enabled;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b546887..d8ef341 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1676,7 +1676,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	if (!chanctx_conf)
 		goto fail_rcu;
 
-	chan = chanctx_conf->channel;
+	chan = chanctx_conf->def.chan;
 
 	/*
 	 * Frame injection is not allowed if beaconing is not allowed
@@ -1779,7 +1779,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		chanctx_conf = rcu_dereference(ap_sdata->vif.chanctx_conf);
 		if (!chanctx_conf)
 			goto fail_rcu;
-		band = chanctx_conf->channel->band;
+		band = chanctx_conf->def.chan->band;
 		if (sta)
 			break;
 		/* fall through */
@@ -1794,7 +1794,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 		if (!chanctx_conf)
 			goto fail_rcu;
-		band = chanctx_conf->channel->band;
+		band = chanctx_conf->def.chan->band;
 		break;
 	case NL80211_IFTYPE_WDS:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
@@ -1871,7 +1871,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 		if (!chanctx_conf)
 			goto fail_rcu;
-		band = chanctx_conf->channel->band;
+		band = chanctx_conf->def.chan->band;
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
@@ -1930,7 +1930,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 		if (!chanctx_conf)
 			goto fail_rcu;
-		band = chanctx_conf->channel->band;
+		band = chanctx_conf->def.chan->band;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		/* DA SA BSSID */
@@ -1941,7 +1941,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 		if (!chanctx_conf)
 			goto fail_rcu;
-		band = chanctx_conf->channel->band;
+		band = chanctx_conf->def.chan->band;
 		break;
 	default:
 		goto fail_rcu;
@@ -2191,7 +2191,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 			return true;
 		}
 		result = ieee80211_tx(sdata, skb, true,
-				      chanctx_conf->channel->band);
+				      chanctx_conf->def.chan->band);
 	} else {
 		struct sk_buff_head skbs;
 
@@ -2455,7 +2455,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
 
-		band = chanctx_conf->channel->band;
+		band = chanctx_conf->def.chan->band;
 
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_ds_params_ie(skb, sdata) ||
@@ -2474,7 +2474,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	band = chanctx_conf->channel->band;
+	band = chanctx_conf->def.chan->band;
 
 	info = IEEE80211_SKB_CB(skb);
 
@@ -2754,7 +2754,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	info = IEEE80211_SKB_CB(skb);
 
 	tx.flags |= IEEE80211_TX_PS_BUFFERED;
-	info->band = chanctx_conf->channel->band;
+	info->band = chanctx_conf->def.chan->band;
 
 	if (invoke_tx_handlers(&tx))
 		skb = NULL;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2f08a7e..3b3dd32 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -898,7 +898,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	use_11b = (chanctx_conf &&
-		   chanctx_conf->channel->band == IEEE80211_BAND_2GHZ) &&
+		   chanctx_conf->def.chan->band == IEEE80211_BAND_2GHZ) &&
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 	rcu_read_unlock();
 
@@ -991,7 +991,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
 	if (chanctx_conf &&
-	    chanctx_conf->channel->band == IEEE80211_BAND_2GHZ &&
+	    chanctx_conf->def.chan->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
 		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 	else
@@ -1871,8 +1871,7 @@ u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 }
 
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
-			       struct ieee80211_channel *channel,
-			       enum nl80211_channel_type channel_type,
+			       const struct cfg80211_chan_def *chandef,
 			       u16 prot_mode)
 {
 	struct ieee80211_ht_operation *ht_oper;
@@ -1880,23 +1879,25 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 	*pos++ = WLAN_EID_HT_OPERATION;
 	*pos++ = sizeof(struct ieee80211_ht_operation);
 	ht_oper = (struct ieee80211_ht_operation *)pos;
-	ht_oper->primary_chan =
-			ieee80211_frequency_to_channel(channel->center_freq);
-	switch (channel_type) {
-	case NL80211_CHAN_HT40MINUS:
-		ht_oper->ht_param = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-		break;
-	case NL80211_CHAN_HT40PLUS:
-		ht_oper->ht_param = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+	ht_oper->primary_chan = ieee80211_frequency_to_channel(
+					chandef->chan->center_freq);
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_160:
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_40:
+		if (chandef->center_freq1 > chandef->chan->center_freq)
+			ht_oper->ht_param = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		else
+			ht_oper->ht_param = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
 		break;
-	case NL80211_CHAN_HT20:
 	default:
 		ht_oper->ht_param = IEEE80211_HT_PARAM_CHA_SEC_NONE;
 		break;
 	}
 	if (ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
-	    channel_type != NL80211_CHAN_NO_HT &&
-	    channel_type != NL80211_CHAN_HT20)
+	    chandef->width != NL80211_CHAN_WIDTH_20_NOHT &&
+	    chandef->width != NL80211_CHAN_WIDTH_20)
 		ht_oper->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
 
 	ht_oper->operation_mode = cpu_to_le16(prot_mode);
@@ -1910,13 +1911,17 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 	return pos + sizeof(struct ieee80211_ht_operation);
 }
 
-enum nl80211_channel_type
-ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper)
+void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
+				  struct ieee80211_ht_operation *ht_oper,
+				  struct cfg80211_chan_def *chandef)
 {
 	enum nl80211_channel_type channel_type;
 
-	if (!ht_oper)
-		return NL80211_CHAN_NO_HT;
+	if (!ht_oper) {
+		cfg80211_chandef_create(chandef, control_chan,
+					NL80211_CHAN_NO_HT);
+		return;
+	}
 
 	switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
@@ -1932,7 +1937,7 @@ ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper)
 		channel_type = NL80211_CHAN_NO_HT;
 	}
 
-	return channel_type;
+	cfg80211_chandef_create(chandef, control_chan, channel_type);
 }
 
 int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
-- 
1.8.0

