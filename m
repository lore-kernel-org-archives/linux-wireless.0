Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43985 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3FFG3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 02:29:50 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ath9k: Fix OFDM weak signal detection for AP mode
Date: Thu,  6 Jun 2013 11:57:00 +0530
Message-Id: <1370500021-18722-1-git-send-email-sujith@msujith.org> (sfid-20130606_082954_082760_EA455D71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit "ath9k_hw: improve ANI processing and rx desensitizing parameters"
changed the OFDM weak signal detection logic to disable it
for AP mode, which is not allowed. Fix this and enable it always
for AP mode.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index e91725b..3ec4c53 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -177,10 +177,15 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 	    BEACON_RSSI(ah) <= ATH9K_ANI_RSSI_THR_HIGH)
 		weak_sig = true;
 
-	if (aniState->ofdmWeakSigDetect != weak_sig)
-			ath9k_hw_ani_control(ah,
-				ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-				entry_ofdm->ofdm_weak_signal_on);
+	/*
+	 * OFDM Weak signal detection is always enabled for AP mode.
+	 */
+	if (ah->opmode != NL80211_IFTYPE_AP &&
+	    aniState->ofdmWeakSigDetect != weak_sig) {
+		ath9k_hw_ani_control(ah,
+				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
+				     entry_ofdm->ofdm_weak_signal_on);
+	}
 
 	if (aniState->ofdmNoiseImmunityLevel >= ATH9K_ANI_OFDM_DEF_LEVEL) {
 		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH;
-- 
1.8.3

