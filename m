Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34809 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbcCFM5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:36 -0500
Received: by mail-wm0-f67.google.com with SMTP id p65so6295183wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:35 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/13] staging: vt6655: mac.c replace byOrgDMACtl with org_dma_ctl
Date: Sun,  6 Mar 2016 12:57:10 +0000
Message-Id: <1457269032-2681-11-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135749_715337_C17C14BC)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case and type prefix.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index d44026b..87bec1c 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -556,10 +556,10 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 curr_desc_addr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned char byOrgDMACtl;
+	unsigned char org_dma_ctl;
 
-	byOrgDMACtl = ioread8(io_base + MAC_REG_RXDMACTL0);
-	if (byOrgDMACtl & DMACTL_RUN)
+	org_dma_ctl = ioread8(io_base + MAC_REG_RXDMACTL0);
+	if (org_dma_ctl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL0 + 2);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
@@ -568,7 +568,7 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 curr_desc_addr)
 	}
 
 	iowrite32(curr_desc_addr, io_base + MAC_REG_RXDMAPTR0);
-	if (byOrgDMACtl & DMACTL_RUN)
+	if (org_dma_ctl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL0);
 }
 
@@ -590,10 +590,10 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 curr_desc_addr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned char byOrgDMACtl;
+	unsigned char org_dma_ctl;
 
-	byOrgDMACtl = ioread8(io_base + MAC_REG_RXDMACTL1);
-	if (byOrgDMACtl & DMACTL_RUN)
+	org_dma_ctl = ioread8(io_base + MAC_REG_RXDMACTL1);
+	if (org_dma_ctl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL1 + 2);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
@@ -602,7 +602,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 curr_desc_addr)
 	}
 
 	iowrite32(curr_desc_addr, io_base + MAC_REG_RXDMAPTR1);
-	if (byOrgDMACtl & DMACTL_RUN)
+	if (org_dma_ctl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL1);
 
 }
@@ -626,10 +626,10 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned char byOrgDMACtl;
+	unsigned char org_dma_ctl;
 
-	byOrgDMACtl = ioread8(io_base + MAC_REG_TXDMACTL0);
-	if (byOrgDMACtl & DMACTL_RUN)
+	org_dma_ctl = ioread8(io_base + MAC_REG_TXDMACTL0);
+	if (org_dma_ctl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_TXDMACTL0 + 2);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
@@ -638,7 +638,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 	}
 
 	iowrite32(curr_desc_addr, io_base + MAC_REG_TXDMAPTR0);
-	if (byOrgDMACtl & DMACTL_RUN)
+	if (org_dma_ctl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_TXDMACTL0);
 }
 
@@ -662,10 +662,10 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
-	unsigned char byOrgDMACtl;
+	unsigned char org_dma_ctl;
 
-	byOrgDMACtl = ioread8(io_base + MAC_REG_AC0DMACTL);
-	if (byOrgDMACtl & DMACTL_RUN)
+	org_dma_ctl = ioread8(io_base + MAC_REG_AC0DMACTL);
+	if (org_dma_ctl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_AC0DMACTL + 2);
 
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
@@ -675,7 +675,7 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 	if (ww == W_MAX_TIMEOUT)
 		pr_debug(" DBG_PORT80(0x26)\n");
 	iowrite32(curr_desc_addr, io_base + MAC_REG_AC0DMAPTR);
-	if (byOrgDMACtl & DMACTL_RUN)
+	if (org_dma_ctl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_AC0DMACTL);
 }
 
-- 
2.7.0

