Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61057 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbaESTep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:45 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so4758968wiv.9
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 20/20] staging: vt6656: clean up BBvUpdatePreEDThreshold
Date: Mon, 19 May 2014 20:33:12 +0100
Message-Id: <1400527992-3061-20-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213452_760711_BD5DB317)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
bScanning -> scanning

White space cleanup

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 504 +++++++++++++++++++-------------------
 drivers/staging/vt6656/baseband.h |   2 +-
 2 files changed, 249 insertions(+), 257 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index b308a7d..88682c0 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1408,277 +1408,269 @@ void TimerSQ3Tmax3CallBack(struct vnt_private *pDevice)
     spin_unlock_irq(&pDevice->lock);
 }
 
-void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
+void BBvUpdatePreEDThreshold(struct vnt_private *priv, int scanning)
 {
 	u8 cr_201 = 0x0, cr_206 = 0x0;
-	u8 ed_inx = pDevice->byBBPreEDIndex;
-
-    switch(pDevice->byRFType)
-    {
-        case RF_AL2230:
-        case RF_AL2230S:
-        case RF_AIROHA7230:
-            //RobertYu:20060627, update new table
-
-            if( bScanning )
-            {   // need Max sensitivity //RSSI -69, -70,....
-		ed_inx = 0;
-		cr_206 = 0x30;
-                break;
-            }
+	u8 ed_inx = priv->byBBPreEDIndex;
+
+	switch (priv->byRFType) {
+	case RF_AL2230:
+	case RF_AL2230S:
+	case RF_AIROHA7230:
+		if (scanning) { /* Max sensitivity */
+			ed_inx = 0;
+			cr_206 = 0x30;
+			break;
+		}
 
-            if(pDevice->byBBPreEDRSSI <= 45) { // RSSI 0, -1,-2,....-45
-		ed_inx = 20;
-		cr_201 = 0xff;
-            } else if(pDevice->byBBPreEDRSSI <= 46)  { //RSSI -46
-		ed_inx = 19;
-		cr_201 = 0x1a;
-            } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -47
-		ed_inx = 18;
-		cr_201 = 0x15;
-            } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
-		ed_inx = 17;
-		cr_201 = 0xe;
-            } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
-		ed_inx = 16;
-		cr_201 = 0x9;
-            } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
-		ed_inx = 15;
-		cr_201 = 0x6;
-            } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
-		ed_inx = 14;
-		cr_201 = 0x3;
-            } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
-		ed_inx = 13;
-		cr_201 = 0x2;
-		cr_206 = 0xa0;
-            } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
-		ed_inx = 12;
-		cr_201 = 0x2;
-		cr_206 = 0x20;
-            } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
-		ed_inx = 11;
-		cr_201 = 0x1;
-		cr_206 = 0xa0;
-            } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
-		ed_inx = 10;
-		cr_201 = 0x1;
-		cr_206 = 0x54;
-            } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
-		ed_inx = 9;
-		cr_201 = 0x1;
-		cr_206 = 0x18;
-            } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
-		ed_inx = 8;
-		cr_206 = 0xe3;
-            } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
-		ed_inx = 7;
-		cr_206 = 0xb9;
-            } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
-		ed_inx = 6;
-		cr_206 = 0x93;
-            } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
-		ed_inx = 5;
-		cr_206 = 0x79;
-            } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
-		ed_inx = 4;
-		cr_206 = 0x62;
-            } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
-		ed_inx = 3;
-		cr_206 = 0x51;
-            } else if(pDevice->byBBPreEDRSSI <= 67)  { //RSSI -67
-		ed_inx = 2;
-		cr_206 = 0x43;
-            } else if(pDevice->byBBPreEDRSSI <= 68)  { //RSSI -68
-		ed_inx = 1;
-		cr_206 = 0x36;
-            } else { //RSSI -69, -70,....
-		ed_inx = 0;
-		cr_206 = 0x30;
-            }
-            break;
+		if (priv->byBBPreEDRSSI <= 45) {
+			ed_inx = 20;
+			cr_201 = 0xff;
+		} else if (priv->byBBPreEDRSSI <= 46) {
+			ed_inx = 19;
+			cr_201 = 0x1a;
+		} else if (priv->byBBPreEDRSSI <= 47) {
+			ed_inx = 18;
+			cr_201 = 0x15;
+		} else if (priv->byBBPreEDRSSI <= 49) {
+			ed_inx = 17;
+			cr_201 = 0xe;
+		} else if (priv->byBBPreEDRSSI <= 51) {
+			ed_inx = 16;
+			cr_201 = 0x9;
+		} else if (priv->byBBPreEDRSSI <= 53) {
+			ed_inx = 15;
+			cr_201 = 0x6;
+		} else if (priv->byBBPreEDRSSI <= 55) {
+			ed_inx = 14;
+			cr_201 = 0x3;
+		} else if (priv->byBBPreEDRSSI <= 56) {
+			ed_inx = 13;
+			cr_201 = 0x2;
+			cr_206 = 0xa0;
+		} else if (priv->byBBPreEDRSSI <= 57) {
+			ed_inx = 12;
+			cr_201 = 0x2;
+			cr_206 = 0x20;
+		} else if (priv->byBBPreEDRSSI <= 58) {
+			ed_inx = 11;
+			cr_201 = 0x1;
+			cr_206 = 0xa0;
+		} else if (priv->byBBPreEDRSSI <= 59) {
+			ed_inx = 10;
+			cr_201 = 0x1;
+			cr_206 = 0x54;
+		} else if (priv->byBBPreEDRSSI <= 60) {
+			ed_inx = 9;
+			cr_201 = 0x1;
+			cr_206 = 0x18;
+		} else if (priv->byBBPreEDRSSI <= 61) {
+			ed_inx = 8;
+			cr_206 = 0xe3;
+		} else if (priv->byBBPreEDRSSI <= 62) {
+			ed_inx = 7;
+			cr_206 = 0xb9;
+		} else if (priv->byBBPreEDRSSI <= 63) {
+			ed_inx = 6;
+			cr_206 = 0x93;
+		} else if (priv->byBBPreEDRSSI <= 64) {
+			ed_inx = 5;
+			cr_206 = 0x79;
+		} else if (priv->byBBPreEDRSSI <= 65) {
+			ed_inx = 4;
+			cr_206 = 0x62;
+		} else if (priv->byBBPreEDRSSI <= 66) {
+			ed_inx = 3;
+			cr_206 = 0x51;
+		} else if (priv->byBBPreEDRSSI <= 67) {
+			ed_inx = 2;
+			cr_206 = 0x43;
+		} else if (priv->byBBPreEDRSSI <= 68) {
+			ed_inx = 1;
+			cr_206 = 0x36;
+		} else {
+			ed_inx = 0;
+			cr_206 = 0x30;
+		}
+		break;
 
