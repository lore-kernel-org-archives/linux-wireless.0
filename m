Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33126 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbcB1TDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 14:03:11 -0500
Received: by mail-wm0-f65.google.com with SMTP id n186so6756956wmn.0
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 11:03:10 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/4] staging: vt6655: mac.c rename dwIoBase to io_base
Date: Sun, 28 Feb 2016 19:02:54 +0000
Message-Id: <1456686177-3167-1-git-send-email-tvboxspy@gmail.com> (sfid-20160228_200316_705928_577FB658)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 274 +++++++++++++++++++++----------------------
 1 file changed, 137 insertions(+), 137 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 79e42d0..5a4fc3b 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -61,7 +61,7 @@
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *      byRegOfs    - Offset of MAC Register
  *      byTestBits  - Test bits
  *  Out:
@@ -73,10 +73,10 @@
 bool MACbIsRegBitsOn(struct vnt_private *priv, unsigned char byRegOfs,
 		     unsigned char byTestBits)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned char byData;
 
-	VNSvInPortB(dwIoBase + byRegOfs, &byData);
+	VNSvInPortB(io_base + byRegOfs, &byData);
 	return (byData & byTestBits) == byTestBits;
 }
 
@@ -86,7 +86,7 @@ bool MACbIsRegBitsOn(struct vnt_private *priv, unsigned char byRegOfs,
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *      byRegOfs    - Offset of MAC Register
  *      byTestBits  - Test bits
  *  Out:
@@ -98,10 +98,10 @@ bool MACbIsRegBitsOn(struct vnt_private *priv, unsigned char byRegOfs,
 bool MACbIsRegBitsOff(struct vnt_private *priv, unsigned char byRegOfs,
 		      unsigned char byTestBits)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned char byData;
 
-	VNSvInPortB(dwIoBase + byRegOfs, &byData);
+	VNSvInPortB(io_base + byRegOfs, &byData);
 	return !(byData & byTestBits);
 }
 
@@ -111,7 +111,7 @@ bool MACbIsRegBitsOff(struct vnt_private *priv, unsigned char byRegOfs,
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *  Out:
  *      none
  *
@@ -120,10 +120,10 @@ bool MACbIsRegBitsOff(struct vnt_private *priv, unsigned char byRegOfs,
  */
 bool MACbIsIntDisable(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned long dwData;
 
-	VNSvInPortD(dwIoBase + MAC_REG_IMR, &dwData);
+	VNSvInPortD(io_base + MAC_REG_IMR, &dwData);
 	if (dwData != 0)
 		return false;
 
@@ -136,7 +136,7 @@ bool MACbIsIntDisable(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *      byRetryLimit- Retry Limit
  *  Out:
  *      none
@@ -146,9 +146,9 @@ bool MACbIsIntDisable(struct vnt_private *priv)
  */
 void MACvSetShortRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	/* set SRT */
-	VNSvOutPortB(dwIoBase + MAC_REG_SRT, byRetryLimit);
+	VNSvOutPortB(io_base + MAC_REG_SRT, byRetryLimit);
 }
 
 
@@ -158,7 +158,7 @@ void MACvSetShortRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *      byRetryLimit- Retry Limit
  *  Out:
  *      none
@@ -168,9 +168,9 @@ void MACvSetShortRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit
  */
 void MACvSetLongRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	/* set LRT */
-	VNSvOutPortB(dwIoBase + MAC_REG_LRT, byRetryLimit);
+	VNSvOutPortB(io_base + MAC_REG_LRT, byRetryLimit);
 }
 
 /*
@@ -179,7 +179,7 @@ void MACvSetLongRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit)
  *
  * Parameters:
  *  In:
- *      dwIoBase        - Base Address for MAC
+ *      io_base        - Base Address for MAC
  *      byLoopbackMode  - Loopback Mode
  *  Out:
  *      none
@@ -189,15 +189,15 @@ void MACvSetLongRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit)
  */
 void MACvSetLoopbackMode(struct vnt_private *priv, unsigned char byLoopbackMode)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned char byOrgValue;
 
 	byLoopbackMode <<= 6;
 	/* set TCR */
-	VNSvInPortB(dwIoBase + MAC_REG_TEST, &byOrgValue);
+	VNSvInPortB(io_base + MAC_REG_TEST, &byOrgValue);
 	byOrgValue = byOrgValue & 0x3F;
 	byOrgValue = byOrgValue | byLoopbackMode;
-	VNSvOutPortB(dwIoBase + MAC_REG_TEST, byOrgValue);
+	VNSvOutPortB(io_base + MAC_REG_TEST, byOrgValue);
 }
 
 /*
@@ -206,7 +206,7 @@ void MACvSetLoopbackMode(struct vnt_private *priv, unsigned char byLoopbackMode)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *  Out:
  *      pbyCxtBuf   - Context buffer
  *
@@ -215,21 +215,21 @@ void MACvSetLoopbackMode(struct vnt_private *priv, unsigned char byLoopbackMode)
  */
 void MACvSaveContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	int         ii;
 
 	/* read page0 register */
 	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE0; ii++)
-		VNSvInPortB((dwIoBase + ii), (pbyCxtBuf + ii));
+		VNSvInPortB((io_base + ii), (pbyCxtBuf + ii));
 
-	MACvSelectPage1(dwIoBase);
+	MACvSelectPage1(io_base);
 
 	/* read page1 register */
 	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++)
