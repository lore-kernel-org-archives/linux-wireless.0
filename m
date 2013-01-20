Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39943 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3ATRwL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 12:52:11 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 7/8] ath9k_hw: reduce struct ar5416AniState size
Date: Sun, 20 Jan 2013 18:51:58 +0100
Message-Id: <1358704319-81749-7-git-send-email-nbd@openwrt.org> (sfid-20130120_185223_554102_D87ABB1C)
In-Reply-To: <1358704319-81749-6-git-send-email-nbd@openwrt.org>
References: <1358704319-81749-1-git-send-email-nbd@openwrt.org>
 <1358704319-81749-2-git-send-email-nbd@openwrt.org>
 <1358704319-81749-3-git-send-email-nbd@openwrt.org>
 <1358704319-81749-4-git-send-email-nbd@openwrt.org>
 <1358704319-81749-5-git-send-email-nbd@openwrt.org>
 <1358704319-81749-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is kept per-channel, so removing unnecessary (or constant) fields from
it can save quite a bit of memory.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 13 ++++++-------
 drivers/net/wireless/ath/ath9k/ani.h |  7 -------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 2978287..a9218a1 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -152,7 +152,8 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 	ath_dbg(common, ANI, "**** ofdmlevel %d=>%d, rssi=%d[lo=%d hi=%d]\n",
 		aniState->ofdmNoiseImmunityLevel,
 		immunityLevel, BEACON_RSSI(ah),
-		aniState->rssiThrLow, aniState->rssiThrHigh);
+		ATH9K_ANI_RSSI_THR_LOW,
+		ATH9K_ANI_RSSI_THR_HIGH);
 
 	if (!scan)
 		aniState->ofdmNoiseImmunityLevel = immunityLevel;
@@ -173,7 +174,7 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 
 	weak_sig = entry_ofdm->ofdm_weak_signal_on;
 	if (ah->opmode == NL80211_IFTYPE_STATION &&
-	    BEACON_RSSI(ah) <= aniState->rssiThrHigh)
+	    BEACON_RSSI(ah) <= ATH9K_ANI_RSSI_THR_HIGH)
 		weak_sig = true;
 
 	if (aniState->ofdmWeakSigDetect != weak_sig)
@@ -216,11 +217,11 @@ static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel,
 
 	ath_dbg(common, ANI, "**** ccklevel %d=>%d, rssi=%d[lo=%d hi=%d]\n",
 		aniState->cckNoiseImmunityLevel, immunityLevel,
-		BEACON_RSSI(ah), aniState->rssiThrLow,
-		aniState->rssiThrHigh);
+		BEACON_RSSI(ah), ATH9K_ANI_RSSI_THR_LOW,
+		ATH9K_ANI_RSSI_THR_HIGH);
 
 	if (ah->opmode == NL80211_IFTYPE_STATION &&
-	    BEACON_RSSI(ah) <= aniState->rssiThrLow &&
+	    BEACON_RSSI(ah) <= ATH9K_ANI_RSSI_THR_LOW &&
 	    immunityLevel > ATH9K_ANI_CCK_MAX_LEVEL_LOW_RSSI)
 		immunityLevel = ATH9K_ANI_CCK_MAX_LEVEL_LOW_RSSI;
 
@@ -514,8 +515,6 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 
 		ani->ofdmsTurn = true;
 
-		ani->rssiThrHigh = ATH9K_ANI_RSSI_THR_HIGH;
-		ani->rssiThrLow = ATH9K_ANI_RSSI_THR_LOW;
 		ani->ofdmWeakSigDetect = ATH9K_ANI_USE_OFDM_WEAK_SIG;
 		ani->cckNoiseImmunityLevel = ATH9K_ANI_CCK_DEF_LEVEL;
 		ani->ofdmNoiseImmunityLevel = ATH9K_ANI_OFDM_DEF_LEVEL;
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 385bdba..dddb136 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -104,7 +104,6 @@ struct ath9k_ani_default {
 };
 
 struct ar5416AniState {
-	struct ath9k_channel *c;
 	u8 noiseImmunityLevel;
 	u8 ofdmNoiseImmunityLevel;
 	u8 cckNoiseImmunityLevel;
@@ -113,15 +112,9 @@ struct ar5416AniState {
 	u8 spurImmunityLevel;
 	u8 firstepLevel;
 	u8 ofdmWeakSigDetect;
-	u8 cckWeakSigThreshold;
 	u32 listenTime;
-	int32_t rssiThrLow;
-	int32_t rssiThrHigh;
 	u32 ofdmPhyErrCount;
 	u32 cckPhyErrCount;
-	int16_t pktRssi[2];
-	int16_t ofdmErrRssi[2];
-	int16_t cckErrRssi[2];
 	struct ath9k_ani_default iniDef;
 };
 
-- 
1.8.0.2

