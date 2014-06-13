Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:60204 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752447AbaFMNa0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 09:30:26 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, michal.kazior@tieto.com
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri, 13 Jun 2014 16:30:07 +0300
Message-Id: <1402666207-2257-5-git-send-email-luca@coelho.fi> (sfid-20140613_153035_447203_C6E8B356)
In-Reply-To: <1402666207-2257-1-git-send-email-luca@coelho.fi>
References: <1402666207-2257-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 4/4] mac80211: stop only the queues assigned to the vif during channel switch
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of stopping all the hardware queues during channel switch,
which is especially bad when we have large CSA counts, stop only the
queues that are assigned to the vif that is performing the channel
switch.

Additionally, check for (sdata->csa_block_tx) instead of calling
ieee80211_csa_needs_block_tx(), which can now be removed.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
In v2:
   * remove ieee80211_csa_needs_block_tx();
   * rebased on top of the new refcounted stop/wake queues functions;
---
 net/mac80211/cfg.c         | 52 ++++++++++++----------------------------------
 net/mac80211/ieee80211_i.h |  1 -
 net/mac80211/iface.c       | 10 ++++-----
 net/mac80211/mlme.c        | 36 +++++++++++++++-----------------
 4 files changed, 35 insertions(+), 64 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e920d48..a0d7a03 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -790,31 +790,6 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-bool ieee80211_csa_needs_block_tx(struct ieee80211_local *local)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	lockdep_assert_held(&local->mtx);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		if (!sdata->vif.csa_active)
-			continue;
-
-		if (!sdata->csa_block_tx)
-			continue;
-
-		rcu_read_unlock();
-		return true;
-	}
-	rcu_read_unlock();
-
-	return false;
-}
-
 static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -834,11 +809,12 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	/* abort any running channel switch */
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
-	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA,
-					false);
+	if (sdata->csa_block_tx) {
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
+		sdata->csa_block_tx = false;
+	}
+
 	mutex_unlock(&local->mtx);
 
 	kfree(sdata->u.ap.next_beacon);
@@ -2826,11 +2802,11 @@ static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	ieee80211_bss_info_change_notify(sdata, changed);
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 
-	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA,
-					false);
+	if (sdata->csa_block_tx) {
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
+		sdata->csa_block_tx = false;
+	}
 
 	return 0;
 }
@@ -3060,10 +3036,8 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.csa_active = true;
 
 	if (sdata->csa_block_tx)
-		ieee80211_stop_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA,
-					false);
+		ieee80211_stop_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
 
 	if (changed) {
 		ieee80211_bss_info_change_notify(sdata, changed);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index dd3086d..c1d5a6e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1488,7 +1488,6 @@ void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
 /* channel switch handling */
-bool ieee80211_csa_needs_block_tx(struct ieee80211_local *local);
 void ieee80211_csa_finalize_work(struct work_struct *work);
 int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			     struct cfg80211_csa_settings *params);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5e7b371..f8de583 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -841,11 +841,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
-	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA,
-					false);
+	if (sdata->csa_block_tx) {
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
+		sdata->csa_block_tx = false;
+	}
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8b73476..aa5049f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -980,11 +980,11 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
 	/* XXX: wait for a beacon first? */
-	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA,
-					false);
+	if (sdata->csa_block_tx) {
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
+		sdata->csa_block_tx = false;
+	}
 	mutex_unlock(&local->mtx);
 
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
@@ -1114,10 +1114,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	sdata->csa_block_tx = csa_ie.mode;
 
 	if (sdata->csa_block_tx)
-		ieee80211_stop_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA,
-					false);
+		ieee80211_stop_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&local->mtx);
 
 	if (local->ops->channel_switch) {
@@ -1833,11 +1831,11 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_vif_release_channel(sdata);
 
 	sdata->vif.csa_active = false;
-	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA,
-					false);
+	if (sdata->csa_block_tx) {
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
+		sdata->csa_block_tx = false;
+	}
 	mutex_unlock(&local->mtx);
 
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
@@ -2083,11 +2081,11 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
-	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA,
-					false);
+	if (sdata->csa_block_tx) {
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
+		sdata->csa_block_tx = false;
+	}
 	mutex_unlock(&local->mtx);
 
 	cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
-- 
2.0.0.rc2

