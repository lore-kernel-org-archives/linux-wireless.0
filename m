Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EKOVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 10:21:03 -0400
Subject: [PATCH v3 1/2] mac80211: add offload channel switch support
From: Johannes Berg <johannes@sipsolutions.net>
To: wey-yi.w.guy@intel.com, John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1273159552-5579-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1273159552-5579-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 16:20:57 +0200
Message-ID: <1273587657.20312.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for offloading the channel switch
operation to devices that support such, typically
by having specific firmware API for it. The reasons
for this could be that the firmware provides better
timing or that regulatory enforcement done by the
device requires special handling of CSAs.

In order to allow drivers to specify the timing to
the device, the new channel_switch callback will
pass through the received frame's mactime, where
available.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   39 ++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h   |   11 ++++++++
 net/mac80211/driver-trace.h |   49 +++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    3 +-
 net/mac80211/mlme.c         |   56 +++++++++++++++++++++++++++++++++++++++---
 5 files changed, 153 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9448a5b..389e86a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -712,6 +712,28 @@ struct ieee80211_conf {
 };
 
 /**
+ * struct ieee80211_channel_switch - holds the channel switch data
+ *
+ * The information provided in this structure is required for channel switch
+ * operation.
+ *
+ * @timestamp: value in microseconds of the 64-bit Time Synchronization
+ *	Function (TSF) timer when the frame containing the channel switch
+ *	announcement was received. This is simply the rx.mactime parameter
+ *	the driver passed into mac80211.
+ * @block_tx: Indicates whether transmission must be blocked before the
+ *	scheduled channel switch, as indicated by the AP.
+ * @channel: the new channel to switch to
+ * @count: the number of TBTT's until the channel switch event
+ */
+struct ieee80211_channel_switch {
+	u64 timestamp;
+	bool block_tx;
+	struct ieee80211_channel *channel;
+	u8 count;
+};
+
+/**
  * struct ieee80211_vif - per-interface data
  *
  * Data in this structure is continually present for driver
@@ -1631,6 +1653,11 @@ enum ieee80211_ampdu_mlme_action {
  * @flush: Flush all pending frames from the hardware queue, making sure
  *	that the hardware queues are empty. If the parameter @drop is set
  *	to %true, pending frames may be dropped. The callback can sleep.
+ *
+ * @channel_switch: Drivers that need (or want) to offload the channel
+ *	switch operation for CSAs received from the AP may implement this
+ *	callback. They must then call ieee80211_chswitch_done() to indicate
+ *	completion of the channel switch.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1694,6 +1721,8 @@ struct ieee80211_ops {
 	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
 #endif
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
+	void (*channel_switch)(struct ieee80211_hw *hw,
+			       struct ieee80211_channel_switch *ch_switch);
 };
 
 /**
@@ -2444,6 +2473,16 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       enum nl80211_cqm_rssi_threshold_event rssi_event,
 			       gfp_t gfp);
 
+/**
+ * ieee80211_chswitch_done - Complete channel switch process
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @success: make the channel switch successful or not
+ *
+ * Complete the channel switch post-process: set the new operational channel
+ * and wake up the suspended queues.
+ */
+void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 997008e..5662bb5 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -373,4 +373,15 @@ static inline void drv_flush(struct ieee80211_local *local, bool drop)
 	if (local->ops->flush)
 		local->ops->flush(&local->hw, drop);
 }
+
+static inline void drv_channel_switch(struct ieee80211_local *local,
+				     struct ieee80211_channel_switch *ch_switch)
+{
+	might_sleep();
+
+	local->ops->channel_switch(&local->hw, ch_switch);
+
+	trace_drv_channel_switch(local, ch_switch);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index ce734b5..6a9b234 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -774,6 +774,34 @@ TRACE_EVENT(drv_flush,
 	)
 );
 
+TRACE_EVENT(drv_channel_switch,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_channel_switch *ch_switch),
+
+	TP_ARGS(local, ch_switch),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u64, timestamp)
+		__field(bool, block_tx)
+		__field(u16, freq)
+		__field(u8, count)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->timestamp = ch_switch->timestamp;
+		__entry->block_tx = ch_switch->block_tx;
+		__entry->freq = ch_switch->channel->center_freq;
+		__entry->count = ch_switch->count;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " new freq:%u count:%d",
+		LOCAL_PR_ARG, __entry->freq, __entry->count
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
@@ -992,6 +1020,27 @@ TRACE_EVENT(api_sta_block_awake,
 	)
 );
 
