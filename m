Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56660 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab1LLUGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 15:06:46 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/6] ath9k: change maximum software retransmission handling
Date: Mon, 12 Dec 2011 21:06:21 +0100
Message-Id: <1323720386-46132-1-git-send-email-nbd@openwrt.org> (sfid-20111212_210649_767111_3D5477C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of limiting a subframe to 10 A-MPDU software transmission attempts,
count hardware retransmissions as well and raise the limit a bit. That way
there will be fewer software retransmission attempts when traffic suffers
from lots of hardware retransmissions.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |   15 ++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index afc156a..fa6c905 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -542,7 +542,7 @@ struct ath_ant_comb {
 #define DEFAULT_CACHELINE       32
 #define ATH_REGCLASSIDS_MAX     10
 #define ATH_CABQ_READY_TIME     80      /* % of beacon interval */
-#define ATH_MAX_SW_RETRIES      10
+#define ATH_MAX_SW_RETRIES      30
 #define ATH_CHAN_MAX            255
 
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9e65c31..a46b4e2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -264,14 +264,17 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 }
 
 static void ath_tx_set_retry(struct ath_softc *sc, struct ath_txq *txq,
-			     struct sk_buff *skb)
+			     struct sk_buff *skb, int count)
 {
 	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ath_buf *bf = fi->bf;
 	struct ieee80211_hdr *hdr;
+	int prev = fi->retries;
 
 	TX_STAT_INC(txq->axq_qnum, a_retries);
-	if (fi->retries++ > 0)
+	fi->retries += count;
+
+	if (prev > 0)
 		return;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -379,6 +382,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	int nframes;
 	u8 tidno;
 	bool flush = !!(ts->ts_status & ATH9K_TX_FLUSH);
+	int i, retries;
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -387,6 +391,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	memcpy(rates, tx_info->control.rates, sizeof(rates));
 
+	retries = ts->ts_longretry + 1;
+	for (i = 0; i < ts->ts_rateindex; i++)
+		retries += rates[i].count;
+
 	rcu_read_lock();
 
 	sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr1, hdr->addr2);
@@ -471,7 +479,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				txpending = 1;
 			} else if (fi->retries < ATH_MAX_SW_RETRIES) {
 				if (txok || !an->sleeping)
-					ath_tx_set_retry(sc, txq, bf->bf_mpdu);
+					ath_tx_set_retry(sc, txq, bf->bf_mpdu,
+							 retries);
 
 				txpending = 1;
 			} else {
-- 
1.7.3.2

