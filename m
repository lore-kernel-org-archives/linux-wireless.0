Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6773 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab2BVHLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:11:22 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38160.264839.628906@gargle.gargle.HOWL> (sfid-20120222_081126_260042_4ECA3276)
Date: Wed, 22 Feb 2012 12:41:12 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 13/26] ath9k_hw: Cleanup MCI bits from ath9k_hw_reset()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves all the MCI-specific code in the main reset
function to helper functions.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  142 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |  129 ++----------------------
 drivers/net/wireless/ath/ath9k/hw.h         |   10 ++
 3 files changed, 163 insertions(+), 118 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 65db2cd..597e707 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -16,6 +16,7 @@
 
 #include <linux/export.h>
 #include "hw.h"
+#include "hw-ops.h"
 #include "ar9003_phy.h"
 #include "ar9003_mci.h"
 
@@ -567,6 +568,131 @@ static bool ar9003_mci_send_coex_bt_flags(struct ath_hw *ah, bool wait_done,
 							wait_done, true);
 }
 
+void ar9003_mci_check_bt(struct ath_hw *ah)
+{
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
+
+	if (!mci_hw->ready)
+		return;
+
+	/*
+	 * check BT state again to make
+	 * sure it's not changed.
+	 */
+	ar9003_mci_sync_bt_state(ah);
+	ar9003_mci_2g5g_switch(ah, true);
+
+	if ((mci_hw->bt_state == MCI_BT_AWAKE) &&
+	    (mci_hw->query_bt == true)) {
+		mci_hw->need_flush_btinfo = true;
+	}
+}
+
+bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
+	u32 payload[4] = {0, 0, 0, 0};
+
+	ar9003_mci_2g5g_changed(ah, IS_CHAN_2GHZ(chan));
+
+	if (mci_hw->bt_state != MCI_BT_CAL_START)
+		return false;
+
+	ath_dbg(common, MCI, "MCI stop rx for BT CAL\n");
+
+	mci_hw->bt_state = MCI_BT_CAL;
+
+	/*
+	 * MCI FIX: disable mci interrupt here. This is to avoid
+	 * SW_MSG_DONE or RX_MSG bits to trigger MCI_INT and
+	 * lead to mci_intr reentry.
+	 */
+
+	ar9003_mci_disable_interrupt(ah);
+
+	ath_dbg(common, MCI, "send WLAN_CAL_GRANT\n");
+
+	MCI_GPM_SET_CAL_TYPE(payload, MCI_GPM_WLAN_CAL_GRANT);
+	ar9003_mci_send_message(ah, MCI_GPM, 0, payload,
+				16, true, false);
+
+	ath_dbg(common, MCI, "\nMCI BT is calibrating\n");
+
+	/* Wait BT calibration to be completed for 25ms */
+
+	if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_DONE,
+				    0, 25000))
+		ath_dbg(common, MCI,
+			"MCI got BT_CAL_DONE\n");
+	else
+		ath_dbg(common, MCI,
+			"MCI ### BT cal takes to long, force bt_state to be bt_awake\n");
+
+	mci_hw->bt_state = MCI_BT_AWAKE;
+	/* MCI FIX: enable mci interrupt here */
+	ar9003_mci_enable_interrupt(ah);
+
+	return true;
+}
+
+int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+			 struct ath9k_hw_cal_data *caldata)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
+
+	if (!mci_hw->ready)
+		return 0;
+
+	if (!IS_CHAN_2GHZ(chan) || (mci_hw->bt_state != MCI_BT_SLEEP))
+		goto exit;
+
+	if (ar9003_mci_check_int(ah, AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET) ||
+	    ar9003_mci_check_int(ah, AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE)) {
+
+		/*
+		 * BT is sleeping. Check if BT wakes up during
+		 * WLAN calibration. If BT wakes up during
+		 * WLAN calibration, need to go through all
+		 * message exchanges again and recal.
+		 */
+
+		ath_dbg(common, MCI,
+			"MCI BT wakes up during WLAN calibration\n");
+
+		REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_RAW,
+			  AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET |
+			  AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE);
+
+		ath_dbg(common, MCI, "MCI send REMOTE_RESET\n");
+
+		ar9003_mci_remote_reset(ah, true);
+		ar9003_mci_send_sys_waking(ah, true);
+		udelay(1);
+
+		if (IS_CHAN_2GHZ(chan))
+			ar9003_mci_send_lna_transfer(ah, true);
+
+		mci_hw->bt_state = MCI_BT_AWAKE;
+
+		ath_dbg(common, MCI, "MCI re-cal\n");
+
+		if (caldata) {
+			caldata->done_txiqcal_once = false;
+			caldata->done_txclcal_once = false;
+			caldata->rtt_hist.num_readings = 0;
+		}
+
+		if (!ath9k_hw_init_cal(ah, chan))
+			return -EIO;
+
+	}
+exit:
+	ar9003_mci_enable_interrupt(ah);
+	return 0;
+}
+
 void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		      bool is_full_sleep)
 {
@@ -696,6 +822,22 @@ void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		ar9003_mci_enable_interrupt(ah);
 }
 
