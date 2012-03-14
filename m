Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55434 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab2CNPko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 02/14] ath9k_hw: clean up tx completion interrupt handling
Date: Wed, 14 Mar 2012 16:40:22 +0100
Message-Id: <1331739634-22318-2-git-send-email-nbd@openwrt.org> (sfid-20120314_164048_929438_8391495E)
In-Reply-To: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TXQ_FLAG_TXOKINT_ENABLE and TXQ_FLAG_TXERRINT_ENABLE are always set and
used together, and they share the same bitmask in enum ath9k_tx_queue_flags.
Simplify the code that tests for these flags.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c  |    7 +++----
 drivers/net/wireless/ath/ath9k/mac.h  |    3 +--
 drivers/net/wireless/ath/ath9k/xmit.c |    3 +--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 13b6afd..bfb95e5 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -516,10 +516,10 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		REG_WRITE(ah, AR_Q_DESC_CRCCHK, AR_Q_DESC_CRCCHK_EN);
 
 	ath9k_hw_clear_queue_interrupts(ah, q);
-	if (qi->tqi_qflags & TXQ_FLAG_TXOKINT_ENABLE)
+	if (qi->tqi_qflags & TXQ_FLAG_TXINT_ENABLE) {
 		ah->txok_interrupt_mask |= 1 << q;
-	if (qi->tqi_qflags & TXQ_FLAG_TXERRINT_ENABLE)
 		ah->txerr_interrupt_mask |= 1 << q;
+	}
 	if (qi->tqi_qflags & TXQ_FLAG_TXDESCINT_ENABLE)
 		ah->txdesc_interrupt_mask |= 1 << q;
 	if (qi->tqi_qflags & TXQ_FLAG_TXEOLINT_ENABLE)
@@ -743,8 +743,7 @@ int ath9k_hw_beaconq_setup(struct ath_hw *ah)
 	qi.tqi_cwmax = 0;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
-		qi.tqi_qflags = TXQ_FLAG_TXOKINT_ENABLE |
-				TXQ_FLAG_TXERRINT_ENABLE;
+		qi.tqi_qflags = TXQ_FLAG_TXINT_ENABLE;
 
 	return ath9k_hw_setuptxqueue(ah, ATH9K_TX_QUEUE_BEACON, &qi);
 }
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 11dbd14..6476d90 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -583,8 +583,7 @@ enum ath9k_tx_queue {
 #define ATH9K_WME_UPSD	4
 
 enum ath9k_tx_queue_flags {
-	TXQ_FLAG_TXOKINT_ENABLE = 0x0001,
-	TXQ_FLAG_TXERRINT_ENABLE = 0x0001,
+	TXQ_FLAG_TXINT_ENABLE = 0x0001,
 	TXQ_FLAG_TXDESCINT_ENABLE = 0x0002,
 	TXQ_FLAG_TXEOLINT_ENABLE = 0x0004,
 	TXQ_FLAG_TXURNINT_ENABLE = 0x0008,
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9f78501..5de5199 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1356,8 +1356,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	 * based intr on the EOSP frames.
 	 */
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
-		qi.tqi_qflags = TXQ_FLAG_TXOKINT_ENABLE |
-				TXQ_FLAG_TXERRINT_ENABLE;
+		qi.tqi_qflags = TXQ_FLAG_TXINT_ENABLE;
 	} else {
 		if (qtype == ATH9K_TX_QUEUE_UAPSD)
 			qi.tqi_qflags = TXQ_FLAG_TXDESCINT_ENABLE;
-- 
1.7.3.2

