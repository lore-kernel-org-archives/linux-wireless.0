Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57159 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaCRN7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:31 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so5372364eek.8
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 18/21] mac80211: use chanctx reservation for STA CSA
Date: Tue, 18 Mar 2014 14:53:21 +0100
Message-Id: <1395150804-24090-19-git-send-email-michal.kazior@tieto.com> (sfid-20140318_150215_698852_C65851B7)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel switch finalization is now 2-step. First
step is when driver calls chswitch_done(), the
other is when reservation is actually finalized
(which be defered for in-place reservation).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c |  4 +++
 net/mac80211/mlme.c | 90 ++++++++++++++++++++++++++++++++---------------------
 2 files changed, 59 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 2959b7f..6f621ba 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -972,6 +972,10 @@ ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
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
index f5589c7..e729da3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -940,54 +940,66 @@ static void ieee80211_chswitch_work(struct work_struct *work)
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
+		goto cleanup;
+
+	if (!sdata->vif.csa_active)
+		goto cleanup;
+
+	/* using reservation isn't immediate as it may be deferred until later
+	 * with multi-vif. once reservation is complete it will re-schedule the
+	 * work with no reserved_chanctx so verify chandef to check if it
+	 * completed successfully */
+
+	if (sdata->reserved_chanctx) {
+		ret = ieee80211_vif_use_reserved_context(sdata);
+		if (ret) {
+			sdata_info(sdata,
+				   "failed to use reserved channel context, disconnecting (err=%d)\n",
+				   ret);
+			ieee80211_queue_work(&sdata->local->hw,
+					     &ifmgd->csa_connection_drop_work);
+			goto cleanup;
+		}
+
 		goto out;
+	}
 
-	mutex_lock(&local->mtx);
-	ret = ieee80211_vif_change_channel(sdata, &changed);
-	mutex_unlock(&local->mtx);
-	if (ret) {
+	if (!cfg80211_chandef_identical(&sdata->vif.bss_conf.chandef,
+					&sdata->csa_chandef)) {
 		sdata_info(sdata,
-			   "vif channel switch failed, disconnecting\n");
+			   "failed to finalize channel switch, disconnecting\n");
 		ieee80211_queue_work(&sdata->local->hw,
 				     &ifmgd->csa_connection_drop_work);
-		goto out;
-	}
-
-	if (!local->use_chanctx) {
-		local->_oper_chandef = sdata->csa_chandef;
-		/* Call "hw_config" only if doing sw channel switch.
-		 * Otherwise update the channel directly
-		 */
-		if (!local->ops->channel_switch)
-			ieee80211_hw_config(local, 0);
-		else
-			local->hw.conf.chandef = local->_oper_chandef;
+		goto cleanup;
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
 	ifmgd->associated->channel = sdata->csa_chandef.chan;
 
-	ieee80211_bss_info_change_notify(sdata, changed);
-
- out:
-	mutex_lock(&local->mtx);
+cleanup:
 	sdata->vif.csa_active = false;
+
 	/* XXX: wait for a beacon first? */
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
-	mutex_unlock(&local->mtx);
 
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
 
@@ -1024,6 +1036,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_bss *cbss = ifmgd->associated;
+	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band current_band;
 	struct ieee80211_csa_ie csa_ie;
@@ -1068,6 +1081,19 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
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
@@ -1084,17 +1110,12 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
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
@@ -1102,10 +1123,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
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

