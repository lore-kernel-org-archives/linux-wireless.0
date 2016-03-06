Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36727 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCFM53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:29 -0500
Received: by mail-wm0-f68.google.com with SMTP id l68so6276861wml.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:28 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/13] staging: vt6655: mac.c/h resize all unsigned long to u32
Date: Sun,  6 Mar 2016 12:57:02 +0000
Message-Id: <1457269032-2681-3-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135734_138386_122A9534)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All addressing is limited to 32 bits match this to all
functions and port out functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 22 +++++++++++-----------
 drivers/staging/vt6655/mac.h | 16 ++++++++--------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 02e3e42..c2723c1 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -264,17 +264,17 @@ void MACvRestoreContext(struct vnt_private *priv, unsigned char *cxt_buf)
 
 	/* restore CURR_RX_DESC_ADDR, CURR_TX_DESC_ADDR */
 	VNSvOutPortD(io_base + MAC_REG_TXDMAPTR0,
-		     *(unsigned long *)(cxt_buf + MAC_REG_TXDMAPTR0));
+		     *(u32 *)(cxt_buf + MAC_REG_TXDMAPTR0));
 	VNSvOutPortD(io_base + MAC_REG_AC0DMAPTR,
-		     *(unsigned long *)(cxt_buf + MAC_REG_AC0DMAPTR));
+		     *(u32 *)(cxt_buf + MAC_REG_AC0DMAPTR));
 	VNSvOutPortD(io_base + MAC_REG_BCNDMAPTR,
-		     *(unsigned long *)(cxt_buf + MAC_REG_BCNDMAPTR));
+		     *(u32 *)(cxt_buf + MAC_REG_BCNDMAPTR));
 
 	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR0,
-		     *(unsigned long *)(cxt_buf + MAC_REG_RXDMAPTR0));
+		     *(u32 *)(cxt_buf + MAC_REG_RXDMAPTR0));
 
 	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR1,
-		     *(unsigned long *)(cxt_buf + MAC_REG_RXDMAPTR1));
+		     *(u32 *)(cxt_buf + MAC_REG_RXDMAPTR1));
 }
 
 /*
@@ -557,7 +557,7 @@ void MACvInitialize(struct vnt_private *priv)
  * Return Value: none
  *
  */
-void MACvSetCurrRx0DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAddr)
+void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
@@ -591,7 +591,7 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
  * Return Value: none
  *
  */
-void MACvSetCurrRx1DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAddr)
+void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
@@ -627,7 +627,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, unsigned long dwCurrDescAd
  *
  */
 void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
-			      unsigned long dwCurrDescAddr)
+			      u32 dwCurrDescAddr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
@@ -663,7 +663,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
  */
 /* TxDMA1 = AC0DMA */
 void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
-			      unsigned long dwCurrDescAddr)
+			      u32 dwCurrDescAddr)
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short ww;
@@ -685,7 +685,7 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 }
 
 void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *priv,
-			   unsigned long dwCurrDescAddr)
+			   u32 dwCurrDescAddr)
 {
 	if (iTxType == TYPE_AC0DMA)
 		MACvSetCurrAC0DescAddrEx(priv, dwCurrDescAddr);
@@ -753,7 +753,7 @@ void MACvOneShotTimer1MicroSec(struct vnt_private *priv, unsigned int uDelayTime
 }
 
 void MACvSetMISCFifo(struct vnt_private *priv, unsigned short wOffset,
-		     unsigned long dwData)
+		     u32 dwData)
 {
 	void __iomem *io_base = priv->PortOffset;
 
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 192f466..3eef928 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -916,24 +916,24 @@ bool MACbSafeStop(struct vnt_private *);
 bool MACbShutdown(struct vnt_private *);
 void MACvInitialize(struct vnt_private *);
 void MACvSetCurrRx0DescAddr(struct vnt_private *,
-			    unsigned long dwCurrDescAddr);
+			    u32 dwCurrDescAddr);
 void MACvSetCurrRx1DescAddr(struct vnt_private *,
-			    unsigned long dwCurrDescAddr);
+			    u32 dwCurrDescAddr);
 void MACvSetCurrTXDescAddr(int iTxType, struct vnt_private *,
-			   unsigned long dwCurrDescAddr);
+			   u32 dwCurrDescAddr);
 void MACvSetCurrTx0DescAddrEx(struct vnt_private *,
-			      unsigned long dwCurrDescAddr);
+			      u32 dwCurrDescAddr);
 void MACvSetCurrAC0DescAddrEx(struct vnt_private *,
-			      unsigned long dwCurrDescAddr);
+			      u32 dwCurrDescAddr);
 void MACvSetCurrSyncDescAddrEx(struct vnt_private *,
-			       unsigned long dwCurrDescAddr);
+			       u32 dwCurrDescAddr);
 void MACvSetCurrATIMDescAddrEx(struct vnt_private *,
-			       unsigned long dwCurrDescAddr);
+			       u32 dwCurrDescAddr);
 void MACvTimer0MicroSDelay(struct vnt_private *, unsigned int uDelay);
 void MACvOneShotTimer1MicroSec(struct vnt_private *, unsigned int uDelayTime);
 
 void MACvSetMISCFifo(struct vnt_private *, unsigned short wOffset,
-		     unsigned long dwData);
+		     u32 dwData);
 
 bool MACbPSWakeup(struct vnt_private *);
 
-- 
2.7.0

