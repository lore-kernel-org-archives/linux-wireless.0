Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54136 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab3FCDwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 23:52:22 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] ath9k: Set ofdmWeakSigDetect directly
Date: Mon,  3 Jun 2013 09:19:27 +0530
Message-Id: <1370231369-16241-5-git-send-email-sujith@msujith.org> (sfid-20130603_055227_237218_EF8ACD16)
In-Reply-To: <1370231369-16241-1-git-send-email-sujith@msujith.org>
References: <1370231369-16241-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The macros ATH9K_ANI_USE_OFDM_WEAK_SIG can be removed.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c        | 6 +-----
 drivers/net/wireless/ath/ath9k/ani.h        | 6 +-----
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 +-
 4 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 734e72d..ba0bad6 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -505,14 +505,10 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 		struct ar5416AniState *ani = &chan->ani;
 
 		ani->spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
-
 		ani->firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
-
 		ani->mrcCCK = AR_SREV_9300_20_OR_LATER(ah) ? true : false;
-
 		ani->ofdmsTurn = true;
-
-		ani->ofdmWeakSigDetect = ATH9K_ANI_USE_OFDM_WEAK_SIG;
+		ani->ofdmWeakSigDetect = true;
 		ani->cckNoiseImmunityLevel = ATH9K_ANI_CCK_DEF_LEVEL;
 		ani->ofdmNoiseImmunityLevel = ATH9K_ANI_OFDM_DEF_LEVEL;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 07079f2..c585e05 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -34,11 +34,7 @@
 #define ATH9K_ANI_CCK_TRIG_LOW            300
 
 #define ATH9K_ANI_NOISE_IMMUNE_LVL        4
-#define ATH9K_ANI_USE_OFDM_WEAK_SIG       true
-#define ATH9K_ANI_CCK_WEAK_SIG_THR        false
-
 #define ATH9K_ANI_SPUR_IMMUNE_LVL         3
-
 #define ATH9K_ANI_FIRSTEP_LVL             2
 
 #define ATH9K_ANI_RSSI_THR_HIGH           40
@@ -107,7 +103,7 @@ struct ar5416AniState {
 	u8 mrcCCK;
 	u8 spurImmunityLevel;
 	u8 firstepLevel;
-	u8 ofdmWeakSigDetect;
+	bool ofdmWeakSigDetect;
 	u32 listenTime;
 	u32 ofdmPhyErrCount;
 	u32 cckPhyErrCount;
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 391da5a..92b79a2 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1251,7 +1251,7 @@ static void ar5008_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	/* these levels just got reset to defaults by the INI */
 	aniState->spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
 	aniState->firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
-	aniState->ofdmWeakSigDetect = ATH9K_ANI_USE_OFDM_WEAK_SIG;
+	aniState->ofdmWeakSigDetect = true;
 	aniState->mrcCCK = false; /* not available on pre AR9003 */
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index e1714d7..53562a4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1214,7 +1214,7 @@ static void ar9003_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	/* these levels just got reset to defaults by the INI */
 	aniState->spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
 	aniState->firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
-	aniState->ofdmWeakSigDetect = ATH9K_ANI_USE_OFDM_WEAK_SIG;
+	aniState->ofdmWeakSigDetect = true;
 	aniState->mrcCCK = true;
 }
 
-- 
1.8.3

