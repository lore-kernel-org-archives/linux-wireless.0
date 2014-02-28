Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45948 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbaB1SCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 13:02:38 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, c_manoha@qca.qualcomm.com
Subject: [PATCH 2/2] ath9k_hw: tweak noise immunity thresholds for older chipsets
Date: Fri, 28 Feb 2014 19:02:25 +0100
Message-Id: <1393610545-68025-2-git-send-email-nbd@openwrt.org> (sfid-20140228_190241_971423_01B24C9F)
In-Reply-To: <1393610545-68025-1-git-send-email-nbd@openwrt.org>
References: <1393610545-68025-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Older chipsets are more sensitive to high PHY error counts, and the
current noise immunity thresholds were based on tests run at QCA with
newer chipsets.

This patch brings back the values from the old ANI implementation for
old chipsets, and it also disables weak signal detection on an earlier
noise immunity level, to improve overall radio stability on affected
devices.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 23 +++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/ani.h |  4 ++++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 3227ee0..2ce5079 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -185,10 +185,18 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 		 ah->opmode != NL80211_IFTYPE_STATION)
 		weak_sig = true;
 
+	/* Older chipsets are more sensitive to high PHY error counts */
+	else if (!AR_SREV_9300_20_OR_LATER(ah) &&
+		 aniState->ofdmNoiseImmunityLevel >= 8)
+		weak_sig = false;
+
 	if (aniState->ofdmWeakSigDetect != weak_sig)
 		ath9k_hw_ani_control(ah, ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
 				     weak_sig);
 
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		return;
+
 	if (aniState->ofdmNoiseImmunityLevel >= ATH9K_ANI_OFDM_DEF_LEVEL) {
 		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH;
 		ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW_ABOVE_INI;
@@ -485,10 +493,17 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 
 	ath_dbg(common, ANI, "Initialize ANI\n");
 
-	ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH;
-	ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW;
-	ah->config.cck_trig_high = ATH9K_ANI_CCK_TRIG_HIGH;
-	ah->config.cck_trig_low = ATH9K_ANI_CCK_TRIG_LOW;
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH;
+		ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW;
+		ah->config.cck_trig_high = ATH9K_ANI_CCK_TRIG_HIGH;
+		ah->config.cck_trig_low = ATH9K_ANI_CCK_TRIG_LOW;
+	} else {
+		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH_OLD;
+		ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW_OLD;
+		ah->config.cck_trig_high = ATH9K_ANI_CCK_TRIG_HIGH_OLD;
+		ah->config.cck_trig_low = ATH9K_ANI_CCK_TRIG_LOW_OLD;
+	}
 
 	ani->spurImmunityLevel = ATH9K_ANI_SPUR_IMMUNE_LVL;
 	ani->firstepLevel = ATH9K_ANI_FIRSTEP_LVL;
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 21e7b83..c40965b 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -22,12 +22,16 @@
 /* units are errors per second */
 #define ATH9K_ANI_OFDM_TRIG_HIGH           3500
 #define ATH9K_ANI_OFDM_TRIG_HIGH_BELOW_INI 1000
+#define ATH9K_ANI_OFDM_TRIG_HIGH_OLD       500
 
 #define ATH9K_ANI_OFDM_TRIG_LOW           400
 #define ATH9K_ANI_OFDM_TRIG_LOW_ABOVE_INI 900
+#define ATH9K_ANI_OFDM_TRIG_LOW_OLD       200
 
 #define ATH9K_ANI_CCK_TRIG_HIGH           600
+#define ATH9K_ANI_CCK_TRIG_HIGH_OLD       200
 #define ATH9K_ANI_CCK_TRIG_LOW            300
+#define ATH9K_ANI_CCK_TRIG_LOW_OLD        100
 
 #define ATH9K_ANI_SPUR_IMMUNE_LVL         3
 #define ATH9K_ANI_FIRSTEP_LVL             2
-- 
1.8.3.4 (Apple Git-47)

