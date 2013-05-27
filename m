Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:48563 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942Ab3E0NHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 09:07:34 -0400
Received: by mail-we0-f179.google.com with SMTP id m46so4331447wev.38
        for <linux-wireless@vger.kernel.org>; Mon, 27 May 2013 06:07:33 -0700 (PDT)
Message-ID: <1369660047.8283.23.camel@canaries64> (sfid-20130527_150737_141246_915A1FAF)
Subject: [PATCH 4/5] staging: vt6656: rf.c: RFbRFTableDownload: Remove camel
 case and clean up.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 14:07:27 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


White space clean up.

Camel case changes;
pDevice -> priv
wLength1 -> length1
wLength2 -> length2
wLength3 -> length3
pbyAddr1 -> addr1
pbyAddr2 -> addr2
pbyAddr3 -> addr3
wLength -> length
wValue -> value
abyArray -> array

No functional changes.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 261 ++++++++++++++++++++------------------------
 1 file changed, 121 insertions(+), 140 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 2f3963e..6deeffe 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -966,146 +966,127 @@ void RFvRSSITodBm(struct vnt_private *priv, u8 rssi, long *dbm)
 	*dbm = -1 * (a + b * 2);
 }
 
-void RFbRFTableDownload(struct vnt_private *pDevice)
+void RFbRFTableDownload(struct vnt_private *priv)
 {
-	u16 wLength1 = 0, wLength2 = 0, wLength3 = 0;
-	u8 *pbyAddr1 = NULL, *pbyAddr2 = NULL, *pbyAddr3 = NULL;
-	u16 wLength, wValue;
-	u8 abyArray[256];
-
-    switch ( pDevice->byRFType ) {
-        case RF_AL2230:
-        case RF_AL2230S:
-            wLength1 = CB_AL2230_INIT_SEQ * 3;
-            wLength2 = CB_MAX_CHANNEL_24G * 3;
-            wLength3 = CB_MAX_CHANNEL_24G * 3;
-            pbyAddr1 = &(abyAL2230InitTable[0][0]);
-            pbyAddr2 = &(abyAL2230ChannelTable0[0][0]);
-            pbyAddr3 = &(abyAL2230ChannelTable1[0][0]);
-            break;
-        case RF_AIROHA7230:
-            wLength1 = CB_AL7230_INIT_SEQ * 3;
-            wLength2 = CB_MAX_CHANNEL * 3;
-            wLength3 = CB_MAX_CHANNEL * 3;
-            pbyAddr1 = &(abyAL7230InitTable[0][0]);
-            pbyAddr2 = &(abyAL7230ChannelTable0[0][0]);
-            pbyAddr3 = &(abyAL7230ChannelTable1[0][0]);
-            break;
-        case RF_VT3226: //RobertYu:20051111
-            wLength1 = CB_VT3226_INIT_SEQ * 3;
-            wLength2 = CB_MAX_CHANNEL_24G * 3;
-            wLength3 = CB_MAX_CHANNEL_24G * 3;
-            pbyAddr1 = &(abyVT3226_InitTable[0][0]);
-            pbyAddr2 = &(abyVT3226_ChannelTable0[0][0]);
-            pbyAddr3 = &(abyVT3226_ChannelTable1[0][0]);
-            break;
-        case RF_VT3226D0: //RobertYu:20051114
-            wLength1 = CB_VT3226_INIT_SEQ * 3;
-            wLength2 = CB_MAX_CHANNEL_24G * 3;
-            wLength3 = CB_MAX_CHANNEL_24G * 3;
-            pbyAddr1 = &(abyVT3226D0_InitTable[0][0]);
-            pbyAddr2 = &(abyVT3226_ChannelTable0[0][0]);
-            pbyAddr3 = &(abyVT3226_ChannelTable1[0][0]);
-            break;
-        case RF_VT3342A0: //RobertYu:20060609
-            wLength1 = CB_VT3342_INIT_SEQ * 3;
-            wLength2 = CB_MAX_CHANNEL * 3;
-            wLength3 = CB_MAX_CHANNEL * 3;
-            pbyAddr1 = &(abyVT3342A0_InitTable[0][0]);
-            pbyAddr2 = &(abyVT3342_ChannelTable0[0][0]);
-            pbyAddr3 = &(abyVT3342_ChannelTable1[0][0]);
-            break;
-
-    }
-    //Init Table
-
-    memcpy(abyArray, pbyAddr1, wLength1);
-    CONTROLnsRequestOut(pDevice,
-                    MESSAGE_TYPE_WRITE,
-                    0,
-                    MESSAGE_REQUEST_RF_INIT,
-                    wLength1,
-                    abyArray
-                    );
-    //Channel Table 0
-    wValue = 0;
-    while ( wLength2 > 0 ) {
-
-        if ( wLength2 >= 64 ) {
-            wLength = 64;
-        } else {
-            wLength = wLength2;
-        }
-        memcpy(abyArray, pbyAddr2, wLength);
-        CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        wValue,
-                        MESSAGE_REQUEST_RF_CH0,
-                        wLength,
-                        abyArray);
-
-        wLength2 -= wLength;
-        wValue += wLength;
-        pbyAddr2 += wLength;
-    }
-    //Channel table 1
-    wValue = 0;
-    while ( wLength3 > 0 ) {
-
-        if ( wLength3 >= 64 ) {
-            wLength = 64;
-        } else {
-            wLength = wLength3;
-        }
-        memcpy(abyArray, pbyAddr3, wLength);
-        CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        wValue,
-                        MESSAGE_REQUEST_RF_CH1,
-                        wLength,
-                        abyArray);
-
-        wLength3 -= wLength;
-        wValue += wLength;
-        pbyAddr3 += wLength;
-    }
-
-    //7230 needs 2 InitTable and 3 Channel Table
-    if ( pDevice->byRFType == RF_AIROHA7230 ) {
-        wLength1 = CB_AL7230_INIT_SEQ * 3;
-        wLength2 = CB_MAX_CHANNEL * 3;
-        pbyAddr1 = &(abyAL7230InitTableAMode[0][0]);
-        pbyAddr2 = &(abyAL7230ChannelTable2[0][0]);
-        memcpy(abyArray, pbyAddr1, wLength1);
-        //Init Table 2
-        CONTROLnsRequestOut(pDevice,
-                    MESSAGE_TYPE_WRITE,
-                    0,
-                    MESSAGE_REQUEST_RF_INIT2,
-                    wLength1,
-                    abyArray);
-
-        //Channel Table 0
-        wValue = 0;
-        while ( wLength2 > 0 ) {
-
-            if ( wLength2 >= 64 ) {
-                wLength = 64;
-            } else {
-                wLength = wLength2;
-            }
-            memcpy(abyArray, pbyAddr2, wLength);
-            CONTROLnsRequestOut(pDevice,
-                            MESSAGE_TYPE_WRITE,
-                            wValue,
-                            MESSAGE_REQUEST_RF_CH2,
-                            wLength,
-                            abyArray);
-
-            wLength2 -= wLength;
-            wValue += wLength;
-            pbyAddr2 += wLength;
-        }
-    }
+	u16 length1 = 0, length2 = 0, length3 = 0;
+	u8 *addr1 = NULL, *addr2 = NULL, *addr3 = NULL;
+	u16 length, value;
+	u8 array[256];
 
