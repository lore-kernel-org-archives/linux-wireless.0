Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63760 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaBYUwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 15:52:55 -0500
Received: by mail-wi0-f180.google.com with SMTP id hm4so1316355wib.7
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 12:52:53 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/10] staging: vt6656: PIPEnsSendBulkOut reverse if statement
Date: Tue, 25 Feb 2014 20:51:43 +0000
Message-Id: <1393361512-13805-1-git-send-email-tvboxspy@gmail.com> (sfid-20140225_215258_677417_6B7DAD0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of unnessary else statement by !(MP_IS_READY(pDevice) &&
pDevice->Flags & fMP_POST_WRITES)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 1fc382d..a93d0ff 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -548,7 +548,10 @@ int PIPEnsSendBulkOut(struct vnt_private *pDevice,
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_nsSendBulkOut\n");
 
-    if (MP_IS_READY(pDevice) && (pDevice->Flags & fMP_POST_WRITES)) {
+	if (!(MP_IS_READY(pDevice) && pDevice->Flags & fMP_POST_WRITES)) {
+		pContext->bBoolInUse = false;
+		return STATUS_RESOURCES;
+	}
 
         pUrb = pContext->pUrb;
         pDevice->ulBulkOutPosted++;
@@ -570,11 +573,6 @@ int PIPEnsSendBulkOut(struct vnt_private *pDevice,
     		return STATUS_FAILURE;
     	}
         return STATUS_PENDING;
-    }
-    else {
-        pContext->bBoolInUse = false;
-        return STATUS_RESOURCES;
-    }
 }
 
 /*
-- 
1.9.0

