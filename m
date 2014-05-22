Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57427 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaEVOPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:15:11 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2717916eei.33
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 07:15:10 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v6 4/6] mac80211: use chanctx reservation for AP CSA
Date: Thu, 22 May 2014 16:07:54 +0200
Message-Id: <1400767676-15994-5-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161531_282950_2A61A0AD)
In-Reply-To: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel switch finalization is now 2-step. First
step is when driver calls csa_finish(), the other
is when reservation is actually finalized (which
be defered for in-place reservation).

It is now safe to call ieee80211_csa_finish() more
then once.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v3:
     * fix lockdep typo s/mtx/chanctx_mtx/ [Johannes]
     * fix comment style [Johannes]
     * use goto for cleaner unlocking/returning [Johannes]
     * squash with ieee80211_vif_change_channel() removal patch [Johannes]
     * fix commit message [Johannes]
     * add resilience for multiple ieee80211_csa_finish() calls
    
    v4:
     * split removal of ieee80211_vif_change_channel()

 net/mac80211/cfg.c  | 82 +++++++++++++++++++++++++++++++++++------------------
 net/mac80211/chan.c | 11 ++++++-
 2 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aab258b..b75014e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3114,17 +3114,35 @@ static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
 
-	sdata->radar_required = sdata->csa_radar_required;
-	err = ieee80211_vif_change_channel(sdata, &changed);
-	if (err < 0)
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
@@ -3160,6 +3178,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
+	mutex_lock(&local->chanctx_mtx);
 
 	/* AP might have been stopped while waiting for the lock. */
 	if (!sdata->vif.csa_active)
@@ -3171,6 +3190,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	ieee80211_csa_finalize(sdata);
 
 unlock:
+	mutex_unlock(&local->chanctx_mtx);
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
@@ -3314,7 +3334,7 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
-	int err, num_chanctx, changed = 0;
+	int err, changed = 0;
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
@@ -3329,37 +3349,43 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
@@ -3377,7 +3403,9 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		ieee80211_csa_finalize(sdata);
 	}
 
-	return 0;
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	return err;
 }
 
 int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3965470..6ca007f 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -966,7 +966,16 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
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