-		VNSvInPortB((dwIoBase + ii),
+		VNSvInPortB((io_base + ii),
 			    (pbyCxtBuf + MAC_MAX_CONTEXT_SIZE_PAGE0 + ii));
 
-	MACvSelectPage0(dwIoBase);
+	MACvSelectPage0(io_base);
 }
 
 /*
@@ -238,7 +238,7 @@ void MACvSaveContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *      pbyCxtBuf   - Context buffer
  *  Out:
  *      none
@@ -248,43 +248,43 @@ void MACvSaveContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
  */
 void MACvRestoreContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	int         ii;
 
-	MACvSelectPage1(dwIoBase);
+	MACvSelectPage1(io_base);
 	/* restore page1 */
 	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++)
-		VNSvOutPortB((dwIoBase + ii),
+		VNSvOutPortB((io_base + ii),
 			     *(pbyCxtBuf + MAC_MAX_CONTEXT_SIZE_PAGE0 + ii));
 
-	MACvSelectPage0(dwIoBase);
+	MACvSelectPage0(io_base);
 
 	/* restore RCR,TCR,IMR... */
 	for (ii = MAC_REG_RCR; ii < MAC_REG_ISR; ii++)
-		VNSvOutPortB(dwIoBase + ii, *(pbyCxtBuf + ii));
+		VNSvOutPortB(io_base + ii, *(pbyCxtBuf + ii));
 
 	/* restore MAC Config. */
 	for (ii = MAC_REG_LRT; ii < MAC_REG_PAGE1SEL; ii++)
-		VNSvOutPortB(dwIoBase + ii, *(pbyCxtBuf + ii));
+		VNSvOutPortB(io_base + ii, *(pbyCxtBuf + ii));
 
-	VNSvOutPortB(dwIoBase + MAC_REG_CFG, *(pbyCxtBuf + MAC_REG_CFG));
+	VNSvOutPortB(io_base + MAC_REG_CFG, *(pbyCxtBuf + MAC_REG_CFG));
 
 	/* restore PS Config. */
 	for (ii = MAC_REG_PSCFG; ii < MAC_REG_BBREGCTL; ii++)
-		VNSvOutPortB(dwIoBase + ii, *(pbyCxtBuf + ii));
+		VNSvOutPortB(io_base + ii, *(pbyCxtBuf + ii));
 
 	/* restore CURR_RX_DESC_ADDR, CURR_TX_DESC_ADDR */
-	VNSvOutPortD(dwIoBase + MAC_REG_TXDMAPTR0,
+	VNSvOutPortD(io_base + MAC_REG_TXDMAPTR0,
 		     *(unsigned long *)(pbyCxtBuf + MAC_REG_TXDMAPTR0));
-	VNSvOutPortD(dwIoBase + MAC_REG_AC0DMAPTR,
+	VNSvOutPortD(io_base + MAC_REG_AC0DMAPTR,
 		     *(unsigned long *)(pbyCxtBuf + MAC_REG_AC0DMAPTR));
-	VNSvOutPortD(dwIoBase + MAC_REG_BCNDMAPTR,
+	VNSvOutPortD(io_base + MAC_REG_BCNDMAPTR,
 		     *(unsigned long *)(pbyCxtBuf + MAC_REG_BCNDMAPTR));
 
-	VNSvOutPortD(dwIoBase + MAC_REG_RXDMAPTR0,
+	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR0,
 		     *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR0));
 
-	VNSvOutPortD(dwIoBase + MAC_REG_RXDMAPTR1,
+	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR1,
 		     *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR1));
 }
 
@@ -294,7 +294,7 @@ void MACvRestoreContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *  Out:
  *      none
  *
@@ -303,15 +303,15 @@ void MACvRestoreContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
  */
 bool MACbSoftwareReset(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned char byData;
 	unsigned short ww;
 
 	/* turn on HOSTCR_SOFTRST, just write 0x01 to reset */
-	VNSvOutPortB(dwIoBase + MAC_REG_HOSTCR, 0x01);
+	VNSvOutPortB(io_base + MAC_REG_HOSTCR, 0x01);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_HOSTCR, &byData);
+		VNSvInPortB(io_base + MAC_REG_HOSTCR, &byData);
 		if (!(byData & HOSTCR_SOFTRST))
 			break;
 	}
