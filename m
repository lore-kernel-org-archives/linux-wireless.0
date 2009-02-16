Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63181 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbZBPH5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 02:57:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 23:57:07 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18841.7016.772008.745034@gargle.gargle.HOWL> (sfid-20090216_085714_024420_FE4B0406)
Date: Mon, 16 Feb 2009 13:23:12 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/4] ath9k: Program the RTC registers correctly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch programs the RTC registers of AR9100 chipsets
correctly during chip reset.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c  |    8 ++++++++
 drivers/net/wireless/ath9k/reg.h |    8 ++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index e33c53f..1c02358 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1482,6 +1482,14 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	u32 rst_flags;
 	u32 tmpReg;
 
+	if (AR_SREV_9100(ah)) {
+		u32 val = REG_READ(ah, AR_RTC_DERIVED_CLK);
+		val &= ~AR_RTC_DERIVED_CLK_PERIOD;
+		val |= SM(1, AR_RTC_DERIVED_CLK_PERIOD);
+		REG_WRITE(ah, AR_RTC_DERIVED_CLK, val);
+		(void)REG_READ(ah, AR_RTC_DERIVED_CLK);
+	}
+
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index a471832..8d85106 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -977,8 +977,6 @@ enum {
 #define AR_RTC_PLL_CLKSEL       0x00000300
 #define AR_RTC_PLL_CLKSEL_S     8
 
-
-
 #define AR_RTC_RESET \
 	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0040) : 0x7040)
 #define AR_RTC_RESET_EN		(0x00000001)
@@ -1015,6 +1013,12 @@ enum {
 #define AR_RTC_INTR_MASK \
 	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0058) : 0x7058)
 
+/* RTC_DERIVED_* - only for AR9100 */
+
+#define AR_RTC_DERIVED_CLK           (AR_RTC_BASE + 0x0038)
+#define AR_RTC_DERIVED_CLK_PERIOD    0x0000fffe
+#define AR_RTC_DERIVED_CLK_PERIOD_S  1
+
 #define	AR_SEQ_MASK	0x8060
 
 #define AR_AN_RF2G1_CH0         0x7810
-- 
1.6.1

