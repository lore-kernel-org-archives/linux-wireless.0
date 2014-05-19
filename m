Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57330 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964783AbaESTek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:40 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so5735677wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:38 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 17/20] staging: vt6656: BBvUpdatePreEDThreshold replace debug messages.
Date: Mon, 19 May 2014 20:33:09 +0100
Message-Id: <1400527992-3061-17-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213445_885525_A9CB5EC9)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace DBG_PRT with single dev_dbg with calling function
and byBBPreEDRSSI value.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 71 ++-------------------------------------
 1 file changed, 3 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 0cde6b5..087b84d 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1423,7 +1423,6 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -69, -70, -71,...\n");
                 break;
             }
 
@@ -1432,127 +1431,106 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
                 pDevice->byBBPreEDIndex = 20;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0xFF); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI 0, -1,-2,..-45\n");
             } else if(pDevice->byBBPreEDRSSI <= 46)  { //RSSI -46
                 if(pDevice->byBBPreEDIndex == 19) break;
                 pDevice->byBBPreEDIndex = 19;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x1A); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -46\n");
             } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -47
                 if(pDevice->byBBPreEDIndex == 18) break;
                 pDevice->byBBPreEDIndex = 18;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x15); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -47\n");
             } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
                 if(pDevice->byBBPreEDIndex == 17) break;
                 pDevice->byBBPreEDIndex = 17;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x0E); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -48,-49\n");
             } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
                 if(pDevice->byBBPreEDIndex == 16) break;
                 pDevice->byBBPreEDIndex = 16;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x09); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -50,-51\n");
             } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
                 if(pDevice->byBBPreEDIndex == 15) break;
                 pDevice->byBBPreEDIndex = 15;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x06); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -52,-53\n");
             } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
                 if(pDevice->byBBPreEDIndex == 14) break;
                 pDevice->byBBPreEDIndex = 14;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x03); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -54,-55\n");
             } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
                 if(pDevice->byBBPreEDIndex == 13) break;
                 pDevice->byBBPreEDIndex = 13;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xA0); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -56\n");
             } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
                 if(pDevice->byBBPreEDIndex == 12) break;
                 pDevice->byBBPreEDIndex = 12;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x20); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -57\n");
             } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
                 if(pDevice->byBBPreEDIndex == 11) break;
                 pDevice->byBBPreEDIndex = 11;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xA0); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -58\n");
             } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
                 if(pDevice->byBBPreEDIndex == 10) break;
                 pDevice->byBBPreEDIndex = 10;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x54); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -59\n");
             } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
                 if(pDevice->byBBPreEDIndex == 9) break;
                 pDevice->byBBPreEDIndex = 9;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x18); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -60\n");
             } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
                 if(pDevice->byBBPreEDIndex == 8) break;
                 pDevice->byBBPreEDIndex = 8;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xE3); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -61\n");
             } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
                 if(pDevice->byBBPreEDIndex == 7) break;
                 pDevice->byBBPreEDIndex = 7;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xB9); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -62\n");
             } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
                 if(pDevice->byBBPreEDIndex == 6) break;
                 pDevice->byBBPreEDIndex = 6;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x93); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -63\n");
             } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
                 if(pDevice->byBBPreEDIndex == 5) break;
                 pDevice->byBBPreEDIndex = 5;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x79); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -64\n");
             } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
                 if(pDevice->byBBPreEDIndex == 4) break;
                 pDevice->byBBPreEDIndex = 4;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x62); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -65\n");
             } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
                 if(pDevice->byBBPreEDIndex == 3) break;
                 pDevice->byBBPreEDIndex = 3;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x51); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -66\n");
             } else if(pDevice->byBBPreEDRSSI <= 67)  { //RSSI -67
                 if(pDevice->byBBPreEDIndex == 2) break;
                 pDevice->byBBPreEDIndex = 2;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x43); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -67\n");
             } else if(pDevice->byBBPreEDRSSI <= 68)  { //RSSI -68
                 if(pDevice->byBBPreEDIndex == 1) break;
                 pDevice->byBBPreEDIndex = 1;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x36); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -68\n");
             } else { //RSSI -69, -70,....
                 if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -69, -70,...\n");
             }
             break;
 
@@ -1565,7 +1543,6 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x24); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -69, -70,..\n");
                 break;
             }
 
