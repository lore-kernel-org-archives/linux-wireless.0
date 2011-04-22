Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35960 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1DVGCo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 02:02:44 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 23:02:17 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/5] ath9k_hw: Fix incorrect baseband PLL phase shift for AR9485
Date: Fri, 22 Apr 2011 11:32:09 +0530
Message-ID: <1303452132-5436-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1303452132-5436-1-git-send-email-senthilkumar@atheros.com>
References: <1303452132-5436-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we should program the AR9485 baseband PLL phase shift to 6 and
a redundant setting overwrites the correct value. Remove the
incorrect and unwnated register setting.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9a89855..289c03e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -686,7 +686,6 @@ unsigned long ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ar9003_get_pll_sqsum_dvc);
 
-#define DPLL3_PHASE_SHIFT_VAL 0x1
 static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
@@ -723,9 +722,6 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
 			      AR_CH0_BB_DPLL2_PLL_PWD, 0x0);
 		udelay(1000);
-
-		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
-			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
 	} else if (AR_SREV_9340(ah)) {
 		u32 regval, pll2_divint, pll2_divfrac, refdiv;
 
-- 
1.7.0.4

