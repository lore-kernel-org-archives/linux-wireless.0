Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4465 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2FLOsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 10:48:06 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 6/8] ath9k_hw: remove MCI_STATE_BT
Date: Tue, 12 Jun 2012 20:18:21 +0530
Message-ID: <1339512503-26670-7-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120612_164810_063443_A81CCA8A)
In-Reply-To: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove MCI_STATE_BT and use bt_state instead.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |    3 ---
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 -
 drivers/net/wireless/ath/ath9k/mci.c        |   15 ++++++---------
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index d6e90f5..1508500 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1200,9 +1200,6 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 	case MCI_STATE_CONT_TXRX:
 		value = MS(mci->cont_status, AR_MCI_CONT_TXRX);
 		break;
-	case MCI_STATE_BT:
-		value = mci->bt_state;
-		break;
 	case MCI_STATE_SET_BT_SLEEP:
 		mci->bt_state = MCI_BT_SLEEP;
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 697a56c..0c02bd8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -189,7 +189,6 @@ enum mci_bt_state {
 /* Type of state query */
 enum mci_state_type {
 	MCI_STATE_ENABLE,
-	MCI_STATE_BT,
 	MCI_STATE_SET_BT_SLEEP,
 	MCI_STATE_SET_BT_AWAKE,
 	MCI_STATE_SET_BT_CAL_START,
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 61a68e8..1564548 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -195,20 +195,16 @@ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
 	u32 payload[4] = {0, 0, 0, 0};
 
 	switch (opcode) {
 	case MCI_GPM_BT_CAL_REQ:
-		if (ar9003_mci_state(ah, MCI_STATE_BT) == MCI_BT_AWAKE) {
+		if (mci_hw->bt_state == MCI_BT_AWAKE) {
 			ar9003_mci_state(ah, MCI_STATE_SET_BT_CAL_START);
 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
-		} else {
-			ath_dbg(common, MCI, "MCI State mismatch: %d\n",
-				ar9003_mci_state(ah, MCI_STATE_BT));
 		}
-		break;
-	case MCI_GPM_BT_CAL_DONE:
-		ar9003_mci_state(ah, MCI_STATE_BT);
+		ath_dbg(common, MCI, "MCI State : %d\n", mci_hw->bt_state);
 		break;
 	case MCI_GPM_BT_CAL_GRANT:
 		MCI_GPM_SET_CAL_TYPE(payload, MCI_GPM_WLAN_CAL_DONE);
@@ -407,6 +403,7 @@ void ath_mci_intr(struct ath_softc *sc)
 	struct ath_mci_coex *mci = &sc->mci_coex;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
 	u32 mci_int, mci_int_rxmsg;
 	u32 offset, subtype, opcode;
 	u32 *pgpm;
@@ -446,7 +443,7 @@ void ath_mci_intr(struct ath_softc *sc)
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING) {
 		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING;
 
-		if ((ar9003_mci_state(ah, MCI_STATE_BT) == MCI_BT_SLEEP) &&
+		if ((mci_hw->bt_state == MCI_BT_SLEEP) &&
 		    (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP) !=
 		     MCI_BT_SLEEP))
 			ar9003_mci_state(ah, MCI_STATE_SET_BT_AWAKE);
@@ -455,7 +452,7 @@ void ath_mci_intr(struct ath_softc *sc)
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING) {
 		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING;
 
-		if ((ar9003_mci_state(ah, MCI_STATE_BT) == MCI_BT_AWAKE) &&
+		if ((mci_hw->bt_state == MCI_BT_AWAKE) &&
 		    (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP) !=
 		     MCI_BT_AWAKE))
 			ar9003_mci_state(ah, MCI_STATE_SET_BT_SLEEP);
-- 
1.7.10.4

