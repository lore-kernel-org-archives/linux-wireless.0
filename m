Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33835 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaCaKDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 06:03:30 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so5532921wgh.31
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 03:03:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 1/4] mac80211: fix CSA tx queue locking
Date: Mon, 31 Mar 2014 11:57:18 +0200
Message-Id: <1396259841-6359-2-git-send-email-michal.kazior@tieto.com> (sfid-20140331_120335_802130_128E85BE)
In-Reply-To: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
 <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible for tx queues to be stuck locked
if AP CSA finalization failed. In that case
stop_ap nor do_stop woke the queues up. This means
it was impossible to perform tx at all until
driver was reloaded or a successful CSA was
performed later.

It was possible to solve this in a simpler manner
however this is more robust and future proof
(having multi-vif CSA in mind).

New sdata->csa_block_tx is introduced to keep
track of which interfaces requested tx to be
blocked for CSA. This is required because mac80211
locks all tx queues for that purpose. This means
queues must be unlocked only when last tx-blocking
CSA interface is finished.

It is still possible to have tx queues stopped
after CSA failure but as soon as offending
interfaces are stopped from userspace (stop_ap or
ifdown) tx queues are woken up properly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * get rid of idempotency [Johannes]

v3:
 * fix wake/stop typo [Luca]
 * move queue waking to csa_finalize() [Luca]
 * tune how queues are woken for STA CSA [Luca]

 include/net/mac80211.h     |  4 ++-
 net/mac80211/cfg.c         | 77 ++++++++++++++++++++++++++++++++++++++--------
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/iface.c       |  7 +++++
 net/mac80211/mlme.c        | 37 ++++++++++++++++------
 5 files changed, 104 insertions(+), 23 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 604e279..ea69961 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1113,7 +1113,9 @@ enum ieee80211_vif_flags {
  * @addr: address of this interface
  * @p2p: indicates whether this AP or STA interface is a p2p
  *	interface, i.e. a GO or p2p-sta respectively
- * @csa_active: marks whether a channel switch is going on
+ * @csa_active: marks whether a channel switch is going on. Internally it is
+ *	write-protected by sdata_lock and local->mtx so holding either is fine
+ *	for read access.
  * @driver_flags: flags/capabilities the driver has for this interface,
  *	these need to be set (or cleared) when the interface is added
  *	or, if supported by the driver, the interface type is changed
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aa39381..b7cf8e4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1084,6 +1084,31 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+bool ieee80211_csa_needs_block_tx(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	lockdep_assert_held(&local->mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		if (!sdata->vif.csa_active)
+			continue;
+
+		if (!sdata->csa_block_tx)
+			continue;
+
+		rcu_read_unlock();
+		return true;
+	}
+	rcu_read_unlock();
+
+	return false;
+}
+
 static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1101,7 +1126,14 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	old_probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
 	/* abort any running channel switch */
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
+	if (!ieee80211_csa_needs_block_tx(local))
+		ieee80211_wake_queues_by_reason(&local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+	mutex_unlock(&local->mtx);
+
 	kfree(sdata->u.ap.next_beacon);
 	sdata->u.ap.next_beacon = NULL;
 
@@ -3025,11 +3057,10 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	int err, changed = 0;
 
 	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
 
-	mutex_lock(&local->mtx);
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
-	mutex_unlock(&local->mtx);
 	if (WARN_ON(err < 0))
 		return;
 
@@ -3070,11 +3101,12 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
+
+	if (!ieee80211_csa_needs_block_tx(local))
+		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
-
-	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 }
 
 void ieee80211_csa_finalize_work(struct work_struct *work)
@@ -3082,8 +3114,11 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
 			     csa_finalize_work);
+	struct ieee80211_local *local = sdata->local;
 
 	sdata_lock(sdata);
+	mutex_lock(&local->mtx);
+
 	/* AP might have been stopped while waiting for the lock. */
 	if (!sdata->vif.csa_active)
 		goto unlock;
@@ -3094,6 +3129,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	ieee80211_csa_finalize(sdata);
 
 unlock:
+	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
 
@@ -3220,8 +3256,8 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			     struct cfg80211_csa_settings *params)
+int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_csa_settings *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -3230,6 +3266,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	int err, num_chanctx, changed = 0;
 
 	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
 
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
@@ -3271,15 +3308,15 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return err;
 
 	sdata->csa_radar_required = params->radar_required;
