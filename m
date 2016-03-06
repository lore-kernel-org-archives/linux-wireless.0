Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34747 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCFM50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:26 -0500
Received: by mail-wm0-f65.google.com with SMTP id p65so6294869wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:26 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/13] staging: vt6655: mac.c rename pbyCxtBuf to cxt_buf
Date: Sun,  6 Mar 2016 12:57:00 +0000
Message-Id: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135730_782083_D3DA89C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case and type prefix.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
Following on from patch
MACvSaveContext use memcpy_fromio to read context.

 drivers/staging/vt6655/mac.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 66ae991..9c4dabd 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -202,22 +202,22 @@ void MACvSetLoopbackMode(struct vnt_private *priv, unsigned char byLoopbackMode)
  *  In:
  *      io_base    - Base Address for MAC
  *  Out:
- *      pbyCxtBuf   - Context buffer
+ *      cxt_buf   - Context buffer
  *
  * Return Value: none
  *
  */
-void MACvSaveContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
+void MACvSaveContext(struct vnt_private *priv, unsigned char *cxt_buf)
 {
 	void __iomem *io_base = priv->PortOffset;
 
 	/* read page0 register */
-	memcpy_fromio(pbyCxtBuf, io_base, MAC_MAX_CONTEXT_SIZE_PAGE0);
+	memcpy_fromio(cxt_buf, io_base, MAC_MAX_CONTEXT_SIZE_PAGE0);
 
 	MACvSelectPage1(io_base);
 
 	/* read page1 register */
-	memcpy_fromio(pbyCxtBuf + MAC_MAX_CONTEXT_SIZE_PAGE0, io_base,
+	memcpy_fromio(cxt_buf + MAC_MAX_CONTEXT_SIZE_PAGE0, io_base,
 		      MAC_MAX_CONTEXT_SIZE_PAGE1);
 
 	MACvSelectPage0(io_base);
@@ -230,14 +230,14 @@ void MACvSaveContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
  * Parameters:
  *  In:
  *      io_base    - Base Address for MAC
- *      pbyCxtBuf   - Context buffer
+ *      cxt_buf   - Context buffer
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void MACvRestoreContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
+void MACvRestoreContext(struct vnt_private *priv, unsigned char *cxt_buf)
 {
 	void __iomem *io_base = priv->PortOffset;
 	int         ii;
@@ -246,37 +246,37 @@ void MACvRestoreContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
 	/* restore page1 */
 	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++)
 		VNSvOutPortB((io_base + ii),
-			     *(pbyCxtBuf + MAC_MAX_CONTEXT_SIZE_PAGE0 + ii));
+			     *(cxt_buf + MAC_MAX_CONTEXT_SIZE_PAGE0 + ii));
 
 	MACvSelectPage0(io_base);
 
 	/* restore RCR,TCR,IMR... */
 	for (ii = MAC_REG_RCR; ii < MAC_REG_ISR; ii++)
-		VNSvOutPortB(io_base + ii, *(pbyCxtBuf + ii));
+		VNSvOutPortB(io_base + ii, *(cxt_buf + ii));
 
 	/* restore MAC Config. */
 	for (ii = MAC_REG_LRT; ii < MAC_REG_PAGE1SEL; ii++)
-		VNSvOutPortB(io_base + ii, *(pbyCxtBuf + ii));
+		VNSvOutPortB(io_base + ii, *(cxt_buf + ii));
 
-	VNSvOutPortB(io_base + MAC_REG_CFG, *(pbyCxtBuf + MAC_REG_CFG));
+	VNSvOutPortB(io_base + MAC_REG_CFG, *(cxt_buf + MAC_REG_CFG));
 
 	/* restore PS Config. */
 	for (ii = MAC_REG_PSCFG; ii < MAC_REG_BBREGCTL; ii++)
-		VNSvOutPortB(io_base + ii, *(pbyCxtBuf + ii));
+		VNSvOutPortB(io_base + ii, *(cxt_buf + ii));
 
 	/* restore CURR_RX_DESC_ADDR, CURR_TX_DESC_ADDR */
 	VNSvOutPortD(io_base + MAC_REG_TXDMAPTR0,
-		     *(unsigned long *)(pbyCxtBuf + MAC_REG_TXDMAPTR0));
+		     *(unsigned long *)(cxt_buf + MAC_REG_TXDMAPTR0));
 	VNSvOutPortD(io_base + MAC_REG_AC0DMAPTR,
-		     *(unsigned long *)(pbyCxtBuf + MAC_REG_AC0DMAPTR));
+		     *(unsigned long *)(cxt_buf + MAC_REG_AC0DMAPTR));
 	VNSvOutPortD(io_base + MAC_REG_BCNDMAPTR,
-		     *(unsigned long *)(pbyCxtBuf + MAC_REG_BCNDMAPTR));
+		     *(unsigned long *)(cxt_buf + MAC_REG_BCNDMAPTR));
 
 	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR0,
-		     *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR0));
+		     *(unsigned long *)(cxt_buf + MAC_REG_RXDMAPTR0));
 
 	VNSvOutPortD(io_base + MAC_REG_RXDMAPTR1,
-		     *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR1));
+		     *(unsigned long *)(cxt_buf + MAC_REG_RXDMAPTR1));
 }
 
 /*
-- 
2.7.0

