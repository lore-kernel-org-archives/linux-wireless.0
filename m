Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11167 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1ISOpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 10:45:11 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Store noise immunity values across scanning
Date: Mon, 19 Sep 2011 20:15:48 +0530
Message-ID: <1316443548-22991-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110919_164516_401504_3B91C067)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CCK/OFDM noise immunilty values are always reset to defaults
during bgscan. This could affect the link quality and
performance when the STA is associated in a noisy channel.
So do not override the learned values across the scanning.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |   10 ++++++++--
 drivers/net/wireless/ath/ath9k/ani.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index d969a11..01240d6 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -273,7 +273,8 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel)
 		immunityLevel, aniState->noiseFloor,
 		aniState->rssiThrLow, aniState->rssiThrHigh);
 
-	aniState->ofdmNoiseImmunityLevel = immunityLevel;
+	if (aniState->update_ani)
+		aniState->ofdmNoiseImmunityLevel = immunityLevel;
 
 	entry_ofdm = &ofdm_level_table[aniState->ofdmNoiseImmunityLevel];
 	entry_cck = &cck_level_table[aniState->cckNoiseImmunityLevel];
@@ -346,7 +347,8 @@ static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel)
 	    immunityLevel > ATH9K_ANI_CCK_MAX_LEVEL_LOW_RSSI)
 		immunityLevel = ATH9K_ANI_CCK_MAX_LEVEL_LOW_RSSI;
 
-	aniState->cckNoiseImmunityLevel = immunityLevel;
+	if (aniState->update_ani)
+		aniState->cckNoiseImmunityLevel = immunityLevel;
 
 	entry_ofdm = &ofdm_level_table[aniState->ofdmNoiseImmunityLevel];
 	entry_cck = &cck_level_table[aniState->cckNoiseImmunityLevel];
@@ -593,6 +595,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 				aniState->ofdmNoiseImmunityLevel,
 				aniState->cckNoiseImmunityLevel);
 
+			aniState->update_ani = false;
 			ath9k_hw_set_ofdm_nil(ah, ATH9K_ANI_OFDM_DEF_LEVEL);
 			ath9k_hw_set_cck_nil(ah, ATH9K_ANI_CCK_DEF_LEVEL);
 		}
@@ -609,6 +612,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 			aniState->ofdmNoiseImmunityLevel,
 			aniState->cckNoiseImmunityLevel);
 
+			aniState->update_ani = true;
 			ath9k_hw_set_ofdm_nil(ah,
 					      aniState->ofdmNoiseImmunityLevel);
 			ath9k_hw_set_cck_nil(ah,
@@ -892,6 +896,8 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 		ani->ofdmWeakSigDetectOff =
 			!ATH9K_ANI_USE_OFDM_WEAK_SIG;
 		ani->cckNoiseImmunityLevel = ATH9K_ANI_CCK_DEF_LEVEL;
+		ani->ofdmNoiseImmunityLevel = ATH9K_ANI_OFDM_DEF_LEVEL;
+		ani->update_ani = false;
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index a547005..83029d6 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -122,6 +122,7 @@ struct ar5416AniState {
 	u8 firstepLevel;
 	u8 ofdmWeakSigDetectOff;
 	u8 cckWeakSigThreshold;
+	bool update_ani;
 	u32 listenTime;
 	int32_t rssiThrLow;
 	int32_t rssiThrHigh;
-- 
1.7.6.1

