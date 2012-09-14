Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2INMgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:36:43 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/10] mac80211: track needed RX chains for channel contexts
Date: Fri, 14 Sep 2012 14:37:11 +0200
Message-Id: <1347626233-21916-9-git-send-email-johannes@sipsolutions.net> (sfid-20120914_143654_973677_B443F67C)
In-Reply-To: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

On each channel that the device is operating on, it
may need to listen using one or more chains depending
on the SMPS settings of the interfaces using it. The
previous channel context changes completely removed
this ability (before, it was available as the SMPS
mode).

Add per-context tracking of the required static and
dynamic RX chains and notify the driver on changes.
To achieve this, track the chains and SMPS mode used
on each virtual interface and update the channel
context whenever this changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h        |   15 ++++++-
 net/mac80211/cfg.c            |   15 +++++--
 net/mac80211/chan.c           |   90 ++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/debugfs_netdev.c |    2 +-
 net/mac80211/ibss.c           |    3 ++
 net/mac80211/ieee80211_i.h    |   20 ++++++---
 net/mac80211/iface.c          |   10 +++++
 net/mac80211/main.c           |   18 ++++-----
 net/mac80211/mlme.c           |   28 ++++++++++---
 net/mac80211/status.c         |   15 +++----
 net/mac80211/trace.h          |   13 ++++--
 net/mac80211/util.c           |   82 +++++++++++++------------------------
 12 files changed, 219 insertions(+), 92 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d9d2119..3560881 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -146,9 +146,11 @@ struct ieee80211_low_level_stats {
 /**
  * enum ieee80211_chanctx_change - change flag for channel context
  * @IEEE80211_CHANCTX_CHANGE_CHANNEL_TYPE: The channel type was changed
+ * @IEEE80211_CHANCTX_CHANGE_RX_CHAINS: The number of RX chains changed
  */
 enum ieee80211_chanctx_change {
 	IEEE80211_CHANCTX_CHANGE_CHANNEL_TYPE	= BIT(0),
+	IEEE80211_CHANCTX_CHANGE_RX_CHAINS	= BIT(1),
 };
 
 /**
@@ -159,6 +161,11 @@ enum ieee80211_chanctx_change {
  *
  * @channel: the channel to tune to
  * @channel_type: the channel (HT) type
+ * @rx_chains_static: The number of RX chains that must always be
+ *	active on the channel to receive MIMO transmissions
+ * @rx_chains_dynamic: The number of RX chains that must be enabled
+ *	after RTS/CTS handshake to receive SMPS MIMO transmissions;
+ *	this will always be >= @rx_chains_always.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  */
@@ -166,6 +173,8 @@ struct ieee80211_chanctx_conf {
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type;
 
+	u8 rx_chains_static, rx_chains_dynamic;
+
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
@@ -820,6 +829,8 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
  * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
+ *	Note that this is only valid if channel contexts are not used,
+ *	otherwise each channel context has the number of chains listed.
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
@@ -885,7 +896,9 @@ enum ieee80211_smps_mode {
  *
  * @smps_mode: spatial multiplexing powersave mode; note that
  *	%IEEE80211_SMPS_STATIC is used when the device is not
- *	configured for an HT channel
+ *	configured for an HT channel.
+ *	Note that this is only valid if channel contexts are not used,
+ *	otherwise each channel context has the number of chains listed.
  */
 struct ieee80211_conf {
 	u32 flags;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d251ddb..6ec5fab 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -883,6 +883,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (old)
 		return -EALREADY;
 
+	/* TODO: make hostapd tell us what it wants */
+	sdata->smps_mode = IEEE80211_SMPS_OFF;
+	sdata->needed_rx_chains = sdata->local->rx_chains;
+
 	err = ieee80211_vif_use_channel(sdata, params->channel,
 					params->channel_type,
 					IEEE80211_CHANCTX_SHARED);
@@ -1672,6 +1676,10 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	if (err)
 		return err;
 
+	/* can mesh use other SMPS modes? */
+	sdata->smps_mode = IEEE80211_SMPS_OFF;
+	sdata->needed_rx_chains = sdata->local->rx_chains;
+
 	err = ieee80211_vif_use_channel(sdata, setup->channel,
 					setup->channel_type,
 					IEEE80211_CHANCTX_SHARED);
@@ -2051,13 +2059,12 @@ int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 
 	/*
 	 * If not associated, or current association is not an HT
-	 * association, there's no need to send an action frame.
+	 * association, there's no need to do anything, just store
+	 * the new value until we associate.
 	 */
 	if (!sdata->u.mgd.associated ||
-	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT) {
-		ieee80211_recalc_smps(sdata->local);
+	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT)
 		return 0;
-	}
 
 	ap = sdata->u.mgd.associated->bssid;
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index ca2be76..c2df2b6 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -118,6 +118,8 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 
 	ctx->conf.channel = channel;
 	ctx->conf.channel_type = channel_type;
+	ctx->conf.rx_chains_static = 1;
+	ctx->conf.rx_chains_dynamic = 1;
 	ctx->mode = mode;
 
 	if (!local->use_chanctx) {
@@ -222,8 +224,10 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	drv_unassign_vif_chanctx(local, sdata, ctx);
 
-	if (ctx->refcount > 0)
+	if (ctx->refcount > 0) {
 		ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
+		ieee80211_recalc_smps_chanctx(local, ctx);
+	}
 }
 
 static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
@@ -246,6 +250,89 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 		ieee80211_free_chanctx(local, ctx);
 }
 
+void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
+				   struct ieee80211_chanctx *chanctx)
+{
+	struct ieee80211_sub_if_data *sdata;
+	u8 rx_chains_static, rx_chains_dynamic;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	rx_chains_static = 1;
+	rx_chains_dynamic = 1;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		u8 needed_static, needed_dynamic;
+
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		if (rcu_access_pointer(sdata->vif.chanctx_conf) !=
+						&chanctx->conf)
+			continue;
+
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_P2P_DEVICE:
+			continue;
+		case NL80211_IFTYPE_STATION:
+			if (!sdata->u.mgd.associated)
+				continue;
+			break;
+		case NL80211_IFTYPE_AP_VLAN:
+			continue;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
+			break;
+		default:
+			WARN_ON_ONCE(1);
+		}
+
+		switch (sdata->smps_mode) {
+		default:
+			WARN_ONCE(1, "Invalid SMPS mode %d\n",
+				  sdata->smps_mode);
+			/* fall through */
+		case IEEE80211_SMPS_OFF:
+			needed_static = sdata->needed_rx_chains;
+			needed_dynamic = sdata->needed_rx_chains;
+			break;
+		case IEEE80211_SMPS_DYNAMIC:
+			needed_static = 1;
+			needed_dynamic = sdata->needed_rx_chains;
+			break;
+		case IEEE80211_SMPS_STATIC:
+			needed_static = 1;
+			needed_dynamic = 1;
+			break;
+		}
+
+		rx_chains_static = max(rx_chains_static, needed_static);
+		rx_chains_dynamic = max(rx_chains_dynamic, needed_dynamic);
+	}
+	rcu_read_unlock();
+
+	if (!local->use_chanctx) {
+		if (rx_chains_static > 1)
+			local->smps_mode = IEEE80211_SMPS_OFF;
+		else if (rx_chains_dynamic > 1)
+			local->smps_mode = IEEE80211_SMPS_DYNAMIC;
+		else
+			local->smps_mode = IEEE80211_SMPS_STATIC;
+		ieee80211_hw_config(local, 0);
+	}
+
+	if (rx_chains_static == chanctx->conf.rx_chains_static &&
+	    rx_chains_dynamic == chanctx->conf.rx_chains_dynamic)
+		return;
+
+	chanctx->conf.rx_chains_static = rx_chains_static;
+	chanctx->conf.rx_chains_dynamic = rx_chains_dynamic;
+	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RX_CHAINS);
+}
+
 int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 			      struct ieee80211_channel *channel,
 			      enum nl80211_channel_type channel_type,
