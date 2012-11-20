Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:19106 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab2KTNAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 08:00:06 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/3] ath9k: Fix MCI reset in BT cal_req
Date: Tue, 20 Nov 2012 18:30:00 +0530
Message-ID: <1353416401-5328-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121120_140021_952130_E4AD2A77)
In-Reply-To: <1353416401-5328-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1353416401-5328-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reverts the commit "ath9k_hw: Wait BT calibration to complete"
and bail out from MCI interrupt routine for chip reset. The above commit
stalls the WLAN TCP traffic while bringing up and down the BT interface
iteratively. Fixing this properly by queueing up chip reset and bailing
out properly from tasklet routine.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  1 -
 drivers/net/wireless/ath/ath9k/debug.c      |  3 +++
 drivers/net/wireless/ath/ath9k/debug.h      |  1 +
 drivers/net/wireless/ath/ath9k/mci.c        | 21 +++------------------
 4 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 42b4412..8dd0692 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -714,7 +714,6 @@ bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	return true;
 }
-EXPORT_SYMBOL(ar9003_mci_start_reset);
 
 int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 			 struct ath9k_hw_cal_data *caldata)
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 585aee4..eed0b9a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -837,6 +837,9 @@ static ssize_t read_file_reset(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%17s: %2d\n", "PLL RX Hang",
 			sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%17s: %2d\n", "MCI Reset",
+			sc->debug.stats.reset[RESET_TYPE_MCI]);
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 2ed9785..61341cd 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -41,6 +41,7 @@ enum ath_reset_type {
 	RESET_TYPE_PLL_HANG,
 	RESET_TYPE_MAC_HANG,
 	RESET_TYPE_BEACON_STUCK,
+	RESET_TYPE_MCI,
 	__RESET_TYPE_MAX
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 0dd2cbb..ece192d 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -207,23 +207,6 @@ skip_tuning:
 	ath9k_btcoex_timer_resume(sc);
 }
 
-static void ath_mci_wait_btcal_done(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-
-	/* Stop tx & rx */
-	ieee80211_stop_queues(sc->hw);
-	ath_stoprecv(sc);
-	ath_drain_all_txq(sc, false);
-
-	/* Wait for cal done */
-	ar9003_mci_start_reset(ah, ah->curchan);
-
-	/* Resume tx & rx */
-	ath_startrecv(sc);
-	ieee80211_wake_queues(sc->hw);
-}
-
 static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -235,7 +218,7 @@ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	case MCI_GPM_BT_CAL_REQ:
 		if (mci_hw->bt_state == MCI_BT_AWAKE) {
 			mci_hw->bt_state = MCI_BT_CAL_START;
-			ath_mci_wait_btcal_done(sc);
+			ath9k_queue_reset(sc, RESET_TYPE_MCI);
 		}
 		ath_dbg(common, MCI, "MCI State : %d\n", mci_hw->bt_state);
 		break;
@@ -578,6 +561,8 @@ void ath_mci_intr(struct ath_softc *sc)
 		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_GPM;
 
 		while (more_data == MCI_GPM_MORE) {
+			if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+				return;
 
 			pgpm = mci->gpm_buf.bf_addr;
 			offset = ar9003_mci_get_next_gpm_offset(ah, false,
-- 
1.8.0