+void ar9003_mci_stop_bt(struct ath_hw *ah, bool save_fullsleep)
+{
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
+
+	ar9003_mci_disable_interrupt(ah);
+
+	if (mci_hw->ready && !save_fullsleep) {
+		ar9003_mci_mute_bt(ah);
+		udelay(20);
+		REG_WRITE(ah, AR_BTCOEX_CTRL, 0);
+	}
+
+	mci_hw->bt_state = MCI_BT_SLEEP;
+	mci_hw->ready = false;
+}
+
 void ar9003_mci_mute_bt(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 406ffd0..475e4ca 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1518,61 +1518,22 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   struct ath9k_hw_cal_data *caldata, bool bChannelChange)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
 	u32 saveLedState;
 	struct ath9k_channel *curchan = ah->curchan;
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	u64 tsf = 0;
 	int i, r;
-	bool allow_fbs = false;
+	bool allow_fbs = false, start_mci_reset = false;
 	bool mci = !!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI);
 	bool save_fullsleep = ah->chip_fullsleep;
 
 	if (mci) {
-
-		ar9003_mci_2g5g_changed(ah, IS_CHAN_2GHZ(chan));
-
-		if (mci_hw->bt_state == MCI_BT_CAL_START) {
-			u32 payload[4] = {0, 0, 0, 0};
-
-			ath_dbg(common, MCI, "MCI stop rx for BT CAL\n");
-
-			mci_hw->bt_state = MCI_BT_CAL;
-
-			/*
-			 * MCI FIX: disable mci interrupt here. This is to avoid
-			 * SW_MSG_DONE or RX_MSG bits to trigger MCI_INT and
-			 * lead to mci_intr reentry.
-			 */
-
-			ar9003_mci_disable_interrupt(ah);
-
-			ath_dbg(common, MCI, "send WLAN_CAL_GRANT\n");
-			MCI_GPM_SET_CAL_TYPE(payload, MCI_GPM_WLAN_CAL_GRANT);
-			ar9003_mci_send_message(ah, MCI_GPM, 0, payload,
-						16, true, false);
-
-			ath_dbg(common, MCI, "\nMCI BT is calibrating\n");
-
-			/* Wait BT calibration to be completed for 25ms */
-
-			if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_DONE,
-								  0, 25000))
-				ath_dbg(common, MCI,
-					"MCI got BT_CAL_DONE\n");
-			else
-				ath_dbg(common, MCI,
-					"MCI ### BT cal takes to long, force bt_state to be bt_awake\n");
-			mci_hw->bt_state = MCI_BT_AWAKE;
-			/* MCI FIX: enable mci interrupt here */
-			ar9003_mci_enable_interrupt(ah);
-
-			return true;
-		}
+		start_mci_reset = ar9003_mci_start_reset(ah, chan);
+		if (start_mci_reset)
+			return 0;
 	}
 
-
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
@@ -1609,7 +1570,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		if (ath9k_hw_channel_change(ah, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
 			ath9k_hw_start_nfcal(ah, true);
-			if (mci && mci_hw->ready)
+			if (mci && ar9003_mci_is_ready(ah))
 				ar9003_mci_2g5g_switch(ah, true);
 
 			if (AR_SREV_9271(ah))
@@ -1618,19 +1579,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		}
 	}
 
