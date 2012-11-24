Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62990 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2KXOxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 09:53:16 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so2790728wer.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 06:53:15 -0800 (PST)
Message-ID: <1353768787.2318.15.camel@user64-MCP7A> (sfid-20121124_155319_913635_91C87848)
Subject: [PATCH 09/10] staging: vt6656: send SIOCGIWSCAN at end of all
 scanning events.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:53:07 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


wpa supplicant can become confused if the scanning has ended on
active scanning.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 99bced7..22f6b41 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -342,6 +342,7 @@ void vRunCommand(void *hDeviceContext)
     BYTE            byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
     struct sk_buff  *skb;
     BYTE            byData;
+	union iwreq_data wrqu;
 

     if (pDevice->dwDiagRefCount != 0)
@@ -503,14 +504,11 @@ void vRunCommand(void *hDeviceContext)
             pMgmt->eScanState = WMAC_NO_SCANNING;
             pDevice->bStopDataPkt = FALSE;
 
-	if(pMgmt->eScanType == WMAC_SCAN_PASSIVE)
-		{
-			//send scan event to wpa_Supplicant
-				union iwreq_data wrqu;
-				PRINT_K("wireless_send_event--->SIOCGIWSCAN(scan done)\n");
-				memset(&wrqu, 0, sizeof(wrqu));
-				wireless_send_event(pDevice->dev, SIOCGIWSCAN, &wrqu, NULL);
-			}
+		/*send scan event to wpa_Supplicant*/
+		PRINT_K("wireless_send_event--->SIOCGIWSCAN(scan done)\n");
+		memset(&wrqu, 0, sizeof(wrqu));
+		wireless_send_event(pDevice->dev, SIOCGIWSCAN, &wrqu, NULL);
+
             s_bCommandComplete(pDevice);
             break;
 
-- 
1.7.10.4



