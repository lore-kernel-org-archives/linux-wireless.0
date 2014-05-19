Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48814 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaESTel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:41 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so4775862wib.7
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 18/20] staging: vt6656: BBvUpdatePreEDThreshold reorganize ControlvWriteByte.
Date: Mon, 19 May 2014 20:33:10 +0100
Message-Id: <1400527992-3061-18-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213449_991166_64636AB9)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create variables cr_201 and cr 206 with values for registers 0xc9 and 0xce.

Set both to zero .

If cr201 and cr206 are zero drop out.

write both out with ControlvWriteByte.

pDevice->byBBPreEDIndex breaks will be dealt with in next patch

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 225 +++++++++++++++-----------------------
 1 file changed, 89 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 087b84d..39bdd4b 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1410,6 +1410,7 @@ void TimerSQ3Tmax3CallBack(struct vnt_private *pDevice)
 
 void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
 {
+	u8 cr_201 = 0x0, cr_206 = 0x0;
 
     switch(pDevice->byRFType)
     {
@@ -1421,116 +1422,99 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
             if( bScanning )
             {   // need Max sensitivity //RSSI -69, -70,....
                 pDevice->byBBPreEDIndex = 0;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
+		cr_206 = 0x30;
                 break;
             }
 
             if(pDevice->byBBPreEDRSSI <= 45) { // RSSI 0, -1,-2,....-45
                 if(pDevice->byBBPreEDIndex == 20) break;
                 pDevice->byBBPreEDIndex = 20;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0xFF); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0xff;
             } else if(pDevice->byBBPreEDRSSI <= 46)  { //RSSI -46
                 if(pDevice->byBBPreEDIndex == 19) break;
                 pDevice->byBBPreEDIndex = 19;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x1A); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x1a;
             } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -47
                 if(pDevice->byBBPreEDIndex == 18) break;
                 pDevice->byBBPreEDIndex = 18;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x15); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x15;
             } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
                 if(pDevice->byBBPreEDIndex == 17) break;
                 pDevice->byBBPreEDIndex = 17;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x0E); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0xe;
             } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
                 if(pDevice->byBBPreEDIndex == 16) break;
                 pDevice->byBBPreEDIndex = 16;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x09); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x9;
             } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
                 if(pDevice->byBBPreEDIndex == 15) break;
                 pDevice->byBBPreEDIndex = 15;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x06); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x6;
             } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
                 if(pDevice->byBBPreEDIndex == 14) break;
                 pDevice->byBBPreEDIndex = 14;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x03); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x3;
             } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
                 if(pDevice->byBBPreEDIndex == 13) break;
                 pDevice->byBBPreEDIndex = 13;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xA0); //CR206(0xCE)
+		cr_201 = 0x2;
+		cr_206 = 0xa0;
             } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
                 if(pDevice->byBBPreEDIndex == 12) break;
                 pDevice->byBBPreEDIndex = 12;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x20); //CR206(0xCE)
+		cr_201 = 0x2;
+		cr_206 = 0x20;
             } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
                 if(pDevice->byBBPreEDIndex == 11) break;
                 pDevice->byBBPreEDIndex = 11;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xA0); //CR206(0xCE)
+		cr_201 = 0x1;
+		cr_206 = 0xa0;
             } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
                 if(pDevice->byBBPreEDIndex == 10) break;
                 pDevice->byBBPreEDIndex = 10;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x54); //CR206(0xCE)
+		cr_201 = 0x1;
+		cr_206 = 0x54;
             } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
                 if(pDevice->byBBPreEDIndex == 9) break;
                 pDevice->byBBPreEDIndex = 9;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x18); //CR206(0xCE)
+		cr_201 = 0x1;
+		cr_206 = 0x18;
             } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
                 if(pDevice->byBBPreEDIndex == 8) break;
                 pDevice->byBBPreEDIndex = 8;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xE3); //CR206(0xCE)
