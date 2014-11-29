Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:62558 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaK2ACo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 19:02:44 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so9719877wgh.26
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2014 16:02:43 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6655: s_cbFillTxBufHead remove parameter cbFrameBodySize
Date: Sat, 29 Nov 2014 00:02:03 +0000
Message-Id: <1417219323-3988-6-git-send-email-tvboxspy@gmail.com> (sfid-20141129_010248_461139_C738EB9F)
In-Reply-To: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
References: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb->len is available locally use that instead.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 9d16916..61c39dd 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -129,7 +129,7 @@ s_vGenerateTxParameter(
 
 static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
-		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
+		  unsigned char *pbyTxBufferAddr,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
 		  unsigned int uNodeIndex);
 
@@ -1030,7 +1030,7 @@ s_vGenerateTxParameter(
 
 static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
-		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
+		  unsigned char *pbyTxBufferAddr,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
 		  unsigned int is_pspoll)
 {
@@ -1195,12 +1195,12 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 	hdr->duration_id = uDuration;
 
-	cbReqCount = cbHeaderLength + uPadding + cbFrameBodySize;
+	cbReqCount = cbHeaderLength + uPadding + skb->len;
 	pbyBuffer = (unsigned char *)pHeadTD->pTDInfo->buf;
 	uLength = cbHeaderLength + uPadding;
 
 	/* Copy the Packet into a tx Buffer */
-	memcpy((pbyBuffer + uLength), skb->data, cbFrameBodySize);
+	memcpy((pbyBuffer + uLength), skb->data, skb->len);
 
 	ptdCurr = (PSTxDesc)pHeadTD;
 
@@ -1398,7 +1398,7 @@ int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
 
 	tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_NONFRAG);
 
-	s_cbFillTxBufHead(priv, pkt_type, (u8 *)tx_buffer_head, skb->len,
+	s_cbFillTxBufHead(priv, pkt_type, (u8 *)tx_buffer_head,
 			  dma_idx, head_td, is_pspoll);
 
 	if (info->control.hw_key) {
-- 
2.1.0

