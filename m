Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64868 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780AbaESTee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:34 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so8445825wgh.29
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/20] staging: vt6656: BBvSetVGAGainOffset remove camel case
Date: Mon, 19 May 2014 20:33:06 +0100
Message-Id: <1400527992-3061-14-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213439_459054_F6437DB2)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv
byData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index e440823..466abd9 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1102,18 +1102,18 @@ void BBvSetShortSlotTime(struct vnt_private *priv)
 	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
 }
 
-void BBvSetVGAGainOffset(struct vnt_private *pDevice, u8 byData)
+void BBvSetVGAGainOffset(struct vnt_private *priv, u8 data)
 {
 
-    ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xE7, byData);
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0xE7, data);
 
-    // patch for 3253B0 Baseband with Cardbus module
-	if (pDevice->bShortSlotTime)
-		pDevice->byBBRxConf &= 0xDF; /* 1101 1111 */
+	/* patch for 3253B0 Baseband with Cardbus module */
+	if (priv->bShortSlotTime)
+		priv->byBBRxConf &= 0xdf; /* 1101 1111 */
 	else
-		pDevice->byBBRxConf |= 0x20; /* 0010 0000 */
+		priv->byBBRxConf |= 0x20; /* 0010 0000 */
 
-    ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0A, pDevice->byBBRxConf);//CR10
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
 }
 
 /*
-- 
1.9.1