+		cr_206 = 0xe3;
             } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
                 if(pDevice->byBBPreEDIndex == 7) break;
                 pDevice->byBBPreEDIndex = 7;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xB9); //CR206(0xCE)
+		cr_206 = 0xb9;
             } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
                 if(pDevice->byBBPreEDIndex == 6) break;
                 pDevice->byBBPreEDIndex = 6;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x93); //CR206(0xCE)
+		cr_206 = 0x93;
             } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
                 if(pDevice->byBBPreEDIndex == 5) break;
                 pDevice->byBBPreEDIndex = 5;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x79); //CR206(0xCE)
+		cr_206 = 0x79;
             } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
                 if(pDevice->byBBPreEDIndex == 4) break;
                 pDevice->byBBPreEDIndex = 4;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x62); //CR206(0xCE)
+		cr_206 = 0x62;
             } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
                 if(pDevice->byBBPreEDIndex == 3) break;
                 pDevice->byBBPreEDIndex = 3;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x51); //CR206(0xCE)
+		cr_206 = 0x51;
             } else if(pDevice->byBBPreEDRSSI <= 67)  { //RSSI -67
                 if(pDevice->byBBPreEDIndex == 2) break;
                 pDevice->byBBPreEDIndex = 2;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x43); //CR206(0xCE)
+		cr_206 = 0x43;
             } else if(pDevice->byBBPreEDRSSI <= 68)  { //RSSI -68
                 if(pDevice->byBBPreEDIndex == 1) break;
                 pDevice->byBBPreEDIndex = 1;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x36); //CR206(0xCE)
+		cr_206 = 0x36;
             } else { //RSSI -69, -70,....
                 if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
+		cr_206 = 0x30;
             }
             break;
 
@@ -1541,126 +1525,107 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
             if( bScanning )
             {   // need Max sensitivity  //RSSI -69, -70, ...
                 pDevice->byBBPreEDIndex = 0;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x24); //CR206(0xCE)
+		cr_206 = 0x24;
                 break;
             }
 
             if(pDevice->byBBPreEDRSSI <= 41) { // RSSI 0, -1,-2,....-41
                 if(pDevice->byBBPreEDIndex == 22) break;
                 pDevice->byBBPreEDIndex = 22;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0xFF); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0xff;
             } else if(pDevice->byBBPreEDRSSI <= 42)  { //RSSI -42
                 if(pDevice->byBBPreEDIndex == 21) break;
                 pDevice->byBBPreEDIndex = 21;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x36); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x36;
             } else if(pDevice->byBBPreEDRSSI <= 43)  { //RSSI -43
                 if(pDevice->byBBPreEDIndex == 20) break;
                 pDevice->byBBPreEDIndex = 20;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x26); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x26;
             } else if(pDevice->byBBPreEDRSSI <= 45)  { //RSSI -44, -45
                 if(pDevice->byBBPreEDIndex == 19) break;
                 pDevice->byBBPreEDIndex = 19;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x18); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x18;
             } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -46, -47
                 if(pDevice->byBBPreEDIndex == 18) break;
                 pDevice->byBBPreEDIndex = 18;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x11); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x11;
             } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
                 if(pDevice->byBBPreEDIndex == 17) break;
                 pDevice->byBBPreEDIndex = 17;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x0a); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0xa;
             } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
                 if(pDevice->byBBPreEDIndex == 16) break;
                 pDevice->byBBPreEDIndex = 16;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x07); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x7;
             } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
                 if(pDevice->byBBPreEDIndex == 15) break;
                 pDevice->byBBPreEDIndex = 15;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x04); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x4;
             } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
                 if(pDevice->byBBPreEDIndex == 14) break;
                 pDevice->byBBPreEDIndex = 14;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xC0); //CR206(0xCE)
+		cr_201 = 0x2;
+		cr_206 = 0xc0;
             } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
                 if(pDevice->byBBPreEDIndex == 13) break;
                 pDevice->byBBPreEDIndex = 13;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
