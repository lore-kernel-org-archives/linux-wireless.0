Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40248 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0JNTNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 15:13:43 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Remove bf_dmacontext, null out stale pointers.
Date: Thu, 14 Oct 2010 12:13:21 -0700
Message-Id: <1287083601-1293-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The bf_dmacontext seems to be totally useless and duplicated
by bf_buf_addr.  Remove it entirely, use bf_buf_addr in its
place.

Also null out bf_buf_addr and bf_mpdu pointers when resources
they are pointing to are no longer owned by the buffer object.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 4e81fe3... 0c917e5... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 8e43443... 97d471f... M	drivers/net/wireless/ath/ath9k/beacon.c
:100644 100644 714d9a8... fd778d2... M	drivers/net/wireless/ath/ath9k/recv.c
:100644 100644 6d41d47... a5e5f27... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/ath9k.h  |    3 +--
 drivers/net/wireless/ath/ath9k/beacon.c |   21 ++++++++++++---------
 drivers/net/wireless/ath/ath9k/recv.c   |    7 +++++--
 drivers/net/wireless/ath/ath9k/xmit.c   |   17 ++++++++++-------
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4e81fe3..0c917e5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -239,12 +239,11 @@ struct ath_buf {
 	struct sk_buff *bf_mpdu;	/* enclosing frame structure */
 	void *bf_desc;			/* virtual addr of desc */
 	dma_addr_t bf_daddr;		/* physical addr of desc */
-	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
+	dma_addr_t bf_buf_addr;	/* physical addr of data buffer, for DMA */
 	bool bf_stale;
 	bool bf_tx_aborted;
 	u16 bf_flags;
 	struct ath_buf_state bf_state;
-	dma_addr_t bf_dmacontext;
 	struct ath_wiphy *aphy;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 8e43443..97d471f 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -136,9 +136,10 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	bf = avp->av_bcbuf;
 	skb = bf->bf_mpdu;
 	if (skb) {
-		dma_unmap_single(sc->dev, bf->bf_dmacontext,
+		dma_unmap_single(sc->dev, bf->bf_buf_addr,
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
+		bf->bf_buf_addr = 0;
 	}
 
 	/* Get a new beacon from mac80211 */
@@ -162,12 +163,12 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
 	}
 
-	bf->bf_buf_addr = bf->bf_dmacontext =
-		dma_map_single(sc->dev, skb->data,
-			       skb->len, DMA_TO_DEVICE);
+	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
+					 skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
+		bf->bf_buf_addr = 0;
 		ath_print(common, ATH_DBG_FATAL,
 			  "dma_mapping_error on beaconing\n");
 		return NULL;
@@ -252,10 +253,11 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 	bf = avp->av_bcbuf;
 	if (bf->bf_mpdu != NULL) {
 		skb = bf->bf_mpdu;
-		dma_unmap_single(sc->dev, bf->bf_dmacontext,
+		dma_unmap_single(sc->dev, bf->bf_buf_addr,
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
+		bf->bf_buf_addr = 0;
 	}
 
 	/* NB: the beacon data buffer must be 32-bit aligned. */
@@ -296,12 +298,12 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 		avp->tsf_adjust = cpu_to_le64(0);
 
 	bf->bf_mpdu = skb;
-	bf->bf_buf_addr = bf->bf_dmacontext =
-		dma_map_single(sc->dev, skb->data,
-			       skb->len, DMA_TO_DEVICE);
+	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
+					 skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
+		bf->bf_buf_addr = 0;
 		ath_print(common, ATH_DBG_FATAL,
 			  "dma_mapping_error on beacon alloc\n");
 		return -ENOMEM;
@@ -324,10 +326,11 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 		bf = avp->av_bcbuf;
 		if (bf->bf_mpdu != NULL) {
 			struct sk_buff *skb = bf->bf_mpdu;
-			dma_unmap_single(sc->dev, bf->bf_dmacontext,
+			dma_unmap_single(sc->dev, bf->bf_buf_addr,
 					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
+			bf->bf_buf_addr = 0;
 		}
 		list_add_tail(&bf->list, &sc->beacon.bbuf);
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 714d9a8..fd778d2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -270,6 +270,7 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 						bf->bf_buf_addr))) {
 				dev_kfree_skb_any(skb);
 				bf->bf_mpdu = NULL;
+				bf->bf_buf_addr = 0;
 				ath_print(common, ATH_DBG_FATAL,
 					"dma_mapping_error() on RX init\n");
 				error = -ENOMEM;
@@ -360,12 +361,12 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 							bf->bf_buf_addr))) {
 				dev_kfree_skb_any(skb);
 				bf->bf_mpdu = NULL;
+				bf->bf_buf_addr = 0;
 				ath_print(common, ATH_DBG_FATAL,
 					  "dma_mapping_error() on RX init\n");
 				error = -ENOMEM;
 				goto err;
 			}
-			bf->bf_dmacontext = bf->bf_buf_addr;
 		}
 		sc->rx.rxlink = NULL;
 	}
@@ -395,6 +396,8 @@ void ath_rx_cleanup(struct ath_softc *sc)
 						common->rx_bufsize,
 						DMA_FROM_DEVICE);
 				dev_kfree_skb(skb);
+				bf->bf_buf_addr = 0;
+				bf->bf_mpdu = NULL;
 			}
 		}
 
@@ -1739,12 +1742,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
 			bf->bf_mpdu = NULL;
+			bf->bf_buf_addr = 0;
 			ath_print(common, ATH_DBG_FATAL,
 				  "dma_mapping_error() on RX\n");
 			ath_rx_send_to_mac80211(hw, sc, skb, rxs);
 			break;
 		}
-		bf->bf_dmacontext = bf->bf_buf_addr;
 
 		/*
 		 * change the default rx antenna if rx diversity chooses the
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6d41d47..a5e5f27 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -294,7 +294,6 @@ static struct ath_buf* ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
 	tbf->bf_buf_addr = bf->bf_buf_addr;
 	memcpy(tbf->bf_desc, bf->bf_desc, sc->sc_ah->caps.tx_desc_len);
 	tbf->bf_state = bf->bf_state;
-	tbf->bf_dmacontext = bf->bf_dmacontext;
 
 	return tbf;
 }
@@ -1642,17 +1641,16 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 
 	bf->bf_mpdu = skb;
 
-	bf->bf_dmacontext = dma_map_single(sc->dev, skb->data,
-					   skb->len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sc->dev, bf->bf_dmacontext))) {
+	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
+					 skb->len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		bf->bf_mpdu = NULL;
+		bf->bf_buf_addr = 0;
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
 			  "dma_mapping_error() on TX\n");
 		return -ENOMEM;
 	}
 
-	bf->bf_buf_addr = bf->bf_dmacontext;
-
 	bf->bf_tx_aborted = false;
 
 	return 0;
@@ -1916,7 +1914,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 			tx_flags |= ATH_TX_XRETRY;
 	}
 
-	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
+	dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
+	bf->bf_buf_addr = 0;
 
 	if (bf->bf_state.bfs_paprd) {
 		if (time_after(jiffies,
@@ -1929,6 +1928,10 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 		ath_debug_stat_tx(sc, txq, bf, ts);
 		ath_tx_complete(sc, skb, bf->aphy, tx_flags);
 	}
+	/* At this point, skb (bf->bf_mpdu) is consumed...make sure we don't
+	 * accidentally reference it later.
+	 */
+	bf->bf_mpdu = NULL;
 
 	/*
 	 * Return the list of ath_buf of this mpdu to free queue
-- 
1.7.2.2