@@ -276,6 +363,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	ieee80211_recalc_smps_chanctx(local, ctx);
  out:
 	mutex_unlock(&local->chanctx_mtx);
 	return ret;
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 6d5aec9..34e1739 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -217,7 +217,7 @@ static ssize_t ieee80211_if_fmt_smps(const struct ieee80211_sub_if_data *sdata,
 
 	return snprintf(buf, buflen, "request: %s\nused: %s\n",
 			smps_modes[sdata->u.mgd.req_smps],
-			smps_modes[sdata->u.mgd.ap_smps]);
+			smps_modes[sdata->smps_mode]);
 }
 
 static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 934d94b..418470b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1132,6 +1132,9 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	changed |= BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	sdata->smps_mode = IEEE80211_SMPS_OFF;
+	sdata->needed_rx_chains = sdata->local->rx_chains;
+
 	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e023092..57de96f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -433,7 +433,6 @@ struct ieee80211_if_managed {
 	bool powersave; /* powersave requested for this iface */
 	bool broken_ap; /* AP is broken -- turn off powersave */
 	enum ieee80211_smps_mode req_smps, /* requested smps mode */
-				 ap_smps, /* smps mode AP thinks we're in */
 				 driver_smps_mode; /* smps mode request */
 
 	struct work_struct request_smps_work;
@@ -728,11 +727,17 @@ struct ieee80211_sub_if_data {
 
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 
+	/* used to reconfigure hardware SM PS */
+	struct work_struct recalc_smps;
+
 	struct work_struct work;
 	struct sk_buff_head skb_queue;
 
 	bool arp_filter_state;
 
+	u8 needed_rx_chains;
+	enum ieee80211_smps_mode smps_mode;
+
 	/*
 	 * AP this belongs to: self in AP mode and
 	 * corresponding AP in VLAN mode, NULL for
@@ -905,9 +910,6 @@ struct ieee80211_local {
 	/* used for uploading changed mc list */
 	struct work_struct reconfig_filter;
 
-	/* used to reconfigure hardware SM PS */
-	struct work_struct recalc_smps;
-
 	/* aggregated multicast list */
 	struct netdev_hw_addr_list mc_list;
 
@@ -944,6 +946,9 @@ struct ieee80211_local {
 	/* wowlan is enabled -- don't reconfig on resume */
 	bool wowlan;
 
+	/* number of RX chains the hardware has */
+	u8 rx_chains;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
@@ -1408,6 +1413,8 @@ void ieee80211_ba_session_work(struct work_struct *work);
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 
+u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
+
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
@@ -1524,7 +1531,7 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    enum ieee80211_band band, u32 *basic_rates);
 int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 			     enum ieee80211_smps_mode smps_mode);
-void ieee80211_recalc_smps(struct ieee80211_local *local);
+void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata);
 
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
@@ -1555,6 +1562,9 @@ ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 			  enum ieee80211_chanctx_mode mode);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 
+void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
+				   struct ieee80211_chanctx *chanctx);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7cb8382..99f2b19 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -739,6 +739,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
+	cancel_work_sync(&sdata->recalc_smps);
+
 	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
