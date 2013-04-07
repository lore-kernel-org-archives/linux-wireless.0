Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58782 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934414Ab3DGWET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:04:19 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 4/7] ath9k: improve dma map failure handling
Date: Mon,  8 Apr 2013 00:04:10 +0200
Message-Id: <1365372253-32782-4-git-send-email-nbd@openwrt.org> (sfid-20130408_000423_529925_824E31AC)
In-Reply-To: <1365372253-32782-3-git-send-email-nbd@openwrt.org>
References: <1365372253-32782-1-git-send-email-nbd@openwrt.org>
 <1365372253-32782-2-git-send-email-nbd@openwrt.org>
 <1365372253-32782-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of leaving the buffer without skb and breaking out of the loop
(which could leak the rx buffer), use the common error path.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a617ef9..1bc8030 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1162,6 +1162,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	u64 tsf = 0;
 	u32 tsf_lower = 0;
 	unsigned long flags;
+	dma_addr_t new_buf_addr;
 
 	if (edma)
 		dma_type = DMA_BIDIRECTIONAL;
@@ -1257,10 +1258,20 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			goto requeue_drop_frag;
 		}
 
+		/* We will now give hardware our shiny new allocated skb */
+		new_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
+					      common->rx_bufsize, dma_type);
+		if (unlikely(dma_mapping_error(sc->dev, new_buf_addr))) {
+			dev_kfree_skb_any(requeue_skb);
+			goto requeue_drop_frag;
+		}
+
+		bf->bf_mpdu = requeue_skb;
+		bf->bf_buf_addr = new_buf_addr;
+
 		/* Unmap the frame */
 		dma_unmap_single(sc->dev, bf->bf_buf_addr,
-				 common->rx_bufsize,
-				 dma_type);
+				 common->rx_bufsize, dma_type);
 
 		skb_put(skb, rs.rs_datalen + ah->caps.rx_status_len);
 		if (ah->caps.rx_status_len)
@@ -1270,21 +1281,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			ath9k_rx_skb_postprocess(common, hdr_skb, &rs,
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
-			ieee80211_rx(hw, skb);
-			break;
-		}
-
 		if (rs.rs_more) {
 			RX_STAT_INC(rx_frags);
 			/*
-- 
1.8.0.2

