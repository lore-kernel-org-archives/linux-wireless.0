Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42328 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760367Ab0G3TCX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 15:02:23 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/4] ath9k_hw: clean up and fix initial noise floor calibration
Date: Fri, 30 Jul 2010 21:02:09 +0200
Message-Id: <1280516532-42721-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AR9003 the initial noise floor calibration is currently triggered
at the end of the reset without allowing the hardware to update the
baseband settings. This could potentially make scans in noisy
environments a bit more unreliable, so use the same calibration
sequence that is used on AR9002.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    5 ++---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    4 +++-
 drivers/net/wireless/ath/ath9k/calib.c        |   10 ++++++++--
 drivers/net/wireless/ath/ath9k/calib.h        |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    7 ++-----
 5 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index dabafb8..2387ad1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -721,7 +721,7 @@ static bool ar9002_hw_calibrate(struct ath_hw *ah,
 		 */
 		ath9k_hw_loadnf(ah, ah->curchan);
 
-		ath9k_hw_start_nfcal(ah);
+		ath9k_hw_start_nfcal(ah, false);
 	}
 
 	return iscaldone;
@@ -869,8 +869,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	ar9002_hw_pa_cal(ah, true);
 
 	/* Do NF Calibration after DC offset and other calibrations */
-	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-		  REG_READ(ah, AR_PHY_AGC_CONTROL) | AR_PHY_AGC_CONTROL_NF);
+	ath9k_hw_start_nfcal(ah, true);
 
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 5a06503..938365e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -156,7 +156,7 @@ static bool ar9003_hw_calibrate(struct ath_hw *ah,
 		ath9k_hw_loadnf(ah, ah->curchan);
 
 		/* start NF calibration, without updating BB NF register */
-		ath9k_hw_start_nfcal(ah);
+		ath9k_hw_start_nfcal(ah, false);
 	}
 
 	return iscaldone;
@@ -762,6 +762,8 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	/* Revert chainmasks to their original values before NF cal */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
 
+	ath9k_hw_start_nfcal(ah, true);
+
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 139289e..294016f 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -158,12 +158,18 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_reset_calvalid);
 
-void ath9k_hw_start_nfcal(struct ath_hw *ah)
+void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 {
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
 		    AR_PHY_AGC_CONTROL_ENABLE_NF);
-	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
+
+	if (update)
+		REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
 		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
+	else
+		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
+
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index cd60d09..bf44742 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -108,7 +108,7 @@ struct ath9k_pacal_info{
 };
 
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah);
-void ath9k_hw_start_nfcal(struct ath_hw *ah);
+void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update);
 void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan);
 int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		       struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8d291cc..257b623 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1256,7 +1256,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 		if (ath9k_hw_channel_change(ah, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
-			ath9k_hw_start_nfcal(ah);
+			ath9k_hw_start_nfcal(ah, true);
 			return 0;
 		}
 	}
@@ -1461,11 +1461,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (ah->btcoex_hw.enabled)
 		ath9k_hw_btcoex_enable(ah);
 
-	if (AR_SREV_9300_20_OR_LATER(ah)) {
-		ath9k_hw_loadnf(ah, curchan);
-		ath9k_hw_start_nfcal(ah);
+	if (AR_SREV_9300_20_OR_LATER(ah))
 		ar9003_hw_bb_watchdog_config(ah);
-	}
 
 	return 0;
 }
-- 
1.6.4.2

