Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41344 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab2AZMjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:13 -0500
Received: by yhoo47 with SMTP id o47so189210yho.38
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:12 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 2/9] mac80211: add radar detection command/event
Date: Thu, 26 Jan 2012 14:37:57 +0200
Message-Id: <1327581484-22047-3-git-send-email-victorg@ti.com> (sfid-20120126_133917_038528_619D55A7)
In-Reply-To: <1327581484-22047-1-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to trigger radar detection in the driver/FW.
Once radar detected usermode notified with 'radar detected'
event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h      |   13 +++++++++++++
 net/mac80211/cfg.c          |   17 +++++++++++++++++
 net/mac80211/driver-ops.h   |   12 ++++++++++++
 net/mac80211/driver-trace.h |    6 ++++++
 net/mac80211/mlme.c         |    9 +++++++++
 5 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2a7523e..de3a97ee 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2236,6 +2236,8 @@ struct ieee80211_ops {
 					u16 tids, int num_frames,
 					enum ieee80211_frame_release_type reason,
 					bool more_data);
+	int (*hw_dfs_start_radar_detection)(struct ieee80211_hw *hw,
+					    struct ieee80211_vif *vif);
 };
 
 /**
@@ -3406,6 +3408,17 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       gfp_t gfp);
 
 /**
+ * ieee80211_radar_detected_notify - inform a configured connection that
+ * radar was detected on the current channel
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @freq: frequency of the 'radar detected' channel.
+ * @gfp: context flags.
+ */
+void ieee80211_radar_detected_notify(struct ieee80211_vif *vif,
+				     u16 freq, gfp_t gfp);
+
+/**
  * ieee80211_get_operstate - get the operstate of the vif
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 850bb96..080a2a4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2013,6 +2013,22 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ieee80211_wk_cancel_remain_on_channel(sdata, cookie);
 }
 
+static int ieee80211_dfs_start_radar_detection(struct wiphy *wiphy,
+					       struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int ret = -ENOENT;
+
+	if (!local->ops->hw_dfs_start_radar_detection)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&local->mtx);
+	ret = drv_dfs_en_radar_detection(local, sdata);
+	mutex_unlock(&local->mtx);
+	return ret;
+}
+
 static enum work_done_result
 ieee80211_offchan_tx_done(struct ieee80211_work *wk, struct sk_buff *skb)
 {
@@ -2760,4 +2776,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.probe_client = ieee80211_probe_client,
 	.get_channel = ieee80211_wiphy_get_channel,
 	.set_noack_map = ieee80211_set_noack_map,
+	.dfs_start_radar_detection = ieee80211_dfs_start_radar_detection,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e8960ae..b84cade 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -309,6 +309,18 @@ static inline void drv_cancel_hw_scan(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_dfs_en_radar_detection(struct ieee80211_local *local,
+					 struct ieee80211_sub_if_data *sdata)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_dfs_en_radar_detection(local, sdata);
+	ret = local->ops->hw_dfs_start_radar_detection(&local->hw, &sdata->vif);
+	return ret;
+}
+
 static inline int
 drv_sched_scan_start(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6e9df8f..75cca02 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -498,6 +498,12 @@ DEFINE_EVENT(local_sdata_evt, drv_cancel_hw_scan,
 	TP_ARGS(local, sdata)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_dfs_en_radar_detection,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
 DEFINE_EVENT(local_sdata_evt, drv_sched_scan_start,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ecb4c84..57aeb84 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2869,6 +2869,15 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
 
+void ieee80211_radar_detected_notify(struct ieee80211_vif *vif,
+				     u16 freq, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_radar_detected_notify(sdata->dev, freq, gfp);
+}
+EXPORT_SYMBOL(ieee80211_radar_detected_notify);
+
 unsigned char ieee80211_get_operstate(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-- 
1.7.5.4

