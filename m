Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:61489 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3KZTRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 14:17:06 -0500
Received: by mail-ea0-f172.google.com with SMTP id q10so3921020ead.31
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 11:17:04 -0800 (PST)
Message-ID: <1385493419.6446.10.camel@canaries32-MCP7A> (sfid-20131126_201711_688896_1F7EFB5E)
Subject: [PATCH 3/3] staging: vt6656: clean up s_vGetFreeContext
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Nov 2013 19:16:59 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case clean up
pDevice -> priv
pContext -> context

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 6534f75..2db03d6 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -96,8 +96,7 @@ static const u16 wFB_Opt1[2][5] = {
 static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 	u8 *pbyDestAddr, u16 wPktLength, u16 wFIFOCtl);
 
-static struct vnt_usb_send_context
-		*s_vGetFreeContext(struct vnt_private *pDevice);
+static struct vnt_usb_send_context *s_vGetFreeContext(struct vnt_private *);
 
 static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
@@ -138,26 +137,28 @@ static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
 	int bNeedAck, u8 byFBOption);
 
 static struct vnt_usb_send_context
-	*s_vGetFreeContext(struct vnt_private *pDevice)
+	*s_vGetFreeContext(struct vnt_private *priv)
 {
-	struct vnt_usb_send_context *pContext = NULL;
+	struct vnt_usb_send_context *context = NULL;
 	int ii;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GetFreeContext()\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GetFreeContext()\n");
 
-    for (ii = 0; ii < pDevice->cbTD; ii++) {
-	if (!pDevice->apTD[ii])
-		return NULL;
-        pContext = pDevice->apTD[ii];
-        if (pContext->bBoolInUse == false) {
-            pContext->bBoolInUse = true;
-		memset(pContext->Data, 0, MAX_TOTAL_SIZE_WITH_ALL_HEADERS);
-		return pContext;
-        }
-    }
-    if ( ii == pDevice->cbTD ) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"No Free Tx Context\n");
-    }
+	for (ii = 0; ii < priv->cbTD; ii++) {
+		if (!priv->apTD[ii])
+			return NULL;
+
+		context = priv->apTD[ii];
+		if (context->bBoolInUse == false) {
+			context->bBoolInUse = true;
+			memset(context->Data, 0,
+					MAX_TOTAL_SIZE_WITH_ALL_HEADERS);
+			return context;
+		}
+	}
+
+	if (ii == priv->cbTD)
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"No Free Tx Context\n");
 
 	return NULL;
 }
-- 
1.8.4.4

