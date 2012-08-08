Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:44407 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757486Ab2HHMAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:00:32 -0400
Received: by obqv19 with SMTP id v19so1647499obq.30
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:00:31 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 4/7] mac80211: add ability to enable TX on op-channel
Date: Wed,  8 Aug 2012 14:53:40 +0300
Message-Id: <1344426823-1795-5-git-send-email-victorg@ti.com> (sfid-20120808_140052_550817_B9F7C7C6)
In-Reply-To: <1344426823-1795-1-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior starting tx on DFS channels, the DFS master
device shall perform a Channel Availability Check
to ensure that there is no radar interference on
those channels. Once CAC done, the tx can be
enabled with ieee80211_dfs_en_tx().

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h    |    4 ++++
 net/mac80211/cfg.c        |   15 +++++++++++++++
 net/mac80211/driver-ops.h |   14 ++++++++++++++
 net/mac80211/trace.h      |    6 ++++++
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d29c99a..ecdfb6a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2266,6 +2266,8 @@ enum ieee80211_rate_control_changed {
 * @start_radar_detection: Start radar detection on current operational
  *	channel, once started it will continuously monitor for radars as long
  *	as the channel active.
+ * @dfs_en_tx: Once channel pass the DFS initial channel availability check,
+ *	initiate the tx on the channel with this command.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2412,6 +2414,8 @@ struct ieee80211_ops {
 	int (*start_radar_detection)(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_channel *chan);
+	int (*dfs_en_tx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_channel *chan);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 59b7ffe..eb18868 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2418,6 +2418,20 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
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
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
@@ -3091,4 +3105,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.dfs_en_tx = ieee80211_dfs_en_tx,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0f42502..04a9168 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -335,6 +335,20 @@ static inline int drv_start_radar_detection(struct ieee80211_local *local,
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
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index acc5b0a..2ef4731 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -492,6 +492,12 @@ DEFINE_EVENT(local_sdata_evt, drv_start_radar_detection,
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

