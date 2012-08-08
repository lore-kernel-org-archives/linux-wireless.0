Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38820 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380Ab2HHOZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 10:25:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com, c_manoha@qca.qualcomm.com
Subject: [PATCH v2 3.6] ath9k: fix interrupt storms on queued hardware reset
Date: Wed,  8 Aug 2012 16:25:03 +0200
Message-Id: <1344435903-70536-1-git-send-email-nbd@openwrt.org> (sfid-20120808_162512_821587_0C7221F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit b74713d04effbacd3d126ce94cec18742187b6ce
"ath9k: Handle fatal interrupts properly" introduced a race condition, where
IRQs are being left enabled, however the irq handler returns IRQ_HANDLED
while the reset is still queued without addressing the IRQ cause.
This leads to an IRQ storm that prevents the system from even getting to
the reset code.

Fix this by disabling IRQs in the handler without touching intr_ref_cnt.

Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c  |   18 ++++++++++++------
 drivers/net/wireless/ath/ath9k/mac.h  |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    4 +++-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 7990cd5..b42be91 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -773,15 +773,10 @@ bool ath9k_hw_intrpend(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_intrpend);
 
-void ath9k_hw_disable_interrupts(struct ath_hw *ah)
+void ath9k_hw_kill_interrupts(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (!(ah->imask & ATH9K_INT_GLOBAL))
-		atomic_set(&ah->intr_ref_cnt, -1);
-	else
-		atomic_dec(&ah->intr_ref_cnt);
-
 	ath_dbg(common, INTERRUPT, "disable IER\n");
 	REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
 	(void) REG_READ(ah, AR_IER);
@@ -793,6 +788,17 @@ void ath9k_hw_disable_interrupts(struct ath_hw *ah)
 		(void) REG_READ(ah, AR_INTR_SYNC_ENABLE);
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_kill_interrupts);
+
+void ath9k_hw_disable_interrupts(struct ath_hw *ah)
+{
+	if (!(ah->imask & ATH9K_INT_GLOBAL))
+		atomic_set(&ah->intr_ref_cnt, -1);
+	else
+		atomic_dec(&ah->intr_ref_cnt);
+
+	ath9k_hw_kill_interrupts(ah);
+}
 EXPORT_SYMBOL(ath9k_hw_disable_interrupts);
 
 void ath9k_hw_enable_interrupts(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 0eba36d..4a745e6 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -738,6 +738,7 @@ bool ath9k_hw_intrpend(struct ath_hw *ah);
 void ath9k_hw_set_interrupts(struct ath_hw *ah);
 void ath9k_hw_enable_interrupts(struct ath_hw *ah);
 void ath9k_hw_disable_interrupts(struct ath_hw *ah);
+void ath9k_hw_kill_interrupts(struct ath_hw *ah);
 
 void ar9002_hw_attach_mac_ops(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6049d8b..a22df74 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -462,8 +462,10 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (!ath9k_hw_intrpend(ah))
 		return IRQ_NONE;
 
-	if(test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
+		ath9k_hw_kill_interrupts(ah);
 		return IRQ_HANDLED;
+	}
 
 	/*
 	 * Figure out the reason(s) for the interrupt.  Note
-- 
1.7.9.6 (Apple Git-31.1)

