Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55994 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaEXNiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:22 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so2177484wiv.3
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/14] staging: vt6656: camel case and clean up CARDvSetBSSMode
Date: Sat, 24 May 2014 14:37:09 +0100
Message-Id: <1400938630-2850-13-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153830_865490_BC80D6A1)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 80 +++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 3d41709..5a65f75 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -838,46 +838,44 @@ int CARDbRadioPowerOn(struct vnt_private *priv)
 	return ret;
 }
 
-void CARDvSetBSSMode(struct vnt_private *pDevice)
+void CARDvSetBSSMode(struct vnt_private *priv)
 {
-    // Set BB and packet type at the same time.//{{RobertYu:20050222, AL7230 have two TX PA output, only connet to b/g now
-    // so in 11a mode need to set the MAC Reg0x4C to 11b/g mode to turn on PA
-    if( (pDevice->byRFType == RF_AIROHA7230 ) && (pDevice->byBBType == BB_TYPE_11A) )
-    {
-        MACvSetBBType(pDevice, BB_TYPE_11G);
-    }
-    else
-    {
-        MACvSetBBType(pDevice, pDevice->byBBType);
-    }
-    pDevice->byPacketType = CARDbyGetPktType(pDevice);
-
-    if (pDevice->byBBType == BB_TYPE_11A) {
-        ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x88, 0x03);
-    } else if (pDevice->byBBType == BB_TYPE_11B) {
-        ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x88, 0x02);
-    } else if (pDevice->byBBType == BB_TYPE_11G) {
-        ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x88, 0x08);
-    }
-
-    vUpdateIFS(pDevice);
-    CARDvSetRSPINF(pDevice, (u8)pDevice->byBBType);
-
-    if ( pDevice->byBBType == BB_TYPE_11A ) {
-        //request by Jack 2005-04-26
-        if (pDevice->byRFType == RF_AIROHA7230) {
-            pDevice->abyBBVGA[0] = 0x20;
-            ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xE7, pDevice->abyBBVGA[0]);
-        }
-        pDevice->abyBBVGA[2] = 0x10;
-        pDevice->abyBBVGA[3] = 0x10;
-    } else {
-        //request by Jack 2005-04-26
-        if (pDevice->byRFType == RF_AIROHA7230) {
-            pDevice->abyBBVGA[0] = 0x1C;
-            ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xE7, pDevice->abyBBVGA[0]);
-        }
-        pDevice->abyBBVGA[2] = 0x0;
-        pDevice->abyBBVGA[3] = 0x0;
-    }
+	if (priv->byRFType == RF_AIROHA7230 && priv->byBBType == BB_TYPE_11A)
+		MACvSetBBType(priv, BB_TYPE_11G);
+	else
+		MACvSetBBType(priv, priv->byBBType);
+
+	priv->byPacketType = CARDbyGetPktType(priv);
+
+	if (priv->byBBType == BB_TYPE_11A)
+		ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x03);
+	else if (priv->byBBType == BB_TYPE_11B)
+		ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x02);
+	else if (priv->byBBType == BB_TYPE_11G)
+		ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x08);
+
+	vUpdateIFS(priv);
+	CARDvSetRSPINF(priv, (u8)priv->byBBType);
+
+	if (priv->byBBType == BB_TYPE_11A) {
+		if (priv->byRFType == RF_AIROHA7230) {
+			priv->abyBBVGA[0] = 0x20;
+
+			ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG,
+						0xe7, priv->abyBBVGA[0]);
+		}
+
+		priv->abyBBVGA[2] = 0x10;
+		priv->abyBBVGA[3] = 0x10;
+	} else {
+		if (priv->byRFType == RF_AIROHA7230) {
+			priv->abyBBVGA[0] = 0x1c;
+
+			ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG,
+						0xe7, priv->abyBBVGA[0]);
+		}
+
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+	}
 }
-- 
1.9.1

