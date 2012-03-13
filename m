Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2CMN3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 09:29:37 -0400
Subject: [PATCH] mac80211: rename bss_conf timestamp to last_tsf
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Mar 2012 14:29:30 +0100
Message-ID: <1331645370.3329.4.camel@jlt3.sipsolutions.net> (sfid-20120313_142950_826355_C6698F6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This value is not really very useful by itself,
yet some drivers (including iwlwifi until I can
figure out what it should do) use it. At least
rename it to "last_tsf" to indicate the meaning
and add a note that it may be really old.

I suspect the value may become useful combined
with the rx_status->mactime, but we don't (yet)
store that value and pass it to the driver.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/common.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00config.c  |    2 +-
 include/net/mac80211.h                      |    5 +++--
 net/mac80211/driver-trace.h                 |    2 +-
 net/mac80211/mlme.c                         |    2 +-
 6 files changed, 8 insertions(+), 7 deletions(-)

--- a/include/net/mac80211.h	2012-03-13 09:11:23.000000000 +0100
+++ b/include/net/mac80211.h	2012-03-13 14:20:50.000000000 +0100
@@ -229,7 +229,8 @@ enum ieee80211_rssi_event {
  *	valid in station mode only while @assoc is true and if also
  *	requested by %IEEE80211_HW_NEED_DTIM_PERIOD (cf. also hw conf
  *	@ps_dtim_period)
- * @timestamp: beacon timestamp
+ * @last_tsf: last beacon's/probe response's TSF timestamp (could be old
+ *	as it may have been received during scanning long ago)
  * @beacon_int: beacon interval
  * @assoc_capability: capabilities taken from assoc resp
  * @basic_rates: bitmap of basic rates, each bit stands for an
@@ -276,7 +277,7 @@ struct ieee80211_bss_conf {
 	u8 dtim_period;
 	u16 beacon_int;
 	u16 assoc_capability;
-	u64 timestamp;
+	u64 last_tsf;
 	u32 basic_rates;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 	u16 ht_operation_mode;
--- a/drivers/net/wireless/iwlegacy/common.c	2012-03-10 09:17:00.000000000 +0100
+++ b/drivers/net/wireless/iwlegacy/common.c	2012-03-13 14:21:26.000000000 +0100
@@ -5355,7 +5355,7 @@ il_mac_bss_info_changed(struct ieee80211
 	if (changes & BSS_CHANGED_ASSOC) {
 		D_MAC80211("ASSOC %d\n", bss_conf->assoc);
 		if (bss_conf->assoc) {
-			il->timestamp = bss_conf->timestamp;
+			il->timestamp = bss_conf->last_tsf;
 
 			if (!il_is_rfkill(il))
 				il->ops->post_associate(il);
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c	2012-03-13 09:11:23.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c	2012-03-13 14:21:10.000000000 +0100
@@ -822,7 +822,7 @@ void iwlagn_bss_info_changed(struct ieee
 
 	if (changes & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
-			priv->timestamp = bss_conf->timestamp;
+			priv->timestamp = bss_conf->last_tsf;
 			ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		} else {
 			/*
--- a/drivers/net/wireless/rt2x00/rt2x00config.c	2012-03-10 09:17:00.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c	2012-03-13 14:22:14.000000000 +0100
@@ -102,7 +102,7 @@ void rt2x00lib_config_erp(struct rt2x00_
 
 	/* Update the AID, this is needed for dynamic PS support */
 	rt2x00dev->aid = bss_conf->assoc ? bss_conf->aid : 0;
-	rt2x00dev->last_beacon = bss_conf->timestamp;
+	rt2x00dev->last_beacon = bss_conf->last_tsf;
 
 	/* Update global beacon interval time, this is needed for PS support */
 	rt2x00dev->beacon_int = bss_conf->beacon_int;
--- a/net/mac80211/driver-trace.h	2012-03-13 09:11:23.000000000 +0100
+++ b/net/mac80211/driver-trace.h	2012-03-13 14:22:34.000000000 +0100
@@ -296,7 +296,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->dtimper = info->dtim_period;
 		__entry->bcnint = info->beacon_int;
 		__entry->assoc_cap = info->assoc_capability;
-		__entry->timestamp = info->timestamp;
+		__entry->timestamp = info->last_tsf;
 		__entry->basic_rates = info->basic_rates;
 		__entry->enable_beacon = info->enable_beacon;
 		__entry->ht_operation_mode = info->ht_operation_mode;
--- a/net/mac80211/mlme.c	2012-03-13 09:22:34.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-13 14:24:35.000000000 +0100
@@ -1318,7 +1318,7 @@ static void ieee80211_set_associated(str
 	bss_info_changed |= BSS_CHANGED_ASSOC;
 	/* set timing information */
 	bss_conf->beacon_int = cbss->beacon_interval;
-	bss_conf->timestamp = cbss->tsf;
+	bss_conf->last_tsf = cbss->tsf;
 
 	bss_info_changed |= BSS_CHANGED_BEACON_INT;
 	bss_info_changed |= ieee80211_handle_bss_capability(sdata,


