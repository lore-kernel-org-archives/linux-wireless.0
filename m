Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65295 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaESTed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:33 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so4761469wiw.10
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/20] staging: vt6656: BBvSetShortSlotTime remove camel case.
Date: Mon, 19 May 2014 20:33:05 +0100
Message-Id: <1400527992-3061-13-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213455_628137_33A6E079)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv
byBBVGA -> bb_vga

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 03ecde8..e440823 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1078,27 +1078,28 @@ int BBbVT3184Init(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      pDevice     - Device Structure
+ *	priv	- Device Structure
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void BBvSetShortSlotTime(struct vnt_private *pDevice)
+void BBvSetShortSlotTime(struct vnt_private *priv)
 {
-    u8 byBBVGA=0;
+	u8 bb_vga = 0;
 
-	if (pDevice->bShortSlotTime)
-        pDevice->byBBRxConf &= 0xDF;//1101 1111
+	if (priv->bShortSlotTime)
+		priv->byBBRxConf &= 0xdf;
 	else
-        pDevice->byBBRxConf |= 0x20;//0010 0000
+		priv->byBBRxConf |= 0x20;
+
+	ControlvReadByte(priv, MESSAGE_REQUEST_BBREG, 0xe7, &bb_vga);
 
-    ControlvReadByte (pDevice, MESSAGE_REQUEST_BBREG, 0xE7, &byBBVGA);
-	if (byBBVGA == pDevice->abyBBVGA[0])
-        pDevice->byBBRxConf |= 0x20;//0010 0000
+	if (bb_vga == priv->abyBBVGA[0])
+		priv->byBBRxConf |= 0x20;
 
-    ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0A, pDevice->byBBRxConf);
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
 }
 
 void BBvSetVGAGainOffset(struct vnt_private *pDevice, u8 byData)
-- 
1.9.1

