Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54682 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 03/15] ath9k_hw: change the way we initialize the pll for ar9271
Date: Mon, 19 Oct 2009 02:33:34 -0400
Message-Id: <1255934026-20686-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We adjust the core clock for ar9271 to 117 MHz; this also
requires us to adjust the baud divider based on the targetted
baud rate.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   36 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/reg.h |    3 ++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6df00ab..f67d3a4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1040,6 +1040,22 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
 }
 
+static void ath9k_hw_change_target_baud(struct ath_hw *ah, u32 freq, u32 baud)
+{
+	u32 lcr;
+	u32 baud_divider = freq * 1000 * 1000 / 16 / baud;
+
+	lcr = REG_READ(ah , 0x5100c);
+	lcr |= 0x80;
+
+	REG_WRITE(ah, 0x5100c, lcr);
+	REG_WRITE(ah, 0x51004, (baud_divider >> 8));
+	REG_WRITE(ah, 0x51000, (baud_divider & 0xff));
+
+	lcr &= ~0x80;
+	REG_WRITE(ah, 0x5100c, lcr);
+}
+
 static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
@@ -1103,6 +1119,26 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 	}
 	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
 
+	/* Switch the core clock for ar9271 to 117Mhz */
+	if (AR_SREV_9271(ah)) {
+		if ((pll == 0x142c) || (pll == 0x2850) ) {
+			udelay(500);
+			/* set CLKOBS to output AHB clock */
+			REG_WRITE(ah, 0x7020, 0xe);
+			/*
+			 * 0x304: 117Mhz, ahb_ratio: 1x1
+			 * 0x306: 40Mhz, ahb_ratio: 1x1
+			 */
+			REG_WRITE(ah, 0x50040, 0x304);
+			/*
+			 * makes adjustments for the baud dividor to keep the
+			 * targetted baud rate based on the used core clock.
+			 */
+			ath9k_hw_change_target_baud(ah, AR9271_CORE_CLOCK,
+						    AR9271_TARGET_BAUD_RATE);
+		}
+	}
+
 	udelay(RTC_PLL_SETTLE_DELAY);
 
 	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index ceed009..061e12c 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1704,4 +1704,7 @@ enum {
 #define AR_KEYTABLE_MAC0(_n)    (AR_KEYTABLE(_n) + 24)
 #define AR_KEYTABLE_MAC1(_n)    (AR_KEYTABLE(_n) + 28)
 
+#define AR9271_CORE_CLOCK	117   /* clock to 117Mhz */
+#define AR9271_TARGET_BAUD_RATE	19200 /* 115200 */
+
 #endif
-- 
1.6.0.4

