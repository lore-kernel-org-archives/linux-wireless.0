Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:43827 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750990AbaEWCii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 22:38:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, michal.kazior@tieto.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 May 2014 05:38:23 +0300
Message-Id: <1400812703-15685-1-git-send-email-luca@coelho.fi> (sfid-20140523_043843_440631_354985B3)
In-Reply-To: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
References: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
Subject: [PATCH] mac80211: add a single-transaction driver op to switch contexts
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In some cases, when the driver is already using all the channel
contexts it can handle at once, we have to do an in-place switch
(ie. we cannot afford using an extra context temporarily for the
transaction).  But some drivers may not support switching the channel
context assigned to a vif on the fly (ie. without unassigning and
assigning it) while others may only work if the context is changed on
the fly, without unassigning it first.

To allow these different scenarios, add a new driver operation that
let's the driver decide how to handle an in-place switch.

Additionally, remove the IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag,
since we never change a running context directly anymore.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h    | 53 ++++++++++++++++++++++++++----
 net/mac80211/chan.c       | 78 +++++++++++++++++++++++++++++++++++++------
 net/mac80211/driver-ops.h | 40 ++++++++++++++++++++++
 net/mac80211/trace.h      | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 239 insertions(+), 16 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2c78997..38c10ea 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -189,6 +189,43 @@ struct ieee80211_chanctx_conf {
 };
 
 /**
+ * enum ieee80211_chanctx_switch_mode - channel context switch mode
+ * @CHANCTX_SWMODE_REASSIGN_VIF: Both old and new contexts already
+ *	exist (and will continue to exist), but the virtual interface
+ *	needs to be switched from one to the other.
+ * @CHANCTX_SWMODE_SWAP_CONTEXTS: The old context exists but will stop
+ *      to exist with this call, the new context doesn't exist but
+ *      will be active after this call, the virtual interface switches
+ *      from the old to the new (note that the driver may of course
+ *      implement this as an on-the-fly chandef switch of the existing
+ *      hardware context, but the mac80211 pointer for the old context
+ *      will cease to exist and only the new one will later be used
+ *      for changes/removal.)
+ */
+enum ieee80211_chanctx_switch_mode {
+	CHANCTX_SWMODE_REASSIGN_VIF,
+	CHANCTX_SWMODE_SWAP_CONTEXTS,
+};
+
+/**
+ * struct ieee80211_vif_chanctx_switch - vif chanctx switch information
+ *
+ * This is structure is used to pass information about a vif that
+ * needs to switch from one chanctx to another.  The
+ * &ieee80211_chanctx_switch_mode defines how the switch should be
+ * done.
+ *
+ * @vif: the vif that should be switched from old_ctx to new_ctx
+ * @old_ctx: the old context to which the vif was assigned
+ * @new_ctx: the new context to which the vif must be assigned
+ */
+struct ieee80211_vif_chanctx_switch {
+	struct ieee80211_vif *vif;
+	struct ieee80211_chanctx_conf *old_ctx;
+	struct ieee80211_chanctx_conf *new_ctx;
+};
+
+/**
  * enum ieee80211_bss_change - BSS change notification flags
  *
  * These flags are used with the bss_info_changed() callback
@@ -1564,11 +1601,6 @@ struct ieee80211_tx_control {
  *	is not enabled the default action is to disconnect when getting the
  *	CSA frame.
  *
- * @IEEE80211_HW_CHANGE_RUNNING_CHANCTX: The hardware can change a
- *	channel context on-the-fly.  This is needed for channel switch
- *	on single-channel hardware.  It can also be used as an
- *	optimization in certain channel switch cases with
- *	multi-channel.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1600,7 +1632,6 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
-	IEEE80211_HW_CHANGE_RUNNING_CHANCTX		= 1<<29,
 };
 
 /**
@@ -2736,6 +2767,12 @@ enum ieee80211_roc_type {
  *	to vif. Possible use is for hw queue remapping.
  * @unassign_vif_chanctx: Notifies device driver about channel context being
  *	unbound from vif.
+
+ * @switch_vif_chanctx: switch a number of vifs from one chanctx to
+ *	another, as specified in the list of
+ *	@ieee80211_vif_chanctx_switch passed to the driver, according
+ *	to the mode defined in &ieee80211_chanctx_switch_mode.
+ *
  * @start_ap: Start operation on the AP interface, this is called after all the
  *	information in bss_conf is set and beacon can be retrieved. A channel
  *	context is bound before this is called. Note that if the driver uses
@@ -2952,6 +2989,10 @@ struct ieee80211_ops {
 	void (*unassign_vif_chanctx)(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_chanctx_conf *ctx);
+	int (*switch_vif_chanctx)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif_chanctx_switch *vifs,
+				  int n_vifs,
+				  enum ieee80211_chanctx_switch_mode mode);
 
 	void (*restart_complete)(struct ieee80211_hw *hw);
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3702d64..20defee 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -928,10 +928,10 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	new_ctx = ieee80211_find_reservation_chanctx(local, chandef, mode);
 	if (!new_ctx) {
 		if (ieee80211_chanctx_refcount(local, curr_ctx) == 1 &&
-		    (local->hw.flags & IEEE80211_HW_CHANGE_RUNNING_CHANCTX)) {
+		    local->ops->switch_vif_chanctx) {
 			/* if we're the only users of the chanctx and
-			 * the driver supports changing a running
-			 * context, reserve our current context
+			 * the driver supports chanctx switches
+			 * reserve our current context.
 			 */
 			new_ctx = curr_ctx;
 		} else if (ieee80211_can_create_new_chanctx(local)) {
@@ -956,6 +956,65 @@ out:
 	return ret;
 }
 
