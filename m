Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40448 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab3AHNEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 08:04:52 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 4/6] mac80211: add radar detection command/event
Date: Tue,  8 Jan 2013 14:04:09 +0100
Message-Id: <1357650251-17425-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130108_140507_352347_F2511F93)
In-Reply-To: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
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
Changes to PATCHv5:
 * use local instead of sdata->local
 * change API to chandef
---
 include/net/mac80211.h    |   19 ++++++++++++
 net/mac80211/cfg.c        |   27 ++++++++++++++++
 net/mac80211/driver-ops.h |   15 +++++++++
 net/mac80211/iface.c      |    4 +++
 net/mac80211/mlme.c       |   11 +++++++
 net/mac80211/trace.h      |   76 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 152 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 23daed3..ab9748d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2487,6 +2487,10 @@ enum ieee80211_rate_control_changed {
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
@@ -2660,6 +2664,10 @@ struct ieee80211_ops {
 				     struct ieee80211_chanctx_conf *ctx);
 
 	void (*restart_complete)(struct ieee80211_hw *hw);
+
+	int (*start_radar_detection)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct cfg80211_chan_def *chandef);
 };
 
 /**
@@ -3889,6 +3897,17 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
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
index 7d290bc..bd300e4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2588,6 +2588,32 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
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
+	sdata->needed_rx_chains = local->rx_chains;
+
+	if (ieee80211_vif_use_channel(sdata, chandef,
+				      IEEE80211_CHANCTX_SHARED))
+		return -EBUSY;
+
+	res = drv_start_radar_detection(local, sdata, chandef);
+	if (res)
+		ieee80211_vif_release_channel(sdata);
+
+	return res;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     unsigned int wait, const u8 *buf, size_t len,
@@ -3292,4 +3318,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_stats = ieee80211_get_et_stats,
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
+	.start_radar_detection = ieee80211_start_radar_detection,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0c07f94..2b3bdd9 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -331,6 +331,21 @@ static inline void drv_cancel_hw_scan(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_start_radar_detection(struct ieee80211_local *local,
+					    struct ieee80211_sub_if_data *sdata,
+					    struct cfg80211_chan_def *chandef)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_start_radar_detection(local, sdata, chandef);
+	ret = local->ops->start_radar_detection(&local->hw, &sdata->vif,
+						chandef);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int
 drv_sched_scan_start(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 06fac29..3dbd81b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -826,6 +826,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
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
index d90c07b1..ce06771 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4131,3 +4131,14 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
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
index a8270b4..553d25b 100644
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
@@ -1815,6 +1844,53 @@ TRACE_EVENT(stop_queue,
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
+);
+
+TRACE_EVENT(drv_start_radar_detection,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_chan_def *chandef),
+
+	TP_ARGS(local, sdata, chandef),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		CHAN_DEF_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " start radar detection on: " CHAN_DEF_PR_FMT,
+		LOCAL_PR_ARG, CHAN_DEF_PR_ARG
+	)
+);
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
-- 
1.7.10.4

