Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:41718 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3E0NCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 09:02:14 -0400
Received: by mail-ea0-f179.google.com with SMTP id z16so3920106ead.10
        for <linux-wireless@vger.kernel.org>; Mon, 27 May 2013 06:02:13 -0700 (PDT)
Message-ID: <1369659729.8283.20.camel@canaries64> (sfid-20130527_150218_689910_78430487)
Subject: [PATCH 1/5] staging: vt6656: rf.c: RFbSetPower Remove camel case
 and clean up.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 14:02:09 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space clean up.

Camel case changes;
pDevice -> priv
uRATE -> rate
uCH -> channel
bResult -> ret
byPwr -> power

No functional changes.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 59 ++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 44cfe0b..0c537b9 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -732,42 +732,41 @@ int IFRFbWriteEmbedded(struct vnt_private *pDevice, u32 dwData)
  * Return Value: true if succeeded; false if failed.
  *
  */
-int RFbSetPower(struct vnt_private *pDevice, u32 uRATE, u32 uCH)
+int RFbSetPower(struct vnt_private *priv, u32 rate, u32 channel)
 {
-	int bResult = true;
-	u8 byPwr = pDevice->byCCKPwr;
+	int ret = true;
+	u8 power = priv->byCCKPwr;
 
-	if (pDevice->dwDiagRefCount)
+	if (priv->dwDiagRefCount)
 		return true;
 
-	if (uCH == 0)
+	if (channel == 0)
 		return -EINVAL;
 
-    switch (uRATE) {
-    case RATE_1M:
-    case RATE_2M:
-    case RATE_5M:
-    case RATE_11M:
-        byPwr = pDevice->abyCCKPwrTbl[uCH-1];
-        break;
-    case RATE_6M:
-    case RATE_9M:
-    case RATE_18M:
-    case RATE_24M:
-    case RATE_36M:
-    case RATE_48M:
-    case RATE_54M:
-        if (uCH > CB_MAX_CHANNEL_24G) {
-            byPwr = pDevice->abyOFDMAPwrTbl[uCH-15];
-        } else {
-            byPwr = pDevice->abyOFDMPwrTbl[uCH-1];
-        }
-        break;
-    }
-
-    bResult = RFbRawSetPower(pDevice, byPwr, uRATE);
-
-    return bResult;
+	switch (rate) {
+	case RATE_1M:
+	case RATE_2M:
+	case RATE_5M:
+	case RATE_11M:
+		power = priv->abyCCKPwrTbl[channel-1];
+		break;
+	case RATE_6M:
+	case RATE_9M:
+	case RATE_18M:
+	case RATE_24M:
+	case RATE_36M:
+	case RATE_48M:
+	case RATE_54M:
+		if (channel > CB_MAX_CHANNEL_24G)
+			power = priv->abyOFDMAPwrTbl[channel-15];
+		else
+			power = priv->abyOFDMPwrTbl[channel-1];
+		break;
+	}
+
+	ret = RFbRawSetPower(priv, power, rate);
+
+	return ret;
 }
 
 /*
-- 
1.8.1.2






