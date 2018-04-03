Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:44792 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751588AbeDCQwC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 12:52:02 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 2/3] wcn36xx: don't keep reference to skb if transmission failed
Date: Tue,  3 Apr 2018 18:51:53 +0200
Message-Id: <20180403165154.18775-2-daniel@zonque.org> (sfid-20180403_185210_060755_6C96E414)
In-Reply-To: <20180403165154.18775-1-daniel@zonque.org>
References: <20180403165154.18775-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When wcn36xx_dxe_tx_frame() fails to transmit the TX frame, the driver
will call into ieee80211_free_txskb() for the skb in flight, so it'll no
longer be valid. Hence, we shouldn't keep a reference to it in ctl->skb.
Also, if the skb has IEEE80211_TX_CTL_REQ_TX_STATUS set, a pointer to
it will currently remain in wcn->tx_ack_skb, which will potentially lead
to a crash if accessed later.

Fix this by checking the return value of wcn36xx_dxe_tx_frame(), and
nullify wcn->tx_ack_skb again in case of errors. Move the assignment
of ctl->skb in wcn36xx_dxe_tx_frame() so it only happens when the
transmission is successful.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c  |  6 +++---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index e8ad8f989ccd..abf7b051e1ff 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -695,7 +695,6 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 
 	/* Set source address of the SKB we send */
 	ctl = ctl->next;
-	ctl->skb = skb;
 	desc = ctl->desc;
 	if (ctl->bd_cpu_addr) {
 		wcn36xx_err("bd_cpu_addr cannot be NULL for skb DXE\n");
@@ -704,8 +703,8 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 	}
 
 	desc->src_addr_l = dma_map_single(wcn->dev,
-					  ctl->skb->data,
-					  ctl->skb->len,
+					  skb->data,
+					  skb->len,
 					  DMA_TO_DEVICE);
 	if (dma_mapping_error(wcn->dev, desc->src_addr_l)) {
 		dev_err(wcn->dev, "unable to DMA map src_addr_l\n");
@@ -713,6 +712,7 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 		goto unlock;
 	}
 
+	ctl->skb = skb;
 	desc->dst_addr_l = ch->dxe_wq;
 	desc->fr_len = ctl->skb->len;
 
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index b1768ed6b0be..a6902371e89c 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -273,6 +273,7 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 	bool bcast = is_broadcast_ether_addr(hdr->addr1) ||
 		is_multicast_ether_addr(hdr->addr1);
 	struct wcn36xx_tx_bd bd;
+	int ret;
 
 	memset(&bd, 0, sizeof(bd));
 
@@ -317,5 +318,17 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 	buff_to_be((u32 *)&bd, sizeof(bd)/sizeof(u32));
 	bd.tx_bd_sign = 0xbdbdbdbd;
 
-	return wcn36xx_dxe_tx_frame(wcn, vif_priv, &bd, skb, is_low);
+	ret = wcn36xx_dxe_tx_frame(wcn, vif_priv, &bd, skb, is_low);
+	if (ret && bd.tx_comp) {
+		/* If the skb has not been transmitted,
+		 * don't keep a reference to it.
+		 */
+		spin_lock_irqsave(&wcn->dxe_lock, flags);
+		wcn->tx_ack_skb = NULL;
+		spin_unlock_irqrestore(&wcn->dxe_lock, flags);
+
+		ieee80211_wake_queues(wcn->hw);
+	}
+
+	return ret;
 }
-- 
2.14.3
