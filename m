Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab0DODa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 89/97] ath9k: Initialize and configure tx status for EDMA
Date: Wed, 14 Apr 2010 23:30:43 -0400
Message-Id: <1271302251-9075-90-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Also add a function to clean up tx status ring.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 +++-
 drivers/net/wireless/ath/ath9k/hw.c    |    1 +
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   46 +++++++++++++++++++++++++++++++-
 4 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f67be52..2d3e42a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -114,8 +114,10 @@ enum buffer_type {
 #define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
 #define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
 
+#define ATH_TXSTATUS_RING_SIZE 64
+
 struct ath_descdma {
-	struct ath_desc *dd_desc;
+	void *dd_desc;
 	dma_addr_t dd_desc_paddr;
 	u32 dd_desc_len;
 	struct ath_buf *dd_bufptr;
@@ -515,6 +517,8 @@ struct ath_softc {
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
 	struct ath_btcoex btcoex;
+
+	struct ath_descdma txsdma;
 };
 
 struct ath_wiphy {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index bd45d4b..58c9bc9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2093,6 +2093,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->rx_lp_qdepth = ATH9K_HW_RX_LP_QDEPTH;
 		pCap->rx_status_len = sizeof(struct ar9003_rxs);
 		pCap->tx_desc_len = sizeof(struct ar9003_txc);
+		pCap->txs_len = sizeof(struct ar9003_txs);
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6b0ab5d..23262f4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -210,6 +210,7 @@ struct ath9k_hw_capabilities {
 	u8 rx_lp_qdepth;
 	u8 rx_status_len;
 	u8 tx_desc_len;
+	u8 txs_len;
 };
 
 struct ath9k_ops_config {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c859e46..84a7b4d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2143,6 +2143,41 @@ void ath_tx_tasklet(struct ath_softc *sc)
 /* Init, Cleanup */
 /*****************/
 
+static int ath_txstatus_setup(struct ath_softc *sc, int size)
+{
+	struct ath_descdma *dd = &sc->txsdma;
+	u8 txs_len = sc->sc_ah->caps.txs_len;
+
+	dd->dd_desc_len = size * txs_len;
+	dd->dd_desc = dma_alloc_coherent(sc->dev, dd->dd_desc_len,
+					 &dd->dd_desc_paddr, GFP_KERNEL);
+	if (!dd->dd_desc)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int ath_tx_edma_init(struct ath_softc *sc)
+{
+	int err;
+
+	err = ath_txstatus_setup(sc, ATH_TXSTATUS_RING_SIZE);
+	if (!err)
+		ath9k_hw_setup_statusring(sc->sc_ah, sc->txsdma.dd_desc,
+					  sc->txsdma.dd_desc_paddr,
+					  ATH_TXSTATUS_RING_SIZE);
+
+	return err;
+}
+
+static void ath_tx_edma_cleanup(struct ath_softc *sc)
+{
+	struct ath_descdma *dd = &sc->txsdma;
+
+	dma_free_coherent(sc->dev, dd->dd_desc_len, dd->dd_desc,
+			  dd->dd_desc_paddr);
+}
+
 int ath_tx_init(struct ath_softc *sc, int nbufs)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -2159,7 +2194,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	}
 
 	error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
-				  "beacon", ATH_BCBUF, 1, 0);
+				  "beacon", ATH_BCBUF, 1, 1);
 	if (error != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to allocate beacon descriptors: %d\n", error);
@@ -2168,6 +2203,12 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 
 	INIT_DELAYED_WORK(&sc->tx_complete_work, ath_tx_complete_poll_work);
 
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		error = ath_tx_edma_init(sc);
+		if (error)
+			goto err;
+	}
+
 err:
 	if (error != 0)
 		ath_tx_cleanup(sc);
@@ -2182,6 +2223,9 @@ void ath_tx_cleanup(struct ath_softc *sc)
 
 	if (sc->tx.txdma.dd_desc_len != 0)
 		ath_descdma_cleanup(sc, &sc->tx.txdma, &sc->tx.txbuf);
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		ath_tx_edma_cleanup(sc);
 }
 
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
-- 
1.6.3.3

