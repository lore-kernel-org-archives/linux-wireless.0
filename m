Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34616 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab2BUJXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 04:23:43 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.25234.331347.535249@gargle.gargle.HOWL> (sfid-20120221_102348_929248_6041453A)
Date: Tue, 21 Feb 2012 14:53:30 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 15/22] ath9k_hw: Cleanup MCI function declarations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch converts a few functions to static variants
and removes extraneous declarations.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  508 +++++++++++++-------------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |   13 -
 2 files changed, 254 insertions(+), 267 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 35299d5..e76ffcf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -82,7 +82,7 @@ static int ar9003_mci_wait_for_interrupt(struct ath_hw *ah, u32 address,
 	return time_out;
 }
 
-void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done)
+static void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done)
 {
 	u32 payload[4] = { 0xffffffff, 0xffffffff, 0xffffffff, 0xffffff00};
 
@@ -94,7 +94,7 @@ void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done)
 	udelay(5);
 }
 
-void ar9003_mci_send_lna_transfer(struct ath_hw *ah, bool wait_done)
+static void ar9003_mci_send_lna_transfer(struct ath_hw *ah, bool wait_done)
 {
 	u32 payload = 0x00000000;
 
@@ -112,7 +112,7 @@ static void ar9003_mci_send_req_wake(struct ath_hw *ah, bool wait_done)
 	udelay(5);
 }
 
-void ar9003_mci_send_sys_waking(struct ath_hw *ah, bool wait_done)
+static void ar9003_mci_send_sys_waking(struct ath_hw *ah, bool wait_done)
 {
 	if (!ATH9K_HW_CAP_MCI)
 		return;
@@ -223,8 +223,8 @@ static void ar9003_mci_send_coex_bt_status_query(struct ath_hw *ah,
 	}
 }
 
-void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
-				      bool wait_done)
+static void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
+					     bool wait_done)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
@@ -383,7 +383,7 @@ void ar9003_mci_set_full_sleep(struct ath_hw *ah)
 	REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
 }
 
-void ar9003_mci_disable_interrupt(struct ath_hw *ah)
+static void ar9003_mci_disable_interrupt(struct ath_hw *ah)
 {
 	if (!ATH9K_HW_CAP_MCI)
 		return;
@@ -392,7 +392,7 @@ void ar9003_mci_disable_interrupt(struct ath_hw *ah)
 	REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN, 0);
 }
 
-void ar9003_mci_enable_interrupt(struct ath_hw *ah)
+static void ar9003_mci_enable_interrupt(struct ath_hw *ah)
 {
 	if (!ATH9K_HW_CAP_MCI)
 		return;
@@ -402,7 +402,7 @@ void ar9003_mci_enable_interrupt(struct ath_hw *ah)
 		  AR_MCI_INTERRUPT_RX_MSG_DEFAULT);
 }
 
-bool ar9003_mci_check_int(struct ath_hw *ah, u32 ints)
+static bool ar9003_mci_check_int(struct ath_hw *ah, u32 ints)
 {
 	u32 intr;
 
@@ -455,7 +455,7 @@ void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	}
 }
 
-void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g)
+static void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g)
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 
@@ -568,6 +568,36 @@ static bool ar9003_mci_send_coex_bt_flags(struct ath_hw *ah, bool wait_done,
 							wait_done, true);
 }
 
+static void ar9003_mci_sync_bt_state(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+	u32 cur_bt_state;
+
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
+	cur_bt_state = ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL);
+
+	if (mci->bt_state != cur_bt_state) {
+		ath_dbg(common, MCI,
+			"MCI BT state mismatches. old: %d, new: %d\n",
+			mci->bt_state, cur_bt_state);
+		mci->bt_state = cur_bt_state;
+	}
+
+	if (mci->bt_state != MCI_BT_SLEEP) {
+
+		ar9003_mci_send_coex_version_query(ah, true);
+		ar9003_mci_send_coex_wlan_channels(ah, true);
+
+		if (mci->unhalt_bt_gpm == true) {
+			ath_dbg(common, MCI, "MCI unhalt BT GPM\n");
+			ar9003_mci_send_coex_halt_bt_gpm(ah, false, true);
+		}
+	}
+}
+
 void ar9003_mci_check_bt(struct ath_hw *ah)
 {
 	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
@@ -588,6 +618,188 @@ void ar9003_mci_check_bt(struct ath_hw *ah)
 	}
 }
 