+static int
+ieee80211_vif_change_reserved_context(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_chanctx *old_ctx)
+{
+	struct ieee80211_local *local = sdata->local;
+	const struct cfg80211_chan_def *chandef = &sdata->reserved_chandef;
+	struct ieee80211_chanctx *new_ctx;
+	struct ieee80211_vif_chanctx_switch vifs[1];
+	int err, changed;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	new_ctx = ieee80211_alloc_chanctx(local, chandef, old_ctx->mode);
+	if (!new_ctx) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	vifs[0].vif = &sdata->vif;
+	vifs[0].old_ctx = &old_ctx->conf;
+	vifs[0].new_ctx = &new_ctx->conf;
+
+	/* turn idle off *before* setting channel -- some drivers need that */
+	changed = ieee80211_idle_off(local);
+	ieee80211_hw_config(local, changed);
+
+	err = drv_switch_vif_chanctx(local, vifs, 1,
+				     CHANCTX_SWMODE_SWAP_CONTEXTS);
+	if (err)
+		goto err_idle;
+
+	rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);
+
+	list_del_rcu(&old_ctx->list);
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
+
+	list_add_rcu(&new_ctx->list, &local->chanctx_list);
+	kfree_rcu(old_ctx, rcu_head);
+
+	ieee80211_recalc_txpower(sdata);
+	ieee80211_recalc_chanctx_chantype(local, new_ctx);
+	ieee80211_recalc_smps_chanctx(local, new_ctx);
+	ieee80211_recalc_radar_chanctx(local, new_ctx);
+	ieee80211_recalc_chanctx_min_def(local, new_ctx);
+	ieee80211_recalc_idle(local);
+
+	return 0;
+
+err_idle:
+	ieee80211_recalc_idle(local);
+	kfree_rcu(new_ctx, rcu_head);
+err:
+	return err;
+
+}
+
 int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 				       u32 *changed)
 {
@@ -999,8 +1058,7 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 
 	if (old_ctx == ctx) {
 		/* This is our own context, just change it */
-		ret = __ieee80211_vif_change_channel(sdata, old_ctx,
-						     &tmp_changed);
+		ret = ieee80211_vif_change_reserved_context(sdata, old_ctx);
 		if (ret)
 			goto out;
 	} else {
@@ -1016,14 +1074,14 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
+
+		ieee80211_recalc_chanctx_chantype(local, ctx);
+		ieee80211_recalc_smps_chanctx(local, ctx);
+		ieee80211_recalc_radar_chanctx(local, ctx);
+		ieee80211_recalc_chanctx_min_def(local, ctx);
 	}
 
 	*changed = tmp_changed;
-
-	ieee80211_recalc_chanctx_chantype(local, ctx);
-	ieee80211_recalc_smps_chanctx(local, ctx);
-	ieee80211_recalc_radar_chanctx(local, ctx);
-	ieee80211_recalc_chanctx_min_def(local, ctx);
 out:
 	mutex_unlock(&local->chanctx_mtx);
 	return ret;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 696ef78..58feb29 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1048,6 +1048,46 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int
+drv_switch_vif_chanctx(struct ieee80211_local *local,
+		       struct ieee80211_vif_chanctx_switch *vifs,
+		       int n_vifs,
+		       enum ieee80211_chanctx_switch_mode mode)
+{
+	int ret = 0;
+	int i;
+
+	if (!local->ops->switch_vif_chanctx)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < n_vifs; i++) {
+		struct ieee80211_chanctx *old_ctx =
+			container_of(vifs[i].old_ctx,
+				     struct ieee80211_chanctx,
+				     conf);
+
+		WARN_ON_ONCE(!old_ctx->driver_present);
+	}
+
+	trace_drv_switch_vif_chanctx(local, vifs, n_vifs, mode);
+	ret = local->ops->switch_vif_chanctx(&local->hw,
+					     vifs, n_vifs, mode);
+	trace_drv_return_int(local, ret);
+
+	if (!ret && mode == CHANCTX_SWMODE_SWAP_CONTEXTS) {
+		for (i = 0; i < n_vifs; i++) {
+			struct ieee80211_chanctx *new_ctx =
+				container_of(vifs[i].new_ctx,
+					     struct ieee80211_chanctx,
+					     conf);
+
+			new_ctx->driver_present = true;
+		}
+	}
+
+	return ret;
+}
+
 static inline int drv_start_ap(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 942f64b..272f51f 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1389,6 +1389,90 @@ TRACE_EVENT(drv_change_chanctx,
 	)
 );
 
