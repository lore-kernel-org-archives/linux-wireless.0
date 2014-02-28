Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45957 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbaB1SCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 13:02:40 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, c_manoha@qca.qualcomm.com
Subject: [PATCH 1/2] ath9k_hw: toggle weak signal detection in AP mode on older chipsets
Date: Fri, 28 Feb 2014 19:02:24 +0100
Message-Id: <1393610545-68025-1-git-send-email-nbd@openwrt.org> (sfid-20140228_190244_247967_E8F6EBC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 80b4205b "ath9k: Fix OFDM weak signal detection for AP mode"
prevented weak signal detection changes from taking effect in AP mode on
all chipsets, claiming it is "not allowed".

The main reason for not disabling weak signal detection in AP mode is
that typically beacon RSSI is used to track whether it is needed to
boost range, and this is unavailable in AP mode for obvious reasons.

The problem with not disabling weak signal detection is that older
chipsets are very sensitive to high PHY error counts. When faced with
heavy noise, this can lead to an excessive amount of "Failed to stop
TX DMA" errors in the field.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index d28923b..3227ee0 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -176,16 +176,18 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 	if (ah->opmode == NL80211_IFTYPE_STATION &&
 	    BEACON_RSSI(ah) <= ATH9K_ANI_RSSI_THR_HIGH)
 		weak_sig = true;
-
 	/*
-	 * OFDM Weak signal detection is always enabled for AP mode.
+	 * Newer chipsets are better at dealing with high PHY error counts -
+	 * keep weak signal detection enabled when no RSSI threshold is
+	 * available to determine if it is needed (mode != STA)
 	 */
-	if (ah->opmode != NL80211_IFTYPE_AP &&
-	    aniState->ofdmWeakSigDetect != weak_sig) {
-		ath9k_hw_ani_control(ah,
-				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-				     entry_ofdm->ofdm_weak_signal_on);
-	}
+	else if (AR_SREV_9300_20_OR_LATER(ah) &&
+		 ah->opmode != NL80211_IFTYPE_STATION)
+		weak_sig = true;
+
+	if (aniState->ofdmWeakSigDetect != weak_sig)
+		ath9k_hw_ani_control(ah, ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
+				     weak_sig);
 
 	if (aniState->ofdmNoiseImmunityLevel >= ATH9K_ANI_OFDM_DEF_LEVEL) {
 		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH;
-- 
1.8.3.4 (Apple Git-47)

