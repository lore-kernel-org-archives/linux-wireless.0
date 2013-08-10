Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59976 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933743Ab3HJN71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 09:59:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 2/2] ath9k: shrink a few data structures by reordering fields
Date: Sat, 10 Aug 2013 15:59:16 +0200
Message-Id: <1376143156-74164-2-git-send-email-nbd@openwrt.org> (sfid-20130810_155931_740241_2A85D855)
In-Reply-To: <1376143156-74164-1-git-send-email-nbd@openwrt.org>
References: <1376143156-74164-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also reduce the size of a few fields where possible

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 12 ++++++------
 drivers/net/wireless/ath/ath9k/xmit.c  | 16 ++++++++--------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0d69b13..7b1d036 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -72,7 +72,6 @@ struct ath_config {
 /*************************/
 
 #define ATH_TXBUF_RESET(_bf) do {				\
-		(_bf)->bf_stale = false;			\
 		(_bf)->bf_lastbf = NULL;			\
 		(_bf)->bf_next = NULL;				\
 		memset(&((_bf)->bf_state), 0,			\
@@ -192,10 +191,10 @@ struct ath_txq {
 
 struct ath_atx_ac {
 	struct ath_txq *txq;
-	int sched;
 	struct list_head list;
 	struct list_head tid_q;
 	bool clear_ps_filter;
+	bool sched;
 };
 
 struct ath_frame_info {
@@ -212,6 +211,7 @@ struct ath_buf_state {
 	u8 bf_type;
 	u8 bfs_paprd;
 	u8 ndelim;
+	bool stale;
 	u16 seqno;
 	unsigned long bfs_paprd_timestamp;
 };
@@ -225,7 +225,6 @@ struct ath_buf {
 	void *bf_desc;			/* virtual addr of desc */
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;	/* physical addr of data buffer, for DMA */
-	bool bf_stale;
 	struct ieee80211_tx_rate rates[4];
 	struct ath_buf_state bf_state;
 };
@@ -237,13 +236,14 @@ struct ath_atx_tid {
 	struct ath_node *an;
 	struct ath_atx_ac *ac;
 	unsigned long tx_buf[BITS_TO_LONGS(ATH_TID_MAX_BUFS)];
-	int bar_index;
 	u16 seq_start;
 	u16 seq_next;
 	u16 baw_size;
-	int tidno;
+	u8 tidno;
 	int baw_head;   /* first un-acked tx buffer */
 	int baw_tail;   /* next unused tx buffer slot */
+
+	s8 bar_index;
 	bool sched;
 	bool paused;
 	bool active;
@@ -255,10 +255,10 @@ struct ath_node {
 	struct ieee80211_vif *vif; /* interface with which we're associated */
 	struct ath_atx_tid tid[IEEE80211_NUM_TIDS];
 	struct ath_atx_ac ac[IEEE80211_NUM_ACS];
-	int ps_key;
 
 	u16 maxampdu;
 	u8 mpdudensity;
+	s8 ps_key;
 
 	bool sleeping;
 	bool no_ps_filter;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d8dfb3e..4fc80e3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -493,7 +493,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		while (bf) {
 			bf_next = bf->bf_next;
 
-			if (!bf->bf_stale || bf_next != NULL)
+			if (!bf->bf_state.stale || bf_next != NULL)
 				list_move_tail(&bf->list, &bf_head);
 
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts, 0);
@@ -586,7 +586,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		 * not a holding desc.
 		 */
 		INIT_LIST_HEAD(&bf_head);
-		if (bf_next != NULL || !bf_last->bf_stale)
+		if (bf_next != NULL || !bf_last->bf_state.stale)
 			list_move_tail(&bf->list, &bf_head);
 
 		if (!txpending) {
@@ -610,7 +610,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				ieee80211_sta_eosp(sta);
 			}
 			/* retry the un-acked ones */
-			if (bf->bf_next == NULL && bf_last->bf_stale) {
+			if (bf->bf_next == NULL && bf_last->bf_state.stale) {
 				struct ath_buf *tbf;
 
 				tbf = ath_clone_txbuf(sc, bf_last);
@@ -1734,7 +1734,7 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 	while (!list_empty(list)) {
 		bf = list_first_entry(list, struct ath_buf, list);
 
-		if (bf->bf_stale) {
+		if (bf->bf_state.stale) {
 			list_del(&bf->list);
 
 			ath_tx_return_buffer(sc, bf);
@@ -2490,7 +2490,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		 * it with the STALE flag.
 		 */
 		bf_held = NULL;
-		if (bf->bf_stale) {
+		if (bf->bf_state.stale) {
 			bf_held = bf;
 			if (list_is_last(&bf_held->list, &txq->axq_q))
 				break;
@@ -2514,7 +2514,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		 * however leave the last descriptor back as the holding
 		 * descriptor for hw.
 		 */
-		lastbf->bf_stale = true;
+		lastbf->bf_state.stale = true;
 		INIT_LIST_HEAD(&bf_head);
 		if (!list_is_singular(&lastbf->list))
 			list_cut_position(&bf_head,
@@ -2585,7 +2585,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		}
 
 		bf = list_first_entry(fifo_list, struct ath_buf, list);
-		if (bf->bf_stale) {
+		if (bf->bf_state.stale) {
 			list_del(&bf->list);
 			ath_tx_return_buffer(sc, bf);
 			bf = list_first_entry(fifo_list, struct ath_buf, list);
@@ -2607,7 +2607,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 				ath_tx_txqaddbuf(sc, txq, &bf_q, true);
 			}
 		} else {
-			lastbf->bf_stale = true;
+			lastbf->bf_state.stale = true;
 			if (bf != lastbf)
 				list_cut_position(&bf_head, fifo_list,
 						  lastbf->list.prev);
-- 
1.8.0.2

