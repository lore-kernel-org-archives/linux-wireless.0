Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4888 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZG2OaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 10:30:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: fix CAB queue operation
Date: Wed, 29 Jul 2009 10:29:04 -0400
Message-Id: <1248877744-7273-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1248877744-7273-1-git-send-email-me@bobcopeland.com>
References: <1248877744-7273-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to process tx descriptors for all queues (currently main tx
queue and cabq) which may have triggered the TX completion interrupt.
Otherwise, the queues can get stuck after sending a few frames.

Also, the CAB queue does need to be DBA (DMA beacon alert) gated, as
in ath9k and madwifi, instead of beacon sent gated or the CAB frames
may not be sent at the right time.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    5 ++++-
 drivers/net/wireless/ath/ath5k/qcu.c  |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 55ee976..3a1c156 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2000,9 +2000,12 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 static void
 ath5k_tasklet_tx(unsigned long data)
 {
+	int i;
 	struct ath5k_softc *sc = (void *)data;
 
-	ath5k_tx_processq(sc, sc->txq);
+	for (i=0; i < AR5K_NUM_TX_QUEUES; i++)
+		if (sc->txqs[i].setup && (sc->ah->ah_txq_isr & BIT(i)))
+			ath5k_tx_processq(sc, &sc->txqs[i]);
 }
 
 
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 6d5aaf0..d7d5d11 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -409,7 +409,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 
 		case AR5K_TX_QUEUE_CAB:
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_FRSHED_BCN_SENT_GT |
+				AR5K_QCU_MISC_FRSHED_DBA_GT |
 				AR5K_QCU_MISC_CBREXP_DIS |
 				AR5K_QCU_MISC_CBREXP_BCN_DIS);
 
-- 
1.6.2.5