-        case RF_VT3226:
-        case RF_VT3226D0:
-            //RobertYu:20060627, update new table
+	case RF_VT3226:
+	case RF_VT3226D0:
+		if (scanning)	{ /* Max sensitivity */
+			ed_inx = 0;
+			cr_206 = 0x24;
+			break;
+		}
 
-            if( bScanning )
-            {   // need Max sensitivity  //RSSI -69, -70, ...
-		ed_inx = 0;
-		cr_206 = 0x24;
-                break;
-            }
+		if (priv->byBBPreEDRSSI <= 41) {
+			ed_inx = 22;
+			cr_201 = 0xff;
+		} else if (priv->byBBPreEDRSSI <= 42) {
+			ed_inx = 21;
+			cr_201 = 0x36;
+		} else if (priv->byBBPreEDRSSI <= 43) {
+			ed_inx = 20;
+			cr_201 = 0x26;
+		} else if (priv->byBBPreEDRSSI <= 45) {
+			ed_inx = 19;
+			cr_201 = 0x18;
+		} else if (priv->byBBPreEDRSSI <= 47) {
+			ed_inx = 18;
+			cr_201 = 0x11;
+		} else if (priv->byBBPreEDRSSI <= 49) {
+			ed_inx = 17;
+			cr_201 = 0xa;
+		} else if (priv->byBBPreEDRSSI <= 51) {
+			ed_inx = 16;
+			cr_201 = 0x7;
+		} else if (priv->byBBPreEDRSSI <= 53) {
+			ed_inx = 15;
+			cr_201 = 0x4;
+		} else if (priv->byBBPreEDRSSI <= 55) {
+			ed_inx = 14;
+			cr_201 = 0x2;
+			cr_206 = 0xc0;
+		} else if (priv->byBBPreEDRSSI <= 56) {
+			ed_inx = 13;
+			cr_201 = 0x2;
+			cr_206 = 0x30;
+		} else if (priv->byBBPreEDRSSI <= 57) {
+			ed_inx = 12;
+			cr_201 = 0x1;
+			cr_206 = 0xb0;
+		} else if (priv->byBBPreEDRSSI <= 58) {
+			ed_inx = 11;
+			cr_201 = 0x1;
+			cr_206 = 0x70;
+		} else if (priv->byBBPreEDRSSI <= 59) {
+			ed_inx = 10;
+			cr_201 = 0x1;
+			cr_206 = 0x30;
+		} else if (priv->byBBPreEDRSSI <= 60) {
+			ed_inx = 9;
+			cr_206 = 0xea;
+		} else if (priv->byBBPreEDRSSI <= 61) {
+			ed_inx = 8;
+			cr_206 = 0xc0;
+		} else if (priv->byBBPreEDRSSI <= 62) {
+			ed_inx = 7;
+			cr_206 = 0x9c;
+		} else if (priv->byBBPreEDRSSI <= 63) {
+			ed_inx = 6;
+			cr_206 = 0x80;
+		} else if (priv->byBBPreEDRSSI <= 64) {
+			ed_inx = 5;
+			cr_206 = 0x68;
+		} else if (priv->byBBPreEDRSSI <= 65) {
+			ed_inx = 4;
+			cr_206 = 0x52;
+		} else if (priv->byBBPreEDRSSI <= 66) {
+			ed_inx = 3;
+			cr_206 = 0x43;
+		} else if (priv->byBBPreEDRSSI <= 67) {
+			ed_inx = 2;
+			cr_206 = 0x36;
+		} else if (priv->byBBPreEDRSSI <= 68) {
+			ed_inx = 1;
+			cr_206 = 0x2d;
+		} else {
+			ed_inx = 0;
+			cr_206 = 0x24;
+		}
+		break;
 
