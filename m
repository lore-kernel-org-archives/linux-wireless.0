Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50545 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2FKGtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 02:49:20 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 7/9] ath9k_hw: process MCI interrupts only when btcoex is enabled
Date: Mon, 11 Jun 2012 12:19:35 +0530
Message-ID: <1339397377-3374-7-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120611_084922_872565_C3230A56)
In-Reply-To: <1339397377-3374-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339397377-3374-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

let us process MCI interrupts only when BTCOEX is enabled to avoid
processing bogus interrupts.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index d9e0824..78816b8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -181,11 +181,14 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	u32 mask2 = 0;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
-	u32 sync_cause = 0, async_cause;
+	u32 sync_cause = 0, async_cause, async_mask = AR_INTR_MAC_IRQ;
+
+	if (ath9k_hw_mci_is_enabled(ah))
+		async_mask |= AR_INTR_ASYNC_MASK_MCI;
 
 	async_cause = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
 
-	if (async_cause & (AR_INTR_MAC_IRQ | AR_INTR_ASYNC_MASK_MCI)) {
+	if (async_cause & async_mask) {
 		if ((REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M)
 				== AR_RTC_STATUS_ON)
 			isr = REG_READ(ah, AR_ISR);
-- 
1.7.10.4

