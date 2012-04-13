Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61694 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2DMLNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 07:13:46 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/3] ath9k: reset noiseimmunity level to default
Date: Fri, 13 Apr 2012 16:44:20 +0530
Message-ID: <1334315662-5017-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120413_131410_324722_B403F5E5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the chip reset, the noise immunity levels are restored with
history values. If the immunity levels are lower than the defaults,
lets start with the optimal values.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 47a9fb4..b4c77f9 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -274,7 +274,9 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel)
 		aniState->rssiThrLow, aniState->rssiThrHigh);
 
 	if (aniState->update_ani)
-		aniState->ofdmNoiseImmunityLevel = immunityLevel;
+		aniState->ofdmNoiseImmunityLevel =
+			(immunityLevel > ATH9K_ANI_OFDM_DEF_LEVEL) ?
+			immunityLevel : ATH9K_ANI_OFDM_DEF_LEVEL;
 
 	entry_ofdm = &ofdm_level_table[aniState->ofdmNoiseImmunityLevel];
 	entry_cck = &cck_level_table[aniState->cckNoiseImmunityLevel];
@@ -340,7 +342,9 @@ static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel)
 		immunityLevel = ATH9K_ANI_CCK_MAX_LEVEL_LOW_RSSI;
 
 	if (aniState->update_ani)
-		aniState->cckNoiseImmunityLevel = immunityLevel;
+		aniState->cckNoiseImmunityLevel =
+			(immunityLevel > ATH9K_ANI_CCK_DEF_LEVEL) ?
+			immunityLevel : ATH9K_ANI_CCK_DEF_LEVEL;
 
 	entry_ofdm = &ofdm_level_table[aniState->ofdmNoiseImmunityLevel];
 	entry_cck = &cck_level_table[aniState->cckNoiseImmunityLevel];
-- 
1.7.10

