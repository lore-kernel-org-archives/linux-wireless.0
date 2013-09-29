Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38643 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab3I2LGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Sep 2013 07:06:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.12] ath9k: fix powersave response handling for BA session packets
Date: Sun, 29 Sep 2013 13:06:31 +0200
Message-Id: <1380452791-1261-1-git-send-email-nbd@openwrt.org> (sfid-20130929_130657_944702_49A8556A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a packet is passed from mac80211 to the driver with the
IEEE80211_TX_CTL_PS_RESPONSE flag set, it bypasses the normal driver
internal queueing and goes directly to the UAPSD queue.

When that happens, packets that are part of a BlockAck session still
need to be tracked as such inside the driver, otherwise it will create
discrepancies in the receiver BA reorder window, causing traffic stalls.
This only happens in AP mode with powersave-enabled clients.

This patch fixes the regression introduced in the commit
"ath9k: use software queues for un-aggregated data packets"

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 13f5434..1ce8af2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1969,15 +1969,18 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 			       struct ath_atx_tid *tid, struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_frame_info *fi = get_frame_info(skb);
 	struct list_head bf_head;
-	struct ath_buf *bf;
-
-	bf = fi->bf;
+	struct ath_buf *bf = fi->bf;
 
 	INIT_LIST_HEAD(&bf_head);
 	list_add_tail(&bf->list, &bf_head);
 	bf->bf_state.bf_type = 0;
+	if (tid && (tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
+		bf->bf_state.bf_type = BUF_AMPDU;
+		ath_tx_addto_baw(sc, tid, bf);
+	}
 
 	bf->bf_next = NULL;
 	bf->bf_lastbf = bf;
-- 
1.8.0.2

