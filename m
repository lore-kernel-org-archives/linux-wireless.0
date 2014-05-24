Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62663 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaEXNiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:20 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so5860701wgg.18
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/14] staging: vt6656: camel case clean up CARDbRadioPowerOn
Date: Sat, 24 May 2014 14:37:08 +0100
Message-Id: <1400938630-2850-12-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153827_117613_D032F332)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
bResult -> ret

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 2635cf7..3d41709 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -803,42 +803,39 @@ int CARDbRadioPowerOff(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be turned on
+ *      priv         - The adapter to be turned on
  *  Out:
  *      none
  *
  * Return Value: true if success; otherwise false
  *
  */
-int CARDbRadioPowerOn(struct vnt_private *pDevice)
+int CARDbRadioPowerOn(struct vnt_private *priv)
 {
-	int bResult = true;
-
-    if ((pDevice->bHWRadioOff == true) || (pDevice->bRadioControlOff == true)) {
-        return false;
-    }
+	int ret = true;
 
-    //if (pDevice->bRadioOff == false)
-    //    return true;
+	if (priv->bHWRadioOff == true || priv->bRadioControlOff == true)
+		return false;
 
-    pDevice->bRadioOff = false;
+	priv->bRadioOff = false;
 
-    BBvExitDeepSleep(pDevice);
+	BBvExitDeepSleep(priv);
 
-    MACvRegBitsOn(pDevice, MAC_REG_HOSTCR, HOSTCR_RXON);
+	MACvRegBitsOn(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
 
-    switch (pDevice->byRFType) {
-        case RF_AL2230:
-        case RF_AL2230S:
-        case RF_AIROHA7230:
-        case RF_VT3226:     //RobertYu:20051111
-        case RF_VT3226D0:
-        case RF_VT3342A0:   //RobertYu:20060609
-            MACvRegBitsOn(pDevice, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE2 | SOFTPWRCTL_SWPE3));
-            break;
-    }
+	switch (priv->byRFType) {
+	case RF_AL2230:
+	case RF_AL2230S:
+	case RF_AIROHA7230:
+	case RF_VT3226:
+	case RF_VT3226D0:
+	case RF_VT3342A0:
+		MACvRegBitsOn(priv, MAC_REG_SOFTPWRCTL,
+			(SOFTPWRCTL_SWPE2 | SOFTPWRCTL_SWPE3));
+		break;
+	}
 
-    return bResult;
+	return ret;
 }
 
 void CARDvSetBSSMode(struct vnt_private *pDevice)
-- 
1.9.1

