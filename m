Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49037 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaJYTcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:32:07 -0400
Received: by mail-wg0-f43.google.com with SMTP id n12so3077371wgh.26
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:32:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 27/31] staging: vt6655: baseband.c replace BIT0 with BIT(0)
Date: Sat, 25 Oct 2014 09:20:37 +0100
Message-Id: <1414225241-5480-28-git-send-email-tvboxspy@gmail.com> (sfid-20141025_213214_256236_345480BC)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
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
1.9.1

