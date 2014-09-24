Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52264 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaIXGRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 02:17:50 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/5] ath9k: Fix queue management
Date: Wed, 24 Sep 2014 11:48:14 +0530
Message-Id: <1411539496-30595-4-git-send-email-sujith@msujith.org> (sfid-20140924_081755_698956_FF3B5D52)
In-Reply-To: <1411539496-30595-1-git-send-email-sujith@msujith.org>
References: <1411539496-30595-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since we use IEEE80211_HW_QUEUE_CONTROL now, the
CAB/Offchannel queues are registered as the last
two queues. There is no need to check and reassign
the queues in the TX start()/done() routines.

CAB frames will not reach the tx() callback since
we set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING and
pull the buffered frames during beacon transmission.
We also don't have a special HW queue for handling
off-channel frames.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 93ad31b..2c8327f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -158,7 +158,6 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_frame_info *fi = get_frame_info(skb);
-	int hw_queue;
 	int q = fi->txq;
 
 	if (q < 0)
@@ -168,10 +167,9 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 	if (WARN_ON(--txq->pending_frames < 0))
 		txq->pending_frames = 0;
 
-	hw_queue = (info->hw_queue >= sc->hw->queues - 2) ? q : info->hw_queue;
 	if (txq->stopped &&
 	    txq->pending_frames < sc->tx.txq_max_pending[q]) {
-		ieee80211_wake_queue(sc->hw, hw_queue);
+		ieee80211_wake_queue(sc->hw, info->hw_queue);
 		txq->stopped = false;
 	}
 }
@@ -2208,8 +2206,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf;
 	bool queue;
-	int q, hw_queue;
-	int ret;
+	int q, ret;
 
 	if (vif)
 		avp = (void *)vif->drv_priv;
@@ -2228,14 +2225,13 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 
 	q = skb_get_queue_mapping(skb);
-	hw_queue = (info->hw_queue >= sc->hw->queues - 2) ? q : info->hw_queue;
 
 	ath_txq_lock(sc, txq);
 	if (txq == sc->tx.txq_map[q]) {
 		fi->txq = q;
 		if (++txq->pending_frames > sc->tx.txq_max_pending[q] &&
 		    !txq->stopped) {
-			ieee80211_stop_queue(sc->hw, hw_queue);
+			ieee80211_stop_queue(sc->hw, info->hw_queue);
 			txq->stopped = true;
 		}
 	}
-- 
2.1.0

