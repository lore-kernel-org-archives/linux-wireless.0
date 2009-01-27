Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32895 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZA0IEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 03:04:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 00:04:11 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18814.48933.653710.927929@gargle.gargle.HOWL> (sfid-20090127_090419_362617_18CD4A8A)
Date: Tue, 27 Jan 2009 13:30:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Fix station access in aggregation completion
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee80211_sta pointer in the SKB's TX control info
area is not guaranteed to be valid after returning from the tx() callback.
Use ieee80211_find_sta() instead and return early if the station
is no longer present.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 1b83673..007ca91 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -268,7 +268,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 {
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
-	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_sta *sta;
+	struct ieee80211_hdr *hdr;
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf_next, *bf_last = bf->bf_lastbf;
 	struct ath_desc *ds = bf_last->bf_desc;
@@ -278,13 +279,19 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0;
 
 	skb = (struct sk_buff *)bf->bf_mpdu;
-	tx_info = IEEE80211_SKB_CB(skb);
+	hdr = (struct ieee80211_hdr *)skb->data;
 
-	if (tx_info->control.sta) {
-		an = (struct ath_node *)tx_info->control.sta->drv_priv;
-		tid = ATH_AN_2_TID(an, bf->bf_tidno);
+	rcu_read_lock();
+
+	sta = ieee80211_find_sta(sc->hw, hdr->addr1);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
 	}
 
+	an = (struct ath_node *)sta->drv_priv;
+	tid = ATH_AN_2_TID(an, bf->bf_tidno);
+
 	isaggr = bf_isaggr(bf);
 	memset(ba, 0, WME_BA_BMP_SIZE >> 3);
 
@@ -391,6 +398,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			/* send buffered frames as singles */
 			ath_tx_flush_tid(sc, tid);
 		}
+		rcu_read_unlock();
 		return;
 	}
 
@@ -402,6 +410,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		spin_unlock_bh(&txq->axq_lock);
 	}
 
+	rcu_read_unlock();
+
 	if (needreset)
 		ath_reset(sc, false);
 }
-- 
1.6.1

