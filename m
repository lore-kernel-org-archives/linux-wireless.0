Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42153 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaLUM5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 07:57:14 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5853203wiv.6
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2014 04:57:13 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2 bug fix] staging: vt6655: vnt_tx_packet Fix corrupted tx packets.
Date: Sun, 21 Dec 2014 12:56:34 +0000
Message-Id: <1419166595-3096-1-git-send-email-tvboxspy@gmail.com> (sfid-20141221_135718_398276_2B4A7629)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move PSTxDesc->m_td1TD1 to inside spin locks.

if m_td1TD1.byTCR has TCR_EDP and TCR_STP are set, the interrupt handler will
try and complete the buffer before it is completed. Usually on the tail
of a burst of tx packets.

This results in a partially completed packet being transmitted or worse
sitll dead lock when skb is freed by the interrupt handler.

Set head_td->m_td1TD1.byTCR to 0 in first lock of vnt_tx_packet to stop
interrupt handler completing the buffer. Move Set TSR1 & ReqCount in
s_cbFillTxBufHead to the second lock.

cbReqCount is carried to the second lock in pTDInfo->dwReqCount without
the padding removed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 7 ++++++-
 drivers/staging/vt6655/rxtx.c        | 5 +----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 83e4162..519c337 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1232,7 +1232,7 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	head_td = priv->apCurrTD[dma_idx];
 
-	head_td->m_td1TD1.byTCR = (TCR_EDP|TCR_STP);
+	head_td->m_td1TD1.byTCR = 0;
 
 	head_td->pTDInfo->skb = skb;
 
@@ -1257,6 +1257,11 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	priv->bPWBitOn = false;
 
+	/* Set TSR1 & ReqCount in TxDescHead */
+	head_td->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
+	head_td->m_td1TD1.wReqCount =
+			cpu_to_le16((u16)head_td->pTDInfo->dwReqCount);
+
 	head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
 
 	if (dma_idx == TYPE_AC0DMA)
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 61c39dd..b5b0155 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1204,13 +1204,10 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 	ptdCurr = (PSTxDesc)pHeadTD;
 
-	ptdCurr->pTDInfo->dwReqCount = cbReqCount - uPadding;
+	ptdCurr->pTDInfo->dwReqCount = cbReqCount;
 	ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
 	ptdCurr->pTDInfo->skb_dma = ptdCurr->pTDInfo->buf_dma;
 	ptdCurr->buff_addr = cpu_to_le32(ptdCurr->pTDInfo->skb_dma);
-	/* Set TSR1 & ReqCount in TxDescHead */
-	ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
-	ptdCurr->m_td1TD1.wReqCount = cpu_to_le16((unsigned short)(cbReqCount));
 
 	return cbHeaderLength;
 }
-- 
2.1.0

