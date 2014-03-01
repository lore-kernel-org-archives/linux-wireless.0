Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49923 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbaCAUQi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:16:38 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 03/23] ath9k_htc: move beaconq to struct htc_beacon
Date: Sat,  1 Mar 2014 21:15:46 +0100
Message-Id: <1393704966-13985-4-git-send-email-linux@rempel-privat.de> (sfid-20140301_211643_226139_1B9CB88E)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h            | 2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 8 ++++----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ed41db5..69022b0 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -409,6 +409,7 @@ static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 struct htc_beacon {
 	struct ieee80211_vif *bslot[ATH9K_HTC_MAX_BCN_VIF];
 	u32 bmisscnt;
+	u32 beaconq;
 };
 
 struct ath_btcoex {
@@ -512,7 +513,6 @@ struct ath9k_htc_priv {
 	struct work_struct led_work;
 #endif
 
-	int beaconq;
 	int cabq;
 	int hwq_map[IEEE80211_NUM_ACS];
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 8929050..09ad141 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -26,7 +26,7 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 	memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
 	memset(&qi_be, 0, sizeof(struct ath9k_tx_queue_info));
 
-	ath9k_hw_get_txq_props(ah, priv->beaconq, &qi);
+	ath9k_hw_get_txq_props(ah, priv->beacon.beaconq, &qi);
 
 	if (priv->ah->opmode == NL80211_IFTYPE_AP ||
 	    priv->ah->opmode == NL80211_IFTYPE_MESH_POINT) {
@@ -54,11 +54,11 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 
 	}
 
-	if (!ath9k_hw_set_txq_props(ah, priv->beaconq, &qi)) {
+	if (!ath9k_hw_set_txq_props(ah, priv->beacon.beaconq, &qi)) {
 		ath_err(ath9k_hw_common(ah),
-			"Unable to update beacon queue %u!\n", priv->beaconq);
+			"Unable to update beacon queue %u!\n", priv->beacon.beaconq);
 	} else {
-		ath9k_hw_resettxqueue(ah, priv->beaconq);
+		ath9k_hw_resettxqueue(ah, priv->beacon.beaconq);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index b8a0220..6eb19b8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -405,8 +405,8 @@ static int ath9k_init_queues(struct ath9k_htc_priv *priv)
 	for (i = 0; i < ARRAY_SIZE(priv->hwq_map); i++)
 		priv->hwq_map[i] = -1;
 
-	priv->beaconq = ath9k_hw_beaconq_setup(priv->ah);
-	if (priv->beaconq == -1) {
+	priv->beacon.beaconq = ath9k_hw_beaconq_setup(priv->ah);
+	if (priv->beacon.beaconq == -1) {
 		ath_err(common, "Unable to setup BEACON xmit queue\n");
 		goto err;
 	}
-- 
1.9.0

