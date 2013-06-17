Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:32923 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3FQV0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 17:26:17 -0400
Received: by mail-ee0-f49.google.com with SMTP id b57so2066741eek.8
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 14:26:16 -0700 (PDT)
Message-ID: <1371504371.3546.6.camel@canaries64> (sfid-20130617_232620_826570_969B1CDC)
Subject: [PATCH] staging: vt6656: mac.c MACvWriteMultiAddr: Remove secondary
 variable byData1
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Jun 2013 22:26:11 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 87c7c8b..5e01be5 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -57,15 +57,13 @@ static int          msglevel                =MSG_LEVEL_INFO;
  */
 void MACvWriteMultiAddr(struct vnt_private *pDevice, u32 uByteIdx, u8 byData)
 {
-	u8 byData1;
 
-    byData1 = byData;
     CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_WRITE,
                         (u16) (MAC_REG_MAR0 + uByteIdx),
                         MESSAGE_REQUEST_MACREG,
                         1,
-                        &byData1);
+			&byData);
 }
 
 /*
-- 
1.8.1.2


