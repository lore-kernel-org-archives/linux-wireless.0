Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:64204 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaEXNiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:19 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so5969362wes.37
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/14] staging: vt6656: camel case clean up CARDbRadioPowerOff
Date: Sat, 24 May 2014 14:37:07 +0100
Message-Id: <1400938630-2850-11-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153833_993166_D8FB6E7D)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
bResult -> ret

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 09b6de5..2635cf7 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -766,38 +766,36 @@ void CARDvUpdateNextTBTT(struct vnt_private *priv, u64 tsf,
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be turned off
+ *      priv         - The adapter to be turned off
  *  Out:
  *      none
  *
  * Return Value: true if success; otherwise false
  *
  */
-int CARDbRadioPowerOff(struct vnt_private *pDevice)
+int CARDbRadioPowerOff(struct vnt_private *priv)
 {
-	int bResult = true;
-
-    //if (pDevice->bRadioOff == true)
-    //    return true;
-
-    pDevice->bRadioOff = true;
-
-    switch (pDevice->byRFType) {
-        case RF_AL2230:
-        case RF_AL2230S:
-        case RF_AIROHA7230:
-        case RF_VT3226:     //RobertYu:20051111
-        case RF_VT3226D0:
-        case RF_VT3342A0:   //RobertYu:20060609
-            MACvRegBitsOff(pDevice, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE2 | SOFTPWRCTL_SWPE3));
-            break;
-    }
+	int ret = true;
+
+	priv->bRadioOff = true;
+
+	switch (priv->byRFType) {
+	case RF_AL2230:
+	case RF_AL2230S:
+	case RF_AIROHA7230:
+	case RF_VT3226:
+	case RF_VT3226D0:
+	case RF_VT3342A0:
+		MACvRegBitsOff(priv, MAC_REG_SOFTPWRCTL,
+				(SOFTPWRCTL_SWPE2 | SOFTPWRCTL_SWPE3));
+		break;
+	}
 
-    MACvRegBitsOff(pDevice, MAC_REG_HOSTCR, HOSTCR_RXON);
+	MACvRegBitsOff(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
 
-    BBvSetDeepSleep(pDevice);
+	BBvSetDeepSleep(priv);
 
-    return bResult;
+	return ret;
 }
 
 /*
-- 
1.9.1

