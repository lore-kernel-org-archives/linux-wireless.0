Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:60478 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946752Ab3BHRQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:16:47 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv10 2/2] mac80211: add radar detection command/event
Date: Fri,  8 Feb 2013 18:16:20 +0100
Message-Id: <1360343782-32149-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130208_182235_460238_BD22D835)
In-Reply-To: <1360343782-32149-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1360343782-32149-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to trigger radar detection in the driver/FW.
Once radar detection is started it should continuously
monitor for radars as long as the channel active.
If radar is detected usermode notified with 'radar
detected' event.

Scanning and remain on channel functionality must be disabled
while doing radar detection/scanning, and vice versa.

based on original patch by Victor Goldenshtein <victorg@ti.com>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
Changes to PATCHv9:
 * forbid DFS for channel context drivers for now
 * remove iflist_mtx locking (Johannes found a better solution)
 * abort cac when going into suspend

Changes to PATCHv8:
 * change from vif-interface to hw interface for radar detection
   reporting
 * fix join_mesh (added radar required there by accident ...)
 * add work queue for radar events
 * change driver interface to report radar per hw, not per vif
 * change to splitted radar/cac event reporting
 * protect release_channel calls with local->iflist_mtx

Changes to PATCHv7:

 * remove typo in mac80211.h (Zefir)
 * remove comment about weather channels
 * add break in ieee80211_recalc_radar_chanctx()
 * reword comment in ieee80211_radar_detected() about virgin interfaces
 * remove cfg80211_chandef_dfs_required dependency

Changes to PATCHv6:
 * squash "check radar interaction with scan and roc" patch
 * add radar detection flag to chanctx conf
 * remove mac80211 radar detection command for drivers
 * remove trace.h chandef macros and drv_start_radar_detection command
 * use chandef in radar_detected_notification, remove channel argument
   (mac80211 already knows it)
 * add timer for channel availability check notification to cfg80211
 * add vif channel release
 * check for dfs required using cfg80211 function

Changes to PATCHv5:
 * use local instead of sdata->local
 * change API to chandef

mac80211: lock AP_VLAN list with iflist_mtx

To remove the dependency to rtnl_lock() for
ieee80211_vif_use/release_channel in AP mode, protect the AP_VLAN
list with local->iflist_mtx instead.

