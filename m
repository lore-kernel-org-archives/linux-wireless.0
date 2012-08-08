Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:47082 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757589Ab2HHMAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:00:47 -0400
Received: by obbwc20 with SMTP id wc20so1277921obb.31
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:00:41 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 6/7] mac80211: add ap channel switch command/event
Date: Wed,  8 Aug 2012 14:53:42 +0300
Message-Id: <1344426823-1795-7-git-send-email-victorg@ti.com> (sfid-20120808_140100_535903_895570CB)
In-Reply-To: <1344426823-1795-1-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ieee80211_ap_process_chanswitch(), to handle a channel switch
request for AP.

Add ieee80211_ap_ch_switch_done() which updates oper_channel
and notifies upper layers about channel switch complete event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h    |   14 ++++++++++++
 net/mac80211/cfg.c        |   19 ++++++++++++++++
 net/mac80211/driver-ops.h |   10 ++++++++
 net/mac80211/main.c       |    3 ++
 net/mac80211/mlme.c       |   21 +++++++++++++++++
 net/mac80211/trace.h      |   53 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 120 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ecdfb6a..3cefafa 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2368,6 +2368,8 @@ struct ieee80211_ops {
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
+	void (*ap_channel_switch)(struct ieee80211_hw *hw,
+				  struct ieee80211_ap_ch_switch *ap_ch_switch);
 	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
 	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
@@ -3599,6 +3601,18 @@ void ieee80211_radar_detected(struct ieee80211_vif *vif,
 			      struct ieee80211_channel *chan, gfp_t gfp);
 
 /**
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
index eb18868..5dbc17a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2432,6 +2432,24 @@ static int ieee80211_dfs_en_tx(struct wiphy *wiphy, struct net_device *dev,
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
+	drv_ap_channel_switch(local, ap_ch_switch);
+	return 0;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
@@ -3106,4 +3124,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
 	.dfs_en_tx = ieee80211_dfs_en_tx,
+	.ap_channel_switch = ieee80211_ap_process_chanswitch,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 04a9168..e22149e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -703,6 +703,16 @@ static inline void drv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void
+drv_ap_channel_switch(struct ieee80211_local *local,
+		      struct ieee80211_ap_ch_switch *ap_ch_switch)
+{
+	might_sleep();
+
+	trace_drv_ap_channel_switch(local, ap_ch_switch);
+	local->ops->ap_channel_switch(&local->hw, ap_ch_switch);
+	trace_drv_return_void(local);
+}
 
 static inline int drv_set_antenna(struct ieee80211_local *local,
 				  u32 tx_ant, u32 rx_ant)
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c26e231..df985b2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -577,6 +577,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	wiphy->features = NL80211_FEATURE_SK_TX_STATUS |
 			  NL80211_FEATURE_HT_IBSS;
 
+	if (ops->ap_channel_switch)
+		wiphy->features |= NL80211_FEATURE_AP_CH_SWITCH;
+
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2d87c5b..d1de8f1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3560,3 +3560,24 @@ void ieee80211_radar_detected(struct ieee80211_vif *vif,
 	cfg80211_radar_detected(sdata->dev, chan, gfp);
 }
 EXPORT_SYMBOL(ieee80211_radar_detected);
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
+	/* update the device channel directly */
+	mutex_lock(&local->mtx);
+	local->oper_channel = local->hw.conf.channel = new_channel;
+	local->_oper_channel_type = type;
+	mutex_unlock(&local->mtx);
+
+	cfg80211_ch_switch_notify(sdata->dev, new_channel->center_freq, type);
+	trace_api_ap_ch_switch_done(sdata, new_channel->center_freq);
+}
+EXPORT_SYMBOL(ieee80211_ap_ch_switch_done);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 2ef4731..d9de352 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -929,6 +929,37 @@ TRACE_EVENT(drv_channel_switch,
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
+		__field(u64, timestamp)
+		__field(bool, block_tx)
+		__field(bool, post_switch_block_tx)
+		__field(u16, freq)
+		__field(u8, count)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->timestamp = ap_ch_switch->timestamp;
+		__entry->block_tx = ap_ch_switch->block_tx;
+		__entry->post_switch_block_tx =
+			ap_ch_switch->post_switch_block_tx;
+		__entry->freq = ap_ch_switch->channel->center_freq;
+		__entry->count = ap_ch_switch->count;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " new freq:%u count:%d",
+		LOCAL_PR_ARG, __entry->freq, __entry->count
+	)
+);
+
 TRACE_EVENT(drv_set_antenna,
 	TP_PROTO(struct ieee80211_local *local, u32 tx_ant, u32 rx_ant, int ret),
 
@@ -1422,6 +1453,28 @@ TRACE_EVENT(api_cqm_rssi_notify,
 	)
 );
 
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
+		VIF_PR_FMT " switched to new freq:%d",
+		VIF_PR_ARG, __entry->center_freq
+	)
+)
+
 TRACE_EVENT(api_radar_detected,
 	TP_PROTO(struct ieee80211_sub_if_data *sdata,
 		 u16 center_freq),
-- 
1.7.5.4

