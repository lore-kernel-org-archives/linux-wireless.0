Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39003 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab2LMN7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:59:09 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 7/8] mac80211: add ap channel switch command/event
Date: Thu, 13 Dec 2012 14:58:32 +0100
Message-Id: <1355407113-27006-8-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121213_145922_906219_35199C40)
In-Reply-To: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Add ieee80211_ap_process_chanswitch(), to handle a channel switch
request for AP.

Add ieee80211_ap_ch_switch_done() which updates oper_channel
and notifies upper layers about channel switch complete event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
[changes:
 * change to chandef
 * fix channel switch notify
 * document ap_channel_switch()
 * stop AP
 * rebased on latest master]
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/mac80211.h     |   27 ++++++++++++++++
 net/mac80211/cfg.c         |   27 ++++++++++++++++
 net/mac80211/driver-ops.h  |   12 +++++++
 net/mac80211/ieee80211_i.h |    4 +++
 net/mac80211/iface.c       |    2 ++
 net/mac80211/main.c        |    2 ++
 net/mac80211/mlme.c        |   66 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h       |   75 ++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 215 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b9186f4..a7b17cf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2358,6 +2358,13 @@ enum ieee80211_rate_control_changed {
  *	callback. They must then call ieee80211_chswitch_done() to indicate
  *	completion of the channel switch.
  *
+ * @ap_channel_switch: Announce a channel switch in the beacons according to the
+ *	parameters passed. The driver must add the CSA IE in the beacon and
+ *	decrement the TBTT with each beacon sent (for details, see
+ *	IEEE 802.11-2012 8.4.2.21). The CSA IE must be set in the beacon before
+ *	calling this function. After completion, ieee80211_ap_ch_switch_done()
+ *	must be called by the driver to finalize the switch.
+ *
  * @napi_poll: Poll Rx queue for incoming data frames.
  *
  * @set_antenna: Set antenna configuration (tx_ant, rx_ant) on the device.
@@ -2594,6 +2601,8 @@ struct ieee80211_ops {
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
+	int (*ap_channel_switch)(struct ieee80211_hw *hw,
+				 struct ieee80211_ap_ch_switch *ap_ch_switch);
 	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
 	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
@@ -3891,6 +3900,24 @@ void ieee80211_radar_detected(struct ieee80211_vif *vif,
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
+				 struct cfg80211_chan_def *chandef);
+
+/**
  * ieee80211_chswitch_done - Complete channel switch process
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @success: make the channel switch successful or not
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9c190c5..394b989 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2586,6 +2586,32 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	return res;
 }
 
+static int
+ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
+				struct net_device *dev,
+				struct ieee80211_ap_ch_switch *ap_ch_switch)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	if (!local->ops->ap_channel_switch)
+		return -EOPNOTSUPP;
+
+	if (!ap_ch_switch || !ap_ch_switch->chandef.chan)
+		return -EINVAL;
+
+	if (local->ap_cs_chandef.chan)
+		return -EBUSY;
+
+	local->ap_cs_chandef = ap_ch_switch->chandef;
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
 			     unsigned int wait, const u8 *buf, size_t len,
@@ -3291,4 +3317,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.ap_channel_switch = ieee80211_ap_process_chanswitch,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f703dfc..4a2f17d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -726,6 +726,18 @@ static inline void drv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int
+drv_ap_channel_switch(struct ieee80211_local *local,
+		      struct ieee80211_ap_ch_switch *ap_ch_switch)
+{
+	int ret = -EOPNOTSUPP;
+	might_sleep();
+	trace_drv_ap_channel_switch(local, ap_ch_switch);
+	if (local->ops->ap_channel_switch)
+		ret = local->ops->ap_channel_switch(&local->hw, ap_ch_switch);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
 
 static inline int drv_set_antenna(struct ieee80211_local *local,
 				  u32 tx_ant, u32 rx_ant)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index abb2759..3d1938e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -302,6 +302,7 @@ struct ieee80211_if_ap {
 
 	struct ps_data ps;
 	atomic_t num_mcast_sta; /* number of stations receiving multicast */
+	struct work_struct ap_ch_sw_work;
 };
 
 struct ieee80211_if_wds {
@@ -830,6 +831,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	IEEE80211_QUEUE_STOP_REASON_CH_SW,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -1051,6 +1053,8 @@ struct ieee80211_local {
 	struct ieee80211_channel *_oper_channel;
 	enum nl80211_channel_type _oper_channel_type;
 
+	struct cfg80211_chan_def ap_cs_chandef;
+
 	/* Temporary remain-on-channel for off-channel operations */
 	struct ieee80211_channel *tmp_channel;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2895cd8..d5c7603 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1237,6 +1237,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 		skb_queue_head_init(&sdata->u.ap.ps.bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
+		INIT_WORK(&sdata->u.ap.ap_ch_sw_work,
+			  ieee80211_ap_ch_switch_work);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 		type = NL80211_IFTYPE_STATION;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1b087ff..efa3eef 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -612,6 +612,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
 				   NL80211_FEATURE_AP_SCAN;
 
+	if (ops->ap_channel_switch)
+		wiphy->features |= NL80211_FEATURE_AP_CH_SWITCH;
 
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a734036..8966627 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4067,3 +4067,69 @@ void ieee80211_radar_detected(struct ieee80211_vif *vif,
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
+	bool stop_ap = false;
+
+	/* announce where we are now. */
+	if (!local->ap_cs_chandef.chan)
+		goto announce;
+
+	mutex_lock(&local->mtx);
+	if (local->ap_cs_chandef.chan->flags & IEEE80211_CHAN_RADAR) {
+		sdata_info(sdata, "changing to DFS channel\n");
+		/* when changing to a DFS channel, stop AP. Userspace must
+		 * restart AP or do start radar detection first.
+		 */
+		stop_ap = true;
+	} else {
+		/* update the device channel directly */
+		sdata_info(sdata, "changing to non-DFS channel\n");
+
+		/* TODO: _oper_channel is deprecated ... use
+		 * vif_release/use_channel instead? In this case, we must make
+		 * sure that interface is down first ...
+		 */
+		local->_oper_channel = local->ap_cs_chandef.chan;
+		local->hw.conf.channel = local->ap_cs_chandef.chan;
+		local->_oper_channel_type =
+			cfg80211_get_chandef_type(&local->ap_cs_chandef);
+		ieee80211_hw_config(sdata->local,
+				    IEEE80211_CONF_CHANGE_CHANNEL);
+		ieee80211_wake_queues_by_reason(&local->hw,
+				IEEE80211_QUEUE_STOP_REASON_CH_SW);
+
+	}
+
+	sdata->vif.bss_conf.chandef = local->ap_cs_chandef;
+	local->ap_cs_chandef.chan = NULL;
+
+	mutex_unlock(&local->mtx);
+
+ announce:
+	cfg80211_ch_switch_notify(sdata->dev, &sdata->vif.bss_conf.chandef,
+				  stop_ap);
+}
+
+void ieee80211_ap_ch_switch_done(struct ieee80211_vif *vif,
+				 struct cfg80211_chan_def *new_chandef)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
+		return;
+
+	if (WARN_ON(!cfg80211_chandef_identical(&local->ap_cs_chandef,
+						new_chandef)))
+		return;
+
+	trace_api_ap_ch_switch_done(sdata, new_chandef);
+	schedule_work(&sdata->u.ap.ap_ch_sw_work);
+}
+EXPORT_SYMBOL(ieee80211_ap_ch_switch_done);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 2c73982..6264b43 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -45,6 +45,35 @@
 			__entry->center_freq1, __entry->center_freq2,		\
 			__entry->rx_chains_static, __entry->rx_chains_dynamic
 
+#define CHAN_DEF_ENTRY __field(enum ieee80211_band, band)		\
+		       __field(u32, control_freq)			\
+		       __field(u32, width)				\
+		       __field(u32, center_freq1)			\
+		       __field(u32, center_freq2)
+#define CHAN_DEF_ASSIGN(chandef)					\
+	do {								\
+		if ((chandef) && (chandef)->chan) {			\
+			__entry->band = (chandef)->chan->band;		\
+			__entry->control_freq =				\
+				(chandef)->chan->center_freq;		\
+			__entry->width = (chandef)->width;		\
+			__entry->center_freq1 = (chandef)->center_freq1;\
+			__entry->center_freq2 = (chandef)->center_freq2;\
+		} else {						\
+			__entry->band = 0;				\
+			__entry->control_freq = 0;			\
+			__entry->width = 0;				\
+			__entry->center_freq1 = 0;			\
+			__entry->center_freq2 = 0;			\
+		}							\
+	} while (0)
+#define CHAN_DEF_PR_FMT							\
+	"band: %d, control freq: %u, width: %d, cf1: %u, cf2: %u"
+#define CHAN_DEF_PR_ARG __entry->band, __entry->control_freq,		\
+			__entry->width, __entry->center_freq1,		\
+			__entry->center_freq2
+
+
 
 
 /*
@@ -1861,6 +1890,52 @@ TRACE_EVENT(drv_start_radar_detection,
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
+		CHAN_DEF_ENTRY
+		__field(u8, count)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		CHAN_DEF_ASSIGN(&ap_ch_switch->chandef);
+		__entry->count = ap_ch_switch->count;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " switching to :" CHAN_DEF_PR_FMT " count:%d",
+		LOCAL_PR_ARG, CHAN_DEF_PR_ARG, __entry->count
+	)
+);
+
+TRACE_EVENT(api_ap_ch_switch_done,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_chan_def *chandef),
+
+	TP_ARGS(sdata, chandef),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+		CHAN_DEF_ENTRY
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+	),
+
+	TP_printk(
+		VIF_PR_FMT ", " CHAN_DEF_PR_FMT,
+		VIF_PR_ARG, CHAN_DEF_PR_ARG
+	)
+)
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
-- 
1.7.10.4

