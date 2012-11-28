Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39118 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2K1VTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 16:19:24 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so5440423eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 13:19:23 -0800 (PST)
Message-ID: <1354137556.2633.5.camel@user64-MCP7A> (sfid-20121128_221928_054748_9221FD16)
Subject: [PATCH 3/3] staging: vt6656: dpc.c :RXbBulkInProcessData clean up
 RSC
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 21:19:16 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 8f21bc7..5d94faf 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -359,6 +359,9 @@ RXbBulkInProcessData (
     WORD            wPLCPwithPadding;
     PS802_11Header  pMACHeader;
     BOOL            bRxeapol_key = FALSE;
+	u16 wLocalTSC15_0 = 0;
+	u32 dwLocalTSC47_16 = 0;
+	u64 RSC = 0;
 


@@ -895,21 +898,17 @@ RXbBulkInProcessData (
 
     // ++++++++++ Reply Counter Check +++++++++++++
 
-    if ((pKey != NULL) && ((pKey->byCipherSuite == KEY_CTL_TKIP) ||
-                           (pKey->byCipherSuite == KEY_CTL_CCMP))) {
-        if (bIsWEP) {
-            WORD        wLocalTSC15_0 = 0;
-            DWORD       dwLocalTSC47_16 = 0;
-	    unsigned long long       RSC = 0;
-            // endian issues
-	    RSC = *((unsigned long long *) &(pKey->KeyRSC));
-            wLocalTSC15_0 = (WORD) RSC;
-            dwLocalTSC47_16 = (DWORD) (RSC>>16);
-
-            RSC = dwRxTSC47_16;
-            RSC <<= 16;
-            RSC += wRxTSC15_0;
-		memcpy(&(pKey->KeyRSC), &RSC,  sizeof(u64));
+	if ((pKey != NULL) && ((pKey->byCipherSuite == KEY_CTL_TKIP) ||
+		(pKey->byCipherSuite == KEY_CTL_CCMP))) {
+
+		if (bIsWEP) {
+			RSC = pKey->KeyRSC;
+			wLocalTSC15_0 = (RSC & 0xffffU);
+			dwLocalTSC47_16 = (u32)(RSC >> 16);
+			RSC = dwRxTSC47_16;
+			RSC <<= 16;
+			RSC += wRxTSC15_0;
+			pKey->KeyRSC = RSC;
 
             if ( (pDevice->sMgmtObj.eCurrMode == WMAC_MODE_ESS_STA) &&
                  (pDevice->sMgmtObj.eCurrState == WMAC_STATE_ASSOC)) {
-- 
1.7.10.4



