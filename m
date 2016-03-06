Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33797 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbcCFM5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:37 -0500
Received: by mail-wm0-f65.google.com with SMTP id p65so6295280wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:37 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/13] staging: vt6655: mac.c replace wOffset with offset.
Date: Sun,  6 Mar 2016 12:57:11 +0000
Message-Id: <1457269032-2681-12-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135949_643906_324E80D0)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case and type prefix.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 87bec1c..e762c33 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -747,14 +747,14 @@ void MACvOneShotTimer1MicroSec(struct vnt_private *priv, unsigned int uDelayTime
 	iowrite8((TMCTL_TMD | TMCTL_TE), io_base + MAC_REG_TMCTL1);
 }
 
-void MACvSetMISCFifo(struct vnt_private *priv, unsigned short wOffset,
+void MACvSetMISCFifo(struct vnt_private *priv, unsigned short offset,
 		     u32 dwData)
 {
 	void __iomem *io_base = priv->PortOffset;
 
-	if (wOffset > 273)
+	if (offset > 273)
 		return;
-	iowrite16(wOffset, io_base + MAC_REG_MISCFFNDEX);
+	iowrite16(offset, io_base + MAC_REG_MISCFFNDEX);
 	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
 	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 }
@@ -803,7 +803,7 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 		     unsigned char byLocalID)
 {
 	void __iomem *io_base = priv->PortOffset;
-	unsigned short wOffset;
+	unsigned short offset;
 	u32 dwData;
 	int     ii;
 
@@ -811,20 +811,20 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 		return;
 
 	pr_debug("MACvSetKeyEntry\n");
-	wOffset = MISCFIFO_KEYETRY0;
-	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
+	offset = MISCFIFO_KEYETRY0;
+	offset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
 	dwData = 0;
 	dwData |= wKeyCtl;
 	dwData <<= 16;
 	dwData |= MAKEWORD(*(pbyAddr+4), *(pbyAddr+5));
-	pr_debug("1. wOffset: %d, Data: %X, KeyCtl:%X\n",
-		 wOffset, dwData, wKeyCtl);
+	pr_debug("1. offset: %d, Data: %X, KeyCtl:%X\n",
+		 offset, dwData, wKeyCtl);
 
-	iowrite16(wOffset, io_base + MAC_REG_MISCFFNDEX);
+	iowrite16(offset, io_base + MAC_REG_MISCFFNDEX);
 	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
 	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
-	wOffset++;
+	offset++;
 
 	dwData = 0;
 	dwData |= *(pbyAddr+3);
@@ -834,19 +834,19 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 	dwData |= *(pbyAddr+1);
 	dwData <<= 8;
 	dwData |= *(pbyAddr+0);
-	pr_debug("2. wOffset: %d, Data: %X\n", wOffset, dwData);
+	pr_debug("2. offset: %d, Data: %X\n", offset, dwData);
 
-	iowrite16(wOffset, io_base + MAC_REG_MISCFFNDEX);
+	iowrite16(offset, io_base + MAC_REG_MISCFFNDEX);
 	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
 	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
-	wOffset++;
+	offset++;
 
-	wOffset += (uKeyIdx * 4);
+	offset += (uKeyIdx * 4);
 	for (ii = 0; ii < 4; ii++) {
 		/* always push 128 bits */
-		pr_debug("3.(%d) wOffset: %d, Data: %X\n",
-			 ii, wOffset+ii, *pdwKey);
-		iowrite16(wOffset + ii, io_base + MAC_REG_MISCFFNDEX);
+		pr_debug("3.(%d) offset: %d, Data: %X\n",
+			 ii, offset + ii, *pdwKey);
+		iowrite16(offset + ii, io_base + MAC_REG_MISCFFNDEX);
 		iowrite32(*pdwKey++, io_base + MAC_REG_MISCFFDATA);
 		iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 	}
@@ -869,12 +869,12 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 void MACvDisableKeyEntry(struct vnt_private *priv, unsigned int uEntryIdx)
 {
 	void __iomem *io_base = priv->PortOffset;
-	unsigned short wOffset;
+	unsigned short offset;
 
-	wOffset = MISCFIFO_KEYETRY0;
-	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
+	offset = MISCFIFO_KEYETRY0;
+	offset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
-	iowrite16(wOffset, io_base + MAC_REG_MISCFFNDEX);
+	iowrite16(offset, io_base + MAC_REG_MISCFFNDEX);
 	iowrite32(0, io_base + MAC_REG_MISCFFDATA);
 	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 }
-- 
2.7.0

