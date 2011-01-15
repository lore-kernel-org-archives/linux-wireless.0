Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34643 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1AONaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 08:30:22 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 2/2] ath9k: fix excessive BAR sending when a frame exceeds its retry limit
Date: Sat, 15 Jan 2011 14:30:15 +0100
Message-Id: <1295098215-98910-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1295098215-98910-1-git-send-email-nbd@openwrt.org>
References: <1295098215-98910-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because the sendbar variable was not reset to zero, the stack would send
Block ACK requests for all subframes following the one that failed, which
could mess up the receiver side block ack window.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fffd13d..ad569e1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -429,7 +429,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	ath_tx_count_frames(sc, bf, ts, txok, &nframes, &nbad);
 	while (bf) {
-		txfail = txpending = 0;
+		txfail = txpending = sendbar = 0;
 		bf_next = bf->bf_next;
 
 		skb = bf->bf_mpdu;
-- 
1.7.3.2

