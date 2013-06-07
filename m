Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:48608 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3FGRFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 13:05:51 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 4/5] mac80211: add channel switch command and beacon callbacks
Date: Fri,  7 Jun 2013 19:05:44 +0200
Message-Id: <1370624745-2267-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130607_190600_804211_2D52B78C)
In-Reply-To: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de>
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
Changes to RFCv1:
 * use beacons as supplied from nl80211 without generating/parsing them
 * update beacons using offsets
 * report back by calling the channel switch event in cfg80211
---
 include/net/mac80211.h     |   21 +++++++++
 net/mac80211/cfg.c         |  106 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/driver-ops.h  |   11 +++++
 net/mac80211/ieee80211_i.h |   11 +++++
 net/mac80211/iface.c       |    2 +
 net/mac80211/trace.h       |   20 +++++++++
 net/mac80211/tx.c          |   45 +++++++++++++++++++
 7 files changed, 214 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a405a7a..efaacd1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1078,6 +1078,7 @@ enum ieee80211_vif_flags {
  * @addr: address of this interface
  * @p2p: indicates whether this AP or STA interface is a p2p
  *	interface, i.e. a GO or p2p-sta respectively
+ * @csa_active: marks whether a channel switch is going on
  * @driver_flags: flags/capabilities the driver has for this interface,
  *	these need to be set (or cleared) when the interface is added
  *	or, if supported by the driver, the interface type is changed
@@ -1100,6 +1101,7 @@ struct ieee80211_vif {
 	struct ieee80211_bss_conf bss_conf;
 	u8 addr[ETH_ALEN];
 	bool p2p;
+	bool csa_active;
 
 	u8 cab_queue;
 	u8 hw_queue[IEEE80211_NUM_ACS];
@@ -2631,6 +2633,14 @@ enum ieee80211_roc_type {
  * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
  *	Currently, this is only called for managed or P2P client interfaces.
  *	This callback is optional; it must not sleep.
+ *
+ * @channel_switch_beacon: Starts a channel switch for the to a new channel.
+ *	Beacons are modified to include CSA or ECSA IEs before calling this
+ *	function. The corresponding count fields in these IEs must be
+ *	decremented, and when they reach zero the driver must call
+ *	ieee80211_finish_csa(). Drivers which use ieee80211_get_beacon()
+ *	already get this done by mac80211.
+ *
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2818,6 +2828,7 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct inet6_dev *idev);
 #endif
+	void (*channel_switch_beacon)(struct ieee80211_vif *vif);
 };
 
 /**
@@ -3313,6 +3324,16 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 }
 
 /**
+ * ieee80211_finish_csa - notify mac80211 about channel switch
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * After a channel switch announcement was scheduled and the counter in this
+ * announcement hit zero, this function must be called by the driver to
+ * notify mac80211 that the channel can be changed.
+ */
+void ieee80211_finish_csa(struct ieee80211_vif *vif);
+
+/**
  * ieee80211_proberesp_get - retrieve a Probe Response template
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1f8e5cf..24b39c7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -854,8 +854,8 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
-				   struct cfg80211_beacon_data *params)
+int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
+			    struct cfg80211_beacon_data *params)
 {
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
@@ -2851,6 +2851,107 @@ error:
 	return NULL;
 }
 
+void ieee80211_csa_finalize_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     csa_finalize_work);
+	struct ieee80211_local *local = sdata->local;
+	int err;
+
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
+		return;
+
+	netif_carrier_off(sdata->dev);
+	err = ieee80211_vif_use_channel(sdata, &local->csa_chandef,
+					IEEE80211_CHANCTX_SHARED);
+	netif_carrier_on(sdata->dev);
+	if (WARN_ON(err < 0))
+		return;
+	netif_carrier_on(sdata->dev);
+
+	err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+	cfg80211_beacon_free(sdata->u.ap.next_beacon);
+	sdata->u.ap.next_beacon = NULL;
+
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	ieee80211_bss_info_change_notify(sdata, err);
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
+	int err;
+
+	if (!list_empty(&local->roc_list) || local->scanning)
+		return -EBUSY;
+
+	/* don't handle if chanctx is used */
+	if (local->use_chanctx)
+		return -EBUSY;
+
+	rcu_read_lock();
+	mutex_lock(&local->chanctx_mtx);
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		mutex_unlock(&local->chanctx_mtx);
+		rcu_read_unlock();
+		return -EBUSY;
+	}
+
+	/* don't handle for multi-VIF cases */
+	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
+	if (chanctx->refcount > 1) {
+		mutex_unlock(&local->chanctx_mtx);
+		rcu_read_unlock();
+		return -EBUSY;
+	}
+	mutex_unlock(&local->chanctx_mtx);
+	rcu_read_unlock();
+
+	/* only handle AP for now. */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	sdata->csa_counter_offset_beacon = params->counter_offset_beacon;
+	sdata->csa_counter_offset_presp = params->counter_offset_presp;
+	sdata->u.ap.next_beacon = cfg80211_beacon_dup(&params->beacon_after);
+	if (!sdata->u.ap.next_beacon)
+		return -ENOMEM;
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
+
+	ieee80211_bss_info_change_notify(sdata, err);
+	drv_channel_switch_beacon(sdata);
+
+	return 0;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     unsigned int wait, const u8 *buf, size_t len,
@@ -3567,4 +3668,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.channel_switch = ieee80211_channel_switch,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index b931c96..47a97ef 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1072,4 +1072,15 @@ static inline void drv_ipv6_addr_change(struct ieee80211_local *local,
 }
 #endif
 
