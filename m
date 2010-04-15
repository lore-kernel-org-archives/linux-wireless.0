Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab0DODa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 88/97] ath9k: Setup appropriate tx desc for regular dma and edma
Date: Wed, 14 Apr 2010 23:30:42 -0400
Message-Id: <1271302251-9075-89-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/init.c  |   26 ++++++++++++++++----------
 drivers/net/wireless/ath/ath9k/recv.c  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |    4 ++--
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a11d830..f67be52 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -123,7 +123,7 @@ struct ath_descdma {
 
 int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		      struct list_head *head, const char *name,
-		      int nbuf, int ndesc);
+		      int nbuf, int ndesc, bool is_tx);
 void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 			 struct list_head *head);
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9779646..299ec05 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -235,31 +235,37 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 */
 int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		      struct list_head *head, const char *name,
-		      int nbuf, int ndesc)
+		      int nbuf, int ndesc, bool is_tx)
 {
 #define	DS2PHYS(_dd, _ds)						\
 	((_dd)->dd_desc_paddr + ((caddr_t)(_ds) - (caddr_t)(_dd)->dd_desc))
 #define ATH_DESC_4KB_BOUND_CHECK(_daddr) ((((_daddr) & 0xFFF) > 0xF7F) ? 1 : 0)
 #define ATH_DESC_4KB_BOUND_NUM_SKIPPED(_len) ((_len) / 4096)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_desc *ds;
+	u8 *ds;
 	struct ath_buf *bf;
-	int i, bsize, error;
+	int i, bsize, error, desc_len;
 
 	ath_print(common, ATH_DBG_CONFIG, "%s DMA: %u buffers %u desc/buf\n",
 		  name, nbuf, ndesc);
 
 	INIT_LIST_HEAD(head);
+
+	if (is_tx)
+		desc_len = sc->sc_ah->caps.tx_desc_len;
+	else
+		desc_len = sizeof(struct ath_desc);
+
 	/* ath_desc must be a multiple of DWORDs */
-	if ((sizeof(struct ath_desc) % 4) != 0) {
+	if ((desc_len % 4) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "ath_desc not DWORD aligned\n");
-		BUG_ON((sizeof(struct ath_desc) % 4) != 0);
+		BUG_ON((desc_len % 4) != 0);
 		error = -ENOMEM;
 		goto fail;
 	}
 
-	dd->dd_desc_len = sizeof(struct ath_desc) * nbuf * ndesc;
+	dd->dd_desc_len = desc_len * nbuf * ndesc;
 
 	/*
 	 * Need additional DMA memory because we can't use
@@ -272,7 +278,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		u32 dma_len;
 
 		while (ndesc_skipped) {
-			dma_len = ndesc_skipped * sizeof(struct ath_desc);
+			dma_len = ndesc_skipped * desc_len;
 			dd->dd_desc_len += dma_len;
 
 			ndesc_skipped = ATH_DESC_4KB_BOUND_NUM_SKIPPED(dma_len);
@@ -286,7 +292,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		error = -ENOMEM;
 		goto fail;
 	}
-	ds = dd->dd_desc;
+	ds = (u8 *) dd->dd_desc;
 	ath_print(common, ATH_DBG_CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
 		  name, ds, (u32) dd->dd_desc_len,
 		  ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
@@ -300,7 +306,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 	dd->dd_bufptr = bf;
 
-	for (i = 0; i < nbuf; i++, bf++, ds += ndesc) {
+	for (i = 0; i < nbuf; i++, bf++, ds += (desc_len * ndesc)) {
 		bf->bf_desc = ds;
 		bf->bf_daddr = DS2PHYS(dd, ds);
 
@@ -316,7 +322,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 				       ((caddr_t) dd->dd_desc +
 					dd->dd_desc_len));
 
-				ds += ndesc;
+				ds += (desc_len * ndesc);
 				bf->bf_desc = ds;
 				bf->bf_daddr = DS2PHYS(dd, ds);
 			}
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ffb599c..921b39d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -324,7 +324,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 		/* Initialize rx descriptors */
 
 		error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
-				"rx", nbufs, 1);
+				"rx", nbufs, 1, 0);
 		if (error != 0) {
 			ath_print(common, ATH_DBG_FATAL,
 				  "failed to allocate rx descriptors: %d\n",
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 550253f..c859e46 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2151,7 +2151,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	spin_lock_init(&sc->tx.txbuflock);
 
 	error = ath_descdma_setup(sc, &sc->tx.txdma, &sc->tx.txbuf,
-				  "tx", nbufs, 1);
+				  "tx", nbufs, 1, 1);
 	if (error != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to allocate tx descriptors: %d\n", error);
@@ -2159,7 +2159,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	}
 
 	error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
-				  "beacon", ATH_BCBUF, 1);
+				  "beacon", ATH_BCBUF, 1, 0);
 	if (error != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to allocate beacon descriptors: %d\n", error);
-- 
1.6.3.3

