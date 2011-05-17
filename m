Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57703 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1EQHNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 03:13:34 -0400
Received: by mail-pw0-f46.google.com with SMTP id 15so151989pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 00:13:34 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19922.8131.305609.638965@gargle.gargle.HOWL> (sfid-20110517_091338_285192_E3488F3A)
Date: Tue, 17 May 2011 12:42:03 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 5/8] ath9k_htc: Fix BSSID calculation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The BSSID/AID has to be set for the first associated station interface.
Subsequent interfaces may move out of assoc/disassoc status, in which
case, the BSSID has to be re-calculated from the available interfaces.
Also, ANI should be enabled or disabled based on the current opmode.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   66 ++++++++++++++++---------
 2 files changed, 44 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 29dfdf8..fa5bb39 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -438,6 +438,7 @@ struct ath9k_htc_priv {
 	u8 vif_sta_pos[ATH9K_HTC_MAX_VIF];
 	u8 num_ibss_vif;
 	u8 num_sta_vif;
+	u8 num_sta_assoc_vif;
 	u8 num_ap_vif;
 
 	u16 op_flags;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 8a82e82..6eedabb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1436,6 +1436,37 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static void ath9k_htc_set_bssid(struct ath9k_htc_priv *priv)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+
+	ath9k_hw_write_associd(priv->ah);
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"BSSID: %pM aid: 0x%x\n",
+		common->curbssid, common->curaid);
+}
+
+static void ath9k_htc_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	if ((vif->type == NL80211_IFTYPE_STATION) && bss_conf->assoc) {
+		common->curaid = bss_conf->aid;
+		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+	}
+}
+
+static void ath9k_htc_choose_set_bssid(struct ath9k_htc_priv *priv)
+{
+	if (priv->num_sta_assoc_vif == 1) {
+		ieee80211_iterate_active_interfaces_atomic(priv->hw,
+							   ath9k_htc_bss_iter, priv);
+		ath9k_htc_set_bssid(priv);
+	}
+}
+
 static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *bss_conf,
@@ -1444,43 +1475,32 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	bool set_assoc;
 
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 
-	/*
-	 * Set the HW AID/BSSID only for the first station interface
-	 * or in IBSS mode.
-	 */
-	set_assoc = !!((priv->ah->opmode == NL80211_IFTYPE_ADHOC) ||
-		       ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
-			(priv->num_sta_vif == 1)));
-
-
 	if (changed & BSS_CHANGED_ASSOC) {
-		if (set_assoc) {
-			ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
-				bss_conf->assoc);
+		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
+			bss_conf->assoc);
 
-			common->curaid = bss_conf->assoc ?
-				bss_conf->aid : 0;
+		bss_conf->assoc ?
+			priv->num_sta_assoc_vif++ : priv->num_sta_assoc_vif--;
 
-			if (bss_conf->assoc)
+		if (priv->ah->opmode == NL80211_IFTYPE_STATION) {
+			if (bss_conf->assoc && (priv->num_sta_assoc_vif == 1))
 				ath9k_htc_start_ani(priv);
-			else
+			else if (priv->num_sta_assoc_vif == 0)
 				ath9k_htc_stop_ani(priv);
 		}
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
-		if (set_assoc) {
+		if (priv->ah->opmode == NL80211_IFTYPE_ADHOC) {
+			common->curaid = bss_conf->aid;
 			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-			ath9k_hw_write_associd(ah);
-
-			ath_dbg(common, ATH_DBG_CONFIG,
-				"BSSID: %pM aid: 0x%x\n",
-				common->curbssid, common->curaid);
+			ath9k_htc_set_bssid(priv);
+		} else if (priv->ah->opmode == NL80211_IFTYPE_STATION) {
+			ath9k_htc_choose_set_bssid(priv);
 		}
 	}
 
-- 
1.7.5.1