+TRACE_EVENT(api_chswitch_done,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata, bool success),
+
+	TP_ARGS(sdata, success),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+		__field(bool, success)
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+		__entry->success = success;
+	),
+
+	TP_printk(
+		VIF_PR_FMT " success=%d",
+		VIF_PR_ARG, __entry->success
+	)
+);
+
 /*
  * Tracing for internal functions
  * (which may also be called in response to driver calls)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 69e7f41..1c8e247 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -999,7 +999,8 @@ int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
 void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_channel_sw_ie *sw_elem,
-				      struct ieee80211_bss *bss);
+				      struct ieee80211_bss *bss,
+				      u64 timestamp);
 void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3093e46..b2f7f9f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -342,7 +342,11 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		goto out;
 
 	sdata->local->oper_channel = sdata->local->csa_channel;
-	ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (!sdata->local->ops->channel_switch) {
+		/* call "hw_config" only if doing sw channel switch */
+		ieee80211_hw_config(sdata->local,
+			IEEE80211_CONF_CHANGE_CHANNEL);
+	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
 	ifmgd->associated->channel = sdata->local->oper_channel;
@@ -354,6 +358,29 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	mutex_unlock(&ifmgd->mtx);
 }
 
+void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_managed *ifmgd;
+
+	sdata = vif_to_sdata(vif);
+	ifmgd = &sdata->u.mgd;
+
+	trace_api_chswitch_done(sdata, success);
+	if (!success) {
+		/*
+		 * If the channel switch was not successful, stay
+		 * around on the old channel. We currently lack
+		 * good handling of this situation, possibly we
+		 * should just drop the association.
+		 */
+		sdata->local->csa_channel = sdata->local->oper_channel;
+	}
+
+	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
+}
+EXPORT_SYMBOL(ieee80211_chswitch_done);
+
 static void ieee80211_chswitch_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -370,7 +397,8 @@ static void ieee80211_chswitch_timer(unsigned long data)
 
 void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_channel_sw_ie *sw_elem,
-				      struct ieee80211_bss *bss)
+				      struct ieee80211_bss *bss,
+				      u64 timestamp)
 {
 	struct cfg80211_bss *cbss =
 		container_of((void *)bss, struct cfg80211_bss, priv);
@@ -398,6 +426,24 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	sdata->local->csa_channel = new_ch;
 
+	if (sdata->local->ops->channel_switch) {
+		/* use driver's channel switch callback */
+		struct ieee80211_channel_switch ch_switch;
+		memset(&ch_switch, 0, sizeof(ch_switch));
+		ch_switch.timestamp = timestamp;
+		if (sw_elem->mode) {
+			ch_switch.block_tx = true;
+			ieee80211_stop_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+		}
+		ch_switch.channel = new_ch;
+		ch_switch.count = sw_elem->count;
+		ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
+		drv_channel_switch(sdata->local, &ch_switch);
+		return;
+	}
+
+	/* channel switch handled in software */
 	if (sw_elem->count <= 1) {
 		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 	} else {
@@ -1317,7 +1363,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 							ETH_ALEN) == 0)) {
 		struct ieee80211_channel_sw_ie *sw_elem =
 			(struct ieee80211_channel_sw_ie *)elems->ch_switch_elem;
-		ieee80211_sta_process_chanswitch(sdata, sw_elem, bss);
+		ieee80211_sta_process_chanswitch(sdata, sw_elem,
+						 bss, rx_status->mactime);
 	}
 }
 
@@ -1649,7 +1696,8 @@ static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 			ieee80211_sta_process_chanswitch(sdata,
 					&mgmt->u.action.u.chan_switch.sw_elem,
-					(void *)ifmgd->associated->priv);
+					(void *)ifmgd->associated->priv,
+					rx_status->mactime);
 			break;
 		}
 		mutex_unlock(&ifmgd->mtx);
-- 
1.7.0.5