-	if (mci) {
-		ar9003_mci_disable_interrupt(ah);
-
-		if (mci_hw->ready && !save_fullsleep) {
-			ar9003_mci_mute_bt(ah);
-			udelay(20);
-			REG_WRITE(ah, AR_BTCOEX_CTRL, 0);
-		}
-
-		mci_hw->bt_state = MCI_BT_SLEEP;
-		mci_hw->ready = false;
-	}
-
+	if (mci)
+		ar9003_mci_stop_bt(ah, save_fullsleep);
 
 	saveDefAntenna = REG_READ(ah, AR_DEF_ANTENNA);
 	if (saveDefAntenna == 0)
@@ -1807,53 +1757,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_loadnf(ah, chan);
 	ath9k_hw_start_nfcal(ah, true);
 
-	if (mci && mci_hw->ready) {
-
-		if (IS_CHAN_2GHZ(chan) &&
-		    (mci_hw->bt_state == MCI_BT_SLEEP)) {
-
-			if (ar9003_mci_check_int(ah,
-			    AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET) ||
-			    ar9003_mci_check_int(ah,
-			    AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE)) {
-
-				/*
-				 * BT is sleeping. Check if BT wakes up during
-				 * WLAN calibration. If BT wakes up during
-				 * WLAN calibration, need to go through all
-				 * message exchanges again and recal.
-				 */
-
-				ath_dbg(common, MCI,
-					"MCI BT wakes up during WLAN calibration\n");
-
-				REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_RAW,
-					  AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET |
-					  AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE);
-				ath_dbg(common, MCI, "MCI send REMOTE_RESET\n");
-				ar9003_mci_remote_reset(ah, true);
-				ar9003_mci_send_sys_waking(ah, true);
-				udelay(1);
-				if (IS_CHAN_2GHZ(chan))
-					ar9003_mci_send_lna_transfer(ah, true);
-
-				mci_hw->bt_state = MCI_BT_AWAKE;
-
-				ath_dbg(common, MCI, "MCI re-cal\n");
-
-				if (caldata) {
-					caldata->done_txiqcal_once = false;
-					caldata->done_txclcal_once = false;
-					caldata->rtt_hist.num_readings = 0;
-				}
-
-				if (!ath9k_hw_init_cal(ah, chan))
-					return -EIO;
-
-			}
-		}
-		ar9003_mci_enable_interrupt(ah);
-	}
+	if (mci && ar9003_mci_end_reset(ah, chan, caldata))
+		return -EIO;
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
@@ -1898,20 +1803,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE)
 		ath9k_hw_btcoex_enable(ah);
 
-	if (mci && mci_hw->ready) {
-		/*
-		 * check BT state again to make
-		 * sure it's not changed.
-		 */
-
-		ar9003_mci_sync_bt_state(ah);
-		ar9003_mci_2g5g_switch(ah, true);
-
-		if ((mci_hw->bt_state == MCI_BT_AWAKE) &&
-				(mci_hw->query_bt == true)) {
-			mci_hw->need_flush_btinfo = true;
-		}
-	}
+	if (mci)
+		ar9003_mci_check_bt(ah);
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ar9003_hw_bb_watchdog_config(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b3e8415..1b41d11 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1208,6 +1208,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
 bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
 			     u32 *payload, u8 len, bool wait_done,
 			     bool check_bt);
+void ar9003_mci_stop_bt(struct ath_hw *ah, bool sava_fullsleep);
 void ar9003_mci_mute_bt(struct ath_hw *ah);
 u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data);
 void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
@@ -1224,6 +1225,10 @@ void ar9003_mci_set_full_sleep(struct ath_hw *ah);
 void ar9003_mci_disable_interrupt(struct ath_hw *ah);
 void ar9003_mci_enable_interrupt(struct ath_hw *ah);
 void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done);
+void ar9003_mci_check_bt(struct ath_hw *ah);
+bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan);
+int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+			 struct ath9k_hw_cal_data *caldata);
 void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		      bool is_full_sleep);
 bool ar9003_mci_check_int(struct ath_hw *ah, u32 ints);
@@ -1235,6 +1240,11 @@ void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 			      u32 *rx_msg_intr);
 void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
 
+static inline bool ar9003_mci_is_ready(struct ath_hw *ah)
+{
+	return ah->btcoex_hw.mci.ready;
+}
+
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 static inline enum ath_btcoex_scheme
 ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
-- 
1.7.9.1

