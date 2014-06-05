Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:40321 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFENEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 09:04:00 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so1073945wes.36
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 06:03:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v8 4/5] mac80211: use chanctx reservation for STA CSA
Date: Thu,  5 Jun 2014 14:56:19 +0200
Message-Id: <1401972980-21484-5-git-send-email-michal.kazior@tieto.com> (sfid-20140605_150406_585756_64167219)
In-Reply-To: <1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
 <1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel switch finalization is now 2-step. First
step is when driver calls chswitch_done(), the
other is when reservation is actually finalized
(which be defered for in-place reservation).

It is now safe to call ieee80211_chswitch_done()
more than once.

Also remove the ieee80211_vif_change_channel()
because it is no longer used.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v3:
     * fix comment style [Johannes]
     * add resilience for multiple ieee80211_chswitch_done() calls
    
    v3:
     * fix lockdep typo s/mtx/chanctx_mtx/ [Johannes]
     * fix comment style [Johannes]
     * use goto for cleaner unlocking/returning [Johannes]
     * squash with ieee80211_vif_change_channel() removal patch [Johannes]
     * fix commit message [Johannes]
     * add resilience for multiple ieee80211_csa_finish() calls
    
    v4:
     * squash with removal of ieee80211_vif_change_channel()
    
    v7:
     * add local->mtx locking when reserving (for ieee80211_chanctx_alloc)

 net/mac80211/chan.c        | 69 ++------------------------------
 net/mac80211/ieee80211_i.h |  5 ---
 net/mac80211/mlme.c        | 99 ++++++++++++++++++++++++++++++----------------
 3 files changed, 69 insertions(+), 104 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index fcbe9b9..0b202b2 100644
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
@@ -1044,8 +980,11 @@ ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
 		ieee80211_queue_work(&sdata->local->hw,
 				     &sdata->csa_finalize_work);
 		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_STATION:
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->u.mgd.chswitch_work);
+		break;
+	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MONITOR:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index aa23193..34892a1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -787,7 +787,6 @@ struct ieee80211_sub_if_data {
 	struct mac80211_qos_map __rcu *qos_map;
 
 	struct work_struct csa_finalize_work;
-	bool csa_radar_required;
 	bool csa_block_tx; /* write-protected by sdata_lock and local->mtx */
 	struct cfg80211_chan_def csa_chandef;
 
@@ -1829,10 +1828,6 @@ int __must_check
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
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7f073ef..baea348 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -940,51 +940,69 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u32 changed = 0;
 	int ret;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
 
 	sdata_lock(sdata);
+	mutex_lock(&local->mtx);
+	mutex_lock(&local->chanctx_mtx);
+
 	if (!ifmgd->associated)
 		goto out;
 
-	mutex_lock(&local->mtx);
-	ret = ieee80211_vif_change_channel(sdata, &changed);
-	mutex_unlock(&local->mtx);
-	if (ret) {
+	if (!sdata->vif.csa_active)
+		goto out;
+
+	/*
+	 * using reservation isn't immediate as it may be deferred until later
+	 * with multi-vif. once reservation is complete it will re-schedule the
+	 * work with no reserved_chanctx so verify chandef to check if it
+	 * completed successfully
+	 */
+
+	if (sdata->reserved_chanctx) {
+		/*
+		 * with multi-vif csa driver may call ieee80211_csa_finish()
+		 * many times while waiting for other interfaces to use their
+		 * reservations
+		 */
+		if (sdata->reserved_ready)
+			goto out;
+
+		ret = ieee80211_vif_use_reserved_context(sdata);
+		if (ret) {
+			sdata_info(sdata,
+				   "failed to use reserved channel context, disconnecting (err=%d)\n",
+				   ret);
+			ieee80211_queue_work(&sdata->local->hw,
+					     &ifmgd->csa_connection_drop_work);
+			goto out;
+		}
+
+		goto out;
+	}
+
+	if (!cfg80211_chandef_identical(&sdata->vif.bss_conf.chandef,
+					&sdata->csa_chandef)) {
 		sdata_info(sdata,
-			   "vif channel switch failed, disconnecting\n");
+			   "failed to finalize channel switch, disconnecting\n");
 		ieee80211_queue_work(&sdata->local->hw,
 				     &ifmgd->csa_connection_drop_work);
 		goto out;
 	}
 
-	if (!local->use_chanctx) {
-		local->_oper_chandef = sdata->csa_chandef;
-		/* Call "hw_config" only if doing sw channel switch.
-		 * Otherwise update the channel directly
-		 */
-		if (!local->ops->channel_switch)
-			ieee80211_hw_config(local, 0);
-		else
-			local->hw.conf.chandef = local->_oper_chandef;
-	}
-
 	/* XXX: shouldn't really modify cfg80211-owned data! */
 	ifmgd->associated->channel = sdata->csa_chandef.chan;
 
-	ieee80211_bss_info_change_notify(sdata, changed);
-
-	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
+
 	/* XXX: wait for a beacon first? */
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
-	mutex_unlock(&local->mtx);
 
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 
@@ -992,6 +1010,8 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	ieee80211_sta_reset_conn_monitor(sdata);
 
 out:
+	mutex_unlock(&local->chanctx_mtx);
+	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
 
@@ -1028,6 +1048,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_bss *cbss = ifmgd->associated;
+	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band current_band;
 	struct ieee80211_csa_ie csa_ie;
@@ -1071,7 +1092,22 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
 
+	mutex_lock(&local->mtx);
 	mutex_lock(&local->chanctx_mtx);
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf) {
+		sdata_info(sdata,
+			   "no channel context assigned to vif?, disconnecting\n");
+		ieee80211_queue_work(&local->hw,
+				     &ifmgd->csa_connection_drop_work);
+		mutex_unlock(&local->chanctx_mtx);
+		mutex_unlock(&local->mtx);
+		return;
+	}
+
+	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
+
 	if (local->use_chanctx) {
 		u32 num_chanctx = 0;
 		list_for_each_entry(chanctx, &local->chanctx_list, list)
@@ -1084,32 +1120,27 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 			ieee80211_queue_work(&local->hw,
 					     &ifmgd->csa_connection_drop_work);
 			mutex_unlock(&local->chanctx_mtx);
+			mutex_unlock(&local->mtx);
 			return;
 		}
 	}
 
-	if (WARN_ON(!rcu_access_pointer(sdata->vif.chanctx_conf))) {
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&local->chanctx_mtx);
-		return;
-	}
-	chanctx = container_of(rcu_access_pointer(sdata->vif.chanctx_conf),
-			       struct ieee80211_chanctx, conf);
-	if (ieee80211_chanctx_refcount(local, chanctx) > 1) {
+	res = ieee80211_vif_reserve_chanctx(sdata, &csa_ie.chandef,
+					    chanctx->mode, false);
+	if (res) {
 		sdata_info(sdata,
-			   "channel switch with multiple interfaces on the same channel, disconnecting\n");
+			   "failed to reserve channel context for channel switch, disconnecting (err=%d)\n",
+			   res);
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
 		mutex_unlock(&local->chanctx_mtx);
+		mutex_unlock(&local->mtx);
 		return;
 	}
 	mutex_unlock(&local->chanctx_mtx);
 
-	sdata->csa_chandef = csa_ie.chandef;
-
-	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = true;
+	sdata->csa_chandef = csa_ie.chandef;
 	sdata->csa_block_tx = csa_ie.mode;
 
 	if (sdata->csa_block_tx)
-- 
1.8.5.3