+static void ar9003_mci_process_gpm_extra(struct ath_hw *ah, u8 gpm_type,
+					 u8 gpm_opcode, u32 *p_gpm)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+	u8 *p_data = (u8 *) p_gpm;
+
+	if (gpm_type != MCI_GPM_COEX_AGENT)
+		return;
+
+	switch (gpm_opcode) {
+	case MCI_GPM_COEX_VERSION_QUERY:
+		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Query\n");
+		ar9003_mci_send_coex_version_response(ah, true);
+		break;
+	case MCI_GPM_COEX_VERSION_RESPONSE:
+		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Response\n");
+		mci->bt_ver_major =
+			*(p_data + MCI_GPM_COEX_B_MAJOR_VERSION);
+		mci->bt_ver_minor =
+			*(p_data + MCI_GPM_COEX_B_MINOR_VERSION);
+		mci->bt_version_known = true;
+		ath_dbg(common, MCI, "MCI BT Coex version: %d.%d\n",
+			mci->bt_ver_major, mci->bt_ver_minor);
+		break;
+	case MCI_GPM_COEX_STATUS_QUERY:
+		ath_dbg(common, MCI,
+			"MCI Recv GPM COEX Status Query = 0x%02X\n",
+			*(p_data + MCI_GPM_COEX_B_WLAN_BITMAP));
+		mci->wlan_channels_update = true;
+		ar9003_mci_send_coex_wlan_channels(ah, true);
+		break;
+	case MCI_GPM_COEX_BT_PROFILE_INFO:
+		mci->query_bt = true;
+		ath_dbg(common, MCI, "MCI Recv GPM COEX BT_Profile_Info\n");
+		break;
+	case MCI_GPM_COEX_BT_STATUS_UPDATE:
+		mci->query_bt = true;
+		ath_dbg(common, MCI,
+			"MCI Recv GPM COEX BT_Status_Update SEQ=%d (drop&query)\n",
+			*(p_gpm + 3));
+		break;
+	default:
+		break;
+	}
+}
+
+static u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
+				   u8 gpm_opcode, int time_out)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+	u32 *p_gpm = NULL, mismatch = 0, more_data;
+	u32 offset;
+	u8 recv_type = 0, recv_opcode = 0;
+	bool b_is_bt_cal_done = (gpm_type == MCI_GPM_BT_CAL_DONE);
+
+	if (!ATH9K_HW_CAP_MCI)
+		return 0;
+
+	more_data = time_out ? MCI_GPM_NOMORE : MCI_GPM_MORE;
+
+	while (time_out > 0) {
+		if (p_gpm) {
+			MCI_GPM_RECYCLE(p_gpm);
+			p_gpm = NULL;
+		}
+
+		if (more_data != MCI_GPM_MORE)
+			time_out = ar9003_mci_wait_for_interrupt(ah,
+					AR_MCI_INTERRUPT_RX_MSG_RAW,
+					AR_MCI_INTERRUPT_RX_MSG_GPM,
+					time_out);
+
+		if (!time_out)
+			break;
+
+		offset = ar9003_mci_state(ah,
+				MCI_STATE_NEXT_GPM_OFFSET, &more_data);
+
+		if (offset == MCI_GPM_INVALID)
+			continue;
+
+		p_gpm = (u32 *) (mci->gpm_buf + offset);
+		recv_type = MCI_GPM_TYPE(p_gpm);
+		recv_opcode = MCI_GPM_OPCODE(p_gpm);
+
+		if (MCI_GPM_IS_CAL_TYPE(recv_type)) {
+
+			if (recv_type == gpm_type) {
+
+				if ((gpm_type == MCI_GPM_BT_CAL_DONE) &&
+				    !b_is_bt_cal_done) {
+					gpm_type = MCI_GPM_BT_CAL_GRANT;
+					ath_dbg(common, MCI,
+						"MCI Recv BT_CAL_DONE wait BT_CAL_GRANT\n");
+					continue;
+				}
+
+				break;
+			}
+		} else if ((recv_type == gpm_type) &&
+			   (recv_opcode == gpm_opcode))
+			break;
+
+		/* not expected message */
+
+		/*
+		 * check if it's cal_grant
+		 *
+		 * When we're waiting for cal_grant in reset routine,
+		 * it's possible that BT sends out cal_request at the
+		 * same time. Since BT's calibration doesn't happen
+		 * that often, we'll let BT completes calibration then
+		 * we continue to wait for cal_grant from BT.
+		 * Orginal: Wait BT_CAL_GRANT.
+		 * New: Receive BT_CAL_REQ -> send WLAN_CAL_GRANT->wait
+		 * BT_CAL_DONE -> Wait BT_CAL_GRANT.
+		 */
+
+		if ((gpm_type == MCI_GPM_BT_CAL_GRANT) &&
+		    (recv_type == MCI_GPM_BT_CAL_REQ)) {
+
+			u32 payload[4] = {0, 0, 0, 0};
+
+			gpm_type = MCI_GPM_BT_CAL_DONE;
+			ath_dbg(common, MCI,
+				"MCI Rcv BT_CAL_REQ, send WLAN_CAL_GRANT\n");
+
+			MCI_GPM_SET_CAL_TYPE(payload,
+					MCI_GPM_WLAN_CAL_GRANT);
+
+			ar9003_mci_send_message(ah, MCI_GPM, 0, payload, 16,
+						false, false);
+
+			ath_dbg(common, MCI, "MCI now wait for BT_CAL_DONE\n");
+
+			continue;
+		} else {
+			ath_dbg(common, MCI, "MCI GPM subtype not match 0x%x\n",
+				*(p_gpm + 1));
+			mismatch++;
+			ar9003_mci_process_gpm_extra(ah, recv_type,
+					recv_opcode, p_gpm);
+		}
+	}
+	if (p_gpm) {
+		MCI_GPM_RECYCLE(p_gpm);
+		p_gpm = NULL;
+	}
+
+	if (time_out <= 0) {
+		time_out = 0;
+		ath_dbg(common, MCI,
+			"MCI GPM received timeout, mismatch = %d\n", mismatch);
+	} else
+		ath_dbg(common, MCI, "MCI Receive GPM type=0x%x, code=0x%x\n",
+			gpm_type, gpm_opcode);
+
+	while (more_data == MCI_GPM_MORE) {
+
+		ath_dbg(common, MCI, "MCI discard remaining GPM\n");
+		offset = ar9003_mci_state(ah, MCI_STATE_NEXT_GPM_OFFSET,
+					  &more_data);
+
+		if (offset == MCI_GPM_INVALID)
+			break;
+
+		p_gpm = (u32 *) (mci->gpm_buf + offset);
+		recv_type = MCI_GPM_TYPE(p_gpm);
+		recv_opcode = MCI_GPM_OPCODE(p_gpm);
+
+		if (!MCI_GPM_IS_CAL_TYPE(recv_type))
+			ar9003_mci_process_gpm_extra(ah, recv_type,
+						     recv_opcode, p_gpm);
+
+		MCI_GPM_RECYCLE(p_gpm);
+	}
+
+	return time_out;
+}
+
 bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -693,6 +905,39 @@ exit:
 	return 0;
 }
 
