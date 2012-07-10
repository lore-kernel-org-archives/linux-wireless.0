Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2GJJJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 05:09:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add time synchronisation with BSS for assoc
Date: Tue, 10 Jul 2012 11:09:10 +0200
Message-Id: <1341911350-13235-1-git-send-email-johannes@sipsolutions.net> (sfid-20120710_110929_487191_5EB8C63D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some drivers (iwlegacy, iwlwifi and rt2x00) today use the
bss_conf.last_tsf value. By itself though that value is
completely worthless since it may be ancient. What really
is needed is synchronisation between some device time and
the TSF.

To clarify this, rename bss_conf.last_tsf to sync_tsf and
add sync_device_ts which is obtained from rx_status which
gets a new field device_timestamp for this purpose. This
is intentionally not using the mactime field since that
is used for other things and in IBSS is expected to sync
with the IBSS's TSF which isn't necessarily true for the
device timestamp.

Also, since we have the information and it's useful even
before the connection has been established, give all the
timing details to the driver before authenticating.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/common.c     |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00config.c |    2 +-
 include/net/mac80211.h                     |   10 ++++++++--
 net/mac80211/ieee80211_i.h                 |    2 ++
 net/mac80211/mlme.c                        |   15 ++++++++-------
 net/mac80211/scan.c                        |    3 ++-
 net/mac80211/trace.h                       |    6 ++++--
 8 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index cbf2dc1..9cbed0b 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -5360,7 +5360,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changes & BSS_CHANGED_ASSOC) {
 		D_MAC80211("ASSOC %d\n", bss_conf->assoc);
 		if (bss_conf->assoc) {
-			il->timestamp = bss_conf->last_tsf;
+			il->timestamp = bss_conf->sync_tsf;
 
 			if (!il_is_rfkill(il))
 				il->ops->post_associate(il);
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 6ee940f..1089639 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1447,7 +1447,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changes & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
-			priv->timestamp = bss_conf->last_tsf;
+			priv->timestamp = bss_conf->sync_tsf;
 			ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		} else {
 			/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index e7361d9..49a63e9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -102,7 +102,7 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 
 	/* Update the AID, this is needed for dynamic PS support */
 	rt2x00dev->aid = bss_conf->assoc ? bss_conf->aid : 0;
-	rt2x00dev->last_beacon = bss_conf->last_tsf;
+	rt2x00dev->last_beacon = bss_conf->sync_tsf;
 
 	/* Update global beacon interval time, this is needed for PS support */
 	rt2x00dev->beacon_int = bss_conf->beacon_int;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 68c5afc..c609b9d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -233,8 +233,10 @@ enum ieee80211_rssi_event {
  *	valid in station mode only while @assoc is true and if also
  *	requested by %IEEE80211_HW_NEED_DTIM_PERIOD (cf. also hw conf
  *	@ps_dtim_period)
- * @last_tsf: last beacon's/probe response's TSF timestamp (could be old
+ * @sync_tsf: last beacon's/probe response's TSF timestamp (could be old
  *	as it may have been received during scanning long ago)
+ * @sync_device_ts: the device timestamp corresponding to the sync_tsf,
+ *	the driver/device can use this to calculate synchronisation
  * @beacon_int: beacon interval
  * @assoc_capability: capabilities taken from assoc resp
  * @basic_rates: bitmap of basic rates, each bit stands for an
@@ -281,7 +283,8 @@ struct ieee80211_bss_conf {
 	u8 dtim_period;
 	u16 beacon_int;
 	u16 assoc_capability;
-	u64 last_tsf;
+	u64 sync_tsf;
+	u32 sync_device_ts;
 	u32 basic_rates;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 	u16 ht_operation_mode;
@@ -716,6 +719,8 @@ enum mac80211_rx_flags {
  *
  * @mactime: value in microseconds of the 64-bit Time Synchronization Function
  * 	(TSF) timer when the first data symbol (MPDU) arrived at the hardware.
+ * @device_timestamp: arbitrary timestamp for the device, mac80211 doesn't use
+ *	it but can store it and pass it back to the driver for synchronisation
  * @band: the active band when this frame was received
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
  * @signal: signal strength when receiving this frame, either in dBm, in dB or
@@ -732,6 +737,7 @@ enum mac80211_rx_flags {
  */
 struct ieee80211_rx_status {
 	u64 mactime;
+	u32 device_timestamp;
 	u32 ampdu_reference;
 	u32 flag;
 	u16 freq;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a95003b..653be8d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -85,6 +85,8 @@ struct ieee80211_bss {
 	size_t ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 
+	u32 device_ts;
+
 	u8 dtim_period;
 
 	bool wmm_used;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4b503ce..4efcbf8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1269,11 +1269,6 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 
 	bss_info_changed |= BSS_CHANGED_ASSOC;
-	/* set timing information */
-	bss_conf->beacon_int = cbss->beacon_interval;
-	bss_conf->last_tsf = cbss->tsf;
-
-	bss_info_changed |= BSS_CHANGED_BEACON_INT;
 	bss_info_changed |= ieee80211_handle_bss_capability(sdata,
 		bss_conf->assoc_capability, bss->has_erp_value, bss->erp_value);
 
@@ -3135,9 +3130,15 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 
 		memcpy(ifmgd->bssid, cbss->bssid, ETH_ALEN);
 
-		/* tell driver about BSSID and basic rates */
+		/* set timing information */
+		sdata->vif.bss_conf.beacon_int = cbss->beacon_interval;
+		sdata->vif.bss_conf.sync_tsf = cbss->tsf;
+		sdata->vif.bss_conf.sync_device_ts = bss->device_ts;
+
+		/* tell driver about BSSID, basic rates and timing */
 		ieee80211_bss_info_change_notify(sdata,
-			BSS_CHANGED_BSSID | BSS_CHANGED_BASIC_RATES);
+			BSS_CHANGED_BSSID | BSS_CHANGED_BASIC_RATES |
+			BSS_CHANGED_BEACON_INT);
 
 		if (assoc)
 			sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 1a893f3..e80a8b6 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -83,13 +83,14 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 
 	cbss = cfg80211_inform_bss_frame(local->hw.wiphy, channel,
 					 mgmt, len, signal, GFP_ATOMIC);
-
 	if (!cbss)
 		return NULL;
 
 	cbss->free_priv = ieee80211_rx_bss_free;
 	bss = (void *)cbss->priv;
 
+	bss->device_ts = rx_status->device_timestamp;
+
 	if (elems->parse_error) {
 		if (beacon)
 			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_BEACON;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 1f3638b..65e9a2a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -306,7 +306,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(u8, dtimper)
 		__field(u16, bcnint)
 		__field(u16, assoc_cap)
-		__field(u64, timestamp)
+		__field(u64, sync_tsf)
+		__field(u32, sync_device_ts)
 		__field(u32, basic_rates)
 		__field(u32, changed)
 		__field(bool, enable_beacon)
@@ -325,7 +326,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->dtimper = info->dtim_period;
 		__entry->bcnint = info->beacon_int;
 		__entry->assoc_cap = info->assoc_capability;
-		__entry->timestamp = info->last_tsf;
+		__entry->sync_tsf = info->sync_tsf;
+		__entry->sync_device_ts = info->sync_device_ts;
 		__entry->basic_rates = info->basic_rates;
 		__entry->enable_beacon = info->enable_beacon;
 		__entry->ht_operation_mode = info->ht_operation_mode;
-- 
1.7.10.4

