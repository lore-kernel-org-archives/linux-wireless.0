Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2LKTSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:18:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix dtim_period in hidden SSID AP association
Date: Tue, 11 Dec 2012 20:18:22 +0100
Message-Id: <1355253502-23159-1-git-send-email-johannes@sipsolutions.net> (sfid-20121211_201803_393036_58A29981)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When AP's SSID is hidden the BSS can appear several times in
cfg80211's BSS list: once with a zero-length SSID that comes
from the beacon, and once for each SSID from probe reponses.

Since the mac80211 stores its data in ieee80211_bss which
is embedded into cfg80211_bss, mac80211's data will be
duplicated too.

This becomes a problem when a driver needs the dtim_period
since this data exists only in the beacon's instance in
cfg80211 bss table which isn't the instance that is used
when associating.

Remove the DTIM period from the BSS table and track it
explicitly to avoid this problem.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  5 +----
 net/mac80211/mlme.c        | 51 ++++++++++++++++++++++++++++++----------------
 net/mac80211/scan.c        | 12 -----------
 3 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 185973d..3d435766 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -92,8 +92,6 @@ struct ieee80211_bss {
 
 	u32 device_ts;
 
-	u8 dtim_period;
-
 	bool wmm_used;
 	bool uapsd_supported;
 
@@ -140,7 +138,6 @@ enum ieee80211_bss_corrupt_data_flags {
 
 /**
  * enum ieee80211_valid_data_flags - BSS valid data flags
- * @IEEE80211_BSS_VALID_DTIM: DTIM data was gathered from non-corrupt IE
  * @IEEE80211_BSS_VALID_WMM: WMM/UAPSD data was gathered from non-corrupt IE
  * @IEEE80211_BSS_VALID_RATES: Supported rates were gathered from non-corrupt IE
  * @IEEE80211_BSS_VALID_ERP: ERP flag was gathered from non-corrupt IE
@@ -151,7 +148,6 @@ enum ieee80211_bss_corrupt_data_flags {
  * beacon/probe response.
  */
 enum ieee80211_bss_valid_data_flags {
-	IEEE80211_BSS_VALID_DTIM		= BIT(0),
 	IEEE80211_BSS_VALID_WMM			= BIT(1),
 	IEEE80211_BSS_VALID_RATES		= BIT(2),
 	IEEE80211_BSS_VALID_ERP			= BIT(3)
@@ -442,6 +438,7 @@ struct ieee80211_if_managed {
 	unsigned long timers_running; /* used for quiesce/restart */
 	bool powersave; /* powersave requested for this iface */
 	bool broken_ap; /* AP is broken -- turn off powersave */
+	u8 dtim_period;
 	enum ieee80211_smps_mode req_smps, /* requested smps mode */
 				 driver_smps_mode; /* smps mode request */
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a5a89ac..97c830d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1112,12 +1112,8 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
 		} else {
-			struct ieee80211_bss *bss;
 			int maxslp = 1;
-			u8 dtimper;
-
-			bss = (void *)found->u.mgd.associated->priv;
-			dtimper = bss->dtim_period;
+			u8 dtimper = found->u.mgd.dtim_period;
 
 			/* If the TIM IE is invalid, pretend the value is 1 */
 			if (!dtimper)
@@ -1449,7 +1445,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	ieee80211_led_assoc(local, 1);
 
 	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
-		bss_conf->dtim_period = bss->dtim_period;
+		bss_conf->dtim_period = sdata->u.mgd.dtim_period ?: 1;
 	else
 		bss_conf->dtim_period = 0;
 
@@ -2416,9 +2412,12 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	if (sdata->u.mgd.associated &&
 	    ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid)) {
-		bss = (void *)sdata->u.mgd.associated->priv;
 		/* not previously set so we may need to recalc */
-		need_ps = !bss->dtim_period;
+		need_ps = !sdata->u.mgd.dtim_period;
+		if (elems->tim && !elems->parse_error) {
+			struct ieee80211_tim_ie *tim_ie = elems->tim;
+			sdata->u.mgd.dtim_period = tim_ie->dtim_period;
+		}
 	}
 
 	if (elems->ds_params && elems->ds_params_len == 1)
@@ -3964,20 +3963,38 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	/* kick off associate process */
 
 	ifmgd->assoc_data = assoc_data;
+	ifmgd->dtim_period = 0;
 
 	err = ieee80211_prep_connection(sdata, req->bss, true);
 	if (err)
 		goto err_clear;
 
-	if (!bss->dtim_period &&
-	    sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {
-		/*
-		 * Wait up to one beacon interval ...
-		 * should this be more if we miss one?
-		 */
-		sdata_info(sdata, "waiting for beacon from %pM\n",
-			   ifmgd->bssid);
-		assoc_data->timeout = TU_TO_EXP_TIME(req->bss->beacon_interval);
+	if (sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {
+		const struct cfg80211_bss_ies *beacon_ies;
+
+		rcu_read_lock();
+		beacon_ies = rcu_dereference(req->bss->beacon_ies);
+		if (!beacon_ies) {
+			/*
+			 * Wait up to one beacon interval ...
+			 * should this be more if we miss one?
+			 */
+			sdata_info(sdata, "waiting for beacon from %pM\n",
+				   ifmgd->bssid);
+			assoc_data->timeout =
+				TU_TO_EXP_TIME(req->bss->beacon_interval);
+		} else {
+			const u8 *tim_ie = cfg80211_find_ie(WLAN_EID_TIM,
+							    beacon_ies->data,
+							    beacon_ies->len);
+			if (tim_ie && tim_ie[1] >=
+					sizeof(struct ieee80211_tim_ie)) {
+				const struct ieee80211_tim_ie *tim;
+				tim = (void *)(tim_ie + 2);
+				ifmgd->dtim_period = tim->dtim_period;
+			}
+		}
+		rcu_read_unlock();
 	} else {
 		assoc_data->have_beacon = true;
 		assoc_data->sent_assoc = false;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f0b8072..31054a8 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -112,18 +112,6 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			bss->valid_data |= IEEE80211_BSS_VALID_ERP;
 	}
 
-	if (elems->tim && (!elems->parse_error ||
-			   !(bss->valid_data & IEEE80211_BSS_VALID_DTIM))) {
-		struct ieee80211_tim_ie *tim_ie = elems->tim;
-		bss->dtim_period = tim_ie->dtim_period;
-		if (!elems->parse_error)
-			bss->valid_data |= IEEE80211_BSS_VALID_DTIM;
-	}
-
-	/* If the beacon had no TIM IE, or it was invalid, use 1 */
-	if (beacon && !bss->dtim_period)
-		bss->dtim_period = 1;
-
 	/* replace old supported rates if we get new values */
 	if (!elems->parse_error ||
 	    !(bss->valid_data & IEEE80211_BSS_VALID_RATES)) {
-- 
1.8.0

