Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:39787 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaBCKD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 05:03:57 -0500
Received: by mail-ea0-f169.google.com with SMTP id h10so3646915eak.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 02:03:55 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
Date: Mon,  3 Feb 2014 10:58:49 +0100
Message-Id: <1391421529-6067-3-git-send-email-michal.kazior@tieto.com> (sfid-20140203_110400_931504_F5D107E3)
In-Reply-To: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This introduces the following benefits:
 * cfg80211 is now aware of channel switching
   (although more work still needs to be done wrt
    interface combinations & multi-interface CSA)
 * fixes some channel switching failcases by
   disconnecting offending interfaces
 * STA CSA no longer modifies BSS channel from
   within mac80211

This aims to make the following possible later:
 * defer channel switching decision to userspace
   (if desired so),
 * inform userspace what interfaces will be
   possibly disconnected by a channel switch,
 * disconnect non-complying interfaces that were
   sharing a channel that is being abandoned by
   channel switching interface(s),
 * take channel switching into account in
   interface combination checks.

Channel switching processing is deferred to a
event_list/work for locking reasons to provide
safe interface list iteration for future interface
combination checks. The downside is if a driver
misbehaves in ch_switch_start/finalize callbacks
it might stall the whole networking subsystem.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h  |  75 ++++++++++++++++++++--
 net/mac80211/cfg.c      |  50 +++++----------
 net/mac80211/ibss.c     |   5 +-
 net/mac80211/mesh.c     |   9 ++-
 net/mac80211/mlme.c     |   5 +-
 net/wireless/ap.c       |   5 +-
 net/wireless/chan.c     | 163 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.c     |  23 ++++---
 net/wireless/core.h     |  18 ++++++
 net/wireless/ibss.c     |   1 +
 net/wireless/mesh.c     |   5 +-
 net/wireless/nl80211.c  |  20 ++++--
 net/wireless/rdev-ops.h |  21 +++++--
 net/wireless/sme.c      |   1 +
 net/wireless/trace.h    |  17 ++++-
 net/wireless/util.c     |   6 ++
 16 files changed, 352 insertions(+), 72 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f6651a2..b4ea9d0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2273,7 +2273,18 @@ struct cfg80211_qos_map {
  *	reliability. This operation can not fail.
  * @set_coalesce: Set coalesce parameters.
  *
- * @channel_switch: initiate channel-switch procedure (with CSA)
+ * @ch_switch_start: initiate channel-switch procedure (with CSA). This should
+ *	prompt the driver to perform preparation work (start some timers,
+ *	include CS IEs in beacons, etc) but don't do an actual channel switch.
+ *	Once driver has completed all preparations and is ready for the actual
+ *	switch (after CSA counter is completed) it must call
+ *	cfg80211_ch_switch_complete(wdev). After that ch_switch_finalize() MAY
+ *	be called, but it doesn't necessarily happen immediately as cfg80211
+ *	may need to synchronize with other interfaces. If channel switch is
+ *	cancelled for some reason ch_switch_finalize() is not called and driver
+ *	should free up resources/cleanup state in interface disconnection flow.
+ * @ch_switch_finalize: finalize channel-switch procedure, i.e. perform the
+ *	actual switch.
  *
  * @set_qos_map: Set QoS mapping information to the driver
  */
@@ -2514,9 +2525,12 @@ struct cfg80211_ops {
 	int	(*set_coalesce)(struct wiphy *wiphy,
 				struct cfg80211_coalesce *coalesce);
 
-	int	(*channel_switch)(struct wiphy *wiphy,
-				  struct net_device *dev,
-				  struct cfg80211_csa_settings *params);
+	int	(*ch_switch_start)(struct wiphy *wiphy,
+				   struct net_device *dev,
+				   struct cfg80211_csa_settings *params);
+	int	(*ch_switch_finalize)(struct wiphy *wiphy,
+				      struct net_device *dev);
+
 	int     (*set_qos_map)(struct wiphy *wiphy,
 			       struct net_device *dev,
 			       struct cfg80211_qos_map *qos_map);
@@ -2775,6 +2789,26 @@ struct wiphy_vendor_command {
 };
 
 /**
+ * enum cfg80211_chsw_state - interface channel switch state
+ *
+ * @CHSW_STATE_NONE: channel switch is not active
+ * @CHSW_STATE_REQUESTED: channel switch has been requested but not processed
+ * @CHSW_STATE_STARTED: channel switch has been processed and accepted
+ * @CHSW_STATE_COMPLETED: channel switch has been scheduled for finalization
+ * @CHSW_STATE_SYNCING: interface is ready for channel to be re-programmed in
+ *	driver. Interface may remain in this state until some additional
+ *	requirements are met, i.e. wait until other channel switch requests on other
+ *	interfaces are synching as well.
+ */
+enum cfg80211_chsw_state {
+	CHSW_STATE_NONE,
+	CHSW_STATE_REQUESTED,
+	CHSW_STATE_STARTED,
+	CHSW_STATE_COMPLETED,
+	CHSW_STATE_SYNCING,
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
@@ -3233,6 +3267,9 @@ struct wireless_dev {
 	bool cac_started;
 	unsigned long cac_start_time;
 
+	enum cfg80211_chsw_state chsw_state;
+	struct cfg80211_chan_def chsw_chandef;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
@@ -4672,6 +4709,36 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
  */
 unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
 
+/**
+ * cfg80211_ch_switch_request - request a channel switch
+ *
+ * If the request is accepted start_channel_switch() driver callback is called.
+ * Otherwise interface is stopped/disconnected.
+ *
+ * This is a generic channel switch callback and can be used with any interface
+ * type.
+ *
+ * @wdev: the wireless device to schedule channel switch on
+ * @params: channel switch parameters
+ *
+ * Return: less than zero on failure
+ */
+int cfg80211_ch_switch_request(struct wireless_dev *wdev,
+			       struct cfg80211_csa_settings *params);
+
+/**
+ * cfg80211_ch_switch_complete - notify cfg80211 that channel switch is ready
+ *
+ * Driver must call this after CSA beacon counter has been completed and is
+ * ready to switch channel. It must not switch the channel until it is asked to
+ * by ch_switch_finalize() op is called.
+ *
+ * @wdev: the wireless device to schedule channel switch on
+ *
+ * Return: less than zero on failure
+ */
+int cfg80211_ch_switch_complete(struct wireless_dev *wdev);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dff4d3a..6ccfc81 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3000,8 +3000,10 @@ void ieee80211_csa_finish(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(ieee80211_csa_finish);
 
-static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_ch_switch_finalize(struct wiphy *wiphy,
+					struct net_device *dev)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	int err, changed = 0;
@@ -3034,9 +3036,6 @@ static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
-		/* XXX: shouldn't really modify cfg80211-owned data! */
-		ifmgd->associated->channel = sdata->csa_chandef.chan;
-
 		ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 		break;
 	case NL80211_IFTYPE_AP:
@@ -3075,34 +3074,14 @@ static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
-
 	return 0;
 }
 
-void ieee80211_csa_disconnect(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_P2P_CLIENT:
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		break;
-	default:
-		/* XXX: other iftypes should be halted too */
-		break;
-	}
-}
-
 void ieee80211_csa_finalize_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
 			     csa_finalize_work);
-	int err;
 
 	sdata_lock(sdata);
 	/* AP might have been stopped while waiting for the lock. */
@@ -3112,16 +3091,14 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		goto unlock;
 
-	err = ieee80211_csa_finalize(sdata);
-	if (err)
-		ieee80211_csa_disconnect(sdata);
+	cfg80211_ch_switch_complete(&sdata->wdev);
 
 unlock:
 	sdata_unlock(sdata);
 }
 
-int __ieee80211_channel_switch(struct ieee80211_sub_if_data *sdata,
-			       struct cfg80211_csa_settings *params)
+static int __ieee80211_ch_switch_start(struct ieee80211_sub_if_data *sdata,
+				       struct cfg80211_csa_settings *params)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
@@ -3306,14 +3283,18 @@ int __ieee80211_channel_switch(struct ieee80211_sub_if_data *sdata,
 		ieee80211_bss_info_change_notify(sdata, changed);
 		drv_channel_switch_beacon(sdata, &params->chandef);
 	} else {
-		/* if the beacon didn't change, we can finalize immediately */
-		ieee80211_csa_finalize(sdata);
+		/* If the beacon didn't change, we can finalize immediately.
+		 *
+		 * Can't call cfg80211_ch_switch_complete() directly since
+		 * we're in cfg80211 callback that touches chsw state */
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->csa_finalize_work);
 	}
 
 	return 0;
 }
 
