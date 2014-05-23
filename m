Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44288 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752200AbaEWLdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 07:33:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, michal.kazior@tieto.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 May 2014 14:33:13 +0300
Message-Id: <1400844793-18069-2-git-send-email-luca@coelho.fi> (sfid-20140523_133336_081302_1C9BA4E9)
In-Reply-To: <1400844793-18069-1-git-send-email-luca@coelho.fi>
References: <1400838772.4358.22.camel@jlt4.sipsolutions.net>
 <1400844793-18069-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 2/2] mac80211: use switch_vif_chanctx to change a running chanctx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of hammering a new channel into the running context, make use
of the new switch_vif_chanctx to let the driver decide how to perform
the switch.

Additionally, remove the IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag,
since we never change a running context directly anymore.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h |  6 ----
 net/mac80211/chan.c    | 77 +++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 236c5c3..38c10ea 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1601,11 +1601,6 @@ struct ieee80211_tx_control {
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
@@ -1637,7 +1632,6 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
-	IEEE80211_HW_CHANGE_RUNNING_CHANCTX		= 1<<29,
 };
 
 /**
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3702d64..7084c2b 100644
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
@@ -956,6 +956,64 @@ out:
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
+}
+
 int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 				       u32 *changed)
 {
@@ -999,8 +1057,7 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 
 	if (old_ctx == ctx) {
 		/* This is our own context, just change it */
-		ret = __ieee80211_vif_change_channel(sdata, old_ctx,
-						     &tmp_changed);
+		ret = ieee80211_vif_change_reserved_context(sdata, old_ctx);
 		if (ret)
 			goto out;
 	} else {
@@ -1016,14 +1073,14 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 
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
-- 
2.0.0.rc0

