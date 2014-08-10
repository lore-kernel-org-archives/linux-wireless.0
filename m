Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63594 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaHJLWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 07:22:54 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so7317157wgh.27
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 04:22:53 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/7] staging: vt6655: upc.h replace read and write memory functions
Date: Sun, 10 Aug 2014 12:22:02 +0100
Message-Id: <1407669722-2682-7-git-send-email-tvboxspy@gmail.com> (sfid-20140810_132258_752100_5576B0D4)
In-Reply-To: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
References: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update to the newer memory functions
readb -> ioread8
readw -> ioread16
readl -> ioread32
writeb -> iowrite8
writew -> iowrite16
writel -> iowrite32

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/upc.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/upc.h b/drivers/staging/vt6655/upc.h
index 00e5a00..c5c889ca 100644
--- a/drivers/staging/vt6655/upc.h
+++ b/drivers/staging/vt6655/upc.h
@@ -40,32 +40,32 @@
 
 #define VNSvInPortB(dwIOAddress, pbyData)				\
 do {									\
-	*(pbyData) = readb(dwIOAddress);				\
+	*(pbyData) = ioread8(dwIOAddress);				\
 } while (0)
 
 #define VNSvInPortW(dwIOAddress, pwData)				\
 do {									\
-	*(pwData) = readw(dwIOAddress);					\
+	*(pwData) = ioread16(dwIOAddress);				\
 } while (0)
 
 #define VNSvInPortD(dwIOAddress, pdwData)				\
 do {									\
-	*(pdwData) = readl(dwIOAddress);				\
+	*(pdwData) = ioread32(dwIOAddress);				\
 } while (0)
 
 #define VNSvOutPortB(dwIOAddress, byData)				\
 do {									\
-	writeb((unsigned char)byData, dwIOAddress);			\
+	iowrite8((u8)byData, dwIOAddress);				\
 } while (0)
 
 #define VNSvOutPortW(dwIOAddress, wData)				\
 do {									\
-	writew((unsigned short)wData, dwIOAddress);			\
+	iowrite16((u16)wData, dwIOAddress);				\
 } while (0)
 
 #define VNSvOutPortD(dwIOAddress, dwData)				\
 do {									\
-	writel((unsigned long)dwData, dwIOAddress);			\
+	iowrite32((u32)dwData, dwIOAddress);				\
 } while (0)
 
 #define PCAvDelayByIO(uDelayUnit)				\
-- 
1.9.1