-static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+static int ieee80211_ch_switch_start(struct wiphy *wiphy, struct net_device *dev,
 				    struct cfg80211_csa_settings *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -3321,7 +3302,7 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	int err;
 
 	mutex_lock(&local->chanctx_mtx);
-	err = __ieee80211_channel_switch(sdata, params);
+	err = __ieee80211_ch_switch_start(sdata, params);
 	mutex_unlock(&local->chanctx_mtx);
 
 	return err;
@@ -4071,6 +4052,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
-	.channel_switch = ieee80211_channel_switch,
+	.ch_switch_start = ieee80211_ch_switch_start,
+	.ch_switch_finalize = ieee80211_ch_switch_finalize,
 	.set_qos_map = ieee80211_set_qos_map,
 };
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a86e278..ae71e76 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -896,10 +896,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	params.block_tx = !!csa_ie.mode;
 
-	mutex_lock(&sdata->local->chanctx_mtx);
-	err = __ieee80211_channel_switch(sdata, &params);
-	mutex_unlock(&sdata->local->chanctx_mtx);
-
+	err = cfg80211_ch_switch_request(&sdata->wdev, &params);
 	if (err < 0)
 		goto disconnect;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 43dc808..ffa00e2 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -936,12 +936,11 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 
 	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_REPEATER;
 
