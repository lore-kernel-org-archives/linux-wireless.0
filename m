Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:10254 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab1A0JPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 04:15:23 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 01:15:03 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: [PATCH 1/5] ath9k_hw: Add a function to read sqsum_dvc.
Date: Thu, 27 Jan 2011 14:45:07 +0530
Message-ID: <1296119711-4024-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a function to observe the delta VC of BB_PLL.
For a good chip, the sqsum_dvc is below 2000.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   13 +++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/reg.h |    6 ++++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4615fd9..baa2977 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -671,6 +671,19 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
+unsigned long ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
+{
+		REG_WRITE(ah, PLL3, (REG_READ(ah, PLL3) & ~(PLL3_DO_MEAS_MASK)));
+		udelay(100);
+		REG_WRITE(ah, PLL3, (REG_READ(ah, PLL3) | PLL3_DO_MEAS_MASK));
+
+		while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) == 0)
+			udelay(100);
+
+		return (REG_READ(ah, PLL3) & SQSUM_DVC_MASK) >> 3;
+}
+EXPORT_SYMBOL(ar9003_get_pll_sqsum_dvc);
+
 static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ad8c2c7..ef79f4c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -929,6 +929,7 @@ void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
 void ath9k_hw_init_global_settings(struct ath_hw *ah);
+unsigned long ar9003_get_pll_sqsum_dvc(struct ath_hw *ah);
 void ath9k_hw_set11nmac2040(struct ath_hw *ah);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 4df5659..264aea7 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1129,6 +1129,12 @@ enum {
 #define AR_RTC_PLL_CLKSEL       0x00000300
 #define AR_RTC_PLL_CLKSEL_S     8
 
+#define PLL3 0x16188
+#define PLL3_DO_MEAS_MASK 0x40000000
+#define PLL4 0x1618c
+#define PLL4_MEAS_DONE    0x8
+#define SQSUM_DVC_MASK 0x007ffff8
+
 #define AR_RTC_RESET \
 	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0040) : 0x7040)
 #define AR_RTC_RESET_EN		(0x00000001)
-- 
1.6.3.3

