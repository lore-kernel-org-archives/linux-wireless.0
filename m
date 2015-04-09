Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33403 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbbDITyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 15:54:15 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/2] staging: vt6655: device_free_tx_buf use only ieee80211_tx_status_irqsafe
Date: Thu,  9 Apr 2015 20:53:43 +0100
Message-Id: <1428609224-3237-1-git-send-email-tvboxspy@gmail.com> (sfid-20150409_215422_033456_20F8DA6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TD_FLAGS_NETIF_SKB is only for data.

Fixes issue of ack frames not being reported.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.19+
---
 drivers/staging/vt6655/device_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 5b3de43..8f48c84 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -989,10 +989,8 @@ static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc)
 				 skb->len, DMA_TO_DEVICE);
 	}
 
-	if (pTDInfo->byFlags & TD_FLAGS_NETIF_SKB)
+	if (skb)
 		ieee80211_tx_status_irqsafe(pDevice->hw, skb);
-	else
-		dev_kfree_skb_irq(skb);
 
 	pTDInfo->skb_dma = 0;
 	pTDInfo->skb = NULL;
-- 
2.1.0