-
-	if (params->block_tx)
-		ieee80211_stop_queues_by_reason(&local->hw,
-				IEEE80211_MAX_QUEUE_MAP,
-				IEEE80211_QUEUE_STOP_REASON_CSA);
-
 	sdata->csa_chandef = params->chandef;
+	sdata->csa_block_tx = params->block_tx;
 	sdata->vif.csa_active = true;
 
+	if (sdata->csa_block_tx)
+		ieee80211_stop_queues_by_reason(&local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+
 	if (changed) {
 		ieee80211_bss_info_change_notify(sdata, changed);
 		drv_channel_switch_beacon(sdata, &params->chandef);
@@ -3291,6 +3328,20 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			     struct cfg80211_csa_settings *params)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int err;
+
+	mutex_lock(&local->mtx);
+	err = __ieee80211_channel_switch(wiphy, dev, params);
+	mutex_unlock(&local->mtx);
+
+	return err;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct cfg80211_mgmt_tx_params *params,
 			     u64 *cookie)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3b73c3e..02fe9f4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -754,6 +754,7 @@ struct ieee80211_sub_if_data {
 	int csa_counter_offset_beacon;
 	int csa_counter_offset_presp;
 	bool csa_radar_required;
+	bool csa_block_tx; /* write-protected by sdata_lock and local->mtx */
 	struct cfg80211_chan_def csa_chandef;
 
 	/* context reservation -- protected with chanctx_mtx */
@@ -1466,6 +1467,7 @@ void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
 /* channel switch handling */
+bool ieee80211_csa_needs_block_tx(struct ieee80211_local *local);
 void ieee80211_csa_finalize_work(struct work_struct *work);
 int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			     struct cfg80211_csa_settings *params);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 359e14b..52dccd6 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -838,8 +838,15 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	cancel_work_sync(&sdata->recalc_smps);
 	sdata_lock(sdata);
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
+	if (!ieee80211_csa_needs_block_tx(local))
+		ieee80211_wake_queues_by_reason(&local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
+
 	cancel_work_sync(&sdata->csa_finalize_work);
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bbc2175..5a916bb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -952,16 +952,20 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	/* XXX: shouldn't really modify cfg80211-owned data! */
 	ifmgd->associated->channel = sdata->csa_chandef.chan;
 
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	mutex_lock(&local->mtx);
+	sdata->vif.csa_active = false;
 	/* XXX: wait for a beacon first? */
-	ieee80211_wake_queues_by_reason(&local->hw,
+	if (!ieee80211_csa_needs_block_tx(local))
+		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
+	mutex_unlock(&local->mtx);
 
-	ieee80211_bss_info_change_notify(sdata, changed);
-
- out:
-	sdata->vif.csa_active = false;
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+
+out:
 	sdata_unlock(sdata);
 }
 
@@ -1077,12 +1081,16 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&local->chanctx_mtx);
 
 	sdata->csa_chandef = csa_ie.chandef;
+
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = true;
+	sdata->csa_block_tx = csa_ie.mode;
 
-	if (csa_ie.mode)
+	if (sdata->csa_block_tx)
 		ieee80211_stop_queues_by_reason(&local->hw,
-				IEEE80211_MAX_QUEUE_MAP,
-				IEEE80211_QUEUE_STOP_REASON_CSA);
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+	mutex_unlock(&local->mtx);
 
 	if (local->ops->channel_switch) {
 		/* use driver's channel switch callback */
@@ -1794,6 +1802,12 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	ifmgd->flags = 0;
 	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
+
+	sdata->vif.csa_active = false;
+	if (!ieee80211_csa_needs_block_tx(local))
+		ieee80211_wake_queues_by_reason(&local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&local->mtx);
 
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
@@ -2022,6 +2036,7 @@ EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 
 static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
@@ -2035,10 +2050,14 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 			       true, frame_buf);
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+	if (!ieee80211_csa_needs_block_tx(local))
+		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
+	mutex_unlock(&local->mtx);
 
 	cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
 			      IEEE80211_DEAUTH_FRAME_LEN);
-- 
1.8.5.3

