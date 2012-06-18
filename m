Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:43107 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265Ab2FROuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 10:50:21 -0400
Received: by obbwc20 with SMTP id wc20so8492069obb.31
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 07:50:16 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH 6/7] mac80211: add ap channel switch command/event
Date: Mon, 18 Jun 2012 17:46:37 +0300
Message-Id: <1340030798-28992-7-git-send-email-victorg@ti.com> (sfid-20120618_165025_157337_DFC8F7C4)
In-Reply-To: <1340030798-28992-1-git-send-email-victorg@ti.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ieee80211_ap_process_chanswitch(), to handle a channel switch
request for AP/GO.

Add ieee80211_ap_ch_switch_complete_notify() which notifies upper
layers about channel switch complete event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h      |   39 +++++++++++++++++++++++++++++++++++++++
 net/mac80211/cfg.c          |   26 ++++++++++++++++++++++++++
 net/mac80211/driver-ops.h   |    9 +++++++++
 net/mac80211/driver-trace.h |   31 +++++++++++++++++++++++++++++++
 net/mac80211/main.c         |    3 +++
 net/mac80211/mlme.c         |    9 +++++++++
 6 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 82e5ee7..79239a0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -865,6 +865,32 @@ struct ieee80211_channel_switch {
 };
 
 /**
+ * struct ieee80211_ap_channel_switch - holds the ap channel switch data
+ *
+ * The information provided in this structure is required for the ap channel
+ * switch operation.
+ *
+ * @timestamp: value in microseconds of the 64-bit Time Synchronization
+ *	Function (TSF) timer when the frame containing the channel switch
+ *	announcement was received. This is simply the rx.mactime parameter
+ *	the driver passed into mac80211.
+ * @block_tx: Indicates whether transmission must be blocked before the
+ *	scheduled channel switch, as indicated by the AP.
+ * @post_switch_block_tx: Indicates whether transmission must be blocked after
+ *	the scheduled channel switch, this should be set if the target channel
+ *	is DFS channel.
+ * @channel: the new channel to switch to
+ * @count: the number of TBTT's until the channel switch event
+ */
+struct ieee80211_ap_channel_switch {
+	u64 timestamp;
+	bool block_tx;
+	bool post_switch_block_tx;
+	struct ieee80211_channel *channel;
+	u8 count;
+};
+
+/**
  * enum ieee80211_vif_flags - virtual interface flags
  *
  * @IEEE80211_VIF_BEACON_FILTER: the device performs beacon filtering
@@ -2354,6 +2380,8 @@ struct ieee80211_ops {
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
+	void (*ap_channel_switch)(struct ieee80211_hw *hw,
+			      struct ieee80211_ap_channel_switch *ap_ch_switch);
 	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
 	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
@@ -3578,6 +3606,17 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 void ieee80211_radar_detected(struct ieee80211_vif *vif, u16 freq, gfp_t gfp);
 
 /**
+ * ieee80211_ap_ch_switch_complete_notify - inform a configured connection that
+ * channel switch is complete
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @gfp: context flags
+ *
+ */
+void ieee80211_ap_ch_switch_complete_notify(struct ieee80211_vif *vif,
+					    u16 freq, gfp_t gfp);
+
+/**
  * ieee80211_get_operstate - get the operstate of the vif
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a48d055..d017972 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2240,6 +2240,31 @@ static int ieee80211_dfs_en_tx(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static int ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   u32 count, bool block_tx,
+					   bool post_switch_block_tx,
+					   struct ieee80211_channel *new_ch)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_ap_channel_switch ap_ch_switch;
+
+	if (!local->ops->channel_switch)
+		return -EOPNOTSUPP;
+
+	memset(&ap_ch_switch, 0, sizeof(ap_ch_switch));
+	ap_ch_switch.channel = new_ch;
+	ap_ch_switch.count = count;
+	ap_ch_switch.block_tx = block_tx;
+	ap_ch_switch.post_switch_block_tx = post_switch_block_tx;
+
+	mutex_lock(&local->mtx);
+	drv_ap_channel_switch(local, &ap_ch_switch);
+	mutex_unlock(&local->mtx);
+	return 0;
+}
+
 static enum work_done_result
 ieee80211_offchan_tx_done(struct ieee80211_work *wk, struct sk_buff *skb)
 {
@@ -3010,4 +3035,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.start_radar_detection = ieee80211_start_radar_detection,
 	.dfs_en_tx = ieee80211_dfs_en_tx,
+	.ap_channel_switch = ieee80211_ap_process_chanswitch,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f49b76b..402f46e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -711,6 +711,15 @@ static inline void drv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_ap_channel_switch(struct ieee80211_local *local,
+			       struct ieee80211_ap_channel_switch *ap_ch_switch)
+{
+	might_sleep();
+
+	trace_drv_ap_channel_switch(local, ap_ch_switch);
+	local->ops->ap_channel_switch(&local->hw, ap_ch_switch);
+	trace_drv_return_void(local);
+}
 
 static inline int drv_set_antenna(struct ieee80211_local *local,
 				  u32 tx_ant, u32 rx_ant)
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6df02c4..972be66 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -927,6 +927,37 @@ TRACE_EVENT(drv_channel_switch,
 	)
 );
 
+TRACE_EVENT(drv_ap_channel_switch,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_ap_channel_switch *ap_ch_switch),
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
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f5548e9..18094cc 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -567,6 +567,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	wiphy->features = NL80211_FEATURE_SK_TX_STATUS |
 			  NL80211_FEATURE_HT_IBSS;
 
+	if (ops->ap_channel_switch)
+		wiphy->features |= NL80211_FEATURE_AP_CH_SWITCH;
+
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 37ed827..ab7e430 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3570,6 +3570,15 @@ void ieee80211_radar_detected(struct ieee80211_vif *vif, u16 freq, gfp_t gfp)
 }
 EXPORT_SYMBOL(ieee80211_radar_detected);
 
+void ieee80211_ap_ch_switch_complete_notify(struct ieee80211_vif *vif,
+					    u16 freq, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_ap_ch_switch_complete_notify(sdata->dev, freq, gfp);
+}
+EXPORT_SYMBOL(ieee80211_ap_ch_switch_complete_notify);
+
 unsigned char ieee80211_get_operstate(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-- 
1.7.5.4

