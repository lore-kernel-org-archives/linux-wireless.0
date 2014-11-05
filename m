Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54842 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaKEVJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:48 -0500
Received: by mail-wg0-f50.google.com with SMTP id z12so1917900wgg.9
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:47 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/11] staging: vt6655: baseband.c/h remove dead functions
Date: Wed,  5 Nov 2014 21:08:56 +0000
Message-Id: <1415221739-3045-8-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220953_437588_922726EE)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions are not used so remove them
BBbIsRegBitsOn
BBbIsRegBitsOff
BBvReadAllRegs
BBvLoopbackOn
BBvLoopbackOff

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 162 --------------------------------------
 drivers/staging/vt6655/baseband.h |   5 --
 2 files changed, 167 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index b04dfd9..30dd59d 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -30,12 +30,7 @@
  *      BBvCaculateParameter   - Caculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
  *      BBbReadEmbedded         - Embedded read baseband register via MAC
  *      BBbWriteEmbedded        - Embedded write baseband register via MAC
- *      BBbIsRegBitsOn         - Test if baseband register bits on
- *      BBbIsRegBitsOff        - Test if baseband register bits off
  *      BBbVT3253Init          - VIA VT3253 baseband chip init code
- *      BBvReadAllRegs         - Read All Baseband Registers
- *      BBvLoopbackOn          - Turn on BaseBand Loopback mode
- *      BBvLoopbackOff         - Turn off BaseBand Loopback mode
  *
  * Revision History:
  *      06-10-2003 Bryan YC Fan:  Re-write codes to support VT3253 spec.
