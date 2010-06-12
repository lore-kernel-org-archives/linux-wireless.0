Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41845 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab0FLPWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 11:22:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 1/7] ath9k_hw: remove ATH9K_CAP_CIPHER
Date: Sat, 12 Jun 2010 17:22:28 +0200
Message-Id: <1276356154-66545-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All of the ciphers that are tested for are always supported

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   24 ++++++++----------------
 drivers/net/wireless/ath/ath9k/hw.c           |   12 ------------
 drivers/net/wireless/ath/ath9k/hw.h           |    1 -
 drivers/net/wireless/ath/ath9k/init.c         |   24 ++++++++----------------
 4 files changed, 16 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 947de70..a26bc56 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -570,16 +570,13 @@ static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
 	for (i = 0; i < common->keymax; i++)
 		ath9k_hw_keyreset(priv->ah, (u16) i);
 
-	if (ath9k_hw_getcapability(priv->ah, ATH9K_CAP_CIPHER,
-				   ATH9K_CIPHER_TKIP, NULL)) {
-		/*
-		 * Whether we should enable h/w TKIP MIC.
-		 * XXX: if we don't support WME TKIP MIC, then we wouldn't
-		 * report WMM capable, so it's always safe to turn on
-		 * TKIP MIC in this case.
-		 */
-		ath9k_hw_setcapability(priv->ah, ATH9K_CAP_TKIP_MIC, 0, 1, NULL);
-	}
+	/*
+	 * Whether we should enable h/w TKIP MIC.
+	 * XXX: if we don't support WME TKIP MIC, then we wouldn't
+	 * report WMM capable, so it's always safe to turn on
+	 * TKIP MIC in this case.
+	 */
+	ath9k_hw_setcapability(priv->ah, ATH9K_CAP_TKIP_MIC, 0, 1, NULL);
 
 	/*
 	 * Check whether the separate key cache entries
@@ -587,12 +584,7 @@ static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
 	 * With split mic keys the number of stations is limited
 	 * to 27 otherwise 59.
 	 */
-	if (ath9k_hw_getcapability(priv->ah, ATH9K_CAP_CIPHER,
-				   ATH9K_CIPHER_TKIP, NULL)
-	    && ath9k_hw_getcapability(priv->ah, ATH9K_CAP_CIPHER,
-				      ATH9K_CIPHER_MIC, NULL)
-	    && ath9k_hw_getcapability(priv->ah, ATH9K_CAP_TKIP_SPLIT,
-				      0, NULL))
+	if (ath9k_hw_getcapability(priv->ah, ATH9K_CAP_TKIP_SPLIT, 0, NULL))
 		common->splitmic = 1;
 
 	/* turn on mcast key search if possible */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5a2e72a..94f1258 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2260,18 +2260,6 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	switch (type) {
-	case ATH9K_CAP_CIPHER:
-		switch (capability) {
-		case ATH9K_CIPHER_AES_CCM:
-		case ATH9K_CIPHER_AES_OCB:
-		case ATH9K_CIPHER_TKIP:
-		case ATH9K_CIPHER_WEP:
-		case ATH9K_CIPHER_MIC:
-		case ATH9K_CIPHER_CLR:
-			return true;
-		default:
-			return false;
-		}
 	case ATH9K_CAP_TKIP_MIC:
 		switch (capability) {
 		case 0:
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d60472b..cc01dc8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -207,7 +207,6 @@ enum ath9k_hw_caps {
 };
 
 enum ath9k_capability_type {
-	ATH9K_CAP_CIPHER = 0,
 	ATH9K_CAP_TKIP_MIC,
 	ATH9K_CAP_TKIP_SPLIT,
 	ATH9K_CAP_TXPOW,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e1fa268..8bb866d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -379,16 +379,13 @@ static void ath9k_init_crypto(struct ath_softc *sc)
 	for (i = 0; i < common->keymax; i++)
 		ath9k_hw_keyreset(sc->sc_ah, (u16) i);
 
-	if (ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_CIPHER,
-				   ATH9K_CIPHER_TKIP, NULL)) {
-		/*
-		 * Whether we should enable h/w TKIP MIC.
-		 * XXX: if we don't support WME TKIP MIC, then we wouldn't
-		 * report WMM capable, so it's always safe to turn on
-		 * TKIP MIC in this case.
-		 */
-		ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_TKIP_MIC, 0, 1, NULL);
-	}
+	/*
+	 * Whether we should enable h/w TKIP MIC.
+	 * XXX: if we don't support WME TKIP MIC, then we wouldn't
+	 * report WMM capable, so it's always safe to turn on
+	 * TKIP MIC in this case.
+	 */
+	ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_TKIP_MIC, 0, 1, NULL);
 
 	/*
 	 * Check whether the separate key cache entries
@@ -396,12 +393,7 @@ static void ath9k_init_crypto(struct ath_softc *sc)
 	 * With split mic keys the number of stations is limited
 	 * to 27 otherwise 59.
 	 */
-	if (ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_CIPHER,
-				   ATH9K_CIPHER_TKIP, NULL)
-	    && ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_CIPHER,
-				      ATH9K_CIPHER_MIC, NULL)
-	    && ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_TKIP_SPLIT,
-				      0, NULL))
+	if (ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_TKIP_SPLIT, 0, NULL))
 		common->splitmic = 1;
 
 	/* turn on mcast key search if possible */
-- 
1.6.4.2

