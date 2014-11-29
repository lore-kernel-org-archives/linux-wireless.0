Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43911 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaK2ACi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 19:02:38 -0500
Received: by mail-wg0-f52.google.com with SMTP id a1so9884423wgh.25
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2014 16:02:37 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6655: srom remove dead functions
Date: Sat, 29 Nov 2014 00:01:59 +0000
Message-Id: <1417219323-3988-2-git-send-email-tvboxspy@gmail.com> (sfid-20141129_010242_643332_D13B57D9)
In-Reply-To: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
References: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove these unused functions
SROMbWriteEmbedded
SROMvRegBitsOn
SROMvRegBitsOff
SROMbIsRegBitsOn
SROMbIsRegBitsOff
SROMvWriteAllContents
SROMvWriteEtherAddress
SROMvReadSubSysVenId
SROMbAutoLoad

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/srom.c | 251 ------------------------------------------
 drivers/staging/vt6655/srom.h |  13 ---
 2 files changed, 264 deletions(-)

diff --git a/drivers/staging/vt6655/srom.c b/drivers/staging/vt6655/srom.c
index 1ac60fb..9ec49e6 100644
--- a/drivers/staging/vt6655/srom.c
+++ b/drivers/staging/vt6655/srom.c
@@ -107,144 +107,6 @@ unsigned char SROMbyReadEmbedded(void __iomem *dwIoBase, unsigned char byContntO
 }
 
 /*
- * Description: Write a byte to EEPROM, by MAC I2C
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      wData           - data to write
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-bool SROMbWriteEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byData)
-{
-	unsigned short wDelay, wNoACK;
-	unsigned char byWait;
-
-	unsigned char byOrg;
-
-	VNSvInPortB(dwIoBase + MAC_REG_I2MCFG, &byOrg);
-	/* turn off hardware retry for getting NACK */
-	VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, (byOrg & (~I2MCFG_NORETRY)));
-	for (wNoACK = 0; wNoACK < W_MAX_I2CRETRY; wNoACK++) {
-		VNSvOutPortB(dwIoBase + MAC_REG_I2MTGID, EEP_I2C_DEV_ID);
-		VNSvOutPortB(dwIoBase + MAC_REG_I2MTGAD, byContntOffset);
-		VNSvOutPortB(dwIoBase + MAC_REG_I2MDOPT, byData);
-
-		/* issue write command */
-		VNSvOutPortB(dwIoBase + MAC_REG_I2MCSR, I2MCSR_EEMW);
-		/* wait DONE be set */
-		for (wDelay = 0; wDelay < W_MAX_TIMEOUT; wDelay++) {
-			VNSvInPortB(dwIoBase + MAC_REG_I2MCSR, &byWait);
-			if (byWait & (I2MCSR_DONE | I2MCSR_NACK))
-				break;
-			PCAvDelayByIO(CB_DELAY_LOOP_WAIT);
-		}
-
-		if ((wDelay < W_MAX_TIMEOUT) &&
-		    (!(byWait & I2MCSR_NACK))) {
-			break;
-		}
-	}
-	if (wNoACK == W_MAX_I2CRETRY) {
-		VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, byOrg);
-		return false;
-	}
-	VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, byOrg);
-	return true;
-}
-
-/*
- * Description: Turn bits on in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byBits          - bits to turn on
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void SROMvRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits)
-{
-	unsigned char byOrgData;
-
-	byOrgData = SROMbyReadEmbedded(dwIoBase, byContntOffset);
-	SROMbWriteEmbedded(dwIoBase, byContntOffset, (unsigned char)(byOrgData | byBits));
-}
-
-/*
- * Description: Turn bits off in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byBits          - bits to turn off
- *  Out:
- *      none
- *
- */
-void SROMvRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits)
-{
-	unsigned char byOrgData;
-
-	byOrgData = SROMbyReadEmbedded(dwIoBase, byContntOffset);
-	SROMbWriteEmbedded(dwIoBase, byContntOffset, (unsigned char)(byOrgData & (~byBits)));
-}
-
-/*
- * Description: Test if bits on in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byTestBits      - bits to test
- *  Out:
- *      none
- *
- * Return Value: true if all test bits on; otherwise false
- *
- */
-bool SROMbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
-{
-	unsigned char byOrgData;
-
-	byOrgData = SROMbyReadEmbedded(dwIoBase, byContntOffset);
-	return (byOrgData & byTestBits) == byTestBits;
-}
-
-/*
- * Description: Test if bits off in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byTestBits      - bits to test
- *  Out:
- *      none
- *
- * Return Value: true if all test bits off; otherwise false
- *
- */
-bool SROMbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
-{
-	unsigned char byOrgData;
-
-	byOrgData = SROMbyReadEmbedded(dwIoBase, byContntOffset);
-	return !(byOrgData & byTestBits);
-}
-
-/*
  * Description: Read all contents of eeprom to buffer
  *
  * Parameters:
@@ -268,30 +130,6 @@ void SROMvReadAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs)
 }
 
 /*
- * Description: Write all contents of buffer to eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      pbyEepromRegs   - EEPROM content Buffer
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void SROMvWriteAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs)
-{
-	int     ii;
-
-	/* ii = Rom Address */
-	for (ii = 0; ii < EEP_MAX_CONTEXT_SIZE; ii++) {
-		SROMbWriteEmbedded(dwIoBase, (unsigned char)ii, *pbyEepromRegs);
-		pbyEepromRegs++;
-	}
-}
-
-/*
  * Description: Read Ethernet Address from eeprom to buffer
  *
  * Parameters:
@@ -313,92 +151,3 @@ void SROMvReadEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddres
 		pbyEtherAddress++;
 	}
 }
-
-/*
- * Description: Write Ethernet Address from buffer to eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      pbyEtherAddress - Ethernet Address buffer
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void SROMvWriteEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress)
-{
-	unsigned char ii;
-
-	/* ii = Rom Address */
-	for (ii = 0; ii < ETH_ALEN; ii++) {
-		SROMbWriteEmbedded(dwIoBase, ii, *pbyEtherAddress);
-		pbyEtherAddress++;
-	}
-}
-
-/*
- * Description: Read Sub_VID and Sub_SysId from eeprom to buffer
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *  Out:
- *      pdwSubSysVenId  - Sub_VID and Sub_SysId read
- *
- * Return Value: none
- *
- */
-void SROMvReadSubSysVenId(void __iomem *dwIoBase, unsigned long *pdwSubSysVenId)
-{
-	unsigned char *pbyData;
-
-	pbyData = (unsigned char *)pdwSubSysVenId;
-	/* sub vendor */
-	*pbyData = SROMbyReadEmbedded(dwIoBase, 6);
-	*(pbyData+1) = SROMbyReadEmbedded(dwIoBase, 7);
-	/* sub system */
-	*(pbyData+2) = SROMbyReadEmbedded(dwIoBase, 8);
-	*(pbyData+3) = SROMbyReadEmbedded(dwIoBase, 9);
-}
-
-/*
- * Description: Auto Load EEPROM to MAC register
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *  Out:
- *      none
- *
- * Return Value: true if success; otherwise false
- *
- */
-bool SROMbAutoLoad(void __iomem *dwIoBase)
-{
-	unsigned char byWait;
-	int     ii;
-
-	unsigned char byOrg;
-
-	VNSvInPortB(dwIoBase + MAC_REG_I2MCFG, &byOrg);
-	/* turn on hardware retry */
-	VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, (byOrg | I2MCFG_NORETRY));
-
-	MACvRegBitsOn(dwIoBase, MAC_REG_I2MCSR, I2MCSR_AUTOLD);
-
-	/* ii = Rom Address */
-	for (ii = 0; ii < EEP_MAX_CONTEXT_SIZE; ii++) {
-		MACvTimer0MicroSDelay(dwIoBase, CB_EEPROM_READBYTE_WAIT);
-		VNSvInPortB(dwIoBase + MAC_REG_I2MCSR, &byWait);
-		if (!(byWait & I2MCSR_AUTOLD))
-			break;
-	}
-
-	VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, byOrg);
-
-	if (ii == EEP_MAX_CONTEXT_SIZE)
-		return false;
-	return true;
-}
diff --git a/drivers/staging/vt6655/srom.h b/drivers/staging/vt6655/srom.h
index 9f309c4..cab638b 100644
--- a/drivers/staging/vt6655/srom.h
+++ b/drivers/staging/vt6655/srom.h
@@ -132,22 +132,9 @@ typedef struct tagSSromReg {
 /*---------------------  Export Functions  --------------------------*/
 
 unsigned char SROMbyReadEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset);
-bool SROMbWriteEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byData);
-
-void SROMvRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits);
-void SROMvRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits);
-
-bool SROMbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits);
-bool SROMbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits);
 
 void SROMvReadAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs);
-void SROMvWriteAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs);
 
 void SROMvReadEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress);
-void SROMvWriteEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress);
-
-void SROMvReadSubSysVenId(void __iomem *dwIoBase, unsigned long *pdwSubSysVenId);
-
-bool SROMbAutoLoad(void __iomem *dwIoBase);
 
 #endif // __EEPROM_H__
-- 
2.1.0

