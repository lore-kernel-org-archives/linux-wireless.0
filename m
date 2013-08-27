Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53909 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3H0GIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 02:08:16 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Remove unused ANI commands
Date: Tue, 27 Aug 2013 11:34:26 +0530
Message-Id: <1377583466-15790-1-git-send-email-sujith@msujith.org> (sfid-20130827_080820_064209_252FF00A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c        |  3 ---
 drivers/net/wireless/ath/ath9k/ani.h        | 13 ++++---------
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |  2 --
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  2 --
 drivers/net/wireless/ath/ath9k/hw.c         |  2 --
 5 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 4994bea..be466b0 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -319,9 +319,6 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 			ah->ani_function = 0;
 	}
 
-	/* always allow mode (on/off) to be controlled */
-	ah->ani_function |= ATH9K_ANI_MODE;
-
 	ofdm_nil = max_t(int, ATH9K_ANI_OFDM_DEF_LEVEL,
 			 aniState->ofdmNoiseImmunityLevel);
 	cck_nil = max_t(int, ATH9K_ANI_CCK_DEF_LEVEL,
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index b54a3fb..21e7b83 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -48,15 +48,10 @@
 /* values here are relative to the INI */
 
 enum ath9k_ani_cmd {
-	ATH9K_ANI_PRESENT = 0x1,
-	ATH9K_ANI_NOISE_IMMUNITY_LEVEL = 0x2,
-	ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION = 0x4,
-	ATH9K_ANI_CCK_WEAK_SIGNAL_THR = 0x8,
-	ATH9K_ANI_FIRSTEP_LEVEL = 0x10,
-	ATH9K_ANI_SPUR_IMMUNITY_LEVEL = 0x20,
-	ATH9K_ANI_MODE = 0x40,
-	ATH9K_ANI_PHYERR_RESET = 0x80,
-	ATH9K_ANI_MRC_CCK = 0x100,
+	ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION = 0x1,
+	ATH9K_ANI_FIRSTEP_LEVEL = 0x2,
+	ATH9K_ANI_SPUR_IMMUNITY_LEVEL = 0x4,
+	ATH9K_ANI_MRC_CCK = 0x8,
 	ATH9K_ANI_ALL = 0xfff
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 1576d58..0865647 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1160,8 +1160,6 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 		 */
 		WARN_ON(1);
 		break;
-	case ATH9K_ANI_PRESENT:
-		break;
 	default:
 		ath_dbg(common, ANI, "invalid cmd %u\n", cmd);
 		return false;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 46b910a..e897648 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1193,8 +1193,6 @@ skip_ws_det:
 		}
 	break;
 	}
-	case ATH9K_ANI_PRESENT:
-		break;
 	default:
 		ath_dbg(common, ANI, "invalid cmd %u\n", cmd);
 		return false;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2670bf6..ec47c50 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -655,8 +655,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_cal_settings(ah);
 
 	ah->ani_function = ATH9K_ANI_ALL;
-	if (AR_SREV_9280_20_OR_LATER(ah) && !AR_SREV_9300_20_OR_LATER(ah))
-		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
 
-- 
1.8.4