@@ -326,7 +326,7 @@ bool MACbSoftwareReset(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *  Out:
  *      none
  *
@@ -358,7 +358,7 @@ bool MACbSafeSoftwareReset(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *  Out:
  *      none
  *
@@ -367,7 +367,7 @@ bool MACbSafeSoftwareReset(struct vnt_private *priv)
  */
 bool MACbSafeRxOff(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
 	unsigned long dwData;
 	unsigned char byData;
@@ -375,10 +375,10 @@ bool MACbSafeRxOff(struct vnt_private *priv)
 	/* turn off wow temp for turn off Rx safely */
 
 	/* Clear RX DMA0,1 */
-	VNSvOutPortD(dwIoBase + MAC_REG_RXDMACTL0, DMACTL_CLRRUN);
-	VNSvOutPortD(dwIoBase + MAC_REG_RXDMACTL1, DMACTL_CLRRUN);
+	VNSvOutPortD(io_base + MAC_REG_RXDMACTL0, DMACTL_CLRRUN);
+	VNSvOutPortD(io_base + MAC_REG_RXDMACTL1, DMACTL_CLRRUN);
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(dwIoBase + MAC_REG_RXDMACTL0, &dwData);
+		VNSvInPortD(io_base + MAC_REG_RXDMACTL0, &dwData);
 		if (!(dwData & DMACTL_RUN))
 			break;
 	}
@@ -387,7 +387,7 @@ bool MACbSafeRxOff(struct vnt_private *priv)
 		return false;
 	}
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(dwIoBase + MAC_REG_RXDMACTL1, &dwData);
+		VNSvInPortD(io_base + MAC_REG_RXDMACTL1, &dwData);
 		if (!(dwData & DMACTL_RUN))
 			break;
 	}
@@ -397,10 +397,10 @@ bool MACbSafeRxOff(struct vnt_private *priv)
 	}
 
 	/* try to safe shutdown RX */
-	MACvRegBitsOff(dwIoBase, MAC_REG_HOSTCR, HOSTCR_RXON);
+	MACvRegBitsOff(io_base, MAC_REG_HOSTCR, HOSTCR_RXON);
 	/* W_MAX_TIMEOUT is the timeout period */
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_HOSTCR, &byData);
+		VNSvInPortB(io_base + MAC_REG_HOSTCR, &byData);
 		if (!(byData & HOSTCR_RXONST))
 			break;
 	}
