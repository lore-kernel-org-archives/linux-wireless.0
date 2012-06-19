Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:55267 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab2FSNOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 09:14:25 -0400
Received: by obbta14 with SMTP id ta14so1344316obb.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 06:14:24 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v2 2/7] mac80211: add radar detection command/event
Date: Tue, 19 Jun 2012 16:10:58 +0300
Message-Id: <1340111463-4554-2-git-send-email-victorg@ti.com> (sfid-20120619_151442_789326_986476C5)
In-Reply-To: <1340111463-4554-1-git-send-email-victorg@ti.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to trigger radar detection in the driver/FW.
Once radar detection is started it should continuously
monitor for radars as long as the channel active.
If radar is detected usermode notified with 'radar
detected' event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h      |   17 +++++++++++++++++
 net/mac80211/cfg.c          |   16 ++++++++++++++++
 net/mac80211/driver-ops.h   |   14 ++++++++++++++
 net/mac80211/driver-trace.h |    6 ++++++
 net/mac80211/mlme.c         |    8 ++++++++
 5 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 95e39b6..a2222cf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2246,6 +2246,10 @@ enum ieee80211_rate_control_changed {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *
+ * @start_radar_detection: Start radar detection on current operational
+ *	channel, once started it will continuously monitor for radars as long
+ *	as the channel active.
+ *
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2385,6 +2389,9 @@ struct ieee80211_ops {
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
+	int (*start_radar_detection)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_channel *chan);
 };
 
 /**
@@ -3557,6 +3564,16 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       gfp_t gfp);
 
 /**
+ * ieee80211_radar_detected - inform a configured connection that
+ * radar was detected on the current channel
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @freq: frequency of the 'radar detected' channel.
+ * @gfp: context flags.
+ */
+void ieee80211_radar_detected(struct ieee80211_vif *vif, u16 freq, gfp_t gfp);
+
+/**
  * ieee80211_get_operstate - get the operstate of the vif
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7d5108a..541b274 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2211,6 +2211,21 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ieee80211_wk_cancel_remain_on_channel(sdata, cookie);
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
 static enum work_done_result
 ieee80211_offchan_tx_done(struct ieee80211_work *wk, struct sk_buff *skb)
 {
@@ -2979,4 +2994,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_sset_count = ieee80211_get_et_sset_count,
 	.get_et_stats = ieee80211_get_et_stats,
 	.get_et_strings = ieee80211_get_et_strings,
+	.start_radar_detection = ieee80211_start_radar_detection,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 6d33a0c..57185df 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -329,6 +329,20 @@ static inline void drv_cancel_hw_scan(struct ieee80211_local *local,
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
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6de00b2..4112aa3 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -484,6 +484,12 @@ DEFINE_EVENT(local_sdata_evt, drv_cancel_hw_scan,
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
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 66e4fcd..37ed827 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3562,6 +3562,14 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
 
+void ieee80211_radar_detected(struct ieee80211_vif *vif, u16 freq, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_radar_detected(sdata->dev, freq, gfp);
+}
+EXPORT_SYMBOL(ieee80211_radar_detected);
+
 unsigned char ieee80211_get_operstate(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-- 
1.7.5.4

