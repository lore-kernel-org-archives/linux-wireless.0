Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36381 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKEVJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:40 -0500
Received: by mail-wi0-f176.google.com with SMTP id h11so13632589wiw.9
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:39 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/11] staging: vt6655: mac.c and mac.h remove dead functions.
Date: Wed,  5 Nov 2014 21:08:51 +0000
Message-Id: <1415221739-3045-3-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220944_150146_FCA362EE)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MACvReadAllRegs
MACbyReadMultiAddr
MACvWriteMultiAddr
MACvSetMultiAddrByHash
MACvResetMultiAddrByHash
MACvSetRxThreshold
MACvGetRxThreshold
MACvSetTxThreshold
MACvGetTxThreshold
MACvSetDmaLength
MACvGetDmaLength
MACvGetLongRetryLimit
MACbIsInLoopbackMode
MACbCompareContext
MACvOneShotTimer0MicroSec
MACbTxDMAOff
MACvClearBusSusInd
MACvEnableBusSusEn
MACbFlushSYNCFifo
MACvSetDefaultKeyEntry
MACvEnableDefaultKey
MACvDisableDefaultKey
MACvSetDefaultTKIPKeyEntry
MACvSetDefaultKeyCtl

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6655/mac.c | 702 -------------------------------------------
 drivers/staging/vt6655/mac.h |  32 --
 2 files changed, 734 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 2ea74a1..af96606 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -26,30 +26,16 @@
  * Date: May 21, 1996
  *
  * Functions:
- *      MACvReadAllRegs - Read All MAC Registers to buffer
  *      MACbIsRegBitsOn - Test if All test Bits On
  *      MACbIsRegBitsOff - Test if All test Bits Off
  *      MACbIsIntDisable - Test if MAC interrupt disable
- *      MACbyReadMultiAddr - Read Multicast Address Mask Pattern
- *      MACvWriteMultiAddr - Write Multicast Address Mask Pattern
- *      MACvSetMultiAddrByHash - Set Multicast Address Mask by Hash value
- *      MACvResetMultiAddrByHash - Clear Multicast Address Mask by Hash value
- *      MACvSetRxThreshold - Set Rx Threshold value
- *      MACvGetRxThreshold - Get Rx Threshold value
- *      MACvSetTxThreshold - Set Tx Threshold value
- *      MACvGetTxThreshold - Get Tx Threshold value
- *      MACvSetDmaLength - Set Dma Length value
- *      MACvGetDmaLength - Get Dma Length value
  *      MACvSetShortRetryLimit - Set 802.11 Short Retry limit
  *      MACvGetShortRetryLimit - Get 802.11 Short Retry limit
  *      MACvSetLongRetryLimit - Set 802.11 Long Retry limit
- *      MACvGetLongRetryLimit - Get 802.11 Long Retry limit
  *      MACvSetLoopbackMode - Set MAC Loopback Mode
- *      MACbIsInLoopbackMode - Test if MAC in Loopback mode
  *      MACvSetPacketFilter - Set MAC Address Filter
  *      MACvSaveContext - Save Context of MAC Registers
  *      MACvRestoreContext - Restore Context of MAC Registers
- *      MACbCompareContext - Compare if values of MAC Registers same as Context
  *      MACbSoftwareReset - Software Reset MAC
  *      MACbSafeRxOff - Turn Off MAC Rx
  *      MACbSafeTxOff - Turn Off MAC Tx
