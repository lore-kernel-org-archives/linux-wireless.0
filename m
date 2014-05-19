Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:64631 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaESTen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:43 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so6075622wes.12
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 19/20] staging: vt6656: BBvUpdatePreEDThreshold change byBBPreEDIndex
Date: Mon, 19 May 2014 20:33:11 +0100
Message-Id: <1400527992-3061-19-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213452_082601_EC644AA5)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

assign pDevice->byBBPreEDIndex to ed_idx and change ed_inx
value in switch.

If ed_inx == byBBPreEDIndex and not bScanning return out.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 207 ++++++++++++++------------------------
 1 file changed, 74 insertions(+), 133 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 39bdd4b..b308a7d 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1411,6 +1411,7 @@ void TimerSQ3Tmax3CallBack(struct vnt_private *pDevice)
 void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
 {
 	u8 cr_201 = 0x0, cr_206 = 0x0;
+	u8 ed_inx = pDevice->byBBPreEDIndex;
 
     switch(pDevice->byRFType)
     {
@@ -1421,99 +1422,78 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
 
             if( bScanning )
             {   // need Max sensitivity //RSSI -69, -70,....
-                pDevice->byBBPreEDIndex = 0;
+		ed_inx = 0;
 		cr_206 = 0x30;
                 break;
             }
 
             if(pDevice->byBBPreEDRSSI <= 45) { // RSSI 0, -1,-2,....-45
-                if(pDevice->byBBPreEDIndex == 20) break;
-                pDevice->byBBPreEDIndex = 20;
+		ed_inx = 20;
 		cr_201 = 0xff;
             } else if(pDevice->byBBPreEDRSSI <= 46)  { //RSSI -46
-                if(pDevice->byBBPreEDIndex == 19) break;
-                pDevice->byBBPreEDIndex = 19;
+		ed_inx = 19;
 		cr_201 = 0x1a;
             } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -47
-                if(pDevice->byBBPreEDIndex == 18) break;
-                pDevice->byBBPreEDIndex = 18;
+		ed_inx = 18;
 		cr_201 = 0x15;
             } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
-                if(pDevice->byBBPreEDIndex == 17) break;
-                pDevice->byBBPreEDIndex = 17;
+		ed_inx = 17;
 		cr_201 = 0xe;
             } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
-                if(pDevice->byBBPreEDIndex == 16) break;
-                pDevice->byBBPreEDIndex = 16;
+		ed_inx = 16;
 		cr_201 = 0x9;
             } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
-                if(pDevice->byBBPreEDIndex == 15) break;
-                pDevice->byBBPreEDIndex = 15;
+		ed_inx = 15;
 		cr_201 = 0x6;
             } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
-                if(pDevice->byBBPreEDIndex == 14) break;
-                pDevice->byBBPreEDIndex = 14;
+		ed_inx = 14;
 		cr_201 = 0x3;
             } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
-                if(pDevice->byBBPreEDIndex == 13) break;
-                pDevice->byBBPreEDIndex = 13;
+		ed_inx = 13;
 		cr_201 = 0x2;
 		cr_206 = 0xa0;
             } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
-                if(pDevice->byBBPreEDIndex == 12) break;
-                pDevice->byBBPreEDIndex = 12;
+		ed_inx = 12;
 		cr_201 = 0x2;
 		cr_206 = 0x20;
             } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
-                if(pDevice->byBBPreEDIndex == 11) break;
-                pDevice->byBBPreEDIndex = 11;
+		ed_inx = 11;
 		cr_201 = 0x1;
 		cr_206 = 0xa0;
             } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
-                if(pDevice->byBBPreEDIndex == 10) break;
-                pDevice->byBBPreEDIndex = 10;
+		ed_inx = 10;
 		cr_201 = 0x1;
 		cr_206 = 0x54;
             } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
-                if(pDevice->byBBPreEDIndex == 9) break;
-                pDevice->byBBPreEDIndex = 9;
+		ed_inx = 9;
 		cr_201 = 0x1;
 		cr_206 = 0x18;
             } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
-                if(pDevice->byBBPreEDIndex == 8) break;
-                pDevice->byBBPreEDIndex = 8;
+		ed_inx = 8;
 		cr_206 = 0xe3;
             } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
