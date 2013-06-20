Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35434 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965398Ab3FTNLf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 09:11:35 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k: fix queue depth accounting in ath_tx_txqaddbuf
Date: Thu, 20 Jun 2013 15:11:31 +0200
Message-Id: <1371733891-20996-1-git-send-email-nbd@openwrt.org> (sfid-20130620_151138_373367_DC2A7777)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_tx_txqaddbuf assumes that all the linked buffers in the queue passed
to it are part of the same A-MPDU or MPDU. The CAB queue rework violates
this assumption, which can cause the internal queue depth to go
negative.
Fix this by increasing the counter for all slots of [bf, bf->bf_lastbf]

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7e19d9b..bfb58a5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1778,9 +1778,13 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	}
 
 	if (!internal) {
-		txq->axq_depth++;
-		if (bf_is_ampdu_not_probing(bf))
-			txq->axq_ampdu_depth++;
+		while (bf) {
+			txq->axq_depth++;
+			if (bf_is_ampdu_not_probing(bf))
+				txq->axq_ampdu_depth++;
+
+			bf = bf->bf_lastbf->bf_next;
+		}
 	}
 }
 
-- 
1.8.0.2

