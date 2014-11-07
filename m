Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37921 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaKGTGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:39 -0500
Received: by mail-wg0-f44.google.com with SMTP id x12so4499991wgg.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:38 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/10] staging: vt6655: dead code remove CARDbAddBasicRate
Date: Fri,  7 Nov 2014 19:06:01 +0000
Message-Id: <1415387169-3843-2-git-send-email-tvboxspy@gmail.com> (sfid-20141107_200642_336807_FD1A597E)
In-Reply-To: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
References: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we nonlonger set rates in the driver

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 12 ------------
 drivers/staging/vt6655/card.h |  1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index d7b023b..7b25969 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -861,18 +861,6 @@ void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
 	pDevice->byTopCCKBasicRate = byTopCCK;
 }
 
-bool CARDbAddBasicRate(struct vnt_private *pDevice, unsigned short wRateIdx)
-{
-	unsigned short wRate = (unsigned short)(1<<wRateIdx);
-
-	pDevice->wBasicRate |= wRate;
-
-	/* Determines the highest basic rate. */
-	CARDvUpdateBasicTopRate((void *)pDevice);
-
-	return true;
-}
-
 bool CARDbIsOFDMinBasicRate(struct vnt_private *pDevice)
 {
 	int ii;
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index f12afef..2449f3c 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -76,7 +76,6 @@ struct vnt_private;
 void CARDvSetRSPINF(struct vnt_private *, CARD_PHY_TYPE ePHYType);
 void vUpdateIFS(struct vnt_private *);
 void CARDvUpdateBasicTopRate(struct vnt_private *);
-bool CARDbAddBasicRate(struct vnt_private *, unsigned short wRateIdx);
 bool CARDbIsOFDMinBasicRate(struct vnt_private *);
 void CARDvSetLoopbackMode(void __iomem *dwIoBase, unsigned short wLoopbackMode);
 bool CARDbSoftwareReset(struct vnt_private *);
-- 
2.1.0

