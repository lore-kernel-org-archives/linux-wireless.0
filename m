Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33167 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3GIS1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 14:27:17 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 4/5] mac80211: add channel switch command and beacon callbacks
Date: Tue,  9 Jul 2013 20:27:03 +0200
Message-Id: <1373394424-23298-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130709_202726_251781_5C018B5D)
In-Reply-To: <1373394424-23298-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373394424-23298-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The count field in CSA must be decremented with each beacon
transmitted. This patch implements the functionality for drivers
using ieee80211_beacon_get(). Other drivers must call back manually
after reaching count == 0.

This patch also contains the handling and finish worker for the channel
switch command.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
Changes to PATCHv3:
 * forbid adding interfaces while CSA is running
 * forbid calling CSA multiple times
 * check for multiple channel contexts
 * abort channel switch when going down while doing CSA

Changes to PATCHv2:
 * fix documentation and style stuff
 * update tracing
 * change csa_active to bool
 * check if csa_active when assigning beacons
 * fix locking and access
 * use new ieee80211_vif_change_channel to change the channel

Changes to PATCHv1:
 * don't switch when CAC is active
 * add hw to parameters for driver

Changes to RFCv1:
 * use beacons as supplied from nl80211 without generating/parsing them
 * update beacons using offsets
 * report back by calling the channel switch event in cfg80211

squash mac80211: add channel switch command and beacon callbacks

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/mac80211.h     |   34 ++++++++++++
 net/mac80211/cfg.c         |  132 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/driver-ops.h  |   13 +++++
 net/mac80211/ieee80211_i.h |   13 +++++
 net/mac80211/iface.c       |    9 +++
 net/mac80211/trace.h       |   26 +++++++++
 net/mac80211/tx.c          |   80 +++++++++++++++++++++++++++
 7 files changed, 305 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2cc306c..1c1c18a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1088,6 +1088,7 @@ enum ieee80211_vif_flags {
  * @addr: address of this interface
  * @p2p: indicates whether this AP or STA interface is a p2p
  *	interface, i.e. a GO or p2p-sta respectively
+ * @csa_active: marks whether a channel switch is going on
  * @driver_flags: flags/capabilities the driver has for this interface,
  *	these need to be set (or cleared) when the interface is added
  *	or, if supported by the driver, the interface type is changed
@@ -1110,6 +1111,7 @@ struct ieee80211_vif {
 	struct ieee80211_bss_conf bss_conf;
 	u8 addr[ETH_ALEN];
 	bool p2p;
+	bool csa_active;
 
 	u8 cab_queue;
 	u8 hw_queue[IEEE80211_NUM_ACS];
@@ -2641,6 +2643,16 @@ enum ieee80211_roc_type {
  * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
  *	Currently, this is only called for managed or P2P client interfaces.
  *	This callback is optional; it must not sleep.
+ *
+ * @channel_switch_beacon: Starts a channel switch to a new channel.
+ *	Beacons are modified to include CSA or ECSA IEs before calling this
+ *	function. The corresponding count fields in these IEs must be
+ *	decremented, and when they reach zero the driver must call
+ *	ieee80211_csa_finish(). Drivers which use ieee80211_beacon_get()
+ *	get the csa counter decremented by mac80211, but must check if it is
+ *	zero using ieee80211_csa_is_complete() after the beacon has been
+ *	transmitted and then call ieee80211_csa_finish().
+ *
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2828,6 +2840,9 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct inet6_dev *idev);
 #endif
+	void (*channel_switch_beacon)(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct cfg80211_chan_def *chandef);
 };
 
 /**
@@ -3323,6 +3338,25 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 }
 
 /**
+ * ieee80211_csa_finish - notify mac80211 about channel switch
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * After a channel switch announcement was scheduled and the counter in this
+ * announcement hit zero, this function must be called by the driver to
+ * notify mac80211 that the channel can be changed.
+ */
+void ieee80211_csa_finish(struct ieee80211_vif *vif);
+
+/**
+ * ieee80211_csa_is_complete - find out if counters reached zero
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * This function returns whether the channel switch counters reached zero.
+ */
+bool ieee80211_csa_is_complete(struct ieee80211_vif *vif);
+
+
+/**
  * ieee80211_proberesp_get - retrieve a Probe Response template
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8e6c935..33bfd26 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -860,8 +860,8 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
-				   struct cfg80211_beacon_data *params)
+int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
+			    struct cfg80211_beacon_data *params)
 {
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
@@ -1024,6 +1024,12 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	/* don't allow changing the beacon while CSA is in place - offset
+	 * of channel switch counter may change
+	 */
+	if (sdata->vif.csa_active)
+		return -EBUSY;
+
 	old = rtnl_dereference(sdata->u.ap.beacon);
 	if (!old)
 		return -ENOENT;
@@ -1048,6 +1054,10 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		return -ENOENT;
 	old_probe_resp = rtnl_dereference(sdata->u.ap.probe_resp);
 
+	/* abort any running channel switch */
+	sdata->vif.csa_active = false;
+	cancel_work_sync(&sdata->csa_finalize_work);
+
 	/* turn off carrier for this interface and dependent VLANs */
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		netif_carrier_off(vlan->dev);
@@ -2831,6 +2841,123 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 	return new_beacon;
 }
 
