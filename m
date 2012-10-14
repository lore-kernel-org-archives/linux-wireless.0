Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34474 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab2JNOzs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 10:55:48 -0400
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v4 2/6] mac80211: add radar detection command/event
Date: Sun, 14 Oct 2012 16:48:53 +0200
Message-ID: <1350226137-13704-3-git-send-email-victorg@ti.com> (sfid-20121014_165558_414548_D7091159)
In-Reply-To: <1350226137-13704-1-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to trigger radar detection in the driver/FW.
Once radar detection is started it should continuously
monitor for radars as long as the channel active.
If radar is detected usermode notified with 'radar
detected' event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h    |   19 ++++++++++++++++++
 net/mac80211/cfg.c        |   14 +++++++++++++
 net/mac80211/driver-ops.h |   14 +++++++++++++
 net/mac80211/iface.c      |    5 ++++
 net/mac80211/mlme.c       |   11 ++++++++++
 net/mac80211/trace.h      |   46 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 82558c8..67f932d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2317,6 +2317,10 @@ enum ieee80211_rate_control_changed {
  *	The callback will be called before each transmission and upon return
  *	mac80211 will transmit the frame right away.
  *	The callback is optional and can (should!) sleep.
+ *
+ * @start_radar_detection: Start radar detection on current operational
+ *	channel, once started it will continuously monitor for radars as long
+ *	as the channel active. This callback can sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2461,6 +2465,10 @@ struct ieee80211_ops {
 
 	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif);
+
+	int (*start_radar_detection)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_channel *chan);
 };
 
 /**
@@ -3633,6 +3641,17 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       gfp_t gfp);
 
 /**
+ * ieee80211_radar_detected - inform a configured connection that
+ * radar was detected on the current channel
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @chan: radar detected on this channel.
+ * @gfp: context flags.
+ */
+void ieee80211_radar_detected(struct ieee80211_vif *vif,
+			      struct ieee80211_channel *chan, gfp_t gfp);
+
+/**
  * ieee80211_chswitch_done - Complete channel switch process
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @success: make the channel switch successful or not
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 05f3a31..a6c5369 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2446,6 +2446,19 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ieee80211_cancel_roc(local, cookie, false);
 }
 
+static int ieee80211_start_radar_detection(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   struct ieee80211_channel *chan)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	if (!local->ops->start_radar_detection)
+		return -EOPNOTSUPP;
+
+	return drv_start_radar_detection(local, sdata, chan);
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
@@ -3131,4 +3144,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_stats = ieee80211_get_et_stats,
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
+	.start_radar_detection = ieee80211_start_radar_detection,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index da9003b..dfb992e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -323,6 +323,20 @@ static inline void drv_cancel_hw_scan(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_start_radar_detection(struct ieee80211_local *local,
+					    struct ieee80211_sub_if_data *sdata,
+					    struct ieee80211_channel *chan)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_start_radar_detection(local, chan);
+	ret = local->ops->start_radar_detection(&local->hw, &sdata->vif, chan);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int
 drv_sched_scan_start(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6f8a73c..02a8382 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -757,6 +757,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/* free all potentially still buffered bcast frames */
 		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps_bc_buf);
 		skb_queue_purge(&sdata->u.ap.ps_bc_buf);
+
+		/* reset DFS channel availability check */
+		if (local->oper_channel)
+			local->oper_channel->cac_started = false;
+
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
 	}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e714ed8..208b835 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3650,3 +3650,14 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, gfp);
 }
 EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
+
+void ieee80211_radar_detected(struct ieee80211_vif *vif,
+			      struct ieee80211_channel *chan, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	trace_api_radar_detected(sdata, chan->center_freq);
+
+	cfg80211_radar_detected(sdata->dev, chan, gfp);
+}
+EXPORT_SYMBOL(ieee80211_radar_detected);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 18d9c8a..cbebd52 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1645,6 +1645,52 @@ TRACE_EVENT(stop_queue,
 	)
 );
 
+TRACE_EVENT(api_radar_detected,
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
+		VIF_PR_FMT " radar on freq:%d",
+		VIF_PR_ARG, __entry->center_freq
+	)
+)
+
+TRACE_EVENT(drv_start_radar_detection,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_channel *chan),
+
+	TP_ARGS(local, chan),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u16, freq)
+		__field(int, cac_type)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->freq = chan->center_freq;
+		__entry->cac_type = chan->cac_type;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " start radar detection on freq:%u cac_type:%d",
+		LOCAL_PR_ARG, __entry->freq, __entry->cac_type
+	)
+);
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
-- 
1.7.5.4

