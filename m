Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38933 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2LMN7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:59:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 4/8] mac80211: add radar detection command/event
Date: Thu, 13 Dec 2012 14:58:29 +0100
Message-Id: <1355407113-27006-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121213_145927_489193_44BB3EEF)
In-Reply-To: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Add command to trigger radar detection in the driver/FW.
Once radar detection is started it should continuously
monitor for radars as long as the channel active.
If radar is detected usermode notified with 'radar
detected' event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
[rebase, change to chandef, minor fixes]
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/mac80211.h    |   19 +++++++++++++++++++
 net/mac80211/cfg.c        |   28 +++++++++++++++++++++++++++
 net/mac80211/driver-ops.h |   14 ++++++++++++++
 net/mac80211/iface.c      |    4 ++++
 net/mac80211/mlme.c       |   11 +++++++++++
 net/mac80211/trace.h      |   46 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 122 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ee50c5e..b9186f4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2475,6 +2475,10 @@ enum ieee80211_rate_control_changed {
  * @restart_complete: Called after a call to ieee80211_restart_hw(), when the
  *	reconfiguration has completed. This can help the driver implement the
  *	reconfiguration step. This callback may sleep.
+ *
+ * @start_radar_detection: Start radar detection on current operational
+ *	channel, once started it will continuously monitor for radars as long
+ *	as the channel active. This callback can sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2648,6 +2652,10 @@ struct ieee80211_ops {
 				     struct ieee80211_chanctx_conf *ctx);
 
 	void (*restart_complete)(struct ieee80211_hw *hw);
+
+	int (*start_radar_detection)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_channel *chan);
 };
 
 /**
@@ -3872,6 +3880,17 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
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
index 5c61677..a9de035 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2551,6 +2551,33 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ieee80211_cancel_roc(local, cookie, false);
 }
 
+static int ieee80211_start_radar_detection(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int res;
+
+	if (!local->ops->start_radar_detection)
+		return -EOPNOTSUPP;
+
+	/* whatever, but channel contexts should not complain about that one */
+	sdata->smps_mode = IEEE80211_SMPS_OFF;
+	sdata->needed_rx_chains = sdata->local->rx_chains;
+
+	/* TODO: shall we define SINGLE_ONLY context here too? */
+	if (ieee80211_vif_use_channel(sdata, chandef,
+				      IEEE80211_CHANCTX_EXCLUSIVE))
+		return -EBUSY;
+
+	res = drv_start_radar_detection(local, sdata, chandef->chan);
+	if (!res)
+		ieee80211_vif_release_channel(sdata);
+
+	return res;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     unsigned int wait, const u8 *buf, size_t len,
@@ -3255,4 +3282,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_stats = ieee80211_get_et_stats,
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
+	.start_radar_detection = ieee80211_start_radar_detection,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c6560cc..f703dfc 100644
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
index 09a80b5..2895cd8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -829,6 +829,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 					 u.vlan.list)
 			dev_close(vlan->dev);
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
+
+		/* reset DFS channel availability check */
+		if (local->_oper_channel)
+			local->_oper_channel->cac_started = false;
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
 	}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7753a9c..a734036 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4056,3 +4056,14 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
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
index a8270b4..2c73982 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1815,6 +1815,52 @@ TRACE_EVENT(stop_queue,
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
1.7.10.4

