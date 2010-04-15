Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab0DODaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 62/97] ath9k_hw: Initialize interrupt mask for AR9003
Date: Wed, 14 Apr 2010 23:30:16 -0400
Message-Id: <1271302251-9075-63-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   29 ++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/reg.h |    5 +++++
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ab3a87b..b8ef2e1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -737,12 +737,24 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
-	if (ah->config.rx_intr_mitigation)
-		imr_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
-	else
-		imr_reg |= AR_IMR_RXOK;
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		imr_reg |= AR_IMR_RXOK_HP;
+		if (ah->config.rx_intr_mitigation)
+			imr_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
+		else
+			imr_reg |= AR_IMR_RXOK_LP;
 
-	imr_reg |= AR_IMR_TXOK;
+	} else {
+		if (ah->config.rx_intr_mitigation)
+			imr_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
+		else
+			imr_reg |= AR_IMR_RXOK;
+	}
+
+	if (ah->config.tx_intr_mitigation)
+		imr_reg |= AR_IMR_TXINTM | AR_IMR_TXMINTR;
+	else
+		imr_reg |= AR_IMR_TXOK;
 
 	if (opmode == NL80211_IFTYPE_AP)
 		imr_reg |= AR_IMR_MIB;
@@ -756,6 +768,13 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, AR_INTR_SYNC_DEFAULT);
 		REG_WRITE(ah, AR_INTR_SYNC_MASK, 0);
 	}
+
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_ENABLE, 0);
+		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_MASK, 0);
+		REG_WRITE(ah, AR_INTR_PRIO_SYNC_ENABLE, 0);
+		REG_WRITE(ah, AR_INTR_PRIO_SYNC_MASK, 0);
+	}
 }
 
 static void ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 7f85633..7758d99 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1042,6 +1042,11 @@ enum {
 #define AR_PCIE_MSI                              (AR_SREV_9300_20_OR_LATER(ah) ? 0x40a4 : 0x4094)
 #define AR_PCIE_MSI_ENABLE                       0x00000001
 
+#define AR_INTR_PRIO_SYNC_ENABLE  0x40c4
+#define AR_INTR_PRIO_ASYNC_MASK   0x40c8
+#define AR_INTR_PRIO_SYNC_MASK    0x40cc
+#define AR_INTR_PRIO_ASYNC_ENABLE 0x40d4
+
 #define AR_RTC_9300_PLL_DIV          0x000003ff
 #define AR_RTC_9300_PLL_DIV_S        0
 #define AR_RTC_9300_PLL_REFDIV       0x00003C00
-- 
1.6.3.3

