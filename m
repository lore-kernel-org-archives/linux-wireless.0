Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57222 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbaJ2R5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:19 -0400
Received: by mail-wi0-f179.google.com with SMTP id h11so5298818wiw.12
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 13/48] staging: vt6655: s_cbFillTxBufHead remove unused parameters
Date: Wed, 29 Oct 2014 17:55:31 +0000
Message-Id: <1414605366-9335-14-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185726_608837_352517C6)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the following parameters
PSEthernetHeader psEthHeader
PSKeyItem pTransmitKey
bool bNeedEncrypt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 5c460ad..c47042c 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -138,9 +138,8 @@ static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
-		  PSEthernetHeader psEthHeader, unsigned char *pPacket,
-		  bool bNeedEncrypt, PSKeyItem pTransmitKey,
-		  unsigned int uNodeIndex, unsigned int *puMACfragNum);
+		  unsigned char *pPacket, unsigned int uNodeIndex,
+		  unsigned int *puMACfragNum);
 
 static
 __le16
@@ -1041,9 +1040,8 @@ static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
-		  PSEthernetHeader psEthHeader, unsigned char *pPacket,
-		  bool bNeedEncrypt, PSKeyItem pTransmitKey,
-		  unsigned int is_pspoll, unsigned int *puMACfragNum)
+		  unsigned char *pPacket, unsigned int is_pspoll,
+		  unsigned int *puMACfragNum)
 {
 	PDEVICE_TD_INFO td_info = pHeadTD->pTDInfo;
 	struct sk_buff *skb = td_info->skb;
@@ -1413,8 +1411,8 @@ int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
 	tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_NONFRAG);
 
 	s_cbFillTxBufHead(priv, pkt_type, (u8 *)tx_buffer_head, skb->len,
-			  dma_idx, head_td, NULL, (u8 *)skb->data,
-			  false, NULL, is_pspoll, &frag);
+			  dma_idx, head_td, (u8 *)skb->data,
+			  is_pspoll, &frag);
 
 	if (info->control.hw_key) {
 		tx_key = info->control.hw_key;
-- 
2.1.0

