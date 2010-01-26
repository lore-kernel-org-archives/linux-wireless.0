Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0AZNUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 08:20:08 -0500
Subject: [PATCH] mac80211: wait for beacon before enabling powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: kalle.valo@iki.fi, linux-wireless@vger.kernel.org, j@w1.fi,
	buytenh@wantstofly.org, wey-yi.w.guy@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 14:19:52 +0100
Message-ID: <1264511993.25642.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because DTIM information is required for powersave
but is only conveyed in beacons, wait for a beacon
before enabling powersave, and change the way the
information is conveyed to the driver accordingly.

mwl8k doesn't currently seem to implement PS but
requires the DTIM period in a different way; after
talking to Lennert we agreed to just have mwl8k do
the parsing itself in the finalize_join work.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
The mwl8k part requires the cfg80211 change.

 drivers/net/wireless/iwlwifi/iwl-power.c  |    2 +-
 drivers/net/wireless/mwl8k.c              |   14 +++++++++-----
 drivers/net/wireless/wl12xx/wl1251.h      |    3 ---
 drivers/net/wireless/wl12xx/wl1251_main.c |   25 +++++++------------------
 include/net/mac80211.h                    |    7 ++++++-
 net/mac80211/mlme.c                       |   27 ++++++++++++++++++++++++---
 net/mac80211/scan.c                       |    4 ----
 7 files changed, 47 insertions(+), 35 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-01-26 09:35:35.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2010-01-26 09:35:50.000000000 +0100