@@ -73,40 +59,6 @@
 
 /*
  * Description:
- *      Read All MAC Registers to buffer
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *  Out:
- *      pbyMacRegs  - buffer to read
- *
- * Return Value: none
- *
- */
-void MACvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyMacRegs)
-{
-	int ii;
-
-	// read page0 register
-	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE0; ii++) {
-		VNSvInPortB(dwIoBase + ii, pbyMacRegs);
-		pbyMacRegs++;
-	}
-
-	MACvSelectPage1(dwIoBase);
-
-	// read page1 register
-	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++) {
-		VNSvInPortB(dwIoBase + ii, pbyMacRegs);
-		pbyMacRegs++;
-	}
-
-	MACvSelectPage0(dwIoBase);
-}
-
-/*
- * Description:
  *      Test if all test bits on
  *
  * Parameters:
@@ -177,252 +129,6 @@ bool MACbIsIntDisable(void __iomem *dwIoBase)
 
 /*
  * Description:
- *      Read MAC Multicast Address Mask
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      uByteidx    - Index of Mask
- *  Out:
- *      none
- *
- * Return Value: Mask Value read
- *
- */
-unsigned char MACbyReadMultiAddr(void __iomem *dwIoBase, unsigned int uByteIdx)
-{
-	unsigned char byData;
-
-	MACvSelectPage1(dwIoBase);
-	VNSvInPortB(dwIoBase + MAC_REG_MAR0 + uByteIdx, &byData);
-	MACvSelectPage0(dwIoBase);
-	return byData;
-}
-
-/*
- * Description:
- *      Write MAC Multicast Address Mask
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      uByteidx    - Index of Mask
- *      byData      - Mask Value to write
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void MACvWriteMultiAddr(void __iomem *dwIoBase, unsigned int uByteIdx, unsigned char byData)
-{
-	MACvSelectPage1(dwIoBase);
-	VNSvOutPortB(dwIoBase + MAC_REG_MAR0 + uByteIdx, byData);
-	MACvSelectPage0(dwIoBase);
-}
-
-/*
- * Description:
- *      Set this hash index into multicast address register bit
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      byHashIdx   - Hash index to set
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void MACvSetMultiAddrByHash(void __iomem *dwIoBase, unsigned char byHashIdx)
-{
-	unsigned int uByteIdx;
-	unsigned char byBitMask;
-	unsigned char byOrgValue;
-
-	// calculate byte position
-	uByteIdx = byHashIdx / 8;
-	ASSERT(uByteIdx < 8);
-	// calculate bit position
-	byBitMask = 1;
-	byBitMask <<= (byHashIdx % 8);
-	// turn on the bit
-	byOrgValue = MACbyReadMultiAddr(dwIoBase, uByteIdx);
-	MACvWriteMultiAddr(dwIoBase, uByteIdx, (unsigned char)(byOrgValue | byBitMask));
-}
-
-/*
- * Description:
- *      Reset this hash index into multicast address register bit
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      byHashIdx   - Hash index to clear
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void MACvResetMultiAddrByHash(void __iomem *dwIoBase, unsigned char byHashIdx)
-{
-	unsigned int uByteIdx;
-	unsigned char byBitMask;
-	unsigned char byOrgValue;
-
-	// calculate byte position
-	uByteIdx = byHashIdx / 8;
-	ASSERT(uByteIdx < 8);
-	// calculate bit position
-	byBitMask = 1;
-	byBitMask <<= (byHashIdx % 8);
-	// turn off the bit
-	byOrgValue = MACbyReadMultiAddr(dwIoBase, uByteIdx);
-	MACvWriteMultiAddr(dwIoBase, uByteIdx, (unsigned char)(byOrgValue & (~byBitMask)));
-}
-
-/*
- * Description:
- *      Set Rx Threshold
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      byThreshold - Threshold Value
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void MACvSetRxThreshold(void __iomem *dwIoBase, unsigned char byThreshold)
-{
-	unsigned char byOrgValue;
-
-	ASSERT(byThreshold < 4);
-
-	// set FCR0
-	VNSvInPortB(dwIoBase + MAC_REG_FCR0, &byOrgValue);
-	byOrgValue = (byOrgValue & 0xCF) | (byThreshold << 4);
-	VNSvOutPortB(dwIoBase + MAC_REG_FCR0, byOrgValue);
-}
-
-/*
- * Description:
- *      Get Rx Threshold
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *  Out:
- *      pbyThreshold- Threshold Value Get
- *
- * Return Value: none
- *
- */
-void MACvGetRxThreshold(void __iomem *dwIoBase, unsigned char *pbyThreshold)
-{
-	// get FCR0
-	VNSvInPortB(dwIoBase + MAC_REG_FCR0, pbyThreshold);
-	*pbyThreshold = (*pbyThreshold >> 4) & 0x03;
-}
-
-/*
- * Description:
- *      Set Tx Threshold
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      byThreshold - Threshold Value
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void MACvSetTxThreshold(void __iomem *dwIoBase, unsigned char byThreshold)
-{
-	unsigned char byOrgValue;
-
-	ASSERT(byThreshold < 4);
-
-	// set FCR0
-	VNSvInPortB(dwIoBase + MAC_REG_FCR0, &byOrgValue);
-	byOrgValue = (byOrgValue & 0xF3) | (byThreshold << 2);
-	VNSvOutPortB(dwIoBase + MAC_REG_FCR0, byOrgValue);
-}
-
-/*
- * Description:
- *      Get Tx Threshold
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *  Out:
- *      pbyThreshold- Threshold Value Get
- *
- * Return Value: none
- *
- */
-void MACvGetTxThreshold(void __iomem *dwIoBase, unsigned char *pbyThreshold)
-{
-	// get FCR0
-	VNSvInPortB(dwIoBase + MAC_REG_FCR0, pbyThreshold);
-	*pbyThreshold = (*pbyThreshold >> 2) & 0x03;
-}
-
-/*
- * Description:
- *      Set Dma Length
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      byDmaLength - Dma Length Value
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void MACvSetDmaLength(void __iomem *dwIoBase, unsigned char byDmaLength)
-{
-	unsigned char byOrgValue;
-
-	ASSERT(byDmaLength < 4);
-
-	// set FCR0
-	VNSvInPortB(dwIoBase + MAC_REG_FCR0, &byOrgValue);
-	byOrgValue = (byOrgValue & 0xFC) | byDmaLength;
-	VNSvOutPortB(dwIoBase + MAC_REG_FCR0, byOrgValue);
-}
-
-/*
- * Description:
- *      Get Dma Length
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *  Out:
- *      pbyDmaLength- Dma Length Value Get
- *
- * Return Value: none
- *
- */
-void MACvGetDmaLength(void __iomem *dwIoBase, unsigned char *pbyDmaLength)
-{
-	// get FCR0
-	VNSvInPortB(dwIoBase + MAC_REG_FCR0, pbyDmaLength);
-	*pbyDmaLength &= 0x03;
-}
-
-/*
- * Description:
  *      Set 802.11 Short Retry Limit
  *
  * Parameters:
@@ -482,25 +188,6 @@ void MACvSetLongRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit)
 
 /*
  * Description:
- *      Get 802.11 Long Retry Limit
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *  Out:
- *      pbyRetryLimit   - Retry Limit Get
- *
- * Return Value: none
- *
- */
-void MACvGetLongRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit)
-{
-	// get LRT
-	VNSvInPortB(dwIoBase + MAC_REG_LRT, pbyRetryLimit);
-}
-
-/*
- * Description:
  *      Set MAC Loopback mode
  *
  * Parameters:
@@ -528,29 +215,6 @@ void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode)
 
 /*
  * Description:
- *      Test if MAC in Loopback mode
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *  Out:
- *      none
- *
- * Return Value: true if in Loopback mode; otherwise false
- *
- */
-bool MACbIsInLoopbackMode(void __iomem *dwIoBase)
-{
-	unsigned char byOrgValue;
-
-	VNSvInPortB(dwIoBase + MAC_REG_TEST, &byOrgValue);
-	if (byOrgValue & (TEST_LBINT | TEST_LBEXT))
-		return true;
-	return false;
-}
-
-/*
- * Description:
  *      Set MAC Address filter
  *
  * Parameters:
@@ -690,47 +354,6 @@ void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
 
 /*
  * Description:
- *      Compare if MAC registers same as context buffer
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      pbyCxtBuf   - Context buffer
- *  Out:
- *      none
- *
- * Return Value: true if all values are the same; otherwise false
- *
- */
-bool MACbCompareContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
-{
-	unsigned long dwData;
-
-	// compare MAC context to determine if this is a power lost init,
-	// return true for power remaining init, return false for power lost init
-
-	// compare CURR_RX_DESC_ADDR, CURR_TX_DESC_ADDR
-	VNSvInPortD(dwIoBase + MAC_REG_TXDMAPTR0, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_TXDMAPTR0))
-		return false;
-
-	VNSvInPortD(dwIoBase + MAC_REG_AC0DMAPTR, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_AC0DMAPTR))
-		return false;
-
-	VNSvInPortD(dwIoBase + MAC_REG_RXDMAPTR0, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR0))
-		return false;
-
-	VNSvInPortD(dwIoBase + MAC_REG_RXDMAPTR1, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR1))
-		return false;
-
-	return true;
-}
-
-/*
- * Description:
  *      Software Reset MAC
  *
  * Parameters:
@@ -1222,27 +845,6 @@ void MACvTimer0MicroSDelay(void __iomem *dwIoBase, unsigned int uDelay)
  * Return Value: none
  *
  */