+static void ar9003_mci_mute_bt(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!ATH9K_HW_CAP_MCI)
+		return;
+
+	/* disable all MCI messages */
+	REG_WRITE(ah, AR_MCI_MSG_ATTRIBUTES_TABLE, 0xffff0000);
+	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS0, 0xffffffff);
+	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS1, 0xffffffff);
+	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS2, 0xffffffff);
+	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS3, 0xffffffff);
+	REG_SET_BIT(ah, AR_MCI_TX_CTRL, AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
+
+	/* wait pending HW messages to flush out */
+	udelay(10);
+
+	/*
+	 * Send LNA_TAKE and SYS_SLEEPING when
+	 * 1. reset not after resuming from full sleep
+	 * 2. before reset MCI RX, to quiet BT and avoid MCI RX misalignment
+	 */
+
+	ath_dbg(common, MCI, "MCI Send LNA take\n");
+	ar9003_mci_send_lna_take(ah, true);
+
+	udelay(5);
+
+	ath_dbg(common, MCI, "MCI Send sys sleeping\n");
+	ar9003_mci_send_sys_sleeping(ah, true);
+}
+
 void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		      bool is_full_sleep)
 {
@@ -838,69 +1083,6 @@ void ar9003_mci_stop_bt(struct ath_hw *ah, bool save_fullsleep)
 	mci_hw->ready = false;
 }
 
