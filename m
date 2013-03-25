Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62055 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab3CYTuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 15:50:52 -0400
Received: by mail-wi0-f181.google.com with SMTP id hj8so3438940wib.14
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 12:50:51 -0700 (PDT)
Message-ID: <1364241044.5170.19.camel@canaries64> (sfid-20130325_205057_073638_CA5B5722)
Subject: [PATCH] staging: vt6656: Fix stuck in scanning with variable
 uScanChannel.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, Andres More <more.andres@gmail.com>
Date: Mon, 25 Mar 2013 19:50:44 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When pMgmt->uScanChannel > pDevice->byMaxChannel scanning ends
but no SIOCGIWSCAN(scan done) message is sent. This section of code is
duplicate of that in WLAN_CMD_SCAN_END which sends scan done.
So remove it and jump eCommandState to WLAN_CMD_SCAN_END.

Increment uScanChannel on !ChannelValid.

At WLAN_CMD_SCAN_END reset uScanChannel to 0 when done.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index d6db8d5..d150d05 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -340,29 +340,7 @@ void vRunCommand(struct vnt_private *pDevice)
                 pMgmt->uScanChannel = pDevice->byMinChannel;
             }
             if (pMgmt->uScanChannel > pDevice->byMaxChannel) {
-                pMgmt->eScanState = WMAC_NO_SCANNING;
-
-                if (pDevice->byBBType != pDevice->byScanBBType) {
-                    pDevice->byBBType = pDevice->byScanBBType;
-                    CARDvSetBSSMode(pDevice);
-                }
-
-                if (pDevice->bUpdateBBVGA) {
-                    BBvSetShortSlotTime(pDevice);
-                    BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
-                    BBvUpdatePreEDThreshold(pDevice, false);
-                }
-                // Set channel back
-                vAdHocBeaconRestart(pDevice);
-                // Set channel back
-                CARDbSetMediaChannel(pDevice, pMgmt->uCurrChannel);
-                // Set Filter
-                if (pMgmt->bCurrBSSIDFilterOn) {
-                    MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
-                    pDevice->byRxMode |= RCR_BSSID;
-                }
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning, set back to channel: [%d]\n", pMgmt->uCurrChannel);
-                pDevice->bStopDataPkt = false;
+		pDevice->eCommandState = WLAN_CMD_SCAN_END;
                 s_bCommandComplete(pDevice);
                 spin_unlock_irq(&pDevice->lock);
                 return;
@@ -370,6 +348,7 @@ void vRunCommand(struct vnt_private *pDevice)
             } else {
                 if (!ChannelValid(pDevice->byZoneType, pMgmt->uScanChannel)) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Invalid channel pMgmt->uScanChannel = %d \n",pMgmt->uScanChannel);
+			pMgmt->uScanChannel++;
                     s_bCommandComplete(pDevice);
                     spin_unlock_irq(&pDevice->lock);
                     return;
@@ -466,6 +445,7 @@ void vRunCommand(struct vnt_private *pDevice)
                 pDevice->byRxMode |= RCR_BSSID;
             }
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning, set back to channel: [%d]\n", pMgmt->uCurrChannel);
+		pMgmt->uScanChannel = 0;
             pMgmt->eScanState = WMAC_NO_SCANNING;
             pDevice->bStopDataPkt = false;
 
-- 
1.8.1.2