-void MACvOneShotTimer0MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime)
-{
-	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL0, 0);
-	VNSvOutPortD(dwIoBase + MAC_REG_TMDATA0, uDelayTime);
-	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL0, (TMCTL_TMD | TMCTL_TE));
-}
-
-/*
- * Description:
- *      Micro Second One shot timer via MAC
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      uDelay      - Delay time
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
 void MACvOneShotTimer1MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime)
 {
 	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL1, 0);
@@ -1259,102 +861,6 @@ void MACvSetMISCFifo(void __iomem *dwIoBase, unsigned short wOffset, unsigned lo
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 }
 
-bool MACbTxDMAOff(void __iomem *dwIoBase, unsigned int idx)
-{
-	unsigned char byData;
-	unsigned int ww = 0;
-
-	if (idx == TYPE_TXDMA0) {
-		VNSvOutPortB(dwIoBase + MAC_REG_TXDMACTL0+2, DMACTL_RUN);
-		for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-			VNSvInPortB(dwIoBase + MAC_REG_TXDMACTL0, &byData);
-			if (!(byData & DMACTL_RUN))
-				break;
-		}
-	} else if (idx == TYPE_AC0DMA) {
-		VNSvOutPortB(dwIoBase + MAC_REG_AC0DMACTL+2, DMACTL_RUN);
-		for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-			VNSvInPortB(dwIoBase + MAC_REG_AC0DMACTL, &byData);
-			if (!(byData & DMACTL_RUN))
-				break;
-		}
-	}
-	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x29);
-		pr_debug(" DBG_PORT80(0x29)\n");
-		return false;
-	}
-	return true;
-}
-
-void MACvClearBusSusInd(void __iomem *dwIoBase)
-{
-	unsigned long dwOrgValue;
-	unsigned int ww;
-	// check if BcnSusInd enabled
-	VNSvInPortD(dwIoBase + MAC_REG_ENCFG , &dwOrgValue);
-	if (!(dwOrgValue & EnCFG_BcnSusInd))
-		return;
-	//Set BcnSusClr
-	dwOrgValue = dwOrgValue | EnCFG_BcnSusClr;
-	VNSvOutPortD(dwIoBase + MAC_REG_ENCFG, dwOrgValue);
-	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(dwIoBase + MAC_REG_ENCFG , &dwOrgValue);
-		if (!(dwOrgValue & EnCFG_BcnSusInd))
-			break;
-	}
-	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x33);
-		pr_debug(" DBG_PORT80(0x33)\n");
-	}
-}
-
-void MACvEnableBusSusEn(void __iomem *dwIoBase)
-{
-	unsigned char byOrgValue;
-	unsigned long dwOrgValue;
-	unsigned int ww;
-	// check if BcnSusInd enabled
-	VNSvInPortB(dwIoBase + MAC_REG_CFG , &byOrgValue);
-
-	//Set BcnSusEn
-	byOrgValue = byOrgValue | CFG_BCNSUSEN;
-	VNSvOutPortB(dwIoBase + MAC_REG_ENCFG, byOrgValue);
-	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(dwIoBase + MAC_REG_ENCFG , &dwOrgValue);
-		if (dwOrgValue & EnCFG_BcnSusInd)
-			break;
-	}
-	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x34);
-		pr_debug(" DBG_PORT80(0x34)\n");
-	}
-}
-
-bool MACbFlushSYNCFifo(void __iomem *dwIoBase)
-{
-	unsigned char byOrgValue;
-	unsigned int ww;
-	// Read MACCR
-	VNSvInPortB(dwIoBase + MAC_REG_MACCR , &byOrgValue);
-
-	// Set SYNCFLUSH
-	byOrgValue = byOrgValue | MACCR_SYNCFLUSH;
-	VNSvOutPortB(dwIoBase + MAC_REG_MACCR, byOrgValue);
-
-	// Check if SyncFlushOK
-	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_MACCR , &byOrgValue);
-		if (byOrgValue & MACCR_SYNCFLUSHOK)
-			break;
-	}
-	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x35);
-		pr_debug(" DBG_PORT80(0x33)\n");
-	}
-	return true;
-}
-
 bool MACbPSWakeup(void __iomem *dwIoBase)
 {
 	unsigned char byOrgValue;
@@ -1472,211 +978,3 @@ void MACvDisableKeyEntry(void __iomem *dwIoBase, unsigned int uEntryIdx)
 	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, 0);
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 }
-
-/*
- * Description:
- *      Set the default Key (KeyEntry[10]) by MISCFIFO
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-
-void MACvSetDefaultKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
-			    unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID)
-{
-	unsigned short wOffset;
-	unsigned long dwData;
-	int     ii;
-
-	if (byLocalID <= 1)
-		return;
-
-	pr_debug("MACvSetDefaultKeyEntry\n");
-	wOffset = MISCFIFO_KEYETRY0;
-	wOffset += (10 * MISCFIFO_KEYENTRYSIZE);
-
-	wOffset++;
-	wOffset++;
-	wOffset += (uKeyIdx * 4);
-	// always push 128 bits
-	for (ii = 0; ii < 3; ii++) {
-		pr_debug("(%d) wOffset: %d, Data: %lX\n",
-			 ii, wOffset+ii, *pdwKey);
-		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
-		VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
-		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-	}
-	dwData = *pdwKey;
-	if (uKeyLen == WLAN_KEY_LEN_WEP40)
-		dwData |= 0x80000000;
-
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+3);
-	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-	pr_debug("End. wOffset: %d, Data: %lX\n", wOffset+3, dwData);
-}
-
-/*
- * Description:
- *      Enable default Key (KeyEntry[10]) by MISCFIFO
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-/*
-  void MACvEnableDefaultKey(void __iomem *dwIoBase, unsigned char byLocalID)
-  {
-  unsigned short wOffset;
-  unsigned long dwData;
-
-  if (byLocalID <= 1)
-  return;
-
-  wOffset = MISCFIFO_KEYETRY0;
-  wOffset += (10 * MISCFIFO_KEYENTRYSIZE);
-
-  dwData = 0xC0440000;
-  VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-  VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-  VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-  pr_debug("MACvEnableDefaultKey: wOffset: %d, Data: %lX\n", wOffset, dwData);
-
-  }
-*/
-
-/*
- * Description:
- *      Disable default Key (KeyEntry[10]) by MISCFIFO
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void MACvDisableDefaultKey(void __iomem *dwIoBase)
-{
-	unsigned short wOffset;
-	unsigned long dwData;
-
-	wOffset = MISCFIFO_KEYETRY0;
-	wOffset += (10 * MISCFIFO_KEYENTRYSIZE);
-
-	dwData = 0x0;
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-	pr_debug("MACvDisableDefaultKey: wOffset: %d, Data: %lX\n",
-		 wOffset, dwData);
-}
-
-/*
- * Description:
- *      Set the default TKIP Group Key (KeyEntry[10]) by MISCFIFO
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void MACvSetDefaultTKIPKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
-				unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID)
-{
-	unsigned short wOffset;
-	unsigned long dwData;
-	int     ii;
-
-	if (byLocalID <= 1)
-		return;
-
-	pr_debug("MACvSetDefaultTKIPKeyEntry\n");
-	wOffset = MISCFIFO_KEYETRY0;
-	// Kyle test : change offset from 10 -> 0
-	wOffset += (10 * MISCFIFO_KEYENTRYSIZE);
-
-	dwData = 0xC0660000;
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-	wOffset++;
-
-	dwData = 0;
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-	wOffset++;
-
-	wOffset += (uKeyIdx * 4);
-	pr_debug("1. wOffset: %d, Data: %lX, idx:%d\n",
-		 wOffset, *pdwKey, uKeyIdx);
-	// always push 128 bits
-	for (ii = 0; ii < 4; ii++) {
-		pr_debug("2.(%d) wOffset: %d, Data: %lX\n",
-			 ii, wOffset+ii, *pdwKey);
-		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
-		VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
-		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-	}
-}
-
-/*
- * Description:
- *      Set the Key Control by MISCFIFO
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-
-void MACvSetDefaultKeyCtl(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx, unsigned char byLocalID)
-{
-	unsigned short wOffset;
-	unsigned long dwData;
-
-	if (byLocalID <= 1)
-		return;
-
-	pr_debug("MACvSetKeyEntry\n");
-	wOffset = MISCFIFO_KEYETRY0;
-	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
-
-	dwData = 0;
-	dwData |= wKeyCtl;
-	dwData <<= 16;
-	dwData |= 0xffff;
-	pr_debug("1. wOffset: %d, Data: %lX, KeyCtl:%X\n",
-		 wOffset, dwData, wKeyCtl);
-
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-}
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 3f37014..7d39a7f 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -964,41 +964,22 @@ do {								\
 #define MACvSetRFLE_LatchBase(dwIoBase)                                 \
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_RFLEOPT)
 
-void MACvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyMacRegs);
-
 bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
 bool MACbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
 
 bool MACbIsIntDisable(void __iomem *dwIoBase);
 
-unsigned char MACbyReadMultiAddr(void __iomem *dwIoBase, unsigned int uByteIdx);
-void MACvWriteMultiAddr(void __iomem *dwIoBase, unsigned int uByteIdx, unsigned char byData);
-void MACvSetMultiAddrByHash(void __iomem *dwIoBase, unsigned char byHashIdx);
-void MACvResetMultiAddrByHash(void __iomem *dwIoBase, unsigned char byHashIdx);
-
-void MACvSetRxThreshold(void __iomem *dwIoBase, unsigned char byThreshold);
-void MACvGetRxThreshold(void __iomem *dwIoBase, unsigned char *pbyThreshold);
-
-void MACvSetTxThreshold(void __iomem *dwIoBase, unsigned char byThreshold);
-void MACvGetTxThreshold(void __iomem *dwIoBase, unsigned char *pbyThreshold);
-
-void MACvSetDmaLength(void __iomem *dwIoBase, unsigned char byDmaLength);
-void MACvGetDmaLength(void __iomem *dwIoBase, unsigned char *pbyDmaLength);
-
 void MACvSetShortRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit);
-void MACvGetShortRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit);
 
 void MACvSetLongRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit);
 void MACvGetLongRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit);
 
 void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode);
-bool MACbIsInLoopbackMode(void __iomem *dwIoBase);
 
 void MACvSetPacketFilter(void __iomem *dwIoBase, unsigned short wFilterType);
 
 void MACvSaveContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
 void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
-bool MACbCompareContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
 
 bool MACbSoftwareReset(void __iomem *dwIoBase);
 bool MACbSafeSoftwareReset(void __iomem *dwIoBase);
@@ -1015,27 +996,14 @@ void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAd
 void MACvSetCurrSyncDescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
 void MACvSetCurrATIMDescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
 void MACvTimer0MicroSDelay(void __iomem *dwIoBase, unsigned int uDelay);
-void MACvOneShotTimer0MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime);
 void MACvOneShotTimer1MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime);
 
 void MACvSetMISCFifo(void __iomem *dwIoBase, unsigned short wOffset, unsigned long dwData);
 
-bool MACbTxDMAOff(void __iomem *dwIoBase, unsigned int idx);
-
-void MACvClearBusSusInd(void __iomem *dwIoBase);
-void MACvEnableBusSusEn(void __iomem *dwIoBase);
-
-bool MACbFlushSYNCFifo(void __iomem *dwIoBase);
 bool MACbPSWakeup(void __iomem *dwIoBase);
 
 void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx,
 		     unsigned int uKeyIdx, unsigned char *pbyAddr, u32 *pdwKey, unsigned char byLocalID);
 void MACvDisableKeyEntry(void __iomem *dwIoBase, unsigned int uEntryIdx);
-void MACvSetDefaultKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
-			    unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID);
-void MACvDisableDefaultKey(void __iomem *dwIoBase);
-void MACvSetDefaultTKIPKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
-				unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID);
-void MACvSetDefaultKeyCtl(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx, unsigned char byLocalID);
 
 #endif // __MAC_H__
-- 
2.1.0