-void ar9003_mci_mute_bt(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
-	/* disable all MCI messages */
-	REG_WRITE(ah, AR_MCI_MSG_ATTRIBUTES_TABLE, 0xffff0000);
-	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS0, 0xffffffff);
-	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS1, 0xffffffff);
-	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS2, 0xffffffff);
-	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS3, 0xffffffff);
-	REG_SET_BIT(ah, AR_MCI_TX_CTRL, AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
-
-	/* wait pending HW messages to flush out */
-	udelay(10);
-
-	/*
-	 * Send LNA_TAKE and SYS_SLEEPING when
-	 * 1. reset not after resuming from full sleep
-	 * 2. before reset MCI RX, to quiet BT and avoid MCI RX misalignment
-	 */
-
-	ath_dbg(common, MCI, "MCI Send LNA take\n");
-	ar9003_mci_send_lna_take(ah, true);
-
-	udelay(5);
-
-	ath_dbg(common, MCI, "MCI Send sys sleeping\n");
-	ar9003_mci_send_sys_sleeping(ah, true);
-}
-
-void ar9003_mci_sync_bt_state(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
-	u32 cur_bt_state;
-
-	if (!ATH9K_HW_CAP_MCI)
-		return;
-
-	cur_bt_state = ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP, NULL);
-
-	if (mci->bt_state != cur_bt_state) {
-		ath_dbg(common, MCI,
-			"MCI BT state mismatches. old: %d, new: %d\n",
-			mci->bt_state, cur_bt_state);
-		mci->bt_state = cur_bt_state;
-	}
-
-	if (mci->bt_state != MCI_BT_SLEEP) {
-
-		ar9003_mci_send_coex_version_query(ah, true);
-		ar9003_mci_send_coex_wlan_channels(ah, true);
-
-		if (mci->unhalt_bt_gpm == true) {
-			ath_dbg(common, MCI, "MCI unhalt BT GPM\n");
-			ar9003_mci_send_coex_halt_bt_gpm(ah, false, true);
-		}
-	}
-}
-
 static void ar9003_mci_send_2g5g_status(struct ath_hw *ah, bool wait_done)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1232,188 +1414,6 @@ void ar9003_mci_cleanup(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ar9003_mci_cleanup);
 