RTNL can not be used from within mac80211 work structs, but the
DFS AP interface requires to release channels (after DFS channel
availability checks).

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/mac80211.h     |   14 +++++++++++
 net/mac80211/cfg.c         |   40 +++++++++++++++++++++++++++++-
 net/mac80211/chan.c        |   33 +++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |   14 +++++++++++
 net/mac80211/iface.c       |   12 +++++++++
 net/mac80211/main.c        |    7 ++++++
 net/mac80211/mlme.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/pm.c          |    2 ++
 net/mac80211/scan.c        |    3 +++
 net/mac80211/trace.h       |   19 ++++++++++++++
 10 files changed, 202 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5c98d65..9bd877a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -147,10 +147,12 @@ struct ieee80211_low_level_stats {
  * enum ieee80211_chanctx_change - change flag for channel context
  * @IEEE80211_CHANCTX_CHANGE_WIDTH: The channel width changed
  * @IEEE80211_CHANCTX_CHANGE_RX_CHAINS: The number of RX chains changed
+ * @IEEE80211_CHANCTX_CHANGE_RADAR: radar detection flag changed
  */
 enum ieee80211_chanctx_change {
 	IEEE80211_CHANCTX_CHANGE_WIDTH		= BIT(0),
 	IEEE80211_CHANCTX_CHANGE_RX_CHAINS	= BIT(1),
+	IEEE80211_CHANCTX_CHANGE_RADAR		= BIT(2),
 };
 
 /**
@@ -165,6 +167,7 @@ enum ieee80211_chanctx_change {
  * @rx_chains_dynamic: The number of RX chains that must be enabled
  *	after RTS/CTS handshake to receive SMPS MIMO transmissions;
  *	this will always be >= @rx_chains_static.
+ * @radar_enabled: whether radar detection is enabled on this channel.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  */
@@ -173,6 +176,8 @@ struct ieee80211_chanctx_conf {
 
 	u8 rx_chains_static, rx_chains_dynamic;
 
+	bool radar_enabled;
+
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
 
@@ -950,6 +955,7 @@ enum ieee80211_smps_mode {
  *
  * @channel: the channel to tune to
  * @channel_type: the channel (HT) type
+ * @radar_enabled: whether radar detection is enabled
  *
  * @long_frame_max_tx_count: Maximum number of transmissions for a "long" frame
  *    (a frame not RTS protected), called "dot11LongRetryLimit" in 802.11,
@@ -976,6 +982,7 @@ struct ieee80211_conf {
 
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type;
+	bool radar_enabled;
 	enum ieee80211_smps_mode smps_mode;
 };
 
@@ -3953,6 +3960,13 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       gfp_t gfp);
 
 /**
+ * ieee80211_radar_detected - inform that a radar was detected
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ */
+void ieee80211_radar_detected(struct ieee80211_hw *hw);
+
+/**
  * ieee80211_chswitch_done - Complete channel switch process
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @success: make the channel switch successful or not
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a232a18..9997641 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -922,6 +922,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	/* TODO: make hostapd tell us what it wants */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
+	sdata->radar_required = params->radar_required;
 
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
@@ -2370,7 +2371,9 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	INIT_LIST_HEAD(&roc->dependents);
 
 	/* if there's one pending or we're scanning, queue this one */
-	if (!list_empty(&local->roc_list) || local->scanning)
+	if (!list_empty(&local->roc_list) ||
+	    local->scanning ||
+	    local->radar_detect_enabled)
 		goto out_check_combine;
 
 	/* if not HW assist, just queue & schedule work */
@@ -2620,6 +2623,40 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ieee80211_cancel_roc(local, cookie, false);
 }
 
+static int ieee80211_start_radar_detection(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	unsigned long timeout;
+	int err;
+
+	if (!(wiphy->flags & WIPHY_FLAG_HAS_RADAR_DETECT))
+		return -ENOTSUPP;
+
+	if (!list_empty(&local->roc_list) || local->scanning)
+		return -EBUSY;
+
+	/* whatever, but channel contexts should not complain about that one */
+	sdata->smps_mode = IEEE80211_SMPS_OFF;
+	sdata->needed_rx_chains = local->rx_chains;
+	sdata->radar_required = true;
+
+	mutex_lock(&local->iflist_mtx);
+	err = ieee80211_vif_use_channel(sdata, chandef,
+					IEEE80211_CHANCTX_SHARED);
+	mutex_unlock(&local->iflist_mtx);
+	if (err)
+		return err;
+
+	timeout = msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
+	ieee80211_queue_delayed_work(&sdata->local->hw,
+				     &sdata->dfs_cac_timer_work, timeout);
+
+	return 0;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     unsigned int wait, const u8 *buf, size_t len,
@@ -3324,4 +3361,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_stats = ieee80211_get_et_stats,
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
+	.start_radar_detection = ieee80211_start_radar_detection,
 };
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index b5b5076..da48aa6 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -180,6 +180,7 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	if (ctx->refcount > 0) {
 		ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
 		ieee80211_recalc_smps_chanctx(local, ctx);
+		ieee80211_recalc_radar_chanctx(local, ctx);
 	}
 }
 
@@ -203,6 +204,37 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 		ieee80211_free_chanctx(local, ctx);
 }
 
+void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
+				    struct ieee80211_chanctx *chanctx)
+{
+	struct ieee80211_sub_if_data *sdata;
+	bool radar_enabled = false;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->radar_required) {
+			radar_enabled = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	if (radar_enabled == chanctx->conf.radar_enabled)
+		return;
+
+	chanctx->conf.radar_enabled = radar_enabled;
+	local->radar_detect_enabled = chanctx->conf.radar_enabled;
+
+	if (!local->use_chanctx) {
+		local->hw.conf.radar_enabled = chanctx->conf.radar_enabled;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	}
+
+	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RADAR);
+}
+
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx)
 {
@@ -318,6 +350,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ieee80211_recalc_smps_chanctx(local, ctx);
+	ieee80211_recalc_radar_chanctx(local, ctx);
  out:
 	mutex_unlock(&local->chanctx_mtx);
 	return ret;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index efe2d23..9ca23dc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -753,6 +753,9 @@ struct ieee80211_sub_if_data {
 	int user_power_level; /* in dBm */
 	int ap_power_level; /* in dBm */
 
+	bool radar_required;
+	struct delayed_work dfs_cac_timer_work;
+
 	/*
 	 * AP this belongs to: self in AP mode and
 	 * corresponding AP in VLAN mode, NULL for
@@ -972,6 +975,10 @@ struct ieee80211_local {
 	/* wowlan is enabled -- don't reconfig on resume */
 	bool wowlan;
 
+	/* DFS/radar detection is enabled */
+	bool radar_detect_enabled;
+	struct work_struct radar_detected_work;
+
 	/* number of RX chains the hardware has */
 	u8 rx_chains;
 
@@ -1641,6 +1648,13 @@ void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
+void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
+				    struct ieee80211_chanctx *chanctx);
+
+void ieee80211_dfs_cac_timer(unsigned long data);
+void ieee80211_dfs_cac_timer_work(struct work_struct *work);
+void ieee80211_dfs_cac_cancel(struct ieee80211_local *local);
+void ieee80211_dfs_radar_detected_work(struct work_struct *work);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0a36dc6..973d302 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -817,6 +817,16 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	cancel_work_sync(&sdata->recalc_smps);
 
+	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
+
+	if (sdata->wdev.cac_started) {
+		mutex_lock(&local->iflist_mtx);
+		ieee80211_vif_release_channel(sdata);
+		mutex_unlock(&local->iflist_mtx);
+		cfg80211_cac_event(sdata->dev, NL80211_RADAR_CAC_ABORTED,
+				   GFP_KERNEL);
+	}
+
 	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
@@ -1583,6 +1593,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	spin_lock_init(&sdata->cleanup_stations_lock);
 	INIT_LIST_HEAD(&sdata->cleanup_stations);
 	INIT_WORK(&sdata->cleanup_stations_wk, ieee80211_cleanup_sdata_stas_wk);
+	INIT_DELAYED_WORK(&sdata->dfs_cac_timer_work,
+			  ieee80211_dfs_cac_timer_work);
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2bdd454..a7b6768 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -632,6 +632,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	INIT_WORK(&local->restart_work, ieee80211_restart_work);
 
+	INIT_WORK(&local->radar_detected_work,
+		  ieee80211_dfs_radar_detected_work);
+
 	INIT_WORK(&local->reconfig_filter, ieee80211_reconfig_filter);
 	local->smps_mode = IEEE80211_SMPS_OFF;
 
@@ -727,6 +730,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		 */
 		if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_WDS))
 			return -EINVAL;
