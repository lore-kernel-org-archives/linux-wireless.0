Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2KSPFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 10:05:11 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1146879eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 07:05:09 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: make remain_on_channel() op pass vif param
Date: Mon, 19 Nov 2012 17:05:09 +0200
Message-Id: <1353337509-6883-1-git-send-email-eliad@wizery.com> (sfid-20121119_160516_117315_C1723BFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers (e.g. wl12xx) might need to know the vif
to roc on (mainly in order to configure the
rx filters correctly).

Add the vif to the op params, and update the current
users (iwlwifi) to use the new api.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: don't combine ROC requests on different vifs (thanks Johannes!)

drivers/net/wireless/iwlwifi/dvm/mac80211.c |    1 +
 include/net/mac80211.h                      |    1 +
 net/mac80211/cfg.c                          |    6 ++++--
 net/mac80211/driver-ops.h                   |    7 ++++---
 net/mac80211/offchannel.c                   |    2 +-
 net/mac80211/trace.h                        |   13 +++++++++----
 6 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index ff8162d..e75d803 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1032,6 +1032,7 @@ done:
 }
 
 static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
 				     struct ieee80211_channel *channel,
 				     enum nl80211_channel_type channel_type,
 				     int duration)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 00b7204..322ac6d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2488,6 +2488,7 @@ struct ieee80211_ops {
 	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
 
 	int (*remain_on_channel)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
 				 struct ieee80211_channel *chan,
 				 enum nl80211_channel_type channel_type,
 				 int duration);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5eab132..6a67340 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2236,7 +2236,8 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	if (!duration)
 		duration = 10;
 
-	ret = drv_remain_on_channel(local, channel, channel_type, duration);
+	ret = drv_remain_on_channel(local, sdata, channel, channel_type,
+				    duration);
 	if (ret) {
 		kfree(roc);
 		return ret;
@@ -2247,7 +2248,8 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
  out_check_combine:
 	list_for_each_entry(tmp, &local->roc_list, list) {
-		if (tmp->chan != channel || tmp->chan_type != channel_type)
+		if (tmp->chan != channel || tmp->chan_type != channel_type ||
+		    tmp->sdata != sdata)
 			continue;
 
 		/*
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 77407b3..73dbf24 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -704,6 +704,7 @@ static inline int drv_get_antenna(struct ieee80211_local *local,
 }
 
 static inline int drv_remain_on_channel(struct ieee80211_local *local,
+					struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_channel *chan,
 					enum nl80211_channel_type chantype,
 					unsigned int duration)
@@ -712,9 +713,9 @@ static inline int drv_remain_on_channel(struct ieee80211_local *local,
 
 	might_sleep();
 
-	trace_drv_remain_on_channel(local, chan, chantype, duration);
-	ret = local->ops->remain_on_channel(&local->hw, chan, chantype,
-					    duration);
+	trace_drv_remain_on_channel(local, sdata, chan, chantype, duration);
+	ret = local->ops->remain_on_channel(&local->hw, &sdata->vif,
+					    chan, chantype, duration);
 	trace_drv_return_int(local, ret);
 
 	return ret;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index c349f3a..1d01459 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -283,7 +283,7 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 		if (!duration)
 			duration = 10;
 
-		ret = drv_remain_on_channel(local, roc->chan,
+		ret = drv_remain_on_channel(local, roc->sdata, roc->chan,
 					    roc->chan_type,
 					    duration);
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0638541..c9aff6f 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1013,13 +1013,16 @@ TRACE_EVENT(drv_get_antenna,
 );
 
 TRACE_EVENT(drv_remain_on_channel,
-	TP_PROTO(struct ieee80211_local *local, struct ieee80211_channel *chan,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_channel *chan,
 		 enum nl80211_channel_type chantype, unsigned int duration),
 
-	TP_ARGS(local, chan, chantype, duration),
+	TP_ARGS(local, sdata, chan, chantype, duration),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		VIF_ENTRY
 		__field(int, center_freq)
 		__field(int, channel_type)
 		__field(unsigned int, duration)
@@ -1027,14 +1030,16 @@ TRACE_EVENT(drv_remain_on_channel,
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		VIF_ASSIGN;
 		__entry->center_freq = chan->center_freq;
 		__entry->channel_type = chantype;
 		__entry->duration = duration;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " freq:%dMHz duration:%dms",
-		LOCAL_PR_ARG, __entry->center_freq, __entry->duration
+		LOCAL_PR_FMT  VIF_PR_FMT " freq:%dMHz duration:%dms",
+		LOCAL_PR_ARG, VIF_PR_ARG,
+		__entry->center_freq, __entry->duration
 	)
 );
 
-- 
1.7.6.401.g6a319

