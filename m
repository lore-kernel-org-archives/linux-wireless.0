Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40072 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab0BWXPm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 18:15:42 -0500
Subject: [PATCH] ath9k: never read from the AR_IMR_S2 register
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 23 Feb 2010 18:15:27 -0500
Message-ID: <20100223231527.8028.84024.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR_IMR_S2 register sometimes cannot be read correctly.  Instead of a
valid value, 0xdeadbeef is returned.  The driver has been observed
writing that value back to AR_IMR_S2 after changing a few bits.

Cache the register value in ah->imrs2_reg and always write chached value
to the register.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   16 +++++++---------
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/mac.c |    6 ++++--
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f00f5c7..1f10fe3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1151,7 +1151,8 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		ah->mask_reg |= AR_IMR_MIB;
 
 	REG_WRITE(ah, AR_IMR, ah->mask_reg);
-	REG_WRITE(ah, AR_IMR_S2, REG_READ(ah, AR_IMR_S2) | AR_IMR_S2_GTT);
+	ah->imrs2_reg |= AR_IMR_S2_GTT;
+	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
 
 	if (!AR_SREV_9100(ah)) {
 		REG_WRITE(ah, AR_INTR_SYNC_CAUSE, 0xFFFFFFFF);
@@ -2910,14 +2911,11 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 
 	ath_print(common, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
 	REG_WRITE(ah, AR_IMR, mask);
-	mask = REG_READ(ah, AR_IMR_S2) & ~(AR_IMR_S2_TIM |
-					   AR_IMR_S2_DTIM |
-					   AR_IMR_S2_DTIMSYNC |
-					   AR_IMR_S2_CABEND |
-					   AR_IMR_S2_CABTO |
-					   AR_IMR_S2_TSFOOR |
-					   AR_IMR_S2_GTT | AR_IMR_S2_CST);
-	REG_WRITE(ah, AR_IMR_S2, mask | mask2);
+	ah->imrs2_reg &= ~(AR_IMR_S2_TIM | AR_IMR_S2_DTIM | AR_IMR_S2_DTIMSYNC |
+			   AR_IMR_S2_CABEND | AR_IMR_S2_CABTO |
+			   AR_IMR_S2_TSFOOR | AR_IMR_S2_GTT | AR_IMR_S2_CST);
+	ah->imrs2_reg |= mask2;
+	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
 	ah->mask_reg = ints;
 
 	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index dbbf7ca..20d9026 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -479,6 +479,7 @@ struct ath_hw {
 
 	int16_t curchan_rad_index;
 	u32 mask_reg;
+	u32 imrs2_reg;
 	u32 txok_interrupt_mask;
 	u32 txerr_interrupt_mask;
 	u32 txdesc_interrupt_mask;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index efc420c..589490b 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -31,8 +31,10 @@ static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 	REG_WRITE(ah, AR_IMR_S1,
 		  SM(ah->txerr_interrupt_mask, AR_IMR_S1_QCU_TXERR)
 		  | SM(ah->txeol_interrupt_mask, AR_IMR_S1_QCU_TXEOL));
-	REG_RMW_FIELD(ah, AR_IMR_S2,
-		      AR_IMR_S2_QCU_TXURN, ah->txurn_interrupt_mask);
+
+	ah->imrs2_reg &= ~AR_IMR_S2_QCU_TXURN;
+	ah->imrs2_reg |= (ah->txurn_interrupt_mask & AR_IMR_S2_QCU_TXURN);
+	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
 }
 
 u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
