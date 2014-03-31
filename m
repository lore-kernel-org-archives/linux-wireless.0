Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35535 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaCaMKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 08:10:25 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so5939930wgg.9
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 05:10:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 2/5] mac80211: use chanctx reservation for AP CSA
Date: Mon, 31 Mar 2014 14:04:16 +0200
Message-Id: <1396267459-9976-3-git-send-email-michal.kazior@tieto.com> (sfid-20140331_141040_035163_E95C8A42)
In-Reply-To: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
References: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
 <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel switch finalization is now 2-step. First
step is when driver calls csa_finish(), the other
is when reservation is actually finalized (which
be defered for in-place reservation).

Also remove the ieee80211_vif_change_channel()
which isn't used anymore.

It is now safe to call ieee80211_csa_finish() more
then once.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v3:
 * fix lockdep typo s/mtx/chanctx_mtx/ [Johannes]
 * fix comment style [Johannes]
 * use goto for cleaner unlocking/returning [Johannes]
 * squash with ieee80211_vif_change_channel() removal patch [Johannes]
 * fix commit message [Johannes]
 * add resilience for multiple ieee80211_csa_finish() calls

 net/mac80211/cfg.c         | 82 +++++++++++++++++++++++++++++++---------------
 net/mac80211/chan.c        | 75 ++++++------------------------------------
 net/mac80211/ieee80211_i.h |  5 ---
 3 files changed, 65 insertions(+), 97 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 871830e..be9e0c5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3096,17 +3096,35 @@ static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
 
-	sdata->radar_required = sdata->csa_radar_required;
-	err = ieee80211_vif_change_channel(sdata, &changed);
-	if (WARN_ON(err < 0))
-		return err;
+	/*
+	 * using reservation isn't immediate as it may be deferred until later
+	 * with multi-vif. once reservation is complete it will re-schedule the
+	 * work with no reserved_chanctx so verify chandef to check if it
+	 * completed successfully
+	 */
 
-	if (!local->use_chanctx) {
-		local->_oper_chandef = sdata->csa_chandef;
-		ieee80211_hw_config(local, 0);
+	if (sdata->reserved_chanctx) {
+		/*
+		 * with multi-vif csa driver may call ieee80211_csa_finish()
+		 * many times while waiting for other interfaces to use their
+		 * reservations
+		 */
+		if (sdata->reserved_ready)
+			return 0;
+
+		err = ieee80211_vif_use_reserved_context(sdata);
+		if (err)
+			return err;
+
+		return 0;
 	}
 
+	if (!cfg80211_chandef_identical(&sdata->vif.bss_conf.chandef,
+					&sdata->csa_chandef))
+		return -EINVAL;
+
 	sdata->vif.csa_active = false;
 
 	err = ieee80211_set_after_csa_beacon(sdata, &changed);
@@ -3134,6 +3152,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
+	mutex_lock(&local->chanctx_mtx);
 
 	/* AP might have been stopped while waiting for the lock. */
 	if (!sdata->vif.csa_active)
@@ -3150,6 +3169,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	}
 
 unlock:
+	mutex_unlock(&local->chanctx_mtx);
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
@@ -3284,7 +3304,7 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
-	int err, num_chanctx, changed = 0;
+	int err, changed = 0;
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
@@ -3299,37 +3319,43 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				       &sdata->vif.bss_conf.chandef))
 		return -EINVAL;
 
+	/* don't allow another channel switch if one is already active. */
+	if (sdata->vif.csa_active)
+		return -EBUSY;
+
 	mutex_lock(&local->chanctx_mtx);
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
 					 lockdep_is_held(&local->chanctx_mtx));
 	if (!conf) {
-		mutex_unlock(&local->chanctx_mtx);
-		return -EBUSY;
+		err = -EBUSY;
+		goto out;
 	}
 
-	/* don't handle for multi-VIF cases */
 	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
