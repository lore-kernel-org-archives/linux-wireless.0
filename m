Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0FJI4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:56:24 -0400
Subject: [PATCH] mac80211: bracket driver tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 10:56:20 +0200
Message-ID: <1276160180.7043.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, driver tracing is sometimes invoked
after and sometimes before the actual driver
callback. This is fine as long as the driver
has no tracing itself, but as soon as it does
it gets confusing.

To make traces containing such information
easier to read, introduce a return tracer in
mac80211 that essentially brackets any driver
tracing, and invoke the real trace before the
driver's callback, only showing the return
value, if any, afterwards.

Since tracing records the process, there's no
problem with overlapping calls if that should
happen.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/driver-ops.h   |   89 +++++++++++++-------
 net/mac80211/driver-trace.h |  189 ++++++++++++++++++++++----------------------
 2 files changed, 156 insertions(+), 122 deletions(-)

--- wireless-testing.orig/net/mac80211/driver-ops.h	2010-06-09 21:07:00.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2010-06-10 10:42:07.000000000 +0200
@@ -16,10 +16,11 @@ static inline int drv_start(struct ieee8
 
 	might_sleep();
 
+	trace_drv_start(local);
 	local->started = true;
 	smp_mb();
 	ret = local->ops->start(&local->hw);
-	trace_drv_start(local, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -27,8 +28,9 @@ static inline void drv_stop(struct ieee8
 {
 	might_sleep();
 
-	local->ops->stop(&local->hw);
 	trace_drv_stop(local);
+	local->ops->stop(&local->hw);
+	trace_drv_return_void(local);
 
 	/* sync away all work on the tasklet before clearing started */
 	tasklet_disable(&local->tasklet);
@@ -46,8 +48,9 @@ static inline int drv_add_interface(stru
 
 	might_sleep();
 
+	trace_drv_add_interface(local, vif_to_sdata(vif));
 	ret = local->ops->add_interface(&local->hw, vif);
-	trace_drv_add_interface(local, vif_to_sdata(vif), ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -56,8 +59,9 @@ static inline void drv_remove_interface(
 {
 	might_sleep();
 
-	local->ops->remove_interface(&local->hw, vif);
 	trace_drv_remove_interface(local, vif_to_sdata(vif));
+	local->ops->remove_interface(&local->hw, vif);
+	trace_drv_return_void(local);
 }
 
 static inline int drv_config(struct ieee80211_local *local, u32 changed)
@@ -66,8 +70,9 @@ static inline int drv_config(struct ieee
 
 	might_sleep();
 
+	trace_drv_config(local, changed);
 	ret = local->ops->config(&local->hw, changed);
-	trace_drv_config(local, changed, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -78,9 +83,10 @@ static inline void drv_bss_info_changed(
 {
 	might_sleep();
 
+	trace_drv_bss_info_changed(local, sdata, info, changed);
 	if (local->ops->bss_info_changed)
 		local->ops->bss_info_changed(&local->hw, &sdata->vif, info, changed);
-	trace_drv_bss_info_changed(local, sdata, info, changed);
+	trace_drv_return_void(local);
 }
 
 struct in_ifaddr;
@@ -92,11 +98,11 @@ static inline int drv_configure_arp_filt
 
 	might_sleep();
 
+	trace_drv_configure_arp_filter(local, vif_to_sdata(vif));
 	if (local->ops->configure_arp_filter)
 		ret = local->ops->configure_arp_filter(&local->hw, vif,
 						       ifa_list);
-
-	trace_drv_configure_arp_filter(local, vif_to_sdata(vif), ifa_list, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -105,10 +111,12 @@ static inline u64 drv_prepare_multicast(
 {
 	u64 ret = 0;
 
+	trace_drv_prepare_multicast(local, mc_list->count);
+
 	if (local->ops->prepare_multicast)
 		ret = local->ops->prepare_multicast(&local->hw, mc_list);
 
-	trace_drv_prepare_multicast(local, mc_list->count, ret);
+	trace_drv_return_u64(local, ret);
 
 	return ret;
 }
@@ -120,19 +128,21 @@ static inline void drv_configure_filter(
 {
 	might_sleep();
 
-	local->ops->configure_filter(&local->hw, changed_flags, total_flags,
-				     multicast);
 	trace_drv_configure_filter(local, changed_flags, total_flags,
 				   multicast);
+	local->ops->configure_filter(&local->hw, changed_flags, total_flags,
+				     multicast);
+	trace_drv_return_void(local);
 }
 
 static inline int drv_set_tim(struct ieee80211_local *local,
 			      struct ieee80211_sta *sta, bool set)
 {
 	int ret = 0;
+	trace_drv_set_tim(local, sta, set);
 	if (local->ops->set_tim)
 		ret = local->ops->set_tim(&local->hw, sta, set);
-	trace_drv_set_tim(local, sta, set, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -146,8 +156,9 @@ static inline int drv_set_key(struct iee
 
 	might_sleep();
 
+	trace_drv_set_key(local, cmd, sdata, sta, key);
 	ret = local->ops->set_key(&local->hw, cmd, &sdata->vif, sta, key);
-	trace_drv_set_key(local, cmd, sdata, sta, key, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -162,10 +173,11 @@ static inline void drv_update_tkip_key(s
 	if (sta)
 		ista = &sta->sta;
 
+	trace_drv_update_tkip_key(local, sdata, conf, ista, iv32);
 	if (local->ops->update_tkip_key)
 		local->ops->update_tkip_key(&local->hw, &sdata->vif, conf,
 					    ista, iv32, phase1key);
-	trace_drv_update_tkip_key(local, sdata, conf, ista, iv32);
+	trace_drv_return_void(local);
 }
 
 static inline int drv_hw_scan(struct ieee80211_local *local,
@@ -176,8 +188,9 @@ static inline int drv_hw_scan(struct iee
 
 	might_sleep();
 
+	trace_drv_hw_scan(local, sdata, req);
 	ret = local->ops->hw_scan(&local->hw, &sdata->vif, req);
-	trace_drv_hw_scan(local, sdata, req, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -185,18 +198,20 @@ static inline void drv_sw_scan_start(str
 {
 	might_sleep();
 
+	trace_drv_sw_scan_start(local);
 	if (local->ops->sw_scan_start)
 		local->ops->sw_scan_start(&local->hw);
-	trace_drv_sw_scan_start(local);
+	trace_drv_return_void(local);
 }
 
 static inline void drv_sw_scan_complete(struct ieee80211_local *local)
 {
 	might_sleep();
 
+	trace_drv_sw_scan_complete(local);
 	if (local->ops->sw_scan_complete)
 		local->ops->sw_scan_complete(&local->hw);
-	trace_drv_sw_scan_complete(local);
+	trace_drv_return_void(local);
 }
 
 static inline int drv_get_stats(struct ieee80211_local *local,
@@ -228,9 +243,10 @@ static inline int drv_set_rts_threshold(
 
 	might_sleep();
 
+	trace_drv_set_rts_threshold(local, value);
 	if (local->ops->set_rts_threshold)
 		ret = local->ops->set_rts_threshold(&local->hw, value);
-	trace_drv_set_rts_threshold(local, value, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -240,12 +256,13 @@ static inline int drv_set_coverage_class
 	int ret = 0;
 	might_sleep();
 
+	trace_drv_set_coverage_class(local, value);
 	if (local->ops->set_coverage_class)
 		local->ops->set_coverage_class(&local->hw, value);
 	else
 		ret = -EOPNOTSUPP;
 
-	trace_drv_set_coverage_class(local, value, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -254,9 +271,10 @@ static inline void drv_sta_notify(struct
 				  enum sta_notify_cmd cmd,
 				  struct ieee80211_sta *sta)
 {
+	trace_drv_sta_notify(local, sdata, cmd, sta);
 	if (local->ops->sta_notify)
 		local->ops->sta_notify(&local->hw, &sdata->vif, cmd, sta);
-	trace_drv_sta_notify(local, sdata, cmd, sta);
+	trace_drv_return_void(local);
 }
 
 static inline int drv_sta_add(struct ieee80211_local *local,
@@ -267,10 +285,11 @@ static inline int drv_sta_add(struct iee
 
 	might_sleep();
 
+	trace_drv_sta_add(local, sdata, sta);
 	if (local->ops->sta_add)
 		ret = local->ops->sta_add(&local->hw, &sdata->vif, sta);
 
-	trace_drv_sta_add(local, sdata, sta, ret);
+	trace_drv_return_int(local, ret);
 
 	return ret;
 }
@@ -281,10 +300,11 @@ static inline void drv_sta_remove(struct
 {
 	might_sleep();
 
+	trace_drv_sta_remove(local, sdata, sta);
 	if (local->ops->sta_remove)
 		local->ops->sta_remove(&local->hw, &sdata->vif, sta);
 
-	trace_drv_sta_remove(local, sdata, sta);
+	trace_drv_return_void(local);
 }
 
 static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
@@ -294,9 +314,10 @@ static inline int drv_conf_tx(struct iee
 
 	might_sleep();
 
+	trace_drv_conf_tx(local, queue, params);
 	if (local->ops->conf_tx)
 		ret = local->ops->conf_tx(&local->hw, queue, params);
-	trace_drv_conf_tx(local, queue, params, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -306,9 +327,10 @@ static inline u64 drv_get_tsf(struct iee
 
 	might_sleep();
 
+	trace_drv_get_tsf(local);
 	if (local->ops->get_tsf)
 		ret = local->ops->get_tsf(&local->hw);
-	trace_drv_get_tsf(local, ret);
+	trace_drv_return_u64(local, ret);
 	return ret;
 }
 
@@ -316,18 +338,20 @@ static inline void drv_set_tsf(struct ie
 {
 	might_sleep();
 
+	trace_drv_set_tsf(local, tsf);
 	if (local->ops->set_tsf)
 		local->ops->set_tsf(&local->hw, tsf);
-	trace_drv_set_tsf(local, tsf);
+	trace_drv_return_void(local);
 }
 
 static inline void drv_reset_tsf(struct ieee80211_local *local)
 {
 	might_sleep();
 
+	trace_drv_reset_tsf(local);
 	if (local->ops->reset_tsf)
 		local->ops->reset_tsf(&local->hw);
-	trace_drv_reset_tsf(local);
+	trace_drv_return_void(local);
 }
 
 static inline int drv_tx_last_beacon(struct ieee80211_local *local)
@@ -336,9 +360,10 @@ static inline int drv_tx_last_beacon(str
 
 	might_sleep();
 
+	trace_drv_tx_last_beacon(local);
 	if (local->ops->tx_last_beacon)
 		ret = local->ops->tx_last_beacon(&local->hw);
-	trace_drv_tx_last_beacon(local, ret);
+	trace_drv_return_int(local, ret);
 	return ret;
 }
 
@@ -352,11 +377,14 @@ static inline int drv_ampdu_action(struc
 
 	might_sleep();
 
+	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn);
+
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
 					       sta, tid, ssn);
 
-	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, ret);
+	trace_drv_return_int(local, ret);
+
 	return ret;
 }
 
@@ -385,6 +413,7 @@ static inline void drv_flush(struct ieee
 	trace_drv_flush(local, drop);
 	if (local->ops->flush)
 		local->ops->flush(&local->hw, drop);
+	trace_drv_return_void(local);
 }
 
 static inline void drv_channel_switch(struct ieee80211_local *local,
@@ -392,9 +421,9 @@ static inline void drv_channel_switch(st
 {
 	might_sleep();
 
-	local->ops->channel_switch(&local->hw, ch_switch);
-
 	trace_drv_channel_switch(local, ch_switch);
+	local->ops->channel_switch(&local->hw, ch_switch);
+	trace_drv_return_void(local);
 }
 
 #endif /* __MAC80211_DRIVER_OPS */
--- wireless-testing.orig/net/mac80211/driver-trace.h	2010-06-09 21:07:00.000000000 +0200
+++ wireless-testing/net/mac80211/driver-trace.h	2010-06-10 10:54:33.000000000 +0200
@@ -36,20 +36,58 @@ static inline void trace_ ## name(proto)
  * Tracing for driver callbacks.
  */
 
-TRACE_EVENT(drv_start,
-	TP_PROTO(struct ieee80211_local *local, int ret),
+TRACE_EVENT(drv_return_void,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+	TP_printk(LOCAL_PR_FMT, LOCAL_PR_ARG)
+);
 
+TRACE_EVENT(drv_return_int,
+	TP_PROTO(struct ieee80211_local *local, int ret),
 	TP_ARGS(local, ret),
-
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		__field(int, ret)
 	),
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+	),
+	TP_printk(LOCAL_PR_FMT " - %d", LOCAL_PR_ARG, __entry->ret)
+);
 
+TRACE_EVENT(drv_return_u64,
+	TP_PROTO(struct ieee80211_local *local, u64 ret),
+	TP_ARGS(local, ret),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u64, ret)
+	),
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		__entry->ret = ret;
 	),
+	TP_printk(LOCAL_PR_FMT " - %llu", LOCAL_PR_ARG, __entry->ret)
+);
+
+TRACE_EVENT(drv_start,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
 
 	TP_printk(
 		LOCAL_PR_FMT, LOCAL_PR_ARG
@@ -76,28 +114,25 @@ TRACE_EVENT(drv_stop,
 
 TRACE_EVENT(drv_add_interface,
 	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
-		 int ret),
+		 struct ieee80211_sub_if_data *sdata),
 
-	TP_ARGS(local, sdata, ret),
+	TP_ARGS(local, sdata),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
 		__array(char, addr, 6)
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
 		memcpy(__entry->addr, sdata->vif.addr, 6);
-		__entry->ret = ret;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT " addr:%pM ret:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, __entry->addr, __entry->ret
+		LOCAL_PR_FMT  VIF_PR_FMT " addr:%pM",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->addr
 	)
 );
 
@@ -126,15 +161,13 @@ TRACE_EVENT(drv_remove_interface,
 
 TRACE_EVENT(drv_config,
 	TP_PROTO(struct ieee80211_local *local,
-		 u32 changed,
-		 int ret),
+		 u32 changed),
 
-	TP_ARGS(local, changed, ret),
+	TP_ARGS(local, changed),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		__field(u32, changed)
-		__field(int, ret)
 		__field(u32, flags)
 		__field(int, power_level)
 		__field(int, dynamic_ps_timeout)
@@ -150,7 +183,6 @@ TRACE_EVENT(drv_config,
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		__entry->changed = changed;
-		__entry->ret = ret;
 		__entry->flags = local->hw.conf.flags;
 		__entry->power_level = local->hw.conf.power_level;
 		__entry->dynamic_ps_timeout = local->hw.conf.dynamic_ps_timeout;
@@ -164,8 +196,8 @@ TRACE_EVENT(drv_config,
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " ch:%#x freq:%d ret:%d",
-		LOCAL_PR_ARG, __entry->changed, __entry->center_freq, __entry->ret
+		LOCAL_PR_FMT " ch:%#x freq:%d",
+		LOCAL_PR_ARG, __entry->changed, __entry->center_freq
 	)
 );
 
@@ -221,50 +253,44 @@ TRACE_EVENT(drv_bss_info_changed,
 
 TRACE_EVENT(drv_configure_arp_filter,
 	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
-		 struct in_ifaddr *ifa_list, int ret),
+		 struct ieee80211_sub_if_data *sdata),
 
-	TP_ARGS(local, sdata, ifa_list, ret),
+	TP_ARGS(local, sdata),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		__entry->ret = ret;
 	),
 
 	TP_printk(
-		VIF_PR_FMT LOCAL_PR_FMT " ret:%d",
-		VIF_PR_ARG, LOCAL_PR_ARG, __entry->ret
+		VIF_PR_FMT LOCAL_PR_FMT,
+		VIF_PR_ARG, LOCAL_PR_ARG
 	)
 );
 
 TRACE_EVENT(drv_prepare_multicast,
-	TP_PROTO(struct ieee80211_local *local, int mc_count, u64 ret),
+	TP_PROTO(struct ieee80211_local *local, int mc_count),
 
-	TP_ARGS(local, mc_count, ret),
+	TP_ARGS(local, mc_count),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		__field(int, mc_count)
-		__field(u64, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		__entry->mc_count = mc_count;
-		__entry->ret = ret;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " prepare mc (%d): %llx",
-		LOCAL_PR_ARG, __entry->mc_count,
-		(unsigned long long) __entry->ret
+		LOCAL_PR_FMT " prepare mc (%d)",
+		LOCAL_PR_ARG, __entry->mc_count
 	)
 );
 
@@ -298,27 +324,25 @@ TRACE_EVENT(drv_configure_filter,
 
 TRACE_EVENT(drv_set_tim,
 	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sta *sta, bool set, int ret),
+		 struct ieee80211_sta *sta, bool set),
 
-	TP_ARGS(local, sta, set, ret),
+	TP_ARGS(local, sta, set),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		STA_ENTRY
 		__field(bool, set)
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		STA_ASSIGN;
 		__entry->set = set;
-		__entry->ret = ret;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT STA_PR_FMT " set:%d ret:%d",
-		LOCAL_PR_ARG, STA_PR_FMT, __entry->set, __entry->ret
+		LOCAL_PR_FMT STA_PR_FMT " set:%d",
+		LOCAL_PR_ARG, STA_PR_FMT, __entry->set
 	)
 );
 
@@ -326,9 +350,9 @@ TRACE_EVENT(drv_set_key,
 	TP_PROTO(struct ieee80211_local *local,
 		 enum set_key_cmd cmd, struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta,
-		 struct ieee80211_key_conf *key, int ret),
+		 struct ieee80211_key_conf *key),
 
-	TP_ARGS(local, cmd, sdata, sta, key, ret),
+	TP_ARGS(local, cmd, sdata, sta, key),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -338,7 +362,6 @@ TRACE_EVENT(drv_set_key,
 		__field(u8, hw_key_idx)
 		__field(u8, flags)
 		__field(s8, keyidx)
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
@@ -349,12 +372,11 @@ TRACE_EVENT(drv_set_key,
 		__entry->flags = key->flags;
 		__entry->keyidx = key->keyidx;
 		__entry->hw_key_idx = key->hw_key_idx;
-		__entry->ret = ret;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " ret:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->ret
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
 	)
 );
 
@@ -389,25 +411,23 @@ TRACE_EVENT(drv_update_tkip_key,
 TRACE_EVENT(drv_hw_scan,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-		 struct cfg80211_scan_request *req, int ret),
+		 struct cfg80211_scan_request *req),
 
-	TP_ARGS(local, sdata, req, ret),
+	TP_ARGS(local, sdata, req),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		__entry->ret = ret;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT VIF_PR_FMT " ret:%d",
-		LOCAL_PR_ARG,VIF_PR_ARG, __entry->ret
+		LOCAL_PR_FMT VIF_PR_FMT,
+		LOCAL_PR_ARG,VIF_PR_ARG
 	)
 );
 
@@ -504,48 +524,44 @@ TRACE_EVENT(drv_get_tkip_seq,
 );
 
 TRACE_EVENT(drv_set_rts_threshold,
-	TP_PROTO(struct ieee80211_local *local, u32 value, int ret),
+	TP_PROTO(struct ieee80211_local *local, u32 value),
 
-	TP_ARGS(local, value, ret),
+	TP_ARGS(local, value),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		__field(u32, value)
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
-		__entry->ret = ret;
 		__entry->value = value;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " value:%d ret:%d",
-		LOCAL_PR_ARG, __entry->value, __entry->ret
+		LOCAL_PR_FMT " value:%d",
+		LOCAL_PR_ARG, __entry->value
 	)
 );
 
 TRACE_EVENT(drv_set_coverage_class,
-	TP_PROTO(struct ieee80211_local *local, u8 value, int ret),
+	TP_PROTO(struct ieee80211_local *local, u8 value),
 
-	TP_ARGS(local, value, ret),
+	TP_ARGS(local, value),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		__field(u8, value)
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
-		__entry->ret = ret;
 		__entry->value = value;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " value:%d ret:%d",
-		LOCAL_PR_ARG, __entry->value, __entry->ret
+		LOCAL_PR_FMT " value:%d",
+		LOCAL_PR_ARG, __entry->value
 	)
 );
 
@@ -580,27 +596,25 @@ TRACE_EVENT(drv_sta_notify,
 TRACE_EVENT(drv_sta_add,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-		 struct ieee80211_sta *sta, int ret),
+		 struct ieee80211_sta *sta),
 
-	TP_ARGS(local, sdata, sta, ret),
+	TP_ARGS(local, sdata, sta),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
 		STA_ENTRY
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
 		STA_ASSIGN;
-		__entry->ret = ret;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " ret:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->ret
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
 	)
 );
 
@@ -631,10 +645,9 @@ TRACE_EVENT(drv_sta_remove,
 
 TRACE_EVENT(drv_conf_tx,
 	TP_PROTO(struct ieee80211_local *local, u16 queue,
-		 const struct ieee80211_tx_queue_params *params,
-		 int ret),
+		 const struct ieee80211_tx_queue_params *params),
 
-	TP_ARGS(local, queue, params, ret),
+	TP_ARGS(local, queue, params),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -643,13 +656,11 @@ TRACE_EVENT(drv_conf_tx,
 		__field(u16, cw_min)
 		__field(u16, cw_max)
 		__field(u8, aifs)
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		__entry->queue = queue;
-		__entry->ret = ret;
 		__entry->txop = params->txop;
 		__entry->cw_max = params->cw_max;
 		__entry->cw_min = params->cw_min;
@@ -657,29 +668,27 @@ TRACE_EVENT(drv_conf_tx,
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " queue:%d ret:%d",
-		LOCAL_PR_ARG, __entry->queue, __entry->ret
+		LOCAL_PR_FMT " queue:%d",
+		LOCAL_PR_ARG, __entry->queue
 	)
 );
 
 TRACE_EVENT(drv_get_tsf,
-	TP_PROTO(struct ieee80211_local *local, u64 ret),
+	TP_PROTO(struct ieee80211_local *local),
 
-	TP_ARGS(local, ret),
+	TP_ARGS(local),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		__field(u64, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
-		__entry->ret = ret;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " ret:%llu",
-		LOCAL_PR_ARG, (unsigned long long)__entry->ret
+		LOCAL_PR_FMT,
+		LOCAL_PR_ARG
 	)
 );
 
@@ -723,23 +732,21 @@ TRACE_EVENT(drv_reset_tsf,
 );
 
 TRACE_EVENT(drv_tx_last_beacon,
-	TP_PROTO(struct ieee80211_local *local, int ret),
+	TP_PROTO(struct ieee80211_local *local),
 
-	TP_ARGS(local, ret),
+	TP_ARGS(local),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
-		__entry->ret = ret;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " ret:%d",
-		LOCAL_PR_ARG, __entry->ret
+		LOCAL_PR_FMT,
+		LOCAL_PR_ARG
 	)
 );
 
@@ -748,9 +755,9 @@ TRACE_EVENT(drv_ampdu_action,
 		 struct ieee80211_sub_if_data *sdata,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
-		 u16 *ssn, int ret),
+		 u16 *ssn),
 
-	TP_ARGS(local, sdata, action, sta, tid, ssn, ret),
+	TP_ARGS(local, sdata, action, sta, tid, ssn),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -758,7 +765,6 @@ TRACE_EVENT(drv_ampdu_action,
 		__field(u32, action)
 		__field(u16, tid)
 		__field(u16, ssn)
-		__field(int, ret)
 		VIF_ENTRY
 	),
 
@@ -766,15 +772,14 @@ TRACE_EVENT(drv_ampdu_action,
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
 		STA_ASSIGN;
-		__entry->ret = ret;
 		__entry->action = action;
 		__entry->tid = tid;
 		__entry->ssn = ssn ? *ssn : 0;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d ret:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action, __entry->tid, __entry->ret
+		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action, __entry->tid
 	)
 );
 


