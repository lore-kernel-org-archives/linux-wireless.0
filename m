Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0DZTEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:41 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 02/13] ath9k_hw: fix pll clock setting for 5ghz on AR9003
Date: Mon, 26 Apr 2010 15:04:30 -0400
Message-Id: <1272308681-32396-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 137543b..bf8ec68 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -375,16 +375,7 @@ static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
 	else if (chan && IS_CHAN_QUARTER_RATE(chan))
 		pll |= SM(0x2, AR_RTC_9300_PLL_CLKSEL);
 
-	if (chan && IS_CHAN_5GHZ(chan)) {
-		pll |= SM(0x28, AR_RTC_9300_PLL_DIV);
-
-		/*
-		 * When doing fast clock, set PLL to 0x142c
-		 */
-		if (IS_CHAN_A_5MHZ_SPACED(chan))
-			pll = 0x142c;
-	} else
-		pll |= SM(0x2c, AR_RTC_9300_PLL_DIV);
+	pll |= SM(0x2c, AR_RTC_9300_PLL_DIV);
 
 	return pll;
 }
-- 
1.6.3.3

