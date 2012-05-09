Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2EIJIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 05:08:41 -0400
Message-ID: <1336554519.4323.7.camel@jlt3.sipsolutions.net> (sfid-20120509_110845_326411_F49D3B7C)
Subject: [RFC] mac80211: add time synchronisation with BSS for assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Helmut Schaa <Helmut.Schaa@gmx.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Date: Wed, 09 May 2012 11:08:39 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
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

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I note that rt2x00 is completely broken since it mixes last_tsf (now
sync_tsf) with jiffies ... what??

 Documentation/networking/mac80211-auth-assoc-deauth.txt |    2 +-
 drivers/net/wireless/iwlegacy/common.c                  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c             |    2 +-
 drivers/net/wireless/rt2x00/rt2x00config.c              |    2 +-
 include/net/mac80211.h                                  |    9 +++++++--
 net/mac80211/driver-trace.h                             |    6 ++++--
 net/mac80211/ieee80211_i.h                              |    2 ++
 net/mac80211/mlme.c                                     |   15 ++++++++-------
 net/mac80211/scan.c                                     |    3 ++-
 9 files changed, 27 insertions(+), 16 deletions(-)

--- a/include/net/mac80211.h	2012-05-09 09:05:52.000000000 +0200
+++ b/include/net/mac80211.h	2012-05-09 09:06:12.000000000 +0200
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
@@ -281,7 +283,7 @@ struct ieee80211_bss_conf {
 	u8 dtim_period;
 	u16 beacon_int;
 	u16 assoc_capability;
-	u64 last_tsf;
+	u64 sync_tsf, sync_device_ts;
 	u32 basic_rates;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 	u16 ht_operation_mode;
@@ -692,6 +694,8 @@ enum mac80211_rx_flags {
  *
  * @mactime: value in microseconds of the 64-bit Time Synchronization Function
  * 	(TSF) timer when the first data symbol (MPDU) arrived at the hardware.
+ * @device_timestamp: arbitrary timestamp for the device, mac80211 doesn't use
+ *	it but can store it and pass it back to the driver for synchronisation
  * @band: the active band when this frame was received
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
  * @signal: signal strength when receiving this frame, either in dBm, in dB or
@@ -705,6 +709,7 @@ enum mac80211_rx_flags {
  */
 struct ieee80211_rx_status {
 	u64 mactime;
+	u64 device_timestamp;
 	enum ieee80211_band band;
 	int freq;
 	int signal;
--- a/drivers/net/wireless/iwlegacy/common.c	2012-05-09 09:05:52.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/common.c	2012-05-09 09:05:53.000000000 +0200
@@ -5360,7 +5360,7 @@ il_mac_bss_info_changed(struct ieee80211
 	if (changes & BSS_CHANGED_ASSOC) {
 		D_MAC80211("ASSOC %d\n", bss_conf->assoc);
 		if (bss_conf->assoc) {
-			il->timestamp = bss_conf->last_tsf;
+			il->timestamp = bss_conf->sync_tsf;
 
 			if (!il_is_rfkill(il))
 				il->ops->post_associate(il);
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c	2012-05-09 09:05:52.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c	2012-05-09 09:05:53.000000000 +0200
@@ -1463,7 +1463,7 @@ void iwlagn_bss_info_changed(struct ieee
 
 	if (changes & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
-			priv->timestamp = bss_conf->last_tsf;
+			priv->timestamp = bss_conf->sync_tsf;
 			ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		} else {
 			/*
--- a/drivers/net/wireless/rt2x00/rt2x00config.c	2012-05-09 09:05:52.000000000 +0200
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c	2012-05-09 09:05:53.000000000 +0200
@@ -102,7 +102,7 @@ void rt2x00lib_config_erp(struct rt2x00_
 
 	/* Update the AID, this is needed for dynamic PS support */
 	rt2x00dev->aid = bss_conf->assoc ? bss_conf->aid : 0;
-	rt2x00dev->last_beacon = bss_conf->last_tsf;
+	rt2x00dev->last_beacon = bss_conf->sync_tsf;
 
 	/* Update global beacon interval time, this is needed for PS support */
 	rt2x00dev->beacon_int = bss_conf->beacon_int;
--- a/net/mac80211/driver-trace.h	2012-05-09 09:05:52.000000000 +0200
+++ b/net/mac80211/driver-trace.h	2012-05-09 09:05:53.000000000 +0200
@@ -306,7 +306,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(u8, dtimper)
 		__field(u16, bcnint)
 		__field(u16, assoc_cap)
-		__field(u64, timestamp)
+		__field(u64, sync_tsf)
+		__field(u64, sync_device_ts)
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
--- a/net/mac80211/ieee80211_i.h	2012-05-09 09:05:52.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2012-05-09 09:05:53.000000000 +0200
@@ -77,6 +77,8 @@ struct ieee80211_fragment_entry {
 
 
 struct ieee80211_bss {
+	u64 device_ts;
+
 	/* don't want to look up all the time */
 	size_t ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
--- a/net/mac80211/mlme.c	2012-05-09 09:05:52.000000000 +0200
+++ b/net/mac80211/mlme.c	2012-05-09 09:07:31.000000000 +0200
@@ -1259,11 +1259,6 @@ static void ieee80211_set_associated(str
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 
 	bss_info_changed |= BSS_CHANGED_ASSOC;
-	/* set timing information */
-	bss_conf->beacon_int = cbss->beacon_interval;
-	bss_conf->last_tsf = cbss->tsf;
-
-	bss_info_changed |= BSS_CHANGED_BEACON_INT;
 	bss_info_changed |= ieee80211_handle_bss_capability(sdata,
 		cbss->capability, bss->has_erp_value, bss->erp_value);
 
@@ -3141,9 +3136,15 @@ static int ieee80211_prep_connection(str
 
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
--- a/net/mac80211/scan.c	2012-05-09 09:05:52.000000000 +0200
+++ b/net/mac80211/scan.c	2012-05-09 09:05:53.000000000 +0200
@@ -83,13 +83,14 @@ ieee80211_bss_info_update(struct ieee802
 
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
--- a/Documentation/networking/mac80211-auth-assoc-deauth.txt	2012-04-12 05:40:25.000000000 +0200
+++ b/Documentation/networking/mac80211-auth-assoc-deauth.txt	2012-05-09 09:16:47.000000000 +0200
@@ -24,7 +24,7 @@ end note
 end
 
 mac80211->driver: config(channel, channel type)
-mac80211->driver: bss_info_changed(set BSSID, basic rate bitmap)
+mac80211->driver: bss_info_changed(set BSSID, basic rate bitmap, timings)
 mac80211->driver: sta_state(AP, exists)
 
 alt no probe request data known


