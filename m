Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52596 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbcARBee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2016 20:34:34 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, nbd@openwrt.org,
	Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v3 2/5] ath9k: clean up ANI per-channel pointer checking
Date: Mon, 18 Jan 2016 09:33:47 +0800
Message-Id: <1453080830-7616-3-git-send-email-miaoqing@codeaurora.org> (sfid-20160118_023436_946974_EE80CC70)
In-Reply-To: <1453080830-7616-1-git-send-email-miaoqing@codeaurora.org>
References: <1453080830-7616-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

commit c24bd3620c50 ("ath9k: Do not maintain ANI state per-channel")
removed per-channel handling, the code to check 'curchan' also
should be removed as never used.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index aa82e13..815efe9 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -126,12 +126,8 @@ static void ath9k_hw_update_mibstats(struct ath_hw *ah,
 
 static void ath9k_ani_restart(struct ath_hw *ah)
 {
-	struct ar5416AniState *aniState;
-
-	if (!ah->curchan)
-		return;
+	struct ar5416AniState *aniState = &ah->ani;
 
-	aniState = &ah->ani;
 	aniState->listenTime = 0;
 
 	ENABLE_REGWRITE_BUFFER(ah);
@@ -221,12 +217,7 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 
 static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 {
-	struct ar5416AniState *aniState;
-
-	if (!ah->curchan)
-		return;
-
-	aniState = &ah->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 
 	if (aniState->ofdmNoiseImmunityLevel < ATH9K_ANI_OFDM_MAX_LEVEL)
 		ath9k_hw_set_ofdm_nil(ah, aniState->ofdmNoiseImmunityLevel + 1, false);
@@ -281,12 +272,7 @@ static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel,
 
 static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
 {
-	struct ar5416AniState *aniState;
-
-	if (!ah->curchan)
-		return;
-
-	aniState = &ah->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 
 	if (aniState->cckNoiseImmunityLevel < ATH9K_ANI_CCK_MAX_LEVEL)
 		ath9k_hw_set_cck_nil(ah, aniState->cckNoiseImmunityLevel + 1,
@@ -299,9 +285,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
  */
 static void ath9k_hw_ani_lower_immunity(struct ath_hw *ah)
 {
-	struct ar5416AniState *aniState;
-
-	aniState = &ah->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 
 	/* lower OFDM noise immunity */
 	if (aniState->ofdmNoiseImmunityLevel > 0 &&
@@ -329,7 +313,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int ofdm_nil, cck_nil;
 
-	if (!ah->curchan)
+	if (!chan)
 		return;
 
 	BUG_ON(aniState == NULL);
@@ -416,14 +400,10 @@ static bool ath9k_hw_ani_read_counters(struct ath_hw *ah)
 
 void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 {
-	struct ar5416AniState *aniState;
+	struct ar5416AniState *aniState = &ah->ani;
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 ofdmPhyErrRate, cckPhyErrRate;
 
-	if (!ah->curchan)
-		return;
-
-	aniState = &ah->ani;
 	if (!ath9k_hw_ani_read_counters(ah))
 		return;
 
-- 
1.9.1