@@ -186,7 +186,8 @@ enum ieee80211_bss_change {
  * @use_short_slot: use short slot time (only relevant for ERP);
  *	if the hardware cannot handle this it must set the
  *	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
- * @dtim_period: num of beacons before the next DTIM, for PSM
+ * @dtim_period: num of beacons before the next DTIM, for beaconing,
+ *	not valid in station mode (cf. hw conf ps_dtim_period)
  * @timestamp: beacon timestamp
  * @beacon_int: beacon interval
  * @assoc_capability: capabilities taken from assoc resp
@@ -652,6 +653,9 @@ enum ieee80211_smps_mode {
  *	value will be only achievable between DTIM frames, the hardware
  *	needs to check for the multicast traffic bit in DTIM beacons.
  *	This variable is valid only when the CONF_PS flag is set.
+ * @ps_dtim_period: The DTIM period of the AP we're connected to, for use
+ *	in power saving. Power saving will not be enabled until a beacon
+ *	has been received and the DTIM period is known.
  * @dynamic_ps_timeout: The dynamic powersave timeout (in ms), see the
  *	powersave documentation below. This variable is valid only when
  *	the CONF_PS flag is set.
@@ -678,6 +682,7 @@ struct ieee80211_conf {
 	int max_sleep_period;
 
 	u16 listen_interval;
+	u8 ps_dtim_period;
 
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
--- wireless-testing.orig/net/mac80211/mlme.c	2010-01-26 09:35:35.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2010-01-26 09:35:50.000000000 +0100
@@ -480,6 +480,7 @@ void ieee80211_recalc_ps(struct ieee8021
 
 	if (count == 1 && found->u.mgd.powersave &&
 	    found->u.mgd.associated &&
+	    found->u.mgd.associated->beacon_ies &&
 	    !(found->u.mgd.flags & (IEEE80211_STA_BEACON_POLL |
 				    IEEE80211_STA_CONNECTION_POLL))) {
 		s32 beaconint_us;
@@ -493,14 +494,22 @@ void ieee80211_recalc_ps(struct ieee8021
 		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
 		} else {
-			u8 dtimper = found->vif.bss_conf.dtim_period;
+			struct ieee80211_bss *bss;
 			int maxslp = 1;
+			u8 dtimper;
 
-			if (dtimper > 1)
+			bss = (void *)found->u.mgd.associated->priv;
+			dtimper = bss->dtim_period;
+
+			/* If the TIM IE is invalid, pretend the value is 1 */
+			if (!dtimper)
+				dtimper = 1;
+			else if (dtimper > 1)
 				maxslp = min_t(int, dtimper,
 						    latency / beaconint_us);
 
 			local->hw.conf.max_sleep_period = maxslp;
+			local->hw.conf.ps_dtim_period = dtimper;
 			local->ps_sdata = found;
 		}
 	} else {
@@ -698,7 +707,6 @@ static void ieee80211_set_associated(str
 	/* set timing information */
 	sdata->vif.bss_conf.beacon_int = cbss->beacon_interval;
 	sdata->vif.bss_conf.timestamp = cbss->tsf;
-	sdata->vif.bss_conf.dtim_period = bss->dtim_period;
 
 	bss_info_changed |= BSS_CHANGED_BEACON_INT;
 	bss_info_changed |= ieee80211_handle_bss_capability(sdata,
@@ -1164,6 +1172,13 @@ static void ieee80211_rx_bss_info(struct
 	int freq;
 	struct ieee80211_bss *bss;
 	struct ieee80211_channel *channel;
+	bool need_ps = false;
+
+	if (sdata->u.mgd.associated) {
+		bss = (void *)sdata->u.mgd.associated->priv;
+		/* not previously set so we may need to recalc */
+		need_ps = !bss->dtim_period;
+	}
 
 	if (elems->ds_params && elems->ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
@@ -1183,6 +1198,12 @@ static void ieee80211_rx_bss_info(struct
 	if (!sdata->u.mgd.associated)
 		return;
 
+	if (need_ps) {
+		mutex_lock(&local->iflist_mtx);
+		ieee80211_recalc_ps(local, -1);
+		mutex_unlock(&local->iflist_mtx);
+	}
+
 	if (elems->ch_switch_elem && (elems->ch_switch_elem_len == 3) &&
 	    (memcmp(mgmt->bssid, sdata->u.mgd.associated->bssid,
 							ETH_ALEN) == 0)) {
--- wireless-testing.orig/net/mac80211/scan.c	2010-01-26 09:35:35.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2010-01-26 09:35:50.000000000 +0100
@@ -111,10 +111,6 @@ ieee80211_bss_info_update(struct ieee802
 		bss->dtim_period = tim_ie->dtim_period;
 	}
 
-	/* set default value for buggy AP/no TIM element */
-	if (bss->dtim_period == 0)
-		bss->dtim_period = 1;
-
 	bss->supp_rates_len = 0;
 	if (elems->supp_rates) {
 		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-power.c	2010-01-26 09:35:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-power.c	2010-01-26 09:35:50.000000000 +0100
@@ -319,7 +319,7 @@ int iwl_power_update_mode(struct iwl_pri
 			priv->chain_noise_data.state == IWL_CHAIN_NOISE_ALIVE;
 
 	if (priv->vif)
-		dtimper = priv->vif->bss_conf.dtim_period;
+		dtimper = priv->hw->conf.ps_dtim_period;
 	else
 		dtimper = 1;
 
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251.h	2010-01-26 09:35:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251.h	2010-01-26 09:35:50.000000000 +0100
@@ -341,9 +341,6 @@ struct wl1251 {
 	/* Are we currently scanning */
 	bool scanning;
 
-	/* Our association ID */
-	u16 aid;
-
 	/* Default key (for WEP) */
 	u32 default_key;
 
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251_main.c	2010-01-26 09:35:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251_main.c	2010-01-26 09:35:50.000000000 +0100
@@ -617,10 +617,13 @@ static int wl1251_op_config(struct ieee8
 
 		wl->psm_requested = true;
 
+		wl->dtim_period = conf->ps_dtim_period;
+
+		ret = wl1251_acx_wr_tbtt_and_dtim(wl, wl->beacon_int,
+						  wl->dtim_period);
+
 		/*
-		 * We enter PSM only if we're already associated.
-		 * If we're not, we'll enter it when joining an SSID,
-		 * through the bss_info_changed() hook.
+		 * mac80211 enables PSM only if we're already associated.
 		 */
 		ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
@@ -943,7 +946,6 @@ static void wl1251_op_bss_info_changed(s
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
 {
-	enum wl1251_cmd_ps_mode mode;
 	struct wl1251 *wl = hw->priv;
 	struct sk_buff *beacon, *skb;
 	int ret;
@@ -984,11 +986,6 @@ static void wl1251_op_bss_info_changed(s
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			wl->beacon_int = bss_conf->beacon_int;
-			wl->dtim_period = bss_conf->dtim_period;
-
-			ret = wl1251_acx_wr_tbtt_and_dtim(wl, wl->beacon_int,
-							  wl->dtim_period);
-			wl->aid = bss_conf->aid;
 
 			skb = ieee80211_pspoll_get(wl->hw, wl->vif);
 			if (!skb)
@@ -1001,17 +998,9 @@ static void wl1251_op_bss_info_changed(s
 			if (ret < 0)
 				goto out_sleep;
 
-			ret = wl1251_acx_aid(wl, wl->aid);
+			ret = wl1251_acx_aid(wl, bss_conf->aid);
 			if (ret < 0)
 				goto out_sleep;
-
-			/* If we want to go in PSM but we're not there yet */
-			if (wl->psm_requested && !wl->psm) {
-				mode = STATION_POWER_SAVE_MODE;
-				ret = wl1251_ps_set_mode(wl, mode);
-				if (ret < 0)
-					goto out_sleep;
-			}
 		} else {
 			/* use defaults when not associated */
 			wl->beacon_int = WL1251_DEFAULT_BEACON_INT;
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2010-01-26 09:35:41.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2010-01-26 09:35:56.000000000 +0100
@@ -3881,12 +3881,16 @@ static void mwl8k_finalize_join_worker(s
 	struct mwl8k_priv *priv =
 		container_of(work, struct mwl8k_priv, finalize_join_worker);
 	struct sk_buff *skb = priv->beacon_skb;
-	struct mwl8k_vif *mwl8k_vif;
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	int len = skb->len - offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	const u8 *tim = cfg80211_find_ie(WLAN_EID_TIM,
+					 mgmt->u.beacon.variable, len);
+	int dtim_period = 1;
 
-	mwl8k_vif = mwl8k_first_vif(priv);
-	if (mwl8k_vif != NULL)
-		mwl8k_cmd_finalize_join(priv->hw, skb->data, skb->len,
-					mwl8k_vif->vif->bss_conf.dtim_period);
+	if (tim && tim[1] >= 2)
+		dtim_period = tim[3];
+
+	mwl8k_cmd_finalize_join(priv->hw, skb->data, skb->len, dtim_period);
 
 	dev_kfree_skb(skb);
 	priv->beacon_skb = NULL;


