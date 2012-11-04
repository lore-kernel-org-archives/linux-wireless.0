Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57205 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2KDQTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 11:19:05 -0500
Received: by mail-wi0-f178.google.com with SMTP id hr7so2454324wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 08:19:03 -0800 (PST)
Message-ID: <1352045936.3056.15.camel@Route3278> (sfid-20121104_171918_388349_D11E3528)
Subject: [PATCH] staging: vt6656: no need to bIndicateReceive when no bytes
 to read.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 04 Nov 2012 16:18:56 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index b5259db..fc68518 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -575,7 +575,8 @@ s_nsBulkInUsbIoCompleteRead(
 //            MP_SET_FLAG(pDevice, fMP_DISCONNECTED);
 //        }
     } else {
-        bIndicateReceive = TRUE;
+	if (bytesRead)
+		bIndicateReceive = TRUE;
         pDevice->ulBulkInContCRCError = 0;
         pDevice->ulBulkInBytesRead += bytesRead;
 
-- 
1.7.10.4


