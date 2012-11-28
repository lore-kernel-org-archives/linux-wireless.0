Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52545 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2K1VPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 16:15:55 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so5956821bkw.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 13:15:54 -0800 (PST)
Message-ID: <1354137348.2633.3.camel@user64-MCP7A> (sfid-20121128_221558_254392_4F718CC5)
Subject: [PATCH 2/3] staging: vt6656: Remove ULONG_PTR/DWORD_PTR from driver.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 21:15:48 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c |   89 +++++++++++++++++++---------------------
 drivers/staging/vt6656/ttype.h |    3 --
 2 files changed, 42 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 539bc1d..d27469e 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -355,13 +355,13 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 			 PBYTE pbyIEs,
 			 void *pRxPacketContext)
 {
-
-    PSDevice     pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
-    PKnownBSS       pBSSList = NULL;
-    unsigned int            ii;
-    BOOL            bParsingQuiet = FALSE;
+	PSDevice pDevice = (PSDevice)hDeviceContext;
+	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+	PSRxMgmtPacket pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
+	PKnownBSS pBSSList = NULL;
+	unsigned int ii;
+	int bParsingQuiet = FALSE;
+	u32 uLen;
 


@@ -433,29 +433,25 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 
     WPA_ClearRSN(pBSSList);
 
-    if (pRSNWPA != NULL) {
-	unsigned int uLen = pRSNWPA->len + 2;
-
-	if (uLen <= (uIELength -
-		     (unsigned int) (ULONG_PTR) ((PBYTE) pRSNWPA - pbyIEs))) {
-		pBSSList->wWPALen = uLen;
-		memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
-		WPA_ParseRSN(pBSSList, pRSNWPA);
+	if (pRSNWPA != NULL) {
+		uLen = pRSNWPA->len + 2;
+		if (uLen <= (uIELength - (u32)((u8 *)pRSNWPA - pbyIEs))) {
+			pBSSList->wWPALen = uLen;
+			memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
+			WPA_ParseRSN(pBSSList, pRSNWPA);
+		}
 	}
-    }
 
     WPA2_ClearRSN(pBSSList);
 
-    if (pRSN != NULL) {
-	unsigned int uLen = pRSN->len + 2;
-
-	if (uLen <= (uIELength -
-		     (unsigned int) (ULONG_PTR) ((PBYTE) pRSN - pbyIEs))) {
-		pBSSList->wRSNLen = uLen;
-		memcpy(pBSSList->byRSNIE, pRSN, uLen);
-		WPA2vParseRSN(pBSSList, pRSN);
+	if (pRSN != NULL) {
+		uLen = pRSN->len + 2;
+		if (uLen <= (uIELength - (u32)((u8 *)pRSN - pbyIEs))) {
+			pBSSList->wRSNLen = uLen;
+			memcpy(pBSSList->byRSNIE, pRSN, uLen);
+			WPA2vParseRSN(pBSSList, pRSN);
+		}
 	}
-    }
 
     if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) || (pBSSList->bWPA2Valid == TRUE)) {
 
@@ -536,12 +532,13 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
 			 PBYTE pbyIEs,
 			 void *pRxPacketContext)
 {
-    int             ii, jj;
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
-    signed long            ldBm, ldBmSum;
-    BOOL            bParsingQuiet = FALSE;
+	PSDevice pDevice = (PSDevice)hDeviceContext;
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	PSRxMgmtPacket pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
+	signed long            ldBm, ldBmSum;
+	int bParsingQuiet = FALSE;
+	int ii, jj;
+	u32 uLen;
 
     if (pBSSList == NULL)
         return FALSE;
@@ -596,27 +593,25 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
 
    WPA_ClearRSN(pBSSList);         //mike update
 
-   if (pRSNWPA != NULL) {
-	unsigned int uLen = pRSNWPA->len + 2;
-	if (uLen <= (uIELength -
-		     (unsigned int) (ULONG_PTR) ((PBYTE) pRSNWPA - pbyIEs))) {
-		pBSSList->wWPALen = uLen;
-		memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
-		WPA_ParseRSN(pBSSList, pRSNWPA);
+	if (pRSNWPA != NULL) {
+		uLen = pRSNWPA->len + 2;
+		if (uLen <= (uIELength - (u32)((u8 *)pRSNWPA - pbyIEs))) {
+			pBSSList->wWPALen = uLen;
+			memcpy(pBSSList->byWPAIE, pRSNWPA, uLen);
+			WPA_ParseRSN(pBSSList, pRSNWPA);
+		}
 	}
-   }
 
    WPA2_ClearRSN(pBSSList);  //mike update
 
-    if (pRSN != NULL) {
-	unsigned int uLen = pRSN->len + 2;
-	if (uLen <= (uIELength -
-			(unsigned int) (ULONG_PTR) ((PBYTE) pRSN - pbyIEs))) {
-		pBSSList->wRSNLen = uLen;
-		memcpy(pBSSList->byRSNIE, pRSN, uLen);
-		WPA2vParseRSN(pBSSList, pRSN);
+	if (pRSN != NULL) {
+		unsigned int uLen = pRSN->len + 2;
+		if (uLen <= (uIELength - (u32)((u8 *) pRSN - pbyIEs))) {
+			pBSSList->wRSNLen = uLen;
+			memcpy(pBSSList->byRSNIE, pRSN, uLen);
+			WPA2vParseRSN(pBSSList, pRSN);
+		}
 	}
-    }
 
     if (pRxPacket->uRSSI != 0) {
         RFvRSSITodBm(pDevice, (BYTE)(pRxPacket->uRSSI), &ldBm);
diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 89ab494..dbe79be 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -50,9 +50,6 @@ typedef u32 DWORD;
 
 /****** Common pointer types ***********************************************/
 
-typedef u32 ULONG_PTR;
-typedef u32 DWORD_PTR;
-
 // boolean pointer
 
 typedef BYTE *           PBYTE;
-- 
1.7.10.4



