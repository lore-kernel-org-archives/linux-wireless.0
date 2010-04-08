Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46954 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab0DHT1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 072/102] ath9k_hw: Fill get_isr() for AR9003
Date: Thu,  8 Apr 2010 15:27:08 -0400
Message-Id: <1270754858-26266-73-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |  132 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |    8 ++
 drivers/net/wireless/ath/ath9k/hw.c         |    3 +
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 drivers/net/wireless/ath/ath9k/reg.h        |    2 +
 5 files changed, 146 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 15f1b0f..2319456 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -32,6 +32,138 @@ static void ar9003_hw_get_desc_link(void *ds, u32 **ds_link)
 
 static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 {
+	u32 isr = 0;
+	u32 mask2 = 0;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	u32 sync_cause = 0;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (REG_READ(ah, AR_INTR_ASYNC_CAUSE) & AR_INTR_MAC_IRQ) {
+		if ((REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M)
+				== AR_RTC_STATUS_ON)
+			isr = REG_READ(ah, AR_ISR);
+	}
+
+	sync_cause = REG_READ(ah, AR_INTR_SYNC_CAUSE) & AR_INTR_SYNC_DEFAULT;
+
+	*masked = 0;
+
+	if (!isr && !sync_cause)
+		return false;
+
+	if (isr) {
+		if (isr & AR_ISR_BCNMISC) {
+			u32 isr2;
+			isr2 = REG_READ(ah, AR_ISR_S2);
+
+			mask2 |= ((isr2 & AR_ISR_S2_TIM) >>
+				  MAP_ISR_S2_TIM);
+			mask2 |= ((isr2 & AR_ISR_S2_DTIM) >>
+				  MAP_ISR_S2_DTIM);
+			mask2 |= ((isr2 & AR_ISR_S2_DTIMSYNC) >>
+				  MAP_ISR_S2_DTIMSYNC);
+			mask2 |= ((isr2 & AR_ISR_S2_CABEND) >>
+				  MAP_ISR_S2_CABEND);
+			mask2 |= ((isr2 & AR_ISR_S2_GTT) <<
+				  MAP_ISR_S2_GTT);
+			mask2 |= ((isr2 & AR_ISR_S2_CST) <<
+				  MAP_ISR_S2_CST);
+			mask2 |= ((isr2 & AR_ISR_S2_TSFOOR) >>
+				  MAP_ISR_S2_TSFOOR);
+
+			if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+				REG_WRITE(ah, AR_ISR_S2, isr2);
+				isr &= ~AR_ISR_BCNMISC;
+			}
+		}
+
+		if ((pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED))
+			isr = REG_READ(ah, AR_ISR_RAC);
+
+		if (isr == 0xffffffff) {
+			*masked = 0;
+			return false;
+		}
+
+		*masked = isr & ATH9K_INT_COMMON;
+
+		if (ah->config.rx_intr_mitigation)
+			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
+				*masked |= ATH9K_INT_RXLP;
+
+		if (ah->config.tx_intr_mitigation)
+			if (isr & (AR_ISR_TXMINTR | AR_ISR_TXINTM))
+				*masked |= ATH9K_INT_TX;
+
+		if (isr & (AR_ISR_LP_RXOK | AR_ISR_RXERR))
+			*masked |= ATH9K_INT_RXLP;
+
+		if (isr & AR_ISR_HP_RXOK)
+			*masked |= ATH9K_INT_RXHP;
+
+		if (isr & (AR_ISR_TXOK | AR_ISR_TXERR | AR_ISR_TXEOL)) {
+			*masked |= ATH9K_INT_TX;
+
+			if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+				u32 s0, s1;
+				s0 = REG_READ(ah, AR_ISR_S0);
+				REG_WRITE(ah, AR_ISR_S0, s0);
+				s1 = REG_READ(ah, AR_ISR_S1);
+				REG_WRITE(ah, AR_ISR_S1, s1);
+
+				isr &= ~(AR_ISR_TXOK | AR_ISR_TXERR |
+					 AR_ISR_TXEOL);
+			}
+		}
+
+		if (isr & AR_ISR_GENTMR) {
+			u32 s5;
+
+			if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)
+				s5 = REG_READ(ah, AR_ISR_S5_S);
+			else
+				s5 = REG_READ(ah, AR_ISR_S5);
+
+			ah->intr_gen_timer_trigger =
+				MS(s5, AR_ISR_S5_GENTIMER_TRIG);
+
+			ah->intr_gen_timer_thresh =
+				MS(s5, AR_ISR_S5_GENTIMER_THRESH);
+
+			if (ah->intr_gen_timer_trigger)
+				*masked |= ATH9K_INT_GENTIMER;
+
+			if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+				REG_WRITE(ah, AR_ISR_S5, s5);
+				isr &= ~AR_ISR_GENTMR;
+			}
+
+		}
+
+		*masked |= mask2;
+
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+			REG_WRITE(ah, AR_ISR, isr);
+
+			(void) REG_READ(ah, AR_ISR);
+		}
+	}
+
+	if (sync_cause) {
+		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
+			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
+			REG_WRITE(ah, AR_RC, 0);
+			*masked |= ATH9K_INT_FATAL;
+		}
+
+		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT)
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "AR_INTR_SYNC_LOCAL_TIMEOUT\n");
+
+			REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
+		(void) REG_READ(ah, AR_INTR_SYNC_CAUSE_CLR);
+
+	}
 	return true;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index eda2355..18e928f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -22,6 +22,14 @@
 #define AR_CtrlStat	0x00004000
 #define AR_TxRxDesc	0x00008000
 
+#define MAP_ISR_S2_CST          6
+#define MAP_ISR_S2_GTT          6
+#define MAP_ISR_S2_TIM          3
+#define MAP_ISR_S2_CABEND       0
+#define MAP_ISR_S2_DTIMSYNC     7
+#define MAP_ISR_S2_DTIM         7
+#define MAP_ISR_S2_TSFOOR       4
+
 enum ath9k_rx_qtype {
 	ATH9K_RX_QUEUE_HP,
 	ATH9K_RX_QUEUE_LP,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5a80f82..4cf11de 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2184,6 +2184,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->tx_desc_len = sizeof(struct ath_desc);
 	}
 
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		pCap->hw_caps |= ATH9K_HW_CAP_RAC_SUPPORTED;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 84b8922..6ae8353 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -180,6 +180,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(15),
 	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(16),
 	ATH9K_HW_CAP_EDMA			= BIT(17),
+	ATH9K_HW_CAP_RAC_SUPPORTED		= BIT(18),
 };
 
 enum ath9k_capability_type {
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 12de95e..12f1621 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -169,6 +169,8 @@
 #define AR_ISR               0x0080
 #define AR_ISR_RXOK          0x00000001
 #define AR_ISR_RXDESC        0x00000002
+#define AR_ISR_HP_RXOK	     0x00000001
+#define AR_ISR_LP_RXOK	     0x00000002
 #define AR_ISR_RXERR         0x00000004
 #define AR_ISR_RXNOPKT       0x00000008
 #define AR_ISR_RXEOL         0x00000010
-- 
1.6.3.3

