Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18507 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1LHG33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 01:29:29 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] ath9k_hw: Fix handling of MCI interrupt
Date: Thu, 8 Dec 2011 11:59:03 +0530
Message-ID: <1323325743-4005-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111208_072931_960395_F65868C7)
In-Reply-To: <1323325743-4005-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1323325743-4005-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

in my previous patches of handling MCI interrupt I overlooked
the case of interrupt status/mask variable being zeroed out in
the below code, so ath_isr does not cache the MCI interrupt
in the intrstatus. finally MCI interrupt handling won't be
handled in ath9k_tasklet for the scheduled interrupts.
Fix this by moving the MCI interrupt code in the appropriate
position in ar9003_hw_get_isr

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   57 ++++++++++++++-------------
 1 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 508c202..631fe4f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -187,34 +187,6 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 			isr = REG_READ(ah, AR_ISR);
 	}
 
-	if (async_cause & AR_INTR_ASYNC_MASK_MCI) {
-		u32 raw_intr, rx_msg_intr;
-
-		rx_msg_intr = REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_RAW);
-		raw_intr = REG_READ(ah, AR_MCI_INTERRUPT_RAW);
-
-		if ((raw_intr == 0xdeadbeef) || (rx_msg_intr == 0xdeadbeef))
-			ath_dbg(common, ATH_DBG_MCI,
-				"MCI gets 0xdeadbeef during MCI int processing"
-				"new raw_intr=0x%08x, new rx_msg_raw=0x%08x, "
-				"raw_intr=0x%08x, rx_msg_raw=0x%08x\n",
-				raw_intr, rx_msg_intr, mci->raw_intr,
-				mci->rx_msg_intr);
-		else {
-			mci->rx_msg_intr |= rx_msg_intr;
-			mci->raw_intr |= raw_intr;
-			*masked |= ATH9K_INT_MCI;
-
-			if (rx_msg_intr & AR_MCI_INTERRUPT_RX_MSG_CONT_INFO)
-				mci->cont_status =
-					REG_READ(ah, AR_MCI_CONT_STATUS);
-
-			REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_RAW, rx_msg_intr);
-			REG_WRITE(ah, AR_MCI_INTERRUPT_RAW, raw_intr);
-			ath_dbg(common, ATH_DBG_MCI, "AR_INTR_SYNC_MCI\n");
-
-		}
-	}
 
 	sync_cause = REG_READ(ah, AR_INTR_SYNC_CAUSE) & AR_INTR_SYNC_DEFAULT;
 
@@ -326,6 +298,35 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 			ar9003_hw_bb_watchdog_read(ah);
 	}
 
+	if (async_cause & AR_INTR_ASYNC_MASK_MCI) {
+		u32 raw_intr, rx_msg_intr;
+
+		rx_msg_intr = REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_RAW);
+		raw_intr = REG_READ(ah, AR_MCI_INTERRUPT_RAW);
+
+		if ((raw_intr == 0xdeadbeef) || (rx_msg_intr == 0xdeadbeef))
+			ath_dbg(common, ATH_DBG_MCI,
+				"MCI gets 0xdeadbeef during MCI int processing"
+				"new raw_intr=0x%08x, new rx_msg_raw=0x%08x, "
+				"raw_intr=0x%08x, rx_msg_raw=0x%08x\n",
+				raw_intr, rx_msg_intr, mci->raw_intr,
+				mci->rx_msg_intr);
+		else {
+			mci->rx_msg_intr |= rx_msg_intr;
+			mci->raw_intr |= raw_intr;
+			*masked |= ATH9K_INT_MCI;
+
+			if (rx_msg_intr & AR_MCI_INTERRUPT_RX_MSG_CONT_INFO)
+				mci->cont_status =
+					REG_READ(ah, AR_MCI_CONT_STATUS);
+
+			REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_RAW, rx_msg_intr);
+			REG_WRITE(ah, AR_MCI_INTERRUPT_RAW, raw_intr);
+			ath_dbg(common, ATH_DBG_MCI, "AR_INTR_SYNC_MCI\n");
+
+		}
+	}
+
 	if (sync_cause) {
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
-- 
1.7.0.4

