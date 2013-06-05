Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:44091 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3FEUuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:50:03 -0400
Received: by mail-ee0-f43.google.com with SMTP id d41so630458eek.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:50:02 -0700 (PDT)
Message-ID: <1370465397.6213.44.camel@canaries64> (sfid-20130605_225008_531157_296D2639)
Subject: [PATCH 12/13] staging: vt6656: clean up MACvDisableBarkerPreambleMd
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:49:57 +0100
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
index 89bba7d..e255405 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -268,20 +268,15 @@ void MACvEnableBarkerPreambleMd(struct vnt_private *priv)
 		MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvDisableBarkerPreambleMd(struct vnt_private *pDevice)
+void MACvDisableBarkerPreambleMd(struct vnt_private *priv)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = 0;
-    pbyData[1] = EnCFG_BarkerPream;
+	data[0] = 0;
+	data[1] = EnCFG_BarkerPream;
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE_MASK,
-                        MAC_REG_ENCFG2,
-                        MESSAGE_REQUEST_MACREG,
-                        2,
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK, MAC_REG_ENCFG2,
+		MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
 void MACvWriteBeaconInterval(struct vnt_private *pDevice, u16 wInterval)
-- 
1.8.1.2



