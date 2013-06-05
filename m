Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42520 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab3FEUry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:47:54 -0400
Received: by mail-ea0-f176.google.com with SMTP id o14so1521047eaj.21
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:47:53 -0700 (PDT)
Message-ID: <1370465266.6213.42.camel@canaries64> (sfid-20130605_224757_420358_6FB5DAC9)
Subject: [PATCH 11/13] staging: vt6656: clean up MACvEnableBarkerPreambleMd
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:47:46 +0100
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
index 4038ad8..89bba7d 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -257,20 +257,15 @@ void MACvDisableProtectMD(struct vnt_private *priv)
 		MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvEnableBarkerPreambleMd(struct vnt_private *pDevice)
+void MACvEnableBarkerPreambleMd(struct vnt_private *priv)
 {
-	u8 pbyData[2];
+	u8 data[2];
 
-    pbyData[0] = EnCFG_BarkerPream;
-    pbyData[1] = EnCFG_BarkerPream;
+	data[0] = EnCFG_BarkerPream;
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
 
 void MACvDisableBarkerPreambleMd(struct vnt_private *pDevice)
-- 
1.8.1.2