-                if(pDevice->byBBPreEDIndex == 7) break;
-                pDevice->byBBPreEDIndex = 7;
+		ed_inx = 7;
 		cr_206 = 0xb9;
             } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
-                if(pDevice->byBBPreEDIndex == 6) break;
-                pDevice->byBBPreEDIndex = 6;
+		ed_inx = 6;
 		cr_206 = 0x93;
             } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
-                if(pDevice->byBBPreEDIndex == 5) break;
-                pDevice->byBBPreEDIndex = 5;
+		ed_inx = 5;
 		cr_206 = 0x79;
             } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
-                if(pDevice->byBBPreEDIndex == 4) break;
-                pDevice->byBBPreEDIndex = 4;
+		ed_inx = 4;
 		cr_206 = 0x62;
             } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
-                if(pDevice->byBBPreEDIndex == 3) break;
-                pDevice->byBBPreEDIndex = 3;
+		ed_inx = 3;
 		cr_206 = 0x51;
             } else if(pDevice->byBBPreEDRSSI <= 67)  { //RSSI -67
-                if(pDevice->byBBPreEDIndex == 2) break;
-                pDevice->byBBPreEDIndex = 2;
+		ed_inx = 2;
 		cr_206 = 0x43;
             } else if(pDevice->byBBPreEDRSSI <= 68)  { //RSSI -68
-                if(pDevice->byBBPreEDIndex == 1) break;
-                pDevice->byBBPreEDIndex = 1;
+		ed_inx = 1;
 		cr_206 = 0x36;
             } else { //RSSI -69, -70,....
-                if(pDevice->byBBPreEDIndex == 0) break;
-                pDevice->byBBPreEDIndex = 0;
+		ed_inx = 0;
 		cr_206 = 0x30;
             }
             break;
@@ -1524,107 +1504,84 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
 
             if( bScanning )
             {   // need Max sensitivity  //RSSI -69, -70, ...
-                pDevice->byBBPreEDIndex = 0;
+		ed_inx = 0;
 		cr_206 = 0x24;
                 break;
             }
 
             if(pDevice->byBBPreEDRSSI <= 41) { // RSSI 0, -1,-2,....-41
-                if(pDevice->byBBPreEDIndex == 22) break;
-                pDevice->byBBPreEDIndex = 22;
+		ed_inx = 22;
 		cr_201 = 0xff;
             } else if(pDevice->byBBPreEDRSSI <= 42)  { //RSSI -42
-                if(pDevice->byBBPreEDIndex == 21) break;
-                pDevice->byBBPreEDIndex = 21;
+		ed_inx = 21;
 		cr_201 = 0x36;
             } else if(pDevice->byBBPreEDRSSI <= 43)  { //RSSI -43
-                if(pDevice->byBBPreEDIndex == 20) break;
-                pDevice->byBBPreEDIndex = 20;
+		ed_inx = 20;
 		cr_201 = 0x26;
             } else if(pDevice->byBBPreEDRSSI <= 45)  { //RSSI -44, -45
-                if(pDevice->byBBPreEDIndex == 19) break;
-                pDevice->byBBPreEDIndex = 19;
+		ed_inx = 19;
 		cr_201 = 0x18;
             } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -46, -47
-                if(pDevice->byBBPreEDIndex == 18) break;
-                pDevice->byBBPreEDIndex = 18;
+		ed_inx = 18;
 		cr_201 = 0x11;
             } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
-                if(pDevice->byBBPreEDIndex == 17) break;
-                pDevice->byBBPreEDIndex = 17;
+		ed_inx = 17;
 		cr_201 = 0xa;
             } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
-                if(pDevice->byBBPreEDIndex == 16) break;
-                pDevice->byBBPreEDIndex = 16;
+		ed_inx = 16;
 		cr_201 = 0x7;
             } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
-                if(pDevice->byBBPreEDIndex == 15) break;
-                pDevice->byBBPreEDIndex = 15;
+		ed_inx = 15;
 		cr_201 = 0x4;
             } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
-                if(pDevice->byBBPreEDIndex == 14) break;
-                pDevice->byBBPreEDIndex = 14;
+		ed_inx = 14;
 		cr_201 = 0x2;
 		cr_206 = 0xc0;
             } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
