Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61546 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1KVQYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 11:24:18 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
Subject: [PATCH 09/18] ath9k_hw: check for MCI interrupt in get_isr
Date: Tue, 22 Nov 2011 21:52:36 +0530
Message-ID: <1321978965-21684-10-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111122_172420_811967_A9D35727)
In-Reply-To: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

check for the condition of MCI interrupt being triggered and
appropriately obtain the values of MCI_INTERRUPT_RX_MSG_RAW and
MCI_INTERRUPT_RAW

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   36 +++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index ccde784..95587e3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -175,15 +175,47 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	u32 isr = 0;
 	u32 mask2 = 0;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	u32 sync_cause = 0;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+	u32 sync_cause = 0, async_cause;
 
-	if (REG_READ(ah, AR_INTR_ASYNC_CAUSE) & AR_INTR_MAC_IRQ) {
+	async_cause = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
+
+	if (async_cause & (AR_INTR_MAC_IRQ | AR_INTR_ASYNC_MASK_MCI)) {
 		if ((REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M)
 				== AR_RTC_STATUS_ON)
 			isr = REG_READ(ah, AR_ISR);
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
 	sync_cause = REG_READ(ah, AR_INTR_SYNC_CAUSE) & AR_INTR_SYNC_DEFAULT;
 
 	*masked = 0;
-- 
1.7.0.4

