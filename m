Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:54633 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab3KZTMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 14:12:45 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so3928992eaj.40
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 11:12:43 -0800 (PST)
Message-ID: <1385493158.6446.7.camel@canaries32-MCP7A> (sfid-20131126_201248_327797_76866B76)
Subject: [PATCH 2/3] staging: vt6656: s_vGetFreeContext remove pReturnContext
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Nov 2013 19:12:38 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just return the context from for loop.

Return NULL if end reached.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 0e4b6fb..6534f75 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -141,7 +141,6 @@ static struct vnt_usb_send_context
 	*s_vGetFreeContext(struct vnt_private *pDevice)
 {
 	struct vnt_usb_send_context *pContext = NULL;
-	struct vnt_usb_send_context *pReturnContext = NULL;
 	int ii;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GetFreeContext()\n");
@@ -153,15 +152,14 @@ static struct vnt_usb_send_context
         if (pContext->bBoolInUse == false) {
             pContext->bBoolInUse = true;
 		memset(pContext->Data, 0, MAX_TOTAL_SIZE_WITH_ALL_HEADERS);
-            pReturnContext = pContext;
-            break;
+		return pContext;
         }
     }
     if ( ii == pDevice->cbTD ) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"No Free Tx Context\n");
     }
 
-	return pReturnContext;
+	return NULL;
 }
 
 static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
-- 
1.8.4.4

