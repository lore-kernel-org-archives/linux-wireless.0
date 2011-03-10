Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51176 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1CJFfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 00:35:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 21:35:30 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k_hw: Fix PLL initialization for AR9485.
Date: Thu, 10 Mar 2011 11:05:42 +0530
Message-ID: <1299735343-915-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1299735343-915-1-git-send-email-vnatarajan@atheros.com>
References: <1299735343-915-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increase the delay to make sure the initialization of pll
passes.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9a34381..338b075 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -701,7 +701,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
 
 		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x1142c);
-		udelay(100);
+		udelay(1000);
 
 		REG_WRITE(ah, AR_RTC_PLL_CONTROL2, 0x886666);
 
@@ -713,7 +713,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
 			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
 		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x142c);
-		udelay(110);
+		udelay(1000);
 	}
 
 	pll = ath9k_hw_compute_pll_control(ah, chan);
-- 
1.6.3.3

