Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26081 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab0KAM0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:26:00 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcI020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:22 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 06/15] mac80211: add support for HW periodic scan
Date: Mon,  1 Nov 2010 13:52:07 +0200
Message-Id: <1288612336-2830-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement support for HW periodic scan.  The mac80211 code doesn't perform
periodic scans itself, but calls the driver to start and stop periodic scans.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/net/mac80211.h      |    4 +++
 net/mac80211/cfg.c          |   26 ++++++++++++++++++++
 net/mac80211/driver-ops.h   |   26 ++++++++++++++++++++
 net/mac80211/driver-trace.h |   44 +++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    6 ++++
 net/mac80211/scan.c         |   54 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 160 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9fdf982..4ea2149 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1759,6 +1759,10 @@ struct ieee80211_ops {
 				u32 iv32, u16 *phase1key);
 	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct cfg80211_scan_request *req);
+	int (*periodic_start)(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif);
+	int (*periodic_stop)(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif);
 	void (*sw_scan_start)(struct ieee80211_hw *hw);
 	void (*sw_scan_complete)(struct ieee80211_hw *hw);
 	int (*get_stats)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18bd0e5..ff29840 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1223,6 +1223,30 @@ static int ieee80211_scan(struct wiphy *wiphy,
 	return ieee80211_request_scan(sdata, req);
 }
 
+static int ieee80211_periodic_start(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct cfg80211_periodic_request *req)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if(!sdata->local->ops->periodic_start)
+		return -EOPNOTSUPP;
+
+	return ieee80211_request_periodic_start(sdata, req);
+}
+
+static int ieee80211_periodic_stop(struct wiphy *wiphy,
+				   struct net_device *dev,
+				   struct cfg80211_periodic_request *req)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if(!sdata->local->ops->periodic_stop)
+		return -EOPNOTSUPP;
+
+	return ieee80211_request_periodic_stop(sdata);
+}
+
 static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
 			  struct cfg80211_auth_request *req)
 {
@@ -1654,6 +1678,8 @@ struct cfg80211_ops mac80211_config_ops = {
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
+	.periodic_start= ieee80211_periodic_start,
+	.periodic_stop= ieee80211_periodic_stop,
 	.auth = ieee80211_auth,
 	.assoc = ieee80211_assoc,
 	.deauth = ieee80211_deauth,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1698382..c425e1c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -191,6 +191,32 @@ static inline int drv_hw_scan(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_periodic_start(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_periodic_start(local, sdata);
+	ret = local->ops->periodic_start(&local->hw, &sdata->vif);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline int drv_periodic_stop(struct ieee80211_local *local,
+				    struct ieee80211_sub_if_data *sdata)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_periodic_stop(local, sdata);
+	ret = local->ops->periodic_stop(&local->hw, &sdata->vif);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline void drv_sw_scan_start(struct ieee80211_local *local)
 {
 	might_sleep();
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6831fb1..a09c17d 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -439,6 +439,50 @@ TRACE_EVENT(drv_hw_scan,
 	)
 );
 
+TRACE_EVENT(drv_periodic_start,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+
+	TP_ARGS(local, sdata),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT,
+		LOCAL_PR_ARG,VIF_PR_ARG
+	)
+);
+
+TRACE_EVENT(drv_periodic_stop,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+
+	TP_ARGS(local, sdata),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT,
+		LOCAL_PR_ARG,VIF_PR_ARG
+	)
+);
+
 TRACE_EVENT(drv_sw_scan_start,
 	TP_PROTO(struct ieee80211_local *local),
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b80c386..305bd57 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -812,6 +812,7 @@ struct ieee80211_local {
 	struct cfg80211_ssid scan_ssid;
 	struct cfg80211_scan_request *int_scan_req;
 	struct cfg80211_scan_request *scan_req, *hw_scan_req;
+	struct cfg80211_periodic_request *periodic_req;
 	struct ieee80211_channel *scan_channel;
 	enum ieee80211_band hw_scan_band;
 	int scan_channel_idx;
@@ -1115,6 +1116,11 @@ ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss);
 
+/* periodic scan handling */
+int ieee80211_request_periodic_start(struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_periodic_request *req);
+int ieee80211_request_periodic_stop(struct ieee80211_sub_if_data *sdata);
+
 /* off-channel helpers */
 void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local);
 void ieee80211_offchannel_stop_station(struct ieee80211_local *local);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 592acfb..fa73abe 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -823,3 +823,57 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	if (finish)
 		__ieee80211_scan_completed_finish(&local->hw, false);
 }
+
+int ieee80211_request_periodic_start(struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_periodic_request *req)
+{
+	struct ieee80211_local *local = sdata->local;
+	int ret;
+
+	mutex_lock(&sdata->local->mtx);
+
+	/* FIXME: check if hw scanning or associated and return -EBUSY */
+
+	if (local->periodic_req) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (!local->ops->periodic_start) {
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	local->periodic_req = req;
+
+	ret = drv_periodic_start(local, sdata);
+	if (ret)
+		local->periodic_req = NULL;
+out:
+	mutex_unlock(&sdata->local->mtx);
+
+	return ret;
+}
+
+int ieee80211_request_periodic_stop(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	int ret = 0;
+
+	mutex_lock(&sdata->local->mtx);
+
+	if (!local->ops->periodic_stop) {
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	if (local->periodic_req) {
+		ret = drv_periodic_stop(local, sdata);
+		local->periodic_req = NULL;
+	}
+
+out:
+	mutex_unlock(&sdata->local->mtx);
+
+	return ret;
+}
-- 
1.7.0.4

