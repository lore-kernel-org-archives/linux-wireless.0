Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:38369 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbaFQNGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 09:06:54 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so7220910wes.11
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jun 2014 06:06:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v10 3/5] mac80211: use chanctx reservation for AP CSA
Date: Tue, 17 Jun 2014 14:58:56 +0200
Message-Id: <1403009938-1084-4-git-send-email-michal.kazior@tieto.com> (sfid-20140617_150700_754978_BC9F0648)
In-Reply-To: <1403009938-1084-1-git-send-email-michal.kazior@tieto.com>
References: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
 <1403009938-1084-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel switch finalization is now 2-step. First
step is when driver calls csa_finish(), the other
is when reservation is actually finalized (which
can be deferred for in-place reservation).

It is now safe to call ieee80211_csa_finish() more
than once.

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
    
    v7:
     * tune commit message
     * put the initial ieee80211_vif_chanctx_reservation_complete()
       implementation here [Johannes]
     * remove 'default' case and use all iftypes explicitly and WARN_ON
    
    v8:
     * fix typo in commit message [Johannes]

 net/mac80211/cfg.c  | 82 +++++++++++++++++++++++++++++++++++------------------
 net/mac80211/chan.c | 35 +++++++++++++++++++++--
 2 files changed, 88 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index af3eac4..32c3cf8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2805,17 +2805,35 @@ static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
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
@@ -2851,6 +2869,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
+	mutex_lock(&local->chanctx_mtx);
 
 	/* AP might have been stopped while waiting for the lock. */
 	if (!sdata->vif.csa_active)
@@ -2862,6 +2881,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	ieee80211_csa_finalize(sdata);
 
 unlock:
+	mutex_unlock(&local->chanctx_mtx);
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
@@ -3007,7 +3027,7 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
-	int err, num_chanctx, changed = 0;
+	int err, changed = 0;
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
@@ -3022,37 +3042,43 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
@@ -3070,7 +3096,9 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		ieee80211_csa_finalize(sdata);
 	}
 
-	return 0;
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	return err;
 }
 
 int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 2560fbe..292e1a3 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1035,6 +1035,30 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+static void
+ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
+{
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->csa_finalize_work);
+		break;
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
+	case NUM_NL80211_IFTYPES:
+		WARN_ON(1);
+		break;
+	}
+}
+
 static int
 ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 {
@@ -1082,7 +1106,7 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 		if (ieee80211_chanctx_refcount(local, new_ctx) == 0)
 			ieee80211_free_chanctx(local, new_ctx);
 
-		return err;
+		goto out;
 	}
 
 	list_move(&sdata->assigned_chanctx_list, &new_ctx->assigned_vifs);
@@ -1102,6 +1126,8 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 	if (changed)
 		ieee80211_bss_info_change_notify(sdata, changed);
 
+out:
+	ieee80211_vif_chanctx_reservation_complete(sdata);
 	return err;
 }
 
@@ -1146,6 +1172,7 @@ ieee80211_vif_use_reserved_assign(struct ieee80211_sub_if_data *sdata)
 	}
 
 out:
+	ieee80211_vif_chanctx_reservation_complete(sdata);
 	return err;
 }
 
@@ -1366,6 +1393,8 @@ ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 			list_move(&sdata->assigned_chanctx_list,
 				  &new_ctx->assigned_vifs);
 			sdata->reserved_chanctx = NULL;
+
+			ieee80211_vif_chanctx_reservation_complete(sdata);
 		}
 
 		/*
@@ -1429,8 +1458,10 @@ err:
 			continue;
 
 		list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
-					 reserved_chanctx_list)
+					 reserved_chanctx_list) {
 			ieee80211_vif_unreserve_chanctx(sdata);
+			ieee80211_vif_chanctx_reservation_complete(sdata);
+		}
 	}
 
 	return err;
-- 
1.8.5.3