-	mutex_lock(&sdata->local->chanctx_mtx);
-	err = __ieee80211_channel_switch(sdata, &params);
-	mutex_unlock(&sdata->local->chanctx_mtx);
-
-	if (err < 0)
+	err = cfg80211_ch_switch_request(&sdata->wdev, &params);
+	if (err < 0) {
+		/* XXX: should disconnect? */
 		return false;
+	}
 
 	return true;
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3aaf2f2..d4d7c23 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -966,10 +966,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	params.timestamp = timestamp;
 	params.count = csa_ie.count;
 
-	mutex_lock(&local->chanctx_mtx);
-	res = __ieee80211_channel_switch(sdata, &params);
-	mutex_unlock(&local->chanctx_mtx);
-
+	res = cfg80211_ch_switch_request(&sdata->wdev, &params);
 	if (res) {
 		sdata_info(sdata, "channel switch failed: %d, disconnecting",
 			   res);
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 4760d65..f0b2f37 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -6,8 +6,8 @@
 #include "rdev-ops.h"
 
 
-static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
-			      struct net_device *dev)
+int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
@@ -29,6 +29,7 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		wdev->beacon_interval = 0;
 		wdev->channel = NULL;
 		wdev->ssid_len = 0;
+		wdev->chsw_state = CHSW_STATE_NONE;
 		rdev_set_qos_map(rdev, dev, NULL);
 		nl80211_send_ap_stopped(wdev);
 	}
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..d6903c0 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -704,3 +704,166 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 
 	return;
 }
