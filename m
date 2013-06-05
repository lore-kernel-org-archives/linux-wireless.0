Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:33049 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3FEUQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:16:46 -0400
Received: by mail-ea0-f181.google.com with SMTP id a11so1520761eae.26
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:16:45 -0700 (PDT)
Message-ID: <1370463399.6213.18.camel@canaries64> (sfid-20130605_221651_156582_1D701039)
Subject: [PATCH 03/13] staging: vt6656: clean up MACvDisableKeyEntry
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:16:39 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove internal white space and camel case.

Camel case changes;
pDevice -> priv
uEntryIdx -> entry_idx
byData -> data

Removed wOffset and dead code

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 0f8132b8..13c15fa 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -98,40 +98,26 @@ void MACvSetBBType(struct vnt_private *priv, u8 type)
 
 /*
  * Description:
- *      Disable the Key Entry by MISCFIFO
+ *	Disable the Key Entry
  *
  * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
+ * In:
+ *	entry_idx - Base Address for MAC
  *
- *  Out:
- *      none
+ * Out:
+ *	none
  *
  * Return Value: none
  *
  */
-void MACvDisableKeyEntry(struct vnt_private *pDevice, u32 uEntryIdx)
+void MACvDisableKeyEntry(struct vnt_private *priv, u32 entry_idx)
 {
-	u16 wOffset;
-	u8 byData;
-
-    byData = (u8) uEntryIdx;
+	u8 data;
 
-    wOffset = MISCFIFO_KEYETRY0;
-    wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
-
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-    //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, 0);
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
+	data = (u8)entry_idx;
 
-    //issue write misc fifo command to device
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_CLRKEYENTRY,
-                        0,
-                        0,
-                        1,
-                        &byData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_CLRKEYENTRY,
+		0, 0, sizeof(u8), &data);
 }
 
 /*
-- 
1.8.1.2