@@ -1574,139 +1551,116 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
                 pDevice->byBBPreEDIndex = 22;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0xFF); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI 0, -1,-2,..-41\n");
             } else if(pDevice->byBBPreEDRSSI <= 42)  { //RSSI -42
                 if(pDevice->byBBPreEDIndex == 21) break;
                 pDevice->byBBPreEDIndex = 21;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x36); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -42\n");
             } else if(pDevice->byBBPreEDRSSI <= 43)  { //RSSI -43
                 if(pDevice->byBBPreEDIndex == 20) break;
                 pDevice->byBBPreEDIndex = 20;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x26); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -43\n");
             } else if(pDevice->byBBPreEDRSSI <= 45)  { //RSSI -44, -45
                 if(pDevice->byBBPreEDIndex == 19) break;
                 pDevice->byBBPreEDIndex = 19;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x18); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -44,-45\n");
             } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -46, -47
                 if(pDevice->byBBPreEDIndex == 18) break;
                 pDevice->byBBPreEDIndex = 18;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x11); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -46,-47\n");
             } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
                 if(pDevice->byBBPreEDIndex == 17) break;
                 pDevice->byBBPreEDIndex = 17;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x0a); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -48,-49\n");
             } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
                 if(pDevice->byBBPreEDIndex == 16) break;
                 pDevice->byBBPreEDIndex = 16;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x07); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -50,-51\n");
             } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
                 if(pDevice->byBBPreEDIndex == 15) break;
                 pDevice->byBBPreEDIndex = 15;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x04); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -52,-53\n");
             } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
                 if(pDevice->byBBPreEDIndex == 14) break;
                 pDevice->byBBPreEDIndex = 14;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xC0); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -54,-55\n");
             } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
                 if(pDevice->byBBPreEDIndex == 13) break;
                 pDevice->byBBPreEDIndex = 13;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -56\n");
             } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
                 if(pDevice->byBBPreEDIndex == 12) break;
                 pDevice->byBBPreEDIndex = 12;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xB0); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -57\n");
             } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
                 if(pDevice->byBBPreEDIndex == 11) break;
                 pDevice->byBBPreEDIndex = 11;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x70); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -58\n");
             } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
                 if(pDevice->byBBPreEDIndex == 10) break;
                 pDevice->byBBPreEDIndex = 10;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -59\n");
             } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
                 if(pDevice->byBBPreEDIndex == 9) break;
                 pDevice->byBBPreEDIndex = 9;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xEA); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -60\n");
             } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
                 if(pDevice->byBBPreEDIndex == 8) break;
                 pDevice->byBBPreEDIndex = 8;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xC0); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -61\n");
             } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
                 if(pDevice->byBBPreEDIndex == 7) break;
                 pDevice->byBBPreEDIndex = 7;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x9C); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -62\n");
             } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
                 if(pDevice->byBBPreEDIndex == 6) break;
                 pDevice->byBBPreEDIndex = 6;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x80); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -63\n");
             } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
                 if(pDevice->byBBPreEDIndex == 5) break;
                 pDevice->byBBPreEDIndex = 5;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x68); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -64\n");
             } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
                 if(pDevice->byBBPreEDIndex == 4) break;
                 pDevice->byBBPreEDIndex = 4;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x52); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -65\n");
             } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
                 if(pDevice->byBBPreEDIndex == 3) break;
                 pDevice->byBBPreEDIndex = 3;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x43); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -66\n");
             } else if(pDevice->byBBPreEDRSSI <= 67)  { //RSSI -67
                 if(pDevice->byBBPreEDIndex == 2) break;
                 pDevice->byBBPreEDIndex = 2;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x36); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -67\n");
             } else if(pDevice->byBBPreEDRSSI <= 68)  { //RSSI -68
                 if(pDevice->byBBPreEDIndex == 1) break;
                 pDevice->byBBPreEDIndex = 1;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x2D); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -68\n");
             } else { //RSSI -69, -70, ...
                 if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x24); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -69, -70,..\n");
             }
             break;
 
@@ -1716,7 +1670,6 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x38); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -67, -68,..\n");
                 break;
             }
 
