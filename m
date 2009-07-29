Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2795 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZG2VdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:33:24 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: fix CAB queue operation
Date: Wed, 29 Jul 2009 17:32:28 -0400
Message-Id: <1248903148-8131-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1248877744-7273-2-git-send-email-me@bobcopeland.com>
References: <1248877744-7273-2-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to process tx descriptors for all queues (currently main tx
queue and cabq) which may have triggered the TX completion interrupt.
Otherwise, the queues can get stuck after sending a few frames.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

John, hand-edited this one to remove the queue config stuff for now.

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
 
 