@@ -417,7 +417,7 @@ bool MACbSafeRxOff(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *  Out:
  *      none
  *
@@ -426,19 +426,19 @@ bool MACbSafeRxOff(struct vnt_private *priv)
  */
 bool MACbSafeTxOff(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
 	unsigned long dwData;
 	unsigned char byData;
 
 	/* Clear TX DMA */
 	/* Tx0 */
-	VNSvOutPortD(dwIoBase + MAC_REG_TXDMACTL0, DMACTL_CLRRUN);
+	VNSvOutPortD(io_base + MAC_REG_TXDMACTL0, DMACTL_CLRRUN);
 	/* AC0 */
-	VNSvOutPortD(dwIoBase + MAC_REG_AC0DMACTL, DMACTL_CLRRUN);
+	VNSvOutPortD(io_base + MAC_REG_AC0DMACTL, DMACTL_CLRRUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(dwIoBase + MAC_REG_TXDMACTL0, &dwData);
+		VNSvInPortD(io_base + MAC_REG_TXDMACTL0, &dwData);
 		if (!(dwData & DMACTL_RUN))
 			break;
 	}
@@ -447,7 +447,7 @@ bool MACbSafeTxOff(struct vnt_private *priv)
 		return false;
 	}
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(dwIoBase + MAC_REG_AC0DMACTL, &dwData);
+		VNSvInPortD(io_base + MAC_REG_AC0DMACTL, &dwData);
 		if (!(dwData & DMACTL_RUN))
 			break;
 	}
@@ -457,11 +457,11 @@ bool MACbSafeTxOff(struct vnt_private *priv)
 	}
 
 	/* try to safe shutdown TX */
-	MACvRegBitsOff(dwIoBase, MAC_REG_HOSTCR, HOSTCR_TXON);
+	MACvRegBitsOff(io_base, MAC_REG_HOSTCR, HOSTCR_TXON);
 
 	/* W_MAX_TIMEOUT is the timeout period */
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_HOSTCR, &byData);
+		VNSvInPortB(io_base + MAC_REG_HOSTCR, &byData);
 		if (!(byData & HOSTCR_TXONST))
 			break;
 	}