+		cr_201 = 0x2;
+		cr_206 = 0x30;
             } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
                 if(pDevice->byBBPreEDIndex == 12) break;
                 pDevice->byBBPreEDIndex = 12;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xB0); //CR206(0xCE)
+		cr_201 = 0x1;
+		cr_206 = 0xb0;
             } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
                 if(pDevice->byBBPreEDIndex == 11) break;
                 pDevice->byBBPreEDIndex = 11;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x70); //CR206(0xCE)
+		cr_201 = 0x1;
+		cr_206 = 0x70;
             } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
                 if(pDevice->byBBPreEDIndex == 10) break;
                 pDevice->byBBPreEDIndex = 10;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
+		cr_201 = 0x1;
+		cr_206 = 0x30;
             } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
                 if(pDevice->byBBPreEDIndex == 9) break;
                 pDevice->byBBPreEDIndex = 9;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xEA); //CR206(0xCE)
+		cr_206 = 0xea;
             } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
                 if(pDevice->byBBPreEDIndex == 8) break;
                 pDevice->byBBPreEDIndex = 8;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xC0); //CR206(0xCE)
+		cr_206 = 0xc0;
             } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
                 if(pDevice->byBBPreEDIndex == 7) break;
                 pDevice->byBBPreEDIndex = 7;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x9C); //CR206(0xCE)
+		cr_206 = 0x9c;
             } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
                 if(pDevice->byBBPreEDIndex == 6) break;
                 pDevice->byBBPreEDIndex = 6;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x80); //CR206(0xCE)
+		cr_206 = 0x80;
             } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
                 if(pDevice->byBBPreEDIndex == 5) break;
                 pDevice->byBBPreEDIndex = 5;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x68); //CR206(0xCE)
+		cr_206 = 0x68;
             } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
                 if(pDevice->byBBPreEDIndex == 4) break;
                 pDevice->byBBPreEDIndex = 4;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x52); //CR206(0xCE)
+		cr_206 = 0x52;
             } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
                 if(pDevice->byBBPreEDIndex == 3) break;
                 pDevice->byBBPreEDIndex = 3;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x43); //CR206(0xCE)
+		cr_206 = 0x43;
             } else if(pDevice->byBBPreEDRSSI <= 67)  { //RSSI -67
                 if(pDevice->byBBPreEDIndex == 2) break;
                 pDevice->byBBPreEDIndex = 2;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x36); //CR206(0xCE)
+		cr_206 = 0x36;
             } else if(pDevice->byBBPreEDRSSI <= 68)  { //RSSI -68
                 if(pDevice->byBBPreEDIndex == 1) break;
                 pDevice->byBBPreEDIndex = 1;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x2D); //CR206(0xCE)
+		cr_206 = 0x2d;
             } else { //RSSI -69, -70, ...
                 if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x24); //CR206(0xCE)
+		cr_206 = 0x24;
             }
             break;
 
@@ -1668,116 +1633,99 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
             if( bScanning )
             {   // need Max sensitivity  //RSSI -67, -68, ...
                 pDevice->byBBPreEDIndex = 0;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x38); //CR206(0xCE)
+		cr_206 = 0x38;
                 break;
             }
 
             if(pDevice->byBBPreEDRSSI <= 41) { // RSSI 0, -1,-2,....-41
                 if(pDevice->byBBPreEDIndex == 20) break;
                 pDevice->byBBPreEDIndex = 20;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0xFF); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0xff;
             } else if(pDevice->byBBPreEDRSSI <= 42)  { //RSSI -42
                 if(pDevice->byBBPreEDIndex == 19) break;
                 pDevice->byBBPreEDIndex = 19;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x36); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x36;
             } else if(pDevice->byBBPreEDRSSI <= 43)  { //RSSI -43
                 if(pDevice->byBBPreEDIndex == 18) break;
                 pDevice->byBBPreEDIndex = 18;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x26); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x26;
             } else if(pDevice->byBBPreEDRSSI <= 45)  { //RSSI -44, -45
                 if(pDevice->byBBPreEDIndex == 17) break;
                 pDevice->byBBPreEDIndex = 17;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x18); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x18;
             } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -46, -47
                 if(pDevice->byBBPreEDIndex == 16) break;
                 pDevice->byBBPreEDIndex = 16;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x11); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x11;
             } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
                 if(pDevice->byBBPreEDIndex == 15) break;
                 pDevice->byBBPreEDIndex = 15;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x0a); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0xa;
             } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
                 if(pDevice->byBBPreEDIndex == 14) break;
                 pDevice->byBBPreEDIndex = 14;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x07); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x7;
             } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
                 if(pDevice->byBBPreEDIndex == 13) break;
                 pDevice->byBBPreEDIndex = 13;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x04); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
