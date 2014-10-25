Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44046 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaJYTcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:32:07 -0400
Received: by mail-wi0-f173.google.com with SMTP id ex7so3530291wid.6
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:32:05 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/48] staging: vt6655: s_cbFillTxBufHead remove unused parameters
Date: Sat, 25 Oct 2014 09:39:39 +0100
Message-Id: <1414226426-5811-2-git-send-email-tvboxspy@gmail.com> (sfid-20141025_213211_181591_B48405AE)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
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
index 9beabea..de8f59c 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -152,9 +152,8 @@ static unsigned int
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
@@ -1209,9 +1208,8 @@ static unsigned int
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
@@ -2599,8 +2597,8 @@ int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
 	tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_NONFRAG);
 
 	s_cbFillTxBufHead(priv, pkt_type, (u8 *)tx_buffer_head, skb->len,
-			  dma_idx, head_td, NULL, (u8 *)skb->data,
-			  false, NULL, is_pspoll, &frag);
+			  dma_idx, head_td, (u8 *)skb->data,
+			  is_pspoll, &frag);
 
 	if (info->control.hw_key) {
 		tx_key = info->control.hw_key;
-- 
1.9.1