-            if(pDevice->byBBPreEDRSSI <= 41) { // RSSI 0, -1,-2,....-41
-		ed_inx = 22;
-		cr_201 = 0xff;
-            } else if(pDevice->byBBPreEDRSSI <= 42)  { //RSSI -42
-		ed_inx = 21;
-		cr_201 = 0x36;
-            } else if(pDevice->byBBPreEDRSSI <= 43)  { //RSSI -43
-		ed_inx = 20;
-		cr_201 = 0x26;
-            } else if(pDevice->byBBPreEDRSSI <= 45)  { //RSSI -44, -45
-		ed_inx = 19;
-		cr_201 = 0x18;
-            } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -46, -47
-		ed_inx = 18;
-		cr_201 = 0x11;
-            } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
-		ed_inx = 17;
-		cr_201 = 0xa;
-            } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
-		ed_inx = 16;
-		cr_201 = 0x7;
-            } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
-		ed_inx = 15;
-		cr_201 = 0x4;
-            } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
-		ed_inx = 14;
-		cr_201 = 0x2;
-		cr_206 = 0xc0;
-            } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
-		ed_inx = 13;
-		cr_201 = 0x2;
-		cr_206 = 0x30;
-            } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
-		ed_inx = 12;
-		cr_201 = 0x1;
-		cr_206 = 0xb0;
-            } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
-		ed_inx = 11;
-		cr_201 = 0x1;
-		cr_206 = 0x70;
-            } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
-		ed_inx = 10;
-		cr_201 = 0x1;
-		cr_206 = 0x30;
-            } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
-		ed_inx = 9;
-		cr_206 = 0xea;
-            } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
-		ed_inx = 8;
-		cr_206 = 0xc0;
-            } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
-		ed_inx = 7;
-		cr_206 = 0x9c;
-            } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
-		ed_inx = 6;
-		cr_206 = 0x80;
-            } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
-		ed_inx = 5;
-		cr_206 = 0x68;
-            } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
-		ed_inx = 4;
-		cr_206 = 0x52;
-            } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
-		ed_inx = 3;
-		cr_206 = 0x43;
-            } else if(pDevice->byBBPreEDRSSI <= 67)  { //RSSI -67
-		ed_inx = 2;
-		cr_206 = 0x36;
-            } else if(pDevice->byBBPreEDRSSI <= 68)  { //RSSI -68
-		ed_inx = 1;
-		cr_206 = 0x2d;
-            } else { //RSSI -69, -70, ...
-		ed_inx = 0;
-		cr_206 = 0x24;
-            }
-            break;
-
-        case RF_VT3342A0: //RobertYu:20060627, testing table
-            if( bScanning )
-            {   // need Max sensitivity  //RSSI -67, -68, ...
-		ed_inx = 0;
-		cr_206 = 0x38;
-                break;
-            }
+	case RF_VT3342A0:
+		if (scanning) { /* need Max sensitivity */
+			ed_inx = 0;
+			cr_206 = 0x38;
+			break;
+		}
 
