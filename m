Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54755 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbbBAMAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 07:00:13 -0500
Received: by mail-wg0-f46.google.com with SMTP id l2so34139427wgh.5
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 04:00:12 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6655: Fix TD_FLAGS_NETIF_SKB only on TYPE_AC0DMA
Date: Sun,  1 Feb 2015 11:59:40 +0000
Message-Id: <1422791983-3408-3-git-send-email-tvboxspy@gmail.com> (sfid-20150201_130025_089993_CEFEBC96)
In-Reply-To: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
References: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow only TD_FLAGS_NETIF_SKB on ring buffer TYPE_AC0DMA for data
only transfers for correct reporting of tx rates.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 870cafd..4324282 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1234,12 +1234,13 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	head_td->buff_addr = cpu_to_le32(head_td->pTDInfo->skb_dma);
 
-	head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
+	if (dma_idx == TYPE_AC0DMA) {
+		head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
 
-	if (dma_idx == TYPE_AC0DMA)
 		MACvTransmitAC0(priv->PortOffset);
-	else
+	} else {
 		MACvTransmit0(priv->PortOffset);
+	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-- 
2.1.0

