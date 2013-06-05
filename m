Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56358 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3FEUom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:44:42 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so637238eek.5
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:44:41 -0700 (PDT)
Message-ID: <1370465077.6213.40.camel@canaries64> (sfid-20130605_224445_189923_8C95E305)
Subject: [PATCH 09/13] staging: vt6656: clean up MACvEnableProtectMD
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:44:37 +0100
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
index d274cae..3e5c816 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -235,20 +235,15 @@ void MACvWriteBSSIDAddress(struct vnt_private *priv, u8 *addr)
 		MESSAGE_REQUEST_MACREG, ETH_ALEN, addr);
 }
 
-void MACvEnableProtectMD(struct vnt_private *pDevice)
+void MACvEnableProtectMD(struct vnt_private *priv)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = EnCFG_ProtectMd;
-    pbyData[1] = EnCFG_ProtectMd;
+	data[0] = EnCFG_ProtectMd;
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
 
 void MACvDisableProtectMD(struct vnt_private *pDevice)
-- 
1.8.1.2



