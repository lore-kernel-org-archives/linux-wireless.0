Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59149 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab0LBLLv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:11:51 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:11:37 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 11/27] ath9k_hw: Configure pll control for AR9485
Date: Thu, 2 Dec 2010 03:06:55 -0800
Message-ID: <1291288031-3409-12-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    7 ++++++-
 drivers/net/wireless/ath/ath9k/reg.h |    2 ++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ddbd6fb..e3b6ad3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -676,7 +676,12 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
-	u32 pll = ath9k_hw_compute_pll_control(ah, chan);
+	u32 pll;
+
+	if (AR_SREV_9485(ah))
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL2, 0x886666);
+
+	pll = ath9k_hw_compute_pll_control(ah, chan);
 
 	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 0153ba1..d3257f7 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1114,6 +1114,8 @@ enum {
 #define AR_RTC_PLL_CONTROL \
 	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0014) : 0x7014)
 
+#define AR_RTC_PLL_CONTROL2	0x703c
+
 #define AR_RTC_PLL_DIV          0x0000001f
 #define AR_RTC_PLL_DIV_S        0
 #define AR_RTC_PLL_DIV2         0x00000020
-- 
1.7.0.4

