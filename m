Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57152 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab0ITLp4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 07:45:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/5] ath9k: clean up block ack window handling
Date: Mon, 20 Sep 2010 13:45:36 +0200
Message-Id: <1284983140-30099-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no reason to keep pointers to pending tx buffers around, if they're
only used to keep track of which frames are still pending. Use a bitfield
instead.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |    8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5fe570b..9fddd80 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -254,7 +254,7 @@ struct ath_atx_tid {
 	struct list_head buf_q;
 	struct ath_node *an;
 	struct ath_atx_ac *ac;
-	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS];
+	unsigned long tx_buf[BITS_TO_LONGS(ATH_TID_MAX_BUFS)];
 	u16 seq_start;
 	u16 seq_next;
 	u16 baw_size;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 457f076..5323a4d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -168,9 +168,9 @@ static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 	index  = ATH_BA_INDEX(tid->seq_start, seqno);
 	cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
 
-	tid->tx_buf[cindex] = NULL;
+	__clear_bit(cindex, tid->tx_buf);
 
-	while (tid->baw_head != tid->baw_tail && !tid->tx_buf[tid->baw_head]) {
+	while (tid->baw_head != tid->baw_tail && !test_bit(tid->baw_head, tid->tx_buf)) {
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 		INCR(tid->baw_head, ATH_TID_MAX_BUFS);
 	}
@@ -186,9 +186,7 @@ static void ath_tx_addto_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 
 	index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
 	cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
-
-	BUG_ON(tid->tx_buf[cindex] != NULL);
-	tid->tx_buf[cindex] = bf;
+	__set_bit(cindex, tid->tx_buf);
 
 	if (index >= ((tid->baw_tail - tid->baw_head) &
 		(ATH_TID_MAX_BUFS - 1))) {
-- 
1.7.2.2

