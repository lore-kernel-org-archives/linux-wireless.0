Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51168 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3EFTOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 15:14:11 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC 3/4] mac80211: add channel switch command and beacon callbacks
Date: Mon,  6 May 2013 21:13:54 +0200
Message-Id: <1367867635-3459-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130506_211422_162957_E7D1170F)
In-Reply-To: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The command requires to add some information into the beacon,
add a general function to obtain the order of the elements within
the beacon.

The count field in CSA must be decremented with each beacon
transmitted. This patch implements the functionality for drivers
using ieee80211_beacon_get(). Other drivers must call back manually
after reaching count == 0.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/linux/ieee80211.h  |    9 ++
 include/net/mac80211.h     |   21 ++++
 net/mac80211/cfg.c         |  262 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h  |   11 ++
 net/mac80211/ieee80211_i.h |    9 ++
 net/mac80211/iface.c       |    2 +
 net/mac80211/trace.h       |   20 ++++
 net/mac80211/tx.c          |   59 ++++++++++
 net/mac80211/util.c        |  210 +++++++++++++++++++++++++++++++++++
 9 files changed, 603 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 06b0ed0..f87b10d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1654,6 +1654,7 @@ enum ieee80211_eid {
 	WLAN_EID_PXUC = 138,
 	WLAN_EID_AUTH_MESH_PEER_EXCH = 139,
 	WLAN_EID_MIC = 140,
+	WLAN_EID_MCCAOP_ADVERT_OVERVIEW = 174,
 
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
@@ -1703,6 +1704,14 @@ enum ieee80211_eid {
 	WLAN_EID_SUPPORTED_REGULATORY_CLASSES = 59,
 	WLAN_EID_EXT_CHANSWITCH_ANN = 60,
 
+	WLAN_EID_TIME_ADVERTISEMENT = 69,
+	WLAN_EID_FMS_DESCRIPTOR = 86,
+	WLAN_EID_QOS_TRAFFIC_CAPABILITY = 89,
+	WLAN_EID_INTERWORKING = 107,
+	WLAN_EID_ADVERTISEMENT_PROTOCOL = 108,
+	WLAN_EID_ROAMING_CONSORTIUM = 111,
+	WLAN_EID_EMERGENCY_ALERT_ID = 112,
+
 	WLAN_EID_VHT_CAPABILITY = 191,
 	WLAN_EID_VHT_OPERATION = 192,
 	WLAN_EID_OPMODE_NOTIF = 199,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ebf83ef..bb6ada3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1071,6 +1071,7 @@ enum ieee80211_vif_flags {
  * @addr: address of this interface
  * @p2p: indicates whether this AP or STA interface is a p2p
  *	interface, i.e. a GO or p2p-sta respectively
+ * @csa_active: marks whether a channel switch is going on
  * @driver_flags: flags/capabilities the driver has for this interface,
  *	these need to be set (or cleared) when the interface is added
  *	or, if supported by the driver, the interface type is changed
@@ -1093,6 +1094,7 @@ struct ieee80211_vif {
 	struct ieee80211_bss_conf bss_conf;
 	u8 addr[ETH_ALEN];
 	bool p2p;
+	bool csa_active;
 
 	u8 cab_queue;
 	u8 hw_queue[IEEE80211_NUM_ACS];
@@ -2624,6 +2626,14 @@ enum ieee80211_roc_type {
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
@@ -2811,6 +2821,7 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct inet6_dev *idev);
 #endif
+	void (*channel_switch_beacon)(struct ieee80211_vif *vif);
 };
 
 /**
@@ -3306,6 +3317,16 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
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
index 1f51bdf..4ea77d3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2771,6 +2771,267 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_beacon_add_csa(struct ieee80211_sub_if_data *sdata,
+				       struct cfg80211_beacon_data **beacon,
+				       struct cfg80211_chan_def *chandef,
+				       bool block_tx, u32 count)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_sw_ie csa_ie;
+	struct ieee80211_ext_chansw_ie ecsa_ie;
+	struct cfg80211_beacon_data *new;
+	struct beacon_data *old;
+	/* TODO: do something about presp? */
+	size_t size;
+	int ch_num;
+	u8 opclass;
+
+	*beacon = NULL;
+
+	old = rtnl_dereference(sdata->u.ap.beacon);
+	if (!old)
+		return -ENOENT;
+
+	size = sizeof(*new) + old->head_len + old->tail_len;
+	size += max(sizeof(csa_ie), sizeof(ecsa_ie)) + 2;
+
+	new = kzalloc(size, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	new->head = ((u8 *)new) + sizeof(*new);
+	new->tail = new->head + old->head_len;
+	memcpy((u8 *)new->head, old->head, old->head_len);
+	memcpy((u8 *)new->tail, old->tail, old->tail_len);
+	new->head_len = old->head_len;
+	new->tail_len = old->tail_len;
+
+	ch_num = ieee80211_frequency_to_channel(chandef->chan->center_freq);
+	/* use the regular CSA for 20 MHz/legacy channels changes */
+	if ((chandef->width == NL80211_CHAN_WIDTH_20_NOHT ||
+	     chandef->width == NL80211_CHAN_WIDTH_20) &&
+	    (local->_oper_chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
+	     local->_oper_chandef.width == NL80211_CHAN_WIDTH_20)) {
+		/* Channel Switch Announcement element */
+		csa_ie.mode = block_tx;
+		csa_ie.new_ch_num = ch_num;
+		csa_ie.count = count;
+		ieee80211_ie_beacon_insert((u8 *)new->tail, &new->tail_len,
+					   WLAN_EID_CHANNEL_SWITCH,
+					   (u8 *)&csa_ie, sizeof(csa_ie));
+	} else {
+		/* Extended Channel Switch Announcement element */
+		ecsa_ie.mode = block_tx;
+		if (ieee80211_chandef_to_operating_class(chandef, &opclass)) {
+			kfree(new);
+			return -EINVAL;
+		}
+		ecsa_ie.new_operating_class = opclass;
+		ecsa_ie.new_ch_num = ch_num;
+		ecsa_ie.count = count;
+		ieee80211_ie_beacon_insert((u8 *)new->tail, &new->tail_len,
+					   WLAN_EID_EXT_CHANSWITCH_ANN,
+					   (u8 *)&ecsa_ie, sizeof(ecsa_ie));
+	}
+
+	*beacon = new;
+
+	return 0;
+}
+
+static int ieee80211_beacon_remove_csa(struct ieee80211_sub_if_data *sdata,
+				       struct cfg80211_beacon_data **beacon)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct cfg80211_beacon_data *new;
+	struct beacon_data *old;
+	u8 *ptr, *head_ies;
+	/* TODO: do something about presp? */
+	size_t size;
+	int ch_num, head_ie_len, freq;
+
+	*beacon = NULL;
+
+	old = rtnl_dereference(sdata->u.ap.beacon);
+	if (!old)
+		return -ENOENT;
+
+	size = sizeof(*new) + old->head_len + old->tail_len;
+
+	new = kzalloc(size, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	new->head = ((u8 *)new) + sizeof(*new);
+	new->tail = new->head + old->head_len;
+	memcpy((u8 *)new->head, old->head, old->head_len);
+	memcpy((u8 *)new->tail, old->tail, old->tail_len);
+	new->head_len = old->head_len;
+	new->tail_len = old->tail_len;
+
+	freq = local->csa_chandef.chan->center_freq;
+	ch_num = ieee80211_frequency_to_channel(freq);
+
+	/* remove channel switching IEs */
+	ieee80211_ie_remove((u8 *)new->tail, &new->tail_len,
+			    WLAN_EID_CHANNEL_SWITCH);
+	ieee80211_ie_remove((u8 *)new->tail, &new->tail_len,
+			    WLAN_EID_EXT_CHANSWITCH_ANN);
+
+	/* replace channel in DS parameter set, this is to be found in head */
+	head_ies = ((u8 *)new->head) +
+		   offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	head_ie_len = new->head_len -
+		   offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	ptr = ieee80211_ie_find(head_ies, head_ie_len, WLAN_EID_DS_PARAMS);
+
+	/* should have length of one, containing the channel number only */
+	if (ptr && (ptr[1] == 1))
+		ptr[2] = ch_num;
+	else
+		/* DS_PARAMS should always be available ... at least warn. */
+		WARN_ON(1);
+
+	/*
+	 * NOTE: only update existing HT infos. We don't support changing from
+	 * a non-HT mode to an HT mode ... TODO: maybe check for that?
+	 */
+	ptr = ieee80211_ie_find((u8 *)new->tail, new->tail_len,
+				WLAN_EID_HT_OPERATION);
+	if (ptr && (ptr[1] == sizeof(struct ieee80211_ht_operation))) {
+		struct ieee80211_supported_band *sband;
+		struct ieee80211_ht_operation *ht_oper, *new_ht_oper;
+		u8 buf[sizeof(*ht_oper) + 2];
+
+		ht_oper = (struct ieee80211_ht_operation *)(&ptr[2]);
+		sband = local->hw.wiphy->bands[local->csa_chandef.chan->band];
+		ieee80211_ie_build_ht_oper(buf, &sband->ht_cap,
+					   &local->csa_chandef,
+					   ht_oper->operation_mode);
+		new_ht_oper = (struct ieee80211_ht_operation *)&buf[2];
+
+		/* only update channel related parameters */
+		ht_oper->primary_chan = new_ht_oper->primary_chan;
+		ht_oper->ht_param = new_ht_oper->ht_param;
+	}
+
+	*beacon = new;
+	return 0;
+}
+
+
+void ieee80211_csa_finalize_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     csa_finalize_work);
+	struct ieee80211_local *local = sdata->local;
+	struct cfg80211_beacon_data *beacon_after_change;
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
+	err = ieee80211_beacon_remove_csa(sdata, &beacon_after_change);
+	if (err < 0)
+		return;
+
+	err = ieee80211_assign_beacon(sdata, beacon_after_change);
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+	kfree(beacon_after_change);
+	ieee80211_bss_info_change_notify(sdata, err);
+}
+
+static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+				    struct cfg80211_chan_def *chandef,
+				    bool block_tx, u32 count)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct cfg80211_beacon_data *beacon_with_csa;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx *chanctx;
+	int err;
+
+	/* TODO: check for cac too? */
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
+	/*
+	 * must be the same band ... changing the beaconing information is not
+	 * supported for changing accross bands.
+	 */
+	if (chanctx_conf->def.chan->band != chandef->chan->band) {
+		mutex_unlock(&local->chanctx_mtx);
+		rcu_read_unlock();
+		return -EINVAL;
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
+	err = ieee80211_beacon_add_csa(sdata, &beacon_with_csa, chandef,
+					  block_tx, count);
+	if (err < 0)
+		return err;
+
+	if (block_tx)
+		ieee80211_stop_queues_by_reason(&local->hw,
+				IEEE80211_MAX_QUEUE_MAP,
+				IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	err = ieee80211_assign_beacon(sdata, beacon_with_csa);
+	kfree(beacon_with_csa);
+	if (err < 0)
+		return err;
+
+	local->csa_chandef = *chandef;
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
@@ -3487,4 +3748,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.channel_switch = ieee80211_channel_switch,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 169664c..0c9669b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1071,4 +1071,15 @@ static inline void drv_ipv6_addr_change(struct ieee80211_local *local,
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
index 44be28c..97bf807 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -717,6 +717,8 @@ struct ieee80211_sub_if_data {
 
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 
+	struct work_struct csa_finalize_work;
+
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
 
@@ -1324,6 +1326,8 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free);
 void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
+/* channel switch handling */
+void ieee80211_csa_finalize_work(struct work_struct *work);
 
 /* interface handling */
 int ieee80211_iface_init(void);
@@ -1578,9 +1582,14 @@ int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 			     enum ieee80211_smps_mode smps_mode);
 void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata);
 
+int ieee80211_beacon_ie_order(int id);
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
+u8 *ieee80211_ie_find(u8 *ies, int ielen, u8 eid);
+int ieee80211_ie_remove(u8 *ies, int *ielen, u8 eid);
+int ieee80211_ie_beacon_insert(u8 *ies, int *ielen, u8 eid, u8 *new_ie,
+			       u8 new_ie_len);
 u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap);
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9daa64e..b8e9125 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -769,6 +769,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	cancel_work_sync(&sdata->recalc_smps);
+	cancel_work_sync(&sdata->csa_finalize_work);
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
 
