Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab1KOGGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:06:45 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
CC: Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 15/18] ath9k_hw: Add MCI related changes in chip reset
Date: Tue, 15 Nov 2011 11:35:27 +0530
Message-ID: <1321337127-12917-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111115_070650_284859_1BC7646F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

here we check for BT state and if BT calibration has started,
give 25ms for BT Calibration to finish. we also take care of 2G/5G
switch and LNA transfer incase WLAN is operating in 5G. in case the BT
state is awake when we do WLAN calibration re-calibrate and we reset
the message exchange between WLAN and BT. BT is given preference when
simultaneous CAL request happens. calibration for WLAN/BT is done
assuming that the other co-existing module is in awake state, if not
we continue to do calibration while if the other module's state changes
we need to do restart the calibration handshake

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |  132 +++++++++++++++++++++++++++++++++++
 1 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1d71d1b..e2860d7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1514,6 +1514,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   struct ath9k_hw_cal_data *caldata, bool bChannelChange)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
 	u32 saveLedState;
 	struct ath9k_channel *curchan = ah->curchan;
 	u32 saveDefAntenna;
@@ -1521,6 +1522,53 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u64 tsf = 0;
 	int i, r;
 	bool allow_fbs = false;
+	bool mci = !!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI);
+	bool save_fullsleep = ah->chip_fullsleep;
+
+	if (mci) {
+
+		ar9003_mci_2g5g_changed(ah, IS_CHAN_2GHZ(chan));
+
+		if (mci_hw->bt_state == MCI_BT_CAL_START) {
+			u32 payload[4] = {0, 0, 0, 0};
+
+			ath_dbg(common, ATH_DBG_MCI, "MCI stop rx for BT CAL");
+
+			mci_hw->bt_state = MCI_BT_CAL;
+
+			/*
+			 * MCI FIX: disable mci interrupt here. This is to avoid
+			 * SW_MSG_DONE or RX_MSG bits to trigger MCI_INT and
+			 * lead to mci_intr reentry.
+			 */
+
+			ar9003_mci_disable_interrupt(ah);
+
+			ath_dbg(common, ATH_DBG_MCI, "send WLAN_CAL_GRANT");
+			MCI_GPM_SET_CAL_TYPE(payload, MCI_GPM_WLAN_CAL_GRANT);
+			ar9003_mci_send_message(ah, MCI_GPM, 0, payload,
+						16, true, false);
+
+			ath_dbg(common, ATH_DBG_MCI, "\nMCI BT is calibrating");
+
+			/* Wait BT calibration to be completed for 25ms */
+
+			if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_DONE,
+								  0, 25000))
+				ath_dbg(common, ATH_DBG_MCI,
+					"MCI got BT_CAL_DONE\n");
+			else
+				ath_dbg(common, ATH_DBG_MCI,
+					"MCI ### BT cal takes to long, force"
+					"bt_state to be bt_awake\n");
+			mci_hw->bt_state = MCI_BT_AWAKE;
+			/* MCI FIX: enable mci interrupt here */
+			ar9003_mci_enable_interrupt(ah);
+
+			return true;
+		}
+	}
+
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
@@ -1558,12 +1606,29 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		if (ath9k_hw_channel_change(ah, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
 			ath9k_hw_start_nfcal(ah, true);
+			if (mci && mci_hw->ready)
+				ar9003_mci_2g5g_switch(ah, true);
+
 			if (AR_SREV_9271(ah))
 				ar9002_hw_load_ani_reg(ah, chan);
 			return 0;
 		}
 	}
 
+	if (mci) {
+		ar9003_mci_disable_interrupt(ah);
+
+		if (mci_hw->ready && !save_fullsleep) {
+			ar9003_mci_mute_bt(ah);
+			udelay(20);
+			REG_WRITE(ah, AR_BTCOEX_CTRL, 0);
+		}
+
+		mci_hw->bt_state = MCI_BT_SLEEP;
+		mci_hw->ready = false;
+	}
+
+
 	saveDefAntenna = REG_READ(ah, AR_DEF_ANTENNA);
 	if (saveDefAntenna == 0)
 		saveDefAntenna = 1;
@@ -1619,6 +1684,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (r)
 		return r;
 
+	if (mci)
+		ar9003_mci_reset(ah, false, IS_CHAN_2GHZ(chan), save_fullsleep);
+
 	/*
 	 * Some AR91xx SoC devices frequently fail to accept TSF writes
 	 * right after the chip reset. When that happens, write a new
@@ -1736,6 +1804,55 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_loadnf(ah, chan);
 	ath9k_hw_start_nfcal(ah, true);
 
+	if (mci && mci_hw->ready) {
+
+		if (IS_CHAN_2GHZ(chan) &&
+		    (mci_hw->bt_state == MCI_BT_SLEEP)) {
+
+			if (ar9003_mci_check_int(ah,
+			    AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET) ||
+			    ar9003_mci_check_int(ah,
+			    AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE)) {
+
+				/*
+				 * BT is sleeping. Check if BT wakes up during
+				 * WLAN calibration. If BT wakes up during
+				 * WLAN calibration, need to go through all
+				 * message exchanges again and recal.
+				 */
+
+				ath_dbg(common, ATH_DBG_MCI, "MCI BT wakes up"
+					"during WLAN calibration\n");
+
+				REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_RAW,
+					  AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET |
+					  AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE);
+				ath_dbg(common, ATH_DBG_MCI, "MCI send"
+					"REMOTE_RESET\n");
+				ar9003_mci_remote_reset(ah, true);
+				ar9003_mci_send_sys_waking(ah, true);
+				udelay(1);
+				if (IS_CHAN_2GHZ(chan))
+					ar9003_mci_send_lna_transfer(ah, true);
+
+				mci_hw->bt_state = MCI_BT_AWAKE;
+
+				ath_dbg(common, ATH_DBG_MCI, "MCI re-cal\n");
+
+				if (caldata) {
+					caldata->done_txiqcal_once = false;
+					caldata->done_txclcal_once = false;
+					caldata->rtt_hist.num_readings = 0;
+				}
+
+				if (!ath9k_hw_init_cal(ah, chan))
+					return -EIO;
+
+			}
+		}
+		ar9003_mci_enable_interrupt(ah);
+	}
+
 	ENABLE_REGWRITE_BUFFER(ah);
 
 	ath9k_hw_restore_chainmask(ah);
@@ -1778,6 +1895,21 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (ah->btcoex_hw.enabled)
 		ath9k_hw_btcoex_enable(ah);
 
+	if (mci && mci_hw->ready) {
+		/*
+		 * check BT state again to make
+		 * sure it's not changed.
+		 */
+
+		ar9003_mci_sync_bt_state(ah);
+		ar9003_mci_2g5g_switch(ah, true);
+
+		if ((mci_hw->bt_state == MCI_BT_AWAKE) &&
+				(mci_hw->query_bt == true)) {
+			mci_hw->need_flush_btinfo = true;
+		}
+	}
+
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ar9003_hw_bb_watchdog_config(ah);
 
-- 
1.7.0.4