-            if(pDevice->byBBPreEDRSSI <= 41) { // RSSI 0, -1,-2,....-41
-		ed_inx = 20;
-		cr_201 = 0xff;
-            } else if(pDevice->byBBPreEDRSSI <= 42)  { //RSSI -42
-		ed_inx = 19;
-		cr_201 = 0x36;
-            } else if(pDevice->byBBPreEDRSSI <= 43)  { //RSSI -43
-		ed_inx = 18;
-		cr_201 = 0x26;
-            } else if(pDevice->byBBPreEDRSSI <= 45)  { //RSSI -44, -45
-		ed_inx = 17;
-		cr_201 = 0x18;
-            } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -46, -47
-		ed_inx = 16;
-		cr_201 = 0x11;
-            } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
-		ed_inx = 15;
-		cr_201 = 0xa;
-            } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
-		ed_inx = 14;
-		cr_201 = 0x7;
-            } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
-		ed_inx = 13;
-		cr_201 = 0x4;
-            } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
-		ed_inx = 12;
-		cr_201 = 0x2;
-		cr_206 = 0xc0;
-            } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
-		ed_inx = 11;
-		cr_201 = 0x2;
-		cr_206 = 0x30;
-            } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
-		ed_inx = 10;
-		cr_201 = 0x1;
-		cr_206 = 0xb0;
-            } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
-		ed_inx = 9;
-		cr_201 = 0x1;
-		cr_206 = 0x70;
-            } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
-		ed_inx = 8;
-		cr_201 = 0x1;
-		cr_206 = 0x30;
-            } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
-		ed_inx = 7;
-		cr_206 = 0xea;
-            } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
-		ed_inx = 6;
-		cr_206 = 0xc0;
-            } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
-		ed_inx = 5;
-		cr_206 = 0x9c;
-            } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
-		ed_inx = 4;
-		cr_206 = 0x80;
-            } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
-		ed_inx = 3;
-		cr_206 = 0x68;
-            } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
-		ed_inx = 2;
-		cr_206 = 0x52;
-            } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
-		ed_inx = 1;
-		cr_206 = 0x43;
-            } else { //RSSI -67, -68, ...
-		ed_inx = 0;
-		cr_206 = 0x38;
-            }
-            break;
+		if (priv->byBBPreEDRSSI <= 41) {
+			ed_inx = 20;
+			cr_201 = 0xff;
+		} else if (priv->byBBPreEDRSSI <= 42) {
+			ed_inx = 19;
+			cr_201 = 0x36;
+		} else if (priv->byBBPreEDRSSI <= 43) {
+			ed_inx = 18;
+			cr_201 = 0x26;
+		} else if (priv->byBBPreEDRSSI <= 45) {
+			ed_inx = 17;
+			cr_201 = 0x18;
+		} else if (priv->byBBPreEDRSSI <= 47) {
+			ed_inx = 16;
+			cr_201 = 0x11;
+		} else if (priv->byBBPreEDRSSI <= 49) {
+			ed_inx = 15;
+			cr_201 = 0xa;
+		} else if (priv->byBBPreEDRSSI <= 51) {
+			ed_inx = 14;
+			cr_201 = 0x7;
+		} else if (priv->byBBPreEDRSSI <= 53) {
+			ed_inx = 13;
+			cr_201 = 0x4;
+		} else if (priv->byBBPreEDRSSI <= 55) {
+			ed_inx = 12;
+			cr_201 = 0x2;
+			cr_206 = 0xc0;
+		} else if (priv->byBBPreEDRSSI <= 56) {
+			ed_inx = 11;
+			cr_201 = 0x2;
+			cr_206 = 0x30;
+		} else if (priv->byBBPreEDRSSI <= 57) {
+			ed_inx = 10;
+			cr_201 = 0x1;
+			cr_206 = 0xb0;
+		} else if (priv->byBBPreEDRSSI <= 58) {
+			ed_inx = 9;
+			cr_201 = 0x1;
+			cr_206 = 0x70;
+		} else if (priv->byBBPreEDRSSI <= 59) {
+			ed_inx = 8;
+			cr_201 = 0x1;
+			cr_206 = 0x30;
+		} else if (priv->byBBPreEDRSSI <= 60) {
+			ed_inx = 7;
+			cr_206 = 0xea;
+		} else if (priv->byBBPreEDRSSI <= 61) {
+			ed_inx = 6;
+			cr_206 = 0xc0;
+		} else if (priv->byBBPreEDRSSI <= 62) {
+			ed_inx = 5;
+			cr_206 = 0x9c;
+		} else if (priv->byBBPreEDRSSI <= 63) {
+			ed_inx = 4;
+			cr_206 = 0x80;
+		} else if (priv->byBBPreEDRSSI <= 64) {
+			ed_inx = 3;
+			cr_206 = 0x68;
+		} else if (priv->byBBPreEDRSSI <= 65) {
+			ed_inx = 2;
+			cr_206 = 0x52;
+		} else if (priv->byBBPreEDRSSI <= 66) {
+			ed_inx = 1;
+			cr_206 = 0x43;
+		} else {
+			ed_inx = 0;
+			cr_206 = 0x38;
+		}
+		break;
 