@@ -1228,6 +1229,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
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
index 4a5fbf8..de08afa 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2325,6 +2325,60 @@ static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
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
+static int ieee80211_update_csa(struct ieee80211_vif *vif,
+				u8 *ie_buf, int ie_len)
+{
+	struct ieee80211_channel_sw_ie *csa_ie;
+	struct ieee80211_ext_chansw_ie *ecsa_ie;
+	u8 *ie_val;
+	int pos = 0;
+	bool found = false;
+
+	/* browse through IEs and update (E)CSA */
+	while (pos < ie_len) {
+		ie_val = ie_buf[pos + 2];
+		if (ie_buf[pos] == WLAN_EID_CHANNEL_SWITCH) {
+			WARN_ON(found);
+			found = true;
+			csa_ie = (struct ieee80211_channel_sw_ie *)ie_val;
+			csa_ie->count--;
+			if (csa_ie->count == 0) {
+				ieee80211_finish_csa(vif);
+				return 1;
+			}
+		}
+
+		if (ie_buf[pos] == WLAN_EID_EXT_CHANSWITCH_ANN) {
+			WARN_ON(found);
+			found = true;
+			ecsa_ie = (struct ieee80211_ext_chansw_ie *)ie_val;
+			ecsa_ie->count--;
+			if (ecsa_ie->count == 0) {
+				ieee80211_finish_csa(vif);
+				return 1;
+			}
+		}
+
+		pos += ie_buf[pos + 1] + 2;
+	}
+
+	if (!found)
+		WARN_ON(1);
+
+	return 0;
+}
+
 struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 u16 *tim_offset, u16 *tim_length)
