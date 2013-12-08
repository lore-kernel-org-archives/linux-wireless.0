Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43864 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3LHJLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Dec 2013 04:11:46 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so2275193wgh.14
        for <linux-wireless@vger.kernel.org>; Sun, 08 Dec 2013 01:11:45 -0800 (PST)
Message-ID: <1386493890.5257.15.camel@canaries32-MCP7A> (sfid-20131208_101209_053148_148E3A6E)
Subject: [PATCH] staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set
 sensitivity on bScanning
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Dec 2013 09:11:30 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

byBBPreEDIndex value is initially 0, this means that from
cold BBvUpdatePreEDThreshold is never set.

This means that sensitivity may be in an ambiguous state,
failing to scan any wireless points or at least distant ones.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/vt6656/baseband.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 468f455..86c047b 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1464,7 +1464,6 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
 
             if( bScanning )
             {   // need Max sensitivity //RSSI -69, -70,....
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
@@ -1607,7 +1606,6 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
 
             if( bScanning )
             {   // need Max sensitivity  //RSSI -69, -70, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x24); //CR206(0xCE)
@@ -1759,7 +1757,6 @@ void BBvUpdatePreEDThreshold(struct vnt_private *pDevice, int bScanning)
         case RF_VT3342A0: //RobertYu:20060627, testing table
             if( bScanning )
             {   // need Max sensitivity  //RSSI -67, -68, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x38); //CR206(0xCE)
-- 
1.8.5.1

