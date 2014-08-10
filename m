Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:62345 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaHJLWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 07:22:52 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so7358477wes.21
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 04:22:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/7] staging: vt6655: upc.h: Remove unused macros
Date: Sun, 10 Aug 2014 12:22:01 +0100
Message-Id: <1407669722-2682-6-git-send-email-tvboxspy@gmail.com> (sfid-20140810_132300_314314_303FE2F6)
In-Reply-To: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
References: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCBv* are not used

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/upc.h | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/staging/vt6655/upc.h b/drivers/staging/vt6655/upc.h
index e262f1b0..00e5a00 100644
--- a/drivers/staging/vt6655/upc.h
+++ b/drivers/staging/vt6655/upc.h
@@ -68,33 +68,6 @@ do {									\
 	writel((unsigned long)dwData, dwIOAddress);			\
 } while (0)
 
-//
-// ALWAYS IO-Mapped IO when in 16-bit/32-bit environment
-//
-#define PCBvInPortB(dwIOAddress, pbyData)	\
-do {						\
-	*(pbyData) = inb(dwIOAddress);		\
-} while (0)
-
-#define PCBvInPortW(dwIOAddress, pwData)	\
-do {						\
-	*(pwData) = inw(dwIOAddress);		\
-} while (0)
-
-#define PCBvInPortD(dwIOAddress, pdwData)	\
-do {						\
-	*(pdwData) = inl(dwIOAddress);		\
-} while (0)
-
-#define PCBvOutPortB(dwIOAddress, byData)	\
-	outb(byData, dwIOAddress)
-
-#define PCBvOutPortW(dwIOAddress, wData)	\
-	outw(wData, dwIOAddress)
-
-#define PCBvOutPortD(dwIOAddress, dwData)	\
-	outl(dwData, dwIOAddress)
-
 #define PCAvDelayByIO(uDelayUnit)				\
 do {								\
 	unsigned char byData;					\
-- 
1.9.1

