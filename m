Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37871 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbbHNV7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 17:59:21 -0400
Received: by wibhh20 with SMTP id hh20so33920984wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 14:59:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: struct tagDEVICE_TD_INFO remove dwHeaderLength
Date: Fri, 14 Aug 2015 22:58:49 +0100
Message-Id: <1439589531-3059-4-git-send-email-tvboxspy@gmail.com> (sfid-20150814_235929_977699_B239571E)
In-Reply-To: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
References: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dwHeaderLength is assigned a value but that is never used.

Remove variable.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 1 -
 drivers/staging/vt6655/rxtx.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index ab52c56..0b786cf 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -246,7 +246,6 @@ typedef struct tagDEVICE_TD_INFO {
 	unsigned char *buf;
 	dma_addr_t          buf_dma;
 	u16 dwReqCount;
-	unsigned long dwHeaderLength;
 	unsigned char byFlags;
 } DEVICE_TD_INFO,    *PDEVICE_TD_INFO;
 
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index f3f6b15..c918248 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1201,7 +1201,6 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 	ptdCurr = (PSTxDesc)pHeadTD;
 
 	ptdCurr->pTDInfo->dwReqCount = (u16)cbReqCount;
-	ptdCurr->pTDInfo->dwHeaderLength = cbHeaderLength;
 
 	return cbHeaderLength;
 }
-- 
2.5.0