+void ieee80211_csa_finalize_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     csa_finalize_work);
+	struct ieee80211_local *local = sdata->local;
+	int err, changed;
+
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
+		return;
+
+	sdata->radar_required = sdata->csa_radar_required;
+	err = ieee80211_vif_change_channel(sdata, &local->csa_chandef,
+					   &changed);
+	if (WARN_ON(err < 0))
+		return;
+
+	err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+	if (err < 0)
+		return;
+
+	changed |= err;
+	kfree(sdata->u.ap.next_beacon);
+	sdata->u.ap.next_beacon = NULL;
+
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	cfg80211_ch_switch_notify(sdata->dev, &local->csa_chandef);
+}
+
+static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+				    struct cfg80211_csa_settings *params)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx *chanctx;
+	int err, num_chanctx;
+
+	if (!list_empty(&local->roc_list) || local->scanning)
+		return -EBUSY;
+
+	if (sdata->wdev.cac_started)
+		return -EBUSY;
+
+	/* don't handle if chanctx is used */
+	if (local->use_chanctx)
+		return -EINVAL;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		rcu_read_unlock();
+		return -EBUSY;
+	}
+
+	/* don't handle for multi-VIF cases */
+	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
+	if (chanctx->refcount > 1) {
+		rcu_read_unlock();
+		return -EBUSY;
+	}
+	num_chanctx = 0;
+	list_for_each_entry_rcu(chanctx, &local->chanctx_list, list)
+		num_chanctx++;
+
+	if (num_chanctx > 1) {
+		rcu_read_unlock();
+		return -EBUSY;
+	}
+	rcu_read_unlock();
+
+	/* don't allow another channel switch if one is already active. */
+	if (sdata->vif.csa_active)
+		return -EBUSY;
+
+	/* only handle AP for now. */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	sdata->u.ap.next_beacon = cfg80211_beacon_dup(&params->beacon_after);
+	if (!sdata->u.ap.next_beacon)
+		return -ENOMEM;
+
+	sdata->csa_counter_offset_beacon = params->counter_offset_beacon;
+	sdata->csa_counter_offset_presp = params->counter_offset_presp;
+	sdata->csa_radar_required = params->radar_required;
+
+	if (params->block_tx)
+		ieee80211_stop_queues_by_reason(&local->hw,
+				IEEE80211_MAX_QUEUE_MAP,
+				IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
+	if (err < 0)
+		return err;
+
+	local->csa_chandef = params->chandef;
+	sdata->vif.csa_active = true;
+
+	ieee80211_bss_info_change_notify(sdata, err);
+	drv_channel_switch_beacon(sdata, &params->chandef);
+
+	return 0;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     unsigned int wait, const u8 *buf, size_t len,
@@ -3548,4 +3675,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.channel_switch = ieee80211_channel_switch,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index b931c96..b3ea11f 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1072,4 +1072,17 @@ static inline void drv_ipv6_addr_change(struct ieee80211_local *local,
 }
 #endif
 
+static inline void
+drv_channel_switch_beacon(struct ieee80211_sub_if_data *sdata,
+			  struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	if (local->ops->channel_switch_beacon) {
+		trace_drv_channel_switch_beacon(local, sdata, chandef);
+		local->ops->channel_switch_beacon(&local->hw, &sdata->vif,
+						  chandef);
+	}
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 20dbc2d..73bcec3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -259,6 +259,8 @@ struct ieee80211_if_ap {
 	struct beacon_data __rcu *beacon;
 	struct probe_resp __rcu *probe_resp;
 
+	/* to be used after channel switch. */
+	struct cfg80211_beacon_data *next_beacon;
 	struct list_head vlans;
 
 	struct ps_data ps;
@@ -716,6 +718,11 @@ struct ieee80211_sub_if_data {
 
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 
+	struct work_struct csa_finalize_work;
+	int csa_counter_offset_beacon;
+	int csa_counter_offset_presp;
+	bool csa_radar_required;
+
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
 
@@ -1373,6 +1380,9 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free);
 void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
+/* channel switch handling */
+void ieee80211_csa_finalize_work(struct work_struct *work);
+
 /* interface handling */
 int ieee80211_iface_init(void);
 void ieee80211_iface_exit(void);
@@ -1394,6 +1404,9 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
 
 bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
+int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
+			    struct cfg80211_beacon_data *params);
+
 
 static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 093c34a..187c161 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -274,6 +274,12 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 			if (iftype == NL80211_IFTYPE_ADHOC &&
 			    nsdata->vif.type == NL80211_IFTYPE_ADHOC)
 				return -EBUSY;
+			/*
+			 * will not add another interface while any channel
+			 * switch is active.
+			 */
+			if (nsdata->vif.csa_active)
+				return -EBUSY;
 
 			/*
 			 * The remaining checks are only performed for interfaces
@@ -804,6 +810,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	cancel_work_sync(&sdata->recalc_smps);
+	sdata->vif.csa_active = false;
+	cancel_work_sync(&sdata->csa_finalize_work);
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
 
@@ -1267,6 +1275,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	skb_queue_head_init(&sdata->skb_queue);
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 	INIT_WORK(&sdata->recalc_smps, ieee80211_recalc_smps_work);
+	INIT_WORK(&sdata->csa_finalize_work, ieee80211_csa_finalize_work);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index c215fafd7..1aba645 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1906,6 +1906,32 @@ TRACE_EVENT(api_radar_detected,
 	)
 );
 
+TRACE_EVENT(drv_channel_switch_beacon,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_chan_def *chandef),
+
+	TP_ARGS(local, sdata, chandef),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		CHANDEF_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		CHANDEF_ASSIGN(chandef);
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT " channel switch to " CHANDEF_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, CHANDEF_PR_ARG
+	)
+);
+
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f82301b..1da252a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2335,6 +2335,83 @@ static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+void ieee80211_csa_finish(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	vif->csa_active = false;
+	ieee80211_queue_work(&sdata->local->hw,
+			     &sdata->csa_finalize_work);
+}
+EXPORT_SYMBOL(ieee80211_csa_finish);
+
+static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
+				 struct beacon_data *beacon)
+{
+	struct probe_resp *resp;
+	int counter_offset_beacon = sdata->csa_counter_offset_beacon;
+	int counter_offset_presp = sdata->csa_counter_offset_presp;
+
+	/* warn if the driver did not check for/react to csa completeness */
+	if (WARN_ON(((u8 *)beacon->tail)[counter_offset_beacon] == 0))
+		return;
+
+	((u8 *)beacon->tail)[counter_offset_beacon]--;
+
+	if (!counter_offset_presp)
+		return;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		rcu_read_lock();
+		resp = rcu_dereference(sdata->u.ap.probe_resp);
+
+		/* if nl80211 accepted the offset, this should not happen. */
+		if (WARN_ON(!resp)) {
+			rcu_read_unlock();
+			return;
+		}
+		resp->data[counter_offset_presp]--;
+	}
+}
+
+bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct beacon_data *beacon = NULL;
+	u8 *beacon_data;
+	size_t beacon_data_len;
+	int counter_beacon = sdata->csa_counter_offset_beacon;
+	int ret = false;
+
+	if (!ieee80211_sdata_running(sdata))
+		return false;
+
+	rcu_read_lock();
+	if (vif->type == NL80211_IFTYPE_AP) {
+		struct ieee80211_if_ap *ap = &sdata->u.ap;
+
+		beacon = rcu_dereference(ap->beacon);
+		if (WARN_ON(!beacon || !beacon->tail))
+			goto out;
+		beacon_data = beacon->tail;
+		beacon_data_len = beacon->tail_len;
+	} else {
+		WARN_ON(1);
+		goto out;
+	}
+
+	if (WARN_ON(counter_beacon > beacon_data_len))
+		goto out;
+
+	if (beacon_data[counter_beacon] == 0)
+		ret = true;
+ out:
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(ieee80211_csa_is_complete);
+
 struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 u16 *tim_offset, u16 *tim_length)
@@ -2365,6 +2442,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		struct beacon_data *beacon = rcu_dereference(ap->beacon);
 
 		if (beacon) {
+			if (sdata->vif.csa_active)
+				ieee80211_update_csa(sdata, beacon);
+
 			/*
 			 * headroom, head length,
 			 * tail length and maximum TIM length
-- 
1.7.10.4

