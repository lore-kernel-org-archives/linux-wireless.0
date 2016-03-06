Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32809 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbcCFM53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:29 -0500
Received: by mail-wm0-f67.google.com with SMTP id n186so6302450wmn.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:28 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/13] staging: vt6655: mac.c replace VNSvOutPortD with iowrite32.
Date: Sun,  6 Mar 2016 12:57:03 +0000
Message-Id: <1457269032-2681-4-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135736_196195_D6692242)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing the macro from functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 52 +++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index c2723c1..a9ddb95 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -263,18 +263,16 @@ void MACvRestoreContext(struct vnt_private *priv, unsigned char *cxt_buf)
 		    MAC_REG_BBREGCTL - MAC_REG_PSCFG);
 
 	/* restore CURR_RX_DESC_ADDR, CURR_TX_DESC_ADDR */
-	VNSvOutPortD(io_base + MAC_REG_TXDMAPTR0,
-		     *(u32 *)(cxt_buf + MAC_REG_TXDMAPTR0));
-	VNSvOutPortD(io_base + MAC_REG_AC0DMAPTR,
-		     *(u32 *)(cxt_buf + MAC_REG_AC0DMAPTR));
-	VNSvOutPortD(io_base + MAC_REG_BCNDMAPTR,
-		     *(u32 *)(cxt_buf + MAC_REG_BCNDMAPTR));
-
-	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR0,
-		     *(u32 *)(cxt_buf + MAC_REG_RXDMAPTR0));
-
-	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR1,
-		     *(u32 *)(cxt_buf + MAC_REG_RXDMAPTR1));
+	iowrite32(*(u32 *)(cxt_buf + MAC_REG_TXDMAPTR0),
+		  io_base + MAC_REG_TXDMAPTR0);
+	iowrite32(*(u32 *)(cxt_buf + MAC_REG_AC0DMAPTR),
+		  io_base + MAC_REG_AC0DMAPTR);
+	iowrite32(*(u32 *)(cxt_buf + MAC_REG_BCNDMAPTR),
+		  io_base + MAC_REG_BCNDMAPTR);
+	iowrite32(*(u32 *)(cxt_buf + MAC_REG_RXDMAPTR0),
+		  io_base + MAC_REG_RXDMAPTR0);
+	iowrite32(*(u32 *)(cxt_buf + MAC_REG_RXDMAPTR1),
+		  io_base + MAC_REG_RXDMAPTR1);
 }
 
 /*
@@ -360,8 +358,8 @@ bool MACbSafeRxOff(struct vnt_private *priv)
 	/* turn off wow temp for turn off Rx safely */
 
 	/* Clear RX DMA0,1 */
-	VNSvOutPortD(io_base + MAC_REG_RXDMACTL0, DMACTL_CLRRUN);
-	VNSvOutPortD(io_base + MAC_REG_RXDMACTL1, DMACTL_CLRRUN);
+	iowrite32(DMACTL_CLRRUN, io_base + MAC_REG_RXDMACTL0);
+	iowrite32(DMACTL_CLRRUN, io_base + MAC_REG_RXDMACTL1);
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		if (!(ioread32(io_base + MAC_REG_RXDMACTL0) & DMACTL_RUN))
 			break;
@@ -413,9 +411,9 @@ bool MACbSafeTxOff(struct vnt_private *priv)
 
 	/* Clear TX DMA */
 	/* Tx0 */
-	VNSvOutPortD(io_base + MAC_REG_TXDMACTL0, DMACTL_CLRRUN);
+	iowrite32(DMACTL_CLRRUN, io_base + MAC_REG_TXDMACTL0);
 	/* AC0 */
-	VNSvOutPortD(io_base + MAC_REG_AC0DMACTL, DMACTL_CLRRUN);
+	iowrite32(DMACTL_CLRRUN, io_base + MAC_REG_AC0DMACTL);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		if (!(ioread32(io_base + MAC_REG_TXDMACTL0) & DMACTL_RUN))
@@ -572,7 +570,7 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 			break;
 	}
 