+
+void __cfg80211_ch_switch_request(struct wireless_dev *wdev,
+				  struct cfg80211_csa_settings *params)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct wireless_dev *wdev_iter;
+	int err;
+
+	ASSERT_RTNL();
+	ASSERT_WDEV_LOCK(wdev);
+
+	/* XXX: prevent multi-interface channel switching until cfg80211 can be
+	 * smart about it */
+	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
+		if (!wdev_iter->netdev)
+			continue;
+
+		if (wdev_iter == wdev)
+			continue;
+
+		/*
+		 * We are holding the "wdev" mutex, but now need to lock
+		 * wdev_iter. This is OK because once we get here wdev_iter
+		 * is not wdev (tested above), but we need to use the nested
+		 * locking for lockdep.
+		 */
+		mutex_lock_nested(&wdev_iter->mtx, 1);
+		__acquire(wdev_iter->mtx);
+		if (wdev_iter->chsw_state != CHSW_STATE_NONE) {
+			pr_warn("%s: another interface already is switching channel, disconnecting\n",
+				wdev->netdev->name);
+			__cfg80211_leave(rdev, wdev);
+			wdev_unlock(wdev_iter);
+			return;
+		}
+		wdev_unlock(wdev_iter);
+	}
+
+	if (WARN_ON(wdev->chsw_state != CHSW_STATE_REQUESTED)) {
+		__cfg80211_leave(rdev, wdev);
+		return;
+	}
+
+	/* XXX: once interface combinations are aware of channel switching
+	 * check if this channel switch request fits - or it will fit once
+	 * channel switch is completed - in any supported combination */
+
+	/* XXX: could notify userspace about channel switch being scheduled and
+	 * possibly hint what interfaces might be disconnected if they don't
+	 * switch as well */
+
+	err = rdev_ch_switch_start(rdev, wdev->netdev, params);
+	if (err) {
+		pr_warn("%s: driver failed to start channel switch (err = %d), disconnecting\n",
+			wdev->netdev->name, err);
+		__cfg80211_leave(rdev, wdev);
+		return;
+	}
+
+	wdev->chsw_state = CHSW_STATE_STARTED;
+	wdev->chsw_chandef = params->chandef;
+}
+
+int cfg80211_ch_switch_request(struct wireless_dev *wdev,
+			       struct cfg80211_csa_settings *params)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (wdev->chsw_state != CHSW_STATE_NONE)
+		return -EALREADY;
+
+	wdev->chsw_chandef = params->chandef;
+	wdev->chsw_state = CHSW_STATE_REQUESTED;
+
+	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
+	if (!ev)
+		return -ENOMEM;
+
+	ev->type = EVENT_CH_SWITCH_REQUESTED;
+	ev->csa = *params;
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	list_add_tail(&ev->list, &wdev->event_list);
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+	queue_work(cfg80211_wq, &rdev->event_work);
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_ch_switch_request);
+
+void __cfg80211_ch_switch_complete(struct wireless_dev *wdev)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	int err;
+
+	ASSERT_RTNL();
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (WARN_ON(wdev->chsw_state != CHSW_STATE_COMPLETED)) {
+		__cfg80211_leave(rdev, wdev);
+		return;
+	}
+
+	wdev->chsw_state = CHSW_STATE_SYNCING;
+
+	/* XXX: Should wait for other interfaces that are channel switching as
+	 * well to make the best of interface combinations, e.g. if
+	 * multi-channel is supported then waiting for other interfaces may not
+	 * be necessary. */
+
+	/* XXX: Interfaces that didn't comply (i.e. weren't scheduled to switch
+	 * channel and use the same channel as interfaces that completed
+	 * channel switch) should be stopped/disconnected here */
+
+	err = rdev_ch_switch_finalize(rdev, wdev->netdev);
+	if (err < 0) {
+		pr_warn("%s: driver failed to finalize channel (err = %d), disconnecting\n",
+			wdev->netdev->name, err);
+		__cfg80211_leave(rdev, wdev);
+		return;
+	}
+
+	cfg80211_ch_switch_notify(wdev->netdev, &wdev->chsw_chandef);
+	wdev->chsw_state = CHSW_STATE_NONE;
+
+	if (wdev->iftype == NL80211_IFTYPE_STATION ||
+	    wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) {
+		if (wdev->current_bss)
+			wdev->current_bss->pub.channel = wdev->chsw_chandef.chan;
+	}
+}
+
+int cfg80211_ch_switch_complete(struct wireless_dev *wdev)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (WARN_ON(wdev->chsw_state != CHSW_STATE_STARTED))
+		return -EINVAL;
+
+	wdev->chsw_state = CHSW_STATE_COMPLETED;
+
+	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
+	if (!ev)
+		return -ENOMEM;
+
+	ev->type = EVENT_CH_SWITCH_COMPLETED;
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	list_add_tail(&ev->list, &wdev->event_list);
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+	queue_work(cfg80211_wq, &rdev->event_work);
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_ch_switch_complete);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index b5ff39a..b622312 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -751,23 +751,23 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 		rdev->num_running_monitor_ifaces += num;
 }
 
