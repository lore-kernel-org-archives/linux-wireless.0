Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34809 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbcB1TDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 14:03:13 -0500
Received: by mail-wm0-f65.google.com with SMTP id p65so6613059wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 11:03:12 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/4] staging: vt6655: replace VNSvInPortD dwData reads with ioread32
Date: Sun, 28 Feb 2016 19:02:56 +0000
Message-Id: <1456686177-3167-3-git-send-email-tvboxspy@gmail.com> (sfid-20160228_200320_109911_BFCC6FFF)
In-Reply-To: <1456686177-3167-1-git-send-email-tvboxspy@gmail.com>
References: <1456686177-3167-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing dwData variable altogether.

The reads are always 32 bit insize.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 893fc52..c935922 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -117,10 +117,8 @@ bool MACbIsRegBitsOff(struct vnt_private *priv, unsigned char byRegOfs,
 bool MACbIsIntDisable(struct vnt_private *priv)
 {
 	void __iomem *io_base = priv->PortOffset;
-	unsigned long dwData;
 
-	VNSvInPortD(io_base + MAC_REG_IMR, &dwData);
-	if (dwData != 0)
+	if (ioread32(io_base + MAC_REG_IMR))
 		return false;
 
 	return true;
@@ -363,7 +361,6 @@ bool MACbSafeRxOff(struct vnt_private *priv)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned long dwData;
 
 	/* turn off wow temp for turn off Rx safely */
 
@@ -371,8 +368,7 @@ bool MACbSafeRxOff(struct vnt_private *priv)
 	VNSvOutPortD(io_base + MAC_REG_RXDMACTL0, DMACTL_CLRRUN);
 	VNSvOutPortD(io_base + MAC_REG_RXDMACTL1, DMACTL_CLRRUN);
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(io_base + MAC_REG_RXDMACTL0, &dwData);
-		if (!(dwData & DMACTL_RUN))
+		if (!(ioread32(io_base + MAC_REG_RXDMACTL0) & DMACTL_RUN))
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
@@ -380,8 +376,7 @@ bool MACbSafeRxOff(struct vnt_private *priv)
 		return false;
 	}
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(io_base + MAC_REG_RXDMACTL1, &dwData);
-		if (!(dwData & DMACTL_RUN))
+		if (!(ioread32(io_base + MAC_REG_RXDMACTL1) & DMACTL_RUN))
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
@@ -420,7 +415,6 @@ bool MACbSafeTxOff(struct vnt_private *priv)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned long dwData;
 
 	/* Clear TX DMA */
 	/* Tx0 */
@@ -429,8 +423,7 @@ bool MACbSafeTxOff(struct vnt_private *priv)
 	VNSvOutPortD(io_base + MAC_REG_AC0DMACTL, DMACTL_CLRRUN);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(io_base + MAC_REG_TXDMACTL0, &dwData);
-		if (!(dwData & DMACTL_RUN))
+		if (!(ioread32(io_base + MAC_REG_TXDMACTL0) & DMACTL_RUN))
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
@@ -438,8 +431,7 @@ bool MACbSafeTxOff(struct vnt_private *priv)
 		return false;
 	}
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortD(io_base + MAC_REG_AC0DMACTL, &dwData);
-		if (!(dwData & DMACTL_RUN))
+		if (!(ioread32(io_base + MAC_REG_AC0DMACTL) & DMACTL_RUN))
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-- 
2.7.0

