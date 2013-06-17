Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36280 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3FQVbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 17:31:07 -0400
Received: by mail-ee0-f44.google.com with SMTP id c13so2130130eek.31
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 14:31:06 -0700 (PDT)
Message-ID: <1371504660.3546.9.camel@canaries64> (sfid-20130617_233111_453942_8C4ACA06)
Subject: [PATCH] staging: vt6656: mac.c Remove commented out dead code
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Jun 2013 22:31:00 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 5e01be5..c707d86 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -128,10 +128,6 @@ void MACvDisableKeyEntry(struct vnt_private *pDevice, u32 uEntryIdx)
     wOffset = MISCFIFO_KEYETRY0;
     wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-    //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, 0);
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-
     //issue write misc fifo command to device
     CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_CLRKEYENTRY,
@@ -180,12 +176,6 @@ void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"1. wOffset: %d, Data: %X,"\
 		" KeyCtl:%X\n", wOffset, dwData1, wKeyCtl);
 
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-    //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-
-    //wOffset++;
-
     dwData2 = 0;
     dwData2 |= *(pbyAddr+3);
     dwData2 <<= 8;
@@ -198,21 +188,6 @@ void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"2. wOffset: %d, Data: %X\n",
 		wOffset, dwData2);
 
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-    //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-
-    //wOffset++;
-
-    //wOffset += (uKeyIdx * 4);
-/*    for (ii=0;ii<4;ii++) {
-        // alway push 128 bits
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"3.(%d) wOffset: %d, Data: %lX\n", ii, wOffset+ii, *pdwKey);
-        VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
-        VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
-        VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-    }
-*/
     pbyKey = (u8 *)pdwKey;
 
     pbyData[0] = (u8)dwData1;
-- 
1.8.1.2


