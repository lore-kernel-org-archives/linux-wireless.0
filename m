Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:56507 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab2FUMDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 08:03:42 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v2 4/7] mac80211: add chanctx tracing
Date: Thu, 21 Jun 2012 14:03:33 +0200
Message-ID: <1340280216-18807-5-git-send-email-michal.kazior@tieto.com> (sfid-20120621_140356_253977_5FF402C0)
In-Reply-To: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/driver-ops.h   |   10 +++++
 net/mac80211/driver-trace.h |   88 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e79f06d..dde9f33 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -850,24 +850,30 @@ static inline void
 drv_add_chanctx(struct ieee80211_local *local,
 		struct ieee80211_chanctx *ctx)
 {
+	trace_drv_add_chanctx(local, ctx);
 	if (local->ops->add_chanctx)
 		local->ops->add_chanctx(&local->hw, &ctx->conf);
+	trace_drv_return_void(local);
 }
 
 static inline void
 drv_remove_chanctx(struct ieee80211_local *local,
 		   struct ieee80211_chanctx *ctx)
 {
+	trace_drv_remove_chanctx(local, ctx);
 	if (local->ops->remove_chanctx)
 		local->ops->remove_chanctx(&local->hw, &ctx->conf);
+	trace_drv_return_void(local);
 }
 
 static inline void
 drv_change_chantype(struct ieee80211_local *local,
 		    struct ieee80211_chanctx *ctx)
 {
+	trace_drv_change_chantype(local, ctx);
 	if (local->ops->change_chantype)
 		local->ops->change_chantype(&local->hw, &ctx->conf);
+	trace_drv_return_void(local);
 }
 
 static inline void
@@ -877,10 +883,12 @@ drv_assign_vif_chanctx(struct ieee80211_local *local,
 {
 	check_sdata_in_driver(sdata);
 
+	trace_drv_assign_vif_chanctx(local, sdata, ctx);
 	if (local->ops->assign_vif_chanctx)
 		local->ops->assign_vif_chanctx(&local->hw,
 					       &sdata->vif,
 					       &ctx->conf);
+	trace_drv_return_void(local);
 }
 
 static inline void
@@ -890,10 +898,12 @@ drv_unassign_vif_chanctx(struct ieee80211_local *local,
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
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6de00b2..16b0e43 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -1606,6 +1606,94 @@ TRACE_EVENT(stop_queue,
 		LOCAL_PR_ARG, __entry->queue, __entry->reason
 	)
 );
+
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
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.0.4

