Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46399 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3FCDw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 23:52:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] ath9k: Do not maintain ANI state per-channel
Date: Mon,  3 Jun 2013 09:19:29 +0530
Message-Id: <1370231369-16241-7-git-send-email-sujith@msujith.org> (sfid-20130603_055230_861153_F8EB090A)
In-Reply-To: <1370231369-16241-1-git-send-email-sujith@msujith.org>
References: <1370231369-16241-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ANI state can be maintained globally instead of per-channel.
This reduces memory usage and since default values are used
during a scan run, per-channel state is not required.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c        | 40 ++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |  4 +--
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  4 +--
 drivers/net/wireless/ath/ath9k/hw.h         |  2 +-
 4 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index ba0bad6..e91725b 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -121,7 +121,7 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 	if (!ah->curchan)
 		return;
 
-	aniState = &ah->curchan->ani;
+	aniState = &ah->ani;
 	aniState->listenTime = 0;
 
 	ENABLE_REGWRITE_BUFFER(ah);
@@ -143,7 +143,7 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 				  bool scan)
 {
-	struct ar5416AniState *aniState = &ah->curchan->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 	struct ath_common *common = ath9k_hw_common(ah);
 	const struct ani_ofdm_level_entry *entry_ofdm;
 	const struct ani_cck_level_entry *entry_cck;
@@ -198,7 +198,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 	if (!ah->curchan)
 		return;
 
-	aniState = &ah->curchan->ani;
+	aniState = &ah->ani;
 
 	if (aniState->ofdmNoiseImmunityLevel < ATH9K_ANI_OFDM_MAX_LEVEL)
 		ath9k_hw_set_ofdm_nil(ah, aniState->ofdmNoiseImmunityLevel + 1, false);
@@ -210,7 +210,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel,
 				 bool scan)
 {
-	struct ar5416AniState *aniState = &ah->curchan->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 	struct ath_common *common = ath9k_hw_common(ah);
 	const struct ani_ofdm_level_entry *entry_ofdm;
 	const struct ani_cck_level_entry *entry_cck;
@@ -254,7 +254,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
 	if (!ah->curchan)
 		return;
 
-	aniState = &ah->curchan->ani;
+	aniState = &ah->ani;
 
 	if (aniState->cckNoiseImmunityLevel < ATH9K_ANI_CCK_MAX_LEVEL)
 		ath9k_hw_set_cck_nil(ah, aniState->cckNoiseImmunityLevel + 1,
@@ -269,7 +269,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 
-	aniState = &ah->curchan->ani;
+	aniState = &ah->ani;
 
 	/* lower OFDM noise immunity */
 	if (aniState->ofdmNoiseImmunityLevel > 0 &&
@@ -292,7 +292,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hw *ah)
  */
 void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 {
-	struct ar5416AniState *aniState = &ah->curchan->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 	struct ath9k_channel *chan = ah->curchan;
 	struct ath_common *common = ath9k_hw_common(ah);
 	int ofdm_nil, cck_nil;
@@ -380,7 +380,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 static bool ath9k_hw_ani_read_counters(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ar5416AniState *aniState = &ah->curchan->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 	u32 phyCnt1, phyCnt2;
 	int32_t listenTime;
 
@@ -418,7 +418,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (!ah->curchan)
 		return;
 
-	aniState = &ah->curchan->ani;
+	aniState = &ah->ani;
 	if (!ath9k_hw_ani_read_counters(ah))
 		return;
 
@@ -490,28 +490,22 @@ EXPORT_SYMBOL(ath9k_hw_disable_mib_counters);
 void ath9k_hw_ani_init(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	int i;
+	struct ar5416AniState *ani = &ah->ani;
 
 	ath_dbg(common, ANI, "Initialize ANI\n");
 
 	ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH;
 	ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW;
-
 	ah->config.cck_trig_high = ATH9K_ANI_CCK_TRIG_HIGH;
 	ah->config.cck_trig_low = ATH9K_ANI_CCK_TRIG_LOW;
 
-	for (i = 0; i < ARRAY_SIZE(ah->channels); i++) {
-		struct ath9k_channel *chan = &ah->channels[i];
-		struct ar5416AniState *ani = &chan->ani;
-
-		ani->spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
-		ani->firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
-		ani->mrcCCK = AR_SREV_9300_20_OR_LATER(ah) ? true : false;
-		ani->ofdmsTurn = true;
-		ani->ofdmWeakSigDetect = true;
-		ani->cckNoiseImmunityLevel = ATH9K_ANI_CCK_DEF_LEVEL;
-		ani->ofdmNoiseImmunityLevel = ATH9K_ANI_OFDM_DEF_LEVEL;
-	}
+	ani->spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
+	ani->firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
+	ani->mrcCCK = AR_SREV_9300_20_OR_LATER(ah) ? true : false;
+	ani->ofdmsTurn = true;
+	ani->ofdmWeakSigDetect = true;
+	ani->cckNoiseImmunityLevel = ATH9K_ANI_CCK_DEF_LEVEL;
+	ani->ofdmNoiseImmunityLevel = ATH9K_ANI_OFDM_DEF_LEVEL;
 
 	/*
 	 * since we expect some ongoing maintenance on the tables, let's sanity
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 92b79a2..d1acfe9 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -931,7 +931,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
-	struct ar5416AniState *aniState = &chan->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 	s32 value, value2;
 
 	switch (cmd & ah->ani_function) {
@@ -1207,7 +1207,7 @@ static void ar5008_hw_ani_cache_ini_regs(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
-	struct ar5416AniState *aniState = &chan->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 	struct ath9k_ani_default *iniDef;
 	u32 val;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 53562a4..83e0385 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -905,7 +905,7 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
-	struct ar5416AniState *aniState = &chan->ani;
+	struct ar5416AniState *aniState = &ah->ani;
 	s32 value, value2;
 
 	switch (cmd & ah->ani_function) {
@@ -1173,7 +1173,7 @@ static void ar9003_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	struct ath9k_ani_default *iniDef;
 	u32 val;
 
-	aniState = &ah->curchan->ani;
+	aniState = &ah->ani;
 	iniDef = &aniState->iniDef;
 
 	ath_dbg(common, ANI, "ver %d.%d opmode %u chan %d Mhz/0x%x\n",
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 301b19e..7d259b7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -420,7 +420,6 @@ struct ath9k_hw_cal_data {
 
 struct ath9k_channel {
 	struct ieee80211_channel *chan;
-	struct ar5416AniState ani;
 	u16 channel;
 	u32 channelFlags;
 	u32 chanmode;
@@ -854,6 +853,7 @@ struct ath_hw {
 	u32 aniperiod;
 	enum ath9k_ani_cmd ani_function;
 	u32 ani_skip_count;
+	struct ar5416AniState ani;
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	struct ath_btcoex_hw btcoex_hw;
-- 
1.8.3