@@ -1125,6 +1127,13 @@ static void ieee80211_iface_work(struct work_struct *work)
 	}
 }
 
+static void ieee80211_recalc_smps_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, recalc_smps);
+
+	ieee80211_recalc_smps(sdata);
+}
 
 /*
  * Helper function to initialise an interface to a specific type.
@@ -1153,6 +1162,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 
 	skb_queue_head_init(&sdata->skb_queue);
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
+	INIT_WORK(&sdata->recalc_smps, ieee80211_recalc_smps_work);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 9cb6280..2c8969b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -372,14 +372,6 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_restart_hw);
 
-static void ieee80211_recalc_smps_work(struct work_struct *work)
-{
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, recalc_smps);
-
-	ieee80211_recalc_smps(local);
-}
-
 #ifdef CONFIG_INET
 static int ieee80211_ifa_changed(struct notifier_block *nb,
 				 unsigned long data, void *arg)
@@ -667,7 +659,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	INIT_WORK(&local->restart_work, ieee80211_restart_work);
 
 	INIT_WORK(&local->reconfig_filter, ieee80211_reconfig_filter);
-	INIT_WORK(&local->recalc_smps, ieee80211_recalc_smps_work);
 	local->smps_mode = IEEE80211_SMPS_OFF;
 
 	INIT_WORK(&local->dynamic_ps_enable_work,
@@ -773,6 +764,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (hw->max_report_rates == 0)
 		hw->max_report_rates = hw->max_rates;
 
+	local->rx_chains = 1;
+
 	/*
 	 * generic code guarantees at least one band,
 	 * set this very early because much code assumes
@@ -804,6 +797,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			max_bitrates = sband->n_bitrates;
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 		supp_vht = supp_vht || sband->vht_cap.vht_supported;
+
+		if (sband->ht_cap.ht_supported)
+			local->rx_chains =
+				max(ieee80211_mcs_to_chains(&sband->ht_cap.mcs),
+				    local->rx_chains);
+
+		/* TODO: consider VHT for RX chains, hopefully it's the same */
 	}
 
 	local->int_scan_req = kzalloc(sizeof(*local->int_scan_req) +
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a717392..bfc2a56 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -543,7 +543,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ap_ht_param,
-				    sband, chan, ifmgd->ap_smps);
+				    sband, chan, sdata->smps_mode);
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 		ieee80211_add_vht_ie(sdata, skb, sband);
@@ -1392,7 +1392,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_ps(local, -1);
 	mutex_unlock(&local->iflist_mtx);
 
