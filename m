Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:60605 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3FQVer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 17:34:47 -0400
Received: by mail-we0-f171.google.com with SMTP id m46so2831294wev.30
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 14:34:45 -0700 (PDT)
Message-ID: <1371504879.3546.11.camel@canaries64> (sfid-20130617_233458_331626_E77283E9)
Subject: [PATCH] staging: vt6656: mac.c MACvDisableKeyEntry remove dead code
 wOffset
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Jun 2013 22:34:39 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index c707d86..e2c8e48 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -120,14 +120,10 @@ void MACvSetBBType(struct vnt_private *pDevice, u8 byType)
  */
 void MACvDisableKeyEntry(struct vnt_private *pDevice, u32 uEntryIdx)
 {
-	u16 wOffset;
 	u8 byData;
 
     byData = (u8) uEntryIdx;
 
-    wOffset = MISCFIFO_KEYETRY0;
-    wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
-
     //issue write misc fifo command to device
     CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_CLRKEYENTRY,
-- 
1.8.1.2