-	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR0, dwCurrDescAddr);
+	iowrite32(dwCurrDescAddr, io_base + MAC_REG_RXDMAPTR0);
 	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(io_base + MAC_REG_RXDMACTL0, DMACTL_RUN);
 }
@@ -606,7 +604,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 			break;
 	}
 
-	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR1, dwCurrDescAddr);
+	iowrite32(dwCurrDescAddr, io_base + MAC_REG_RXDMAPTR1);
 	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(io_base + MAC_REG_RXDMACTL1, DMACTL_RUN);
 
@@ -642,7 +640,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 			break;
 	}
 
-	VNSvOutPortD(io_base + MAC_REG_TXDMAPTR0, dwCurrDescAddr);
+	iowrite32(dwCurrDescAddr, io_base + MAC_REG_TXDMAPTR0);
 	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(io_base + MAC_REG_TXDMACTL0, DMACTL_RUN);
 }
@@ -679,7 +677,7 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 	}
 	if (ww == W_MAX_TIMEOUT)
 		pr_debug(" DBG_PORT80(0x26)\n");
-	VNSvOutPortD(io_base + MAC_REG_AC0DMAPTR, dwCurrDescAddr);
+	iowrite32(dwCurrDescAddr, io_base + MAC_REG_AC0DMAPTR);
 	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(io_base + MAC_REG_AC0DMACTL, DMACTL_RUN);
 }
@@ -714,7 +712,7 @@ void MACvTimer0MicroSDelay(struct vnt_private *priv, unsigned int uDelay)
 	unsigned int uu, ii;
 
 	VNSvOutPortB(io_base + MAC_REG_TMCTL0, 0);
-	VNSvOutPortD(io_base + MAC_REG_TMDATA0, uDelay);
+	iowrite32(uDelay, io_base + MAC_REG_TMDATA0);
 	VNSvOutPortB(io_base + MAC_REG_TMCTL0, (TMCTL_TMD | TMCTL_TE));
 	for (ii = 0; ii < 66; ii++) {  /* assume max PCI clock is 66Mhz */
 		for (uu = 0; uu < uDelay; uu++) {
@@ -748,7 +746,7 @@ void MACvOneShotTimer1MicroSec(struct vnt_private *priv, unsigned int uDelayTime
 	void __iomem *io_base = priv->PortOffset;
 
 	VNSvOutPortB(io_base + MAC_REG_TMCTL1, 0);
-	VNSvOutPortD(io_base + MAC_REG_TMDATA1, uDelayTime);
+	iowrite32(uDelayTime, io_base + MAC_REG_TMDATA1);
 	VNSvOutPortB(io_base + MAC_REG_TMCTL1, (TMCTL_TMD | TMCTL_TE));
 }
 
@@ -760,7 +758,7 @@ void MACvSetMISCFifo(struct vnt_private *priv, unsigned short wOffset,
 	if (wOffset > 273)
 		return;
 	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, dwData);
+	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
 	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 }
 
@@ -829,7 +827,7 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 		 wOffset, dwData, wKeyCtl);
 
 	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, dwData);
+	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
 	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 	wOffset++;
 
@@ -844,7 +842,7 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 	pr_debug("2. wOffset: %d, Data: %X\n", wOffset, dwData);
 
 	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, dwData);
+	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
 	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 	wOffset++;
 
@@ -854,7 +852,7 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 		pr_debug("3.(%d) wOffset: %d, Data: %X\n",
 			 ii, wOffset+ii, *pdwKey);
 		VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset+ii);
-		VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, *pdwKey++);
+		iowrite32(*pdwKey++, io_base + MAC_REG_MISCFFDATA);
 		VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 	}
 }
@@ -882,6 +880,6 @@ void MACvDisableKeyEntry(struct vnt_private *priv, unsigned int uEntryIdx)
 	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
 	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
-	VNSvOutPortD(io_base + MAC_REG_MISCFFDATA, 0);
+	iowrite32(0, io_base + MAC_REG_MISCFFDATA);
 	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 }
-- 
2.7.0