@@ -1725,131 +1678,113 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
                 pDevice->byBBPreEDIndex = 20;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0xFF); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI 0, -1,-2,..-41\n");
             } else if(pDevice->byBBPreEDRSSI <= 42)  { //RSSI -42
                 if(pDevice->byBBPreEDIndex == 19) break;
                 pDevice->byBBPreEDIndex = 19;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x36); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -42\n");
             } else if(pDevice->byBBPreEDRSSI <= 43)  { //RSSI -43
                 if(pDevice->byBBPreEDIndex == 18) break;
                 pDevice->byBBPreEDIndex = 18;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x26); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -43\n");
             } else if(pDevice->byBBPreEDRSSI <= 45)  { //RSSI -44, -45
                 if(pDevice->byBBPreEDIndex == 17) break;
                 pDevice->byBBPreEDIndex = 17;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x18); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -44,-45\n");
             } else if(pDevice->byBBPreEDRSSI <= 47)  { //RSSI -46, -47
                 if(pDevice->byBBPreEDIndex == 16) break;
                 pDevice->byBBPreEDIndex = 16;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x11); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -46,-47\n");
             } else if(pDevice->byBBPreEDRSSI <= 49)  { //RSSI -48, -49
                 if(pDevice->byBBPreEDIndex == 15) break;
                 pDevice->byBBPreEDIndex = 15;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x0a); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -48,-49\n");
             } else if(pDevice->byBBPreEDRSSI <= 51)  { //RSSI -50, -51
                 if(pDevice->byBBPreEDIndex == 14) break;
                 pDevice->byBBPreEDIndex = 14;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x07); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -50,-51\n");
             } else if(pDevice->byBBPreEDRSSI <= 53)  { //RSSI -52, -53
                 if(pDevice->byBBPreEDIndex == 13) break;
                 pDevice->byBBPreEDIndex = 13;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x04); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x00); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -52,-53\n");
             } else if(pDevice->byBBPreEDRSSI <= 55)  { //RSSI -54, -55
                 if(pDevice->byBBPreEDIndex == 12) break;
                 pDevice->byBBPreEDIndex = 12;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xC0); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -54,-55\n");
             } else if(pDevice->byBBPreEDRSSI <= 56)  { //RSSI -56
                 if(pDevice->byBBPreEDIndex == 11) break;
                 pDevice->byBBPreEDIndex = 11;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x02); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -56\n");
             } else if(pDevice->byBBPreEDRSSI <= 57)  { //RSSI -57
                 if(pDevice->byBBPreEDIndex == 10) break;
                 pDevice->byBBPreEDIndex = 10;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xB0); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -57\n");
             } else if(pDevice->byBBPreEDRSSI <= 58)  { //RSSI -58
                 if(pDevice->byBBPreEDIndex == 9) break;
                 pDevice->byBBPreEDIndex = 9;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x70); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -58\n");
             } else if(pDevice->byBBPreEDRSSI <= 59)  { //RSSI -59
                 if(pDevice->byBBPreEDIndex == 8) break;
                 pDevice->byBBPreEDIndex = 8;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x01); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -59\n");
             } else if(pDevice->byBBPreEDRSSI <= 60)  { //RSSI -60
                 if(pDevice->byBBPreEDIndex == 7) break;
                 pDevice->byBBPreEDIndex = 7;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xEA); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -60\n");
             } else if(pDevice->byBBPreEDRSSI <= 61)  { //RSSI -61
                 if(pDevice->byBBPreEDIndex == 6) break;
                 pDevice->byBBPreEDIndex = 6;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0xC0); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -61\n");
             } else if(pDevice->byBBPreEDRSSI <= 62)  { //RSSI -62
                 if(pDevice->byBBPreEDIndex == 5) break;
                 pDevice->byBBPreEDIndex = 5;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x9C); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -62\n");
             } else if(pDevice->byBBPreEDRSSI <= 63)  { //RSSI -63
                 if(pDevice->byBBPreEDIndex == 4) break;
                 pDevice->byBBPreEDIndex = 4;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x80); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -63\n");
             } else if(pDevice->byBBPreEDRSSI <= 64)  { //RSSI -64
                 if(pDevice->byBBPreEDIndex == 3) break;
                 pDevice->byBBPreEDIndex = 3;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x68); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -64\n");
             } else if(pDevice->byBBPreEDRSSI <= 65)  { //RSSI -65
                 if(pDevice->byBBPreEDIndex == 2) break;
                 pDevice->byBBPreEDIndex = 2;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x52); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -65\n");
             } else if(pDevice->byBBPreEDRSSI <= 66)  { //RSSI -66
                 if(pDevice->byBBPreEDIndex == 1) break;
                 pDevice->byBBPreEDIndex = 1;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x43); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -66\n");
             } else { //RSSI -67, -68, ...
                 if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x38); //CR206(0xCE)
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"            pDevice->byBBPreEDRSSI -67, -68,..\n");
             }
             break;
 
     }
 
+	dev_dbg(&pDevice->usb->dev, "%s byBBPreEDRSSI %d\n",
+					__func__, pDevice->byBBPreEDRSSI);
+
 }
 
-- 
1.9.1