@@ -2355,6 +2409,11 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		struct beacon_data *beacon = rcu_dereference(ap->beacon);
 
 		if (beacon) {
+			if (beacon->tail && vif->csa_active)
+				if (ieee80211_update_csa(vif, beacon->tail,
+							 beacon->tail_len))
+					goto out;
+
 			/*
 			 * headroom, head length,
 			 * tail length and maximum TIM length
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 27e0715..f7c710f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -661,6 +661,124 @@ void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_queue_delayed_work);
 
+/*
+ * returns the order number of the element according to
+ * IEEE 802.11-2012 8.3.3.2
+ */
+int ieee80211_beacon_ie_order(int id)
+{
+	switch (id) {
+	case WLAN_EID_SSID:
+		return 4;
+	case WLAN_EID_SUPP_RATES:
+		return 5;
+	case WLAN_EID_FH_PARAMS:
+		return 6;
+	case WLAN_EID_DS_PARAMS:
+		return 7;
+	case WLAN_EID_CF_PARAMS:
+		return 8;
+	case WLAN_EID_IBSS_PARAMS:
+		return 9;
+	case WLAN_EID_TIM:
+		return 10;
+	case WLAN_EID_COUNTRY:
+		return 11;
+	case WLAN_EID_HP_PARAMS:
+		return 12;
+	case WLAN_EID_HP_TABLE:
+		return 13;
+	case WLAN_EID_PWR_CONSTRAINT:
+		return 14;
+	case WLAN_EID_CHANNEL_SWITCH:
+		return 15;
+	case WLAN_EID_QUIET:
+		return 16;
+	case WLAN_EID_IBSS_DFS:
+		return 17;
+	case WLAN_EID_TPC_REPORT:
+		return 18;
+	case WLAN_EID_ERP_INFO:
+		return 19;
+	case WLAN_EID_EXT_SUPP_RATES:
+		return 20;
+	case WLAN_EID_RSN:
+		return 21;
+	case WLAN_EID_QBSS_LOAD:
+		return 22;
+	case WLAN_EID_EDCA_PARAM_SET:
+		return 23;
+	case WLAN_EID_QOS_CAPA:
+		return 24;
+	case WLAN_EID_AP_CHAN_REPORT:
+		return 25;
+	case WLAN_EID_BSS_AVG_ACCESS_DELAY:
+		return 26;
+	case WLAN_EID_ANTENNA_INFO:
+		return 27;
+	case WLAN_EID_BSS_AVAILABLE_CAPACITY:
+		return 28;
+	case WLAN_EID_BSS_AC_ACCESS_DELAY:
+		return 29;
+	case WLAN_EID_MEASUREMENT_PILOT_TX_INFO:
+		return 30;
+	case WLAN_EID_MULTIPLE_BSSID:
+		return 31;
+	case WLAN_EID_RRM_ENABLED_CAPABILITIES:
+		return 32;
+	case WLAN_EID_MOBILITY_DOMAIN:
+		return 33;
+	case WLAN_EID_DSE_REGISTERED_LOCATION:
+		return 34;
+	case WLAN_EID_EXT_CHANSWITCH_ANN:
+		return 35;
+	case WLAN_EID_SUPPORTED_REGULATORY_CLASSES:
+		return 36;
+	case WLAN_EID_HT_CAPABILITY:
+		return 37;
+	case WLAN_EID_HT_OPERATION:
+		return 38;
+	case WLAN_EID_BSS_COEX_2040:
+		return 39;
+	case WLAN_EID_OVERLAP_BSS_SCAN_PARAM:
+		return 40;
+	case WLAN_EID_EXT_CAPABILITY:
+		return 41;
+	case WLAN_EID_FMS_DESCRIPTOR:
+		return 42;
+	case WLAN_EID_QOS_TRAFFIC_CAPABILITY:
+		return 43;
+	case WLAN_EID_TIME_ADVERTISEMENT:
+		return 44;
+	case WLAN_EID_INTERWORKING:
+		return 45;
+	case WLAN_EID_ADVERTISEMENT_PROTOCOL:
+		return 46;
+	case WLAN_EID_ROAMING_CONSORTIUM:
+		return 47;
+	case WLAN_EID_EMERGENCY_ALERT_ID:
+		return 48;
+	case WLAN_EID_MESH_ID:
+		return 49;
+	case WLAN_EID_MESH_CONFIG:
+		return 50;
+	case WLAN_EID_MESH_AWAKE_WINDOW:
+		return 51;
+	case WLAN_EID_BEACON_TIMING:
+		return 52;
+	case WLAN_EID_MCCAOP_ADVERT_OVERVIEW:
+		return 53;
+	case WLAN_EID_MCCAOP_ADVERT:
+		return 54;
+	case WLAN_EID_CHAN_SWITCH_PARAM:
+		return 55;
+	case WLAN_EID_VENDOR_SPECIFIC:
+		return 255;
+	}
+
+	return -1;
+}
+
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc)
@@ -1857,6 +1975,98 @@ size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset)
 	return pos;
 }
 
