Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:45622
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754779AbaGPTKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 15:10:15 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k: fix pending tx frames accounting
Date: Wed, 16 Jul 2014 20:26:05 +0200
Message-Id: <1405535165-49881-1-git-send-email-nbd@openwrt.org> (sfid-20140716_211019_372468_04A983A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Packets originally buffered for the regular hardware tx queues can end
up being transmitted through the U-APSD queue (via PS-Poll or U-APSD).
When packets are dropped due to retransmit failures, the pending frames
counter is not always updated properly.
Fix this by keeping track of the queue that a frame was accounted for in
the ath_frame_info struct, and using that on completion to decide
whether the counter should be updated.
This fixes some spurious transmit queue hangs.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c  | 25 ++++++++++++++-----------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 11b5e4d..7fc13a8 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -182,7 +182,8 @@ struct ath_atx_ac {
 
 struct ath_frame_info {
 	struct ath_buf *bf;
-	int framelen;
+	u16 framelen;
+	s8 txq;
 	enum ath9k_key_type keytype;
 	u8 keyix;
 	u8 rtscts_rate;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d4927c9..3611529 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -157,15 +157,14 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 			     struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int q, hw_queue;
-
-	q = skb_get_queue_mapping(skb);
-	if (txq == sc->tx.uapsdq)
-		txq = sc->tx.txq_map[q];
+	struct ath_frame_info *fi = get_frame_info(skb);
+	int hw_queue;
+	int q = fi->txq;
 
-	if (txq != sc->tx.txq_map[q])
+	if (q < 0)
 		return;
 
+	txq = sc->tx.txq_map[q];
 	if (WARN_ON(--txq->pending_frames < 0))
 		txq->pending_frames = 0;
 
@@ -2036,6 +2035,7 @@ static void setup_frame_info(struct ieee80211_hw *hw,
 		an = (struct ath_node *) sta->drv_priv;
 
 	memset(fi, 0, sizeof(*fi));
+	fi->txq = -1;
 	if (hw_key)
 		fi->keyix = hw_key->hw_key_idx;
 	else if (an && ieee80211_is_data(hdr->frame_control) && an->ps_key > 0)
@@ -2187,6 +2187,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = txctl->sta;
 	struct ieee80211_vif *vif = info->control.vif;
+	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ath_vif *avp = NULL;
 	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
@@ -2216,11 +2217,13 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	hw_queue = (info->hw_queue >= sc->hw->queues - 2) ? q : info->hw_queue;
 
 	ath_txq_lock(sc, txq);
-	if (txq == sc->tx.txq_map[q] &&
-	    ++txq->pending_frames > sc->tx.txq_max_pending[q] &&
-	    !txq->stopped) {
-		ieee80211_stop_queue(sc->hw, hw_queue);
-		txq->stopped = true;
+	if (txq == sc->tx.txq_map[q]) {
+		fi->txq = q;
+		if (++txq->pending_frames > sc->tx.txq_max_pending[q] &&
+		    !txq->stopped) {
+			ieee80211_stop_queue(sc->hw, hw_queue);
+			txq->stopped = true;
+		}
 	}
 
 	queue = ieee80211_is_data_present(hdr->frame_control);
-- 
1.8.5.2 (Apple Git-48)

