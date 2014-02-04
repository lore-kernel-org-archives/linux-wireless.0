Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:57266 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaBDM7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 07:59:32 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: michal.kazior@tieto.com, johannes@sipsolutions.net,
	kvalo@adurom.com
Subject: [RCF/WIP 2/3] mac80211: implement channel switch for multiple vifs and multiple channels
Date: Tue,  4 Feb 2014 14:59:26 +0200
Message-Id: <1391518767-25847-3-git-send-email-luca@coelho.fi> (sfid-20140204_135946_685848_F915D8F0)
In-Reply-To: <1391518767-25847-1-git-send-email-luca@coelho.fi>
References: <1391518767-25847-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In order to support CSA handling with multiple vifs and multiple
contexts, we implement a concept of reserving a context when the CSA
process is started.  This allows us to know whether the CSA can be
done before we try to do it (which is useful in AP mode, for
instance).  When the actual channel switch happens, this reserved
context is used.

When reserving the context, the following algorithm is used:

1) try to find an existing context that matches our future chandef and
   reserve it if it exists;
2) otherwise, check if we're the only vif in the current context, in
   which case we can just change our current context.  To prevent
   other vifs from joining this context in the meantime, we mark it as
   exclusive.  This is an optimization to avoid using extra contexts
   when not necessary;
3) if we're not the only vif in the current context, create a new
   context and reserve it;

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/chan.c        | 146 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |   8 +++
 2 files changed, 154 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index a27c6ec..4289c22 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -611,6 +611,150 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
+int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
+				  const struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *new_ctx, *curr_ctx;
+	int ret;
+
+	/* TODO: check !use_ctxt stuff */
+
+	mutex_lock(&local->chanctx_mtx);
+
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
+
+	/* try to find another context with the chandef we want */
+	new_ctx = ieee80211_find_chanctx(local, chandef,
+					 IEEE80211_CHANCTX_SHARED);
+	if (new_ctx) {
+		/* reserve the existing compatible context */
+		sdata->csa_reserved_chanctx = new_ctx;
+		new_ctx->refcount++;
+	} else if (curr_ctx->refcount == 1) {
+		/* We're the only user of the current context, mark it
+		 * as exclusive, so nobody tries to use it until we
+		 * finish the channel switch.  This is an optimization
+		 * to prevent waste of contexts when the number is
+		 * limited.
+		 */
+
+		sdata->csa_reserved_chanctx = curr_ctx;
+		sdata->csa_chandef = *chandef;
+
+		sdata->csa_chanctx_old_mode = curr_ctx->mode;
+
+		curr_ctx->mode = IEEE80211_CHANCTX_EXCLUSIVE;
+	} else {
+		/* create a new context and reserve it */
+		new_ctx = ieee80211_new_chanctx(local, chandef,
+						IEEE80211_CHANCTX_SHARED);
+		if (IS_ERR(new_ctx)) {
+			ret = PTR_ERR(new_ctx);
+			goto out;
+		}
+		sdata->csa_reserved_chanctx = new_ctx;
+
+		new_ctx->refcount++;
+	}
+
+	ret = 0;
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	return ret;
+}
+
+int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
+				       u32 *changed)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx *ctx;
+	struct ieee80211_chanctx *old_ctx;
+	struct ieee80211_chanctx_conf *conf;
+	int ret, local_changed = *changed;
+
+	/* TODO: need to recheck if the chandef is usable etc.? */
+
+	lockdep_assert_held(&local->mtx);
+
+	mutex_lock(&local->chanctx_mtx);
+
+	ctx = sdata->csa_reserved_chanctx;
+	if (WARN_ON(!ctx)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
+
+	if (old_ctx == ctx) {
+		/* This is our own context, just change it */
+		ret = __ieee80211_vif_change_channel(sdata, old_ctx,
+						     &local_changed);
+		if (ret)
+			goto out;
+
+		/* TODO: what happens if another vif created a context
+		 * that is compatible with our future chandef while
+		 * this one has been marked as exclusive? Merge?
+		 */
+
+		ctx->mode = sdata->csa_chanctx_old_mode;
+
+		*changed = local_changed;
+		goto out;
+	}
+
+	ieee80211_stop_queues_by_reason(&local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	ieee80211_unassign_vif_chanctx(sdata, old_ctx);
+	if (old_ctx->refcount == 0)
+		ieee80211_free_chanctx(local, old_ctx);
+
+	if (sdata->vif.bss_conf.chandef.width != ctx->conf.def.width)
+		local_changed |= BSS_CHANGED_BANDWIDTH;
+
+	sdata->vif.bss_conf.chandef = ctx->conf.def;
+
+	/* unref our reservation before assigning */
+	ctx->refcount--;
+	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
+	if (ret) {
+		/* if assign fails refcount stays the same */
+		if (ctx->refcount == 0)
+			ieee80211_free_chanctx(local, ctx);
+		goto out;
+	}
+
+	/* TODO: should we wake the queues here? */
+
+	*changed = local_changed;
+
+	ieee80211_recalc_chanctx_chantype(local, ctx);
+	ieee80211_recalc_smps_chanctx(local, ctx);
+	ieee80211_recalc_radar_chanctx(local, ctx);
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	return ret;
+}
+
 int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 				   const struct cfg80211_chan_def *chandef,
 				   u32 *changed)
@@ -664,6 +808,8 @@ void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 {
 	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
 
+	/* TODO: remember to remove the reservation in here! */
+
 	lockdep_assert_held(&sdata->local->mtx);
 
 	mutex_lock(&sdata->local->chanctx_mtx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0014b53..df85562 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -755,6 +755,8 @@ struct ieee80211_sub_if_data {
 	int csa_counter_offset_presp;
 	bool csa_radar_required;
 	struct cfg80211_chan_def csa_chandef;
+	struct ieee80211_chanctx *csa_reserved_chanctx;
+	enum ieee80211_chanctx_mode csa_chanctx_old_mode;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
@@ -1774,6 +1776,12 @@ ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 			  const struct cfg80211_chan_def *chandef,
 			  enum ieee80211_chanctx_mode mode);
 int __must_check
+ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
+			      const struct cfg80211_chan_def *chandef);
+int __must_check
+ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
+				   u32 *changed);
+int __must_check
 ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 			       const struct cfg80211_chan_def *chandef,
 			       u32 *changed);
-- 
1.8.5.3