-void cfg80211_leave(struct cfg80211_registered_device *rdev,
-		    struct wireless_dev *wdev)
+void __cfg80211_leave(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev)
 {
 	struct net_device *dev = wdev->netdev;
 
 	ASSERT_RTNL();
+	ASSERT_WDEV_LOCK(wdev);
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_ADHOC:
-		cfg80211_leave_ibss(rdev, dev, true);
+		__cfg80211_leave_ibss(rdev, dev, true);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
 		if (rdev->sched_scan_req && dev == rdev->sched_scan_req->dev)
 			__cfg80211_stop_sched_scan(rdev, false);
 
-		wdev_lock(wdev);
 #ifdef CONFIG_CFG80211_WEXT
 		kfree(wdev->wext.ie);
 		wdev->wext.ie = NULL;
@@ -776,14 +776,13 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 #endif
 		cfg80211_disconnect(rdev, dev,
 				    WLAN_REASON_DEAUTH_LEAVING, true);
-		wdev_unlock(wdev);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		cfg80211_leave_mesh(rdev, dev);
+		__cfg80211_leave_mesh(rdev, dev);
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		cfg80211_stop_ap(rdev, dev);
+		__cfg80211_stop_ap(rdev, dev);
 		break;
 	default:
 		break;
@@ -792,6 +791,16 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 	wdev->beacon_interval = 0;
 }
 
+void cfg80211_leave(struct cfg80211_registered_device *rdev,
+		    struct wireless_dev *wdev)
+{
+	ASSERT_RTNL();
+
+	wdev_lock(wdev);
+	__cfg80211_leave(rdev, wdev);
+	wdev_unlock(wdev);
+}
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state, void *ptr)
 {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 37ec16d..4c8fb5d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -181,6 +181,8 @@ enum cfg80211_event_type {
 	EVENT_ROAMED,
 	EVENT_DISCONNECTED,
 	EVENT_IBSS_JOINED,
+	EVENT_CH_SWITCH_REQUESTED,
+	EVENT_CH_SWITCH_COMPLETED,
 };
 
 struct cfg80211_event {
@@ -211,6 +213,7 @@ struct cfg80211_event {
 		struct {
 			u8 bssid[ETH_ALEN];
 		} ij;
+		struct cfg80211_csa_settings csa;
 	};
 };
 
@@ -272,6 +275,8 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
 		       struct mesh_setup *setup,
 		       const struct mesh_config *conf);
+int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev);
 int cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 			struct net_device *dev);
 int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
@@ -279,6 +284,8 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 			      struct cfg80211_chan_def *chandef);
 
 /* AP */
+int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev);
 int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev);
 
@@ -372,6 +379,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 
+void __cfg80211_chswitch_request(struct wireless_dev *wdev,
+				 struct cfg80211_csa_settings *params);
+
 int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 struct wireless_dev *wdev,
 				 enum nl80211_iftype iftype,
@@ -456,12 +466,20 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
+void __cfg80211_leave(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev);
+
 void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		    struct wireless_dev *wdev);
 
 void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
 
+void __cfg80211_ch_switch_request(struct wireless_dev *wdev,
+				  struct cfg80211_csa_settings *params);
+
+void __cfg80211_ch_switch_complete(struct wireless_dev *wdev);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index f911c5f..a4130e5 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -198,6 +198,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
 	}
 
+	wdev->chsw_state = CHSW_STATE_NONE;
 	wdev->current_bss = NULL;
 	wdev->ssid_len = 0;
 #ifdef CONFIG_CFG80211_WEXT
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 8858624..f7792df 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -256,8 +256,8 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
-				 struct net_device *dev)
+int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
@@ -277,6 +277,7 @@ static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 	if (!err) {
 		wdev->mesh_id_len = 0;
 		wdev->channel = NULL;
+		wdev->chsw_state = CHSW_STATE_NONE;
 		rdev_set_qos_map(rdev, dev, NULL);
 	}
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 28ab3a9..989951b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1471,7 +1471,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			CMD(crit_proto_start, CRIT_PROTOCOL_START);
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
 			if (dev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
-				CMD(channel_switch, CHANNEL_SWITCH);
+				CMD(ch_switch_start, CHANNEL_SWITCH);
 		}
 		CMD(set_qos_map, SET_QOS_MAP);
 
