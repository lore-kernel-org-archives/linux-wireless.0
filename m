Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26954 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYKRDgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:36:54 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:36:54 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14248.689244.711685@gargle.gargle.HOWL> (sfid-20081118_043656_287494_7FB9DA25)
Date: Tue, 18 Nov 2008 09:04:00 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 03/18] ath9k: Remove ath_setup_rates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup legacy rates in ath_rate_init() itself.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   36 ++++++++++--------------------------
 1 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 09d622a..798dff6 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1755,26 +1755,6 @@ static int ath_rate_newassoc(struct ath_softc *sc,
 	return 0;
 }
 
-static void ath_setup_rates(struct ath_softc *sc,
-			    struct ieee80211_supported_band *sband,
-			    struct ieee80211_sta *sta,
-			    struct ath_rate_node *rc_priv)
-
-{
-	int i, j = 0;
-
-	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sta->supp_rates[sband->band] & BIT(i)) {
-			rc_priv->neg_rates.rs_rates[j]
-				= (sband->bitrates[i].bitrate * 2) / 10;
-			j++;
-		}
-	}
-	rc_priv->neg_rates.rs_nrates = j;
-}
-
 void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv)
 {
 	struct ath_softc *sc = hw->priv;
@@ -1895,11 +1875,17 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	struct ath_rate_node *ath_rc_priv = priv_sta;
 	int i, j = 0;
 
-	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (sta->supp_rates[sband->band] & BIT(i)) {
+			ath_rc_priv->neg_rates.rs_rates[j]
+				= (sband->bitrates[i].bitrate * 2) / 10;
+			j++;
+		}
+	}
+	ath_rc_priv->neg_rates.rs_nrates = j;
 
-	ath_setup_rates(sc, sband, sta, ath_rc_priv);
 	if (sta->ht_cap.ht_supported) {
-		for (i = 0; i < 77; i++) {
+		for (i = 0, j = 0; i < 77; i++) {
 			if (sta->ht_cap.mcs.rx_mask[i/8] & (1<<(i%8)))
 				ath_rc_priv->neg_ht_rates.rs_rates[j++] = i;
 			if (j == ATH_RATE_MAX)
@@ -1907,14 +1893,12 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		}
 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
 	}
+
 	ath_rc_node_update(sc->hw, priv_sta);
 }
 
 static void *ath_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
-	struct ath_softc *sc = hw->priv;
-
-	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 	return hw->priv;
 }
 
-- 
1.6.0.3

