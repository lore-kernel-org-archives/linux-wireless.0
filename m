Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab0CMFrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 00:47:03 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 10/12] ath9k_hw: always set the core clock for AR9271
Date: Sat, 13 Mar 2010 00:46:54 -0500
Message-Id: <1268459216-22372-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

When initializing the PLL on AR9271 we always need
to set the core clock to 117MHz. While at it remove
the baud rate settings for the serial device on the
AR9271, the default settings work well unless you
want to customize it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   34 ++--------------------------------
 1 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 20392cf..0b1737f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1006,22 +1006,6 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
 }
 
-static void ath9k_hw_change_target_baud(struct ath_hw *ah, u32 freq, u32 baud)
-{
-	u32 lcr;
-	u32 baud_divider = freq * 1000 * 1000 / 16 / baud;
-
-	lcr = REG_READ(ah , 0x5100c);
-	lcr |= 0x80;
-
-	REG_WRITE(ah, 0x5100c, lcr);
-	REG_WRITE(ah, 0x51004, (baud_divider >> 8));
-	REG_WRITE(ah, 0x51000, (baud_divider & 0xff));
-
-	lcr &= ~0x80;
-	REG_WRITE(ah, 0x5100c, lcr);
-}
-
 static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
@@ -1087,22 +1071,8 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 
 	/* Switch the core clock for ar9271 to 117Mhz */
 	if (AR_SREV_9271(ah)) {
-		if ((pll == 0x142c) || (pll == 0x2850) ) {
-			udelay(500);
-			/* set CLKOBS to output AHB clock */
-			REG_WRITE(ah, 0x7020, 0xe);
-			/*
-			 * 0x304: 117Mhz, ahb_ratio: 1x1
-			 * 0x306: 40Mhz, ahb_ratio: 1x1
-			 */
-			REG_WRITE(ah, 0x50040, 0x304);
-			/*
-			 * makes adjustments for the baud dividor to keep the
-			 * targetted baud rate based on the used core clock.
-			 */
-			ath9k_hw_change_target_baud(ah, AR9271_CORE_CLOCK,
-						    AR9271_TARGET_BAUD_RATE);
-		}
+		udelay(500);
+		REG_WRITE(ah, 0x50040, 0x304);
 	}
 
 	udelay(RTC_PLL_SETTLE_DELAY);
-- 
1.6.3.3

