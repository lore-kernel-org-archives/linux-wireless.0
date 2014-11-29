Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52829 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaK2ACm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 19:02:42 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so1630460wgh.22
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2014 16:02:41 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/6] staging: vt6655: s_cbFillTxBufHead remove parameter *pPacket
Date: Sat, 29 Nov 2014 00:02:02 +0000
Message-Id: <1417219323-3988-5-git-send-email-tvboxspy@gmail.com> (sfid-20141129_010247_095889_A4472D46)
In-Reply-To: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
References: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb->data is available locally so use that instead.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index f1dacf9..9d16916 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -131,7 +131,7 @@ static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
-		  unsigned char *pPacket, unsigned int uNodeIndex);
+		  unsigned int uNodeIndex);
 
 static
 __le16
@@ -1032,7 +1032,7 @@ static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
-		  unsigned char *pPacket, unsigned int is_pspoll)
+		  unsigned int is_pspoll)
 {
 	PDEVICE_TD_INFO td_info = pHeadTD->pTDInfo;
 	struct sk_buff *skb = td_info->skb;
@@ -1200,7 +1200,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 	uLength = cbHeaderLength + uPadding;
 
 	/* Copy the Packet into a tx Buffer */
-	memcpy((pbyBuffer + uLength), pPacket, cbFrameBodySize);
+	memcpy((pbyBuffer + uLength), skb->data, cbFrameBodySize);
 
 	ptdCurr = (PSTxDesc)pHeadTD;
 
@@ -1399,8 +1399,7 @@ int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
 	tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_NONFRAG);
 
 	s_cbFillTxBufHead(priv, pkt_type, (u8 *)tx_buffer_head, skb->len,
-			  dma_idx, head_td, (u8 *)skb->data,
-			  is_pspoll);
+			  dma_idx, head_td, is_pspoll);
 
 	if (info->control.hw_key) {
 		tx_key = info->control.hw_key;
-- 
2.1.0

