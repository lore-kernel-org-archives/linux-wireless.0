Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49482 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755879Ab2HHMAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:00:22 -0400
Received: by obbtb18 with SMTP id tb18so1454122obb.21
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:00:21 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 2/7] mac80211: add radar detection command/event
Date: Wed,  8 Aug 2012 14:53:38 +0300
Message-Id: <1344426823-1795-3-git-send-email-victorg@ti.com> (sfid-20120808_140051_352679_E9F33592)
In-Reply-To: <1344426823-1795-1-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to trigger radar detection in the driver/FW.
Once radar detection is started it should continuously
monitor for radars as long as the channel active.
If radar is detected usermode notified with 'radar
detected' event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h    |   19 +++++++++++++++++++
 net/mac80211/cfg.c        |   16 ++++++++++++++++
 net/mac80211/driver-ops.h |   14 ++++++++++++++
 net/mac80211/iface.c      |    7 +++++++
 net/mac80211/mlme.c       |   11 +++++++++++
 net/mac80211/trace.h      |   28 ++++++++++++++++++++++++++++
 6 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bb86aa6..d29c99a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2262,6 +2262,10 @@ enum ieee80211_rate_control_changed {
  *	The callback will be called before each transmission and upon return
  *	mac80211 will transmit the frame right away.
  *	The callback is optional and can (should!) sleep.
+ *
+* @start_radar_detection: Start radar detection on current operational
+ *	channel, once started it will continuously monitor for radars as long
+ *	as the channel active.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2404,6 +2408,10 @@ struct ieee80211_ops {
 
 	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif);
+
+	int (*start_radar_detection)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_channel *chan);
 };
 
 /**
@@ -3576,6 +3584,17 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
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
index d41974a..59b7ffe 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2403,6 +2403,21 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ieee80211_cancel_roc(local, cookie, false);
 }
 
+static int ieee80211_start_radar_detection(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   struct ieee80211_channel *chan)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int ret;
+
+	if (!local->ops->start_radar_detection)
+		return -EOPNOTSUPP;
+
+	ret = drv_start_radar_detection(local, sdata, chan);
+	return ret;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
@@ -3075,4 +3090,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_stats = ieee80211_get_et_stats,
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
+	.start_radar_detection = ieee80211_start_radar_detection,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index df92031..0f42502 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -321,6 +321,20 @@ static inline void drv_cancel_hw_scan(struct ieee80211_local *local,
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
+	trace_drv_start_radar_detection(local, sdata);
+	ret = local->ops->start_radar_detection(&local->hw, &sdata->vif, chan);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int
 drv_sched_scan_start(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bfb57dc..ca7e4c2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -731,6 +731,13 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/* free all potentially still buffered bcast frames */
 		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps_bc_buf);
 		skb_queue_purge(&sdata->u.ap.ps_bc_buf);
+
+		/* reset DFS channel availability check */
+		if (local->oper_channel && sdata->wdev.preset_chan) {
+			local->oper_channel->cac_type = 0;
+			/* in case AP hasn't started yet */
+			sdata->wdev.preset_chan->cac_type = 0;
+		}
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
 	}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a4a5acd..2d87c5b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3549,3 +3549,14 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
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
index c6d33b5..acc5b0a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -486,6 +486,12 @@ DEFINE_EVENT(local_sdata_evt, drv_cancel_hw_scan,
 	TP_ARGS(local, sdata)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_start_radar_detection,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
 DEFINE_EVENT(local_sdata_evt, drv_sched_scan_start,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
@@ -1410,6 +1416,28 @@ TRACE_EVENT(api_cqm_rssi_notify,
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
 TRACE_EVENT(api_scan_completed,
 	TP_PROTO(struct ieee80211_local *local, bool aborted),
 
-- 
1.7.5.4

