Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54463 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab2JYWbX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 18:31:23 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.7] ath9k: fix stale pointers potentially causing access to free'd skbs
Date: Fri, 26 Oct 2012 00:31:11 +0200
Message-Id: <1351204271-94815-1-git-send-email-nbd@openwrt.org> (sfid-20121026_003126_992324_2FBF1CA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bf->bf_next is only while buffers are chained as part of an A-MPDU
in the tx queue. When a tid queue is flushed (e.g. on tearing down
an aggregation session), frames can be enqueued again as normal
transmission, without bf_next being cleared. This can lead to the
old pointer being dereferenced again later.

This patch might fix crashes and "Failed to stop TX DMA!" messages.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 378bd70..1ffca75 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -312,6 +312,7 @@ static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
 	}
 
 	bf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
+	bf->bf_next = NULL;
 	list_del(&bf->list);
 
 	spin_unlock_bh(&sc->tx.txbuflock);
@@ -1774,6 +1775,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	list_add_tail(&bf->list, &bf_head);
 	bf->bf_state.bf_type = 0;
 
+	bf->bf_next = NULL;
 	bf->bf_lastbf = bf;
 	ath_tx_fill_desc(sc, bf, txq, fi->framelen);
 	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
-- 
1.7.12.2

