Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41844 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab0FLPWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 11:22:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 5/7] ath9k_hw: remove ATH9K_CAP_MCAST_KEYSRCH
Date: Sat, 12 Jun 2010 17:22:32 +0200
Message-Id: <1276356154-66545-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1276356154-66545-4-git-send-email-nbd@openwrt.org>
References: <1276356154-66545-1-git-send-email-nbd@openwrt.org>
 <1276356154-66545-2-git-send-email-nbd@openwrt.org>
 <1276356154-66545-3-git-send-email-nbd@openwrt.org>
 <1276356154-66545-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver always sets this to enabled, but this can be simplified with
a small change to ah->sta_id1_defaults instead.
This change also removes the now-obsolete ath9k_hw_setcapability function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    5 ----
 drivers/net/wireless/ath/ath9k/hw.c           |   33 ++----------------------
 drivers/net/wireless/ath/ath9k/hw.h           |    3 --
 drivers/net/wireless/ath/ath9k/init.c         |    6 ----
 4 files changed, 3 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 5190a88..d339e5f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -569,11 +569,6 @@ static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
 	 */
 	for (i = 0; i < common->keymax; i++)
 		ath9k_hw_keyreset(priv->ah, (u16) i);
-
-	/* turn on mcast key search if possible */
-	if (!ath9k_hw_getcapability(priv->ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
-		(void)ath9k_hw_setcapability(priv->ah, ATH9K_CAP_MCAST_KEYSRCH,
-					     1, 1, NULL);
 }
 
 static void ath9k_init_channels_rates(struct ath9k_htc_priv *priv)
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a5203b1..9321931 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -425,7 +425,9 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 		ah->ah_flags = AH_USE_EEPROM;
 
 	ah->atim_window = 0;
-	ah->sta_id1_defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
+	ah->sta_id1_defaults =
+		AR_STA_ID1_CRPT_MIC_ENABLE |
+		AR_STA_ID1_MCAST_KSRCH;
 	ah->beacon_interval = 100;
 	ah->enable_32kHz_clock = DONT_USE_32KHZ;
 	ah->slottime = (u32) -1;
@@ -2259,20 +2261,6 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result)
 {
 	switch (type) {
-	case ATH9K_CAP_MCAST_KEYSRCH:
-		switch (capability) {
-		case 0:
-			return true;
-		case 1:
-			if (REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_ADHOC) {
-				return false;
-			} else {
-				return (ah->sta_id1_defaults &
-					AR_STA_ID1_MCAST_KSRCH) ? true :
-					false;
-			}
-		}
-		return false;
 	case ATH9K_CAP_DS:
 		return (AR_SREV_9280_20_OR_LATER(ah) &&
 			(ah->eep_ops->get_eeprom(ah, EEP_RC_CHAIN_MASK) == 1))
@@ -2283,21 +2271,6 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 }
 EXPORT_SYMBOL(ath9k_hw_getcapability);
 
-bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
-			    u32 capability, u32 setting, int *status)
-{
-	switch (type) {
-	case ATH9K_CAP_MCAST_KEYSRCH:
-		if (setting)
-			ah->sta_id1_defaults |= AR_STA_ID1_MCAST_KSRCH;
-		else
-			ah->sta_id1_defaults &= ~AR_STA_ID1_MCAST_KSRCH;
-		return true;
-	default:
-		return false;
-	}
-}
-EXPORT_SYMBOL(ath9k_hw_setcapability);
 
 /****************************/
 /* GPIO / RFKILL / Antennae */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 28fca9d..16b35cd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -207,7 +207,6 @@ enum ath9k_hw_caps {
 };
 
 enum ath9k_capability_type {
-	ATH9K_CAP_MCAST_KEYSRCH,
 	ATH9K_CAP_DS
 };
 
@@ -855,8 +854,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 int ath9k_hw_fill_cap_info(struct ath_hw *ah);
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result);
-bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
-			    u32 capability, u32 setting, int *status);
 u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan);
 
 /* Key Cache Management */
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4bdf8c8..514a401 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -387,12 +387,6 @@ static void ath9k_init_crypto(struct ath_softc *sc)
 	 */
 	if (!(sc->sc_ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA))
 		common->splitmic = 1;
-
-	/* turn on mcast key search if possible */
-	if (!ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
-		(void)ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_MCAST_KEYSRCH,
-					     1, 1, NULL);
-
 }
 
 static int ath9k_init_btcoex(struct ath_softc *sc)
-- 
1.6.4.2

