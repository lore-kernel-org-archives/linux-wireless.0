Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43258 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab0FLEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	stable@kernel.org
Subject: [PATCH 11/24] ath9k: fix mac80211 queue lookup for waking up queues
Date: Sat, 12 Jun 2010 00:33:49 -0400
Message-Id: <1276317242-15540-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

ath_get_mac80211_qnum() expects the queue 'subtype'
(internal ID for the WMM AC) as argument when looking up
the mac80211 queue, however ath_wake_mac80211_queue provides
txq->axq_qnum instead, which contains the hardware queue
number. Fix this by keeping track of the WMM class ID in
the txq data structure.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c00946d..c5c6629 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -194,6 +194,7 @@ enum ATH_AGGR_STATUS {
 
 #define ATH_TXFIFO_DEPTH 8
 struct ath_txq {
+	int axq_class;
 	u32 axq_qnum;
 	u32 *axq_link;
 	struct list_head axq_q;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7547c8f..ec124fb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -941,6 +941,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	if (!ATH_TXQ_SETUP(sc, qnum)) {
 		struct ath_txq *txq = &sc->tx.txq[qnum];
 
+		txq->axq_class = subtype;
 		txq->axq_qnum = qnum;
 		txq->axq_link = NULL;
 		INIT_LIST_HEAD(&txq->axq_q);
@@ -2047,7 +2048,7 @@ static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
 
 	spin_lock_bh(&txq->axq_lock);
 	if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
-		qnum = ath_get_mac80211_qnum(txq->axq_qnum, sc);
+		qnum = ath_get_mac80211_qnum(txq->axq_class, sc);
 		if (qnum != -1) {
 			ath_mac80211_start_queue(sc, qnum);
 			txq->stopped = 0;
-- 
1.6.3.3

