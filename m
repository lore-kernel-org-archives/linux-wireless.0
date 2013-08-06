Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57814 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275Ab3HFMSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 08:18:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 03/12] ath9k: add function for getting the tx tid for a packet
Date: Tue,  6 Aug 2013 14:18:04 +0200
Message-Id: <1375791493-83971-3-git-send-email-nbd@openwrt.org> (sfid-20130806_141843_437531_CB73CBAA)
In-Reply-To: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
References: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c2b6cf0..350429b 100644
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

