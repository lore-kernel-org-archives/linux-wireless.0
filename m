Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41343 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab2JNO4I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 10:56:08 -0400
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v4 6/6] mac80211: add ap channel switch command/event
Date: Sun, 14 Oct 2012 16:48:57 +0200
Message-ID: <1350226137-13704-7-git-send-email-victorg@ti.com> (sfid-20121014_165618_503092_A21E6EB3)
In-Reply-To: <1350226137-13704-1-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ieee80211_ap_process_chanswitch(), to handle a channel switch
request for AP.

Add ieee80211_ap_ch_switch_done() which updates oper_channel
and notifies upper layers about channel switch complete event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h     |   21 ++++++++++++++++++++
 net/mac80211/cfg.c         |   28 ++++++++++++++++++++++++++
 net/mac80211/driver-ops.h  |   12 +++++++++++
 net/mac80211/ieee80211_i.h |    4 +++
 net/mac80211/iface.c       |    2 +
 net/mac80211/main.c        |    3 ++
 net/mac80211/mlme.c        |   42 ++++++++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h       |   46 ++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 158 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 725018f..48ea3b5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2426,6 +2426,8 @@ struct ieee80211_ops {
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
+	int (*ap_channel_switch)(struct ieee80211_hw *hw,
+				 struct ieee80211_ap_ch_switch *ap_ch_switch);
 	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
 	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
@@ -3657,6 +3659,25 @@ void ieee80211_radar_detected(struct ieee80211_vif *vif,
 			      struct ieee80211_channel *chan, gfp_t gfp);
 
 /**
+ * ieee80211_ap_ch_switch_done_work - ap channel switch complete work.
+ *
+ * @work: the channel switch complete work
+ */
+void ieee80211_ap_ch_switch_work(struct work_struct *work);
+
+/**
+ * ieee80211_ap_ch_switch_done - inform and update a configured connection
+ * that channel switch is complete.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @new_channel: the new channel.
+ * @type: new channe ltype.
+ */
+void ieee80211_ap_ch_switch_done(struct ieee80211_vif *vif,
+				 struct ieee80211_channel *new_channel,
+				 enum nl80211_channel_type type);
+
+/**
  * ieee80211_chswitch_done - Complete channel switch process
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @success: make the channel switch successful or not
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b706232..5fbcdcf 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2473,6 +2473,33 @@ static int ieee80211_dfs_en_tx(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static int
+ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
+				struct net_device *dev,
+				struct ieee80211_ap_ch_switch *ap_ch_switch)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	if (!local->ops->channel_switch)
+		return -EOPNOTSUPP;
+
+	if (!ap_ch_switch || !ap_ch_switch->channel)
+		return -EINVAL;
+
+	if (local->ap_cs_channel)
+		return -EBUSY;
+
+	local->ap_cs_channel = ap_ch_switch->channel;
+	local->ap_cs_type = ap_ch_switch->channel_type;
+
+	ieee80211_stop_queues_by_reason(&local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CH_SW);
+
+	drv_ap_channel_switch(local, ap_ch_switch);
+	return 0;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
@@ -3160,4 +3187,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
 	.dfs_en_tx = ieee80211_dfs_en_tx,
+	.ap_channel_switch = ieee80211_ap_process_chanswitch,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index bca55a3..5042a12 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -708,6 +708,18 @@ static inline void drv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int
+drv_ap_channel_switch(struct ieee80211_local *local,
+		      struct ieee80211_ap_ch_switch *ap_ch_switch)
+{
+	int ret = -EOPNOTSUPP;
+	might_sleep();
+	trace_drv_ap_channel_switch(local, ap_ch_switch);
+	if (local->ops->channel_switch)
+		ret = local->ops->ap_channel_switch(&local->hw, ap_ch_switch);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
 
 static inline int drv_set_antenna(struct ieee80211_local *local,
 				  u32 tx_ant, u32 rx_ant)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8c80455..08c12fc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -295,6 +295,7 @@ struct ieee80211_if_ap {
 	atomic_t num_mcast_sta; /* number of stations receiving multicast */
 	int dtim_count;
 	bool dtim_bc_mc;
+	struct work_struct ap_ch_sw_work;
 };
 
 struct ieee80211_if_wds {
@@ -772,6 +773,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	IEEE80211_QUEUE_STOP_REASON_CH_SW,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -982,6 +984,8 @@ struct ieee80211_local {
 	struct ieee80211_sub_if_data __rcu *scan_sdata;
 	enum nl80211_channel_type _oper_channel_type;
 	struct ieee80211_channel *oper_channel, *csa_channel;
+	struct ieee80211_channel *ap_cs_channel;
+	enum nl80211_channel_type ap_cs_type;
 
 	/* Temporary remain-on-channel for off-channel operations */
 	struct ieee80211_channel *tmp_channel;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 02a8382..f18fad7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1164,6 +1164,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
+		INIT_WORK(&sdata->u.ap.ap_ch_sw_work,
+			ieee80211_ap_ch_switch_work);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 		type = NL80211_IFTYPE_STATION;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c80c449..3b440d8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -587,6 +587,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	wiphy->features = NL80211_FEATURE_SK_TX_STATUS |
 			  NL80211_FEATURE_HT_IBSS;
 
+	if (ops->ap_channel_switch)
+		wiphy->features |= NL80211_FEATURE_AP_CH_SWITCH;
+
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 208b835..25ec150 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3661,3 +3661,45 @@ void ieee80211_radar_detected(struct ieee80211_vif *vif,
 	cfg80211_radar_detected(sdata->dev, chan, gfp);
 }
 EXPORT_SYMBOL(ieee80211_radar_detected);
+
+void ieee80211_ap_ch_switch_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.ap.ap_ch_sw_work);
+	struct ieee80211_local *local = sdata->local;
+
+	/* update the device channel directly */
+	mutex_lock(&local->mtx);
+	if (local->ap_cs_channel) {
+		local->oper_channel =
+			local->hw.conf.channel = local->ap_cs_channel;
+		local->_oper_channel_type =  local->ap_cs_type;
+		local->ap_cs_channel = NULL;
+	}
+
+	ieee80211_wake_queues_by_reason(&local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CH_SW);
+	mutex_unlock(&local->mtx);
+
+	cfg80211_ch_switch_notify(sdata->dev, local->oper_channel->center_freq,
+				  local->_oper_channel_type);
+}
+
+void ieee80211_ap_ch_switch_done(struct ieee80211_vif *vif,
+				 struct ieee80211_channel *new_channel,
+				 enum nl80211_channel_type type)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
+		return;
+
+	if (WARN_ON(local->ap_cs_channel != new_channel))
+		return;
+
+	trace_api_ap_ch_switch_done(sdata, new_channel->center_freq);
+	schedule_work(&sdata->u.ap.ap_ch_sw_work);
+}
+EXPORT_SYMBOL(ieee80211_ap_ch_switch_done);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index e6e066e..e12f243 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1715,6 +1715,52 @@ TRACE_EVENT(drv_dfs_en_tx,
 	)
 );
 
+TRACE_EVENT(drv_ap_channel_switch,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_ap_ch_switch *ap_ch_switch),
+
+	TP_ARGS(local, ap_ch_switch),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u16, freq)
+		__field(u8, count)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->freq = ap_ch_switch->channel->center_freq;
+		__entry->count = ap_ch_switch->count;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " switching to freq:%u count:%d",
+		LOCAL_PR_ARG, __entry->freq, __entry->count
+	)
+);
+
+TRACE_EVENT(api_ap_ch_switch_done,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata,
+		 u16 center_freq),
+
+	TP_ARGS(sdata, center_freq),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+		__field(u16, center_freq)
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+		__entry->center_freq = center_freq;
+	),
+
+	TP_printk(
+		VIF_PR_FMT " switched to freq:%d",
+		VIF_PR_ARG, __entry->center_freq
+	)
+)
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
-- 
1.7.5.4

