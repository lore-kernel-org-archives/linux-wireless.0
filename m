Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:34577 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754428AbaJHGtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 02:49:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com, michal.kazior@tieto.com,
	linux-wireless@vger.kernel.org
Date: Wed,  8 Oct 2014 09:48:39 +0300
Message-Id: <1412750920-15392-7-git-send-email-luca@coelho.fi> (sfid-20141008_084927_647329_13E1789A)
In-Reply-To: <1412750920-15392-1-git-send-email-luca@coelho.fi>
References: <1412750920-15392-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 6/7] mac80211: wait for the first beacon on the new channel after CSA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of immediately reopening the queues (in case of block_tx),
calling the post_channel_switch operation and sending the
notification, wait for the first beacon on the new channel.  This
makes sure that we don't lose packets if the AP/GO is not on the new
channel yet.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/iface.c       |  2 ++
 net/mac80211/mlme.c        | 45 ++++++++++++++++++++++++++++++++-------------
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a9cc491..78d6121 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -434,6 +434,8 @@ struct ieee80211_if_managed {
 
 	unsigned int flags;
 
+	bool csa_waiting_bcn;
+
 	bool beacon_crc_valid;
 	u32 beacon_crc;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index af23722..e469b33 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -842,6 +842,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		sdata->u.mgd.csa_waiting_bcn = false;
 	if (sdata->csa_block_tx) {
 		ieee80211_wake_vif_queues(local, sdata,
 					  IEEE80211_QUEUE_STOP_REASON_CSA);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2e29cc3..109812f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1001,31 +1001,44 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	/* XXX: shouldn't really modify cfg80211-owned data! */
 	ifmgd->associated->channel = sdata->csa_chandef.chan;
 
-	sdata->vif.csa_active = false;
+	ifmgd->csa_waiting_bcn = true;
+
+	ieee80211_sta_reset_beacon_monitor(sdata);
+	ieee80211_sta_reset_conn_monitor(sdata);
+
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	mutex_unlock(&local->mtx);
+	sdata_unlock(sdata);
+}
+
+static void ieee80211_chswitch_post_beacon(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	int ret;
+
+	sdata_assert_lock(sdata);
+
+	WARN_ON(!sdata->vif.csa_active);
 
-	/* XXX: wait for a beacon first? */
 	if (sdata->csa_block_tx) {
 		ieee80211_wake_vif_queues(local, sdata,
 					  IEEE80211_QUEUE_STOP_REASON_CSA);
 		sdata->csa_block_tx = false;
 	}
 
+	sdata->vif.csa_active = false;
+	ifmgd->csa_waiting_bcn = false;
+
 	ret = drv_post_channel_switch(sdata);
 	if (ret) {
 		sdata_info(sdata,
 			   "driver post channel switch failed, disconnecting\n");
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
-		goto out;
+		return;
 	}
-
-	ieee80211_sta_reset_beacon_monitor(sdata);
-	ieee80211_sta_reset_conn_monitor(sdata);
-
-out:
-	mutex_unlock(&local->chanctx_mtx);
-	mutex_unlock(&local->mtx);
-	sdata_unlock(sdata);
 }
 
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
@@ -1943,6 +1956,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_vif_release_channel(sdata);
 
 	sdata->vif.csa_active = false;
+	ifmgd->csa_waiting_bcn = false;
 	if (sdata->csa_block_tx) {
 		ieee80211_wake_vif_queues(local, sdata,
 					  IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -2191,6 +2205,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 			       true, frame_buf);
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
+	ifmgd->csa_waiting_bcn = false;
 	if (sdata->csa_block_tx) {
 		ieee80211_wake_vif_queues(local, sdata,
 					  IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -3215,6 +3230,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	if (ifmgd->csa_waiting_bcn)
+		ieee80211_chswitch_post_beacon(sdata);
+
 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
 		return;
 	ifmgd->beacon_crc = ncrc;
@@ -3687,11 +3705,12 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (local->quiescing)
 		return;
 
-	if (sdata->vif.csa_active)
+	if (sdata->vif.csa_active && !ifmgd->csa_waiting_bcn)
 		return;
 
 	sdata->u.mgd.connection_loss = false;
@@ -3709,7 +3728,7 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
-	if (sdata->vif.csa_active)
+	if (sdata->vif.csa_active && !ifmgd->csa_waiting_bcn)
 		return;
 
 	ieee80211_queue_work(&local->hw, &ifmgd->monitor_work);
-- 
2.1.1

