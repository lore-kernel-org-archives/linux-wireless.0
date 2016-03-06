Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34845 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbcCFM5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:38 -0500
Received: by mail-wm0-f67.google.com with SMTP id 1so6277650wmg.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:37 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/13] staging: vt6655: mac.c replace dwData with data.
Date: Sun,  6 Mar 2016 12:57:12 +0000
Message-Id: <1457269032-2681-13-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135949_838874_936AAB7B)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case and type prefix.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index e762c33..45196c6 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -748,14 +748,14 @@ void MACvOneShotTimer1MicroSec(struct vnt_private *priv, unsigned int uDelayTime
 }
 
 void MACvSetMISCFifo(struct vnt_private *priv, unsigned short offset,
-		     u32 dwData)
+		     u32 data)
 {
 	void __iomem *io_base = priv->PortOffset;
 
 	if (offset > 273)
 		return;
 	iowrite16(offset, io_base + MAC_REG_MISCFFNDEX);
-	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
+	iowrite32(data, io_base + MAC_REG_MISCFFDATA);
 	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 }
 
@@ -804,7 +804,7 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 {
 	void __iomem *io_base = priv->PortOffset;
 	unsigned short offset;
-	u32 dwData;
+	u32 data;
 	int     ii;
 
 	if (byLocalID <= 1)
@@ -814,30 +814,30 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 	offset = MISCFIFO_KEYETRY0;
 	offset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
-	dwData = 0;
-	dwData |= wKeyCtl;
-	dwData <<= 16;
-	dwData |= MAKEWORD(*(pbyAddr+4), *(pbyAddr+5));
+	data = 0;
+	data |= wKeyCtl;
+	data <<= 16;
+	data |= MAKEWORD(*(pbyAddr + 4), *(pbyAddr + 5));
 	pr_debug("1. offset: %d, Data: %X, KeyCtl:%X\n",
-		 offset, dwData, wKeyCtl);
+		 offset, data, wKeyCtl);
 
 	iowrite16(offset, io_base + MAC_REG_MISCFFNDEX);
-	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
+	iowrite32(data, io_base + MAC_REG_MISCFFDATA);
 	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 	offset++;
 
-	dwData = 0;
-	dwData |= *(pbyAddr+3);
-	dwData <<= 8;
-	dwData |= *(pbyAddr+2);
-	dwData <<= 8;
-	dwData |= *(pbyAddr+1);
-	dwData <<= 8;
-	dwData |= *(pbyAddr+0);
-	pr_debug("2. offset: %d, Data: %X\n", offset, dwData);
+	data = 0;
+	data |= *(pbyAddr + 3);
+	data <<= 8;
+	data |= *(pbyAddr + 2);
+	data <<= 8;
+	data |= *(pbyAddr + 1);
+	data <<= 8;
+	data |= *pbyAddr;
+	pr_debug("2. offset: %d, Data: %X\n", offset, data);
 
 	iowrite16(offset, io_base + MAC_REG_MISCFFNDEX);
-	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
+	iowrite32(data, io_base + MAC_REG_MISCFFDATA);
 	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 	offset++;
 
-- 
2.7.0

