Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41841 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0FLPWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 11:22:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 4/7] ath9k_hw: remove ATH9K_CAP_TKIP_SPLIT
Date: Sat, 12 Jun 2010 17:22:31 +0200
Message-Id: <1276356154-66545-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1276356154-66545-3-git-send-email-nbd@openwrt.org>
References: <1276356154-66545-1-git-send-email-nbd@openwrt.org>
 <1276356154-66545-2-git-send-email-nbd@openwrt.org>
 <1276356154-66545-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is only used as a workaround for an issue in one specific hw revision.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    9 ---------
 drivers/net/wireless/ath/ath9k/hw.c           |    3 ---
 drivers/net/wireless/ath/ath9k/hw.h           |    1 -
 drivers/net/wireless/ath/ath9k/init.c         |    2 +-
 4 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 03100e3..5190a88 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -570,15 +570,6 @@ static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
 	for (i = 0; i < common->keymax; i++)
 		ath9k_hw_keyreset(priv->ah, (u16) i);
 
-	/*
-	 * Check whether the separate key cache entries
-	 * are required to handle both tx+rx MIC keys.
-	 * With split mic keys the number of stations is limited
-	 * to 27 otherwise 59.
-	 */
-	if (ath9k_hw_getcapability(priv->ah, ATH9K_CAP_TKIP_SPLIT, 0, NULL))
-		common->splitmic = 1;
-
 	/* turn on mcast key search if possible */
 	if (!ath9k_hw_getcapability(priv->ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
 		(void)ath9k_hw_setcapability(priv->ah, ATH9K_CAP_MCAST_KEYSRCH,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f1d9918..a5203b1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2259,9 +2259,6 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result)
 {
 	switch (type) {
-	case ATH9K_CAP_TKIP_SPLIT:
-		return (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) ?
-			false : true;
 	case ATH9K_CAP_MCAST_KEYSRCH:
 		switch (capability) {
 		case 0:
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5574daa..28fca9d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -207,7 +207,6 @@ enum ath9k_hw_caps {
 };
 
 enum ath9k_capability_type {
-	ATH9K_CAP_TKIP_SPLIT,
 	ATH9K_CAP_MCAST_KEYSRCH,
 	ATH9K_CAP_DS
 };
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f66b357..4bdf8c8 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -385,7 +385,7 @@ static void ath9k_init_crypto(struct ath_softc *sc)
 	 * With split mic keys the number of stations is limited
 	 * to 27 otherwise 59.
 	 */
-	if (ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_TKIP_SPLIT, 0, NULL))
+	if (!(sc->sc_ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA))
 		common->splitmic = 1;
 
 	/* turn on mcast key search if possible */
-- 
1.6.4.2

