Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55438 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069Ab2CNPko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 06/14] ath9k_hw: remove ath9k_hw_gettxintrtxqs
Date: Wed, 14 Mar 2012 16:40:26 +0100
Message-Id: <1331739634-22318-6-git-send-email-nbd@openwrt.org> (sfid-20120314_164113_605802_8B0EF964)
In-Reply-To: <1331739634-22318-5-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
 <1331739634-22318-4-git-send-email-nbd@openwrt.org>
 <1331739634-22318-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver can just check the mask directly

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c  |    7 -------
 drivers/net/wireless/ath/ath9k/mac.h  |    1 -
 drivers/net/wireless/ath/ath9k/xmit.c |    5 ++---
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index bfb95e5..f7bd253 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -185,13 +185,6 @@ bool ath9k_hw_stop_dma_queue(struct ath_hw *ah, u32 q)
 }
 EXPORT_SYMBOL(ath9k_hw_stop_dma_queue);
 
-void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs)
-{
-	*txqs &= ah->intr_txqs;
-	ah->intr_txqs &= ~(*txqs);
-}
-EXPORT_SYMBOL(ath9k_hw_gettxintrtxqs);
-
 bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo)
 {
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 6476d90..21c9556 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -713,7 +713,6 @@ u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q);
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel);
 bool ath9k_hw_stop_dma_queue(struct ath_hw *ah, u32 q);
 void ath9k_hw_abort_tx_dma(struct ath_hw *ah);
-void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs);
 bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo);
 bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5de5199..a91cfd7 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2262,10 +2262,9 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 
 void ath_tx_tasklet(struct ath_softc *sc)
 {
+	struct ath_hw *ah = sc->sc_ah;
+	u32 qcumask = ((1 << ATH9K_NUM_TX_QUEUES) - 1) & ah->intr_txqs;
 	int i;
-	u32 qcumask = ((1 << ATH9K_NUM_TX_QUEUES) - 1);
-
-	ath9k_hw_gettxintrtxqs(sc->sc_ah, &qcumask);
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (ATH_TXQ_SETUP(sc, i) && (qcumask & (1 << i)))
-- 
1.7.3.2

