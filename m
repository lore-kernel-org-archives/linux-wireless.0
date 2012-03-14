Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55441 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab2CNPkq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 01/14] ath9k_hw: simplify tx queue interrupt mask handling
Date: Wed, 14 Mar 2012 16:40:21 +0100
Message-Id: <1331739634-22318-1-git-send-email-nbd@openwrt.org> (sfid-20120314_164059_715706_9D2D64C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 5f4ae6c..13b6afd 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -340,6 +340,15 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 }
 EXPORT_SYMBOL(ath9k_hw_setuptxqueue);
 
+static void ath9k_hw_clear_queue_interrupts(struct ath_hw *ah, u32 q)
+{
+	ah->txok_interrupt_mask &= ~(1 << q);
+	ah->txerr_interrupt_mask &= ~(1 << q);
+	ah->txdesc_interrupt_mask &= ~(1 << q);
+	ah->txeol_interrupt_mask &= ~(1 << q);
+	ah->txurn_interrupt_mask &= ~(1 << q);
+}
+
 bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -354,11 +363,7 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 	ath_dbg(common, QUEUE, "Release TX queue: %u\n", q);
 
 	qi->tqi_type = ATH9K_TX_QUEUE_INACTIVE;
-	ah->txok_interrupt_mask &= ~(1 << q);
-	ah->txerr_interrupt_mask &= ~(1 << q);
-	ah->txdesc_interrupt_mask &= ~(1 << q);
-	ah->txeol_interrupt_mask &= ~(1 << q);
-	ah->txurn_interrupt_mask &= ~(1 << q);
+	ath9k_hw_clear_queue_interrupts(ah, q);
 	ath9k_hw_set_txq_interrupts(ah, qi);
 
 	return true;
@@ -510,26 +515,17 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		REG_WRITE(ah, AR_Q_DESC_CRCCHK, AR_Q_DESC_CRCCHK_EN);
 
+	ath9k_hw_clear_queue_interrupts(ah, q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXOKINT_ENABLE)
 		ah->txok_interrupt_mask |= 1 << q;
-	else
-		ah->txok_interrupt_mask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXERRINT_ENABLE)
 		ah->txerr_interrupt_mask |= 1 << q;
-	else
-		ah->txerr_interrupt_mask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXDESCINT_ENABLE)
 		ah->txdesc_interrupt_mask |= 1 << q;
-	else
-		ah->txdesc_interrupt_mask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXEOLINT_ENABLE)
 		ah->txeol_interrupt_mask |= 1 << q;
-	else
-		ah->txeol_interrupt_mask &= ~(1 << q);
 	if (qi->tqi_qflags & TXQ_FLAG_TXURNINT_ENABLE)
 		ah->txurn_interrupt_mask |= 1 << q;
-	else
-		ah->txurn_interrupt_mask &= ~(1 << q);
 	ath9k_hw_set_txq_interrupts(ah, qi);
 
 	return true;
-- 
1.7.3.2

