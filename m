Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34803 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbcCFM5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:35 -0500
Received: by mail-wm0-f65.google.com with SMTP id p65so6295163wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:34 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/13] staging: vt6655: mac Replace dwCurrDescAddr with curr_desc_addr.
Date: Sun,  6 Mar 2016 12:57:09 +0000
Message-Id: <1457269032-2681-10-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135748_388334_15F34BD5)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case and type prefix.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 30 +++++++++++++++---------------
 drivers/staging/vt6655/mac.h | 14 +++++++-------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index a1be62d..d44026b 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -545,14 +545,14 @@ void MACvInitialize(struct vnt_private *priv)
  * Parameters:
  *  In:
  *      io_base        - Base Address for MAC
- *      dwCurrDescAddr  - Descriptor Address
+ *      curr_desc_addr  - Descriptor Address
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
+void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 curr_desc_addr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
@@ -567,7 +567,7 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 			break;
 	}
 
-	iowrite32(dwCurrDescAddr, io_base + MAC_REG_RXDMAPTR0);
+	iowrite32(curr_desc_addr, io_base + MAC_REG_RXDMAPTR0);
 	if (byOrgDMACtl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL0);
 }
@@ -579,14 +579,14 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
  * Parameters:
  *  In:
  *      io_base        - Base Address for MAC
- *      dwCurrDescAddr  - Descriptor Address
+ *      curr_desc_addr  - Descriptor Address
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
+void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 curr_desc_addr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
@@ -601,7 +601,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 			break;
 	}
 
-	iowrite32(dwCurrDescAddr, io_base + MAC_REG_RXDMAPTR1);
+	iowrite32(curr_desc_addr, io_base + MAC_REG_RXDMAPTR1);
 	if (byOrgDMACtl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL1);
 
@@ -614,7 +614,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
  * Parameters:
  *  In:
  *      io_base        - Base Address for MAC
- *      dwCurrDescAddr  - Descriptor Address
+ *      curr_desc_addr  - Descriptor Address
  *  Out:
  *      none
  *
@@ -622,7 +622,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
  *
  */
 void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
-			      u32 dwCurrDescAddr)
+			      u32 curr_desc_addr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
@@ -637,7 +637,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 			break;
 	}
 
-	iowrite32(dwCurrDescAddr, io_base + MAC_REG_TXDMAPTR0);
+	iowrite32(curr_desc_addr, io_base + MAC_REG_TXDMAPTR0);
 	if (byOrgDMACtl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_TXDMACTL0);
 }
@@ -649,7 +649,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
  * Parameters:
  *  In:
  *      io_base        - Base Address for MAC
- *      dwCurrDescAddr  - Descriptor Address
+ *      curr_desc_addr  - Descriptor Address
  *  Out:
  *      none
  *
@@ -658,7 +658,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
  */
 /* TxDMA1 = AC0DMA */
 void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
-			      u32 dwCurrDescAddr)
+			      u32 curr_desc_addr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
@@ -674,18 +674,18 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 	}
 	if (ww == W_MAX_TIMEOUT)
 		pr_debug(" DBG_PORT80(0x26)\n");
-	iowrite32(dwCurrDescAddr, io_base + MAC_REG_AC0DMAPTR);
+	iowrite32(curr_desc_addr, io_base + MAC_REG_AC0DMAPTR);
 	if (byOrgDMACtl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_AC0DMACTL);
 }
 
 void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *priv,
-			   u32 dwCurrDescAddr)
+			   u32 curr_desc_addr)
 {
 	if (iTxType == TYPE_AC0DMA)
-		MACvSetCurrAC0DescAddrEx(priv, dwCurrDescAddr);
+		MACvSetCurrAC0DescAddrEx(priv, curr_desc_addr);
 	else if (iTxType == TYPE_TXDMA0)
-		MACvSetCurrTx0DescAddrEx(priv, dwCurrDescAddr);
+		MACvSetCurrTx0DescAddrEx(priv, curr_desc_addr);
 }
 
 /*
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 3eef928..030f529 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -916,19 +916,19 @@ bool MACbSafeStop(struct vnt_private *);
 bool MACbShutdown(struct vnt_private *);
 void MACvInitialize(struct vnt_private *);
 void MACvSetCurrRx0DescAddr(struct vnt_private *,
-			    u32 dwCurrDescAddr);
+			    u32 curr_desc_addr);
 void MACvSetCurrRx1DescAddr(struct vnt_private *,
-			    u32 dwCurrDescAddr);
+			    u32 curr_desc_addr);
 void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *,
-			   u32 dwCurrDescAddr);
+			   u32 curr_desc_addr);
 void MACvSetCurrTx0DescAddrEx(struct vnt_private *,
-			      u32 dwCurrDescAddr);
+			      u32 curr_desc_addr);
 void MACvSetCurrAC0DescAddrEx(struct vnt_private *,
-			      u32 dwCurrDescAddr);
+			      u32 curr_desc_addr);
 void MACvSetCurrSyncDescAddrEx(struct vnt_private *,
-			       u32 dwCurrDescAddr);
+			       u32 curr_desc_addr);
 void MACvSetCurrATIMDescAddrEx(struct vnt_private *,
-			       u32 dwCurrDescAddr);
+			       u32 curr_desc_addr);
 void MACvTimer0MicroSDelay(struct vnt_private *, unsigned int uDelay);
 void MACvOneShotTimer1MicroSec(struct vnt_private *, unsigned int uDelayTime);
 
-- 
2.7.0

