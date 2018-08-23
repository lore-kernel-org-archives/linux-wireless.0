Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:13372 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732101AbeHWPQn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:43 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 7/9] wil6210: fix RX buffers release and unmap
Date: Thu, 23 Aug 2018 14:47:11 +0300
Message-Id: <1535024833-15178-8-git-send-email-merez@codeaurora.org> (sfid-20180823_134728_103663_91D73582)
In-Reply-To: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX SKBs are released in both wil6210 rmmod and RX handle.
As there is no lock to protect the buffers DMA unmap,
the SKB pointer in buff_arr is used to check if the buffer
memory was already released.
Setting wil->rx_buff_mgmt.buff_arr[buff_id].skb to NULL before the DMA
memory unmap will prevent duplicate unmapping of the same memory.
Move the buffer ID to the free list also in case the SKB is NULL.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index bca61cb..3e7fc29 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -279,9 +279,6 @@ static void wil_move_all_rx_buff_to_free_list(struct wil6210_priv *wil,
 		u16 buff_id;
 
 		*d = *_d;
-		pa = wil_rx_desc_get_addr_edma(&d->dma);
-		dmalen = le16_to_cpu(d->dma.length);
-		dma_unmap_single(dev, pa, dmalen, DMA_FROM_DEVICE);
 
 		/* Extract the SKB from the rx_buff management array */
 		buff_id = __le16_to_cpu(d->mac.buff_id);
@@ -291,10 +288,15 @@ static void wil_move_all_rx_buff_to_free_list(struct wil6210_priv *wil,
 		}
 		skb = wil->rx_buff_mgmt.buff_arr[buff_id].skb;
 		wil->rx_buff_mgmt.buff_arr[buff_id].skb = NULL;
-		if (unlikely(!skb))
+		if (unlikely(!skb)) {
 			wil_err(wil, "No Rx skb at buff_id %d\n", buff_id);
-		else
+		} else {
+			pa = wil_rx_desc_get_addr_edma(&d->dma);
+			dmalen = le16_to_cpu(d->dma.length);
+			dma_unmap_single(dev, pa, dmalen, DMA_FROM_DEVICE);
+
 			kfree_skb(skb);
+		}
 
 		/* Move the buffer from the active to the free list */
 		list_move(&wil->rx_buff_mgmt.buff_arr[buff_id].list,
@@ -906,6 +908,9 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	wil->rx_buff_mgmt.buff_arr[buff_id].skb = NULL;
 	if (!skb) {
 		wil_err(wil, "No Rx skb at buff_id %d\n", buff_id);
+		/* Move the buffer from the active list to the free list */
+		list_move(&wil->rx_buff_mgmt.buff_arr[buff_id].list,
+			  &wil->rx_buff_mgmt.free);
 		goto again;
 	}
 
-- 
1.9.1
