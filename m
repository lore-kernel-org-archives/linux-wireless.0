Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54628 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaCaMK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 08:10:27 -0400
Received: by mail-wi0-f178.google.com with SMTP id bs8so3160933wib.17
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 05:10:26 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 3/5] mac80211: use chanctx reservation for STA CSA
Date: Mon, 31 Mar 2014 14:04:17 +0200
Message-Id: <1396267459-9976-4-git-send-email-michal.kazior@tieto.com> (sfid-20140331_141045_710922_57EDD251)
In-Reply-To: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
References: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
 <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel switch finalization is now 2-step. First
step is when driver calls chswitch_done(), the
other is when reservation is actually finalized
(which be defered for in-place reservation).

It is now safe to call ieee80211_chswitch_done()
more than once.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v3:
 * fix comment style [Johannes]
 * add resilience for multiple ieee80211_chswitch_done() calls

 net/mac80211/chan.c |  4 +++
 net/mac80211/mlme.c | 94 ++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 65 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 94e06c0..d69762f 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -907,6 +907,10 @@ ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
 		ieee80211_queue_work(&sdata->local->hw,
 				     &sdata->csa_finalize_work);
 		break;
+	case NL80211_IFTYPE_STATION:
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->u.mgd.chswitch_work);
+		break;
 	default:
 		break;
 	}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b36e73f..07a4324 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -917,55 +917,75 @@ static void ieee80211_chswitch_work(struct work_struct *work)
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
 
 out:
+	mutex_unlock(&local->chanctx_mtx);
+	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
 
@@ -1002,6 +1022,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_bss *cbss = ifmgd->associated;
+	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band current_band;
 	struct ieee80211_csa_ie csa_ie;
@@ -1046,6 +1067,19 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
 
 	mutex_lock(&local->chanctx_mtx);
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf) {
+		sdata_info(sdata,
+			   "no channel context assigned to vif?, disconnecting\n");
+		ieee80211_queue_work(&local->hw,
+				     &ifmgd->csa_connection_drop_work);
+		mutex_unlock(&local->chanctx_mtx);
+		return;
+	}
+
+	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
+
 	if (local->use_chanctx) {
 		u32 num_chanctx = 0;
 		list_for_each_entry(chanctx, &local->chanctx_list, list)
@@ -1062,17 +1096,12 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
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
@@ -1080,10 +1109,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&local->chanctx_mtx);
 
-	sdata->csa_chandef = csa_ie.chandef;
-
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = true;
+	sdata->csa_chandef = csa_ie.chandef;
 	sdata->csa_block_tx = csa_ie.mode;
 
 	if (sdata->csa_block_tx)
-- 
1.8.5.3

