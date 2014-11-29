Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58996 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaK2ACl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 19:02:41 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so12468000wiw.9
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2014 16:02:40 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: s_cbFillTxBufHead remove unused parameter *puMACfragNum
Date: Sat, 29 Nov 2014 00:02:01 +0000
Message-Id: <1417219323-3988-4-git-send-email-tvboxspy@gmail.com> (sfid-20141129_010246_300502_C078A1AA)
In-Reply-To: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
References: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*puMACfragNum was part of old legacy functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 4189405..f1dacf9 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -131,8 +131,7 @@ static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
-		  unsigned char *pPacket, unsigned int uNodeIndex,
-		  unsigned int *puMACfragNum);
+		  unsigned char *pPacket, unsigned int uNodeIndex);
 
 static
 __le16
@@ -1033,8 +1032,7 @@ static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
-		  unsigned char *pPacket, unsigned int is_pspoll,
-		  unsigned int *puMACfragNum)
+		  unsigned char *pPacket, unsigned int is_pspoll)
 {
 	PDEVICE_TD_INFO td_info = pHeadTD->pTDInfo;
 	struct sk_buff *skb = td_info->skb;
@@ -1214,8 +1212,6 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 	ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
 	ptdCurr->m_td1TD1.wReqCount = cpu_to_le16((unsigned short)(cbReqCount));
 
-	*puMACfragNum = uMACfragNum;
-
 	return cbHeaderLength;
 }
 
@@ -1297,7 +1293,6 @@ int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
 	struct ieee80211_hdr *hdr;
 	struct vnt_tx_fifo_head *tx_buffer_head =
 			(struct vnt_tx_fifo_head *)td_info->buf;
-	u32 frag;
 	u16 tx_body_size = skb->len, current_rate;
 	u8 pkt_type;
 	bool is_pspoll = false;
@@ -1405,7 +1400,7 @@ int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
 
 	s_cbFillTxBufHead(priv, pkt_type, (u8 *)tx_buffer_head, skb->len,
 			  dma_idx, head_td, (u8 *)skb->data,
-			  is_pspoll, &frag);
+			  is_pspoll);
 
 	if (info->control.hw_key) {
 		tx_key = info->control.hw_key;
-- 
2.1.0

