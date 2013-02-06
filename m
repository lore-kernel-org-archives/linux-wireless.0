Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab3BFO3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 09:29:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: introduce beacon-only timing data
Date: Wed,  6 Feb 2013 15:29:26 +0100
Message-Id: <1360160966-26163-1-git-send-email-johannes@sipsolutions.net> (sfid-20130206_152911_650604_90D399DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to be able to predict the next DTIM TBTT
in the driver, add the ability to use timing data
from beacons only with the new hardware flag
IEEE80211_HW_TIMING_BEACON_ONLY and the BSS info
value sync_dtim_count which is only valid if the
timing data came from a beacon. The data can only
come from a beacon, and if no beacon was received
before association it is updated later together
with the DTIM count notification.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 14 +++++++++-
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/mlme.c        | 65 +++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/scan.c        |  5 +++-
 net/mac80211/trace.h       |  2 ++
 5 files changed, 81 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7d9a4f7..d7dc907 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -277,9 +277,16 @@ enum ieee80211_rssi_event {
  *	valid in station mode only if after the driver was notified
  *	with the %BSS_CHANGED_DTIM_PERIOD flag, will be non-zero then.
  * @sync_tsf: last beacon's/probe response's TSF timestamp (could be old
- *	as it may have been received during scanning long ago)
+ *	as it may have been received during scanning long ago). If the
+ *	HW flag %IEEE80211_HW_TIMING_BEACON_ONLY is set, then this can
+ *	only come from a beacon, but might not become valid until after
+ *	association when a beacon is received (which is notified with the
+ *	%BSS_CHANGED_DTIM flag.)
  * @sync_device_ts: the device timestamp corresponding to the sync_tsf,
  *	the driver/device can use this to calculate synchronisation
+ *	(see @sync_tsf)
+ * @sync_dtim_count: Only valid when %IEEE80211_HW_TIMING_BEACON_ONLY
+ *	is requested, see @sync_tsf/@sync_device_ts.
  * @beacon_int: beacon interval
  * @assoc_capability: capabilities taken from assoc resp
  * @basic_rates: bitmap of basic rates, each bit stands for an
@@ -331,6 +338,7 @@ struct ieee80211_bss_conf {
 	u16 assoc_capability;
 	u64 sync_tsf;
 	u32 sync_device_ts;
+	u8 sync_dtim_count;
 	u32 basic_rates;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 	u16 ht_operation_mode;
@@ -1376,6 +1384,9 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF: Use the P2P Device address for any
  *	P2P Interface. This will be honoured even if more than one interface
  *	is supported.
+ *
+ * @IEEE80211_HW_TIMING_BEACON_ONLY: Use sync timing from beacon frames
+ *	only, to allow getting TBTT of a DTIM beacon.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1404,6 +1415,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
 	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
+	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4631de0..0aee941 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -86,7 +86,7 @@ struct ieee80211_fragment_entry {
 
 
 struct ieee80211_bss {
-	u32 device_ts;
+	u32 device_ts_beacon, device_ts_presp;
 
 	bool wmm_used;
 	bool uapsd_supported;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b49c484..735859e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2590,6 +2590,17 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 		ifmgd->assoc_data->have_beacon = true;
 		ifmgd->assoc_data->need_beacon = false;
+		if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
+			sdata->vif.bss_conf.sync_tsf =
+				le64_to_cpu(mgmt->u.beacon.timestamp);
+			sdata->vif.bss_conf.sync_device_ts =
+				rx_status->device_timestamp;
+			if (elems.tim)
+				sdata->vif.bss_conf.sync_dtim_count =
+					elems.tim->dtim_count;
+			else
+				sdata->vif.bss_conf.sync_dtim_count = 0;
+		}
 		/* continue assoc process */
 		ifmgd->assoc_data->timeout = jiffies;
 		run_again(ifmgd, ifmgd->assoc_data->timeout);
@@ -2748,7 +2759,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	/*
 	 * If we haven't had a beacon before, tell the driver about the
-	 * DTIM period now.
+	 * DTIM period (and beacon timing if desired) now.
 	 */
 	if (!bss_conf->dtim_period) {
 		/* a few bogus AP send dtim_period = 0 or no TIM IE */
@@ -2756,6 +2767,19 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			bss_conf->dtim_period = elems.tim->dtim_period ?: 1;
 		else
 			bss_conf->dtim_period = 1;
+
+		if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
+			sdata->vif.bss_conf.sync_tsf =
+				le64_to_cpu(mgmt->u.beacon.timestamp);
+			sdata->vif.bss_conf.sync_device_ts =
+				rx_status->device_timestamp;
+			if (elems.tim)
+				sdata->vif.bss_conf.sync_dtim_count =
+					elems.tim->dtim_count;
+			else
+				sdata->vif.bss_conf.sync_dtim_count = 0;
+		}
+
 		changed |= BSS_CHANGED_DTIM_PERIOD;
 	}
 
@@ -3738,10 +3762,33 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		/* set timing information */
 		sdata->vif.bss_conf.beacon_int = cbss->beacon_interval;
 		rcu_read_lock();
-		ies = rcu_dereference(cbss->ies);
-		sdata->vif.bss_conf.sync_tsf = ies->tsf;
+		ies = rcu_dereference(cbss->beacon_ies);
+		if (ies) {
+			const u8 *tim_ie;
+
+			sdata->vif.bss_conf.sync_tsf = ies->tsf;
+			sdata->vif.bss_conf.sync_device_ts =
+				bss->device_ts_beacon;
+			tim_ie = cfg80211_find_ie(WLAN_EID_TIM,
+						  ies->data, ies->len);
+			if (tim_ie && tim_ie[1] >= 2)
+				sdata->vif.bss_conf.sync_dtim_count = tim_ie[2];
+			else
+				sdata->vif.bss_conf.sync_dtim_count = 0;
+		} else if (!(local->hw.flags &
+					IEEE80211_HW_TIMING_BEACON_ONLY)) {
+			ies = rcu_dereference(cbss->proberesp_ies);
+			/* must be non-NULL since beacon IEs were NULL */
+			sdata->vif.bss_conf.sync_tsf = ies->tsf;
+			sdata->vif.bss_conf.sync_device_ts =
+				bss->device_ts_presp;
+			sdata->vif.bss_conf.sync_dtim_count = 0;
+		} else {
+			sdata->vif.bss_conf.sync_tsf = 0;
+			sdata->vif.bss_conf.sync_device_ts = 0;
+			sdata->vif.bss_conf.sync_dtim_count = 0;
+		}
 		rcu_read_unlock();
-		sdata->vif.bss_conf.sync_device_ts = bss->device_ts;
 
 		/* tell driver about BSSID, basic rates and timing */
 		ieee80211_bss_info_change_notify(sdata,
@@ -4067,13 +4114,23 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		const u8 *tim_ie = cfg80211_find_ie(WLAN_EID_TIM,
 						    beacon_ies->data,
 						    beacon_ies->len);
+		u8 dtim_count = 0;
+
 		if (tim_ie && tim_ie[1] >= sizeof(struct ieee80211_tim_ie)) {
 			const struct ieee80211_tim_ie *tim;
 			tim = (void *)(tim_ie + 2);
 			ifmgd->dtim_period = tim->dtim_period;
+			dtim_count = tim->dtim_count;
 		}
 		assoc_data->have_beacon = true;
 		assoc_data->timeout = jiffies;
+
+		if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
+			sdata->vif.bss_conf.sync_tsf = beacon_ies->tsf;
+			sdata->vif.bss_conf.sync_device_ts =
+				bss->device_ts_beacon;
+			sdata->vif.bss_conf.sync_dtim_count = dtim_count;
+		}
 	} else {
 		assoc_data->timeout = jiffies;
 	}
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 400153f..edd47d9 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -80,7 +80,10 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 
 	bss = (void *)cbss->priv;
 
-	bss->device_ts = rx_status->device_timestamp;
+	if (beacon)
+		bss->device_ts_beacon = rx_status->device_timestamp;
+	else
+		bss->device_ts_presp = rx_status->device_timestamp;
 
 	if (elems->parse_error) {
 		if (beacon)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 6ca53d6..dd2b80a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -340,6 +340,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(u16, assoc_cap)
 		__field(u64, sync_tsf)
 		__field(u32, sync_device_ts)
+		__field(u8, sync_dtim_count)
 		__field(u32, basic_rates)
 		__array(int, mcast_rate, IEEE80211_NUM_BANDS)
 		__field(u16, ht_operation_mode)
@@ -379,6 +380,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->assoc_cap = info->assoc_capability;
 		__entry->sync_tsf = info->sync_tsf;
 		__entry->sync_device_ts = info->sync_device_ts;
+		__entry->sync_dtim_count = info->sync_dtim_count;
 		__entry->basic_rates = info->basic_rates;
 		memcpy(__entry->mcast_rate, info->mcast_rate,
 		       sizeof(__entry->mcast_rate));
-- 
1.8.0

