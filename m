Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:45819 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3FEUNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:13:30 -0400
Received: by mail-ea0-f172.google.com with SMTP id q10so84376eaj.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:13:29 -0700 (PDT)
Message-ID: <1370463202.6213.16.camel@canaries64> (sfid-20130605_221333_452315_2CFD3693)
Subject: [PATCH 01/13] staging: vt6656: cleanup MACvWriteMultiAddr
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:13:22 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove internal white space and camel case.

Camel case changes;
pDevice -> priv
uByteidx -> byte_idx
byData -> data

Functional change secondary buffer byData1 removed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 24 +++++++++---------------
 drivers/staging/vt6656/mac.h |  2 +-
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 343db19..89d700f 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -46,26 +46,20 @@ static int          msglevel                =MSG_LEVEL_INFO;
  *      Write MAC Multicast Address Mask
  *
  * Parameters:
- *  In:
- *      uByteidx    - Index of Mask
- *      byData      - Mask Value to write
- *  Out:
- *      none
+ * In:
+ *	byte_idx - Index of Mask
+ *	data- Mask Value to write
+ * Out:
+ *	none
  *
  * Return Value: none
  *
  */
-void MACvWriteMultiAddr(struct vnt_private *pDevice, u32 uByteIdx, u8 byData)
+void MACvWriteMultiAddr(struct vnt_private *priv, u16 byte_idx, u8 data)
 {
-	u8 byData1;
-
-    byData1 = byData;
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        (u16) (MAC_REG_MAR0 + uByteIdx),
-                        MESSAGE_REQUEST_MACREG,
-                        1,
-                        &byData1);
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+		(u16)(MAC_REG_MAR0 + byte_idx), MESSAGE_REQUEST_MACREG,
+			sizeof(data), &data);
 }
 
 /*
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 0db1be5..f0cecc9 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -403,7 +403,7 @@
 #define MAC_REVISION_A0     0x00
 #define MAC_REVISION_A1     0x01
 
-void MACvWriteMultiAddr(struct vnt_private *, u32, u8);
+void MACvWriteMultiAddr(struct vnt_private *, u16, u8);
 void MACbShutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u32);
-- 
1.8.1.2