+	switch (priv->byRFType) {
+	case RF_AL2230:
+	case RF_AL2230S:
+		length1 = CB_AL2230_INIT_SEQ * 3;
+		length2 = CB_MAX_CHANNEL_24G * 3;
+		length3 = CB_MAX_CHANNEL_24G * 3;
+		addr1 = &abyAL2230InitTable[0][0];
+		addr2 = &abyAL2230ChannelTable0[0][0];
+		addr3 = &abyAL2230ChannelTable1[0][0];
+		break;
+	case RF_AIROHA7230:
+		length1 = CB_AL7230_INIT_SEQ * 3;
+		length2 = CB_MAX_CHANNEL * 3;
+		length3 = CB_MAX_CHANNEL * 3;
+		addr1 = &abyAL7230InitTable[0][0];
+		addr2 = &abyAL7230ChannelTable0[0][0];
+		addr3 = &abyAL7230ChannelTable1[0][0];
+		break;
+	case RF_VT3226:
+		length1 = CB_VT3226_INIT_SEQ * 3;
+		length2 = CB_MAX_CHANNEL_24G * 3;
+		length3 = CB_MAX_CHANNEL_24G * 3;
+		addr1 = &abyVT3226_InitTable[0][0];
+		addr2 = &abyVT3226_ChannelTable0[0][0];
+		addr3 = &abyVT3226_ChannelTable1[0][0];
+		break;
+	case RF_VT3226D0:
+		length1 = CB_VT3226_INIT_SEQ * 3;
+		length2 = CB_MAX_CHANNEL_24G * 3;
+		length3 = CB_MAX_CHANNEL_24G * 3;
+		addr1 = &abyVT3226D0_InitTable[0][0];
+		addr2 = &abyVT3226_ChannelTable0[0][0];
+		addr3 = &abyVT3226_ChannelTable1[0][0];
+		break;
+	case RF_VT3342A0:
+		length1 = CB_VT3342_INIT_SEQ * 3;
+		length2 = CB_MAX_CHANNEL * 3;
+		length3 = CB_MAX_CHANNEL * 3;
+		addr1 = &abyVT3342A0_InitTable[0][0];
+		addr2 = &abyVT3342_ChannelTable0[0][0];
+		addr3 = &abyVT3342_ChannelTable1[0][0];
+		break;
+	}
+
+	/* Init Table */
+	memcpy(array, addr1, length1);
+
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, 0,
+		MESSAGE_REQUEST_RF_INIT, length1, array);
+
+	/* Channel Table 0 */
+	value = 0;
+	while (length2 > 0) {
+		if (length2 >= 64)
+			length = 64;
+		else
+			length = length2;
+
+		memcpy(array, addr2, length);
+
+		CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+			value, MESSAGE_REQUEST_RF_CH0, length, array);
+
+		length2 -= length;
+		value += length;
+		addr2 += length;
+	}
+
+	/* Channel table 1 */
+	value = 0;
+	while (length3 > 0) {
+		if (length3 >= 64)
+			length = 64;
+		else
+			length = length3;
+
+		memcpy(array, addr3, length);
+
+		CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+			value, MESSAGE_REQUEST_RF_CH1, length, array);
+
+		length3 -= length;
+		value += length;
+		addr3 += length;
+	}
+
+	if (priv->byRFType == RF_AIROHA7230) {
+		length1 = CB_AL7230_INIT_SEQ * 3;
+		length2 = CB_MAX_CHANNEL * 3;
+		addr1 = &(abyAL7230InitTableAMode[0][0]);
+		addr2 = &(abyAL7230ChannelTable2[0][0]);
+
+		memcpy(array, addr1, length1);
+
+		/* Init Table 2 */
+		CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+			0, MESSAGE_REQUEST_RF_INIT2, length1, array);
+
+		/* Channel Table 0 */
+		value = 0;
+		while (length2 > 0) {
+			if (length2 >= 64)
+				length = 64;
+			else
+				length = length2;
+
+			memcpy(array, addr2, length);
+
+			CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+				value, MESSAGE_REQUEST_RF_CH2, length, array);
+
+			length2 -= length;
+			value += length;
+			addr2 += length;
+		}
+	}
 }
-- 
1.8.1.2




