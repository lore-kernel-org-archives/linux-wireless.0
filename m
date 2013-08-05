Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36200 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab3HET4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 15:56:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 03/12] ath9k: add function for getting the tx tid for a packet
Date: Mon,  5 Aug 2013 21:56:14 +0200
Message-Id: <1375732583-39001-3-git-send-email-nbd@openwrt.org> (sfid-20130805_215648_779011_9B68518F)
In-Reply-To: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ac6bd50..e54c3e5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -168,6 +168,20 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 	}
 }
 
+static struct ath_atx_tid *
+ath_get_skb_tid(struct ath_softc *sc, struct ath_node *an, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	u8 tidno = 0;
+
+	hdr = (struct ieee80211_hdr *) skb->data;
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		tidno = ieee80211_get_qos_ctl(hdr)[0];
+
+	tidno &= IEEE80211_QOS_CTL_TID_MASK;
+	return ATH_AN_2_TID(an, tidno);
+}
+
 static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
 {
 	return !skb_queue_empty(&tid->buf_q) || !skb_queue_empty(&tid->retry_q);
@@ -419,7 +433,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	struct ieee80211_tx_rate rates[4];
 	struct ath_frame_info *fi;
 	int nframes;
-	u8 tidno;
 	bool flush = !!(ts->ts_status & ATH9K_TX_FLUSH);
 	int i, retries;
 	int bar_index = -1;
@@ -456,8 +469,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	}
 
 	an = (struct ath_node *)sta->drv_priv;
-	tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
-	tid = ATH_AN_2_TID(an, tidno);
+	tid = ath_get_skb_tid(sc, an, skb);
 	seq_first = tid->seq_start;
 	isba = ts->ts_flags & ATH9K_TX_BA;
 
@@ -469,7 +481,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	 * Only BlockAcks have a TID and therefore normal Acks cannot be
 	 * checked
 	 */
-	if (isba && tidno != ts->tid)
+	if (isba && tid->tidno != ts->tid)
 		txok = false;
 
 	isaggr = bf_isaggr(bf);
@@ -2116,7 +2128,6 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_txq *txq = txctl->txq;
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf;
-	u8 tidno;
 	int q;
 	int ret;
 
@@ -2147,9 +2158,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	}
 
 	if (txctl->an && ieee80211_is_data_qos(hdr->frame_control)) {
-		tidno = ieee80211_get_qos_ctl(hdr)[0] &
-			IEEE80211_QOS_CTL_TID_MASK;
-		tid = ATH_AN_2_TID(txctl->an, tidno);
+		tid = ath_get_skb_tid(sc, txctl->an, skb);
 
 		WARN_ON(tid->ac->txq != txctl->txq);
 	}
-- 
1.8.0.2

