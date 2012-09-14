Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52613 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2INMgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:36:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 02/10] mac80211: introduce new ieee80211_ops
Date: Fri, 14 Sep 2012 14:37:05 +0200
Message-Id: <1347626233-21916-3-git-send-email-johannes@sipsolutions.net> (sfid-20120914_143648_672285_373D4740)
In-Reply-To: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Introduce channel context driver methods. The channel
on a context channel is immutable, but the channel type
and other properties can change.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |   24 ++++++++++
 net/mac80211/driver-ops.h |   65 +++++++++++++++++++++++++++
 net/mac80211/trace.h      |  107 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 196 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ab1b5ba..d9d2119 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2353,6 +2353,16 @@ enum ieee80211_rate_control_changed {
  *	The callback will be called before each transmission and upon return
  *	mac80211 will transmit the frame right away.
  *	The callback is optional and can (should!) sleep.
+ *
+ * @add_chanctx: Notifies device driver about new channel context creation.
+ * @remove_chanctx: Notifies device driver about channel context destruction.
+ * @change_chanctx: Notifies device driver about channel context changes that
+ *	may happen when combining different virtual interfaces on the same
+ *	channel context with different settings
+ * @assign_vif_chanctx: Notifies device driver about channel context being bound
+ *	to vif. Possible use is for hw queue remapping.
+ * @unassign_vif_chanctx: Notifies device driver about channel context being
+ *	unbound from vif.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2497,6 +2507,20 @@ struct ieee80211_ops {
 
 	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif);
+
+	int (*add_chanctx)(struct ieee80211_hw *hw,
+			   struct ieee80211_chanctx_conf *ctx);
+	void (*remove_chanctx)(struct ieee80211_hw *hw,
+			       struct ieee80211_chanctx_conf *ctx);
+	void (*change_chanctx)(struct ieee80211_hw *hw,
+			       struct ieee80211_chanctx_conf *ctx,
+			       u32 changed);
+	int (*assign_vif_chanctx)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_chanctx_conf *ctx);
+	void (*unassign_vif_chanctx)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_chanctx_conf *ctx);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index da9003b..77407b3 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -871,4 +871,69 @@ static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
 		local->ops->mgd_prepare_tx(&local->hw, &sdata->vif);
 	trace_drv_return_void(local);
 }
+
+static inline int drv_add_chanctx(struct ieee80211_local *local,
+				  struct ieee80211_chanctx *ctx)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_drv_add_chanctx(local, ctx);
+	if (local->ops->add_chanctx)
+		ret = local->ops->add_chanctx(&local->hw, &ctx->conf);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline void drv_remove_chanctx(struct ieee80211_local *local,
+				      struct ieee80211_chanctx *ctx)
+{
+	trace_drv_remove_chanctx(local, ctx);
+	if (local->ops->remove_chanctx)
+		local->ops->remove_chanctx(&local->hw, &ctx->conf);
+	trace_drv_return_void(local);
+}
+
+static inline void drv_change_chanctx(struct ieee80211_local *local,
+				      struct ieee80211_chanctx *ctx,
+				      u32 changed)
+{
+	trace_drv_change_chanctx(local, ctx, changed);
+	if (local->ops->change_chanctx)
+		local->ops->change_chanctx(&local->hw, &ctx->conf, changed);
+	trace_drv_return_void(local);
+}
+
+static inline int drv_assign_vif_chanctx(struct ieee80211_local *local,
+					 struct ieee80211_sub_if_data *sdata,
+					 struct ieee80211_chanctx *ctx)
+{
+	int ret = 0;
+
+	check_sdata_in_driver(sdata);
+
+	trace_drv_assign_vif_chanctx(local, sdata, ctx);
+	if (local->ops->assign_vif_chanctx)
+		ret = local->ops->assign_vif_chanctx(&local->hw,
+						     &sdata->vif,
+						     &ctx->conf);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
+					    struct ieee80211_sub_if_data *sdata,
+					    struct ieee80211_chanctx *ctx)
+{
+	check_sdata_in_driver(sdata);
+
+	trace_drv_unassign_vif_chanctx(local, sdata, ctx);
+	if (local->ops->unassign_vif_chanctx)
+		local->ops->unassign_vif_chanctx(&local->hw,
+						 &sdata->vif,
+						 &ctx->conf);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 18d9c8a..a3f5fe2 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -28,6 +28,15 @@
 #define VIF_PR_FMT	" vif:%s(%d%s)"
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 
+#define CHANCTX_ENTRY	__field(int, freq)					\
+			__field(int, chantype)
+#define CHANCTX_ASSIGN	__entry->freq = ctx->conf.channel->center_freq;		\
+			__entry->chantype = ctx->conf.channel_type
+#define CHANCTX_PR_FMT	" freq:%d MHz chantype:%d"
+#define CHANCTX_PR_ARG	__entry->freq, __entry->chantype
+
+
+
 /*
  * Tracing for driver callbacks.
  */
@@ -1256,6 +1265,104 @@ DEFINE_EVENT(local_sdata_evt, drv_mgd_prepare_tx,
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
+		CHANCTX_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		CHANCTX_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT CHANCTX_PR_FMT,
+		LOCAL_PR_ARG, CHANCTX_PR_ARG
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
+TRACE_EVENT(drv_change_chanctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_chanctx *ctx,
+		 u32 changed),
+
+	TP_ARGS(local, ctx, changed),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		CHANCTX_ENTRY
+		__field(u32, changed)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		CHANCTX_ASSIGN;
+		__entry->changed = changed;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT CHANCTX_PR_FMT " changed:%#x",
+		LOCAL_PR_ARG, CHANCTX_PR_ARG, __entry->changed
+	)
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
+		CHANCTX_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		CHANCTX_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT CHANCTX_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, CHANCTX_PR_ARG
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

