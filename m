Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41846 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0FLPWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 11:22:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 2/7] ath9k_hw: remove ATH9K_CAP_TXPOW
Date: Sat, 12 Jun 2010 17:22:29 +0200
Message-Id: <1276356154-66545-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1276356154-66545-1-git-send-email-nbd@openwrt.org>
References: <1276356154-66545-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace calls that read this capability with accesses to ath9k_hw's
regulatory data.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 +---
 drivers/net/wireless/ath/ath9k/hw.c           |   16 ----------------
 drivers/net/wireless/ath/ath9k/hw.h           |    1 -
 drivers/net/wireless/ath/ath9k/main.c         |    4 +---
 4 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c4d022a..312ff1b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -27,13 +27,11 @@ static struct dentry *ath9k_debugfs_root;
 static void ath_update_txpow(struct ath9k_htc_priv *priv)
 {
 	struct ath_hw *ah = priv->ah;
-	u32 txpow;
 
 	if (priv->curtxpow != priv->txpowlimit) {
 		ath9k_hw_set_txpowerlimit(ah, priv->txpowlimit);
 		/* read back in case value is clamped */
-		ath9k_hw_getcapability(ah, ATH9K_CAP_TXPOW, 1, &txpow);
-		priv->curtxpow = txpow;
+		priv->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 94f1258..d908f78 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2258,7 +2258,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result)
 {
-	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	switch (type) {
 	case ATH9K_CAP_TKIP_MIC:
 		switch (capability) {
@@ -2286,21 +2285,6 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			}
 		}
 		return false;
-	case ATH9K_CAP_TXPOW:
-		switch (capability) {
-		case 0:
-			return 0;
-		case 1:
-			*result = regulatory->power_limit;
-			return 0;
-		case 2:
-			*result = regulatory->max_power_level;
-			return 0;
-		case 3:
-			*result = regulatory->tp_scale;
-			return 0;
-		}
-		return false;
 	case ATH9K_CAP_DS:
 		return (AR_SREV_9280_20_OR_LATER(ah) &&
 			(ah->eep_ops->get_eeprom(ah, EEP_RC_CHAIN_MASK) == 1))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index cc01dc8..7456850 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -209,7 +209,6 @@ enum ath9k_hw_caps {
 enum ath9k_capability_type {
 	ATH9K_CAP_TKIP_MIC,
 	ATH9K_CAP_TKIP_SPLIT,
-	ATH9K_CAP_TXPOW,
 	ATH9K_CAP_MCAST_KEYSRCH,
 	ATH9K_CAP_DS
 };
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7b2f4a7..69b2e3b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -51,13 +51,11 @@ static void ath_cache_conf_rate(struct ath_softc *sc,
 static void ath_update_txpow(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	u32 txpow;
 
 	if (sc->curtxpow != sc->config.txpowlimit) {
 		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit);
 		/* read back in case value is clamped */
-		ath9k_hw_getcapability(ah, ATH9K_CAP_TXPOW, 1, &txpow);
-		sc->curtxpow = txpow;
+		sc->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
 	}
 }
 
-- 
1.6.4.2

