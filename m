Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:39446 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbaBSSgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 13:36:46 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so661317wes.16
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 10:36:45 -0800 (PST)
Message-ID: <1392834997.8766.9.camel@canaries64-MCP7A> (sfid-20140219_193649_677986_1B6D2EEC)
Subject: [PATCH 2/4] staging: vt6656: PIPEnsInterruptRead set intBuf.bInUse
 to false.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 18:36:37 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set intBuf.bInUse to false on return error.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 845a8a1..1a0b436 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -323,9 +323,11 @@ int PIPEnsInterruptRead(struct vnt_private *pDevice)
 		pDevice->int_interval);
 
 	ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC);
-	if (ntStatus != 0) {
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit int URB failed %d\n", ntStatus);
-    }
+	if (ntStatus) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Submit int URB failed %d\n", ntStatus);
+		pDevice->intBuf.bInUse = false;
+	}
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----s_nsStartInterruptUsbRead Return(%x)\n",ntStatus);
     return ntStatus;
-- 
1.9.rc1


