Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58492 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1AJHMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 02:12:30 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH RESEND 11/11] ath9k: Implement rx copy-break.
Date: Sun,  9 Jan 2011 23:11:53 -0800
Message-Id: <1294643513-18820-12-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
References: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This saves us constantly allocating large, multi-page
skbs.  It should fix the order-1 allocation errors reported,
and in a 60-vif scenario, this significantly decreases CPU
utilization, and latency, and increases bandwidth.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 b2497b8... ea2f67c... M	drivers/net/wireless/ath/ath9k/recv.c
 drivers/net/wireless/ath/ath9k/recv.c |   92 ++++++++++++++++++++++-----------
 1 files changed, 61 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b2497b8..ea2f67c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -16,6 +16,7 @@
 
 #include "ath9k.h"
 #include "ar9003_mac.h"
+#include <linux/pci.h>
 
 #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
 
@@ -1623,7 +1624,7 @@ div_comb_done:
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_buf *bf;
-	struct sk_buff *skb = NULL, *requeue_skb;
+	struct sk_buff *skb = NULL, *requeue_skb = NULL;
 	struct ieee80211_rx_status *rxs;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1634,7 +1635,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	 */
 	struct ieee80211_hw *hw = NULL;
 	struct ieee80211_hdr *hdr;
-	int retval;
+	int retval, len;
+	bool use_copybreak = true;
 	bool decrypt_error = false;
 	struct ath_rx_status rs;
 	enum ath9k_rx_qtype qtype;
@@ -1702,42 +1704,70 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
-		/* Ensure we always have an skb to requeue once we are done
-		 * processing the current buffer's skb */
-		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
-
-		/* If there is no memory we ignore the current RX'd frame,
-		 * tell hardware it can give us a new frame using the old
-		 * skb and put it at the tail of the sc->rx.rxbuf list for
-		 * processing. */
-		if (!requeue_skb)
-			goto requeue;
-
-		/* Unmap the frame */
-		dma_unmap_single(sc->dev, bf->bf_buf_addr,
-				 common->rx_bufsize,
-				 dma_type);
+		len = rs.rs_datalen + ah->caps.rx_status_len;
+		if (use_copybreak) {
+			skb = netdev_alloc_skb(NULL, len);
+			if (!skb) {
+				skb = bf->bf_mpdu;
+				use_copybreak = false;
+				goto non_copybreak;
+			}
+		} else {
+non_copybreak:
+			/* Ensure we always have an skb to requeue once we are
+			 * done processing the current buffer's skb */
+			requeue_skb = ath_rxbuf_alloc(common,
+						      common->rx_bufsize,
+						      GFP_ATOMIC);
+
+			/* If there is no memory we ignore the current RX'd
+			 * frame, tell hardware it can give us a new frame
+			 * using the old skb and put it at the tail of the
+			 * sc->rx.rxbuf list for processing. */
+			if (!requeue_skb)
+				goto requeue;
+
+			/* Unmap the frame */
+			dma_unmap_single(sc->dev, bf->bf_buf_addr,
+					 common->rx_bufsize,
+					 dma_type);
+		}
 
-		skb_put(skb, rs.rs_datalen + ah->caps.rx_status_len);
+		skb_put(skb, len);
 		if (ah->caps.rx_status_len)
 			skb_pull(skb, ah->caps.rx_status_len);
 
+		if (use_copybreak) {
+			struct pci_dev *pdev = to_pci_dev(sc->dev);
+			pci_dma_sync_single_for_cpu(pdev, bf->bf_buf_addr,
+						    len, PCI_DMA_FROMDEVICE);
+			skb_copy_from_linear_data(bf->bf_mpdu, skb->data, len);
+			pci_dma_sync_single_for_device(pdev, bf->bf_buf_addr,
+						       len, PCI_DMA_FROMDEVICE);
+			memcpy(skb->cb, bf->bf_mpdu->cb, sizeof(skb->cb));
+			rxs =  IEEE80211_SKB_RXCB(skb);
+		}
+
 		ath9k_rx_skb_postprocess(common, skb, &rs,
 					 rxs, decrypt_error);
 
-		/* We will now give hardware our shiny new allocated skb */
-		bf->bf_mpdu = requeue_skb;
-		bf->bf_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
-						 common->rx_bufsize,
-						 dma_type);
-		if (unlikely(dma_mapping_error(sc->dev,
-			  bf->bf_buf_addr))) {
-			dev_kfree_skb_any(requeue_skb);
-			bf->bf_mpdu = NULL;
-			bf->bf_buf_addr = 0;
-			ath_err(common, "dma_mapping_error() on RX\n");
-			ath_rx_send_to_mac80211(hw, sc, skb);
-			break;
+		if (!use_copybreak) {
+			/* We will now give hardware our shiny new allocated
+			 * skb */
+			bf->bf_mpdu = requeue_skb;
+			bf->bf_buf_addr = dma_map_single(sc->dev,
+							 requeue_skb->data,
+							 common->rx_bufsize,
+							 dma_type);
+			if (unlikely(dma_mapping_error(sc->dev,
+						       bf->bf_buf_addr))) {
+				dev_kfree_skb_any(requeue_skb);
+				bf->bf_mpdu = NULL;
+				bf->bf_buf_addr = 0;
+				ath_err(common, "dma_mapping_error() on RX\n");
+				ath_rx_send_to_mac80211(hw, sc, skb);
+				break;
+			}
 		}
 
 		/*
-- 
1.7.2.3

