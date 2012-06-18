Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:52101 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265Ab2FROuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 10:50:10 -0400
Received: by yenr13 with SMTP id r13so5052964yen.24
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 07:50:05 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH 4/7] mac80211: add ability to enable TX on op-channel
Date: Mon, 18 Jun 2012 17:46:35 +0300
Message-Id: <1340030798-28992-5-git-send-email-victorg@ti.com> (sfid-20120618_165014_216112_7D968F50)
In-Reply-To: <1340030798-28992-1-git-send-email-victorg@ti.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior starting tx on DFS channels, the DFS master
device shall perform a Channel Availability Check
to ensure that there is no radar interference on
those channels. Once CAC done, the tx can be
enabled with ieee80211_dfs_en_tx().

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h      |    4 ++++
 net/mac80211/cfg.c          |   15 +++++++++++++++
 net/mac80211/driver-ops.h   |   14 ++++++++++++++
 net/mac80211/driver-trace.h |    6 ++++++
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a2222cf..82e5ee7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2249,6 +2249,8 @@ enum ieee80211_rate_control_changed {
  * @start_radar_detection: Start radar detection on current operational
  *	channel, once started it will continuously monitor for radars as long
  *	as the channel active.
+ * @dfs_en_tx: Once channel pass the DFS initial channel availability check,
+ *	initiate the tx on the channel with this command.
  *
  */
 struct ieee80211_ops {
@@ -2392,6 +2394,8 @@ struct ieee80211_ops {
 	int (*start_radar_detection)(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_channel *chan);
+	int (*dfs_en_tx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_channel *chan);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 541b274..a48d055 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2226,6 +2226,20 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	return ret;
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
 static enum work_done_result
 ieee80211_offchan_tx_done(struct ieee80211_work *wk, struct sk_buff *skb)
 {
@@ -2995,4 +3009,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_stats = ieee80211_get_et_stats,
 	.get_et_strings = ieee80211_get_et_strings,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.dfs_en_tx = ieee80211_dfs_en_tx,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 57185df..f49b76b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -343,6 +343,20 @@ static inline int drv_start_radar_detection(struct ieee80211_local *local,
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
+	trace_drv_dfs_en_tx(local, sdata);
+	ret = local->ops->dfs_en_tx(&local->hw, &sdata->vif, chan);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int
 drv_sched_scan_start(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 4112aa3..6df02c4 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -490,6 +490,12 @@ DEFINE_EVENT(local_sdata_evt, drv_start_radar_detection,
 	TP_ARGS(local, sdata)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_dfs_en_tx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
 DEFINE_EVENT(local_sdata_evt, drv_sched_scan_start,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
-- 
1.7.5.4