-	if (ieee80211_chanctx_refcount(local, chanctx) > 1) {
-		mutex_unlock(&local->chanctx_mtx);
-		return -EBUSY;
+	if (!chanctx) {
+		err = -EBUSY;
+		goto out;
 	}
-	num_chanctx = 0;
-	list_for_each_entry_rcu(chanctx, &local->chanctx_list, list)
-		num_chanctx++;
-	mutex_unlock(&local->chanctx_mtx);
 
-	if (num_chanctx > 1)
-		return -EBUSY;
+	err = ieee80211_vif_reserve_chanctx(sdata, &params->chandef,
+					    chanctx->mode,
+					    params->radar_required);
+	if (err)
+		goto out;
 
-	/* don't allow another channel switch if one is already active. */
-	if (sdata->vif.csa_active)
-		return -EBUSY;
+	/* if reservation is invalid then this will fail */
+	err = ieee80211_check_combinations(sdata, NULL, chanctx->mode, 0);
+	if (err) {
+		ieee80211_vif_unreserve_chanctx(sdata);
+		goto out;
+	}
 
 	err = ieee80211_set_csa_beacon(sdata, params, &changed);
-	if (err)
-		return err;
+	if (err) {
+		ieee80211_vif_unreserve_chanctx(sdata);
+		goto out;
+	}
 
-	sdata->csa_radar_required = params->radar_required;
 	sdata->csa_chandef = params->chandef;
 	sdata->csa_block_tx = params->block_tx;
 	sdata->vif.csa_active = true;
@@ -3347,7 +3373,9 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		ieee80211_csa_finalize(sdata);
 	}
 
-	return 0;
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	return err;
 }
 
 int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 6870c3c..94e06c0 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -799,70 +799,6 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
-static int __ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-					  struct ieee80211_chanctx *ctx,
-					  u32 *changed)
-{
-	struct ieee80211_local *local = sdata->local;
-	const struct cfg80211_chan_def *chandef = &sdata->csa_chandef;
-	u32 chanctx_changed = 0;
-
-	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
-				     IEEE80211_CHAN_DISABLED))
-		return -EINVAL;
-
-	if (ieee80211_chanctx_refcount(local, ctx) != 1)
-		return -EINVAL;
-
-	if (sdata->vif.bss_conf.chandef.width != chandef->width) {
-		chanctx_changed = IEEE80211_CHANCTX_CHANGE_WIDTH;
-		*changed |= BSS_CHANGED_BANDWIDTH;
-	}
-
-	sdata->vif.bss_conf.chandef = *chandef;
-	ctx->conf.def = *chandef;
-
-	chanctx_changed |= IEEE80211_CHANCTX_CHANGE_CHANNEL;
-	drv_change_chanctx(local, ctx, chanctx_changed);
-
-	ieee80211_recalc_chanctx_chantype(local, ctx);
-	ieee80211_recalc_smps_chanctx(local, ctx);
-	ieee80211_recalc_radar_chanctx(local, ctx);
-	ieee80211_recalc_chanctx_min_def(local, ctx);
-
-	return 0;
-}
-
-int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-				 u32 *changed)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *conf;
-	struct ieee80211_chanctx *ctx;
-	int ret;
-
-	lockdep_assert_held(&local->mtx);
-
-	/* should never be called if not performing a channel switch. */
-	if (WARN_ON(!sdata->vif.csa_active))
-		return -EINVAL;
-
-	mutex_lock(&local->chanctx_mtx);
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	ctx = container_of(conf, struct ieee80211_chanctx, conf);
-
-	ret = __ieee80211_vif_change_channel(sdata, ctx, changed);
- out:
-	mutex_unlock(&local->chanctx_mtx);
-	return ret;
-}
-
 static void
 __ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 				      bool clear)
@@ -964,7 +900,16 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 static void
 ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
 {
-	/* stub */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->csa_finalize_work);
+		break;
+	default:
+		break;
+	}
 }
 
 static int
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a941260..40e0d0d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -755,7 +755,6 @@ struct ieee80211_sub_if_data {
 	struct work_struct csa_finalize_work;
 	int csa_counter_offset_beacon;
 	int csa_counter_offset_presp;
-	bool csa_radar_required;
 	bool csa_block_tx; /* write-protected by sdata_lock and local->mtx */
 	struct cfg80211_chan_def csa_chandef;
 
@@ -1802,10 +1801,6 @@ int __must_check
 ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 			       const struct cfg80211_chan_def *chandef,
 			       u32 *changed);
-/* NOTE: only use ieee80211_vif_change_channel() for channel switch */
-int __must_check
-ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-			     u32 *changed);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
-- 
1.8.5.3

