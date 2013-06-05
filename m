Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61281 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab3FEUdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:33:11 -0400
Received: by mail-ee0-f51.google.com with SMTP id e52so621931eek.10
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:33:09 -0700 (PDT)
Message-ID: <1370464385.6213.32.camel@canaries64> (sfid-20130605_223315_525127_6A0E2D8A)
Subject: [PATCH 06/13] staging: vt6656: clean up MACvRegBitsOn
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:33:05 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove internal white space and camel case.

Camel case changes;
pDevice -> priv
byRegOfs -> offset
byBits -> bits
pbyData -> data

Functional change
CONTROLnsRequestOut Length = ARRAY_SIZE(data)
offset changed to u16

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 17 ++++++-----------
 drivers/staging/vt6656/mac.h |  2 +-
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 77ec057..d690ef1 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -201,20 +201,15 @@ void MACvRegBitsOff(struct vnt_private *priv, u16 offset, u8 bits)
 		offset, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvRegBitsOn(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
+void MACvRegBitsOn(struct vnt_private *priv, u16 offset, u8 bits)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = byBits;
-    pbyData[1] = byBits;
+	data[0] = bits;
+	data[1] = bits;
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE_MASK,
-                        byRegOfs,
-                        MESSAGE_REQUEST_MACREG,
-                        2,
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+		offset, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
 void MACvWriteWord(struct vnt_private *pDevice, u8 byRegOfs, u16 wData)
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 4aa0f8d..91964e8 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -409,7 +409,7 @@ void MACvSetBBType(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u32);
 void MACvSetKeyEntry(struct vnt_private *, u16, u32, u16, u8 *, u32 *);
 void MACvRegBitsOff(struct vnt_private *, u16, u8);
-void MACvRegBitsOn(struct vnt_private *, u8, u8);
+void MACvRegBitsOn(struct vnt_private *, u16, u8);
 void MACvWriteWord(struct vnt_private *, u8, u16);
 void MACvWriteBSSIDAddress(struct vnt_private *, u8 *);
 void MACvEnableProtectMD(struct vnt_private *);
-- 
1.8.1.2



