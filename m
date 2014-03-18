Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35305 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbaCRPGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 11:06:47 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v10 3/4] mac80211: implement chanctx reservation
Date: Tue, 18 Mar 2014 17:03:05 +0200
Message-Id: <1395154986-13810-4-git-send-email-luciano.coelho@intel.com> (sfid-20140318_160651_878419_21B5BDE1)
In-Reply-To: <1395154986-13810-1-git-send-email-luciano.coelho@intel.com>
References: <1395154986-13810-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to support channel switch with multiple vifs and multiple
contexts, we implement a concept of channel context reservation.  This
allows us to reserve a channel context to be used later.

The reservation functionality is not tied directly to channel switch
and may be used in other situations (eg. reserving a channel context
during IBSS join).

We first check if an existing compatible context exists and if it
does, we reserve it.  If there is no compatible context we create a
new one and reserve it.

Additionally, split ieee80211_vif_copy_chanctx_to_vlans() so we can
call it while already holding the chanctx mutex.

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

In v5:

   * removed a comment that was being removed, mistakenly, on the next
     patch;

In v7:

   * renamed local_changed variable to tmp_changed to avoid confusion;
   * call ieee80211_recalc_chanctx_min_def() in
     ieee80211_vif_use_reserved_chanctx();
   * use new combined ieee80211_assign_vif_chanctx() when using
     reserved channel;
   * don't stop queues before switching context;
   * call ieee80211_vif_copy_chanctx_to_vlans() in use_reserved();

In v8:

   * don't set sdata->vif.bss_conf.chandef twice;
   * split ieee80211_vif_copy_chanctx_to_vlans();
   * don't call the recalc functions twice;

In v9:

   * remove the same-context switch in use reserved() since that
     should be in the next patch;
   * move the local->mtx lockdep check from
     ieee80211_vif_copy_chanctx_to_vlans() to the inner function;

In v10:

   * only call __ieee80211_vif_copy_chanctx_to_vlans() if the vif type
     is AP.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/chan.c        | 197 +++++++++++++++++++++++++++++++++++++--------
 net/mac80211/ieee80211_i.h |  13 +++
 2 files changed, 176 insertions(+), 34 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5fa12f1..f7e581b 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -420,6 +420,9 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 
 	ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
+	if (sdata->reserved_chanctx)
+		ieee80211_vif_unreserve_chanctx(sdata);
+
 	ieee80211_assign_vif_chanctx(sdata, NULL);
 	if (ctx->refcount == 0)
 		ieee80211_free_chanctx(local, ctx);
@@ -612,6 +615,166 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
+static void
+__ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
+				      bool clear)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *vlan;
+	struct ieee80211_chanctx_conf *conf;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
+		return;
+
+	lockdep_assert_held(&local->mtx);
+
+	/* Check that conf exists, even when clearing this function
+	 * must be called with the AP's channel context still there
+	 * as it would otherwise cause VLANs to have an invalid
+	 * channel context pointer for a while, possibly pointing
+	 * to a channel context that has already been freed.
+	 */
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+				lockdep_is_held(&local->chanctx_mtx));
+	WARN_ON(!conf);
+
+	if (clear)
+		conf = NULL;
+
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		rcu_assign_pointer(vlan->vif.chanctx_conf, conf);
+}
+
+void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
+					 bool clear)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	mutex_lock(&local->chanctx_mtx);
+
+	__ieee80211_vif_copy_chanctx_to_vlans(sdata, clear);
+
+	mutex_unlock(&local->chanctx_mtx);
+}
+
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
+	new_ctx->refcount++;
+	sdata->reserved_chanctx = new_ctx;
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
+	int ret;
+	u32 tmp_changed = *changed;
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
+	if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
+		tmp_changed |= BSS_CHANGED_BANDWIDTH;
+
+	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+
+	/* unref our reservation before assigning */
+	ctx->refcount--;
+	sdata->reserved_chanctx = NULL;
+
+	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
+	if (old_ctx->refcount == 0)
+		ieee80211_free_chanctx(local, old_ctx);
+	if (ret) {
+		/* if assign fails refcount stays the same */
+		if (ctx->refcount == 0)
+			ieee80211_free_chanctx(local, ctx);
+		goto out;
+	}
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
+
+	*changed = tmp_changed;
+
+	ieee80211_recalc_chanctx_chantype(local, ctx);
+	ieee80211_recalc_smps_chanctx(local, ctx);
+	ieee80211_recalc_radar_chanctx(local, ctx);
+	ieee80211_recalc_chanctx_min_def(local, ctx);
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	return ret;
+}
+
 int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 				   const struct cfg80211_chan_def *chandef,
 				   u32 *changed)
@@ -691,40 +854,6 @@ void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->chanctx_mtx);
 }
 
-void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
-					 bool clear)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sub_if_data *vlan;
-	struct ieee80211_chanctx_conf *conf;
-
-	lockdep_assert_held(&local->mtx);
-
-	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
-		return;
-
-	mutex_lock(&local->chanctx_mtx);
-
-	/*
-	 * Check that conf exists, even when clearing this function
-	 * must be called with the AP's channel context still there
-	 * as it would otherwise cause VLANs to have an invalid
-	 * channel context pointer for a while, possibly pointing
-	 * to a channel context that has already been freed.
-	 */
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-				lockdep_is_held(&local->chanctx_mtx));
-	WARN_ON(!conf);
-
-	if (clear)
-		conf = NULL;
-
-	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-		rcu_assign_pointer(vlan->vif.chanctx_conf, conf);
-
-	mutex_unlock(&local->chanctx_mtx);
-}
-
 void ieee80211_iter_chan_contexts_atomic(
 	struct ieee80211_hw *hw,
 	void (*iter)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2f662ca..6949099 100644
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
 
@@ -1776,6 +1780,15 @@ ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
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
1.9.0

