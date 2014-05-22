Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53877 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaEVOPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:15:08 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so2680904eei.14
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 07:15:06 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v6 1/6] mac80211: introduce switch_vif_chanctx op
Date: Thu, 22 May 2014 16:07:51 +0200
Message-Id: <1400767676-15994-2-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161526_509592_88650116)
In-Reply-To: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new device driver operation will be used for
channel context reservation and switching.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h    |  28 ++++++++++++
 net/mac80211/driver-ops.h |  36 +++++++++++++++
 net/mac80211/main.c       |   2 +
 net/mac80211/trace.h      | 111 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 177 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a34f26a..831607e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -161,6 +161,23 @@ enum ieee80211_chanctx_change {
 };
 
 /**
+ * enum ieee80211_chanctx_swmode - channel switch mode
+ * @IEEE80211_CHANCTX_SWMODE_REASSIGN: simply re-assign chanctx to/from vifs.
+ *	Both contexts in old_ctx and new_ctx are already known to device driver.
+ * @IEEE80211_CHANCTX_SWMODE_SWAP: contexts in old_ctx are known to device
+ *	driver and are supposed to be treated as if remove_chanctx() was called for
+ *	each on success. Contexts in new_ctx aren't known to device driver at
+ *	call time and are supposed to be treated as if add_chanctx() was called
+ *	for each on success. This is used for channel switching when there are
+ *	no channel context allocations possible and contexts must be swapped
+ *	"in place".
+ */
+enum ieee80211_chanctx_swmode {
+	IEEE80211_CHANCTX_SWMODE_REASSIGN,
+	IEEE80211_CHANCTX_SWMODE_SWAP,
+};
+
+/**
  * struct ieee80211_chanctx_conf - channel context that vifs may be tuned to
  *
  * This is the driver-visible part. The ieee80211_chanctx
@@ -2736,6 +2753,11 @@ enum ieee80211_roc_type {
  *	to vif. Possible use is for hw queue remapping.
  * @unassign_vif_chanctx: Notifies device driver about channel context being
  *	unbound from vif.
+ * @switch_vif_chanctx: Requests driver to perform a channel switch. It passes
+ *	a list of triplets (vif, oldctx, newctx). Driver should try to restore
+ *	pre-call state if it fails.
+ *	The callback is optional and can sleep.
+ *
  * @start_ap: Start operation on the AP interface, this is called after all the
  *	information in bss_conf is set and beacon can be retrieved. A channel
  *	context is bound before this is called. Note that if the driver uses
@@ -2948,6 +2970,12 @@ struct ieee80211_ops {
 	void (*unassign_vif_chanctx)(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_chanctx_conf *ctx);
+	int (*switch_vif_chanctx)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif **vifs,
+				  struct ieee80211_chanctx_conf **old_ctx,
+				  struct ieee80211_chanctx_conf **new_ctx,
+				  int n_vifs,
+				  enum ieee80211_chanctx_swmode swmode);
 
 	void (*restart_complete)(struct ieee80211_hw *hw);
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index df1d502..8e8c290 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1048,6 +1048,42 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+#define IEEE80211_MAX_NUM_SWITCH_VIFS 8
+
+static inline int drv_switch_vif_chanctx(struct ieee80211_local *local,
+					 struct ieee80211_sub_if_data **sdata,
+					 struct ieee80211_chanctx **old_ctx,
+					 struct ieee80211_chanctx **new_ctx,
+					 int n_vifs,
+					 enum ieee80211_chanctx_swmode swmode)
+{
+	struct ieee80211_vif *vifs[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
+	struct ieee80211_chanctx_conf *old_conf[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
+	struct ieee80211_chanctx_conf *new_conf[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
+	int i, ret = 0;
+
+	if (local->ops->switch_vif_chanctx)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < n_vifs; i++)
+		if (!check_sdata_in_driver(sdata[i]))
+			return -EIO;
+
+	for (i = 0; i < n_vifs; i++) {
+		trace_drv_switch_vif_chanctx(local, sdata[i], old_ctx[i],
+					     new_ctx[i], n_vifs, swmode, i);
+
+		vifs[i] = &sdata[i]->vif;
+		old_conf[i] = &old_ctx[i]->conf;
+		new_conf[i] = &new_ctx[i]->conf;
+	}
+
+	ret = local->ops->switch_vif_chanctx(&local->hw, vifs, old_conf,
+					     new_conf, n_vifs, swmode);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int drv_start_ap(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 767335f..acdb4b5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -502,6 +502,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	if (WARN_ON(i != 0 && i != 5))
 		return NULL;
 	use_chanctx = i == 5;
+	if (WARN_ON(!use_chanctx && ops->switch_vif_chanctx))
+		return NULL;
 
 	/* Ensure 32-byte alignment of our private data and hw private data.
 	 * We use the wiphy priv data for both our ieee80211_local and for
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a0b0aea..c9bb678 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1414,6 +1414,117 @@ DEFINE_EVENT(local_sdata_chanctx, drv_unassign_vif_chanctx,
 	TP_ARGS(local, sdata, ctx)
 );
 
+TRACE_EVENT(drv_switch_vif_chanctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_chanctx *old_ctx,
+		 struct ieee80211_chanctx *new_ctx,
+		 int n_vifs,
+		 enum ieee80211_chanctx_swmode swmode,
+		 int i),
+
+	TP_ARGS(local, sdata, old_ctx, new_ctx, n_vifs, swmode, i),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+
+		__field(u32, old_control_freq)
+		__field(u32, old_chan_width)
+		__field(u32, old_center_freq1)
+		__field(u32, old_center_freq2)
+		__field(u32, old_min_control_freq)
+		__field(u32, old_min_chan_width)
+		__field(u32, old_min_center_freq1)
+		__field(u32, old_min_center_freq2)
+		__field(u8, old_rx_chains_static)
+		__field(u8, old_rx_chains_dynamic)
+
+		__field(u32, new_control_freq)
+		__field(u32, new_chan_width)
+		__field(u32, new_center_freq1)
+		__field(u32, new_center_freq2)
+		__field(u32, new_min_control_freq)
+		__field(u32, new_min_chan_width)
+		__field(u32, new_min_center_freq1)
+		__field(u32, new_min_center_freq2)
+		__field(u8, new_rx_chains_static)
+		__field(u8, new_rx_chains_dynamic)
+
+		__field(u32, n_vifs)
+		__field(u32, swmode)
+		__field(u32, i)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+
+		__entry->old_control_freq = old_ctx->conf.def.chan ? old_ctx->conf.def.chan->center_freq : 0;
+		__entry->old_chan_width = old_ctx->conf.def.width;
+		__entry->old_center_freq1 = old_ctx->conf.def.center_freq1;
+		__entry->old_center_freq2 = old_ctx->conf.def.center_freq2;
+		__entry->old_min_control_freq = old_ctx->conf.min_def.chan ? old_ctx->conf.min_def.chan->center_freq : 0;
+		__entry->old_min_chan_width = old_ctx->conf.min_def.width;
+		__entry->old_min_center_freq1 = old_ctx->conf.min_def.center_freq1;
+		__entry->old_min_center_freq2 = old_ctx->conf.min_def.center_freq2;
+		__entry->old_rx_chains_static = old_ctx->conf.rx_chains_static;
+		__entry->old_rx_chains_dynamic = old_ctx->conf.rx_chains_dynamic;
+
+		__entry->new_control_freq = new_ctx->conf.def.chan ? new_ctx->conf.def.chan->center_freq : 0;
+		__entry->new_chan_width = new_ctx->conf.def.width;
+		__entry->new_center_freq1 = new_ctx->conf.def.center_freq1;
+		__entry->new_center_freq2 = new_ctx->conf.def.center_freq2;
+		__entry->new_min_control_freq = new_ctx->conf.min_def.chan ? new_ctx->conf.min_def.chan->center_freq : 0;
+		__entry->new_min_chan_width = new_ctx->conf.min_def.width;
+		__entry->new_min_center_freq1 = new_ctx->conf.min_def.center_freq1;
+		__entry->new_min_center_freq2 = new_ctx->conf.min_def.center_freq2;
+		__entry->new_rx_chains_static = new_ctx->conf.rx_chains_static;
+		__entry->new_rx_chains_dynamic = new_ctx->conf.rx_chains_dynamic;
+
+		__entry->n_vifs = n_vifs;
+		__entry->swmode = swmode;
+		__entry->i = i;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT
+		" old_ctx:"
+		" control:%d MHz width:%d center: %d/%d MHz"
+		" min_control:%d MHz min_width:%d min_center: %d/%d MHz"
+		" chains:%d/%d"
+		" new_ctx:"
+		" control:%d MHz width:%d center: %d/%d MHz"
+		" min_control:%d MHz min_width:%d min_center: %d/%d MHz"
+		" chains:%d/%d"
+		" n_vifs:%d swmode:%d i:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG,
+		__entry->old_control_freq,
+		__entry->old_chan_width,
+		__entry->old_center_freq1,
+		__entry->old_center_freq2,
+		__entry->old_min_control_freq,
+		__entry->old_min_chan_width,
+		__entry->old_min_center_freq1,
+		__entry->old_min_center_freq2,
+		__entry->old_rx_chains_static,
+		__entry->old_rx_chains_dynamic,
+		__entry->new_control_freq,
+		__entry->new_chan_width,
+		__entry->new_center_freq1,
+		__entry->new_center_freq2,
+		__entry->new_min_control_freq,
+		__entry->new_min_chan_width,
+		__entry->new_min_center_freq1,
+		__entry->new_min_center_freq2,
+		__entry->new_rx_chains_static,
+		__entry->new_rx_chains_dynamic,
+		__entry->n_vifs,
+		__entry->swmode,
+		__entry->i
+	)
+);
+
 TRACE_EVENT(drv_start_ap,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
1.8.5.3

