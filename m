Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51336 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3LLXdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 18:33:39 -0500
Received: by mail-wi0-f172.google.com with SMTP id en1so349255wid.5
        for <linux-wireless@vger.kernel.org>; Thu, 12 Dec 2013 15:33:38 -0800 (PST)
Message-ID: <1386891188.6227.4.camel@canaries64-MCP7A> (sfid-20131213_003347_295775_11B096B1)
Subject: [PATCH] staging: vt6656: clean up CARDbSetMediaChannel.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Dec 2013 23:33:08 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space and commented out code.

Camel case clean up.
pDevice -> priv
uConnectionChannel -> connection_channel 

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 74 ++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 662cfea..bb91ffa 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -75,52 +75,48 @@ static const u16 cwRXBCNTSFOff[MAX_RATE] =
  * Parameters:
  *  In:
  *      pDevice             - The adapter to be set
- *      uConnectionChannel  - Channel to be set
+ *      connection_channel  - Channel to be set
  *  Out:
  *      none
  */
-void CARDbSetMediaChannel(struct vnt_private *pDevice, u32 uConnectionChannel)
+void CARDbSetMediaChannel(struct vnt_private *priv, u32 connection_channel)
 {
 
-    if (pDevice->byBBType == BB_TYPE_11A) { // 15 ~ 38
-        if ((uConnectionChannel < (CB_MAX_CHANNEL_24G+1)) || (uConnectionChannel > CB_MAX_CHANNEL))
-            uConnectionChannel = (CB_MAX_CHANNEL_24G+1);
-    } else {
-        if ((uConnectionChannel > CB_MAX_CHANNEL_24G) || (uConnectionChannel == 0)) // 1 ~ 14
-            uConnectionChannel = 1;
-    }
-
-    // clear NAV
-    MACvRegBitsOn(pDevice, MAC_REG_MACCR, MACCR_CLRNAV);
-
-    // Set Channel[7] = 0 to tell H/W channel is changing now.
-    MACvRegBitsOff(pDevice, MAC_REG_CHANNEL, 0x80);
-
-    //if (pMgmt->uCurrChannel == uConnectionChannel)
-    //    return bResult;
-
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_SELECT_CHANNLE,
-                        (u16) uConnectionChannel,
-                        0,
-                        0,
-                        NULL
-                        );
+	if (priv->byBBType == BB_TYPE_11A) {
+		if ((connection_channel < (CB_MAX_CHANNEL_24G + 1)) ||
+					(connection_channel > CB_MAX_CHANNEL))
+			connection_channel = (CB_MAX_CHANNEL_24G + 1);
+	} else {
+		if ((connection_channel > CB_MAX_CHANNEL_24G) ||
+						(connection_channel == 0))
+			connection_channel = 1;
+	}
 
-    //{{ RobertYu: 20041202
-    //// TX_PE will reserve 3 us for MAX2829 A mode only, it is for better TX throughput
+	/* clear NAV */
+	MACvRegBitsOn(priv, MAC_REG_MACCR, MACCR_CLRNAV);
+
+	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
+	MACvRegBitsOff(priv, MAC_REG_CHANNEL, 0xb0);
+
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SELECT_CHANNLE,
+					connection_channel, 0, 0, NULL);
+
+	if (priv->byBBType == BB_TYPE_11A) {
+		priv->byCurPwr = 0xff;
+		RFbRawSetPower(priv,
+			priv->abyOFDMAPwrTbl[connection_channel-15], RATE_54M);
+	} else if (priv->byBBType == BB_TYPE_11G) {
+		priv->byCurPwr = 0xff;
+		RFbRawSetPower(priv,
+			priv->abyOFDMPwrTbl[connection_channel-1], RATE_54M);
+	} else {
+		priv->byCurPwr = 0xff;
+		RFbRawSetPower(priv,
+			priv->abyCCKPwrTbl[connection_channel-1], RATE_1M);
+	}
 
-    if (pDevice->byBBType == BB_TYPE_11A) {
-        pDevice->byCurPwr = 0xFF;
-        RFbRawSetPower(pDevice, pDevice->abyOFDMAPwrTbl[uConnectionChannel-15], RATE_54M);
-    } else if (pDevice->byBBType == BB_TYPE_11G) {
-        pDevice->byCurPwr = 0xFF;
-        RFbRawSetPower(pDevice, pDevice->abyOFDMPwrTbl[uConnectionChannel-1], RATE_54M);
-    } else {
-        pDevice->byCurPwr = 0xFF;
-        RFbRawSetPower(pDevice, pDevice->abyCCKPwrTbl[uConnectionChannel-1], RATE_1M);
-    }
-    ControlvWriteByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_CHANNEL,(u8)(uConnectionChannel|0x80));
+	ControlvWriteByte(priv, MESSAGE_REQUEST_MACREG, MAC_REG_CHANNEL,
+		(u8)(connection_channel|0x80));
 }
 
 /*
-- 
1.8.3.2

