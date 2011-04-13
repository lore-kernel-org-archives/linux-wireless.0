Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34681 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1DMFvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:51:03 -0400
Received: by gwaa18 with SMTP id a18so129024gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:51:02 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.14934.301856.408429@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:23:26 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 07/40] ath9k_htc: Configure the beacon queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Set operating parameters (cwmin, cwmax) for the beacon queue
in AP mode.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   77 ++++++++++++++---------
 1 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 2fad613..7aafd21 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -18,6 +18,50 @@
 
 #define FUDGE 2
 
+void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
+{
+	struct ath_hw *ah = priv->ah;
+	struct ath9k_tx_queue_info qi, qi_be;
+
+	memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
+	memset(&qi_be, 0, sizeof(struct ath9k_tx_queue_info));
+
+	ath9k_hw_get_txq_props(ah, priv->beaconq, &qi);
+
+	if (priv->ah->opmode == NL80211_IFTYPE_AP) {
+		qi.tqi_aifs = 1;
+		qi.tqi_cwmin = 0;
+		qi.tqi_cwmax = 0;
+	} else if (priv->ah->opmode == NL80211_IFTYPE_ADHOC) {
+		int qnum = priv->hwq_map[WME_AC_BE];
+
+		ath9k_hw_get_txq_props(ah, qnum, &qi_be);
+
+		qi.tqi_aifs = qi_be.tqi_aifs;
+
+		/*
+		 * For WIFI Beacon Distribution
+		 * Long slot time  : 2x cwmin
+		 * Short slot time : 4x cwmin
+		 */
+		if (ah->slottime == ATH9K_SLOT_TIME_20)
+			qi.tqi_cwmin = 2*qi_be.tqi_cwmin;
+		else
+			qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
+
+		qi.tqi_cwmax = qi_be.tqi_cwmax;
+
+	}
+
+	if (!ath9k_hw_set_txq_props(ah, priv->beaconq, &qi)) {
+		ath_err(ath9k_hw_common(ah),
+			"Unable to update beacon queue %u!\n", priv->beaconq);
+	} else {
+		ath9k_hw_resettxqueue(ah, priv->beaconq);
+	}
+}
+
+
 static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 					struct htc_beacon_config *bss_conf)
 {
@@ -176,6 +220,8 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 		"imask: 0x%x\n",
 		bss_conf->beacon_interval, nexttbtt, imask);
 
+	ath9k_htc_beaconq_config(priv);
+
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	ath9k_hw_beaconinit(priv->ah, TU_TO_USEC(nexttbtt), TU_TO_USEC(intval));
 	priv->cur_beacon_conf.bmiss_cnt = 0;
@@ -347,37 +393,6 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv)
 	ath9k_htc_send_beacon(priv, slot);
 }
 
-/* Currently, only for IBSS */
-void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
-{
-	struct ath_hw *ah = priv->ah;
-	struct ath9k_tx_queue_info qi, qi_be;
-	int qnum = priv->hwq_map[WME_AC_BE];
-
-	memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
-	memset(&qi_be, 0, sizeof(struct ath9k_tx_queue_info));
-
-	ath9k_hw_get_txq_props(ah, qnum, &qi_be);
-
-	qi.tqi_aifs = qi_be.tqi_aifs;
-	/* For WIFI Beacon Distribution
-	 * Long slot time  : 2x cwmin
-	 * Short slot time : 4x cwmin
-	 */
-	if (ah->slottime == ATH9K_SLOT_TIME_20)
-		qi.tqi_cwmin = 2*qi_be.tqi_cwmin;
-	else
-		qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
-	qi.tqi_cwmax = qi_be.tqi_cwmax;
-
-	if (!ath9k_hw_set_txq_props(ah, priv->beaconq, &qi)) {
-		ath_err(ath9k_hw_common(ah),
-			"Unable to update beacon queue %u!\n", qnum);
-	} else {
-		ath9k_hw_resettxqueue(ah, priv->beaconq);
-	}
-}
-
 void ath9k_htc_assign_bslot(struct ath9k_htc_priv *priv,
 			    struct ieee80211_vif *vif)
 {
-- 
1.7.4.4

