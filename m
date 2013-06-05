Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33023 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab3FEUlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:41:08 -0400
Received: by mail-ee0-f44.google.com with SMTP id c13so632725eek.31
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:41:07 -0700 (PDT)
Message-ID: <1370464857.6213.38.camel@canaries64> (sfid-20130605_224117_861095_E23FD7C8)
Subject: [PATCH 08/13] staging: vt6656: cleanup MACvWriteBSSIDAddress
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:40:57 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove secondary buffer

Camel case changes;
pDevice -> priv
pbyEtherAddr -> addr

Functional change
point buffer to callers addr
addr is always ETH_ALEN length and check for NULL
CONTROLnsRequestOut Length = ETH_ALEN

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 673ed5d..d274cae 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -223,24 +223,16 @@ void MACvWriteWord(struct vnt_private *priv, u16 offset, u16 word)
 		offset, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvWriteBSSIDAddress(struct vnt_private *pDevice, u8 *pbyEtherAddr)
+void MACvWriteBSSIDAddress(struct vnt_private *priv, u8 *addr)
 {
-	u8 pbyData[6];
 
-    pbyData[0] = *((u8 *)pbyEtherAddr);
-    pbyData[1] = *((u8 *)pbyEtherAddr+1);
-    pbyData[2] = *((u8 *)pbyEtherAddr+2);
-    pbyData[3] = *((u8 *)pbyEtherAddr+3);
-    pbyData[4] = *((u8 *)pbyEtherAddr+4);
-    pbyData[5] = *((u8 *)pbyEtherAddr+5);
+	if (!addr) {
+		pr_warn("%s addr is NULL\n", __func__);
+		return;
+	}
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        MAC_REG_BSSID0,
-                        MESSAGE_REQUEST_MACREG,
-                        6,
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_BSSID0,
+		MESSAGE_REQUEST_MACREG, ETH_ALEN, addr);
 }
 
 void MACvEnableProtectMD(struct vnt_private *pDevice)
-- 
1.8.1.2