-	ieee80211_recalc_smps(local);
+	ieee80211_recalc_smps(sdata);
 	ieee80211_recalc_ps_vif(sdata);
 
 	netif_tx_start_all_queues(sdata->dev);
@@ -3157,6 +3157,10 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (ht_oper) {
+		const u8 *ht_cap_ie;
+		const struct ieee80211_ht_cap *ht_cap;
+		u8 chains = 1;
+
 		channel_type = NL80211_CHAN_HT20;
 
 		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
@@ -3170,8 +3174,22 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 				break;
 			}
 		}
+
+		ht_cap_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
+					     cbss->information_elements,
+					     cbss->len_information_elements);
+		if (ht_cap_ie && ht_cap_ie[1] >= sizeof(*ht_cap)) {
+			ht_cap = (void *)(ht_cap_ie + 2);
+			chains = ieee80211_mcs_to_chains(&ht_cap->mcs);
+		}
+		sdata->needed_rx_chains = min(chains, local->rx_chains);
+	} else {
+		sdata->needed_rx_chains = 1;
 	}
 
+	/* will change later if needed */
+	sdata->smps_mode = IEEE80211_SMPS_OFF;
+
 	ieee80211_vif_release_channel(sdata);
 	return ieee80211_vif_use_channel(sdata, cbss->channel, channel_type,
 					 IEEE80211_CHANCTX_SHARED);
@@ -3485,11 +3503,11 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	if (ifmgd->req_smps == IEEE80211_SMPS_AUTOMATIC) {
 		if (ifmgd->powersave)
-			ifmgd->ap_smps = IEEE80211_SMPS_DYNAMIC;
+			sdata->smps_mode = IEEE80211_SMPS_DYNAMIC;
 		else
-			ifmgd->ap_smps = IEEE80211_SMPS_OFF;
+			sdata->smps_mode = IEEE80211_SMPS_OFF;
 	} else
-		ifmgd->ap_smps = ifmgd->req_smps;
+		sdata->smps_mode = ifmgd->req_smps;
 
 	assoc_data->capability = req->bss->capability;
 	assoc_data->wmm = bss->wmm_used &&
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 2ce8973..f143cd1 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -189,30 +189,31 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	}
 
 	if (ieee80211_is_action(mgmt->frame_control) &&
-	    sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    mgmt->u.action.category == WLAN_CATEGORY_HT &&
-	    mgmt->u.action.u.ht_smps.action == WLAN_HT_ACTION_SMPS) {
+	    mgmt->u.action.u.ht_smps.action == WLAN_HT_ACTION_SMPS &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    ieee80211_sdata_running(sdata)) {
 		/*
 		 * This update looks racy, but isn't -- if we come
 		 * here we've definitely got a station that we're
 		 * talking to, and on a managed interface that can
 		 * only be the AP. And the only other place updating
-		 * this variable is before we're associated.
+		 * this variable in managed mode is before association.
 		 */
 		switch (mgmt->u.action.u.ht_smps.smps_control) {
 		case WLAN_HT_SMPS_CONTROL_DYNAMIC:
-			sta->sdata->u.mgd.ap_smps = IEEE80211_SMPS_DYNAMIC;
+			sdata->smps_mode = IEEE80211_SMPS_DYNAMIC;
 			break;
 		case WLAN_HT_SMPS_CONTROL_STATIC:
-			sta->sdata->u.mgd.ap_smps = IEEE80211_SMPS_STATIC;
+			sdata->smps_mode = IEEE80211_SMPS_STATIC;
 			break;
 		case WLAN_HT_SMPS_CONTROL_DISABLED:
 		default: /* shouldn't happen since we don't send that */
-			sta->sdata->u.mgd.ap_smps = IEEE80211_SMPS_OFF;
+			sdata->smps_mode = IEEE80211_SMPS_OFF;
 			break;
 		}
 
-		ieee80211_queue_work(&local->hw, &local->recalc_smps);
+		ieee80211_queue_work(&local->hw, &sdata->recalc_smps);
 	}
 }
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a3f5fe2..6293647 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -29,11 +29,16 @@
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 
 #define CHANCTX_ENTRY	__field(int, freq)					\
