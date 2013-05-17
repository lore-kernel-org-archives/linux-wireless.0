Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59505 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab3EQJga (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 05:36:30 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.10 3/3] ath9k: fix draining aggregation tid buffers
Date: Fri, 17 May 2013 11:36:23 +0200
Message-Id: <1368783383-82459-3-git-send-email-nbd@openwrt.org> (sfid-20130517_113634_741886_8B45F38A)
In-Reply-To: <1368783383-82459-1-git-send-email-nbd@openwrt.org>
References: <1368783383-82459-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a tx attempt, an A-MPDU subframe can still have fi->retries at 0
(if the retry count wasn't incremented due to powersave).
In that case it is still tracked as part of the block ack window, so
when draining the tid queue, its sequence number needs to be cleared
from the pending frame bitmap.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ad6e0b3..14bb335 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -287,9 +287,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 
 		list_add_tail(&bf->list, &bf_head);
 
-		if (fi->retries)
-			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
-
+		ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 	}
 
-- 
1.8.0.2

