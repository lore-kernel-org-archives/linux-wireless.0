Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40877 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab1IYRHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Sep 2011 13:07:01 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so3096767eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Sep 2011 10:07:00 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] mac80211: save tx params per sdata
Date: Sun, 25 Sep 2011 20:06:54 +0300
Message-Id: <1316970415-23239-2-git-send-email-eliad@wizery.com> (sfid-20110925_190721_689985_FD2188CE)
In-Reply-To: <1316970415-23239-1-git-send-email-eliad@wizery.com>
References: <1316970415-23239-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

save and configure tx param per sdata, rather than
per hardware.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/cfg.c          |    5 +++--
 net/mac80211/driver-ops.h   |    5 +++--
 net/mac80211/driver-trace.h |   14 ++++++++++----
 net/mac80211/ieee80211_i.h  |    3 ++-
 net/mac80211/mlme.c         |    4 ++--
 net/mac80211/util.c         |   15 +++++++++++----
 6 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 805b40b..edc1d21 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1275,6 +1275,7 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 				    struct ieee80211_txq_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_tx_queue_params p;
 
 	if (!local->ops->conf_tx)
@@ -1295,8 +1296,8 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 	if (params->queue >= local->hw.queues)
 		return -EINVAL;
 
-	local->tx_conf[params->queue] = p;
-	if (drv_conf_tx(local, params->queue, &p)) {
+	sdata->tx_conf[params->queue] = p;
+	if (drv_conf_tx(local, sdata, params->queue, &p)) {
 		wiphy_debug(local->hw.wiphy,
 			    "failed to set TX queue parameters for queue %d\n",
 			    params->queue);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 9001ff3..5315a5d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -413,14 +413,15 @@ static inline void drv_sta_remove(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
+static inline int drv_conf_tx(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata, u16 queue,
 			      const struct ieee80211_tx_queue_params *params)
 {
 	int ret = -EOPNOTSUPP;
 
 	might_sleep();
 
-	trace_drv_conf_tx(local, queue, params);
+	trace_drv_conf_tx(local, sdata, queue, params);
 	if (local->ops->conf_tx)
 		ret = local->ops->conf_tx(&local->hw, queue, params);
 	trace_drv_return_int(local, ret);
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index f47b00d..aaf97da 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -697,32 +697,38 @@ TRACE_EVENT(drv_sta_remove,
 );
 
 TRACE_EVENT(drv_conf_tx,
-	TP_PROTO(struct ieee80211_local *local, u16 queue,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u16 queue,
 		 const struct ieee80211_tx_queue_params *params),
 
-	TP_ARGS(local, queue, params),
+	TP_ARGS(local, sdata, queue, params),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		VIF_ENTRY
 		__field(u16, queue)
 		__field(u16, txop)
 		__field(u16, cw_min)
 		__field(u16, cw_max)
 		__field(u8, aifs)
+		__field(bool, uapsd)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		VIF_ASSIGN;
 		__entry->queue = queue;
 		__entry->txop = params->txop;
 		__entry->cw_max = params->cw_max;
 		__entry->cw_min = params->cw_min;
 		__entry->aifs = params->aifs;
+		__entry->uapsd = params->uapsd;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " queue:%d",
-		LOCAL_PR_ARG, __entry->queue
+		LOCAL_PR_FMT  VIF_PR_FMT  " queue:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->queue
 	)
 );
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 21186e2..fc3e846 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -609,6 +609,8 @@ struct ieee80211_sub_if_data {
 	__be16 control_port_protocol;
 	bool control_port_no_encrypt;
 
+	struct ieee80211_tx_queue_params tx_conf[IEEE80211_MAX_QUEUES];
+
 	struct work_struct work;
 	struct sk_buff_head skb_queue;
 
@@ -751,7 +753,6 @@ struct ieee80211_local {
 	struct workqueue_struct *workqueue;
 
 	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
-	struct ieee80211_tx_queue_params tx_conf[IEEE80211_MAX_QUEUES];
 	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1a59fb6..fefd9bf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -936,8 +936,8 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 			    params.aifs, params.cw_min, params.cw_max,
 			    params.txop, params.uapsd);
 #endif
-		local->tx_conf[queue] = params;
-		if (drv_conf_tx(local, queue, &params))
+		sdata->tx_conf[queue] = params;
+		if (drv_conf_tx(local, sdata, queue, &params))
 			wiphy_debug(local->hw.wiphy,
 				    "failed to set TX queue parameters for queue %d\n",
 				    queue);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4b1466d..8413dc0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -632,8 +632,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 
 		qparam.uapsd = false;
 
-		local->tx_conf[queue] = qparam;
-		drv_conf_tx(local, queue, &qparam);
+		sdata->tx_conf[queue] = qparam;
+		drv_conf_tx(local, sdata, queue, &qparam);
 	}
 
 	/* after reinitialize QoS TX queues setting to default,
@@ -1040,8 +1040,15 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mutex_unlock(&local->sta_mtx);
 
 	/* reconfigure tx conf */
-	for (i = 0; i < hw->queues; i++)
-		drv_conf_tx(local, i, &local->tx_conf[i]);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+		    !ieee80211_sdata_running(sdata))
+			continue;
+
+		for (i = 0; i < hw->queues; i++)
+			drv_conf_tx(local, sdata, i, &sdata->tx_conf[i]);
+	}
 
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
-- 
1.7.6.401.g6a319