@@ -2036,50 +2031,6 @@ bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned c
 }
 
 /*
- * Description: Test if all bits are set for the Baseband register
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *      byBBAddr    - address of register in Baseband
- *      byTestBits  - TestBits
- *  Out:
- *      none
- *
- * Return Value: true if all TestBits are set; false otherwise.
- *
- */
-bool BBbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits)
-{
-	unsigned char byOrgData;
-
-	BBbReadEmbedded(dwIoBase, byBBAddr, &byOrgData);
-	return (byOrgData & byTestBits) == byTestBits;
-}
-
-/*
- * Description: Test if all bits are clear for the Baseband register
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *      byBBAddr    - address of register in Baseband
- *      byTestBits  - TestBits
- *  Out:
- *      none
- *
- * Return Value: true if all TestBits are clear; false otherwise.
- *
- */
-bool BBbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits)
-{
-	unsigned char byOrgData;
-
-	BBbReadEmbedded(dwIoBase, byBBAddr, &byOrgData);
-	return (byOrgData & byTestBits) == 0;
-}
-
-/*
  * Description: VIA VT3253 Baseband chip init function
  *
  * Parameters:
@@ -2252,119 +2203,6 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
 }
 
 /*
- * Description: Read All Baseband Registers
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *      pbyBBRegs   - Point to struct that stores Baseband Registers
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void BBvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyBBRegs)
-{
-	int  ii;
-	unsigned char byBase = 1;
-
-	for (ii = 0; ii < BB_MAX_CONTEXT_SIZE; ii++) {
-		BBbReadEmbedded(dwIoBase, (unsigned char)(ii*byBase), pbyBBRegs);
-		pbyBBRegs += byBase;
-	}
-}
-
-/*
- * Description: Turn on BaseBand Loopback mode
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *      bCCK        - If CCK is set
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-
-void BBvLoopbackOn(struct vnt_private *pDevice)
-{
-	unsigned char byData;
-	void __iomem *dwIoBase = pDevice->PortOffset;
-
-	/* CR C9 = 0x00 */
-	BBbReadEmbedded(dwIoBase, 0xC9, &pDevice->byBBCRc9); /* CR201 */
-	BBbWriteEmbedded(dwIoBase, 0xC9, 0);
-	BBbReadEmbedded(dwIoBase, 0x4D, &pDevice->byBBCR4d); /* CR77 */
-	BBbWriteEmbedded(dwIoBase, 0x4D, 0x90);
-
-	/* CR 88 = 0x02(CCK), 0x03(OFDM) */
-	BBbReadEmbedded(dwIoBase, 0x88, &pDevice->byBBCR88); /* CR136 */
-
-	if (pDevice->uConnectionRate <= RATE_11M) { /* CCK */
-		/* Enable internal digital loopback: CR33 |= 0000 0001 */
-		BBbReadEmbedded(dwIoBase, 0x21, &byData); /* CR33 */
-		BBbWriteEmbedded(dwIoBase, 0x21, (unsigned char)(byData | 0x01)); /* CR33 */
-		/* CR154 = 0x00 */
-		BBbWriteEmbedded(dwIoBase, 0x9A, 0);    /* CR154 */
-
-		BBbWriteEmbedded(dwIoBase, 0x88, 0x02); /* CR239 */
-	} else { /* OFDM */
-		/* Enable internal digital loopback:CR154 |= 0000 0001 */
-		BBbReadEmbedded(dwIoBase, 0x9A, &byData); /* CR154 */
-		BBbWriteEmbedded(dwIoBase, 0x9A, (unsigned char)(byData | 0x01)); /* CR154 */
-		/* CR33 = 0x00 */
-		BBbWriteEmbedded(dwIoBase, 0x21, 0);    /* CR33 */
-
-		BBbWriteEmbedded(dwIoBase, 0x88, 0x03); /* CR239 */
-	}
-
-	/* CR14 = 0x00 */
-	BBbWriteEmbedded(dwIoBase, 0x0E, 0); /* CR14 */
-
-	/* Disable TX_IQUN */
-	BBbReadEmbedded(pDevice->PortOffset, 0x09, &pDevice->byBBCR09);
-	BBbWriteEmbedded(pDevice->PortOffset, 0x09, (unsigned char)(pDevice->byBBCR09 & 0xDE));
-}
-
-/*
- * Description: Turn off BaseBand Loopback mode
- *
- * Parameters:
- *  In:
- *      pDevice         - Device Structure
- *
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void BBvLoopbackOff(struct vnt_private *pDevice)
-{
-	unsigned char byData;
-	void __iomem *dwIoBase = pDevice->PortOffset;
-
-	BBbWriteEmbedded(dwIoBase, 0xC9, pDevice->byBBCRc9); /* CR201 */
-	BBbWriteEmbedded(dwIoBase, 0x88, pDevice->byBBCR88); /* CR136 */
-	BBbWriteEmbedded(dwIoBase, 0x09, pDevice->byBBCR09); /* CR136 */
-	BBbWriteEmbedded(dwIoBase, 0x4D, pDevice->byBBCR4d); /* CR77  */
-
-	if (pDevice->uConnectionRate <= RATE_11M) { /* CCK */
-		/* Set the CR33 Bit2 to disable internal Loopback. */
-		BBbReadEmbedded(dwIoBase, 0x21, &byData);/* CR33 */
-		BBbWriteEmbedded(dwIoBase, 0x21, (unsigned char)(byData & 0xFE)); /* CR33 */
-	} else { /* OFDM */
-		BBbReadEmbedded(dwIoBase, 0x9A, &byData); /* CR154 */
-		BBbWriteEmbedded(dwIoBase, 0x9A, (unsigned char)(byData & 0xFE)); /* CR154 */
-	}
-	BBbReadEmbedded(dwIoBase, 0x0E, &byData); /* CR14 */
-	BBbWriteEmbedded(dwIoBase, 0x0E, (unsigned char)(byData | 0x80)); /* CR14 */
-}
-
-/*
  * Description: Set ShortSlotTime mode
  *
  * Parameters:
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index bfdd422..6ce856c 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -80,12 +80,7 @@ void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char *pbyData);
 bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byData);
 
-void BBvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyBBRegs);
-void BBvLoopbackOn(struct vnt_private *pDevice);
-void BBvLoopbackOff(struct vnt_private *pDevice);
 void BBvSetShortSlotTime(struct vnt_private *pDevice);
-bool BBbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits);
-bool BBbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits);
 void BBvSetVGAGainOffset(struct vnt_private *pDevice, unsigned char byData);
 
 /* VT3253 Baseband */
-- 
2.1.0