+static inline void
+drv_channel_switch_beacon(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	if (local->ops->channel_switch_beacon) {
+		trace_drv_channel_switch_beacon(sdata);
+		local->ops->channel_switch_beacon(&sdata->vif);
+	}
+}
+
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7a6f1a0..d34d816 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -258,6 +258,8 @@ struct ieee80211_if_ap {
 	struct beacon_data __rcu *beacon;
 	struct probe_resp __rcu *probe_resp;
 
+	/* to be used after channel switch. */
+	struct cfg80211_beacon_data *next_beacon;
 	struct list_head vlans;
 
 	struct ps_data ps;
@@ -713,6 +715,10 @@ struct ieee80211_sub_if_data {
 
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 
+	struct work_struct csa_finalize_work;
+	int csa_counter_offset_beacon;
+	int csa_counter_offset_presp;
+
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
 
@@ -1340,6 +1346,8 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free);
 void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
+/* channel switch handling */
+void ieee80211_csa_finalize_work(struct work_struct *work);
 
 /* interface handling */
 int ieee80211_iface_init(void);
@@ -1362,6 +1370,9 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
 
 bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
+int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
+			    struct cfg80211_beacon_data *params);
+
 
 static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7cabaf2..d17692d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -800,6 +800,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	cancel_work_sync(&sdata->recalc_smps);
+	cancel_work_sync(&sdata->csa_finalize_work);
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
 
@@ -1263,6 +1264,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	skb_queue_head_init(&sdata->skb_queue);
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 	INIT_WORK(&sdata->recalc_smps, ieee80211_recalc_smps_work);
+	INIT_WORK(&sdata->csa_finalize_work, ieee80211_csa_finalize_work);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index c215fafd7..6b2af54 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1906,6 +1906,26 @@ TRACE_EVENT(api_radar_detected,
 	)
 );
 
+TRACE_EVENT(drv_channel_switch_beacon,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata),
+
+	TP_ARGS(sdata),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+	),
+
+	TP_printk(
+		VIF_PR_FMT " channel switch",
+		VIF_PR_ARG
+	)
+);
+
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4105d0c..0f1916f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2320,6 +2320,47 @@ static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+void ieee80211_finish_csa(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = NULL;
+	sdata = vif_to_sdata(vif);
+
+	vif->csa_active = 0;
+	ieee80211_queue_work(&sdata->local->hw,
+			     &sdata->csa_finalize_work);
+}
+EXPORT_SYMBOL(ieee80211_finish_csa);
+
+static int ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
+				struct beacon_data *beacon)
+{
+	struct probe_resp *resp;
+	int counter_beacon = sdata->csa_counter_offset_beacon;
+	int counter_presp = sdata->csa_counter_offset_presp;
+
+	if (WARN_ON(counter_beacon > beacon->tail_len))
+		return 1;
+
+	((u8 *)beacon->tail)[counter_beacon]--;
+
+	if (counter_presp && sdata->vif.type == NL80211_IFTYPE_AP) {
+		resp = rcu_dereference(sdata->u.ap.probe_resp);
+		if (WARN_ON(!resp))
+			return 1;
+		if (WARN_ON(counter_presp > resp->len))
+			return 1;
+
+		((u8 *)resp->data)[counter_presp]--;
+	}
+
+	if (((u8 *)beacon->tail)[counter_beacon] == 0) {
+		sdata->vif.csa_active = 0;
+		ieee80211_finish_csa(&sdata->vif);
+		return 1;
+	}
+	return 0;
+}
+
 struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 u16 *tim_offset, u16 *tim_length)
@@ -2350,6 +2391,10 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		struct beacon_data *beacon = rcu_dereference(ap->beacon);
 
 		if (beacon) {
+			if (sdata->vif.csa_active)
+				if (ieee80211_update_csa(sdata, beacon))
+					goto out;
+
 			/*
 			 * headroom, head length,
 			 * tail length and maximum TIM length
-- 
1.7.10.4

