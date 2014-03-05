Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53272 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaCEOc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 09:32:26 -0500
Received: by mail-ea0-f177.google.com with SMTP id h10so1076292eak.36
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2014 06:32:24 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/4] mac80211: fix CSA tx queue locking
Date: Wed,  5 Mar 2014 15:27:00 +0100
Message-Id: <1394029623-21894-2-git-send-email-michal.kazior@tieto.com> (sfid-20140305_153241_391040_9193D5DD)
In-Reply-To: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
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

Now csa_active and newly introduced csa_block_tx
are write-protected by both sdata_lock and
local->mtx so either one can be held for read
access. This way it's easy to iterate over all
interfaces to see if there's any interface with an
active CSA.

It is still possible to have tx queues stopped
after CSA failure but as soon as offending
interfaces are stopped from userspace (stop_ap or
ifdown) tx queues are woken up.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h     |  4 ++-
 net/mac80211/cfg.c         | 83 ++++++++++++++++++++++++++++++++++++++--------
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/iface.c       |  4 +++
 net/mac80211/mlme.c        | 27 ++++++++-------
 5 files changed, 93 insertions(+), 27 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 86faa41..d284411 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1111,7 +1111,9 @@ enum ieee80211_vif_flags {
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
index aaa59d7..3dce573 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1075,6 +1075,45 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static bool ieee80211_csa_needs_block_tx(struct ieee80211_local *local)
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
+void ieee80211_recalc_csa_block_tx(struct ieee80211_local *local)
+{
+	lockdep_assert_held(&local->mtx);
+
+	if (ieee80211_csa_needs_block_tx(local))
+		ieee80211_stop_queues_by_reason(&local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+	else
+		ieee80211_wake_queues_by_reason(&local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+}
+
 static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1092,7 +1131,11 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	old_probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
 	/* abort any running channel switch */
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
+	ieee80211_recalc_csa_block_tx(local);
+	mutex_unlock(&local->mtx);
+
 	kfree(sdata->u.ap.next_beacon);
 	sdata->u.ap.next_beacon = NULL;
 
@@ -3017,11 +3060,10 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	int err, changed = 0;
 
 	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
 
-	mutex_lock(&local->mtx);
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
-	mutex_unlock(&local->mtx);
 	if (WARN_ON(err < 0))
 		return;
 
@@ -3062,10 +3104,6 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
-
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 }
 
@@ -3074,8 +3112,11 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
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
@@ -3084,8 +3125,10 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 		goto unlock;
 
 	ieee80211_csa_finalize(sdata);
+	ieee80211_recalc_csa_block_tx(local);
 
 unlock:
+	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
 
@@ -3212,8 +3255,8 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			     struct cfg80211_csa_settings *params)
+int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_csa_settings *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -3222,6 +3265,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	int err, num_chanctx, changed = 0;
 
 	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
 
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
@@ -3263,15 +3307,12 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
 
+	ieee80211_recalc_csa_block_tx(local);
+
 	if (changed) {
 		ieee80211_bss_info_change_notify(sdata, changed);
 		drv_channel_switch_beacon(sdata, &params->chandef);
@@ -3283,6 +3324,20 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
index 8603dfb..75dec8c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -754,6 +754,7 @@ struct ieee80211_sub_if_data {
 	int csa_counter_offset_beacon;
 	int csa_counter_offset_presp;
 	bool csa_radar_required;
+	bool csa_block_tx; /* write-protected by sdata_lock and local->mtx */
 	struct cfg80211_chan_def csa_chandef;
 
 	/* used to reconfigure hardware SM PS */
@@ -1461,6 +1462,7 @@ void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
 /* channel switch handling */
+void ieee80211_recalc_csa_block_tx(struct ieee80211_local *local);
 void ieee80211_csa_finalize_work(struct work_struct *work);
 int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			     struct cfg80211_csa_settings *params);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index be198f4..b82ee53 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -829,8 +829,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	cancel_work_sync(&sdata->recalc_smps);
 	sdata_lock(sdata);
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
+	ieee80211_recalc_csa_block_tx(local);
+	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
+
 	cancel_work_sync(&sdata->csa_finalize_work);
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46b62bb..0a6e77cf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -952,15 +952,15 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	/* XXX: shouldn't really modify cfg80211-owned data! */
 	ifmgd->associated->channel = sdata->csa_chandef.chan;
 
-	/* XXX: wait for a beacon first? */
-	ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
-
 	ieee80211_bss_info_change_notify(sdata, changed);
 
  out:
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
+	/* XXX: wait for a beacon first? */
+	ieee80211_recalc_csa_block_tx(local);
+	mutex_unlock(&local->mtx);
+
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	sdata_unlock(sdata);
 }
@@ -1077,12 +1077,13 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&local->chanctx_mtx);
 
 	sdata->csa_chandef = csa_ie.chandef;
+
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = true;
+	sdata->csa_block_tx = csa_ie.mode;
 
-	if (csa_ie.mode)
-		ieee80211_stop_queues_by_reason(&local->hw,
-				IEEE80211_MAX_QUEUE_MAP,
-				IEEE80211_QUEUE_STOP_REASON_CSA);
+	ieee80211_recalc_csa_block_tx(local);
+	mutex_unlock(&local->mtx);
 
 	if (local->ops->channel_switch) {
 		/* use driver's channel switch callback */
@@ -2022,6 +2023,7 @@ EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 
 static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
@@ -2035,10 +2037,11 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 			       true, frame_buf);
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+	ieee80211_recalc_csa_block_tx(local);
+	mutex_unlock(&local->mtx);
 
 	cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
 			      IEEE80211_DEAUTH_FRAME_LEN);
-- 
1.8.5.3

