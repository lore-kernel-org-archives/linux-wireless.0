Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47140 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab0GLVQh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 17:16:37 -0400
Message-ID: <4C3B8632.20305@openwrt.org>
Date: Mon, 12 Jul 2010 23:16:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: another fix for the A-MPDU buffer leak
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch 'ath9k: fix a buffer leak in A-MPDU completion' addressed the
issue of running out of buffers/descriptors in the tx path if a STA is
deleted while tx status feedback is still pending.
The remaining issue is that the skbs of the buffers are not reclaimed,
leaving a memory leak.
This patch fixes this issue by running the buffers through
ath_tx_complete_buf(), ensuring that the pending frames counter is also
updated.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -329,7 +329,6 @@ static void ath_tx_complete_aggr(struct 
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
 	struct ieee80211_tx_rate rates[4];
-	unsigned long flags;
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -346,9 +345,21 @@ static void ath_tx_complete_aggr(struct 
 	if (!sta) {
 		rcu_read_unlock();
 
-		spin_lock_irqsave(&sc->tx.txbuflock, flags);
-		list_splice_tail_init(bf_q, &sc->tx.txbuf);
-		spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
+		INIT_LIST_HEAD(&bf_head);
+		while (bf) {
+			bf_next = bf->bf_next;
+
+			bf->bf_state.bf_type |= BUF_XRETRY;
+			if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) ||
+			    !bf->bf_stale || bf_next != NULL)
+				list_move_tail(&bf->list, &bf_head);
+
+			ath_tx_rc_status(bf, ts, 0, 0, false);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
+				0, 0);
+
+			bf = bf_next;
+		}
 		return;
 	}
 
