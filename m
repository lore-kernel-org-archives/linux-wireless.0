Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2G0LRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 04/20] mac80211: add chanctx tracing
Date: Fri, 27 Jul 2012 13:16:40 +0200
Message-Id: <1343387816-9414-5-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131741_297829_2335218B)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/driver-ops.h |   10 ++++++
 net/mac80211/trace.h      |   88 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index b38f97d..da0fa69 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -870,22 +870,28 @@ static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
 static inline void drv_add_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *ctx)
 {
+	trace_drv_add_chanctx(local, ctx);
 	if (local->ops->add_chanctx)
 		local->ops->add_chanctx(&local->hw, &ctx->conf);
+	trace_drv_return_void(local);
 }
 
 static inline void drv_remove_chanctx(struct ieee80211_local *local,
 				      struct ieee80211_chanctx *ctx)
 {
+	trace_drv_remove_chanctx(local, ctx);
 	if (local->ops->remove_chanctx)
 		local->ops->remove_chanctx(&local->hw, &ctx->conf);
+	trace_drv_return_void(local);
 }
 
 static inline void drv_change_chantype(struct ieee80211_local *local,
 				       struct ieee80211_chanctx *ctx)
 {
+	trace_drv_change_chantype(local, ctx);
 	if (local->ops->change_chantype)
 		local->ops->change_chantype(&local->hw, &ctx->conf);
+	trace_drv_return_void(local);
 }
 
 static inline void drv_assign_vif_chanctx(struct ieee80211_local *local,
@@ -894,10 +900,12 @@ static inline void drv_assign_vif_chanctx(struct ieee80211_local *local,
 {
 	check_sdata_in_driver(sdata);
 
+	trace_drv_assign_vif_chanctx(local, sdata, ctx);
 	if (local->ops->assign_vif_chanctx)
 		local->ops->assign_vif_chanctx(&local->hw,
 					       &sdata->vif,
 					       &ctx->conf);
+	trace_drv_return_void(local);
 }
 
 static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
@@ -906,10 +914,12 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
 {
 	check_sdata_in_driver(sdata);
 
+	trace_drv_unassign_vif_chanctx(local, sdata, ctx);
 	if (local->ops->unassign_vif_chanctx)
 		local->ops->unassign_vif_chanctx(&local->hw,
 						 &sdata->vif,
 						 &ctx->conf);
+	trace_drv_return_void(local);
 }
 
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 65e9a2a..a0cd3cb 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1253,6 +1253,94 @@ DEFINE_EVENT(local_sdata_evt, drv_mgd_prepare_tx,
 	TP_ARGS(local, sdata)
 );
 
+DECLARE_EVENT_CLASS(local_chanctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_chanctx *ctx),
+
+	TP_ARGS(local, ctx),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(void *, ctx)
+		__field(int, freq)
+		__field(int, chantype)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ctx = ctx;
+		__entry->freq = ctx->conf.channel->center_freq;
+		__entry->chantype = ctx->conf.channel_type;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " ctx:%p freq:%dMhz chantype:%d",
+		LOCAL_PR_ARG, __entry->ctx, __entry->freq, __entry->chantype
+	)
+);
+
+DEFINE_EVENT(local_chanctx, drv_add_chanctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_chanctx *ctx),
+	TP_ARGS(local, ctx)
+);
+
+DEFINE_EVENT(local_chanctx, drv_remove_chanctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_chanctx *ctx),
+	TP_ARGS(local, ctx)
+);
+
+DEFINE_EVENT(local_chanctx, drv_change_chantype,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_chanctx *ctx),
+	TP_ARGS(local, ctx)
+);
+
+DECLARE_EVENT_CLASS(local_sdata_chanctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_chanctx *ctx),
+
+	TP_ARGS(local, sdata, ctx),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(void *, ctx)
+		__field(int, freq)
+		__field(int, chantype)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->ctx = ctx;
+		__entry->freq = ctx->conf.channel->center_freq;
+		__entry->chantype = ctx->conf.channel_type;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT " ctx:%p freq:%dMhz chantype:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG,
+		__entry->ctx, __entry->freq, __entry->chantype
+	)
+);
+
+DEFINE_EVENT(local_sdata_chanctx, drv_assign_vif_chanctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_chanctx *ctx),
+	TP_ARGS(local, sdata, ctx)
+);
+
+DEFINE_EVENT(local_sdata_chanctx, drv_unassign_vif_chanctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_chanctx *ctx),
+	TP_ARGS(local, sdata, ctx)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.7.10.4

