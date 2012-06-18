Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62282 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab2FRK6D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 06:58:03 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [RFC 1/5] mac80211: make filter configuration work per subif
Date: Mon, 18 Jun 2012 12:57:11 +0200
Message-ID: <1340017035-7657-2-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120618_125809_095630_B47105BC)
In-Reply-To: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
References: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_configure_filter takes ieee80211_sub_if_data*
as argument instead of ieee80211_local*.

reconfig_filter work is now bounded to ieee80211_sub_if_data.

Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
---
 net/mac80211/cfg.c         |    6 +++---
 net/mac80211/ieee80211_i.h |   15 ++++++++-------
 net/mac80211/iface.c       |   31 ++++++++++++++++++++++---------
 net/mac80211/main.c        |   21 +++++++--------------
 net/mac80211/mesh.c        |    4 ++--
 net/mac80211/scan.c        |    8 +++++---
 net/mac80211/util.c        |    6 ++----
 7 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 85ac364..d3ae0df 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -69,7 +69,6 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		sdata->u.mgd.use_4addr = params->use_4addr;
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags) {
-		struct ieee80211_local *local = sdata->local;
 
 		if (ieee80211_sdata_running(sdata)) {
 			/*
@@ -88,7 +87,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 			sdata->u.mntr_flags = *flags;
 			ieee80211_adjust_monitor_flags(sdata, 1);
 
-			ieee80211_configure_filter(local);
+			ieee80211_configure_filter(sdata);
 		} else {
 			/*
 			 * Because the interface is down, ieee80211_do_stop
@@ -2489,6 +2488,7 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 					  u16 frame_type, bool reg)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (frame_type != (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_REQ))
 		return;
@@ -2498,7 +2498,7 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 	else
 		local->probe_req_reg--;
 
-	ieee80211_queue_work(&local->hw, &local->reconfig_filter);
+	ieee80211_queue_work(&local->hw, &sdata->reconfig_filter);
 }
 
 static int ieee80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e6cbf5b..78fc9cc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -723,6 +723,13 @@ struct ieee80211_sub_if_data {
 		struct dentry *default_mgmt_key;
 	} debugfs;
 #endif
+
+	/* protects the aggregated multicast list and filter calls */
+	spinlock_t filter_lock;
+
+	/* used for uploading changed mc list */
+	struct work_struct reconfig_filter;
+
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
@@ -842,12 +849,6 @@ struct ieee80211_local {
 
 	bool wiphy_ciphers_allocated;
 
-	/* protects the aggregated multicast list and filter calls */
-	spinlock_t filter_lock;
-
-	/* used for uploading changed mc list */
-	struct work_struct reconfig_filter;
-
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
 
@@ -1171,7 +1172,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed);
-void ieee80211_configure_filter(struct ieee80211_local *local);
+void ieee80211_configure_filter(struct ieee80211_sub_if_data *sdata);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
 /* STA code */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 87aeb4f..059388b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -385,7 +385,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 		}
 
 		ieee80211_adjust_monitor_flags(sdata, 1);
-		ieee80211_configure_filter(local);
+		ieee80211_configure_filter(sdata);
 
 		netif_carrier_on(dev);
 		break;
@@ -405,7 +405,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 			local->fif_pspoll++;
 			local->fif_probe_req++;
 
-			ieee80211_configure_filter(local);
+			ieee80211_configure_filter(sdata);
 		} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 			local->fif_probe_req++;
 		}
@@ -566,13 +566,13 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	}
 
 	netif_addr_lock_bh(sdata->dev);
-	spin_lock_bh(&local->filter_lock);
+	spin_lock_bh(&sdata->filter_lock);
 	__hw_addr_unsync(&local->mc_list, &sdata->dev->mc,
 			 sdata->dev->addr_len);
-	spin_unlock_bh(&local->filter_lock);
+	spin_unlock_bh(&sdata->filter_lock);
 	netif_addr_unlock_bh(sdata->dev);
 
-	ieee80211_configure_filter(local);
+	ieee80211_configure_filter(sdata);
 
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
@@ -631,7 +631,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		}
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
-		ieee80211_configure_filter(local);
+		ieee80211_configure_filter(sdata);
 		break;
 	default:
 		flush_work(&sdata->work);
@@ -741,10 +741,10 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 			atomic_dec(&local->iff_promiscs);
 		sdata->flags ^= IEEE80211_SDATA_PROMISC;
 	}
-	spin_lock_bh(&local->filter_lock);
+	spin_lock_bh(&sdata->filter_lock);
 	__hw_addr_sync(&local->mc_list, &dev->mc, dev->addr_len);
-	spin_unlock_bh(&local->filter_lock);
-	ieee80211_queue_work(&local->hw, &local->reconfig_filter);
+	spin_unlock_bh(&sdata->filter_lock);
+	ieee80211_queue_work(&local->hw, &sdata->reconfig_filter);
 }
 
 /*
@@ -960,6 +960,14 @@ static void ieee80211_iface_work(struct work_struct *work)
 	}
 }
 
+static void ieee80211_reconfig_filter(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     reconfig_filter);
+
+	ieee80211_configure_filter(sdata);
+}
 
 /*
  * Helper function to initialise an interface to a specific type.
@@ -984,8 +992,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	/* only monitor differs */
 	sdata->dev->type = ARPHRD_ETHER;
 
