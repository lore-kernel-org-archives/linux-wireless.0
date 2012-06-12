Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4486 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2FLOsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 10:48:16 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 7/8] ath9k_hw: remove MCI_STATE_CONT_* state
Date: Tue, 12 Jun 2012 20:18:22 +0530
Message-ID: <1339512503-26670-8-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120612_164822_856863_95B85DFD)
In-Reply-To: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |    9 ---------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |    3 ---
 drivers/net/wireless/ath/ath9k/mci.c        |   22 ++++++++--------------
 drivers/net/wireless/ath/ath9k/reg.h        |    4 ++--
 4 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 1508500..25f99ef 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1191,15 +1191,6 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 			   AR_MCI_RX_REMOTE_SLEEP) ?
 			MCI_BT_SLEEP : MCI_BT_AWAKE;
 		break;
-	case MCI_STATE_CONT_RSSI_POWER:
-		value = MS(mci->cont_status, AR_MCI_CONT_RSSI_POWER);
-		break;
-	case MCI_STATE_CONT_PRIORITY:
-		value = MS(mci->cont_status, AR_MCI_CONT_RRIORITY);
-		break;
-	case MCI_STATE_CONT_TXRX:
-		value = MS(mci->cont_status, AR_MCI_CONT_TXRX);
-		break;
 	case MCI_STATE_SET_BT_SLEEP:
 		mci->bt_state = MCI_BT_SLEEP;
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 0c02bd8..98bfc62 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -195,9 +195,6 @@ enum mci_state_type {
 	MCI_STATE_SET_BT_CAL,
 	MCI_STATE_LAST_SCHD_MSG_OFFSET,
 	MCI_STATE_REMOTE_SLEEP,
-	MCI_STATE_CONT_RSSI_POWER,
-	MCI_STATE_CONT_PRIORITY,
-	MCI_STATE_CONT_TXRX,
 	MCI_STATE_RESET_REQ_WAKE,
 	MCI_STATE_SEND_WLAN_COEX_VERSION,
 	MCI_STATE_SEND_VERSION_QUERY,
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 1564548..e83d720 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -517,23 +517,17 @@ void ath_mci_intr(struct ath_softc *sc)
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_LNA_INFO;
 
 		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_INFO) {
-			int value_dbm = ar9003_mci_state(ah,
-						 MCI_STATE_CONT_RSSI_POWER);
+			int value_dbm = MS(mci_hw->cont_status,
+					   AR_MCI_CONT_RSSI_POWER);
 
 			mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_CONT_INFO;
 
-			if (ar9003_mci_state(ah, MCI_STATE_CONT_TXRX))
-				ath_dbg(common, MCI,
-					"MCI CONT_INFO: (tx) pri = %d, pwr = %d dBm\n",
-					ar9003_mci_state(ah,
-						 MCI_STATE_CONT_PRIORITY),
-					value_dbm);
-			else
-				ath_dbg(common, MCI,
-					"MCI CONT_INFO: (rx) pri = %d,pwr = %d dBm\n",
-					ar9003_mci_state(ah,
-						 MCI_STATE_CONT_PRIORITY),
-					value_dbm);
+			ath_dbg(common, MCI,
+				"MCI CONT_INFO: (%s) pri = %d pwr = %d dBm\n",
+				MS(mci_hw->cont_status, AR_MCI_CONT_TXRX) ?
+				"tx" : "rx",
+				MS(mci_hw->cont_status, AR_MCI_CONT_PRIORITY),
+				value_dbm);
 		}
 
 		if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_CONT_NACK)
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 560d6ef..75acefb 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -2098,8 +2098,8 @@ enum {
 #define AR_MCI_CONT_STATUS			0x1848
 #define AR_MCI_CONT_RSSI_POWER			0x000000FF
 #define AR_MCI_CONT_RSSI_POWER_S		0
-#define AR_MCI_CONT_RRIORITY			0x0000FF00
-#define AR_MCI_CONT_RRIORITY_S			8
+#define AR_MCI_CONT_PRIORITY			0x0000FF00
+#define AR_MCI_CONT_PRIORITY_S			8
 #define AR_MCI_CONT_TXRX			0x00010000
 #define AR_MCI_CONT_TXRX_S			16
 
-- 
1.7.10.4