-static void ar9003_mci_process_gpm_extra(struct ath_hw *ah, u8 gpm_type,
-					 u8 gpm_opcode, u32 *p_gpm)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
-	u8 *p_data = (u8 *) p_gpm;
-
-	if (gpm_type != MCI_GPM_COEX_AGENT)
-		return;
-
-	switch (gpm_opcode) {
-	case MCI_GPM_COEX_VERSION_QUERY:
-		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Query\n");
-		ar9003_mci_send_coex_version_response(ah, true);
-		break;
-	case MCI_GPM_COEX_VERSION_RESPONSE:
-		ath_dbg(common, MCI, "MCI Recv GPM COEX Version Response\n");
-		mci->bt_ver_major =
-			*(p_data + MCI_GPM_COEX_B_MAJOR_VERSION);
-		mci->bt_ver_minor =
-			*(p_data + MCI_GPM_COEX_B_MINOR_VERSION);
-		mci->bt_version_known = true;
-		ath_dbg(common, MCI, "MCI BT Coex version: %d.%d\n",
-			mci->bt_ver_major, mci->bt_ver_minor);
-		break;
-	case MCI_GPM_COEX_STATUS_QUERY:
-		ath_dbg(common, MCI,
-			"MCI Recv GPM COEX Status Query = 0x%02X\n",
-			*(p_data + MCI_GPM_COEX_B_WLAN_BITMAP));
-		mci->wlan_channels_update = true;
-		ar9003_mci_send_coex_wlan_channels(ah, true);
-		break;
-	case MCI_GPM_COEX_BT_PROFILE_INFO:
-		mci->query_bt = true;
-		ath_dbg(common, MCI, "MCI Recv GPM COEX BT_Profile_Info\n");
-		break;
-	case MCI_GPM_COEX_BT_STATUS_UPDATE:
-		mci->query_bt = true;
-		ath_dbg(common, MCI,
-			"MCI Recv GPM COEX BT_Status_Update SEQ=%d (drop&query)\n",
-			*(p_gpm + 3));
-		break;
-	default:
-		break;
-	}
-}
-
-u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
-			    u8 gpm_opcode, int time_out)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
-	u32 *p_gpm = NULL, mismatch = 0, more_data;
-	u32 offset;
-	u8 recv_type = 0, recv_opcode = 0;
-	bool b_is_bt_cal_done = (gpm_type == MCI_GPM_BT_CAL_DONE);
-
-	if (!ATH9K_HW_CAP_MCI)
-		return 0;
-
-	more_data = time_out ? MCI_GPM_NOMORE : MCI_GPM_MORE;
-
-	while (time_out > 0) {
-		if (p_gpm) {
-			MCI_GPM_RECYCLE(p_gpm);
-			p_gpm = NULL;
-		}
-
-		if (more_data != MCI_GPM_MORE)
-			time_out = ar9003_mci_wait_for_interrupt(ah,
-					AR_MCI_INTERRUPT_RX_MSG_RAW,
-					AR_MCI_INTERRUPT_RX_MSG_GPM,
-					time_out);
-
-		if (!time_out)
-			break;
-
-		offset = ar9003_mci_state(ah,
-				MCI_STATE_NEXT_GPM_OFFSET, &more_data);
-
-		if (offset == MCI_GPM_INVALID)
-			continue;
-
-		p_gpm = (u32 *) (mci->gpm_buf + offset);
-		recv_type = MCI_GPM_TYPE(p_gpm);
-		recv_opcode = MCI_GPM_OPCODE(p_gpm);
-
-		if (MCI_GPM_IS_CAL_TYPE(recv_type)) {
-
-			if (recv_type == gpm_type) {
-
-				if ((gpm_type == MCI_GPM_BT_CAL_DONE) &&
-				    !b_is_bt_cal_done) {
-					gpm_type = MCI_GPM_BT_CAL_GRANT;
-					ath_dbg(common, MCI,
-						"MCI Recv BT_CAL_DONE wait BT_CAL_GRANT\n");
-					continue;
-				}
-
-				break;
-			}
-		} else if ((recv_type == gpm_type) &&
-			   (recv_opcode == gpm_opcode))
-			break;
-
-		/* not expected message */
-
-		/*
-		 * check if it's cal_grant
-		 *
-		 * When we're waiting for cal_grant in reset routine,
-		 * it's possible that BT sends out cal_request at the
-		 * same time. Since BT's calibration doesn't happen
-		 * that often, we'll let BT completes calibration then
-		 * we continue to wait for cal_grant from BT.
-		 * Orginal: Wait BT_CAL_GRANT.
-		 * New: Receive BT_CAL_REQ -> send WLAN_CAL_GRANT->wait
-		 * BT_CAL_DONE -> Wait BT_CAL_GRANT.
-		 */
-
-		if ((gpm_type == MCI_GPM_BT_CAL_GRANT) &&
-		    (recv_type == MCI_GPM_BT_CAL_REQ)) {
-
-			u32 payload[4] = {0, 0, 0, 0};
-
-			gpm_type = MCI_GPM_BT_CAL_DONE;
-			ath_dbg(common, MCI,
-				"MCI Rcv BT_CAL_REQ, send WLAN_CAL_GRANT\n");
-
-			MCI_GPM_SET_CAL_TYPE(payload,
-					MCI_GPM_WLAN_CAL_GRANT);
-
-			ar9003_mci_send_message(ah, MCI_GPM, 0, payload, 16,
-						false, false);
-
-			ath_dbg(common, MCI, "MCI now wait for BT_CAL_DONE\n");
-
-			continue;
-		} else {
-			ath_dbg(common, MCI, "MCI GPM subtype not match 0x%x\n",
-				*(p_gpm + 1));
-			mismatch++;
-			ar9003_mci_process_gpm_extra(ah, recv_type,
-					recv_opcode, p_gpm);
-		}
-	}
-	if (p_gpm) {
-		MCI_GPM_RECYCLE(p_gpm);
-		p_gpm = NULL;
-	}
-
-	if (time_out <= 0) {
-		time_out = 0;
-		ath_dbg(common, MCI,
-			"MCI GPM received timeout, mismatch = %d\n", mismatch);
-	} else
-		ath_dbg(common, MCI, "MCI Receive GPM type=0x%x, code=0x%x\n",
-			gpm_type, gpm_opcode);
-
-	while (more_data == MCI_GPM_MORE) {
-
-		ath_dbg(common, MCI, "MCI discard remaining GPM\n");
-		offset = ar9003_mci_state(ah, MCI_STATE_NEXT_GPM_OFFSET,
-					  &more_data);
-
-		if (offset == MCI_GPM_INVALID)
-			break;
-
-		p_gpm = (u32 *) (mci->gpm_buf + offset);
-		recv_type = MCI_GPM_TYPE(p_gpm);
-		recv_opcode = MCI_GPM_OPCODE(p_gpm);
-
-		if (!MCI_GPM_IS_CAL_TYPE(recv_type))
-			ar9003_mci_process_gpm_extra(ah, recv_type,
-						     recv_opcode, p_gpm);
-
-		MCI_GPM_RECYCLE(p_gpm);
-	}
-
-	return time_out;
-}
-
 u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 39bbf67..507527b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -258,21 +258,13 @@ bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
 			     u32 *payload, u8 len, bool wait_done,
 			     bool check_bt);
 void ar9003_mci_stop_bt(struct ath_hw *ah, bool sava_fullsleep);
