Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:52440 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3FEUqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:46:06 -0400
Received: by mail-ea0-f171.google.com with SMTP id m14so1536691eaj.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:46:05 -0700 (PDT)
Message-ID: <1370465161.6213.41.camel@canaries64> (sfid-20130605_224625_466662_CF5C6567)
Subject: [PATCH 10/13] staging: vt6656: clean up MACvDisableProtectMD
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:46:01 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove internal white space and camel case.

Camel case changes;
pDevice -> priv
pbyData -> data

Functional change
CONTROLnsRequestOut Length = ARRAY_SIZE(data)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 3e5c816..4038ad8 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -246,20 +246,15 @@ void MACvEnableProtectMD(struct vnt_private *priv)
 		MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvDisableProtectMD(struct vnt_private *pDevice)
+void MACvDisableProtectMD(struct vnt_private *priv)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = 0;
-    pbyData[1] = EnCFG_ProtectMd;
+	data[0] = 0;
+	data[1] = EnCFG_ProtectMd;
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE_MASK,
-                        MAC_REG_ENCFG0,
-                        MESSAGE_REQUEST_MACREG,
-                        2,
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK, MAC_REG_ENCFG0,
+		MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
 void MACvEnableBarkerPreambleMd(struct vnt_private *pDevice)
-- 
1.8.1.2



