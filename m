Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54317 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab2EJGpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 02:45:13 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/7] mac80211: move oper_channel to sdata
Date: Thu, 10 May 2012 08:44:42 +0200
Message-ID: <1336632282-2278-8-git-send-email-michal.kazior@tieto.com> (sfid-20120510_084522_020358_156C2D54)
In-Reply-To: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change-Id: I647c0e6dae9e9184f471d73a6a895f66d14d9b69
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         |   58 +++++++++++++++++++++++++++++++-------------
 net/mac80211/ibss.c        |    8 +++---
 net/mac80211/ieee80211_i.h |    3 +-
 net/mac80211/iface.c       |    4 ++-
 net/mac80211/main.c        |   11 ++++----
 net/mac80211/mesh.c        |    4 +-
 net/mac80211/mesh_plink.c  |    2 +-
 net/mac80211/mlme.c        |   22 ++++++++--------
 net/mac80211/scan.c        |    2 +-
 9 files changed, 70 insertions(+), 44 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1898299..9b3d8a0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -750,7 +750,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 mask, set;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[sdata->oper_channel->band];
 
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
@@ -865,7 +865,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 					rates |= BIT(j);
 			}
 		}
-		sta->sta.supp_rates[local->oper_channel->band] = rates;
+		sta->sta.supp_rates[sdata->oper_channel->band] = rates;
 	}
 
 	if (params->ht_capa)