@@ -478,7 +478,7 @@ bool MACbSafeTxOff(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *  Out:
  *      none
  *
@@ -487,9 +487,9 @@ bool MACbSafeTxOff(struct vnt_private *priv)
  */
 bool MACbSafeStop(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 
-	MACvRegBitsOff(dwIoBase, MAC_REG_TCR, TCR_AUTOBCNTX);
+	MACvRegBitsOff(io_base, MAC_REG_TCR, TCR_AUTOBCNTX);
 
 	if (!MACbSafeRxOff(priv)) {
 		pr_debug(" MACbSafeRxOff == false)\n");
@@ -502,7 +502,7 @@ bool MACbSafeStop(struct vnt_private *priv)
 		return false;
 	}
 
-	MACvRegBitsOff(dwIoBase, MAC_REG_HOSTCR, HOSTCR_MACEN);
+	MACvRegBitsOff(io_base, MAC_REG_HOSTCR, HOSTCR_MACEN);
 
 	return true;
 }
@@ -513,7 +513,7 @@ bool MACbSafeStop(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *  Out:
  *      none
  *
@@ -522,9 +522,9 @@ bool MACbSafeStop(struct vnt_private *priv)
  */
 bool MACbShutdown(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	/* disable MAC IMR */
-	MACvIntDisable(dwIoBase);
+	MACvIntDisable(io_base);
 	MACvSetLoopbackMode(priv, MAC_LB_INTERNAL);
 	/* stop the adapter */
 	if (!MACbSafeStop(priv)) {
@@ -541,7 +541,7 @@ bool MACbShutdown(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *  Out:
  *      none
  *
@@ -550,20 +550,20 @@ bool MACbShutdown(struct vnt_private *priv)
  */
 void MACvInitialize(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	/* clear sticky bits */
-	MACvClearStckDS(dwIoBase);
+	MACvClearStckDS(io_base);
 	/* disable force PME-enable */
-	VNSvOutPortB(dwIoBase + MAC_REG_PMC1, PME_OVR);
+	VNSvOutPortB(io_base + MAC_REG_PMC1, PME_OVR);
 	/* only 3253 A */
 
 	/* do reset */
 	MACbSoftwareReset(priv);
 
 	/* reset TSF counter */
-	VNSvOutPortB(dwIoBase + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
+	VNSvOutPortB(io_base + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
 	/* enable TSF counter */
-	VNSvOutPortB(dwIoBase + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+	VNSvOutPortB(io_base + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
 }
 
 /*
@@ -572,7 +572,7 @@ void MACvInitialize(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      dwIoBase        - Base Address for MAC
+ *      io_base        - Base Address for MAC
  *      dwCurrDescAddr  - Descriptor Address
  *  Out:
  *      none
@@ -582,24 +582,24 @@ void MACvInitialize(struct vnt_private *priv)
  */
 void MACvSetCurrRx0DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAddr)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byData;
 	unsigned char byOrgDMACtl;
 
-	VNSvInPortB(dwIoBase + MAC_REG_RXDMACTL0, &byOrgDMACtl);
+	VNSvInPortB(io_base + MAC_REG_RXDMACTL0, &byOrgDMACtl);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(dwIoBase + MAC_REG_RXDMACTL0+2, DMACTL_RUN);
+		VNSvOutPortB(io_base + MAC_REG_RXDMACTL0+2, DMACTL_RUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_RXDMACTL0, &byData);
+		VNSvInPortB(io_base + MAC_REG_RXDMACTL0, &byData);
 		if (!(byData & DMACTL_RUN))
 			break;
 	}
 
-	VNSvOutPortD(dwIoBase + MAC_REG_RXDMAPTR0, dwCurrDescAddr);
+	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR0, dwCurrDescAddr);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(dwIoBase + MAC_REG_RXDMACTL0, DMACTL_RUN);
+		VNSvOutPortB(io_base + MAC_REG_RXDMACTL0, DMACTL_RUN);
 }
 
 /*
@@ -608,7 +608,7 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
  *
  * Parameters:
  *  In:
- *      dwIoBase        - Base Address for MAC
+ *      io_base        - Base Address for MAC
  *      dwCurrDescAddr  - Descriptor Address
  *  Out:
  *      none
@@ -618,24 +618,24 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
  */
 void MACvSetCurrRx1DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAddr)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byData;
 	unsigned char byOrgDMACtl;
 
-	VNSvInPortB(dwIoBase + MAC_REG_RXDMACTL1, &byOrgDMACtl);
+	VNSvInPortB(io_base + MAC_REG_RXDMACTL1, &byOrgDMACtl);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(dwIoBase + MAC_REG_RXDMACTL1+2, DMACTL_RUN);
+		VNSvOutPortB(io_base + MAC_REG_RXDMACTL1+2, DMACTL_RUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_RXDMACTL1, &byData);
+		VNSvInPortB(io_base + MAC_REG_RXDMACTL1, &byData);
 		if (!(byData & DMACTL_RUN))
 			break;
 	}
 
-	VNSvOutPortD(dwIoBase + MAC_REG_RXDMAPTR1, dwCurrDescAddr);
+	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR1, dwCurrDescAddr);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(dwIoBase + MAC_REG_RXDMACTL1, DMACTL_RUN);
+		VNSvOutPortB(io_base + MAC_REG_RXDMACTL1, DMACTL_RUN);
 
 }
 
@@ -645,7 +645,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
  *
  * Parameters:
  *  In:
- *      dwIoBase        - Base Address for MAC
+ *      io_base        - Base Address for MAC
  *      dwCurrDescAddr  - Descriptor Address
  *  Out:
  *      none
@@ -656,24 +656,24 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
 void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 			      unsigned long dwCurrDescAddr)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byData;
 	unsigned char byOrgDMACtl;
 
