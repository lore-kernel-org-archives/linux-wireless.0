Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55807 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab3JKVbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 17:31:11 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v2 01/10] ath9k: use a separate data structure for rx buffers
Date: Fri, 11 Oct 2013 23:30:52 +0200
Message-Id: <1381527061-43758-1-git-send-email-nbd@openwrt.org> (sfid-20131011_233126_603591_419C6727)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no shared code for handling both rx and tx buffers, and tx
buffers require a lot more metadata than rx buffers.
Using a separate data structure for rx reduces memory usage and improves
cache footprint.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 10 +++-
 drivers/net/wireless/ath/ath9k/init.c  | 84 ++++++++++++++++++++++++----------
 drivers/net/wireless/ath/ath9k/recv.c  | 48 +++++++++----------
 3 files changed, 92 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8878f2d..83c0455 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -207,6 +207,14 @@ struct ath_frame_info {
 	u8 baw_tracked : 1;
 };
 
+struct ath_rxbuf {
+	struct list_head list;
+	struct sk_buff *bf_mpdu;
+	void *bf_desc;
+	dma_addr_t bf_daddr;
+	dma_addr_t bf_buf_addr;
+};
+
 struct ath_buf_state {
 	u8 bf_type;
 	u8 bfs_paprd;
@@ -307,7 +315,7 @@ struct ath_rx {
 	struct ath_descdma rxdma;
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 
-	struct ath_buf *buf_hold;
+	struct ath_rxbuf *buf_hold;
 	struct sk_buff *frag;
 
 	u32 ampdu_ref;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e3d11c4..2306f57 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -347,7 +347,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	u8 *ds;
-	struct ath_buf *bf;
 	int i, bsize, desc_len;
 
 	ath_dbg(common, CONFIG, "%s DMA: %u buffers %u desc/buf\n",
@@ -399,33 +398,68 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
 
 	/* allocate buffers */
-	bsize = sizeof(struct ath_buf) * nbuf;
-	bf = devm_kzalloc(sc->dev, bsize, GFP_KERNEL);
-	if (!bf)
-		return -ENOMEM;
+	if (is_tx) {
+		struct ath_buf *bf;
+
+		bsize = sizeof(struct ath_buf) * nbuf;
+		bf = devm_kzalloc(sc->dev, bsize, GFP_KERNEL);
+		if (!bf)
+			return -ENOMEM;
+
+		for (i = 0; i < nbuf; i++, bf++, ds += (desc_len * ndesc)) {
+			bf->bf_desc = ds;
+			bf->bf_daddr = DS2PHYS(dd, ds);
+
+			if (!(sc->sc_ah->caps.hw_caps &
+				  ATH9K_HW_CAP_4KB_SPLITTRANS)) {
+				/*
+				 * Skip descriptor addresses which can cause 4KB
+				 * boundary crossing (addr + length) with a 32 dword
+				 * descriptor fetch.
+				 */
+				while (ATH_DESC_4KB_BOUND_CHECK(bf->bf_daddr)) {
+					BUG_ON((caddr_t) bf->bf_desc >=
+						   ((caddr_t) dd->dd_desc +
+						dd->dd_desc_len));
+
+					ds += (desc_len * ndesc);
+					bf->bf_desc = ds;
+					bf->bf_daddr = DS2PHYS(dd, ds);
+				}
+			}
+			list_add_tail(&bf->list, head);
+		}
+	} else {
+		struct ath_rxbuf *bf;
+
+		bsize = sizeof(struct ath_rxbuf) * nbuf;
+		bf = devm_kzalloc(sc->dev, bsize, GFP_KERNEL);
+		if (!bf)
+			return -ENOMEM;
 
-	for (i = 0; i < nbuf; i++, bf++, ds += (desc_len * ndesc)) {
-		bf->bf_desc = ds;
-		bf->bf_daddr = DS2PHYS(dd, ds);
-
-		if (!(sc->sc_ah->caps.hw_caps &
-		      ATH9K_HW_CAP_4KB_SPLITTRANS)) {
-			/*
-			 * Skip descriptor addresses which can cause 4KB
-			 * boundary crossing (addr + length) with a 32 dword
-			 * descriptor fetch.
-			 */
-			while (ATH_DESC_4KB_BOUND_CHECK(bf->bf_daddr)) {
-				BUG_ON((caddr_t) bf->bf_desc >=
-				       ((caddr_t) dd->dd_desc +
-					dd->dd_desc_len));
-
-				ds += (desc_len * ndesc);
-				bf->bf_desc = ds;
-				bf->bf_daddr = DS2PHYS(dd, ds);
+		for (i = 0; i < nbuf; i++, bf++, ds += (desc_len * ndesc)) {
+			bf->bf_desc = ds;
+			bf->bf_daddr = DS2PHYS(dd, ds);
+
+			if (!(sc->sc_ah->caps.hw_caps &
+				  ATH9K_HW_CAP_4KB_SPLITTRANS)) {
+				/*
+				 * Skip descriptor addresses which can cause 4KB
+				 * boundary crossing (addr + length) with a 32 dword
+				 * descriptor fetch.
+				 */
+				while (ATH_DESC_4KB_BOUND_CHECK(bf->bf_daddr)) {
+					BUG_ON((caddr_t) bf->bf_desc >=
+						   ((caddr_t) dd->dd_desc +
+						dd->dd_desc_len));
+
+					ds += (desc_len * ndesc);
+					bf->bf_desc = ds;
+					bf->bf_daddr = DS2PHYS(dd, ds);
+				}
 			}
+			list_add_tail(&bf->list, head);
 		}
-		list_add_tail(&bf->list, head);
 	}
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ab9e3a8..8b788ef 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -19,7 +19,7 @@
 #include "ath9k.h"
 #include "ar9003_mac.h"
 
-#define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
+#define SKB_CB_ATHBUF(__skb)	(*((struct ath_rxbuf **)__skb->cb))
 
 static inline bool ath9k_check_auto_sleep(struct ath_softc *sc)
 {
@@ -35,7 +35,7 @@ static inline bool ath9k_check_auto_sleep(struct ath_softc *sc)
  * buffer (or rx fifo). This can incorrectly acknowledge packets
  * to a sender if last desc is self-linked.
  */
-static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
+static void ath_rx_buf_link(struct ath_softc *sc, struct ath_rxbuf *bf)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -68,7 +68,7 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	sc->rx.rxlink = &ds->ds_link;
 }
 
-static void ath_rx_buf_relink(struct ath_softc *sc, struct ath_buf *bf)
+static void ath_rx_buf_relink(struct ath_softc *sc, struct ath_rxbuf *bf)
 {
 	if (sc->rx.buf_hold)
 		ath_rx_buf_link(sc, sc->rx.buf_hold);
@@ -112,13 +112,13 @@ static bool ath_rx_edma_buf_link(struct ath_softc *sc,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_rx_edma *rx_edma;
 	struct sk_buff *skb;
-	struct ath_buf *bf;
+	struct ath_rxbuf *bf;
 
 	rx_edma = &sc->rx.rx_edma[qtype];
 	if (skb_queue_len(&rx_edma->rx_fifo) >= rx_edma->rx_fifo_hwsize)
 		return false;
 
-	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	bf = list_first_entry(&sc->rx.rxbuf, struct ath_rxbuf, list);
 	list_del_init(&bf->list);
 
 	skb = bf->bf_mpdu;
@@ -138,7 +138,7 @@ static void ath_rx_addbuffer_edma(struct ath_softc *sc,
 				  enum ath9k_rx_qtype qtype)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_buf *bf, *tbf;
+	struct ath_rxbuf *bf, *tbf;
 
 	if (list_empty(&sc->rx.rxbuf)) {
 		ath_dbg(common, QUEUE, "No free rx buf available\n");
@@ -154,7 +154,7 @@ static void ath_rx_addbuffer_edma(struct ath_softc *sc,
 static void ath_rx_remove_buffer(struct ath_softc *sc,
 				 enum ath9k_rx_qtype qtype)
 {
-	struct ath_buf *bf;
+	struct ath_rxbuf *bf;
 	struct ath_rx_edma *rx_edma;
 	struct sk_buff *skb;
 
@@ -171,7 +171,7 @@ static void ath_rx_edma_cleanup(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_buf *bf;
+	struct ath_rxbuf *bf;
 
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_LP);
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_HP);
@@ -199,7 +199,7 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_hw *ah = sc->sc_ah;
 	struct sk_buff *skb;
-	struct ath_buf *bf;
+	struct ath_rxbuf *bf;
 	int error = 0, i;
 	u32 size;
 
@@ -211,7 +211,7 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 	ath_rx_edma_init_queue(&sc->rx.rx_edma[ATH9K_RX_QUEUE_HP],
 			       ah->caps.rx_hp_qdepth);
 
-	size = sizeof(struct ath_buf) * nbufs;
+	size = sizeof(struct ath_rxbuf) * nbufs;
 	bf = devm_kzalloc(sc->dev, size, GFP_KERNEL);
 	if (!bf)
 		return -ENOMEM;
@@ -271,7 +271,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct sk_buff *skb;
-	struct ath_buf *bf;
+	struct ath_rxbuf *bf;
 	int error = 0;
 
 	spin_lock_init(&sc->sc_pcu_lock);
@@ -332,7 +332,7 @@ void ath_rx_cleanup(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct sk_buff *skb;
-	struct ath_buf *bf;
+	struct ath_rxbuf *bf;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		ath_rx_edma_cleanup(sc);
@@ -427,7 +427,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 int ath_startrecv(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_buf *bf, *tbf;
+	struct ath_rxbuf *bf, *tbf;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		ath_edma_start_recv(sc);
@@ -447,7 +447,7 @@ int ath_startrecv(struct ath_softc *sc)
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
-	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	bf = list_first_entry(&sc->rx.rxbuf, struct ath_rxbuf, list);
 	ath9k_hw_putrxbuf(ah, bf->bf_daddr);
 	ath9k_hw_rxena(ah);
 
@@ -603,13 +603,13 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb, bool mybeacon)
 static bool ath_edma_get_buffers(struct ath_softc *sc,
 				 enum ath9k_rx_qtype qtype,
 				 struct ath_rx_status *rs,
-				 struct ath_buf **dest)
+				 struct ath_rxbuf **dest)
 {
 	struct ath_rx_edma *rx_edma = &sc->rx.rx_edma[qtype];
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct sk_buff *skb;
-	struct ath_buf *bf;
+	struct ath_rxbuf *bf;
 	int ret;
 
 	skb = skb_peek(&rx_edma->rx_fifo);
@@ -653,11 +653,11 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
 	return true;
 }
 
-static struct ath_buf *ath_edma_get_next_rx_buf(struct ath_softc *sc,
+static struct ath_rxbuf *ath_edma_get_next_rx_buf(struct ath_softc *sc,
 						struct ath_rx_status *rs,
 						enum ath9k_rx_qtype qtype)
 {
-	struct ath_buf *bf = NULL;
+	struct ath_rxbuf *bf = NULL;
 
 	while (ath_edma_get_buffers(sc, qtype, rs, &bf)) {
 		if (!bf)
@@ -668,13 +668,13 @@ static struct ath_buf *ath_edma_get_next_rx_buf(struct ath_softc *sc,
 	return NULL;
 }
 
-static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
+static struct ath_rxbuf *ath_get_next_rx_buf(struct ath_softc *sc,
 					   struct ath_rx_status *rs)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_desc *ds;
-	struct ath_buf *bf;
+	struct ath_rxbuf *bf;
 	int ret;
 
 	if (list_empty(&sc->rx.rxbuf)) {
@@ -682,7 +682,7 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 		return NULL;
 	}
 
-	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	bf = list_first_entry(&sc->rx.rxbuf, struct ath_rxbuf, list);
 	if (bf == sc->rx.buf_hold)
 		return NULL;
 
@@ -702,7 +702,7 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 	ret = ath9k_hw_rxprocdesc(ah, ds, rs);
 	if (ret == -EINPROGRESS) {
 		struct ath_rx_status trs;
-		struct ath_buf *tbf;
+		struct ath_rxbuf *tbf;
 		struct ath_desc *tds;
 
 		memset(&trs, 0, sizeof(trs));
@@ -711,7 +711,7 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 			return NULL;
 		}
 
-		tbf = list_entry(bf->list.next, struct ath_buf, list);
+		tbf = list_entry(bf->list.next, struct ath_rxbuf, list);
 
 		/*
 		 * On some hardware the descriptor status words could
@@ -1308,7 +1308,7 @@ static void ath9k_apply_ampdu_details(struct ath_softc *sc,
 
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
-	struct ath_buf *bf;
+	struct ath_rxbuf *bf;
 	struct sk_buff *skb = NULL, *requeue_skb, *hdr_skb;
 	struct ieee80211_rx_status *rxs;
 	struct ath_hw *ah = sc->sc_ah;
-- 
1.8.0.2

