Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34051 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbbHNV7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 17:59:20 -0400
Received: by wicne3 with SMTP id ne3so31639368wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 14:59:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6655: struct tagDEVICE_TD_INFO resize dwReqCount.
Date: Fri, 14 Aug 2015 22:58:48 +0100
Message-Id: <1439589531-3059-3-git-send-email-tvboxspy@gmail.com> (sfid-20150814_235925_496721_503EF63B)
In-Reply-To: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
References: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dwReqCount is no bigger than u16

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h        | 2 +-
 drivers/staging/vt6655/device_main.c | 2 +-
 drivers/staging/vt6655/rxtx.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 6efe825..ab52c56 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -245,7 +245,7 @@ typedef struct tagDEVICE_TD_INFO {
 	struct sk_buff *skb;
 	unsigned char *buf;
 	dma_addr_t          buf_dma;
-	unsigned long dwReqCount;
+	u16 dwReqCount;
 	unsigned long dwHeaderLength;
 	unsigned char byFlags;
 } DEVICE_TD_INFO,    *PDEVICE_TD_INFO;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 947e868..c3b7bd4 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1193,7 +1193,7 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	/* Set TSR1 & ReqCount in TxDescHead */
 	head_td->td1.tcr |= (TCR_STP | TCR_EDP | EDMSDU);
-	head_td->td1.req_count = cpu_to_le16((u16)head_td->pTDInfo->dwReqCount);
+	head_td->td1.req_count = cpu_to_le16(head_td->pTDInfo->dwReqCount);
 
 	head_td->buff_addr = cpu_to_le32(head_td->pTDInfo->buf_dma);
 
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 380b879..f3f6b15 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1200,7 +1200,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 	ptdCurr = (PSTxDesc)pHeadTD;
 
-	ptdCurr->pTDInfo->dwReqCount = cbReqCount;
+	ptdCurr->pTDInfo->dwReqCount = (u16)cbReqCount;
 	ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
 
 	return cbHeaderLength;
-- 
2.5.0

