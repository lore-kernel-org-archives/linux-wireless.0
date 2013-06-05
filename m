Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3FEHMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 03:12:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: Use suitable semantics for beacon availability indication
Date: Wed,  5 Jun 2013 09:12:37 +0200
Message-Id: <1370416357-14421-1-git-send-email-johannes@sipsolutions.net> (sfid-20130605_091244_516515_18FE4C88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Currently beacon availability upon association is marked by have_beacon
flag of assoc_data structure that becomes unavailable when association
completes. However beacon availability indication is required also after
association to inform a driver. Currently dtim_period parameter is used
for this purpose. Move have_beacon flag to another structure, persistant
throughout a interface's life cycle. Use suitable sematics for beacon
availability indication.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
[fix another instance of BSS_CHANGED_DTIM_PERIOD in docs]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 include/net/mac80211.h                      |  8 ++++----
 net/mac80211/ieee80211_i.h                  |  3 ++-
 net/mac80211/mlme.c                         | 20 +++++++++++---------
 net/mac80211/util.c                         |  5 +++--
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b807dda..c942eb0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -785,7 +785,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			if (ret)
 				IWL_ERR(mvm, "failed to update quotas\n");
 		}
-	} else if (changes & BSS_CHANGED_DTIM_PERIOD) {
+	} else if (changes & BSS_CHANGED_BEACON_INFO) {
 		/*
 		 * We received a beacon _after_ association so
 		 * remove the session protection.
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cb37f82..a405a7a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -217,8 +217,8 @@ struct ieee80211_chanctx_conf {
  * @BSS_CHANGED_TXPOWER: TX power setting changed for this interface
  * @BSS_CHANGED_P2P_PS: P2P powersave settings (CTWindow, opportunistic PS)
  *	changed (currently only in P2P client mode, GO mode will be later)
- * @BSS_CHANGED_DTIM_PERIOD: the DTIM period value was changed (set when
- *	it becomes valid, managed mode only)
+ * @BSS_CHANGED_BEACON_INFO: Data from the AP's beacon became available:
+ *	currently dtim_period only is under consideration.
  * @BSS_CHANGED_BANDWIDTH: The bandwidth used by this interface changed,
  *	note that this is only called when it changes after the channel
  *	context had been assigned.
@@ -244,7 +244,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_PS			= 1<<17,
 	BSS_CHANGED_TXPOWER		= 1<<18,
 	BSS_CHANGED_P2P_PS		= 1<<19,
-	BSS_CHANGED_DTIM_PERIOD		= 1<<20,
+	BSS_CHANGED_BEACON_INFO		= 1<<20,
 	BSS_CHANGED_BANDWIDTH		= 1<<21,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
@@ -288,7 +288,7 @@ enum ieee80211_rssi_event {
  *	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
  * @dtim_period: num of beacons before the next DTIM, for beaconing,
  *	valid in station mode only if after the driver was notified
- *	with the %BSS_CHANGED_DTIM_PERIOD flag, will be non-zero then.
+ *	with the %BSS_CHANGED_BEACON_INFO flag, will be non-zero then.
  * @sync_tsf: last beacon's/probe response's TSF timestamp (could be old
  *	as it may have been received during scanning long ago). If the
  *	HW flag %IEEE80211_HW_TIMING_BEACON_ONLY is set, then this can
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9eed6f1..7a6f1a0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -366,7 +366,7 @@ struct ieee80211_mgd_assoc_data {
 	u8 ssid_len;
 	u8 supp_rates_len;
 	bool wmm, uapsd;
-	bool have_beacon, need_beacon;
+	bool need_beacon;
 	bool synced;
 	bool timeout_started;
 
@@ -404,6 +404,7 @@ struct ieee80211_if_managed {
 
 	bool powersave; /* powersave requested for this iface */
 	bool broken_ap; /* AP is broken -- turn off powersave */
+	bool have_beacon;
 	u8 dtim_period;
 	enum ieee80211_smps_mode req_smps, /* requested smps mode */
 				 driver_smps_mode; /* smps mode request */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index aa5cd2e..ad9bb9e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1360,7 +1360,7 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 			  IEEE80211_STA_CONNECTION_POLL))
 		return false;
 