+	spin_lock_init(&sdata->filter_lock);
+
 	skb_queue_head_init(&sdata->skb_queue);
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
+	INIT_WORK(&sdata->reconfig_filter, ieee80211_reconfig_filter);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
@@ -1373,6 +1384,8 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 {
 	ASSERT_RTNL();
 
+	cancel_work_sync(&sdata->reconfig_filter);
+
 	mutex_lock(&sdata->local->iflist_mtx);
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d81c178..14c990a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -35,11 +35,15 @@
 
 static struct lock_class_key ieee80211_rx_skb_queue_class;
 
-void ieee80211_configure_filter(struct ieee80211_local *local)
+void ieee80211_configure_filter(struct ieee80211_sub_if_data *sdata)
 {
 	u64 mc;
 	unsigned int changed_flags;
 	unsigned int new_flags = 0;
+	struct ieee80211_local *local = sdata->local;
+
+	if (!ieee80211_sdata_running(sdata))
+		return;
 
 	if (atomic_read(&local->iff_promiscs))
 		new_flags |= FIF_PROMISC_IN_BSS;
@@ -69,11 +73,11 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
 	if (local->fif_pspoll)
 		new_flags |= FIF_PSPOLL;
 
-	spin_lock_bh(&local->filter_lock);
+	spin_lock_bh(&sdata->filter_lock);
 	changed_flags = local->filter_flags ^ new_flags;
 
 	mc = drv_prepare_multicast(local, &local->mc_list);
-	spin_unlock_bh(&local->filter_lock);
+	spin_unlock_bh(&sdata->filter_lock);
 
 	/* be a bit nasty */
 	new_flags |= (1<<31);
@@ -85,14 +89,6 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
 	local->filter_flags = new_flags & ~(1<<31);
 }
 
-static void ieee80211_reconfig_filter(struct work_struct *work)
-{
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, reconfig_filter);
-
-	ieee80211_configure_filter(local);
-}
-
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 {
 	struct ieee80211_channel *chan;
@@ -610,7 +606,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	mutex_init(&local->mtx);
 
 	mutex_init(&local->key_mtx);
-	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
 	/*
@@ -627,7 +622,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	INIT_WORK(&local->restart_work, ieee80211_restart_work);
 
-	INIT_WORK(&local->reconfig_filter, ieee80211_reconfig_filter);
 	INIT_WORK(&local->recalc_smps, ieee80211_recalc_smps_work);
 	local->smps_mode = IEEE80211_SMPS_OFF;
 
@@ -1015,7 +1009,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	rtnl_unlock();
 
 	cancel_work_sync(&local->restart_work);
-	cancel_work_sync(&local->reconfig_filter);
 
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 7cf1950..94acc1c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -585,7 +585,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
 	atomic_inc(&local->iff_allmultis);
-	ieee80211_configure_filter(local);
+	ieee80211_configure_filter(sdata);
 
 	ifmsh->mesh_cc_id = 0;	/* Disabled */
 	ifmsh->mesh_auth_id = 0;	/* Disabled */
@@ -631,7 +631,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
-	ieee80211_configure_filter(local);
+	ieee80211_configure_filter(sdata);
 }
 
 static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 379f178..9a2cba8 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -277,6 +277,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 				       bool was_hw_scan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -304,6 +305,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	if (local->scan_req != local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
+	sdata = local->scan_sdata;
 	local->scan_sdata = NULL;
 
 	local->scanning = 0;
@@ -313,7 +315,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	ieee80211_hw_config(local, 0);
 
 	if (!was_hw_scan) {
-		ieee80211_configure_filter(local);
+		ieee80211_configure_filter(sdata);
 		drv_sw_scan_complete(local);
 		ieee80211_offchannel_return(local, true);
 	}
@@ -362,7 +364,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 
 	ieee80211_offchannel_stop_vifs(local, true);
 
-	ieee80211_configure_filter(local);
+	ieee80211_configure_filter(local->scan_sdata);
 
 	/* We need to set power level at maximum rate for scanning. */
 	ieee80211_hw_config(local, 0);
@@ -494,7 +496,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		 * same as normal software scan, in case that matters. */
 		drv_sw_scan_start(local);
 
-		ieee80211_configure_filter(local); /* accept probe-responses */
+		ieee80211_configure_filter(sdata); /* accept probe-responses */
 
 		/* We need to ensure power level is at max for scanning. */
 		ieee80211_hw_config(local, 0);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1df4019..74aab81 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1193,9 +1193,6 @@ void ieee80211_stop_device(struct ieee80211_local *local)
 {
 	ieee80211_led_radio(local, false);
 	ieee80211_mod_tpt_led_trig(local, 0, IEEE80211_TPT_LEDTRIG_FL_RADIO);
-
-	cancel_work_sync(&local->reconfig_filter);
-
 	flush_workqueue(local->workqueue);
 	drv_stop(local);
 }
@@ -1312,7 +1309,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
 
-	ieee80211_configure_filter(local);
+	list_for_each_entry(sdata, &local->interfaces, list)
+		ieee80211_configure_filter(sdata);
 
 	/* Finally also reconfigure all the BSS information */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-- 
1.7.0.4

