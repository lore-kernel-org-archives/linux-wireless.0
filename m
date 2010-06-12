Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41842 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab0FLPWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 11:22:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 3/7] ath9k_hw: remove ATH9K_CAP_TKIP_MIC
Date: Sat, 12 Jun 2010 17:22:30 +0200
Message-Id: <1276356154-66545-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1276356154-66545-2-git-send-email-nbd@openwrt.org>
References: <1276356154-66545-1-git-send-email-nbd@openwrt.org>
 <1276356154-66545-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TKIP MIC support is always enabled anyway.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    8 --------
 drivers/net/wireless/ath/ath9k/hw.c           |   17 -----------------
 drivers/net/wireless/ath/ath9k/hw.h           |    1 -
 drivers/net/wireless/ath/ath9k/init.c         |    8 --------
 4 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a26bc56..03100e3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -571,14 +571,6 @@ static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
 		ath9k_hw_keyreset(priv->ah, (u16) i);
 
 	/*
-	 * Whether we should enable h/w TKIP MIC.
-	 * XXX: if we don't support WME TKIP MIC, then we wouldn't
-	 * report WMM capable, so it's always safe to turn on
-	 * TKIP MIC in this case.
-	 */
-	ath9k_hw_setcapability(priv->ah, ATH9K_CAP_TKIP_MIC, 0, 1, NULL);
-
-	/*
 	 * Check whether the separate key cache entries
 	 * are required to handle both tx+rx MIC keys.
 	 * With split mic keys the number of stations is limited
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d908f78..f1d9918 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2259,15 +2259,6 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result)
 {
 	switch (type) {
-	case ATH9K_CAP_TKIP_MIC:
-		switch (capability) {
-		case 0:
-			return true;
-		case 1:
-			return (ah->sta_id1_defaults &
-				AR_STA_ID1_CRPT_MIC_ENABLE) ? true :
-			false;
-		}
 	case ATH9K_CAP_TKIP_SPLIT:
 		return (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) ?
 			false : true;
@@ -2299,14 +2290,6 @@ bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 setting, int *status)
 {
 	switch (type) {
-	case ATH9K_CAP_TKIP_MIC:
-		if (setting)
-			ah->sta_id1_defaults |=
-				AR_STA_ID1_CRPT_MIC_ENABLE;
-		else
-			ah->sta_id1_defaults &=
-				~AR_STA_ID1_CRPT_MIC_ENABLE;
-		return true;
 	case ATH9K_CAP_MCAST_KEYSRCH:
 		if (setting)
 			ah->sta_id1_defaults |= AR_STA_ID1_MCAST_KSRCH;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7456850..5574daa 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -207,7 +207,6 @@ enum ath9k_hw_caps {
 };
 
 enum ath9k_capability_type {
-	ATH9K_CAP_TKIP_MIC,
 	ATH9K_CAP_TKIP_SPLIT,
 	ATH9K_CAP_MCAST_KEYSRCH,
 	ATH9K_CAP_DS
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 8bb866d..f66b357 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -380,14 +380,6 @@ static void ath9k_init_crypto(struct ath_softc *sc)
 		ath9k_hw_keyreset(sc->sc_ah, (u16) i);
 
 	/*
-	 * Whether we should enable h/w TKIP MIC.
-	 * XXX: if we don't support WME TKIP MIC, then we wouldn't
-	 * report WMM capable, so it's always safe to turn on
-	 * TKIP MIC in this case.
-	 */
-	ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_TKIP_MIC, 0, 1, NULL);
-
-	/*
 	 * Check whether the separate key cache entries
 	 * are required to handle both tx+rx MIC keys.
 	 * With split mic keys the number of stations is limited
-- 
1.6.4.2

