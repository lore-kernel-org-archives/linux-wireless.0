Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:39637 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab3FEUic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:38:32 -0400
Received: by mail-ea0-f177.google.com with SMTP id j14so1514689eak.36
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:38:30 -0700 (PDT)
Message-ID: <1370464702.6213.36.camel@canaries64> (sfid-20130605_223842_206728_063D0B65)
Subject: [PATCH 07/13] staging: vt6656: clean up MACvWriteWord
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:38:22 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Remove internal white space and camel case.

Camel case changes;
pDevice -> priv
byRegOfs -> offset
wData -> word
pbyData -> data

Functional change
CONTROLnsRequestOut Length = ARRAY_SIZE(data)
offset changed to u16 to match CONTROLnsRequestOut
Value size.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 18 ++++++------------
 drivers/staging/vt6656/mac.h |  2 +-
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index d690ef1..673ed5d 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -212,21 +212,15 @@ void MACvRegBitsOn(struct vnt_private *priv, u16 offset, u8 bits)
 		offset, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvWriteWord(struct vnt_private *pDevice, u8 byRegOfs, u16 wData)
+void MACvWriteWord(struct vnt_private *priv, u16 offset, u16 word)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = (u8)(wData & 0xff);
-    pbyData[1] = (u8)(wData >> 8);
-
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        byRegOfs,
-                        MESSAGE_REQUEST_MACREG,
-                        2,
-                        pbyData
-                        );
+	data[0] = (u8)(word & 0xff);
+	data[1] = (u8)(word >> 8);
 
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+		offset, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
 void MACvWriteBSSIDAddress(struct vnt_private *pDevice, u8 *pbyEtherAddr)
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 91964e8..b575d61 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -410,7 +410,7 @@ void MACvDisableKeyEntry(struct vnt_private *, u32);
 void MACvSetKeyEntry(struct vnt_private *, u16, u32, u16, u8 *, u32 *);
 void MACvRegBitsOff(struct vnt_private *, u16, u8);
 void MACvRegBitsOn(struct vnt_private *, u16, u8);
-void MACvWriteWord(struct vnt_private *, u8, u16);
+void MACvWriteWord(struct vnt_private *, u16, u16);
 void MACvWriteBSSIDAddress(struct vnt_private *, u8 *);
 void MACvEnableProtectMD(struct vnt_private *);
 void MACvDisableProtectMD(struct vnt_private *);
-- 
1.8.1.2



