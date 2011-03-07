Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35618 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab1CGCNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:13:08 -0500
Received: by mail-yi0-f46.google.com with SMTP id 27so1454482yia.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:13:08 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16171.486222.209974@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:42:59 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 04/34] ath9k_htc: Configure the beacon queue
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
index 52b6907..5f15896 100644
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
@@ -179,6 +223,8 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 		bss_conf->beacon_interval, nexttbtt, imask,
 		!!(intval & ATH9K_BEACON_RESET_TSF));
 
+	ath9k_htc_beaconq_config(priv);
+
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
 	priv->cur_beacon_conf.bmiss_cnt = 0;
@@ -351,37 +397,6 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv)
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
1.7.4.1

