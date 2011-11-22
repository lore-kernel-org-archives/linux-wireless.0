Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25206 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab1KVQ0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 11:26:19 -0500
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
Subject: [PATCH 07/18] ath9k_hw: take care of enabling MCI interrupts
Date: Tue, 22 Nov 2011 21:52:34 +0530
Message-ID: <1321978965-21684-8-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111122_172627_429993_182044AD)
In-Reply-To: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

enable MCI interrupt when ath9k_hw_enable_interrupts is called,
like during the completion of chip_reset before which the interrupts
are disabled

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index ecdb6fd..9d69320 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -798,6 +798,7 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 sync_default = AR_INTR_SYNC_DEFAULT;
+	u32 async_mask;
 
 	if (!(ah->imask & ATH9K_INT_GLOBAL))
 		return;
@@ -812,13 +813,16 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 	if (AR_SREV_9340(ah))
 		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
 
+	async_mask = AR_INTR_MAC_IRQ;
+
+	if (ah->imask & ATH9K_INT_MCI)
+		async_mask |= AR_INTR_ASYNC_MASK_MCI;
+
 	ath_dbg(common, ATH_DBG_INTERRUPT, "enable IER\n");
 	REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
 	if (!AR_SREV_9100(ah)) {
-		REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
-			  AR_INTR_MAC_IRQ);
-		REG_WRITE(ah, AR_INTR_ASYNC_MASK, AR_INTR_MAC_IRQ);
-
+		REG_WRITE(ah, AR_INTR_ASYNC_ENABLE, async_mask);
+		REG_WRITE(ah, AR_INTR_ASYNC_MASK, async_mask);
 
 		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, sync_default);
 		REG_WRITE(ah, AR_INTR_SYNC_MASK, sync_default);
-- 
1.7.0.4