-                if(pDevice->byBBPreEDIndex == 13) break;
-                pDevice->byBBPreEDIndex = 13;
+		ed_inx = 13;
 		cr_201 = 0x2;
 		cr_206 = 0x30;
             } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
-                if(pDevice->byBBPreEDIndex == 12) break;
-                pDevice->byBBPreEDIndex = 12;
+		ed_inx = 12;
 		cr_201 = 0x1;
 		cr_206 = 0xb0;
             } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
-                if(pDevice->byBBPreEDIndex == 11) break;
-                pDevice->byBBPreEDIndex = 11;
+		ed_inx = 11;
 		cr_201 = 0x1;
 		cr_206 = 0x70;
             } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
-                if(pDevice->byBBPreEDIndex == 10) break;
-                pDevice->byBBPreEDIndex = 10;
+		ed_inx = 10;
 		cr_201 = 0x1;
 		cr_206 = 0x30;
             } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
-                if(pDevice->byBBPreEDIndex == 9) break;
-                pDevice->byBBPreEDIndex = 9;
+		ed_inx = 9;
 		cr_206 = 0xea;
             } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
-                if(pDevice->byBBPreEDIndex == 8) break;
-                pDevice->byBBPreEDIndex = 8;
+		ed_inx = 8;
 		cr_206 = 0xc0;
             } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
-                if(pDevice->byBBPreEDIndex == 7) break;
-                pDevice->byBBPreEDIndex = 7;
+		ed_inx = 7;
 		cr_206 = 0x9c;
             } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
-                if(pDevice->byBBPreEDIndex == 6) break;
-                pDevice->byBBPreEDIndex = 6;
+		ed_inx = 6;
 		cr_206 = 0x80;
             } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
-                if(pDevice->byBBPreEDIndex == 5) break;
-                pDevice->byBBPreEDIndex = 5;
+		ed_inx = 5;
 		cr_206 = 0x68;
             } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
-                if(pDevice->byBBPreEDIndex == 4) break;
-                pDevice->byBBPreEDIndex = 4;
+		ed_inx = 4;
 		cr_206 = 0x52;
             } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
-                if(pDevice->byBBPreEDIndex == 3) break;
-                pDevice->byBBPreEDIndex = 3;
+		ed_inx = 3;
 		cr_206 = 0x43;
             } else if(pDevice->byBBPreEDRSSI <= 67)  { //RSSI -67
-                if(pDevice->byBBPreEDIndex == 2) break;
-                pDevice->byBBPreEDIndex = 2;
+		ed_inx = 2;
 		cr_206 = 0x36;
             } else if(pDevice->byBBPreEDRSSI <= 68)  { //RSSI -68
-                if(pDevice->byBBPreEDIndex == 1) break;
-                pDevice->byBBPreEDIndex = 1;
+		ed_inx = 1;
 		cr_206 = 0x2d;
             } else { //RSSI -69, -70, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
-                pDevice->byBBPreEDIndex = 0;
+		ed_inx = 0;
 		cr_206 = 0x24;
             }
             break;
@@ -1632,105 +1589,89 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
         case RF_VT3342A0: //RobertYu:20060627, testing table
             if( bScanning )
             {   // need Max sensitivity  //RSSI -67, -68, ...
-                pDevice->byBBPreEDIndex = 0;
+		ed_inx = 0;
 		cr_206 = 0x38;
                 break;
             }
 
             if(pDevice->byBBPreEDRSSI <= 41) { // RSSI 0, -1,-2,....-41
-                if(pDevice->byBBPreEDIndex == 20) break;
-                pDevice->byBBPreEDIndex = 20;
+		ed_inx = 20;
 		cr_201 = 0xff;
             } else if(pDevice->byBBPreEDRSSI <= 42)  { //RSSI -42
-                if(pDevice->byBBPreEDIndex == 19) break;
-                pDevice->byBBPreEDIndex = 19;
+		ed_inx = 19;
 		cr_201 = 0x36;
             } else if(pDevice->byBBPreEDRSSI <= 43)  { //RSSI -43
-                if(pDevice->byBBPreEDIndex == 18) break;
-                pDevice->byBBPreEDIndex = 18;
+		ed_inx = 18;
 		cr_201 = 0x26;
             } else if(pDevice->byBBPreEDRSSI <= 45)  { //RSSI -44, -45
-                if(pDevice->byBBPreEDIndex == 17) break;
-                pDevice->byBBPreEDIndex = 17;
+		ed_inx = 17;
 		cr_201 = 0x18;
             } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -46, -47
