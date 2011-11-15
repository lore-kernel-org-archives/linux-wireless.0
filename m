Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24366 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1KOGFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:05:22 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
CC: Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 14/18] ath9k_hw: Add support for MCI WLAN calibration
Date: Tue, 15 Nov 2011 11:35:13 +0530
Message-ID: <1321337113-12880-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111115_070551_988389_AB255402)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

WLAN communicates with BT for its calibration by sending WLAN_CAL_REQ,
waits for BT_CAL_GRANT. This is done with the help of GPM messages.
also WLAN_CAL_DONE messages is sent once WLAN calibration is done.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   43 +++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 12a730d..f7bc05c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -18,6 +18,7 @@
 #include "hw-ops.h"
 #include "ar9003_phy.h"
 #include "ar9003_rtt.h"
+#include "ar9003_mci.h"
 
 #define MAX_MEASUREMENT	MAX_IQCAL_MEASUREMENT
 #define MAX_MAG_DELTA	11
@@ -934,10 +935,12 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
 	bool txiqcal_done = false, txclcal_done = false;
 	bool is_reusable = true, status = true;
 	bool run_rtt_cal = false, run_agc_cal;
 	bool rtt = !!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT);
+	bool mci = !!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI);
 	u32 agc_ctrl = 0, agc_supp_cals = AR_PHY_AGC_CONTROL_OFFSET_CAL |
 					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
 					  AR_PHY_AGC_CONTROL_PKDET_CAL;
@@ -1005,6 +1008,31 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	} else if (caldata && !caldata->done_txiqcal_once)
 		run_agc_cal = true;
 
+	if (mci && IS_CHAN_2GHZ(chan) &&
+	    (mci_hw->bt_state  == MCI_BT_AWAKE) &&
+	    run_agc_cal &&
+	    !(mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL)) {
+
+		u32 pld[4] = {0, 0, 0, 0};
+
+		/* send CAL_REQ only when BT is AWAKE. */
+		ath_dbg(common, ATH_DBG_MCI, "MCI send WLAN_CAL_REQ 0x%x\n",
+			mci_hw->wlan_cal_seq);
+		MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_REQ);
+		pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_seq++;
+		ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
+
+		/* Wait BT_CAL_GRANT for 50ms */
+		ath_dbg(common, ATH_DBG_MCI, "MCI wait for BT_CAL_GRANT");
+
+		if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_GRANT, 0, 50000))
+			ath_dbg(common, ATH_DBG_MCI, "MCI got BT_CAL_GRANT");
+		else {
+			is_reusable = false;
+			ath_dbg(common, ATH_DBG_MCI, "\nMCI BT is not responding");
+		}
+	}
+
 	txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
 	udelay(5);
@@ -1022,6 +1050,21 @@ skip_tx_iqcal:
 				       AR_PHY_AGC_CONTROL_CAL,
 				       0, AH_WAIT_TIMEOUT);
 	}
+
+	if (mci && IS_CHAN_2GHZ(chan) &&
+	    (mci_hw->bt_state  == MCI_BT_AWAKE)	&&
+	    run_agc_cal	&&
+	    !(mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL)) {
+
+		u32 pld[4] = {0, 0, 0, 0};
+
+		ath_dbg(common, ATH_DBG_MCI, "MCI Send WLAN_CAL_DONE 0x%x\n",
+			mci_hw->wlan_cal_done);
+		MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_DONE);
+		pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_done++;
+		ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
+	}
+
 	if (rtt && !run_rtt_cal) {
 		agc_ctrl |= agc_supp_cals;
 		REG_WRITE(ah, AR_PHY_AGC_CONTROL, agc_ctrl);
-- 
1.7.0.4

