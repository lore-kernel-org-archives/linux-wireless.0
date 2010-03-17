Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 09/20] ath9k_hw: Use a helper for setting phy error masks
Date: Wed, 17 Mar 2010 18:28:02 -0400
Message-Id: <1268864893-11428-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The phy error masks are used consistently on ani.c so
define a common helper for this. We will later use this to
further abstract direct hardware reads/writes depending on
the chipset. While at it, add some sort of explanation as
to what these masks are for.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 2a0cd64..08deda3 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -231,6 +231,18 @@ static void ath9k_hw_update_mibstats(struct ath_hw *ah,
 	stats->beacons += REG_READ(ah, AR_BEACON_CNT);
 }
 
+/*
+ * These masks are used by the hardware to know which
+ * type of phy errors to include on their error counts.
+ * We use one counter for OFDM phy timing errors and the
+ * other for CCK phy timing errors only.
+ */
+static void ath9k_hw_update_phy_err_masks(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
+	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+}
+
 static void ath9k_ani_restart(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
@@ -264,8 +276,7 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 		  aniState->cckPhyErrBase);
 	REG_WRITE(ah, AR_PHY_ERR_1, aniState->ofdmPhyErrBase);
 	REG_WRITE(ah, AR_PHY_ERR_2, aniState->cckPhyErrBase);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+	ath9k_hw_update_phy_err_masks(ah);
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
@@ -540,8 +551,7 @@ void ath9k_ani_reset(struct ath_hw *ah)
 	ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
 			     ~ATH9K_RX_FILTER_PHYERR);
 	ath9k_ani_restart(ah);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+	ath9k_hw_update_phy_err_masks(ah);
 }
 
 void ath9k_hw_ani_monitor(struct ath_hw *ah,
@@ -644,8 +654,7 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 	REG_WRITE(ah, AR_MIBC,
 		  ~(AR_MIBC_COW | AR_MIBC_FMC | AR_MIBC_CMC | AR_MIBC_MCS)
 		  & 0x0f);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+	ath9k_hw_update_phy_err_masks(ah);
 }
 
 /* Freeze the MIB counters, get the stats and then clear them */
-- 
1.6.3.3

