Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35477 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbcB1TDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 14:03:12 -0500
Received: by mail-wm0-f66.google.com with SMTP id 1so1583343wmg.2
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 11:03:11 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4] staging: vt6655: mac.c Replace VNSvInPortB byData reads with ioread8.
Date: Sun, 28 Feb 2016 19:02:55 +0000
Message-Id: <1456686177-3167-2-git-send-email-tvboxspy@gmail.com> (sfid-20160228_200317_305307_E319E8AE)
In-Reply-To: <1456686177-3167-1-git-send-email-tvboxspy@gmail.com>
References: <1456686177-3167-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing byData variable altogether.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 5a4fc3b..893fc52 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -74,10 +74,8 @@ bool MACbIsRegBitsOn(struct vnt_private *priv, unsigned char byRegOfs,
 		     unsigned char byTestBits)
 {
 	void __iomem *io_base = priv->PortOffset;
-	unsigned char byData;
 
-	VNSvInPortB(io_base + byRegOfs, &byData);
-	return (byData & byTestBits) == byTestBits;
+	return (ioread8(io_base + byRegOfs) & byTestBits) == byTestBits;
 }
 
 /*
@@ -99,10 +97,8 @@ bool MACbIsRegBitsOff(struct vnt_private *priv, unsigned char byRegOfs,
 		      unsigned char byTestBits)
 {
 	void __iomem *io_base = priv->PortOffset;
-	unsigned char byData;
 
-	VNSvInPortB(io_base + byRegOfs, &byData);
-	return !(byData & byTestBits);
+	return !(ioread8(io_base + byRegOfs) & byTestBits);
 }
 
 /*
@@ -304,15 +300,13 @@ void MACvRestoreContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
 bool MACbSoftwareReset(struct vnt_private *priv)
 {
 	void __iomem *io_base = priv->PortOffset;
-	unsigned char byData;
 	unsigned short ww;
 
 	/* turn on HOSTCR_SOFTRST, just write 0x01 to reset */
 	VNSvOutPortB(io_base + MAC_REG_HOSTCR, 0x01);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(io_base + MAC_REG_HOSTCR, &byData);
-		if (!(byData & HOSTCR_SOFTRST))
+		if (!(ioread8(io_base + MAC_REG_HOSTCR) & HOSTCR_SOFTRST))
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT)
@@ -370,7 +364,6 @@ bool MACbSafeRxOff(struct vnt_private *priv)
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
 	unsigned long dwData;
-	unsigned char byData;
 
 	/* turn off wow temp for turn off Rx safely */
 
@@ -400,8 +393,7 @@ bool MACbSafeRxOff(struct vnt_private *priv)
 	MACvRegBitsOff(io_base, MAC_REG_HOSTCR, HOSTCR_RXON);
 	/* W_MAX_TIMEOUT is the timeout period */
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(io_base + MAC_REG_HOSTCR, &byData);
-		if (!(byData & HOSTCR_RXONST))
+		if (!(ioread8(io_base + MAC_REG_HOSTCR) & HOSTCR_RXONST))
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
@@ -429,7 +421,6 @@ bool MACbSafeTxOff(struct vnt_private *priv)
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
 	unsigned long dwData;
-	unsigned char byData;
 
 	/* Clear TX DMA */
 	/* Tx0 */
@@ -461,8 +452,7 @@ bool MACbSafeTxOff(struct vnt_private *priv)
 
 	/* W_MAX_TIMEOUT is the timeout period */
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(io_base + MAC_REG_HOSTCR, &byData);
-		if (!(byData & HOSTCR_TXONST))
+		if (!(ioread8(io_base + MAC_REG_HOSTCR) & HOSTCR_TXONST))
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
@@ -584,7 +574,6 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned char byData;
 	unsigned char byOrgDMACtl;
 
 	VNSvInPortB(io_base + MAC_REG_RXDMACTL0, &byOrgDMACtl);
@@ -592,8 +581,7 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
 		VNSvOutPortB(io_base + MAC_REG_RXDMACTL0+2, DMACTL_RUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(io_base + MAC_REG_RXDMACTL0, &byData);
-		if (!(byData & DMACTL_RUN))
+		if (!(ioread8(io_base + MAC_REG_RXDMACTL0) & DMACTL_RUN))
 			break;
 	}
 
@@ -620,7 +608,6 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned char byData;
 	unsigned char byOrgDMACtl;
 
 	VNSvInPortB(io_base + MAC_REG_RXDMACTL1, &byOrgDMACtl);
@@ -628,8 +615,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
 		VNSvOutPortB(io_base + MAC_REG_RXDMACTL1+2, DMACTL_RUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(io_base + MAC_REG_RXDMACTL1, &byData);
-		if (!(byData & DMACTL_RUN))
+		if (!(ioread8(io_base + MAC_REG_RXDMACTL1) & DMACTL_RUN))
 			break;
 	}
 
@@ -658,7 +644,6 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned char byData;
 	unsigned char byOrgDMACtl;
 
 	VNSvInPortB(io_base + MAC_REG_TXDMACTL0, &byOrgDMACtl);
@@ -666,8 +651,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 		VNSvOutPortB(io_base + MAC_REG_TXDMACTL0+2, DMACTL_RUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(io_base + MAC_REG_TXDMACTL0, &byData);
-		if (!(byData & DMACTL_RUN))
+		if (!(ioread8(io_base + MAC_REG_TXDMACTL0) & DMACTL_RUN))
 			break;
 	}
 
@@ -696,7 +680,6 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned char byData;
 	unsigned char byOrgDMACtl;
 
 	VNSvInPortB(io_base + MAC_REG_AC0DMACTL, &byOrgDMACtl);
@@ -704,8 +687,7 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 		VNSvOutPortB(io_base + MAC_REG_AC0DMACTL+2, DMACTL_RUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(io_base + MAC_REG_AC0DMACTL, &byData);
-		if (!(byData & DMACTL_RUN))
+		if (!(ioread8(io_base + MAC_REG_AC0DMACTL) & DMACTL_RUN))
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT)
-- 
2.7.0

