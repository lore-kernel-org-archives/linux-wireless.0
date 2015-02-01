Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:43212 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbbBAMAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 07:00:10 -0500
Received: by mail-we0-f172.google.com with SMTP id q59so34344206wes.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 04:00:09 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6655: move setting of PSTxDesc->buff_addr to vnt_tx_packet
Date: Sun,  1 Feb 2015 11:59:38 +0000
Message-Id: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com> (sfid-20150201_130019_617519_9DD5C3F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep setting of this part of the structure with the others.

Only pTDInfo needs carried in the buffer structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 2 ++
 drivers/staging/vt6655/rxtx.c        | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 58559fa..9a80144 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1217,6 +1217,8 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	head_td->m_td1TD1.wReqCount =
 			cpu_to_le16((u16)head_td->pTDInfo->dwReqCount);
 
+	head_td->buff_addr = cpu_to_le32(head_td->pTDInfo->skb_dma);
+
 	head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
 
 	if (dma_idx == TYPE_AC0DMA)
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 9cade85..07ce3fd 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1207,7 +1207,6 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 	ptdCurr->pTDInfo->dwReqCount = cbReqCount;
 	ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
 	ptdCurr->pTDInfo->skb_dma = ptdCurr->pTDInfo->buf_dma;
-	ptdCurr->buff_addr = cpu_to_le32(ptdCurr->pTDInfo->skb_dma);
 
 	return cbHeaderLength;
 }
-- 
2.1.0

