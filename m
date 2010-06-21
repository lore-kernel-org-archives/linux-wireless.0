Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14757 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab0FUHgO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 03:36:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 00:36:14 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix kernel panic during rmmod ath9k
Date: Mon, 21 Jun 2010 00:36:08 -0700
Message-ID: <1277105768-1980-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This panic was introduced in ar9003 family chipsets
by the following commit

	Author: Felix Fietkau <nbd@openwrt.org>
	Date:   Sat Jun 12 00:34:01 2010 -0400

	ath9k: implement PA predistortion support

Above patch does kfree_skb on a PA predistortion frame
in ath_paprd_calibrate(). This is fine for the cases
where this frame could not be queued onto sw/hw queues
or the tx of this frame is completed. But freeing this
frame upon a failed completion event will result in
dereferencing a freed memory in ath_tx_complete_buf()
while draining pending tx frames.

This patch fixes this issue by moving kfree_skb to
ath_tx_complete_buf() once the frame is successfully
queued.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 +++--
 drivers/net/wireless/ath/ath9k/xmit.c |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c8de50f..37933d3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -306,8 +306,10 @@ void ath_paprd_calibrate(struct work_struct *work)
 		init_completion(&sc->paprd_complete);
 		ar9003_paprd_setup_gain_table(ah, chain);
 		txctl.paprd = BIT(chain);
-		if (ath_tx_start(hw, skb, &txctl) != 0)
+		if (ath_tx_start(hw, skb, &txctl) != 0) {
+			kfree_skb(skb);
 			break;
+		}
 
 		time_left = wait_for_completion_timeout(&sc->paprd_complete,
 							100);
@@ -327,7 +329,6 @@ void ath_paprd_calibrate(struct work_struct *work)
 
 		chain_ok = 1;
 	}
-	kfree_skb(skb);
 
 	if (chain_ok) {
 		ah->curchan->paprd_done = true;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8c7c615..197e898 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1946,6 +1946,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	if (bf->bf_state.bfs_paprd) {
 		sc->paprd_txok = txok;
 		complete(&sc->paprd_complete);
+		dev_kfree_skb_any(skb);
 	} else {
 		ath_tx_complete(sc, skb, bf->aphy, tx_flags);
 		ath_debug_stat_tx(sc, txq, bf, ts);
-- 
1.7.0.4