+
+		/* DFS currently not supported with channel context drivers */
+		if (local->hw.wiphy->flags & WIPHY_FLAG_HAS_RADAR_DETECT)
+			return -EINVAL;
 	}
 
 	/* Only HW csum features are currently compatible with mac80211 */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5913fb9..b45eaff 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1244,6 +1244,19 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 	ieee80211_queue_work(&local->hw, &local->dynamic_ps_enable_work);
 }
 
+void ieee80211_dfs_cac_timer_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work =
+		container_of(work, struct delayed_work, work);
+	struct ieee80211_sub_if_data *sdata =
+		container_of(delayed_work, struct ieee80211_sub_if_data,
+			     dfs_cac_timer_work);
+
+	ieee80211_vif_release_channel(sdata);
+
+	cfg80211_cac_event(sdata->dev, NL80211_RADAR_CAC_FINISHED, GFP_KERNEL);
+}
+
 /* MLME */
 static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
@@ -4117,3 +4130,49 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, gfp);
 }
 EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
+
+void ieee80211_dfs_cac_cancel(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
+
+		if (sdata->wdev.cac_started) {
+			ieee80211_vif_release_channel(sdata);
+			cfg80211_cac_event(sdata->dev,
+					   NL80211_RADAR_CAC_ABORTED,
+					   GFP_KERNEL);
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+}
+
+void ieee80211_dfs_radar_detected_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, radar_detected_work);
+	struct cfg80211_chan_def chandef;
+
+	ieee80211_cac_cancel(local);
+
+	if (local->use_chanctx)
+		/* currently not handled */
+		WARN_ON(1);
+	else {
+		cfg80211_chandef_create(&chandef, local->hw.conf.channel,
+					local->hw.conf.channel_type);
+		cfg80211_radar_event(local->hw.wiphy, &chandef, GFP_KERNEL);
+	}
+}
+
+void ieee80211_radar_detected(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	trace_api_radar_detected(local);
+
+	ieee80211_queue_work(hw, &local->radar_detected_work);
+}
+EXPORT_SYMBOL(ieee80211_radar_detected);
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index e45b836..89ccf3b 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -38,6 +38,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	ieee80211_scan_cancel(local);
 
+	ieee80211_dfs_cac_cancel(local);
+
 	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
 		mutex_lock(&local->sta_mtx);
 		list_for_each_entry(sta, &local->sta_list, list) {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 607684c..100ab2d 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -356,6 +356,9 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 static bool ieee80211_can_scan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
+	if (local->radar_detect_enabled)
+		return false;
+
 	if (!list_empty(&local->roc_list))
 		return false;
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 6ca53d6..c5f5dbe 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1860,6 +1860,25 @@ TRACE_EVENT(drv_set_default_unicast_key,
 		  LOCAL_PR_ARG, VIF_PR_ARG, __entry->key_idx)
 );
 
+TRACE_EVENT(api_radar_detected,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " radar detected",
+		LOCAL_PR_ARG
+	)
+);
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
-- 
1.7.10.4

