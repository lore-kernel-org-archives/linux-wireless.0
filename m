Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58288 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0JOVaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 17:30:20 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Clear DMA addresses when buffers are freed.
Date: Fri, 15 Oct 2010 14:29:59 -0700
Message-Id: <1287178199-7506-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Previous patches cleared the pointer to the SKB, but did not
clear the DMA addresses.  This patch moves the clear logic into
a method and makes sure that the DMA addresses are cleared as well.

This does not obviously fix any bug, but may make it harder to
cause bugs in the future.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 0c917e5... 8fba13d... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 97d471f... cc406f9... M	drivers/net/wireless/ath/ath9k/beacon.c
:100644 100644 62294da... 1560280... M	drivers/net/wireless/ath/ath9k/main.c
:100644 100644 fd778d2... 5afb46f... M	drivers/net/wireless/ath/ath9k/recv.c
:100644 100644 a5e5f27... e86f59c... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 ++
 drivers/net/wireless/ath/ath9k/beacon.c |   14 +++++---------
 drivers/net/wireless/ath/ath9k/main.c   |   11 +++++++++++
 drivers/net/wireless/ath/ath9k/recv.c   |   12 ++++--------
 drivers/net/wireless/ath/ath9k/xmit.c   |    6 ++----
 5 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0c917e5..8fba13d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -737,4 +737,6 @@ bool ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
 void ath_start_rfkill_poll(struct ath_softc *sc);
 extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
 
+void ath_clear_dma_ptrs(struct ath_buf *bf);
+
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 97d471f..cc406f9 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -139,7 +139,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 		dma_unmap_single(sc->dev, bf->bf_buf_addr,
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
-		bf->bf_buf_addr = 0;
+		ath_clear_dma_ptrs(bf);
 	}
 
 	/* Get a new beacon from mac80211 */
@@ -167,8 +167,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 					 skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
-		bf->bf_mpdu = NULL;
-		bf->bf_buf_addr = 0;
+		ath_clear_dma_ptrs(bf);
 		ath_print(common, ATH_DBG_FATAL,
 			  "dma_mapping_error on beaconing\n");
 		return NULL;
@@ -256,8 +255,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 		dma_unmap_single(sc->dev, bf->bf_buf_addr,
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
-		bf->bf_mpdu = NULL;
-		bf->bf_buf_addr = 0;
+		ath_clear_dma_ptrs(bf);
 	}
 
 	/* NB: the beacon data buffer must be 32-bit aligned. */
@@ -302,8 +300,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 					 skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
-		bf->bf_mpdu = NULL;
-		bf->bf_buf_addr = 0;
+		ath_clear_dma_ptrs(bf);
 		ath_print(common, ATH_DBG_FATAL,
 			  "dma_mapping_error on beacon alloc\n");
 		return -ENOMEM;
@@ -329,8 +326,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 			dma_unmap_single(sc->dev, bf->bf_buf_addr,
 					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
-			bf->bf_mpdu = NULL;
-			bf->bf_buf_addr = 0;
+			ath_clear_dma_ptrs(bf);
 		}
 		list_add_tail(&bf->list, &sc->beacon.bbuf);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 62294da..1560280 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -213,6 +213,17 @@ static void ath_update_survey_stats(struct ath_softc *sc)
 	ath_update_survey_nf(sc, pos);
 }
 
+void ath_clear_dma_ptrs(struct ath_buf *bf)
+{
+	struct ath_desc *ds = bf->bf_desc;
+	bf->bf_buf_addr = 0;
+	bf->bf_mpdu = NULL;
+	if (ds) {
+		ds->ds_data = 0;
+		ds->ds_vdata = NULL;
+	}
+}
+
 /*
  * Set/change channels.  If the channel is really being changed, it's done
  * by reseting the chip.  To accomplish this we must first cleanup any pending
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fd778d2..5afb46f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -269,8 +269,7 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 		if (unlikely(dma_mapping_error(sc->dev,
 						bf->bf_buf_addr))) {
 				dev_kfree_skb_any(skb);
-				bf->bf_mpdu = NULL;
-				bf->bf_buf_addr = 0;
+				ath_clear_dma_ptrs(bf);
 				ath_print(common, ATH_DBG_FATAL,
 					"dma_mapping_error() on RX init\n");
 				error = -ENOMEM;
@@ -360,8 +359,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 			if (unlikely(dma_mapping_error(sc->dev,
 							bf->bf_buf_addr))) {
 				dev_kfree_skb_any(skb);
-				bf->bf_mpdu = NULL;
-				bf->bf_buf_addr = 0;
+				ath_clear_dma_ptrs(bf);
 				ath_print(common, ATH_DBG_FATAL,
 					  "dma_mapping_error() on RX init\n");
 				error = -ENOMEM;
@@ -396,8 +394,7 @@ void ath_rx_cleanup(struct ath_softc *sc)
 						common->rx_bufsize,
 						DMA_FROM_DEVICE);
 				dev_kfree_skb(skb);
-				bf->bf_buf_addr = 0;
-				bf->bf_mpdu = NULL;
+				ath_clear_dma_ptrs(bf);
 			}
 		}
 
@@ -1741,8 +1738,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (unlikely(dma_mapping_error(sc->dev,
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
-			bf->bf_mpdu = NULL;
-			bf->bf_buf_addr = 0;
+			ath_clear_dma_ptrs(bf);
 			ath_print(common, ATH_DBG_FATAL,
 				  "dma_mapping_error() on RX\n");
 			ath_rx_send_to_mac80211(hw, sc, skb, rxs);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a5e5f27..e86f59c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1644,8 +1644,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
 					 skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
-		bf->bf_mpdu = NULL;
-		bf->bf_buf_addr = 0;
+		ath_clear_dma_ptrs(bf);
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
 			  "dma_mapping_error() on TX\n");
 		return -ENOMEM;
@@ -1915,7 +1914,6 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	}
 
 	dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
-	bf->bf_buf_addr = 0;
 
 	if (bf->bf_state.bfs_paprd) {
 		if (time_after(jiffies,
@@ -1931,7 +1929,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	/* At this point, skb (bf->bf_mpdu) is consumed...make sure we don't
 	 * accidentally reference it later.
 	 */
-	bf->bf_mpdu = NULL;
+	ath_clear_dma_ptrs(bf);
 
 	/*
 	 * Return the list of ath_buf of this mpdu to free queue
-- 
1.7.2.2

