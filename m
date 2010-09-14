Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56008 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab0INSWr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 14:22:47 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_hw: remove useless hw capability flags
Date: Tue, 14 Sep 2010 20:22:44 +0200
Message-Id: <1284488564-74988-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    3 +-
 drivers/net/wireless/ath/ath9k/hw.c           |   21 --------------
 drivers/net/wireless/ath/ath9k/hw.h           |   37 +++++++++----------------
 drivers/net/wireless/ath/ath9k/init.c         |    3 +-
 drivers/net/wireless/ath/ath9k/main.c         |   12 +-------
 drivers/net/wireless/ath/ath9k/recv.c         |    3 +-
 7 files changed, 19 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 695e2b0..717f2b8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -601,8 +601,7 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 	common->tx_chainmask = priv->ah->caps.tx_chainmask;
 	common->rx_chainmask = priv->ah->caps.rx_chainmask;
 
-	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
+	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 2a6e45a..c99600a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -415,8 +415,7 @@ static void ath9k_htc_opmode_init(struct ath9k_htc_priv *priv)
 	ath9k_hw_setrxfilter(ah, rfilt);
 
 	/* configure bssid mask */
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath_hw_setbssidmask(common);
+	ath_hw_setbssidmask(common);
 
 	/* configure operational mode */
 	ath9k_hw_setopmode(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index afadade..b585a8ea 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1574,12 +1574,6 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 		keyType = AR_KEYTABLE_TYPE_AES;
 		break;
 	case ATH9K_CIPHER_AES_CCM:
-		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
-			ath_print(common, ATH_DBG_ANY,
-				  "AES-CCM not supported by mac rev 0x%x\n",
-				  ah->hw_version.macRev);
-			return false;
-		}
 		keyType = AR_KEYTABLE_TYPE_CCM;
 		break;
 	case ATH9K_CIPHER_TKIP:
@@ -2143,24 +2137,11 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->low_5ghz_chan = 4920;
 	pCap->high_5ghz_chan = 6100;
 
-	pCap->hw_caps &= ~ATH9K_HW_CAP_CIPHER_CKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_TKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_AESCCM;
-
-	pCap->hw_caps &= ~ATH9K_HW_CAP_MIC_CKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_MIC_TKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_MIC_AESCCM;
-
 	if (ah->config.ht_enable)
 		pCap->hw_caps |= ATH9K_HW_CAP_HT;
 	else
 		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
 
-	pCap->hw_caps |= ATH9K_HW_CAP_GTT;
-	pCap->hw_caps |= ATH9K_HW_CAP_VEOL;
-	pCap->hw_caps |= ATH9K_HW_CAP_BSSIDMASK;
-	pCap->hw_caps &= ~ATH9K_HW_CAP_MCAST_KEYSEARCH;
-
 	if (capField & AR_EEPROM_EEPCAP_MAXQCU)
 		pCap->total_queues =
 			MS(capField, AR_EEPROM_EEPCAP_MAXQCU);
@@ -2173,8 +2154,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->keycache_size = AR_KEYTABLE_SIZE;
 
-	pCap->hw_caps |= ATH9K_HW_CAP_FASTCC;
-
 	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 		pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD >> 1;
 	else
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1724b17..a3c2ce2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -181,30 +181,19 @@ enum wireless_mode {
 };
 
 enum ath9k_hw_caps {
-	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(0),
-	ATH9K_HW_CAP_MIC_CKIP                   = BIT(1),
-	ATH9K_HW_CAP_MIC_TKIP                   = BIT(2),
-	ATH9K_HW_CAP_CIPHER_AESCCM              = BIT(3),
-	ATH9K_HW_CAP_CIPHER_CKIP                = BIT(4),
-	ATH9K_HW_CAP_CIPHER_TKIP                = BIT(5),
-	ATH9K_HW_CAP_VEOL                       = BIT(6),
-	ATH9K_HW_CAP_BSSIDMASK                  = BIT(7),
-	ATH9K_HW_CAP_MCAST_KEYSEARCH            = BIT(8),
-	ATH9K_HW_CAP_HT                         = BIT(9),
-	ATH9K_HW_CAP_GTT                        = BIT(10),
-	ATH9K_HW_CAP_FASTCC                     = BIT(11),
-	ATH9K_HW_CAP_RFSILENT                   = BIT(12),
-	ATH9K_HW_CAP_CST                        = BIT(13),
-	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(14),
-	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(15),
-	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(16),
-	ATH9K_HW_CAP_EDMA			= BIT(17),
-	ATH9K_HW_CAP_RAC_SUPPORTED		= BIT(18),
-	ATH9K_HW_CAP_LDPC			= BIT(19),
-	ATH9K_HW_CAP_FASTCLOCK			= BIT(20),
-	ATH9K_HW_CAP_SGI_20			= BIT(21),
-	ATH9K_HW_CAP_PAPRD			= BIT(22),
-	ATH9K_HW_CAP_ANT_DIV_COMB		= BIT(23),
+	ATH9K_HW_CAP_HT                         = BIT(0),
+	ATH9K_HW_CAP_RFSILENT                   = BIT(1),
+	ATH9K_HW_CAP_CST                        = BIT(2),
+	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(3),
+	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(4),
+	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(5),
+	ATH9K_HW_CAP_EDMA			= BIT(6),
+	ATH9K_HW_CAP_RAC_SUPPORTED		= BIT(7),
+	ATH9K_HW_CAP_LDPC			= BIT(8),
+	ATH9K_HW_CAP_FASTCLOCK			= BIT(9),
+	ATH9K_HW_CAP_SGI_20			= BIT(10),
+	ATH9K_HW_CAP_PAPRD			= BIT(11),
+	ATH9K_HW_CAP_ANT_DIV_COMB		= BIT(12),
 };
 
 struct ath9k_hw_capabilities {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e7c07b3..5c77a99 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -522,8 +522,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 	ath9k_hw_set_diversity(sc->sc_ah, true);
 	sc->rx.defant = ath9k_hw_getdefantenna(sc->sc_ah);
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
+	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d3f96e4..a2f7eb2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1156,8 +1156,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	else
 		ah->imask |= ATH9K_INT_RX;
 
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_GTT)
-		ah->imask |= ATH9K_INT_GTT;
+	ah->imask |= ATH9K_INT_GTT;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		ah->imask |= ATH9K_INT_CST;
@@ -1379,12 +1378,6 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 
-	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) &&
-	    sc->nvifs > 0) {
-		ret = -ENOBUFS;
-		goto out;
-	}
-
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		ic_opmode = NL80211_IFTYPE_STATION;
@@ -1414,8 +1407,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	sc->nvifs++;
 
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath9k_set_bssid_mask(hw, vif);
+	ath9k_set_bssid_mask(hw, vif);
 
 	if (sc->nvifs > 1)
 		goto out; /* skip global settings for secondary vif */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b32c8f0..6fb3b45 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -119,8 +119,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 	ath9k_hw_setrxfilter(ah, rfilt);
 
 	/* configure bssid mask */
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath_hw_setbssidmask(common);
+	ath_hw_setbssidmask(common);
 
 	/* configure operational mode */
 	ath9k_hw_setopmode(ah);
-- 
1.7.2.2

