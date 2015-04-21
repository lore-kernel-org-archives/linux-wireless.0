Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36780 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbbDUVd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 17:33:27 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/3] staging: vt6655: vnt_tx_packet Correct TX order of OWNED_BY_NIC
Date: Tue, 21 Apr 2015 22:33:00 +0100
Message-Id: <1429651982-4352-1-git-send-email-tvboxspy@gmail.com> (sfid-20150421_233331_626806_204D7E51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The state of m_td0TD0.f1Owner should change after the buff_addr
has been filled otherwise the device grabs the buffer too early.

m_td0TD0.f1Owner is protected by memory barriers on both sides
of change.

iTDUsed is best incremented after MACvTransmit.

It appears that f1Owner actually polls to do the memory transfer.

A back port patch will be needed for v3.19

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v4.0+
---
 drivers/staging/vt6655/device_main.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c5f8233..ed90b6f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1201,14 +1201,6 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	if (dma_idx == TYPE_AC0DMA)
 		head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
 
-	priv->iTDUsed[dma_idx]++;
-
-	/* Take ownership */
-	wmb();
-	head_td->m_td0TD0.f1Owner = OWNED_BY_NIC;
-
-	/* get Next */
-	wmb();
 	priv->apCurrTD[dma_idx] = head_td->next;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1229,11 +1221,18 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	head_td->buff_addr = cpu_to_le32(head_td->pTDInfo->skb_dma);
 
+	/* Poll Transmit the adapter */
+	wmb();
+	head_td->m_td0TD0.f1Owner = OWNED_BY_NIC;
+	wmb(); /* second memory barrier */
+
 	if (head_td->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB)
 		MACvTransmitAC0(priv->PortOffset);
 	else
 		MACvTransmit0(priv->PortOffset);
 
+	priv->iTDUsed[dma_idx]++;
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
-- 
2.1.4