-			__field(int, chantype)
+			__field(int, chantype)					\
+			__field(u8, rx_chains_static)				\
+			__field(u8, rx_chains_dynamic)
 #define CHANCTX_ASSIGN	__entry->freq = ctx->conf.channel->center_freq;		\
-			__entry->chantype = ctx->conf.channel_type
-#define CHANCTX_PR_FMT	" freq:%d MHz chantype:%d"
-#define CHANCTX_PR_ARG	__entry->freq, __entry->chantype
+			__entry->chantype = ctx->conf.channel_type;		\
+			__entry->rx_chains_static = ctx->conf.rx_chains_static;	\
+			__entry->rx_chains_dynamic = ctx->conf.rx_chains_dynamic
+#define CHANCTX_PR_FMT	" freq:%d MHz chantype:%d chains:%d/%d"
+#define CHANCTX_PR_ARG	__entry->freq, __entry->chantype,			\
+			__entry->rx_chains_static, __entry->rx_chains_dynamic
 
 
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9dde8db..d2b38d5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1615,68 +1615,24 @@ void ieee80211_resume_disconnect(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL_GPL(ieee80211_resume_disconnect);
 
-static int check_mgd_smps(struct ieee80211_if_managed *ifmgd,
-			  enum ieee80211_smps_mode *smps_mode)
+void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata)
 {
-	if (ifmgd->associated) {
-		*smps_mode = ifmgd->ap_smps;
-
-		if (*smps_mode == IEEE80211_SMPS_AUTOMATIC) {
-			if (ifmgd->powersave)
-				*smps_mode = IEEE80211_SMPS_DYNAMIC;
-			else
-				*smps_mode = IEEE80211_SMPS_OFF;
-		}
-
-		return 1;
-	}
-
-	return 0;
-}
-
-void ieee80211_recalc_smps(struct ieee80211_local *local)
-{
-	struct ieee80211_sub_if_data *sdata;
-	enum ieee80211_smps_mode smps_mode = IEEE80211_SMPS_OFF;
-	int count = 0;
-
-	mutex_lock(&local->iflist_mtx);
-
-	/*
-	 * This function could be improved to handle multiple
-	 * interfaces better, but right now it makes any
-	 * non-station interfaces force SM PS to be turned
-	 * off. If there are multiple station interfaces it
-	 * could also use the best possible mode, e.g. if
-	 * one is in static and the other in dynamic then
-	 * dynamic is ok.
-	 */
-
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-		if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE)
-			continue;
-		if (sdata->vif.type != NL80211_IFTYPE_STATION)
-			goto set;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx *chanctx;
 
-		count += check_mgd_smps(&sdata->u.mgd, &smps_mode);
+	mutex_lock(&local->chanctx_mtx);
 
-		if (count > 1) {
-			smps_mode = IEEE80211_SMPS_OFF;
-			break;
-		}
-	}
+	chanctx_conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					lockdep_is_held(&local->chanctx_mtx));
 
-	if (smps_mode == local->smps_mode)
+	if (WARN_ON_ONCE(!chanctx_conf))
 		goto unlock;
 
- set:
-	local->smps_mode = smps_mode;
-	/* changed flag is auto-detected for this */
-	ieee80211_hw_config(local, 0);
+	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
+	ieee80211_recalc_smps_chanctx(local, chanctx);
  unlock:
-	mutex_unlock(&local->iflist_mtx);
+	mutex_unlock(&local->chanctx_mtx);
 }
 
 static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
@@ -1975,3 +1931,19 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
 	return ifmgd->ave_beacon_signal;
 }
 EXPORT_SYMBOL_GPL(ieee80211_ave_rssi);
+
+u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs)
+{
+	if (!mcs)
+		return 1;
+
+	/* TODO: consider rx_highest */
+
+	if (mcs->rx_mask[3])
+		return 4;
+	if (mcs->rx_mask[2])
+		return 3;
+	if (mcs->rx_mask[1])
+		return 2;
+	return 1;
+}
-- 
1.7.10.4

