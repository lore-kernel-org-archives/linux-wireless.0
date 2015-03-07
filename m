Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35078 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbbCGRFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 12:05:34 -0500
Received: by wibbs8 with SMTP id bs8so10451542wib.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Mar 2015 09:05:32 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH resend 3/3] staging: vt6655: vnt_tx_packet fix dma_idx selection.
Date: Sat,  7 Mar 2015 17:04:56 +0000
Message-Id: <1425747896-8353-3-git-send-email-tvboxspy@gmail.com> (sfid-20150307_180541_153346_6B3C4F41)
In-Reply-To: <1425747896-8353-1-git-send-email-tvboxspy@gmail.com>
References: <1425747896-8353-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is still a problem that dma_idx is causing packets to
go onto the wrong tx path.

Protect dma_idx fully with the present first lock and
use pTDInfo->byFlags TD_FLAGS_NETIF_SKB to set MACvTransmit.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index a512f83..14c935f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1179,12 +1179,14 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	PSTxDesc head_td;
-	u32 dma_idx = TYPE_AC0DMA;
+	u32 dma_idx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (ieee80211_is_data(hdr->frame_control))
+		dma_idx = TYPE_AC0DMA;
+	else
 		dma_idx = TYPE_TXDMA0;
 
 	if (AVAIL_TD(priv, dma_idx) < 1) {
@@ -1198,6 +1200,9 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	head_td->pTDInfo->skb = skb;
 
+	if (dma_idx == TYPE_AC0DMA)
+		head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
+
 	priv->iTDUsed[dma_idx]++;
 
 	/* Take ownership */
@@ -1226,13 +1231,10 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	head_td->buff_addr = cpu_to_le32(head_td->pTDInfo->skb_dma);
 
-	if (dma_idx == TYPE_AC0DMA) {
-		head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
-
+	if (head_td->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB)
 		MACvTransmitAC0(priv->PortOffset);
-	} else {
+	else
 		MACvTransmit0(priv->PortOffset);
-	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-- 
2.1.4

