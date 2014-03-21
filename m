Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45651 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965718AbaCUN6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:58:12 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so1818406eek.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:58:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/7] mac80211: use chanctx reservation for AP CSA
Date: Fri, 21 Mar 2014 14:52:17 +0100
Message-Id: <1395409941-26303-4-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145824_059420_EB85AFD8)
In-Reply-To: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
 <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
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
 net/mac80211/cfg.c  | 62 ++++++++++++++++++++++++++++++++++++-----------------
 net/mac80211/chan.c | 11 +++++++++-
 2 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0c68269..ba544d3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3096,17 +3096,25 @@ static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->mtx);
 
-	sdata->radar_required = sdata->csa_radar_required;
-	err = ieee80211_vif_change_channel(sdata, &changed);
-	if (WARN_ON(err < 0))
-		return err;
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
@@ -3129,6 +3137,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
+	mutex_lock(&local->chanctx_mtx);
 
 	/* AP might have been stopped while waiting for the lock. */
 	if (!sdata->vif.csa_active)
@@ -3150,6 +3159,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 
 unlock:
+	mutex_unlock(&local->chanctx_mtx);
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
@@ -3284,7 +3294,7 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
-	int err, num_chanctx, changed = 0;
+	int err, changed = 0;
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
@@ -3299,6 +3309,10 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				       &sdata->vif.bss_conf.chandef))
 		return -EINVAL;
 
+	/* don't allow another channel switch if one is already active. */
+	if (sdata->vif.csa_active)
+		return -EBUSY;
+
 	mutex_lock(&local->chanctx_mtx);
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
 					 lockdep_is_held(&local->chanctx_mtx));
@@ -3307,27 +3321,34 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
@@ -3347,6 +3368,7 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		ieee80211_csa_finalize(sdata);
 	}
 
+	mutex_unlock(&local->chanctx_mtx);
 	return 0;
 }
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c630501..c171837 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -957,7 +957,16 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
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

