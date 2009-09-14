Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/11] ath9k: remove driver ASSERT, just use BUG_ON()
Date: Mon, 14 Sep 2009 04:37:25 -0400
Message-Id: <1252917448-10744-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 --
 drivers/net/wireless/ath/ath9k/hw.c    |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |    4 ++--
 drivers/net/wireless/ath/ath9k/rc.c    |    8 ++++----
 drivers/net/wireless/ath/ath9k/recv.c  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |   12 ++++++------
 6 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f3b5a60..e512d51 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -54,8 +54,6 @@ struct ath_node;
 
 #define A_MAX(a, b) ((a) > (b) ? (a) : (b))
 
-#define ASSERT(exp) BUG_ON(!(exp))
-
 #define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 75831a1..f993631 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3774,7 +3774,7 @@ void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio)
 {
 	u32 gpio_shift;
 
-	ASSERT(gpio < ah->caps.num_gpio_pins);
+	BUG_ON(gpio >= ah->caps.num_gpio_pins);
 
 	gpio_shift = gpio << 1;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8b9ce67..e38baed 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2034,7 +2034,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	if ((sizeof(struct ath_desc) % 4) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "ath_desc not DWORD aligned\n");
-		ASSERT((sizeof(struct ath_desc) % 4) == 0);
+		BUG_ON((sizeof(struct ath_desc) % 4) != 0);
 		error = -ENOMEM;
 		goto fail;
 	}
@@ -2092,7 +2092,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 			 * descriptor fetch.
 			 */
 			while (ATH_DESC_4KB_BOUND_CHECK(bf->bf_daddr)) {
-				ASSERT((caddr_t) bf->bf_desc <
+				BUG_ON((caddr_t) bf->bf_desc >=
 				       ((caddr_t) dd->dd_desc +
 					dd->dd_desc_len));
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 7346649..0639364 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -425,7 +425,7 @@ static void ath_rc_init_valid_txmask(struct ath_rate_priv *ath_rc_priv)
 static inline void ath_rc_set_valid_txmask(struct ath_rate_priv *ath_rc_priv,
 					   u8 index, int valid_tx_rate)
 {
-	ASSERT(index <= ath_rc_priv->rate_table_size);
+	BUG_ON(index > ath_rc_priv->rate_table_size);
 	ath_rc_priv->valid_rate_index[index] = valid_tx_rate ? 1 : 0;
 }
 
@@ -1243,7 +1243,7 @@ static void ath_rc_init(struct ath_softc *sc,
 
 	ath_rc_priv->rate_table_size = hi + 1;
 	ath_rc_priv->rate_max_phy = 0;
-	ASSERT(ath_rc_priv->rate_table_size <= RATE_TABLE_SIZE);
+	BUG_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
 
 	for (i = 0, k = 0; i < WLAN_RC_PHY_MAX; i++) {
 		for (j = 0; j < ath_rc_priv->valid_phy_ratecnt[i]; j++) {
@@ -1257,8 +1257,8 @@ static void ath_rc_init(struct ath_softc *sc,
 
 		ath_rc_priv->rate_max_phy = ath_rc_priv->valid_phy_rateidx[i][j-1];
 	}
-	ASSERT(ath_rc_priv->rate_table_size <= RATE_TABLE_SIZE);
-	ASSERT(k <= RATE_TABLE_SIZE);
+	BUG_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
+	BUG_ON(k > RATE_TABLE_SIZE);
 
 	ath_rc_priv->max_valid_rate = k;
 	ath_rc_sort_validrates(rate_table, ath_rc_priv);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6caef1b..3a2204d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -59,7 +59,7 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 
 	/* virtual addr of the beginning of the buffer. */
 	skb = bf->bf_mpdu;
-	ASSERT(skb != NULL);
+	BUG_ON(skb == NULL);
 	ds->ds_vdata = skb->data;
 
 	/* setup rx descriptors. The rx.bufsize here tells the harware
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f302652..a8620b1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -107,7 +107,7 @@ static void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
 
-	ASSERT(tid->paused > 0);
+	BUG_ON(tid->paused <= 0);
 	spin_lock_bh(&txq->axq_lock);
 
 	tid->paused--;
@@ -131,7 +131,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	struct list_head bf_head;
 	INIT_LIST_HEAD(&bf_head);
 
-	ASSERT(tid->paused > 0);
+	BUG_ON(tid->paused <= 0);
 	spin_lock_bh(&txq->axq_lock);
 
 	tid->paused--;
@@ -143,7 +143,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 
 	while (!list_empty(&tid->buf_q)) {
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
-		ASSERT(!bf_isretried(bf));
+		BUG_ON(bf_isretried(bf));
 		list_move_tail(&bf->list, &bf_head);
 		ath_tx_send_ht_normal(sc, txq, tid, &bf_head);
 	}
@@ -178,7 +178,7 @@ static void ath_tx_addto_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 	index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
 	cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
 
-	ASSERT(tid->tx_buf[cindex] == NULL);
+	BUG_ON(tid->tx_buf[cindex] != NULL);
 	tid->tx_buf[cindex] = bf;
 
 	if (index >= ((tid->baw_tail - tid->baw_head) &
@@ -358,7 +358,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			else
 				INIT_LIST_HEAD(&bf_head);
 		} else {
-			ASSERT(!list_empty(bf_q));
+			BUG_ON(list_empty(bf_q));
 			list_move_tail(&bf->list, &bf_head);
 		}
 
@@ -946,7 +946,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 		return 0;
 	}
 
-	ASSERT(sc->tx.txq[qnum].axq_qnum == qnum);
+	BUG_ON(sc->tx.txq[qnum].axq_qnum != qnum);
 
 	ath9k_hw_get_txq_props(ah, qnum, &qi);
 	qi.tqi_aifs = qinfo->tqi_aifs;
-- 
1.6.3.3

