Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37705 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0CaWFi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 18:05:38 -0400
Subject: [PATCH 3/3] ath9k: remove ah->mask_reg, it's never used properly
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 31 Mar 2010 18:05:37 -0400
Message-ID: <20100331220537.2920.74323.stgit@mj.roinet.com>
In-Reply-To: <20100331220525.2920.14907.stgit@mj.roinet.com>
References: <20100331220525.2920.14907.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ah->mask_reg was used to hold different data throughout the driver.
ath9k_hw_init_interrupt_masks() used it to save the value written to
AR_IMR.  ath9k_hw_set_interrupts() used it to hold the interrupt mask as
defined in enum ath9k_int.  Those masks differ in many bits.

Use ah->imask instead of ah->mask_reg in ath9k_hw_set_interrupts() and
ath9k_hw_updatetxtriglevel().  That's what the code was meant to do.
ah->imask is initialized in ath9k_start(), so we don't need to
initialize it from ah->mask_reg.

Once it's done, ah->mask_reg becomes write-only, so it's replaced with a
local variable in ath9k_hw_init_interrupt_masks().

Signed-off-by: Pavel Roskin <proski@gnu.org>
Reported-by: Julia Lawall <julia@diku.dk>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   15 +++++++--------
 drivers/net/wireless/ath/ath9k/hw.h  |    1 -
 drivers/net/wireless/ath/ath9k/mac.c |    2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 77db932..e716b60 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1120,23 +1120,23 @@ static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
 static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 					  enum nl80211_iftype opmode)
 {
-	ah->mask_reg = AR_IMR_TXERR |
+	u32 imr_reg = AR_IMR_TXERR |
 		AR_IMR_TXURN |
 		AR_IMR_RXERR |
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
 	if (ah->config.rx_intr_mitigation)
-		ah->mask_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
+		imr_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
 	else
-		ah->mask_reg |= AR_IMR_RXOK;
+		imr_reg |= AR_IMR_RXOK;
 
-	ah->mask_reg |= AR_IMR_TXOK;
+	imr_reg |= AR_IMR_TXOK;
 
 	if (opmode == NL80211_IFTYPE_AP)
-		ah->mask_reg |= AR_IMR_MIB;
+		imr_reg |= AR_IMR_MIB;
 
-	REG_WRITE(ah, AR_IMR, ah->mask_reg);
+	REG_WRITE(ah, AR_IMR, imr_reg);
 	ah->imrs2_reg |= AR_IMR_S2_GTT;
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
 
@@ -2839,7 +2839,7 @@ EXPORT_SYMBOL(ath9k_hw_getisr);
 
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 {
-	u32 omask = ah->mask_reg;
+	enum ath9k_int omask = ah->imask;
 	u32 mask, mask2;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -2911,7 +2911,6 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 			   AR_IMR_S2_TSFOOR | AR_IMR_S2_GTT | AR_IMR_S2_CST);
 	ah->imrs2_reg |= mask2;
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
-	ah->mask_reg = ints;
 
 	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
 		if (ints & ATH9K_INT_TIM_TIMER)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0ac7a80..97ebeba 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -479,7 +479,6 @@ struct ath_hw {
 
 	int16_t curchan_rad_index;
 	enum ath9k_int imask;
-	u32 mask_reg;
 	u32 imrs2_reg;
 	u32 txok_interrupt_mask;
 	u32 txerr_interrupt_mask;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index e020b82..4a2060e 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -105,7 +105,7 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 	if (ah->tx_trig_level >= ah->config.max_txtrig_level)
 		return false;
 
-	omask = ath9k_hw_set_interrupts(ah, ah->mask_reg & ~ATH9K_INT_GLOBAL);
+	omask = ath9k_hw_set_interrupts(ah, ah->imask & ~ATH9K_INT_GLOBAL);
 
 	txcfg = REG_READ(ah, AR_TXCFG);
 	curLevel = MS(txcfg, AR_FTRIG);
