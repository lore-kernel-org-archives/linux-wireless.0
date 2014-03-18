Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58597 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbaCRN7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:30 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so5340433eek.23
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:29 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 17/21] mac80211: use chanctx reservation for AP CSA
Date: Tue, 18 Mar 2014 14:53:20 +0100
Message-Id: <1395150804-24090-18-git-send-email-michal.kazior@tieto.com> (sfid-20140318_150214_549180_0ACE8DA0)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel switch finalization is now 2-step. First
step is when driver calls csa_finish(), the other
is when reservation is actually finalized (which
be defered for in-place reservation).

This implies driver must not call csa_finish()
more than once for each channel_switch request.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c  | 77 +++++++++++++++++++++++++++++++++++++----------------
 net/mac80211/chan.c | 11 +++++++-
 2 files changed, 64 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5f63e1d..3979f2f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3088,7 +3088,7 @@ static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
@@ -3096,25 +3096,35 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->mtx);
 
-	sdata->radar_required = sdata->csa_radar_required;
-	err = ieee80211_vif_change_channel(sdata, &changed);
-	if (WARN_ON(err < 0))
-		return;
+	/* using reservation isn't immediate as it may be deferred until later
+	 * with multi-vif. once reservation is complete it will re-schedule the
+	 * work with no reserved_chanctx so verify chandef to check if it
+	 * completed successfully */
 
-	if (!local->use_chanctx) {
-		local->_oper_chandef = sdata->csa_chandef;
-		ieee80211_hw_config(local, 0);
+	if (sdata->reserved_chanctx) {
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
 	if (err)
-		return;
+		return err;
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
+
+	return 0;
 }
 
 void ieee80211_csa_finalize_work(struct work_struct *work)
@@ -3123,9 +3133,11 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     csa_finalize_work);
 	struct ieee80211_local *local = sdata->local;
+	int err;
 
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
+	mutex_lock(&local->chanctx_mtx);
 
 	/* AP might have been stopped while waiting for the lock. */
 	if (!sdata->vif.csa_active)
@@ -3134,13 +3146,20 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		goto unlock;
 
-	ieee80211_csa_finalize(sdata);
+	err = ieee80211_csa_finalize(sdata);
+	if (err) {
+		sdata_info(sdata, "failed to finalize channel switch\n");
+		/* FIXME: disconnect the interface */
+		goto unlock;
+	}
+
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 
 unlock:
+	mutex_unlock(&local->chanctx_mtx);
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
@@ -3275,7 +3294,7 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
-	int err, num_chanctx, changed = 0;
+	int err, changed = 0;
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
@@ -3290,6 +3309,10 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				       &sdata->vif.bss_conf.chandef))
 		return -EINVAL;
 
+	/* don't allow another channel switch if one is already active. */
+	if (sdata->vif.csa_active)
+		return -EBUSY;
+
 	mutex_lock(&local->chanctx_mtx);
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
 					 lockdep_is_held(&local->chanctx_mtx));
@@ -3298,27 +3321,34 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return -EBUSY;
 	}
 
-	/* don't handle for multi-VIF cases */
 	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
-	if (ieee80211_chanctx_refcount(local, chanctx) > 1) {
+	if (!chanctx) {
 		mutex_unlock(&local->chanctx_mtx);
 		return -EBUSY;
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
+	if (err) {
+		mutex_unlock(&local->chanctx_mtx);
+		return err;
+	}
 
-	/* don't allow another channel switch if one is already active. */
-	if (sdata->vif.csa_active)
-		return -EBUSY;
+	/* if reservation is invalid then this will fail */
+	err = ieee80211_check_combinations(sdata, NULL, chanctx->mode, 0);
+	if (err) {
+		ieee80211_vif_unreserve_chanctx(sdata);
+		mutex_unlock(&local->chanctx_mtx);
+		return err;
+	}
 
 	err = ieee80211_set_csa_beacon(sdata, params, &changed);
-	if (err)
+	if (err) {
+		ieee80211_vif_unreserve_chanctx(sdata);
+		mutex_unlock(&local->chanctx_mtx);
 		return err;
+	}
 
 	sdata->csa_radar_required = params->radar_required;
 	sdata->csa_chandef = params->chandef;
@@ -3338,6 +3368,7 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		ieee80211_csa_finalize(sdata);
 	}
 
+	mutex_unlock(&local->chanctx_mtx);
 	return 0;
 }
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 7cf8970..2959b7f 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -965,7 +965,16 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
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
-- 
1.8.5.3