-	if (!sdata->vif.bss_conf.dtim_period)
+	if (!mgd->have_beacon)
 		return false;
 
 	rcu_read_lock();
@@ -1771,7 +1771,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_led_assoc(local, 1);
 
-	if (sdata->u.mgd.assoc_data->have_beacon) {
+	if (sdata->u.mgd.have_beacon) {
 		/*
 		 * If the AP is buggy we may get here with no DTIM period
 		 * known, so assume it's 1 which is the only safe assumption
@@ -1779,7 +1779,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 		 * probably just won't work at all.
 		 */
 		bss_conf->dtim_period = sdata->u.mgd.dtim_period ?: 1;
-		bss_info_changed |= BSS_CHANGED_DTIM_PERIOD;
+		bss_info_changed |= BSS_CHANGED_BEACON_INFO;
 	} else {
 		bss_conf->dtim_period = 0;
 	}
@@ -1903,6 +1903,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
 
 	sdata->vif.bss_conf.dtim_period = 0;
+	ifmgd->have_beacon = false;
 
 	ifmgd->flags = 0;
 	ieee80211_vif_release_channel(sdata);
@@ -2877,7 +2878,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			const struct ieee80211_tim_ie *tim_ie = elems.tim;
 			ifmgd->dtim_period = tim_ie->dtim_period;
 		}
-		ifmgd->assoc_data->have_beacon = true;
+		ifmgd->have_beacon = true;
 		ifmgd->assoc_data->need_beacon = false;
 		if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
 			sdata->vif.bss_conf.sync_tsf =
@@ -3059,7 +3060,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	 * If we haven't had a beacon before, tell the driver about the
 	 * DTIM period (and beacon timing if desired) now.
 	 */
-	if (!bss_conf->dtim_period) {
+	if (!ifmgd->have_beacon) {
 		/* a few bogus AP send dtim_period = 0 or no TIM IE */
 		if (elems.tim)
 			bss_conf->dtim_period = elems.tim->dtim_period ?: 1;
@@ -3078,7 +3079,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				sdata->vif.bss_conf.sync_dtim_count = 0;
 		}
 
-		changed |= BSS_CHANGED_DTIM_PERIOD;
+		changed |= BSS_CHANGED_BEACON_INFO;
+		ifmgd->have_beacon = true;
 
 		mutex_lock(&local->iflist_mtx);
 		ieee80211_recalc_ps(local, -1);
@@ -3424,8 +3426,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 	if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started &&
 	    time_after(jiffies, ifmgd->assoc_data->timeout)) {
-		if ((ifmgd->assoc_data->need_beacon &&
-		     !ifmgd->assoc_data->have_beacon) ||
+		if ((ifmgd->assoc_data->need_beacon && !ifmgd->have_beacon) ||
 		    ieee80211_do_assoc(sdata)) {
 			u8 bssid[ETH_ALEN];
 
@@ -4193,6 +4194,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->assoc_data = assoc_data;
 	ifmgd->dtim_period = 0;
+	ifmgd->have_beacon = false;
 
 	err = ieee80211_prep_connection(sdata, req->bss, true);
 	if (err)
@@ -4224,7 +4226,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			ifmgd->dtim_period = tim->dtim_period;
 			dtim_count = tim->dtim_count;
 		}
-		assoc_data->have_beacon = true;
+		ifmgd->have_beacon = true;
 		assoc_data->timeout = jiffies;
 		assoc_data->timeout_started = true;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89a8377..5a6c135 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1584,8 +1584,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 				   BSS_CHANGED_ARP_FILTER |
 				   BSS_CHANGED_PS;
 
-			if (sdata->u.mgd.dtim_period)
-				changed |= BSS_CHANGED_DTIM_PERIOD;
+			/* Re-send beacon info report to the driver */
+			if (sdata->u.mgd.have_beacon)
+				changed |= BSS_CHANGED_BEACON_INFO;
 
 			sdata_lock(sdata);
 			ieee80211_bss_info_change_notify(sdata, changed);
-- 
1.8.0

