Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56512 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab1JGA21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 20:28:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/4] ath9k: indicate which queues are blocked when stopping tx fails
Date: Fri,  7 Oct 2011 02:28:12 +0200
Message-Id: <1317947295-52172-1-git-send-email-nbd@openwrt.org> (sfid-20111007_022830_954421_25AE41F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c2bfc57..8980e7b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1473,7 +1473,8 @@ bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_txq *txq;
-	int i, npend = 0;
+	int i;
+	u32 npend = 0;
 
 	if (sc->sc_flags & SC_OP_INVALID)
 		return true;
@@ -1485,11 +1486,12 @@ bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		if (!ATH_TXQ_SETUP(sc, i))
 			continue;
 
-		npend += ath9k_hw_numtxpending(ah, sc->tx.txq[i].axq_qnum);
+		if (ath9k_hw_numtxpending(ah, sc->tx.txq[i].axq_qnum))
+			npend |= BIT(i);
 	}
 
 	if (npend)
-		ath_err(common, "Failed to stop TX DMA!\n");
+		ath_err(common, "Failed to stop TX DMA, queues=0x%03x!\n", npend);
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (!ATH_TXQ_SETUP(sc, i))
-- 
1.7.3.2