+		cr_201 = 0x4;
             } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
                 if(pDevice->byBBPreEDIndex == 12) break;
                 pDevice->byBBPreEDIndex = 12;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xC0); //CR206(0xCE)
+		cr_201 = 0x2;
+		cr_206 = 0xc0;
             } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
                 if(pDevice->byBBPreEDIndex == 11) break;
                 pDevice->byBBPreEDIndex = 11;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
+		cr_201 = 0x2;
+		cr_206 = 0x30;
             } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
                 if(pDevice->byBBPreEDIndex == 10) break;
                 pDevice->byBBPreEDIndex = 10;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xB0); //CR206(0xCE)
+		cr_201 = 0x1;
+		cr_206 = 0xb0;
             } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
                 if(pDevice->byBBPreEDIndex == 9) break;
                 pDevice->byBBPreEDIndex = 9;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x70); //CR206(0xCE)
+		cr_201 = 0x1;
+		cr_206 = 0x70;
             } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
                 if(pDevice->byBBPreEDIndex == 8) break;
                 pDevice->byBBPreEDIndex = 8;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
+		cr_201 = 0x1;
+		cr_206 = 0x30;
             } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
                 if(pDevice->byBBPreEDIndex == 7) break;
                 pDevice->byBBPreEDIndex = 7;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xEA); //CR206(0xCE)
+		cr_206 = 0xea;
             } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
                 if(pDevice->byBBPreEDIndex == 6) break;
                 pDevice->byBBPreEDIndex = 6;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xC0); //CR206(0xCE)
+		cr_206 = 0xc0;
             } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
                 if(pDevice->byBBPreEDIndex == 5) break;
                 pDevice->byBBPreEDIndex = 5;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x9C); //CR206(0xCE)
+		cr_206 = 0x9c;
             } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
                 if(pDevice->byBBPreEDIndex == 4) break;
                 pDevice->byBBPreEDIndex = 4;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x80); //CR206(0xCE)
+		cr_206 = 0x80;
             } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
                 if(pDevice->byBBPreEDIndex == 3) break;
                 pDevice->byBBPreEDIndex = 3;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x68); //CR206(0xCE)
+		cr_206 = 0x68;
             } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
                 if(pDevice->byBBPreEDIndex == 2) break;
                 pDevice->byBBPreEDIndex = 2;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x52); //CR206(0xCE)
+		cr_206 = 0x52;
             } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
                 if(pDevice->byBBPreEDIndex == 1) break;
                 pDevice->byBBPreEDIndex = 1;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x43); //CR206(0xCE)
+		cr_206 = 0x43;
             } else { //RSSI -67, -68, ...
                 if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
-                ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x38); //CR206(0xCE)
+		cr_206 = 0x38;
             }
             break;
 
@@ -1786,5 +1734,10 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
 	dev_dbg(&pDevice->usb->dev, "%s byBBPreEDRSSI %d\n",
 					__func__, pDevice->byBBPreEDRSSI);
 
+	if (!cr_201 && !cr_206)
+		return;
+
+	ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xc9, cr_201);
+	ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xce, cr_206);
 }
 
-- 
1.9.1

