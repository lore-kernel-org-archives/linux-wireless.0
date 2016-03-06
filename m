Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35820 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbcCFM5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:31 -0500
Received: by mail-wm0-f66.google.com with SMTP id 1so6277391wmg.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:31 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/13] staging: vt6655: mac.c replace VNSvOutPortB with iowrite8
Date: Sun,  6 Mar 2016 12:57:05 +0000
Message-Id: <1457269032-2681-6-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135740_090723_6673A14E)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

removing macro from functions

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 43e5f66..a1be5a7 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -142,7 +142,7 @@ void MACvSetShortRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit
 {
 	void __iomem *io_base = priv->PortOffset;
 	/* set SRT */
-	VNSvOutPortB(io_base + MAC_REG_SRT, byRetryLimit);
+	iowrite8(byRetryLimit, io_base + MAC_REG_SRT);
 }
 
 
@@ -164,7 +164,7 @@ void MACvSetLongRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit)
 {
 	void __iomem *io_base = priv->PortOffset;
 	/* set LRT */
-	VNSvOutPortB(io_base + MAC_REG_LRT, byRetryLimit);
+	iowrite8(byRetryLimit, io_base + MAC_REG_LRT);
 }
 
 /*
@@ -191,7 +191,7 @@ void MACvSetLoopbackMode(struct vnt_private *priv, unsigned char byLoopbackMode)
 	VNSvInPortB(io_base + MAC_REG_TEST, &byOrgValue);
 	byOrgValue = byOrgValue & 0x3F;
 	byOrgValue = byOrgValue | byLoopbackMode;
-	VNSvOutPortB(io_base + MAC_REG_TEST, byOrgValue);
+	iowrite8(byOrgValue, io_base + MAC_REG_TEST);
 }
 
 /*
@@ -256,7 +256,7 @@ void MACvRestoreContext(struct vnt_private *priv, unsigned char *cxt_buf)
 	memcpy_toio(io_base + MAC_REG_LRT, cxt_buf + MAC_REG_LRT,
 		    MAC_REG_PAGE1SEL - MAC_REG_LRT);
 
-	VNSvOutPortB(io_base + MAC_REG_CFG, *(cxt_buf + MAC_REG_CFG));
+	iowrite8(*(cxt_buf + MAC_REG_CFG), io_base + MAC_REG_CFG);
 
 	/* restore PS Config. */
 	memcpy_toio(io_base + MAC_REG_PSCFG, cxt_buf + MAC_REG_PSCFG,
@@ -294,7 +294,7 @@ bool MACbSoftwareReset(struct vnt_private *priv)
 	unsigned short ww;
 
 	/* turn on HOSTCR_SOFTRST, just write 0x01 to reset */
-	VNSvOutPortB(io_base + MAC_REG_HOSTCR, 0x01);
+	iowrite8(0x01, io_base + MAC_REG_HOSTCR);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		if (!(ioread8(io_base + MAC_REG_HOSTCR) & HOSTCR_SOFTRST))
@@ -529,16 +529,16 @@ void MACvInitialize(struct vnt_private *priv)
 	/* clear sticky bits */
 	MACvClearStckDS(io_base);
 	/* disable force PME-enable */
-	VNSvOutPortB(io_base + MAC_REG_PMC1, PME_OVR);
+	iowrite8(PME_OVR, io_base + MAC_REG_PMC1);
 	/* only 3253 A */
 
 	/* do reset */
 	MACbSoftwareReset(priv);
 
 	/* reset TSF counter */
-	VNSvOutPortB(io_base + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
+	iowrite8(TFTCTL_TSFCNTRST, io_base + MAC_REG_TFTCTL);
 	/* enable TSF counter */
-	VNSvOutPortB(io_base + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+	iowrite8(TFTCTL_TSFCNTREN, io_base + MAC_REG_TFTCTL);
 }
 
 /*
@@ -563,7 +563,7 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 
 	VNSvInPortB(io_base + MAC_REG_RXDMACTL0, &byOrgDMACtl);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(io_base + MAC_REG_RXDMACTL0+2, DMACTL_RUN);
+		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL0 + 2);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		if (!(ioread8(io_base + MAC_REG_RXDMACTL0) & DMACTL_RUN))
@@ -572,7 +572,7 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 
 	iowrite32(dwCurrDescAddr, io_base + MAC_REG_RXDMAPTR0);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(io_base + MAC_REG_RXDMACTL0, DMACTL_RUN);
+		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL0);
 }
 
 /*
@@ -597,7 +597,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 
 	VNSvInPortB(io_base + MAC_REG_RXDMACTL1, &byOrgDMACtl);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(io_base + MAC_REG_RXDMACTL1+2, DMACTL_RUN);
+		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL1 + 2);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		if (!(ioread8(io_base + MAC_REG_RXDMACTL1) & DMACTL_RUN))
@@ -606,7 +606,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 
 	iowrite32(dwCurrDescAddr, io_base + MAC_REG_RXDMAPTR1);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(io_base + MAC_REG_RXDMACTL1, DMACTL_RUN);
+		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL1);
 
 }
 
@@ -633,7 +633,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 
 	VNSvInPortB(io_base + MAC_REG_TXDMACTL0, &byOrgDMACtl);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(io_base + MAC_REG_TXDMACTL0+2, DMACTL_RUN);
+		iowrite8(DMACTL_RUN, io_base + MAC_REG_TXDMACTL0 + 2);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		if (!(ioread8(io_base + MAC_REG_TXDMACTL0) & DMACTL_RUN))
@@ -642,7 +642,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 
 	iowrite32(dwCurrDescAddr, io_base + MAC_REG_TXDMAPTR0);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(io_base + MAC_REG_TXDMACTL0, DMACTL_RUN);
+		iowrite8(DMACTL_RUN, io_base + MAC_REG_TXDMACTL0);
 }
 
 /*
@@ -669,7 +669,7 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 
 	VNSvInPortB(io_base + MAC_REG_AC0DMACTL, &byOrgDMACtl);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(io_base + MAC_REG_AC0DMACTL+2, DMACTL_RUN);
+		iowrite8(DMACTL_RUN, io_base + MAC_REG_AC0DMACTL + 2);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		if (!(ioread8(io_base + MAC_REG_AC0DMACTL) & DMACTL_RUN))
@@ -679,7 +679,7 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 		pr_debug(" DBG_PORT80(0x26)\n");
 	iowrite32(dwCurrDescAddr, io_base + MAC_REG_AC0DMAPTR);
 	if (byOrgDMACtl & DMACTL_RUN)
-		VNSvOutPortB(io_base + MAC_REG_AC0DMACTL, DMACTL_RUN);
+		iowrite8(DMACTL_RUN, io_base + MAC_REG_AC0DMACTL);
 }
 
 void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *priv,
@@ -711,20 +711,20 @@ void MACvTimer0MicroSDelay(struct vnt_private *priv, unsigned int uDelay)
 	unsigned char byValue;
 	unsigned int uu, ii;
 
-	VNSvOutPortB(io_base + MAC_REG_TMCTL0, 0);
+	iowrite8(0, io_base + MAC_REG_TMCTL0);
 	iowrite32(uDelay, io_base + MAC_REG_TMDATA0);
-	VNSvOutPortB(io_base + MAC_REG_TMCTL0, (TMCTL_TMD | TMCTL_TE));
+	iowrite8((TMCTL_TMD | TMCTL_TE), io_base + MAC_REG_TMCTL0);
 	for (ii = 0; ii < 66; ii++) {  /* assume max PCI clock is 66Mhz */
 		for (uu = 0; uu < uDelay; uu++) {
 			VNSvInPortB(io_base + MAC_REG_TMCTL0, &byValue);
 			if ((byValue == 0) ||
 			    (byValue & TMCTL_TSUSP)) {
-				VNSvOutPortB(io_base + MAC_REG_TMCTL0, 0);
+				iowrite8(0, io_base + MAC_REG_TMCTL0);
 				return;
 			}
 		}
 	}
-	VNSvOutPortB(io_base + MAC_REG_TMCTL0, 0);
+	iowrite8(0, io_base + MAC_REG_TMCTL0);
 }
 
 /*
@@ -745,9 +745,9 @@ void MACvOneShotTimer1MicroSec(struct vnt_private *priv, unsigned int uDelayTime
 {
 	void __iomem *io_base = priv->PortOffset;
 
-	VNSvOutPortB(io_base + MAC_REG_TMCTL1, 0);
+	iowrite8(0, io_base + MAC_REG_TMCTL1);
 	iowrite32(uDelayTime, io_base + MAC_REG_TMDATA1);
-	VNSvOutPortB(io_base + MAC_REG_TMCTL1, (TMCTL_TMD | TMCTL_TE));
+	iowrite8((TMCTL_TMD | TMCTL_TE), io_base + MAC_REG_TMCTL1);
 }
 
 void MACvSetMISCFifo(struct vnt_private *priv, unsigned short wOffset,
-- 
2.7.0

