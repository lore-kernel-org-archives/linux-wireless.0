Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33318 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbbGVSRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:44 -0400
Received: by wicmv11 with SMTP id mv11so92400662wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/15] staging: vt6655: remove unnecessary variable skb_dma
Date: Wed, 22 Jul 2015 19:16:36 +0100
Message-Id: <1437589007-5479-4-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201749_958260_A01C1CC3)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb_dma flips from 0 to the contents buf_dma.

This is nolonger necessary so use buf_dma directly
and remove skb_dma altogether.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h        | 1 -
 drivers/staging/vt6655/device_main.c | 3 +--
 drivers/staging/vt6655/rxtx.c        | 1 -
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 758eeb2..d568101 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -256,7 +256,6 @@ typedef struct tagDEVICE_TD_INFO {
 	void *mic_hdr;
 	struct sk_buff *skb;
 	unsigned char *buf;
-	dma_addr_t          skb_dma;
 	dma_addr_t          buf_dma;
 	dma_addr_t          curr_desc;
 	unsigned long dwReqCount;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 695aa25..89611a7 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -970,7 +970,6 @@ static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc)
 	if (skb)
 		ieee80211_tx_status_irqsafe(pDevice->hw, skb);
 
-	pTDInfo->skb_dma = 0;
 	pTDInfo->skb = NULL;
 	pTDInfo->byFlags = 0;
 }
@@ -1201,7 +1200,7 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	head_td->m_td1TD1.wReqCount =
 			cpu_to_le16((u16)head_td->pTDInfo->dwReqCount);
 
-	head_td->buff_addr = cpu_to_le32(head_td->pTDInfo->skb_dma);
+	head_td->buff_addr = cpu_to_le32(head_td->pTDInfo->buf_dma);
 
 	/* Poll Transmit the adapter */
 	wmb();
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 0ffa9bf..82380f3 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1202,7 +1202,6 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 	ptdCurr->pTDInfo->dwReqCount = cbReqCount;
 	ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
-	ptdCurr->pTDInfo->skb_dma = ptdCurr->pTDInfo->buf_dma;
 
 	return cbHeaderLength;
 }
-- 
2.1.4