-	VNSvInPortB(dwIoBase + MAC_REG_TXDMACTL0, &byOrgDMACtl);
+	VNSvInPortB(io_base + MAC_REG_TXDMACTL0, &byOrgDMACtl);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(dwIoBase + MAC_REG_TXDMACTL0+2, DMACTL_RUN);
+		VNSvOutPortB(io_base + MAC_REG_TXDMACTL0+2, DMACTL_RUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_TXDMACTL0, &byData);
+		VNSvInPortB(io_base + MAC_REG_TXDMACTL0, &byData);
 		if (!(byData & DMACTL_RUN))
 			break;
 	}
 
-	VNSvOutPortD(dwIoBase + MAC_REG_TXDMAPTR0, dwCurrDescAddr);
+	VNSvOutPortD(io_base + MAC_REG_TXDMAPTR0, dwCurrDescAddr);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(dwIoBase + MAC_REG_TXDMACTL0, DMACTL_RUN);
+		VNSvOutPortB(io_base + MAC_REG_TXDMACTL0, DMACTL_RUN);
 }
 
 /*
@@ -682,7 +682,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
  *
  * Parameters:
  *  In:
- *      dwIoBase        - Base Address for MAC
+ *      io_base        - Base Address for MAC
  *      dwCurrDescAddr  - Descriptor Address
  *  Out:
  *      none
@@ -694,25 +694,25 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 			      unsigned long dwCurrDescAddr)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byData;
 	unsigned char byOrgDMACtl;
 
-	VNSvInPortB(dwIoBase + MAC_REG_AC0DMACTL, &byOrgDMACtl);
+	VNSvInPortB(io_base + MAC_REG_AC0DMACTL, &byOrgDMACtl);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(dwIoBase + MAC_REG_AC0DMACTL+2, DMACTL_RUN);
+		VNSvOutPortB(io_base + MAC_REG_AC0DMACTL+2, DMACTL_RUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_AC0DMACTL, &byData);
+		VNSvInPortB(io_base + MAC_REG_AC0DMACTL, &byData);
 		if (!(byData & DMACTL_RUN))
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT)
 		pr_debug(" DBG_PORT80(0x26)\n");
-	VNSvOutPortD(dwIoBase + MAC_REG_AC0DMAPTR, dwCurrDescAddr);
+	VNSvOutPortD(io_base + MAC_REG_AC0DMAPTR, dwCurrDescAddr);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(dwIoBase + MAC_REG_AC0DMACTL, DMACTL_RUN);
+		VNSvOutPortB(io_base + MAC_REG_AC0DMACTL, DMACTL_RUN);
 }
 
 void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *priv,
@@ -730,7 +730,7 @@ void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *priv,
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *      uDelay      - Delay time (timer resolution is 4 us)
  *  Out:
  *      none
@@ -740,24 +740,24 @@ void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *priv,
  */
 void MACvTimer0MicroSDelay(struct vnt_private *priv, unsigned int uDelay)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned char byValue;
 	unsigned int uu, ii;
 
-	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL0, 0);
-	VNSvOutPortD(dwIoBase + MAC_REG_TMDATA0, uDelay);
-	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL0, (TMCTL_TMD | TMCTL_TE));
+	VNSvOutPortB(io_base + MAC_REG_TMCTL0, 0);
+	VNSvOutPortD(io_base + MAC_REG_TMDATA0, uDelay);
+	VNSvOutPortB(io_base + MAC_REG_TMCTL0, (TMCTL_TMD | TMCTL_TE));
 	for (ii = 0; ii < 66; ii++) {  /* assume max PCI clock is 66Mhz */
 		for (uu = 0; uu < uDelay; uu++) {
-			VNSvInPortB(dwIoBase + MAC_REG_TMCTL0, &byValue);
+			VNSvInPortB(io_base + MAC_REG_TMCTL0, &byValue);
 			if ((byValue == 0) ||
 			    (byValue & TMCTL_TSUSP)) {
-				VNSvOutPortB(dwIoBase + MAC_REG_TMCTL0, 0);
+				VNSvOutPortB(io_base + MAC_REG_TMCTL0, 0);
 				return;
 			}
 		}
 	}
