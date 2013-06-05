Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60430 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3FEUvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:51:50 -0400
Received: by mail-ea0-f173.google.com with SMTP id g15so1401541eak.4
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:51:49 -0700 (PDT)
Message-ID: <1370465502.6213.46.camel@canaries64> (sfid-20130605_225154_424564_3B1B5A78)
Subject: [PATCH 13/13] staging: vt6656: clean up MACvWriteBeaconInterval
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:51:42 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove internal white space and camel case.

Camel case changes;
pDevice -> priv
pbyData -> data
wInterval -> interval

Functional change
CONTROLnsRequestOut Length = ARRAY_SIZE(data)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index e255405..1d25722 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -279,18 +279,13 @@ void MACvDisableBarkerPreambleMd(struct vnt_private *priv)
 		MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvWriteBeaconInterval(struct vnt_private *pDevice, u16 wInterval)
+void MACvWriteBeaconInterval(struct vnt_private *priv, u16 interval)
 {
-	u8 pbyData[2];
-
-	pbyData[0] = (u8)(wInterval & 0xff);
-	pbyData[1] = (u8)(wInterval >> 8);
-
-    CONTROLnsRequestOut(pDevice,
-			MESSAGE_TYPE_WRITE,
-			MAC_REG_BI,
-			MESSAGE_REQUEST_MACREG,
-			2,
-			pbyData
-			);
+	u8 data[2];
+
+	data[0] = (u8)(interval & 0xff);
+	data[1] = (u8)(interval >> 8);
+
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_BI,
+		MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
-- 
1.8.1.2



