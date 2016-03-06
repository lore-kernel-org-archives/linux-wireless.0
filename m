Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35813 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbcCFM5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:30 -0500
Received: by mail-wm0-f66.google.com with SMTP id 1so6277362wmg.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:29 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/13] staging: vt6655: mac.c replace VNSvOutPortW with iowrite16
Date: Sun,  6 Mar 2016 12:57:04 +0000
Message-Id: <1457269032-2681-5-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135738_166374_FD86829C)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

removig macro from functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index a9ddb95..43e5f66 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -757,9 +757,9 @@ void MACvSetMISCFifo(struct vnt_private *priv, unsigned short wOffset,
 
 	if (wOffset > 273)
 		return;
-	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
+	iowrite16(wOffset, io_base + MAC_REG_MISCFFNDEX);
 	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
-	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 }
 
 bool MACbPSWakeup(struct vnt_private *priv)
@@ -826,9 +826,9 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 	pr_debug("1. wOffset: %d, Data: %X, KeyCtl:%X\n",
 		 wOffset, dwData, wKeyCtl);
 
-	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
+	iowrite16(wOffset, io_base + MAC_REG_MISCFFNDEX);
 	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
-	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 	wOffset++;
 
 	dwData = 0;
@@ -841,9 +841,9 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 	dwData |= *(pbyAddr+0);
 	pr_debug("2. wOffset: %d, Data: %X\n", wOffset, dwData);
 
-	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
+	iowrite16(wOffset, io_base + MAC_REG_MISCFFNDEX);
 	iowrite32(dwData, io_base + MAC_REG_MISCFFDATA);
-	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 	wOffset++;
 
 	wOffset += (uKeyIdx * 4);
@@ -851,9 +851,9 @@ void MACvSetKeyEntry(struct vnt_private *priv, unsigned short wKeyCtl,
 		/* always push 128 bits */
 		pr_debug("3.(%d) wOffset: %d, Data: %X\n",
 			 ii, wOffset+ii, *pdwKey);
-		VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset+ii);
+		iowrite16(wOffset + ii, io_base + MAC_REG_MISCFFNDEX);
 		iowrite32(*pdwKey++, io_base + MAC_REG_MISCFFDATA);
-		VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+		iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 	}
 }
 
@@ -879,7 +879,7 @@ void MACvDisableKeyEntry(struct vnt_private *priv, unsigned int uEntryIdx)
 	wOffset = MISCFIFO_KEYETRY0;
 	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
-	VNSvOutPortW(io_base + MAC_REG_MISCFFNDEX, wOffset);
+	iowrite16(wOffset, io_base + MAC_REG_MISCFFNDEX);
 	iowrite32(0, io_base + MAC_REG_MISCFFDATA);
-	VNSvOutPortW(io_base + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+	iowrite16(MISCFFCTL_WRITE, io_base + MAC_REG_MISCFFCTL);
 }
-- 
2.7.0

