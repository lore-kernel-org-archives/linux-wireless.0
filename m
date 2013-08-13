Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:62253 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab3HMMEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 08:04:08 -0400
Received: by mail-ee0-f43.google.com with SMTP id e52so4129333eek.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 05:04:06 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: implement STA CSA for drivers using channel contexts
Date: Tue, 13 Aug 2013 15:03:58 +0300
Message-Id: <1376395438-24788-1-git-send-email-arik@wizery.com> (sfid-20130813_140413_518220_6596D641)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Limit the current implementation to a single channel context used by
a single vif, thereby avoiding multi-vif/channel complexities.

Reuse the main function from AP CSA code, but move a portion out in
order to fit the STA scenario.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
This isn't very well tested yet, but seems to work with a TI wl18xx card.
The single-role/single-channel support is enough to pass the 11h certification.

 net/mac80211/cfg.c  |  5 +++++
 net/mac80211/chan.c |  5 -----
 net/mac80211/mlme.c | 55 +++++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7aa38ce..beb1c2a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2872,6 +2872,11 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	if (WARN_ON(err < 0))
 		return;
 
+	if (!local->use_chanctx) {
+		local->_oper_chandef = local->csa_chandef;
+		ieee80211_hw_config(local, 0);
+	}
+
 	err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
 	if (err < 0)
 		return;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3a4764b..03ba6b5 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -453,11 +453,6 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	chanctx_changed |= IEEE80211_CHANCTX_CHANGE_CHANNEL;
 	drv_change_chanctx(local, ctx, chanctx_changed);
 
-	if (!local->use_chanctx) {
-		local->_oper_chandef = *chandef;
-		ieee80211_hw_config(local, 0);
-	}
-
 	ieee80211_recalc_chanctx_chantype(local, ctx);
 	ieee80211_recalc_smps_chanctx(local, ctx);
 	ieee80211_recalc_radar_chanctx(local, ctx);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45a87ee..750bf55 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -926,6 +926,8 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u32 changed = 0;
+	int ret;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
@@ -934,24 +936,38 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	local->_oper_chandef = local->csa_chandef;
+	ret = ieee80211_vif_change_channel(sdata, &local->csa_chandef,
+					   &changed);
+	if (ret) {
+		sdata_info(sdata,
+			   "vif channel switch failed, disconnecting\n");
+		ieee80211_queue_work(&sdata->local->hw,
+				     &ifmgd->csa_connection_drop_work);
+		goto out;
+	}
 
-	if (!local->ops->channel_switch) {
-		/* call "hw_config" only if doing sw channel switch */
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-	} else {
-		/* update the device channel directly */
-		local->hw.conf.chandef = local->_oper_chandef;
+	if (!local->use_chanctx) {
+		local->_oper_chandef = local->csa_chandef;
+		/* Call "hw_config" only if doing sw channel switch.
+		 * Otherwise update the channel directly */
+		if (!local->ops->channel_switch)
+			ieee80211_hw_config(local, 0);
+		else
+			local->hw.conf.chandef = local->_oper_chandef;
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = local->_oper_chandef.chan;
+	ifmgd->associated->channel = local->csa_chandef.chan;
 
 	/* XXX: wait for a beacon first? */
 	ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	ieee80211_bss_info_change_notify(sdata, changed);
+
  out:
+	sdata->vif.csa_active = false;
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	sdata_unlock(sdata);
 }
@@ -1180,17 +1196,27 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
+	sdata->vif.csa_active = true;
 
+	mutex_lock(&local->chanctx_mtx);
 	if (local->use_chanctx) {
-		sdata_info(sdata,
-			   "not handling channel switch with channel contexts\n");
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		return;
+		u32 num_chanctx = 0;
+		list_for_each_entry(chanctx, &local->chanctx_list, list)
+		       num_chanctx++;
+
+		if (num_chanctx > 1) {
+			sdata_info(sdata,
+				   "not handling chan-switch with channel contexts multi-vif\n");
+			ieee80211_queue_work(&local->hw,
+					     &ifmgd->csa_connection_drop_work);
+			mutex_unlock(&local->chanctx_mtx);
+			return;
+		}
 	}
 
-	mutex_lock(&local->chanctx_mtx);
 	if (WARN_ON(!rcu_access_pointer(sdata->vif.chanctx_conf))) {
+		ieee80211_queue_work(&local->hw,
+				     &ifmgd->csa_connection_drop_work);
 		mutex_unlock(&local->chanctx_mtx);
 		return;
 	}
@@ -2163,6 +2189,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 			       true, frame_buf);
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+	sdata->vif.csa_active = false;
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
-- 
1.8.1.2

