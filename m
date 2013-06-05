Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:55160 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab3FEUPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:15:19 -0400
Received: by mail-ea0-f172.google.com with SMTP id q10so85627eaj.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:15:18 -0700 (PDT)
Message-ID: <1370463312.6213.17.camel@canaries64> (sfid-20130605_221525_924643_E29EB175)
Subject: [PATCH 02/13] staging: vt6656: clean up MACvSetBBType
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:15:12 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove internal white space and camel case.

Camel case changes;
pDevice -> priv
pbyData -> data
byType -> type

Functional change
CONTROLnsRequestOut Length = ARRAY_SIZE(data)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 89d700f..0f8132b8 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -84,20 +84,16 @@ void MACbShutdown(struct vnt_private *pDevice)
                         );
 }
 
-void MACvSetBBType(struct vnt_private *pDevice, u8 byType)
+void MACvSetBBType(struct vnt_private *priv, u8 type)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = byType;
-    pbyData[1] = EnCFG_BBType_MASK;
+	data[0] = type;
+	data[1] = EnCFG_BBType_MASK;
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE_MASK,
-                        MAC_REG_ENCFG0,
-                        MESSAGE_REQUEST_MACREG,
-                        2,
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+		MAC_REG_ENCFG0, MESSAGE_REQUEST_MACREG,
+		ARRAY_SIZE(data), data);
 }
 
 /*
-- 
1.8.1.2



