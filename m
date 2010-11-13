Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38657 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752368Ab0KMXDH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 18:03:07 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: fix PA predistortion training frame setup
Date: Sun, 14 Nov 2010 00:03:01 +0100
Message-Id: <1289689381-62033-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8ba0e2d..dc648a5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1656,9 +1656,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			    bf->bf_buf_addr,
 			    txctl->txq->axq_qnum);
 
-	if (bf->bf_state.bfs_paprd)
-		ar9003_hw_set_paprd_txdesc(ah, ds, bf->bf_state.bfs_paprd);
-
 	spin_lock_bh(&txctl->txq->axq_lock);
 
 	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR) &&
@@ -1684,6 +1681,9 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 		bf->bf_state.bfs_ftype = txctl->frame_type;
 		bf->bf_state.bfs_paprd = txctl->paprd;
 
+		if (bf->bf_state.bfs_paprd)
+			ar9003_hw_set_paprd_txdesc(ah, ds, bf->bf_state.bfs_paprd);
+
 		if (txctl->paprd)
 			bf->bf_state.bfs_paprd_timestamp = jiffies;
 
-- 
1.7.3.2