+#if !defined(__TRACE_VIF_ENTRY)
+#define __TRACE_VIF_ENTRY
+struct trace_vif_entry {
+	enum nl80211_iftype vif_type;
+	bool p2p;
+	char vif_name[8];
+};
+
+struct trace_chandef_entry {
+	u32 control_freq;
+	u32 chan_width;
+	u32 center_freq1;
+	u32 center_freq2;
+};
+
+struct trace_switch_entry {
+	struct trace_vif_entry vif;
+	struct trace_chandef_entry old_chandef;
+	struct trace_chandef_entry new_chandef;
+};
+
+#define SWITCH_ENTRY_ASSIGN(to, from) local_vifs[i].to = vifs[i].from
+#endif
+
+TRACE_EVENT(drv_switch_vif_chanctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_vif_chanctx_switch *vifs,
+		 int n_vifs, enum ieee80211_chanctx_switch_mode mode),
+	    TP_ARGS(local, vifs, n_vifs, mode),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, n_vifs)
+		__field(u32, mode)
+		__dynamic_array(u8, vifs,
+				sizeof(struct trace_switch_entry) * n_vifs)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->n_vifs = n_vifs;
+		__entry->mode = mode;
+		{
+			struct trace_switch_entry *local_vifs =
+				__get_dynamic_array(vifs);
+			int i;
+
+			for (i = 0; i < n_vifs; i++) {
+				struct ieee80211_sub_if_data *sdata;
+
+				sdata = container_of(vifs[i].vif,
+						struct ieee80211_sub_if_data,
+						vif);
+
+				SWITCH_ENTRY_ASSIGN(vif.vif_type, vif->type);
+				SWITCH_ENTRY_ASSIGN(vif.p2p, vif->p2p);
+				strncpy(local_vifs[i].vif.vif_name,
+					sdata->name, 8);
+				SWITCH_ENTRY_ASSIGN(old_chandef.control_freq,
+						old_ctx->def.chan->center_freq);
+				SWITCH_ENTRY_ASSIGN(old_chandef.chan_width,
+						    old_ctx->def.width);
+				SWITCH_ENTRY_ASSIGN(old_chandef.center_freq1,
+						    old_ctx->def.center_freq1);
+				SWITCH_ENTRY_ASSIGN(old_chandef.center_freq2,
+						    old_ctx->def.center_freq2);
+				SWITCH_ENTRY_ASSIGN(new_chandef.control_freq,
+						new_ctx->def.chan->center_freq);
+				SWITCH_ENTRY_ASSIGN(new_chandef.chan_width,
+						    new_ctx->def.width);
+				SWITCH_ENTRY_ASSIGN(new_chandef.center_freq1,
+						    new_ctx->def.center_freq1);
+				SWITCH_ENTRY_ASSIGN(new_chandef.center_freq2,
+						    new_ctx->def.center_freq2);
+			}
+		}
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " n_vifs:%d mode:%d",
+		LOCAL_PR_ARG, __entry->n_vifs, __entry->mode
+	)
+);
+
 DECLARE_EVENT_CLASS(local_sdata_chanctx,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
2.0.0.rc0

