Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285Ab0DHT1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 079/102] ath9k_hw: Update ath9k_hw_set_dma for AR9300
Date: Thu,  8 Apr 2010 15:27:15 -0400
Message-Id: <1270754858-26266-80-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   18 +++++++++++++++---
 drivers/net/wireless/ath/ath9k/reg.h |    6 ++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c728346..1c625c0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -832,13 +832,16 @@ u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan)
 
 static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 regval;
 
 	/*
 	 * set AHB_MODE not to do cacheline prefetches
 	*/
-	regval = REG_READ(ah, AR_AHB_MODE);
-	REG_WRITE(ah, AR_AHB_MODE, regval | AR_AHB_PREFETCH_RD_EN);
+	if (!AR_SREV_9300_20_OR_LATER(ah)) {
+		regval = REG_READ(ah, AR_AHB_MODE);
+		REG_WRITE(ah, AR_AHB_MODE, regval | AR_AHB_PREFETCH_RD_EN);
+	}
 
 	/*
 	 * let mac dma reads be in 128 byte chunks
@@ -851,7 +854,8 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	 * The initial value depends on whether aggregation is enabled, and is
 	 * adjusted whenever underruns are detected.
 	 */
-	REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->tx_trig_level);
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->tx_trig_level);
 
 	/*
 	 * let mac dma writes be in 128 byte chunks
@@ -864,6 +868,14 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	 */
 	REG_WRITE(ah, AR_RXFIFO_CFG, 0x200);
 
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		REG_RMW_FIELD(ah, AR_RXBP_THRESH, AR_RXBP_THRESH_HP, 0x1);
+		REG_RMW_FIELD(ah, AR_RXBP_THRESH, AR_RXBP_THRESH_LP, 0x1);
+
+		ath9k_hw_set_rx_bufsize(ah, common->rx_bufsize -
+			ah->caps.rx_status_len);
+	}
+
 	/*
 	 * reduce the number of usable entries in PCU TXBUF to avoid
 	 * wrap around issues.
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 12f1621..2ca478c 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -39,6 +39,12 @@
 #define AR_CFG_PCI_MASTER_REQ_Q_THRESH         0x00060000
 #define AR_CFG_PCI_MASTER_REQ_Q_THRESH_S       17
 
+#define AR_RXBP_THRESH       0x0018
+#define AR_RXBP_THRESH_HP    0x0000000f
+#define AR_RXBP_THRESH_HP_S  0
+#define AR_RXBP_THRESH_LP    0x00003f00
+#define AR_RXBP_THRESH_LP_S  8
+
 #define AR_MIRT              0x0020
 #define AR_MIRT_VAL          0x0000ffff
 #define AR_MIRT_VAL_S        16
-- 
1.6.3.3

