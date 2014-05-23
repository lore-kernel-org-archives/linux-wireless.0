Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53734 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaEWRBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:05 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so1222143wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/20] staging: vt6656: camel case clean up MACvSetBBType
Date: Fri, 23 May 2014 18:00:02 +0100
Message-Id: <1400864419-8327-3-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192148_203630_BDED6333)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
byType -> type
pbyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index cc80c8e..0e14aab 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -77,20 +77,15 @@ void MACbShutdown(struct vnt_private *priv)
 	CONTROLnsRequestOut(priv, MESSAGE_TYPE_MACSHUTDOWN, 0, 0, 0, NULL);
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
-			ARRAY_SIZE(pbyData),
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK, MAC_REG_ENCFG0,
+		MESSAGE_REQUEST_MACREG,	ARRAY_SIZE(data), data);
 }
 
 /*
-- 
1.9.1

