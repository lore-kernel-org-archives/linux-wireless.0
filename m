Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f194.google.com ([209.85.212.194]:48640 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbbBITMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 14:12:34 -0500
Received: by mail-wi0-f194.google.com with SMTP id hm9so2840742wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 11:12:33 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH fix for v3.20] staging: vt6655: vnt_tx_packet fix dma_idx selection.
Date: Mon,  9 Feb 2015 19:11:33 +0000
Message-Id: <1423509094-4548-1-git-send-email-tvboxspy@gmail.com> (sfid-20150209_201238_158778_017C6EEF)
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
index 4324282..f5c5872 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1187,12 +1187,14 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
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
@@ -1206,6 +1208,9 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	head_td->pTDInfo->skb = skb;
 
+	if (dma_idx == TYPE_AC0DMA)
+		head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
+
 	priv->iTDUsed[dma_idx]++;
 
 	/* Take ownership */
@@ -1234,13 +1239,10 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
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
2.1.0

