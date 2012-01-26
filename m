Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:54051 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab2AZMj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:28 -0500
Received: by yenm3 with SMTP id m3so229316yen.17
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:23 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 4/9] mac80211: add ability to enable TX on op-channel
Date: Thu, 26 Jan 2012 14:37:59 +0200
Message-Id: <1327581484-22047-5-git-send-email-victorg@ti.com> (sfid-20120126_133930_726143_6B07E6E1)
In-Reply-To: <1327581484-22047-1-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior starting tx on DFS channels, the DFS master
device shall perform a Channel Availability Check
to ensure that there is no radar interference on
those channels. Once CAC done, the tx can be
enabled with ieee80211_dfs_en_tx().

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h      |    2 ++
 net/mac80211/cfg.c          |   16 ++++++++++++++++
 net/mac80211/driver-ops.h   |   12 ++++++++++++
 net/mac80211/driver-trace.h |    6 ++++++
 4 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de3a97ee..d08b808 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2238,6 +2238,8 @@ struct ieee80211_ops {
 					bool more_data);
 	int (*hw_dfs_start_radar_detection)(struct ieee80211_hw *hw,
 					    struct ieee80211_vif *vif);
+	int (*hw_dfs_en_tx)(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 080a2a4..2d85a97 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2029,6 +2029,21 @@ static int ieee80211_dfs_start_radar_detection(struct wiphy *wiphy,
 	return ret;
 }
 
+static int ieee80211_dfs_en_tx(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int ret = -ENOENT;
+
+	if (!local->ops->hw_dfs_en_tx)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&local->mtx);
+	ret = drv_dfs_en_tx(local, sdata);
+	mutex_unlock(&local->mtx);
+	return ret;
+}
+
 static enum work_done_result
 ieee80211_offchan_tx_done(struct ieee80211_work *wk, struct sk_buff *skb)
 {
@@ -2777,4 +2792,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_channel = ieee80211_wiphy_get_channel,
 	.set_noack_map = ieee80211_set_noack_map,
 	.dfs_start_radar_detection = ieee80211_dfs_start_radar_detection,
+	.dfs_en_tx = ieee80211_dfs_en_tx,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index b84cade..b37fac5 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -321,6 +321,18 @@ static inline int drv_dfs_en_radar_detection(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_dfs_en_tx(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_dfs_en_tx(local, sdata);
+	ret = local->ops->hw_dfs_en_tx(&local->hw, &sdata->vif);
+	return ret;
+}
+
 static inline int
 drv_sched_scan_start(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 75cca02..5ec9792 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -504,6 +504,12 @@ DEFINE_EVENT(local_sdata_evt, drv_dfs_en_radar_detection,
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