@@ -1409,9 +1409,8 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	if (params->basic_rates) {
 		int i, j;
 		u32 rates = 0;
-		struct ieee80211_local *local = wiphy_priv(wiphy);
 		struct ieee80211_supported_band *sband =
-			wiphy->bands[local->oper_channel->band];
+			wiphy->bands[sdata->oper_channel->band];
 
 		for (i = 0; i < params->basic_rates_len; i++) {
 			int rate = (params->basic_rates[i] & 0x7f) * 5;
@@ -1479,6 +1478,31 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 	return 0;
 }
 
+static bool ieee80211_can_use_fixed_channel(struct ieee80211_local *local,
+					    struct ieee80211_channel *channel)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int result = true;
+
+	/* cfg80211 arbitrates multi-channel */
+	if (local->hw.wiphy->flags & WIPHY_FLAG_ENFORCE_COMBINATIONS)
+		return true;
+
+	/* support legacy single-channel mode */
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (sdata->oper_channel != channel) {
+			result = false;
+			break;
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	return result;
+}
+
 static int ieee80211_set_channel(struct wiphy *wiphy,
 				 struct net_device *netdev,
 				 struct ieee80211_channel *chan,
@@ -1497,7 +1521,7 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	case CHAN_MODE_HOPPING:
 		return -EBUSY;
 	case CHAN_MODE_FIXED:
-		if (local->oper_channel != chan)
+		if (!ieee80211_can_use_fixed_channel(local, chan))
 			return -EBUSY;
 		break;
 	case CHAN_MODE_UNDEFINED:
@@ -1511,11 +1535,11 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	if (!ieee80211_set_channel_type(local, sdata, channel_type))
 		return -EBUSY;
 
-	old_oper = local->oper_channel;
-	local->oper_channel = chan;
+	old_oper = sdata->oper_channel;
+	sdata->oper_channel = chan;
 
 	/* Update driver if changes were actually made. */
-	if ((old_oper != local->oper_channel) ||
+	if ((old_oper != sdata->oper_channel) ||
 	    (old_oper_type != ieee80211_oper_channel_type(local, sdata)))
 		ieee80211_recalc_channel(sdata);
 
@@ -1613,9 +1637,9 @@ static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
 	case CHAN_MODE_HOPPING:
 		return -EBUSY;
 	case CHAN_MODE_FIXED:
-		if (local->oper_channel == req->bss->channel)
-			break;
-		return -EBUSY;
+		if (!ieee80211_can_use_fixed_channel(local, req->bss->channel))
+			return -EBUSY;
+		break;
 	case CHAN_MODE_UNDEFINED:
 		break;
 	}
@@ -1647,9 +1671,9 @@ static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	case CHAN_MODE_FIXED:
 		if (!params->channel_fixed)
 			return -EBUSY;
-		if (local->oper_channel == params->channel)
-			break;
-		return -EBUSY;
+		if (!ieee80211_can_use_fixed_channel(local, params->channel))
+			return -EBUSY;
+		break;
 	case CHAN_MODE_UNDEFINED:
 		break;
 	}
@@ -2058,7 +2082,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 
 	/* Check that we are on the requested channel for transmission */
 	if (chan != local->tmp_channel &&
-	    chan != local->oper_channel)
+	    chan != sdata->oper_channel)
 		is_offchan = true;
 	if (channel_type_valid &&
 	    (channel_type != local->tmp_channel_type &&
@@ -2323,7 +2347,7 @@ static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
 	u16 capab;
 
 	capab = 0;
-	if (local->oper_channel->band != IEEE80211_BAND_2GHZ)
+	if (sdata->oper_channel->band != IEEE80211_BAND_2GHZ)
 		return capab;
 
 	if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
@@ -2699,7 +2723,7 @@ ieee80211_wiphy_get_channel(struct wiphy *wiphy,
 			container_of(wdev, struct ieee80211_sub_if_data, wdev);
 
 	*type = ieee80211_oper_channel_type(local, sdata);
-	return local->oper_channel;
+	return sdata->oper_channel;
 }
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 718ee49..3159700 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -80,7 +80,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	local->oper_channel = chan;
+	sdata->oper_channel = chan;
 	channel_type = ifibss->channel_type;
 	if (channel_type > NL80211_CHAN_HT20 &&
 	    !cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
@@ -496,7 +496,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		goto put_bss;
 
 	/* different channel */
-	if (cbss->channel != local->oper_channel)
+	if (cbss->channel != sdata->oper_channel)
 		goto put_bss;
 
 	/* different SSID */
@@ -778,7 +778,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 
 		if (time_after(jiffies, ifibss->ibss_join_req +
 			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
-			if (!(local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)) {
+			if (!(sdata->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)) {
 				ieee80211_sta_create_ibss(sdata);
 				return;
 			}
@@ -1088,7 +1088,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	/* fix ourselves to that channel now already */
 	if (params->channel_fixed) {
-		sdata->local->oper_channel = params->channel;
+		sdata->oper_channel = params->channel;
 		if (!ieee80211_set_channel_type(sdata->local, sdata,
 					       params->channel_type)) {
 			mutex_unlock(&sdata->u.ibss.mtx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3a1af25..66fe242 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -717,6 +717,8 @@ struct ieee80211_sub_if_data {
 
 	bool arp_filter_state;
 
+	struct ieee80211_channel *oper_channel, *csa_channel;
+
 	/*
 	 * AP this belongs to: self in AP mode and
 	 * corresponding AP in VLAN mode, NULL for
@@ -993,7 +995,6 @@ struct ieee80211_local {
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
-	struct ieee80211_channel *oper_channel, *csa_channel;
 
 	/* Temporary remain-on-channel for off-channel operations */
 	struct ieee80211_sub_if_data *tmp_sdata;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 77b9154..394d33f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1124,7 +1124,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 		return 0;
 
 	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
-	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
+	if (sdata->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
 	    type == NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
@@ -1312,6 +1312,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	sdata->arp_filter_state = true;
 #endif
 
+	sdata->oper_channel = &local->hw.wiphy->bands[0]->channels[0];
+
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
 		skb_queue_head_init(&sdata->fragments[i].skb_list);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6c05464..3959dfb 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -133,7 +133,7 @@ void ieee80211_recalc_channel(struct ieee80211_sub_if_data *sdata)
 		/* If scanning on oper channel, use whatever channel-type
 		 * is currently in use.
 		 */
-		if (chan == local->oper_channel)
+		if (chan == sdata->oper_channel)
 			channel_type = oper_channel_type;
 		else
 			channel_type = NL80211_CHAN_NO_HT;
@@ -141,11 +141,11 @@ void ieee80211_recalc_channel(struct ieee80211_sub_if_data *sdata)
 		chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
 	} else {
-		chan = local->oper_channel;
+		chan = sdata->oper_channel;
 		channel_type = oper_channel_type;
 	}
 
-	if (chan != local->oper_channel ||
+	if (chan != sdata->oper_channel ||
 	    channel_type != oper_channel_type)
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
 	else
@@ -737,10 +737,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		sband = local->hw.wiphy->bands[band];
 		if (!sband)
 			continue;
-		if (!local->oper_channel) {
+		if (!local->hw.conf.channel) {
 			/* init channel we're on */
-			local->hw.conf.channel =
-			local->oper_channel = &sband->channels[0];
+			local->hw.conf.channel = &sband->channels[0];
 			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
 		}
 		channels += sband->n_channels;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ac03c4b..742124b 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -361,7 +361,7 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[sdata->oper_channel->band];
 	if (!sband->ht_cap.ht_supported ||
 	    ieee80211_oper_channel_type(local, sdata) == NL80211_CHAN_NO_HT)
 		return 0;
@@ -379,7 +379,7 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_channel *channel = local->oper_channel;
+	struct ieee80211_channel *channel = sdata->oper_channel;
 	enum nl80211_channel_type channel_type =
 				ieee80211_oper_channel_type(local, sdata);
 	struct ieee80211_supported_band *sband =
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 9c836e7..a97f5e6 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -93,7 +93,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[sdata->oper_channel->band];
 
 	if (local->num_sta >= MESH_MAX_PLINKS)
 		return NULL;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f75947b..17174a4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -351,7 +351,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	lockdep_assert_held(&ifmgd->mtx);
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[sdata->oper_channel->band];
 
 	if (assoc_data->supp_rates_len) {
 		/*
@@ -472,7 +472,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		*pos++ = WLAN_EID_PWR_CAPABILITY;
 		*pos++ = 2;
 		*pos++ = 0; /* min tx power */
-		*pos++ = local->oper_channel->max_power; /* max tx power */
+		*pos++ = sdata->oper_channel->max_power; /* max tx power */
 
 		/* 2. supported channels */
 		/* TODO: get this in reg domain format */
@@ -510,7 +510,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ht_operation_ie,
-				    sband, local->oper_channel, ifmgd->ap_smps);
+				    sband, sdata->oper_channel, ifmgd->ap_smps);
 
 	/* if present, add any custom non-vendor IEs that go after HT */
 	if (assoc_data->ie_len && assoc_data->ie) {
@@ -678,17 +678,17 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	sdata->local->oper_channel = sdata->local->csa_channel;
+	sdata->oper_channel = sdata->csa_channel;
 	if (!sdata->local->ops->channel_switch) {
 		/* call "hw_config" only if doing sw channel switch */
 		ieee80211_recalc_channel(sdata);
 	} else {
 		/* update the device channel directly */
-		sdata->local->hw.conf.channel = sdata->local->oper_channel;
+		sdata->local->hw.conf.channel = sdata->oper_channel;
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->local->oper_channel;
+	ifmgd->associated->channel = sdata->oper_channel;
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -713,7 +713,7 @@ void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 		 * good handling of this situation, possibly we
 		 * should just drop the association.
 		 */
-		sdata->local->csa_channel = sdata->local->oper_channel;
+		sdata->csa_channel = sdata->oper_channel;
 	}
 
 	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
@@ -764,7 +764,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	sdata->local->csa_channel = new_ch;
+	sdata->csa_channel = new_ch;
 
 	if (sdata->local->ops->channel_switch) {
 		/* use driver's channel switch callback */
@@ -2021,7 +2021,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		return false;
 	}
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[sdata->oper_channel->band];
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
@@ -3109,7 +3109,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 						    channel_type));
 	}
 
-	local->oper_channel = cbss->channel;
+	sdata->oper_channel = cbss->channel;
 	ieee80211_hw_config(local, 0);
 	ieee80211_recalc_channel(sdata);
 
@@ -3143,7 +3143,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.basic_rates = basic_rates;
 
 		/* cf. IEEE 802.11 9.2.12 */
-		if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
+		if (sdata->oper_channel->band == IEEE80211_BAND_2GHZ &&
 		    have_higher_than_11mbit)
 			sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 		else
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 71d642e..b20bff1 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -245,7 +245,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	if (bss)
 		ieee80211_rx_bss_put(sdata->local, bss);
 
-	if (channel == sdata->local->oper_channel)
+	if (channel == sdata->oper_channel)
 		return RX_CONTINUE;
 
 	dev_kfree_skb(skb);
-- 
1.7.0.4

