Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45490 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3FEU2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:28:55 -0400
Received: by mail-wi0-f175.google.com with SMTP id hn14so5207493wib.8
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:28:54 -0700 (PDT)
Message-ID: <1370464127.6213.30.camel@canaries64> (sfid-20130605_222859_521492_DD8468C7)
Subject: [PATCH 05/13] staging: vt6656: cleanup MACvRegBitsOff
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:28:47 +0100
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
index 56da5ef..77ec057 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -190,20 +190,15 @@ void MACvSetKeyEntry(struct vnt_private *priv, u16 key_ctl, u32 entry_idx,
 
 }
 
-void MACvRegBitsOff(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
+void MACvRegBitsOff(struct vnt_private *priv, u16 offset, u8 bits)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = 0;
-    pbyData[1] = byBits;
+	data[0] = 0;
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
 
 void MACvRegBitsOn(struct vnt_private *pDevice, u8 byRegOfs, u8 byBits)
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 548ab3c..4aa0f8d 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -408,7 +408,7 @@ void MACbShutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u32);
 void MACvSetKeyEntry(struct vnt_private *, u16, u32, u16, u8 *, u32 *);
-void MACvRegBitsOff(struct vnt_private *, u8, u8);
+void MACvRegBitsOff(struct vnt_private *, u16, u8);
 void MACvRegBitsOn(struct vnt_private *, u8, u8);
 void MACvWriteWord(struct vnt_private *, u8, u16);
 void MACvWriteBSSIDAddress(struct vnt_private *, u8 *);
-- 
1.8.1.2

