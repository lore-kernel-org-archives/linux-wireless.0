Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38388 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaJYT0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:26:18 -0400
Received: by mail-wi0-f171.google.com with SMTP id em10so3501360wid.4
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:26:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/31] staging: vt6655: dead code remove s_vFillFragParameter.
Date: Sat, 25 Oct 2014 09:20:15 +0100
Message-Id: <1414225241-5480-6-git-send-email-tvboxspy@gmail.com> (sfid-20141025_212621_049139_D7ACE48A)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s_vFillFragParameter is nolonger used.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 47 -------------------------------------------
 1 file changed, 47 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index b114a60..09df536 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -148,15 +148,6 @@ s_vGenerateTxParameter(
 	unsigned short wCurrentRate
 );
 
-static void s_vFillFragParameter(
-	struct vnt_private *pDevice,
-	unsigned char *pbyBuffer,
-	unsigned int	uTxType,
-	void *pvtdCurr,
-	unsigned short wFragType,
-	unsigned int	cbReqCount
-);
-
 static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
@@ -1257,44 +1248,6 @@ s_vGenerateTxParameter(
 	}
 }
 
-static
-void
-s_vFillFragParameter(
-	struct vnt_private *pDevice,
-	unsigned char *pbyBuffer,
-	unsigned int uTxType,
-	void *pvtdCurr,
-	unsigned short wFragType,
-	unsigned int cbReqCount
-)
-{
-	PSTxBufHead pTxBufHead = (PSTxBufHead) pbyBuffer;
-
-	if (uTxType == TYPE_SYNCDMA) {
-		PSTxSyncDesc ptdCurr = (PSTxSyncDesc)pvtdCurr;
-
-		//Set FIFOCtl & TimeStamp in TxSyncDesc
-		ptdCurr->m_wFIFOCtl = pTxBufHead->wFIFOCtl;
-		ptdCurr->m_wTimeStamp = pTxBufHead->wTimeStamp;
-		//Set TSR1 & ReqCount in TxDescHead
-		ptdCurr->m_td1TD1.wReqCount = cpu_to_le16((unsigned short)(cbReqCount));
-		if (wFragType == FRAGCTL_ENDFRAG) //Last Fragmentation
-			ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
-		else
-			ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP);
-	} else {
-		PSTxDesc ptdCurr = (PSTxDesc)pvtdCurr;
-		//Set TSR1 & ReqCount in TxDescHead
-		ptdCurr->m_td1TD1.wReqCount = cpu_to_le16((unsigned short)(cbReqCount));
-		if (wFragType == FRAGCTL_ENDFRAG) //Last Fragmentation
-			ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
-		else
-			ptdCurr->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP);
-	}
-
-	pTxBufHead->wFragCtl |= (unsigned short)wFragType;//0x0001; //0000 0000 0000 0001
-}
-
 static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr, unsigned int cbFrameBodySize,
-- 
1.9.1