@@ -5846,7 +5846,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	int err;
 	bool need_new_beacon = false;
 
-	if (!rdev->ops->channel_switch ||
+	if (!rdev->ops->ch_switch_start ||
 	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
 		return -EOPNOTSUPP;
 
@@ -5957,9 +5957,21 @@ skip_beacons:
 		params.block_tx = true;
 
 	wdev_lock(wdev);
-	err = rdev_channel_switch(rdev, dev, &params);
-	wdev_unlock(wdev);
 
+	if (wdev->chsw_state != CHSW_STATE_NONE) {
+		err = -EALREADY;
+		goto unlock;
+	}
+
+	err = rdev_ch_switch_start(rdev, dev, &params);
+	if (err)
+		goto unlock;
+
+	wdev->chsw_state = CHSW_STATE_STARTED;
+	wdev->chsw_chandef = params.chandef;
+
+unlock:
+	wdev_unlock(wdev);
 	return err;
 }
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index c8e2259..780de5e 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -920,14 +920,25 @@ static inline void rdev_crit_proto_stop(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
-static inline int rdev_channel_switch(struct cfg80211_registered_device *rdev,
-				      struct net_device *dev,
-				      struct cfg80211_csa_settings *params)
+static inline int rdev_ch_switch_start(struct cfg80211_registered_device *rdev,
+				       struct net_device *dev,
+				       struct cfg80211_csa_settings *params)
+{
+	int ret;
+
+	trace_rdev_ch_switch_start(&rdev->wiphy, dev, params);
+	ret = rdev->ops->ch_switch_start(&rdev->wiphy, dev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int rdev_ch_switch_finalize(struct cfg80211_registered_device *rdev,
+					  struct net_device *dev)
 {
 	int ret;
 
-	trace_rdev_channel_switch(&rdev->wiphy, dev, params);
-	ret = rdev->ops->channel_switch(&rdev->wiphy, dev, params);
+	trace_rdev_ch_switch_finalize(&rdev->wiphy, dev);
+	ret = rdev->ops->ch_switch_finalize(&rdev->wiphy, dev);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index c854f1c..3590c3c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -977,6 +977,7 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 
 	kfree(wdev->connect_keys);
 	wdev->connect_keys = NULL;
+	wdev->chsw_state = CHSW_STATE_NONE;
 
 	if (wdev->conn)
 		err = cfg80211_sme_disconnect(wdev, reason);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index fbcc23e..d3fd363 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1864,7 +1864,7 @@ TRACE_EVENT(rdev_crit_proto_stop,
 		  WIPHY_PR_ARG, WDEV_PR_ARG)
 );
 
-TRACE_EVENT(rdev_channel_switch,
+TRACE_EVENT(rdev_ch_switch_start,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_csa_settings *params),
 	TP_ARGS(wiphy, netdev, params),
@@ -1897,6 +1897,21 @@ TRACE_EVENT(rdev_channel_switch,
 		  __entry->counter_offset_presp)
 );
 
+TRACE_EVENT(rdev_ch_switch_finalize,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG)
+);
+
 TRACE_EVENT(rdev_set_qos_map,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_qos_map *qos_map),
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d39c371..350a244 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -822,6 +822,12 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 		case EVENT_IBSS_JOINED:
 			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid);
 			break;
+		case EVENT_CH_SWITCH_REQUESTED:
+			__cfg80211_ch_switch_request(wdev, &ev->csa);
+			break;
+		case EVENT_CH_SWITCH_COMPLETED:
+			__cfg80211_ch_switch_complete(wdev);
+			break;
 		}
 		wdev_unlock(wdev);
 
-- 
1.8.5.3

