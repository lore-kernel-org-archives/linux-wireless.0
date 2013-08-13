Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41182 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab3HMKdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 06:33:38 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 4/5] ath9k: simplify ath_tid_drain
Date: Tue, 13 Aug 2013 12:33:29 +0200
Message-Id: <1376390010-81819-4-git-send-email-nbd@openwrt.org> (sfid-20130813_123341_959232_3CE51762)
In-Reply-To: <1376390010-81819-1-git-send-email-nbd@openwrt.org>
References: <1376390010-81819-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_tid_drain is only called when a station entry is being removed, so
there is no point in still tracking BAW state. Remove some unnecessary
code and a bogus TODO comment related to this.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4fc80e3..cb06c1c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -312,12 +312,6 @@ static void ath_tx_addto_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 	}
 }
 
-/*
- * TODO: For frame(s) that are in the retry state, we will reuse the
- * sequence number(s) without setting the retry bit. The
- * alternative is to give up on these and BAR the receiver's window
- * forward.
- */
 static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 			  struct ath_atx_tid *tid)
 
@@ -341,14 +335,8 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 		}
 
 		list_add_tail(&bf->list, &bf_head);
-
-		ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 	}
-
-	tid->seq_next = tid->seq_start;
-	tid->baw_tail = tid->baw_head;
-	tid->bar_index = -1;
 }
 
 static void ath_tx_set_retry(struct ath_softc *sc, struct ath_txq *txq,
-- 
1.8.0.2

