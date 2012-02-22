Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17868 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab2BVHLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:11:16 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38154.691214.327628@gargle.gargle.HOWL> (sfid-20120222_081121_442547_14AEE563)
Date: Wed, 22 Feb 2012 12:41:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 12/26] ath9k_hw: Setup MCI calibration using a helper
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   42 ++-------------------
 drivers/net/wireless/ath/ath9k/ar9003_mci.c   |   48 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |    2 +
 3 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 8e70f0b..63089cc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -925,7 +925,6 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
-	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
 	bool txiqcal_done = false, txclcal_done = false;
 	bool is_reusable = true, status = true;
 	bool run_rtt_cal = false, run_agc_cal;
@@ -998,30 +997,8 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	} else if (caldata && !caldata->done_txiqcal_once)
 		run_agc_cal = true;
 
-	if (mci && IS_CHAN_2GHZ(chan) &&
-	    (mci_hw->bt_state  == MCI_BT_AWAKE) &&
-	    run_agc_cal &&
-	    !(mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL)) {
-
-		u32 pld[4] = {0, 0, 0, 0};
-
-		/* send CAL_REQ only when BT is AWAKE. */
-		ath_dbg(common, MCI, "MCI send WLAN_CAL_REQ 0x%x\n",
-			mci_hw->wlan_cal_seq);
-		MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_REQ);
-		pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_seq++;
-		ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
-
-		/* Wait BT_CAL_GRANT for 50ms */
-		ath_dbg(common, MCI, "MCI wait for BT_CAL_GRANT\n");
-
-		if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_GRANT, 0, 50000))
-			ath_dbg(common, MCI, "MCI got BT_CAL_GRANT\n");
-		else {
-			is_reusable = false;
-			ath_dbg(common, MCI, "\nMCI BT is not responding\n");
-		}
-	}
+	if (mci && IS_CHAN_2GHZ(chan) && run_agc_cal)
+		ar9003_mci_init_cal_req(ah, &is_reusable);
 
 	txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
@@ -1041,19 +1018,8 @@ skip_tx_iqcal:
 				       0, AH_WAIT_TIMEOUT);
 	}
 
-	if (mci && IS_CHAN_2GHZ(chan) &&
-	    (mci_hw->bt_state  == MCI_BT_AWAKE)	&&
-	    run_agc_cal	&&
-	    !(mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL)) {
-
-		u32 pld[4] = {0, 0, 0, 0};
-
-		ath_dbg(common, MCI, "MCI Send WLAN_CAL_DONE 0x%x\n",
-			mci_hw->wlan_cal_done);
-		MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_DONE);
-		pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_done++;
-		ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
-	}
+	if (mci && IS_CHAN_2GHZ(chan) && run_agc_cal)
+		ar9003_mci_init_cal_done(ah);
 
 	if (rtt && !run_rtt_cal) {
 		agc_ctrl |= agc_supp_cals;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index a87d4ca1..65db2cd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1011,6 +1011,54 @@ bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
 }
 EXPORT_SYMBOL(ar9003_mci_send_message);
 
+void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
+	u32 pld[4] = {0, 0, 0, 0};
+
+	if ((mci_hw->bt_state != MCI_BT_AWAKE) ||
+	    (mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL))
+		return;
+
+	/* send CAL_REQ only when BT is AWAKE. */
+	ath_dbg(common, MCI, "MCI send WLAN_CAL_REQ 0x%x\n",
+		mci_hw->wlan_cal_seq);
+
+	MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_REQ);
+	pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_seq++;
+
+	ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
+
+	/* Wait BT_CAL_GRANT for 50ms */
+	ath_dbg(common, MCI, "MCI wait for BT_CAL_GRANT\n");
+
+	if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_GRANT, 0, 50000)) {
+		ath_dbg(common, MCI, "MCI got BT_CAL_GRANT\n");
+	} else {
+		is_reusable = false;
+		ath_dbg(common, MCI, "MCI BT is not responding\n");
+	}
+}
+
+void ar9003_mci_init_cal_done(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
+	u32 pld[4] = {0, 0, 0, 0};
+
+	if ((mci_hw->bt_state != MCI_BT_AWAKE) ||
+	    (mci_hw->config & ATH_MCI_CONFIG_DISABLE_MCI_CAL))
+		return;
+
+	ath_dbg(common, MCI, "MCI Send WLAN_CAL_DONE 0x%x\n",
+		mci_hw->wlan_cal_done);
+
+	MCI_GPM_SET_CAL_TYPE(pld, MCI_GPM_WLAN_CAL_DONE);
+	pld[MCI_GPM_WLAN_CAL_W_SEQUENCE] = mci_hw->wlan_cal_done++;
+	ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
+}
+
 void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
 		      u16 len, u32 sched_addr)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6460af5..b3e8415 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1210,6 +1210,8 @@ bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
 			     bool check_bt);
 void ar9003_mci_mute_bt(struct ath_hw *ah);
 u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data);
+void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
+void ar9003_mci_init_cal_done(struct ath_hw *ah);
 void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
 		      u16 len, u32 sched_addr);
 void ar9003_mci_cleanup(struct ath_hw *ah);
-- 
1.7.9.1

