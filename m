Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26383 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2EXEDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 00:03:23 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45771.531890.970671@gargle.gargle.HOWL> (sfid-20120524_060337_444595_8241B405)
Date: Thu, 24 May 2012 09:32:19 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 05/22] ath9k_hw: Fix MCI usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MCI has to be handled only when BTCOEX is actually enabled.
Check for this condition before calling MCI related functions
from various reset/calibration call-sites.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    5 ++---
 drivers/net/wireless/ath/ath9k/ar9003_mci.h   |    8 --------
 drivers/net/wireless/ath/ath9k/hw.c           |   15 +++++++--------
 drivers/net/wireless/ath/ath9k/hw.h           |    9 +++++++++
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 9fdd70f..f83a4a2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -901,7 +901,6 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	bool is_reusable = true, status = true;
 	bool run_rtt_cal = false, run_agc_cal;
 	bool rtt = !!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT);
-	bool mci = !!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI);
 	u32 agc_ctrl = 0, agc_supp_cals = AR_PHY_AGC_CONTROL_OFFSET_CAL |
 					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
 					  AR_PHY_AGC_CONTROL_PKDET_CAL;
@@ -970,7 +969,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	} else if (caldata && !caldata->done_txiqcal_once)
 		run_agc_cal = true;
 
-	if (mci && IS_CHAN_2GHZ(chan) && run_agc_cal)
+	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
 		ar9003_mci_init_cal_req(ah, &is_reusable);
 
 	if (!(IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan))) {
@@ -993,7 +992,7 @@ skip_tx_iqcal:
 				       0, AH_WAIT_TIMEOUT);
 	}
 
-	if (mci && IS_CHAN_2GHZ(chan) && run_agc_cal)
+	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
 		ar9003_mci_init_cal_done(ah);
 
 	if (rtt && !run_rtt_cal) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 4842f6c..652ab8c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -273,10 +273,6 @@ void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 
-static inline bool ar9003_mci_is_ready(struct ath_hw *ah)
-{
-	return ah->btcoex_hw.mci.ready;
-}
 void ar9003_mci_stop_bt(struct ath_hw *ah, bool save_fullsleep);
 void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
 void ar9003_mci_init_cal_done(struct ath_hw *ah);
@@ -292,10 +288,6 @@ void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
 
 #else
 
-static inline bool ar9003_mci_is_ready(struct ath_hw *ah)
-{
-	return false;
-}
 static inline void ar9003_mci_stop_bt(struct ath_hw *ah, bool save_fullsleep)
 {
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8698589..175b340 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1704,7 +1704,7 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 	ath9k_hw_loadnf(ah, ah->curchan);
 	ath9k_hw_start_nfcal(ah, true);
 
-	if ((ah->caps.hw_caps & ATH9K_HW_CAP_MCI) && ar9003_mci_is_ready(ah))
+	if (ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_2g5g_switch(ah, true);
 
 	if (AR_SREV_9271(ah))
@@ -1725,10 +1725,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u64 tsf = 0;
 	int i, r;
 	bool start_mci_reset = false;
-	bool mci = !!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI);
 	bool save_fullsleep = ah->chip_fullsleep;
 
-	if (mci) {
+	if (ath9k_hw_mci_is_enabled(ah)) {
 		start_mci_reset = ar9003_mci_start_reset(ah, chan);
 		if (start_mci_reset)
 			return 0;
@@ -1757,7 +1756,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 			return r;
 	}
 
-	if (mci)
+	if (ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_stop_bt(ah, save_fullsleep);
 
 	saveDefAntenna = REG_READ(ah, AR_DEF_ANTENNA);
@@ -1815,7 +1814,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (r)
 		return r;
 
-	if (mci)
+	if (ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_reset(ah, false, IS_CHAN_2GHZ(chan), save_fullsleep);
 
 	/*
@@ -1934,7 +1933,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_loadnf(ah, chan);
 	ath9k_hw_start_nfcal(ah, true);
 
-	if (mci && ar9003_mci_end_reset(ah, chan, caldata))
+	if (ath9k_hw_mci_is_enabled(ah) && ar9003_mci_end_reset(ah, chan, caldata))
 		return -EIO;
 
 	ENABLE_REGWRITE_BUFFER(ah);
@@ -1979,7 +1978,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (ath9k_hw_btcoex_is_enabled(ah))
 		ath9k_hw_btcoex_enable(ah);
 
-	if (mci)
+	if (ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_check_bt(ah);
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
@@ -2163,7 +2162,7 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 		status = ath9k_hw_set_power_awake(ah, setChip);
 		break;
 	case ATH9K_PM_FULL_SLEEP:
-		if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+		if (ath9k_hw_mci_is_enabled(ah))
 			ar9003_mci_set_full_sleep(ah);
 
 		ath9k_set_power_sleep(ah, setChip);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b620c55..3740aab 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1037,6 +1037,11 @@ static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
 {
 	return ah->btcoex_hw.enabled;
 }
+static inline bool ath9k_hw_mci_is_enabled(struct ath_hw *ah)
+{
+	return ah->btcoex_hw.enabled && (ah->caps.hw_caps & ATH9K_HW_CAP_MCI);
+
+}
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 static inline enum ath_btcoex_scheme
 ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
@@ -1048,6 +1053,10 @@ static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
 {
 	return false;
 }
+static inline bool ath9k_hw_mci_is_enabled(struct ath_hw *ah)
+{
+	return false;
+}
 static inline void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
 }
-- 
1.7.10.2

