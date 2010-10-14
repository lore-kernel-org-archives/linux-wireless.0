Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55439 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab0JNTpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 15:45:46 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath9k:  Null out references to stale pointers.
Date: Thu, 14 Oct 2010 12:45:30 -0700
Message-Id: <1287085530-7262-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1287085530-7262-1-git-send-email-greearb@candelatech.com>
References: <1287085530-7262-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This doesn't fix any problem that I'm aware of, but should
make it harder to add use-after-free type bugs in the
future.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 df6a9fa... 97d471f... M	drivers/net/wireless/ath/ath9k/beacon.c
:100644 100644 cd748ab... fd778d2... M	drivers/net/wireless/ath/ath9k/recv.c
:100644 100644 e1ce8cc... a5e5f27... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/beacon.c |    5 +++++
 drivers/net/wireless/ath/ath9k/recv.c   |    5 +++++
 drivers/net/wireless/ath/ath9k/xmit.c   |    6 ++++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index df6a9fa..97d471f 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -139,6 +139,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 		dma_unmap_single(sc->dev, bf->bf_buf_addr,
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
+		bf->bf_buf_addr = 0;
 	}
 
 	/* Get a new beacon from mac80211 */
@@ -167,6 +168,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
+		bf->bf_buf_addr = 0;
 		ath_print(common, ATH_DBG_FATAL,
 			  "dma_mapping_error on beaconing\n");
 		return NULL;
@@ -255,6 +257,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
+		bf->bf_buf_addr = 0;
 	}
 
 	/* NB: the beacon data buffer must be 32-bit aligned. */
@@ -300,6 +303,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
+		bf->bf_buf_addr = 0;
 		ath_print(common, ATH_DBG_FATAL,
 			  "dma_mapping_error on beacon alloc\n");
 		return -ENOMEM;
@@ -326,6 +330,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
+			bf->bf_buf_addr = 0;
 		}
 		list_add_tail(&bf->list, &sc->beacon.bbuf);
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index cd748ab..fd778d2 100644
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
@@ -360,6 +361,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 							bf->bf_buf_addr))) {
 				dev_kfree_skb_any(skb);
 				bf->bf_mpdu = NULL;
+				bf->bf_buf_addr = 0;
 				ath_print(common, ATH_DBG_FATAL,
 					  "dma_mapping_error() on RX init\n");
 				error = -ENOMEM;
@@ -394,6 +396,8 @@ void ath_rx_cleanup(struct ath_softc *sc)
 						common->rx_bufsize,
 						DMA_FROM_DEVICE);
 				dev_kfree_skb(skb);
+				bf->bf_buf_addr = 0;
+				bf->bf_mpdu = NULL;
 			}
 		}
 
@@ -1738,6 +1742,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
 			bf->bf_mpdu = NULL;
+			bf->bf_buf_addr = 0;
 			ath_print(common, ATH_DBG_FATAL,
 				  "dma_mapping_error() on RX\n");
 			ath_rx_send_to_mac80211(hw, sc, skb, rxs);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e1ce8cc..a5e5f27 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1645,6 +1645,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 					 skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		bf->bf_mpdu = NULL;
+		bf->bf_buf_addr = 0;
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
 			  "dma_mapping_error() on TX\n");
 		return -ENOMEM;
@@ -1914,6 +1915,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	}
 
 	dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
+	bf->bf_buf_addr = 0;
 
 	if (bf->bf_state.bfs_paprd) {
 		if (time_after(jiffies,
@@ -1926,6 +1928,10 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
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

