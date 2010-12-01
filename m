Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13839 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab0LAHeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:34:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:33:53 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/26] ath9k: Configure pll control for AR9485
Date: Tue, 30 Nov 2010 23:32:39 -0800
Message-ID: <1291188775-13707-11-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   16 ++++++++++------
 drivers/net/wireless/ath/ath9k/hw.c         |    7 ++++++-
 drivers/net/wireless/ath/ath9k/reg.h        |    2 ++
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index b34a9e9..4e35bda 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -390,14 +390,18 @@ static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
 {
 	u32 pll;
 
-	pll = SM(0x5, AR_RTC_9300_PLL_REFDIV);
+	if (AR_SREV_9485(ah))
+		pll = 0x142c;
+	else {
+		pll = SM(0x5, AR_RTC_9300_PLL_REFDIV);
 
-	if (chan && IS_CHAN_HALF_RATE(chan))
-		pll |= SM(0x1, AR_RTC_9300_PLL_CLKSEL);
-	else if (chan && IS_CHAN_QUARTER_RATE(chan))
-		pll |= SM(0x2, AR_RTC_9300_PLL_CLKSEL);
+		if (chan && IS_CHAN_HALF_RATE(chan))
+			pll |= SM(0x1, AR_RTC_9300_PLL_CLKSEL);
+		else if (chan && IS_CHAN_QUARTER_RATE(chan))
+			pll |= SM(0x2, AR_RTC_9300_PLL_CLKSEL);
 
-	pll |= SM(0x2c, AR_RTC_9300_PLL_DIV);
+		pll |= SM(0x2c, AR_RTC_9300_PLL_DIV);
+	}
 
 	return pll;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b1d3c1e..79a4e70 100644
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

