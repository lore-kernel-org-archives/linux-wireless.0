Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57276 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab1DSN7q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:59:46 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 06:59:20 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 21/22] ath9k_hw: Disable INTR_HOST1_FATAL to avoid interrupt strom with ar9430
Date: Tue, 19 Apr 2011 19:29:19 +0530
Message-ID: <1303221560-25139-22-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
References: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    6 +++++-
 drivers/net/wireless/ath/ath9k/mac.c |   10 ++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c725640..b780f6f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -793,12 +793,16 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 					  enum nl80211_iftype opmode)
 {
+	u32 sync_default = AR_INTR_SYNC_DEFAULT;
 	u32 imr_reg = AR_IMR_TXERR |
 		AR_IMR_TXURN |
 		AR_IMR_RXERR |
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
+	if (AR_SREV_9340(ah))
+		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
+
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		imr_reg |= AR_IMR_RXOK_HP;
 		if (ah->config.rx_intr_mitigation)
@@ -829,7 +833,7 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 
 	if (!AR_SREV_9100(ah)) {
 		REG_WRITE(ah, AR_INTR_SYNC_CAUSE, 0xFFFFFFFF);
-		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, AR_INTR_SYNC_DEFAULT);
+		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, sync_default);
 		REG_WRITE(ah, AR_INTR_SYNC_MASK, 0);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 1968c67..c8a4ced 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -812,10 +812,14 @@ EXPORT_SYMBOL(ath9k_hw_disable_interrupts);
 void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	u32 sync_default = AR_INTR_SYNC_DEFAULT;
 
 	if (!(ah->imask & ATH9K_INT_GLOBAL))
 		return;
 
+	if (AR_SREV_9340(ah))
+		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
+
 	ath_dbg(common, ATH_DBG_INTERRUPT, "enable IER\n");
 	REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
 	if (!AR_SREV_9100(ah)) {
@@ -824,10 +828,8 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 		REG_WRITE(ah, AR_INTR_ASYNC_MASK, AR_INTR_MAC_IRQ);
 
 
-		REG_WRITE(ah, AR_INTR_SYNC_ENABLE,
-			  AR_INTR_SYNC_DEFAULT);
-		REG_WRITE(ah, AR_INTR_SYNC_MASK,
-			  AR_INTR_SYNC_DEFAULT);
+		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, sync_default);
+		REG_WRITE(ah, AR_INTR_SYNC_MASK, sync_default);
 	}
 	ath_dbg(common, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
 		REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
-- 
1.7.0.4

