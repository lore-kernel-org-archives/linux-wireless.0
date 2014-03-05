Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:35999 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaCELLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 06:11:50 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v5 2/3] mac80211: implement chanctx reservation
Date: Wed,  5 Mar 2014 13:11:43 +0200
Message-Id: <1394017904-4012-3-git-send-email-luca@coelho.fi> (sfid-20140305_121157_481462_FD764783)
In-Reply-To: <1394017904-4012-1-git-send-email-luca@coelho.fi>
References: <1394017904-4012-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In order to support channel switch with multiple vifs and multiple
contexts, we implement a concept of channel context reservation.  This
allows us to reserve a channel context to be used later.

The reservation functionality is not tied directly to channel switch
and may be used in other situations (eg. reserving a channel context
during IBSS join).

We first check if an existing compatible context exists and if it
does, we reserve it.  If there is no compatible context we create a
new one and reserve it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
In RFC v2:

   * reformulated the patch to make channel reservation generic and
     not only for channel switch, as we may find other uses for it in
     the future;
   * added ieee80211_vif_unreserve_chanctx();
   * removed reservation of the current chanctx from this patch;
   * added a stop_queue_reason for chanctx reservation;
   * added a few TODOs according to Michal's comments to be handled in
     future patch series;
   * set sdata->csa_chandef to the received chandef in all cases (it
     was only happening in the alone-in-the-vif case;

In v3:

   * removed stray empty line;
   * reworded the commit message;
   * added reserved_chandef;
   * added comment about reserved_chanctx and reserved_chandef protection;
   * wake the queues if ieee80211_assign_vif_chanctx() fails;

In v4:

   * add chanctx mode parameter to ieee80211_vif_reserve_chanctx();
   * compare the vif's previous BSS width with the reserved new width
     instead of comparing it to the chanctx's combined width;
---
 net/mac80211/chan.c        | 127 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  14 +++++
 2 files changed, 141 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index a27c6ec..9dfdba5 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -419,6 +419,9 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 
 	ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
+	if (sdata->reserved_chanctx)
+		ieee80211_vif_unreserve_chanctx(sdata);
+
 	ieee80211_unassign_vif_chanctx(sdata, ctx);
 	if (ctx->refcount == 0)
 		ieee80211_free_chanctx(local, ctx);
@@ -611,6 +614,130 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
+int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
+{
+	lockdep_assert_held(&sdata->local->chanctx_mtx);
+
+	if (WARN_ON(!sdata->reserved_chanctx))
+		return -EINVAL;
+
+	if (--sdata->reserved_chanctx->refcount == 0)
+		ieee80211_free_chanctx(sdata->local, sdata->reserved_chanctx);
+
+	sdata->reserved_chanctx = NULL;
+
+	return 0;
+}
+
+int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
+				  const struct cfg80211_chan_def *chandef,
+				  enum ieee80211_chanctx_mode mode)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *new_ctx, *curr_ctx;
+	int ret = 0;
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
+	new_ctx = ieee80211_find_chanctx(local, chandef, mode);
+	if (!new_ctx) {
+		/* create a new context */
+		new_ctx = ieee80211_new_chanctx(local, chandef, mode);
+		if (IS_ERR(new_ctx)) {
+			ret = PTR_ERR(new_ctx);
+			goto out;
+		}
+	}
+
+	/* reserve the new or existing context */
+	sdata->reserved_chanctx = new_ctx;
+	new_ctx->refcount++;
+
+	sdata->reserved_chandef = *chandef;
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
+	ctx = sdata->reserved_chanctx;
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
+	ieee80211_stop_queues_by_reason(&local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CHANCTX);
+
+	ieee80211_unassign_vif_chanctx(sdata, old_ctx);
+	if (old_ctx->refcount == 0)
+		ieee80211_free_chanctx(local, old_ctx);
+
+	if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
+		local_changed |= BSS_CHANGED_BANDWIDTH;
+
+	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+
+	/* unref our reservation before assigning */
+	ctx->refcount--;
+	sdata->reserved_chanctx = NULL;
+	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
+	if (ret) {
+		/* if assign fails refcount stays the same */
+		if (ctx->refcount == 0)
+			ieee80211_free_chanctx(local, ctx);
+		goto out_wake;
+	}
+
+	*changed = local_changed;
+
+	ieee80211_recalc_chanctx_chantype(local, ctx);
+	ieee80211_recalc_smps_chanctx(local, ctx);
+	ieee80211_recalc_radar_chanctx(local, ctx);
+out_wake:
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CHANCTX);
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	return ret;
+}
+
 int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 				   const struct cfg80211_chan_def *chandef,
 				   u32 *changed)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8603dfb..ae8acc2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -756,6 +756,10 @@ struct ieee80211_sub_if_data {
 	bool csa_radar_required;
 	struct cfg80211_chan_def csa_chandef;
 
+	/* context reservation -- protected with chanctx_mtx */
+	struct ieee80211_chanctx *reserved_chanctx;
+	struct cfg80211_chan_def reserved_chandef;
+
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
 
@@ -899,6 +903,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
 	IEEE80211_QUEUE_STOP_REASON_FLUSH,
+	IEEE80211_QUEUE_STOP_REASON_CHANCTX,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -1776,6 +1781,15 @@ ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 			  const struct cfg80211_chan_def *chandef,
 			  enum ieee80211_chanctx_mode mode);
 int __must_check
+ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
+			      const struct cfg80211_chan_def *chandef,
+			      enum ieee80211_chanctx_mode mode);
+int __must_check
+ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
+				   u32 *changed);
+int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata);
+
+int __must_check
 ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 			       const struct cfg80211_chan_def *chandef,
 			       u32 *changed);
-- 
1.8.5.3

