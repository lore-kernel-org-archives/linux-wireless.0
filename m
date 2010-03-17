Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26850 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab0CQV1V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 17:27:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:27:21 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 09/12] ath9k_hw: always set the core clock for AR9271
Date: Wed, 17 Mar 2010 14:25:22 +0530
Message-ID: <1268816125-16173-10-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1268816125-16173-9-git-send-email-senthilkumar@atheros.com>
References: <1268816125-16173-1-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-2-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-3-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-4-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-5-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-6-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-7-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-8-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-9-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index 023c38b..5bc5f5f 100644
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
1.6.4.2

