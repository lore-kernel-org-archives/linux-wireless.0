Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8648 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab2IJGE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 02:04:26 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 1/3] ath9k_hw: Wait BT calibration to complete
Date: Mon, 10 Sep 2012 17:05:09 +0530
Message-ID: <1347276911-1993-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120910_080430_045158_1ED25EE8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever BT calibration requested, WLAN has to wait for the
calibration to be completed. But right now we defer the waiting
which might cause BT calibration to fail. Fix that.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  1 +
 drivers/net/wireless/ath/ath9k/debug.h      |  1 -
 drivers/net/wireless/ath/ath9k/mci.c        | 19 ++++++++++++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index ff53091..fbc96d0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -714,6 +714,7 @@ bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	return true;
 }
+EXPORT_SYMBOL(ar9003_mci_start_reset);
 
 int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 			 struct ath9k_hw_cal_data *caldata)
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 8b9d080..f80c466 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -41,7 +41,6 @@ enum ath_reset_type {
 	RESET_TYPE_PLL_HANG,
 	RESET_TYPE_MAC_HANG,
 	RESET_TYPE_BEACON_STUCK,
-	RESET_TYPE_MCI,
 	__RESET_TYPE_MAX
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 9ee1f89..8f0e8d9 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -191,6 +191,23 @@ skip_tuning:
 	ath9k_btcoex_timer_resume(sc);
 }
 
+static void ath_mci_wait_btcal_done(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	/* Stop tx & rx */
+	ieee80211_stop_queues(sc->hw);
+	ath_stoprecv(sc);
+	ath_drain_all_txq(sc, false);
+
+	/* Wait for cal done */
+	ar9003_mci_start_reset(ah, ah->curchan);
+
+	/* Resume tx & rx */
+	ath_startrecv(sc);
+	ieee80211_wake_queues(sc->hw);
+}
+
 static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -202,7 +219,7 @@ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	case MCI_GPM_BT_CAL_REQ:
 		if (mci_hw->bt_state == MCI_BT_AWAKE) {
 			mci_hw->bt_state = MCI_BT_CAL_START;
-			ath9k_queue_reset(sc, RESET_TYPE_MCI);
+			ath_mci_wait_btcal_done(sc);
 		}
 		ath_dbg(common, MCI, "MCI State : %d\n", mci_hw->bt_state);
 		break;
-- 
1.7.12

