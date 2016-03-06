Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35791 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbcCFM51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:27 -0500
Received: by mail-wm0-f67.google.com with SMTP id 1so6277264wmg.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:27 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/13] staging: vt6655: MACvRestoreContext replace for loops with memcpy_toio.
Date: Sun,  6 Mar 2016 12:57:01 +0000
Message-Id: <1457269032-2681-2-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135733_078674_4F0681D9)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing the need for variable ii.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 9c4dabd..02e3e42 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -240,29 +240,27 @@ void MACvSaveContext(struct vnt_private *priv, unsigned char *cxt_buf)
 void MACvRestoreContext(struct vnt_private *priv, unsigned char *cxt_buf)
 {
 	void __iomem *io_base = priv->PortOffset;
-	int         ii;
 
 	MACvSelectPage1(io_base);
 	/* restore page1 */
-	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++)
-		VNSvOutPortB((io_base + ii),
-			     *(cxt_buf + MAC_MAX_CONTEXT_SIZE_PAGE0 + ii));
+	memcpy_toio(io_base, cxt_buf + MAC_MAX_CONTEXT_SIZE_PAGE0,
+		    MAC_MAX_CONTEXT_SIZE_PAGE1);
 
 	MACvSelectPage0(io_base);
 
 	/* restore RCR,TCR,IMR... */
-	for (ii = MAC_REG_RCR; ii < MAC_REG_ISR; ii++)
-		VNSvOutPortB(io_base + ii, *(cxt_buf + ii));
+	memcpy_toio(io_base + MAC_REG_RCR, cxt_buf + MAC_REG_RCR,
+		    MAC_REG_ISR - MAC_REG_RCR);
 
 	/* restore MAC Config. */
-	for (ii = MAC_REG_LRT; ii < MAC_REG_PAGE1SEL; ii++)
-		VNSvOutPortB(io_base + ii, *(cxt_buf + ii));
+	memcpy_toio(io_base + MAC_REG_LRT, cxt_buf + MAC_REG_LRT,
+		    MAC_REG_PAGE1SEL - MAC_REG_LRT);
 
 	VNSvOutPortB(io_base + MAC_REG_CFG, *(cxt_buf + MAC_REG_CFG));
 
 	/* restore PS Config. */
-	for (ii = MAC_REG_PSCFG; ii < MAC_REG_BBREGCTL; ii++)
-		VNSvOutPortB(io_base + ii, *(cxt_buf + ii));
+	memcpy_toio(io_base + MAC_REG_PSCFG, cxt_buf + MAC_REG_PSCFG,
+		    MAC_REG_BBREGCTL - MAC_REG_PSCFG);
 
 	/* restore CURR_RX_DESC_ADDR, CURR_TX_DESC_ADDR */
 	VNSvOutPortD(io_base + MAC_REG_TXDMAPTR0,
-- 
2.7.0

