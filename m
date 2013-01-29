Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3A2Jzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 04:55:37 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] mac80211: inform the driver about update of dtim_period
Date: Tue, 29 Jan 2013 10:55:59 +0100
Message-Id: <1359453359-20767-2-git-send-email-johannes@sipsolutions.net> (sfid-20130129_105543_802273_AB8DD8D9)
In-Reply-To: <1359453359-20767-1-git-send-email-johannes@sipsolutions.net>
References: <1359453359-20767-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Currently, when the driver requires the DTIM period,
mac80211 will wait to hear a beacon before association.
This behavior is suboptimal since some drivers may be
able to deal with knowing the DTIM period after the
association, if they get it at all.

To address this, notify the drivers with bss_info_changed
with the new BSS_CHANGED_DTIM_PERIOD flag when the DTIM
becomes known. This might be when changing to associated,
or later when the entire association was done with only
probe response information.

Rename the hardware flag for the current behaviour to
IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC to more accurately
reflect its behaviour. IEEE80211_HW_NEED_DTIM_PERIOD is
no longer accurate as all drivers get the DTIM period
now, just not before association.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/carl9170/main.c    |  2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c    |  2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  2 +-
 include/net/mac80211.h                      | 16 ++++---
 net/mac80211/debugfs.c                      |  4 +-
 net/mac80211/ieee80211_i.h                  |  2 +-
 net/mac80211/mlme.c                         | 74 +++++++++++++++++------------
 net/mac80211/util.c                         |  4 ++
 8 files changed, 63 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index aaa2699..d6cd29d 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1786,7 +1786,7 @@ void *carl9170_alloc(size_t priv_size)
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
-		     IEEE80211_HW_NEED_DTIM_PERIOD |
+		     IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
 		     IEEE80211_HW_SIGNAL_DBM;
 
 	if (!modparam_noht) {
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 6a86ed4..2fb40ac 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5711,7 +5711,7 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	/* Tell mac80211 our characteristics */
 	hw->flags =
 	    IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_AMPDU_AGGREGATION |
-	    IEEE80211_HW_NEED_DTIM_PERIOD | IEEE80211_HW_SPECTRUM_MGMT |
+	    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC | IEEE80211_HW_SPECTRUM_MGMT |
 	    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	if (il->cfg->sku & IL_SKU_N)
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index f16b81d..900075d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -145,7 +145,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_NEED_DTIM_PERIOD |
+		    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
 		    IEEE80211_HW_SPECTRUM_MGMT |
 		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		    IEEE80211_HW_QUEUE_CONTROL |
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a06780a..514543c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -208,6 +208,8 @@ struct ieee80211_chanctx_conf {
  * @BSS_CHANGED_TXPOWER: TX power setting changed for this interface
  * @BSS_CHANGED_P2P_PS: P2P powersave settings (CTWindow, opportunistic PS)
  *	changed (currently only in P2P client mode, GO mode will be later)
+ * @BSS_CHANGED_DTIM_PERIOD: the DTIM period value was changed (set when
+ *	it becomes valid, managed mode only)
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -230,6 +232,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_PS			= 1<<17,
 	BSS_CHANGED_TXPOWER		= 1<<18,
 	BSS_CHANGED_P2P_PS		= 1<<19,
+	BSS_CHANGED_DTIM_PERIOD		= 1<<20,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -271,9 +274,8 @@ enum ieee80211_rssi_event {
  *	if the hardware cannot handle this it must set the
  *	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
  * @dtim_period: num of beacons before the next DTIM, for beaconing,
- *	valid in station mode only while @assoc is true and if also
- *	requested by %IEEE80211_HW_NEED_DTIM_PERIOD (cf. also hw conf
- *	@ps_dtim_period)
+ *	valid in station mode only if after the driver was notified
+ *	with the %BSS_CHANGED_DTIM_PERIOD flag, will be non-zero then.
  * @sync_tsf: last beacon's/probe response's TSF timestamp (could be old
  *	as it may have been received during scanning long ago)
  * @sync_device_ts: the device timestamp corresponding to the sync_tsf,
@@ -1333,9 +1335,9 @@ struct ieee80211_tx_control {
  *      When this flag is set, signaling beacon-loss will cause an immediate
  *      change to disassociated state.
  *
- * @IEEE80211_HW_NEED_DTIM_PERIOD:
- *	This device needs to know the DTIM period for the BSS before
- *	associating.
+ * @IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC:
+ *	This device needs to get data from beacon before association (i.e.
+ *	dtim_period).
  *
  * @IEEE80211_HW_SUPPORTS_PER_STA_GTK: The device's crypto engine supports
  *	per-station GTKs as used by IBSS RSN or during fast transition. If
@@ -1384,7 +1386,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
 	IEEE80211_HW_SIGNAL_UNSPEC			= 1<<5,
 	IEEE80211_HW_SIGNAL_DBM				= 1<<6,
-	IEEE80211_HW_NEED_DTIM_PERIOD			= 1<<7,
+	IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC		= 1<<7,
 	IEEE80211_HW_SPECTRUM_MGMT			= 1<<8,
 	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<9,
 	IEEE80211_HW_SUPPORTS_PS			= 1<<10,
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 466f4b4..8e604099 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -121,8 +121,8 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 		sf += snprintf(buf + sf, mxln - sf, "SIGNAL_UNSPEC\n");
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		sf += snprintf(buf + sf, mxln - sf, "SIGNAL_DBM\n");
-	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
-		sf += snprintf(buf + sf, mxln - sf, "NEED_DTIM_PERIOD\n");
+	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC)
+		sf += snprintf(buf + sf, mxln - sf, "NEED_DTIM_BEFORE_ASSOC\n");
 	if (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT)
 		sf += snprintf(buf + sf, mxln - sf, "SPECTRUM_MGMT\n");
 	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0f3e4b1..dc1000c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -399,7 +399,7 @@ struct ieee80211_mgd_assoc_data {
 	u8 ssid_len;
 	u8 supp_rates_len;
 	bool wmm, uapsd;
-	bool have_beacon;
+	bool have_beacon, need_beacon;
 	bool synced;
 
 	u8 ap_ht_param;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index eda80b1..84b8afb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1444,7 +1444,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_led_assoc(local, 1);
 
-	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {
+	if (sdata->u.mgd.assoc_data->have_beacon) {
 		/*
 		 * If the AP is buggy we may get here with no DTIM period
 		 * known, so assume it's 1 which is the only safe assumption
@@ -1452,6 +1452,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 		 * probably just won't work at all.
 		 */
 		bss_conf->dtim_period = sdata->u.mgd.dtim_period ?: 1;
+		bss_info_changed |= BSS_CHANGED_DTIM_PERIOD;
 	} else {
 		bss_conf->dtim_period = 0;
 	}
@@ -2571,13 +2572,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
 
-	if (ifmgd->assoc_data && !ifmgd->assoc_data->have_beacon &&
+	if (ifmgd->assoc_data && ifmgd->assoc_data->need_beacon &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->assoc_data->bss->bssid)) {
 		ieee802_11_parse_elems(mgmt->u.beacon.variable,
 				       len - baselen, &elems);
 
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 		ifmgd->assoc_data->have_beacon = true;
+		ifmgd->assoc_data->need_beacon = false;
 		/* continue assoc process */
 		ifmgd->assoc_data->timeout = jiffies;
 		run_again(ifmgd, ifmgd->assoc_data->timeout);
@@ -2734,6 +2736,19 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     elems.wmm_param_len))
 		changed |= BSS_CHANGED_QOS;
 
+	/*
+	 * If we haven't had a beacon before, tell the driver about the
+	 * DTIM period now.
+	 */
+	if (!bss_conf->dtim_period) {
+		/* a few bogus AP send dtim_period = 0 or no TIM IE */
+		if (elems.tim)
+			bss_conf->dtim_period = elems.tim->dtim_period ?: 1;
+		else
+			bss_conf->dtim_period = 1;
+		changed |= BSS_CHANGED_DTIM_PERIOD;
+	}
+
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		erp_valid = true;
 		erp_value = elems.erp_info[0];
@@ -3015,7 +3030,8 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 	if (ifmgd->assoc_data &&
 	    time_after(jiffies, ifmgd->assoc_data->timeout)) {
-		if (!ifmgd->assoc_data->have_beacon ||
+		if ((ifmgd->assoc_data->need_beacon &&
+		     !ifmgd->assoc_data->have_beacon) ||
 		    ieee80211_do_assoc(sdata)) {
 			u8 bssid[ETH_ALEN];
 
@@ -3802,6 +3818,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)req->bss->priv;
 	struct ieee80211_mgd_assoc_data *assoc_data;
+	const struct cfg80211_bss_ies *beacon_ies;
 	struct ieee80211_supported_band *sband;
 	const u8 *ssidie, *ht_ie, *vht_ie;
 	int i, err;
@@ -3967,38 +3984,35 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (err)
 		goto err_clear;
 
-	if (sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {
-		const struct cfg80211_bss_ies *beacon_ies;
+	rcu_read_lock();
+	beacon_ies = rcu_dereference(req->bss->beacon_ies);
 
-		rcu_read_lock();
-		beacon_ies = rcu_dereference(req->bss->beacon_ies);
-		if (!beacon_ies) {
-			/*
-			 * Wait up to one beacon interval ...
-			 * should this be more if we miss one?
-			 */
-			sdata_info(sdata, "waiting for beacon from %pM\n",
-				   ifmgd->bssid);
-			assoc_data->timeout =
-				TU_TO_EXP_TIME(req->bss->beacon_interval);
-		} else {
-			const u8 *tim_ie = cfg80211_find_ie(WLAN_EID_TIM,
-							    beacon_ies->data,
-							    beacon_ies->len);
-			if (tim_ie && tim_ie[1] >=
-					sizeof(struct ieee80211_tim_ie)) {
-				const struct ieee80211_tim_ie *tim;
-				tim = (void *)(tim_ie + 2);
-				ifmgd->dtim_period = tim->dtim_period;
-			}
-			assoc_data->have_beacon = true;
-			assoc_data->timeout = jiffies;
+	if (sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC &&
+	    !beacon_ies) {
+		/*
+		 * Wait up to one beacon interval ...
+		 * should this be more if we miss one?
+		 */
+		sdata_info(sdata, "waiting for beacon from %pM\n",
+			   ifmgd->bssid);
+		assoc_data->timeout = TU_TO_EXP_TIME(req->bss->beacon_interval);
+		assoc_data->need_beacon = true;
+	} else if (beacon_ies) {
+		const u8 *tim_ie = cfg80211_find_ie(WLAN_EID_TIM,
+						    beacon_ies->data,
+						    beacon_ies->len);
+		if (tim_ie && tim_ie[1] >= sizeof(struct ieee80211_tim_ie)) {
+			const struct ieee80211_tim_ie *tim;
+			tim = (void *)(tim_ie + 2);
+			ifmgd->dtim_period = tim->dtim_period;
 		}
-		rcu_read_unlock();
-	} else {
 		assoc_data->have_beacon = true;
 		assoc_data->timeout = jiffies;
+	} else {
+		assoc_data->timeout = jiffies;
 	}
+	rcu_read_unlock();
+
 	run_again(ifmgd, assoc_data->timeout);
 
 	if (bss->corrupt_data) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8627fcb..cb343ce 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1545,6 +1545,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			changed |= BSS_CHANGED_ASSOC |
 				   BSS_CHANGED_ARP_FILTER |
 				   BSS_CHANGED_PS;
+
+			if (sdata->u.mgd.dtim_period)
+				changed |= BSS_CHANGED_DTIM_PERIOD;
+
 			mutex_lock(&sdata->u.mgd.mtx);
 			ieee80211_bss_info_change_notify(sdata, changed);
 			mutex_unlock(&sdata->u.mgd.mtx);
-- 
1.8.0