-void ar9003_mci_mute_bt(struct ath_hw *ah);
 u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data);
 void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
 void ar9003_mci_init_cal_done(struct ath_hw *ah);
 void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
 		      u16 len, u32 sched_addr);
 void ar9003_mci_cleanup(struct ath_hw *ah);
-void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
-				      bool wait_done);
-u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
-			    u8 gpm_opcode, int time_out);
-void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g);
 void ar9003_mci_set_full_sleep(struct ath_hw *ah);
-void ar9003_mci_disable_interrupt(struct ath_hw *ah);
-void ar9003_mci_enable_interrupt(struct ath_hw *ah);
 void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done);
 void ar9003_mci_check_bt(struct ath_hw *ah);
 bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan);
@@ -280,11 +272,6 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 			 struct ath9k_hw_cal_data *caldata);
 void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		      bool is_full_sleep);
-bool ar9003_mci_check_int(struct ath_hw *ah, u32 ints);
-void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done);
-void ar9003_mci_send_sys_waking(struct ath_hw *ah, bool wait_done);
-void ar9003_mci_send_lna_transfer(struct ath_hw *ah, bool wait_done);
-void ar9003_mci_sync_bt_state(struct ath_hw *ah);
 void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 			      u32 *rx_msg_intr);
 void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
-- 
1.7.9.1

