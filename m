Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55435 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0JNTph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 15:45:37 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath9k:  Remove bf_dmacontext.
Date: Thu, 14 Oct 2010 12:45:29 -0700
Message-Id: <1287085530-7262-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The bf_dmacontext seems to be totally useless and duplicated
by bf_buf_addr.  Remove it entirely, use bf_buf_addr in its
place.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 4e81fe3... 0c917e5... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 8e43443... df6a9fa... M	drivers/net/wireless/ath/ath9k/beacon.c
:100644 100644 714d9a8... cd748ab... M	drivers/net/wireless/ath/ath9k/recv.c
:100644 100644 6d41d47... e1ce8cc... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/ath9k.h  |    3 +--
 drivers/net/wireless/ath/ath9k/beacon.c |   16 +++++++---------
 drivers/net/wireless/ath/ath9k/recv.c   |    2 --
 drivers/net/wireless/ath/ath9k/xmit.c   |   11 ++++-------
 4 files changed, 12 insertions(+), 20 deletions(-)

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
index 8e43443..df6a9fa 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -136,7 +136,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	bf = avp->av_bcbuf;
 	skb = bf->bf_mpdu;
 	if (skb) {
-		dma_unmap_single(sc->dev, bf->bf_dmacontext,
+		dma_unmap_single(sc->dev, bf->bf_buf_addr,
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 	}
@@ -162,9 +162,8 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
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
@@ -252,7 +251,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 	bf = avp->av_bcbuf;
 	if (bf->bf_mpdu != NULL) {
 		skb = bf->bf_mpdu;
-		dma_unmap_single(sc->dev, bf->bf_dmacontext,
+		dma_unmap_single(sc->dev, bf->bf_buf_addr,
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
@@ -296,9 +295,8 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
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
@@ -324,7 +322,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 		bf = avp->av_bcbuf;
 		if (bf->bf_mpdu != NULL) {
 			struct sk_buff *skb = bf->bf_mpdu;
-			dma_unmap_single(sc->dev, bf->bf_dmacontext,
+			dma_unmap_single(sc->dev, bf->bf_buf_addr,
 					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 714d9a8..cd748ab 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -365,7 +365,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 				error = -ENOMEM;
 				goto err;
 			}
-			bf->bf_dmacontext = bf->bf_buf_addr;
 		}
 		sc->rx.rxlink = NULL;
 	}
@@ -1744,7 +1743,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			ath_rx_send_to_mac80211(hw, sc, skb, rxs);
 			break;
 		}
-		bf->bf_dmacontext = bf->bf_buf_addr;
 
 		/*
 		 * change the default rx antenna if rx diversity chooses the
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6d41d47..e1ce8cc 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -294,7 +294,6 @@ static struct ath_buf* ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
 	tbf->bf_buf_addr = bf->bf_buf_addr;
 	memcpy(tbf->bf_desc, bf->bf_desc, sc->sc_ah->caps.tx_desc_len);
 	tbf->bf_state = bf->bf_state;
-	tbf->bf_dmacontext = bf->bf_dmacontext;
 
 	return tbf;
 }
@@ -1642,17 +1641,15 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 
 	bf->bf_mpdu = skb;
 
-	bf->bf_dmacontext = dma_map_single(sc->dev, skb->data,
-					   skb->len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sc->dev, bf->bf_dmacontext))) {
+	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
+					 skb->len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		bf->bf_mpdu = NULL;
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
 			  "dma_mapping_error() on TX\n");
 		return -ENOMEM;
 	}
 
-	bf->bf_buf_addr = bf->bf_dmacontext;
-
 	bf->bf_tx_aborted = false;
 
 	return 0;
@@ -1916,7 +1913,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 			tx_flags |= ATH_TX_XRETRY;
 	}
 
-	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
+	dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
 
 	if (bf->bf_state.bfs_paprd) {
 		if (time_after(jiffies,
-- 
1.7.2.2

