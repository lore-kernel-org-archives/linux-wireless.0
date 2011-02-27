Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57282 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1B0Duk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 22:50:40 -0500
Received: by iyb26 with SMTP id 26so1973610iyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Feb 2011 19:50:39 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19817.51728.628618.230856@gargle.gargle.HOWL>
Date: Sun, 27 Feb 2011 09:20:40 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2] ath9k_htc: Handle BSSID/AID for multiple interfaces
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The AID and BSSID should be set in the HW only for the
first station interface or adhoc interface. Also, cancel
the ANI timer in stop() for multi-STA scenario. And finally
configure the HW beacon timers only for the first station
interface.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
v2: Handle non-associated state of existing interfaces.

 drivers/net/wireless/ath/ath9k/htc.h            |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   58 ++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   44 +++++++++++------
 3 files changed, 82 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index e9c51ca..753a245 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -243,6 +243,7 @@ struct ath9k_htc_target_stats {
 struct ath9k_htc_vif {
 	u8 index;
 	u16 seq_no;
+	bool beacon_configured;
 };
 
 struct ath9k_vif_iter_data {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 007b99f..8d1d879 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -123,8 +123,9 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	/* TSF out of range threshold fixed at 1 second */
 	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
 
-	ath_dbg(common, ATH_DBG_BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
-	ath_dbg(common, ATH_DBG_BEACON,
+	ath_dbg(common, ATH_DBG_CONFIG, "intval: %u tsf: %llu tsftu: %u\n",
+		intval, tsf, tsftu);
+	ath_dbg(common, ATH_DBG_CONFIG,
 		"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
 		bs.bs_bmissthreshold, bs.bs_sleepduration,
 		bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
@@ -309,12 +310,23 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 	}
 }
 
-void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
-			     struct ieee80211_vif *vif)
+static void ath9k_htc_beacon_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	bool *beacon_configured = (bool *)data;
+	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *) vif->drv_priv;
+
+	if (vif->type == NL80211_IFTYPE_STATION &&
+	    avp->beacon_configured)
+		*beacon_configured = true;
+}
+
+static bool ath9k_htc_check_beacon_config(struct ath9k_htc_priv *priv,
+					  struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	bool beacon_configured;
 
 	/*
 	 * Changing the beacon interval when multiple AP interfaces
@@ -327,7 +339,7 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 	    (cur_conf->beacon_interval != bss_conf->beacon_int)) {
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Changing beacon interval of multiple AP interfaces !\n");
-		return;
+		return false;
 	}
 
 	/*
@@ -338,9 +350,42 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 	    (vif->type != NL80211_IFTYPE_AP)) {
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"HW in AP mode, cannot set STA beacon parameters\n");
-		return;
+		return false;
+	}
+
+	/*
+	 * The beacon parameters are configured only for the first
+	 * station interface.
+	 */
+	if ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
+	    (priv->num_sta_vif > 1) &&
+	    (vif->type == NL80211_IFTYPE_STATION)) {
+		beacon_configured = false;
+		ieee80211_iterate_active_interfaces_atomic(priv->hw,
+							   ath9k_htc_beacon_iter,
+							   &beacon_configured);
+
+		if (beacon_configured) {
+			ath_dbg(common, ATH_DBG_CONFIG,
+				"Beacon already configured for a station interface\n");
+			return false;
+		}
 	}
 
+	return true;
+}
+
+void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
+			     struct ieee80211_vif *vif)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *) vif->drv_priv;
+
+	if (!ath9k_htc_check_beacon_config(priv, vif))
+		return;
+
 	cur_conf->beacon_interval = bss_conf->beacon_int;
 	if (cur_conf->beacon_interval == 0)
 		cur_conf->beacon_interval = 100;
@@ -352,6 +397,7 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		ath9k_htc_beacon_config_sta(priv, cur_conf);
+		avp->beacon_configured = true;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		ath9k_htc_beacon_config_adhoc(priv, cur_conf);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 7367d6c..ff1bb0f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1602,30 +1602,44 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	bool set_assoc;
 
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 
+	/*
+	 * Set the HW AID/BSSID only for the first station interface
+	 * or in IBSS mode.
+	 */
+	set_assoc = !!((priv->ah->opmode == NL80211_IFTYPE_ADHOC) ||
+		       ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
+			(priv->num_sta_vif == 1)));
+
+
 	if (changed & BSS_CHANGED_ASSOC) {
-		common->curaid = bss_conf->assoc ?
-				 bss_conf->aid : 0;
-		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
-			bss_conf->assoc);
+		if (set_assoc) {
+			ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
+				bss_conf->assoc);
 
-		if (bss_conf->assoc)
-			ath9k_htc_start_ani(priv);
-		else
-			ath9k_htc_stop_ani(priv);
+			common->curaid = bss_conf->assoc ?
+				bss_conf->aid : 0;
+
+			if (bss_conf->assoc)
+				ath9k_htc_start_ani(priv);
+			else
+				ath9k_htc_stop_ani(priv);
+		}
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
-		/* Set BSSID */
-		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-		ath9k_hw_write_associd(ah);
+		if (set_assoc) {
+			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+			ath9k_hw_write_associd(ah);
 
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"BSSID: %pM aid: 0x%x\n",
-			common->curbssid, common->curaid);
+			ath_dbg(common, ATH_DBG_CONFIG,
+				"BSSID: %pM aid: 0x%x\n",
+				common->curbssid, common->curaid);
+		}
 	}
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon) {
-- 
1.7.4.1