-	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL0, 0);
+	VNSvOutPortB(io_base + MAC_REG_TMCTL0, 0);
 }
 
 /*
@@ -766,7 +766,7 @@ void MACvTimer0MicroSDelay(struct vnt_private *priv, unsigned int uDelay)
  *
  * Parameters:
  *  In:
- *      dwIoBase    - Base Address for MAC
+ *      io_base    - Base Address for MAC
  *      uDelay      - Delay time
  *  Out:
  *      none
@@ -776,28 +776,28 @@ void MACvTimer0MicroSDelay(struct vnt_private *priv, unsigned int uDelay)
  */
 void MACvOneShotTimer1MicroSec(struct vnt_private *priv, unsigned int uDelayTime)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 
-	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL1, 0);
-	VNSvOutPortD(dwIoBase + MAC_REG_TMDATA1, uDelayTime);
-	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL1, (TMCTL_TMD | TMCTL_TE));
+	VNSvOutPortB(io_base + MAC_REG_TMCTL1, 0);
+	VNSvOutPortD(io_base + MAC_REG_TMDATA1, uDelayTime);
+	VNSvOutPortB(io_base + MAC_REG_TMCTL1, (TMCTL_TMD | TMCTL_TE));
 }
 
 void MACvSetMISCFifo(struct vnt_private *priv, unsigned short wOffset,
 		     unsigned long dwData)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 
 	if (wOffset > 273)
 		return;
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
+	VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, dwData);
+	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 }
 
 bool MACbPSWakeup(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned char byOrgValue;
 	unsigned int ww;
 	/* Read PSCTL */
@@ -805,11 +805,11 @@ bool MACbPSWakeup(struct vnt_private *priv)
 		return true;
 
 	/* Disable PS */
-	MACvRegBitsOff(dwIoBase, MAC_REG_PSCTL, PSCTL_PSEN);
+	MACvRegBitsOff(io_base, MAC_REG_PSCTL, PSCTL_PSEN);
 
 	/* Check if SyncFlushOK */
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(dwIoBase + MAC_REG_PSCTL, &byOrgValue);
+		VNSvInPortB(io_base + MAC_REG_PSCTL, &byOrgValue);
 		if (byOrgValue & PSCTL_WAKEDONE)
 			break;
 	}
@@ -826,7 +826,7 @@ bool MACbPSWakeup(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      dwIoBase        - Base Address for MAC
+ *      io_base        - Base Address for MAC
  *
  *  Out:
  *      none
@@ -840,7 +840,7 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 		     unsigned char *pbyAddr, u32 *pdwKey,
 		     unsigned char byLocalID)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned short wOffset;
 	u32 dwData;
 	int     ii;
@@ -859,9 +859,9 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 	pr_debug("1. wOffset: %d, Data: %X, KeyCtl:%X\n",
 		 wOffset, dwData, wKeyCtl);
 
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
+	VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, dwData);
+	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 	wOffset++;
 
 	dwData = 0;
@@ -874,9 +874,9 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 	dwData |= *(pbyAddr+0);
 	pr_debug("2. wOffset: %d, Data: %X\n", wOffset, dwData);
 
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
+	VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, dwData);
+	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 	wOffset++;
 
 	wOffset += (uKeyIdx * 4);
@@ -884,9 +884,9 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 		/* always push 128 bits */
 		pr_debug("3.(%d) wOffset: %d, Data: %X\n",
 			 ii, wOffset+ii, *pdwKey);
-		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
-		VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
-		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+		VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset+ii);
+		VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, *pdwKey++);
+		VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 	}
 }
 
@@ -896,7 +896,7 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
  *
  * Parameters:
  *  In:
- *      dwIoBase        - Base Address for MAC
+ *      io_base        - Base Address for MAC
  *
  *  Out:
  *      none
@@ -906,13 +906,13 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
  */
 void MACvDisableKeyEntry(struct vnt_private *priv, unsigned int uEntryIdx)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
+	void __iomem *io_base = priv->PortOffset;
 	unsigned short wOffset;
 
 	wOffset = MISCFIFO_KEYETRY0;
 	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, 0);
-	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
+	VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, 0);
+	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 }
-- 
2.7.0

