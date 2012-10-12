Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44251 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab2JLItX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 04:49:23 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1407946bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2012 01:49:22 -0700 (PDT)
Message-ID: <1350031755.15399.3.camel@Route3278> (sfid-20121012_104928_534285_6E5DBE3E)
Subject: [PATCH] staging: vt6656: [BUG] PIPEnsSendBulkOut free bBoolInUse
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Oct 2012 09:49:15 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Eventually, when there is enough errors we run out of free TX urbs and
connection stalls.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 609e8fa..b5259db 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -660,6 +660,7 @@ PIPEnsSendBulkOut(
     	if (status != 0)
     	{
     		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit Tx URB failed %d\n", status);
+		pContext->bBoolInUse = FALSE;
     		return STATUS_FAILURE;
     	}
         return STATUS_PENDING;
-- 
1.7.10.4


