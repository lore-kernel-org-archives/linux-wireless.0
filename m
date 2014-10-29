Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35927 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbaJ2RqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:46:01 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so2404946wib.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:46:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 27/34] staging: vt6655: baseband.c replace BIT0 with BIT(0)
Date: Wed, 29 Oct 2014 17:44:02 +0000
Message-Id: <1414604649-9105-28-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184620_362481_C703364F)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index b8a64c0..8adeea4 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -2116,7 +2116,7 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
 				bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC4_RFMD2959[ii][0], byVT3253B0_AGC4_RFMD2959[ii][1]);
 
 			VNSvOutPortD(dwIoBase + MAC_REG_ITRTMSET, 0x23);
-			MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT0);
+			MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT(0));
 		}
 		pDevice->abyBBVGA[0] = 0x18;
 		pDevice->abyBBVGA[1] = 0x0A;
@@ -2149,7 +2149,7 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
 		VNSvOutPortB(dwIoBase + MAC_REG_ITRTMSET, 0x23);
-		MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT0);
+		MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT(0));
 
 		pDevice->abyBBVGA[0] = 0x14;
 		pDevice->abyBBVGA[1] = 0x0A;
@@ -2455,7 +2455,7 @@ BBvPowerSaveModeON(void __iomem *dwIoBase)
 	unsigned char byOrgData;
 
 	BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
-	byOrgData |= BIT0;
+	byOrgData |= BIT(0);
 	BBbWriteEmbedded(dwIoBase, 0x0D, byOrgData);
 }
 
@@ -2477,7 +2477,7 @@ BBvPowerSaveModeOFF(void __iomem *dwIoBase)
 	unsigned char byOrgData;
 
 	BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
-	byOrgData &= ~(BIT0);
+	byOrgData &= ~(BIT(0));
 	BBbWriteEmbedded(dwIoBase, 0x0D, byOrgData);
 }
 
-- 
2.1.0

