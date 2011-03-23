Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44613 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 08/10] ath9k_hw: remove pCap->keycache_size
Date: Wed, 23 Mar 2011 20:57:31 +0100
Message-Id: <1300910253-28189-8-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300910253-28189-7-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
 <1300910253-28189-2-git-send-email-nbd@openwrt.org>
 <1300910253-28189-3-git-send-email-nbd@openwrt.org>
 <1300910253-28189-4-git-send-email-nbd@openwrt.org>
 <1300910253-28189-5-git-send-email-nbd@openwrt.org>
 <1300910253-28189-6-git-send-email-nbd@openwrt.org>
 <1300910253-28189-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar to the number of tx queue, the number of keycache entries depends
on the chip and shouldn't be messed with based on EEPROM data.
Remove this field and stick to using AR_KEYTABLE_SIZE

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    8 +-------
 drivers/net/wireless/ath/ath9k/hw.c           |    6 ------
 drivers/net/wireless/ath/ath9k/hw.h           |    1 -
 drivers/net/wireless/ath/ath9k/init.c         |    8 +-------
 4 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index ca69e7c..8303b34 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -564,13 +564,7 @@ static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
 	int i = 0;
 
 	/* Get the hardware key cache size. */
-	common->keymax = priv->ah->caps.keycache_size;
-	if (common->keymax > ATH_KEYMAX) {
-		ath_dbg(common, ATH_DBG_ANY,
-			"Warning, using only %u entries in %u key cache\n",
-			ATH_KEYMAX, common->keymax);
-		common->keymax = ATH_KEYMAX;
-	}
+	common->keymax = AR_KEYTABLE_SIZE;
 
 	if (priv->ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA)
 		common->crypt_caps |= ATH_CRYPT_CAP_MIC_COMBINED;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index be22574..5c676da 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1880,12 +1880,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
 
-	if (capField & AR_EEPROM_EEPCAP_KC_ENTRIES)
-		pCap->keycache_size =
-			1 << MS(capField, AR_EEPROM_EEPCAP_KC_ENTRIES);
-	else
-		pCap->keycache_size = AR_KEYTABLE_SIZE;
-
 	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 		pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD >> 1;
 	else
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a255f9a..296e51b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -191,7 +191,6 @@ enum ath9k_hw_caps {
 
 struct ath9k_hw_capabilities {
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
-	u16 keycache_size;
 	u16 low_5ghz_chan, high_5ghz_chan;
 	u16 low_2ghz_chan, high_2ghz_chan;
 	u16 rts_aggr_limit;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9790636a..4dbd59e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -407,13 +407,7 @@ void ath9k_init_crypto(struct ath_softc *sc)
 	int i = 0;
 
 	/* Get the hardware key cache size. */
-	common->keymax = sc->sc_ah->caps.keycache_size;
-	if (common->keymax > ATH_KEYMAX) {
-		ath_dbg(common, ATH_DBG_ANY,
-			"Warning, using only %u entries in %u key cache\n",
-			ATH_KEYMAX, common->keymax);
-		common->keymax = ATH_KEYMAX;
-	}
+	common->keymax = AR_KEYTABLE_SIZE;
 
 	/*
 	 * Reset the key cache since some parts do not
-- 
1.7.3.2