-    }
+	}
 
-	if (ed_inx == pDevice->byBBPreEDIndex && !bScanning)
+	if (ed_inx == priv->byBBPreEDIndex && !scanning)
 		return;
 
-	pDevice->byBBPreEDIndex = ed_inx;
+	priv->byBBPreEDIndex = ed_inx;
 
-	dev_dbg(&pDevice->usb->dev, "%s byBBPreEDRSSI %d\n",
-					__func__, pDevice->byBBPreEDRSSI);
+	dev_dbg(&priv->usb->dev, "%s byBBPreEDRSSI %d\n",
+					__func__, priv->byBBPreEDRSSI);
 
 	if (!cr_201 && !cr_206)
 		return;
 
-	ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xc9, cr_201);
-	ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xce, cr_206);
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0xc9, cr_201);
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0xce, cr_206);
 }
 
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 005b94c..eda0d8a 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -107,6 +107,6 @@ void BBvSetAntennaMode(struct vnt_private *, u8 byAntennaMode);
 int BBbVT3184Init(struct vnt_private *);
 void BBvSetDeepSleep(struct vnt_private *);
 void BBvExitDeepSleep(struct vnt_private *);
-void BBvUpdatePreEDThreshold(struct vnt_private *, int bScanning);
+void BBvUpdatePreEDThreshold(struct vnt_private *, int scanning);
 
 #endif /* __BASEBAND_H__ */
-- 
1.9.1