-                if(pDevice->byBBPreEDIndex == 16) break;
-                pDevice->byBBPreEDIndex = 16;
+		ed_inx = 16;
 		cr_201 = 0x11;
             } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
-                if(pDevice->byBBPreEDIndex == 15) break;
-                pDevice->byBBPreEDIndex = 15;
+		ed_inx = 15;
 		cr_201 = 0xa;
             } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
-                if(pDevice->byBBPreEDIndex == 14) break;
-                pDevice->byBBPreEDIndex = 14;
+		ed_inx = 14;
 		cr_201 = 0x7;
             } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
-                if(pDevice->byBBPreEDIndex == 13) break;
-                pDevice->byBBPreEDIndex = 13;
+		ed_inx = 13;
 		cr_201 = 0x4;
             } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
-                if(pDevice->byBBPreEDIndex == 12) break;
-                pDevice->byBBPreEDIndex = 12;
+		ed_inx = 12;
 		cr_201 = 0x2;
 		cr_206 = 0xc0;
             } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
-                if(pDevice->byBBPreEDIndex == 11) break;
-                pDevice->byBBPreEDIndex = 11;
+		ed_inx = 11;
 		cr_201 = 0x2;
 		cr_206 = 0x30;
             } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
-                if(pDevice->byBBPreEDIndex == 10) break;
-                pDevice->byBBPreEDIndex = 10;
+		ed_inx = 10;
 		cr_201 = 0x1;
 		cr_206 = 0xb0;
             } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
-                if(pDevice->byBBPreEDIndex == 9) break;
-                pDevice->byBBPreEDIndex = 9;
+		ed_inx = 9;
 		cr_201 = 0x1;
 		cr_206 = 0x70;
             } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
-                if(pDevice->byBBPreEDIndex == 8) break;
-                pDevice->byBBPreEDIndex = 8;
+		ed_inx = 8;
 		cr_201 = 0x1;
 		cr_206 = 0x30;
             } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
-                if(pDevice->byBBPreEDIndex == 7) break;
-                pDevice->byBBPreEDIndex = 7;
+		ed_inx = 7;
 		cr_206 = 0xea;
             } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
-                if(pDevice->byBBPreEDIndex == 6) break;
-                pDevice->byBBPreEDIndex = 6;
+		ed_inx = 6;
 		cr_206 = 0xc0;
             } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
-                if(pDevice->byBBPreEDIndex == 5) break;
-                pDevice->byBBPreEDIndex = 5;
+		ed_inx = 5;
 		cr_206 = 0x9c;
             } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
-                if(pDevice->byBBPreEDIndex == 4) break;
-                pDevice->byBBPreEDIndex = 4;
+		ed_inx = 4;
 		cr_206 = 0x80;
             } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
-                if(pDevice->byBBPreEDIndex == 3) break;
-                pDevice->byBBPreEDIndex = 3;
+		ed_inx = 3;
 		cr_206 = 0x68;
             } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
-                if(pDevice->byBBPreEDIndex == 2) break;
-                pDevice->byBBPreEDIndex = 2;
+		ed_inx = 2;
 		cr_206 = 0x52;
             } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
-                if(pDevice->byBBPreEDIndex == 1) break;
-                pDevice->byBBPreEDIndex = 1;
+		ed_inx = 1;
 		cr_206 = 0x43;
             } else { //RSSI -67, -68, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
-                pDevice->byBBPreEDIndex = 0;
+		ed_inx = 0;
 		cr_206 = 0x38;
             }
             break;
 
     }
 
+	if (ed_inx == pDevice->byBBPreEDIndex && !bScanning)
+		return;
+
+	pDevice->byBBPreEDIndex = ed_inx;
+
 	dev_dbg(&pDevice->usb->dev, "%s byBBPreEDRSSI %d\n",
 					__func__, pDevice->byBBPreEDRSSI);
 
-- 
1.9.1

