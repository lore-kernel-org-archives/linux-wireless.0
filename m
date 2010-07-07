Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48126 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0GGRmU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 13:42:20 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/2] ath9k: fix a buffer leak in A-MPDU completion
Date: Wed,  7 Jul 2010 19:42:09 +0200
Message-Id: <1278524529-30246-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278524529-30246-1-git-send-email-nbd@openwrt.org>
References: <1278524529-30246-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When ath_tx_complete_aggr() is called, it's responsible for returning
all buffers in the linked list. This was not done when the STA lookup
failed, leading to a race condition that could leak a few buffers when
a STA just disconnected.
Fix this by immediately returning all buffers to the free list in this case.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/xmit.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 408d1c5..05ec36a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -329,6 +329,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
 	struct ieee80211_tx_rate rates[4];
+	unsigned long flags;
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -344,6 +345,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	sta = ieee80211_find_sta_by_hw(hw, hdr->addr1);
 	if (!sta) {
 		rcu_read_unlock();
+
+		spin_lock_irqsave(&sc->tx.txbuflock, flags);
+		list_splice_tail_init(bf_q, &sc->tx.txbuf);
+		spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
 		return;
 	}
 
-- 
1.6.4.2