+u8 *ieee80211_ie_find(u8 *ies, int ielen, u8 eid)
+{
+	int pos = 0;
+
+	while (pos < ielen) {
+		if (ies[pos] == eid) {
+			/* sanity check - warn if buffer is bigger than ies  */
+			if (WARN_ON(ies[pos + 1] > (ielen - pos - 2)))
+				return NULL;
+
+			return &ies[pos];
+		}
+		pos += 2 + ies[pos + 1];
+	}
+	return NULL;
+}
+
+/* remove an IE from a (beacon) ie buffer. */
+int ieee80211_ie_remove(u8 *ies, int *ielen, u8 eid)
+{
+	int cur_ie_len, pos = 0, found = 0;
+
+	while (pos < *ielen) {
+		if (ies[pos] != eid) {
+			pos += 2 + ies[pos + 1];
+			continue;
+		}
+
+		cur_ie_len = ies[pos + 1];
+		/* sanity check */
+		if (WARN_ON(cur_ie_len > (*ielen - pos - 2)))
+			return found;
+
+		*ielen -= 2 + cur_ie_len;
+		if (pos < *ielen)
+			memmove(&ies[pos], &ies[pos + 2 + cur_ie_len],
+				*ielen - pos);
+		found = 1;
+	}
+
+	return found;
+}
+
+/*
+ * add an IE to the beacon information element buffer (ies).
+ * Caller must make sure that enough extra space is available in the
+ * buffer of ies (i.e. must have at leat *ielen + ie_size + 2 allocated).
+ */
+int ieee80211_ie_beacon_insert(u8 *ies, int *ielen, u8 eid, u8 *new_ie,
+			       u8 new_ie_len)
+{
+	int pos = 0;
+	int ie_order, pos_order;
+
+	ie_order = ieee80211_beacon_ie_order(eid);
+	if (WARN_ON(ie_order < 0))
+		return -EINVAL;
+
+	while (pos < *ielen) {
+		pos_order = ieee80211_beacon_ie_order(ies[pos]);
+
+		/* buffer corrupt or unknown EID */
+		if (WARN_ON(pos_order < 0))
+			return -EINVAL;
+
+		/* already present */
+		if (unlikely(pos_order == ie_order))
+			return -EBUSY;
+
+		if (ie_order > pos_order) {
+			/* skip this ie */
+			pos += 2 + ies[pos + 1];
+			continue;
+		}
+
+		break;
+	}
+	/* something was off ... */
+	if (WARN_ON(pos > *ielen))
+		return -1;
+
+	/* insert our IE here. This might be the end of the buffer */
+	if (pos < *ielen)
+		memmove(&ies[pos + 2 + new_ie_len], &ies[pos], *ielen - pos);
+	ies[pos] = eid;
+	ies[pos + 1] = new_ie_len;
+	memcpy(&ies[pos + 2], new_ie, new_ie_len);
+	*ielen += 2 + new_ie_len;
+
+	return 0;
+}
+
 static void _ieee80211_enable_rssi_reports(struct ieee80211_sub_if_data *sdata,
 					    int rssi_min_thold,
 					    int rssi_max_thold)
-- 
1.7.10.4

