Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34481 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab2JNOzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 10:55:51 -0400
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v4 4/6] mac80211: add ability to enable TX on op-channel
Date: Sun, 14 Oct 2012 16:48:55 +0200
Message-ID: <1350226137-13704-5-git-send-email-victorg@ti.com> (sfid-20121014_165557_460851_A7BFA5B7)
In-Reply-To: <1350226137-13704-1-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior starting tx on DFS channels, the DFS master
device shall perform a Channel Availability Check
to ensure that there is no radar interference on
those channels. Once CAC done, the tx can be
enabled with ieee80211_dfs_en_tx().

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h    |    5 +++++
 net/mac80211/cfg.c        |   15 +++++++++++++++
 net/mac80211/driver-ops.h |   14 ++++++++++++++
 net/mac80211/trace.h      |   24 ++++++++++++++++++++++++
 4 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 67f932d..725018f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2321,6 +2321,9 @@ enum ieee80211_rate_control_changed {
  * @start_radar_detection: Start radar detection on current operational
  *	channel, once started it will continuously monitor for radars as long
  *	as the channel active. This callback can sleep.
+ * @dfs_en_tx: Once channel pass the DFS initial channel availability check,
+ *	initiate the tx on the channel with this command. This callback can
+ *	sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2469,6 +2472,8 @@ struct ieee80211_ops {
 	int (*start_radar_detection)(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_channel *chan);
+	int (*dfs_en_tx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_channel *chan);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a6c5369..b706232 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2459,6 +2459,20 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	return drv_start_radar_detection(local, sdata, chan);
 }
 
+static int ieee80211_dfs_en_tx(struct wiphy *wiphy, struct net_device *dev,
+			       struct ieee80211_channel *chan)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int ret = -ENOENT;
+
+	if (!local->ops->dfs_en_tx)
+		return -EOPNOTSUPP;
+
+	ret = drv_dfs_en_tx(local, sdata, chan);
+	return ret;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
@@ -3145,4 +3159,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.dfs_en_tx = ieee80211_dfs_en_tx,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index dfb992e..bca55a3 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -337,6 +337,20 @@ static inline int drv_start_radar_detection(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_dfs_en_tx(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_channel *chan)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_dfs_en_tx(local, chan);
+	ret = local->ops->dfs_en_tx(&local->hw, &sdata->vif, chan);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int
 drv_sched_scan_start(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index cbebd52..e6e066e 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1691,6 +1691,30 @@ TRACE_EVENT(drv_start_radar_detection,
 	)
 );
 
+TRACE_EVENT(drv_dfs_en_tx,
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
+		LOCAL_PR_FMT " enable transmission on freq:%u cac_type:%d",
+		LOCAL_PR_ARG, __entry->freq, __entry->cac_type
+	)
+);
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
-- 
1.7.5.4

