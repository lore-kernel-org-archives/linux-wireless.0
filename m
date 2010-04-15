Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab0DOVjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 29/97] ath9k_hw: Implement PLL control on AR9003
Date: Thu, 15 Apr 2010 17:38:34 -0400
Message-Id: <1271367582-992-30-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   23 +++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/reg.h        |    6 ++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index f1632ab..9767265 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -112,8 +112,27 @@ static void ar9003_hw_spur_mitigate(struct ath_hw *ah,
 static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
-	/* TODO */
-	return 0;
+	u32 pll;
+
+	pll = SM(0x5, AR_RTC_9300_PLL_REFDIV);
+
+	if (chan && IS_CHAN_HALF_RATE(chan))
+		pll |= SM(0x1, AR_RTC_9300_PLL_CLKSEL);
+	else if (chan && IS_CHAN_QUARTER_RATE(chan))
+		pll |= SM(0x2, AR_RTC_9300_PLL_CLKSEL);
+
+	if (chan && IS_CHAN_5GHZ(chan)) {
+		pll |= SM(0x28, AR_RTC_9300_PLL_DIV);
+
+		/*
+		 * When doing fast clock, set PLL to 0x142c
+		 */
+		if (IS_CHAN_A_5MHZ_SPACED(chan))
+			pll = 0x142c;
+	} else
+		pll |= SM(0x2c, AR_RTC_9300_PLL_DIV);
+
+	return pll;
 }
 
 static void ar9003_hw_set_channel_regs(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index bc48bc9..9d63286 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1040,6 +1040,12 @@ enum {
 #define AR_PCIE_MSI                              (AR_SREV_9300_20_OR_LATER(ah) ? 0x40a4 : 0x4094)
 #define AR_PCIE_MSI_ENABLE                       0x00000001
 
+#define AR_RTC_9300_PLL_DIV          0x000003ff
+#define AR_RTC_9300_PLL_DIV_S        0
+#define AR_RTC_9300_PLL_REFDIV       0x00003C00
+#define AR_RTC_9300_PLL_REFDIV_S     10
+#define AR_RTC_9300_PLL_CLKSEL       0x0000C000
+#define AR_RTC_9300_PLL_CLKSEL_S     14
 
 #define AR_RTC_9160_PLL_DIV	0x000003ff
 #define AR_RTC_9160_PLL_DIV_S   0
-- 
1.6.3.3

