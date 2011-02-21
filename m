Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39473 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:20:22 -0500
Received: by mail-yi0-f46.google.com with SMTP id 18so2360641yib.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:20:22 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52184.289748.148298@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:50:08 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 19/23] ath9k_htc: Handle BSSID/AID for multiple interfaces
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
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   17 ++++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   44 +++++++++++++++--------
 2 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 007b99f..5238091 100644
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
@@ -341,6 +342,18 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 		return;
 	}
 
+	/*
+	 * The beacon paramters are configured only for the first
+	 * station interface.
+	 */
+	if ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
+	    (priv->num_sta_vif > 1) &&
+	    (vif->type == NL80211_IFTYPE_STATION)) {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Beacon already configured for a station interface\n");
+		return;
+	}
+
 	cur_conf->beacon_interval = bss_conf->beacon_int;
 	if (cur_conf->beacon_interval == 0)
 		cur_conf->beacon_interval = 100;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 949af24..6ec9cb6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1603,30 +1603,44 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
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

