Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35394 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaH3V0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:43 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so4199756wib.4
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/23] staging: vt6655: Fix *Duration s_uFillDataHead to return to __le16
Date: Sat, 30 Aug 2014 22:25:38 +0100
Message-Id: <1409433949-5468-12-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234534_371294_A2E9FABD)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All callers should be __le16.

Fix vGenerateMACHeader duration to __le16 and reverse the endian
conversion.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index bd0e339..0171f64 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -166,7 +166,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned int uNodeIndex, unsigned int *puMACfragNum);
 
 static
-unsigned int
+__le16
 s_uFillDataHead(
 	struct vnt_private *pDevice,
 	unsigned char byPktType,
@@ -671,7 +671,7 @@ s_uGetRTSCTSDuration(
 }
 
 static
-unsigned int
+__le16
 s_uFillDataHead(
 	struct vnt_private *pDevice,
 	unsigned char byPktType,
@@ -1202,7 +1202,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 	unsigned char *pbyIVHead;
 	unsigned char *pbyMacHdr;
 	unsigned short wFragType; //00:Non-Frag, 01:Start, 10:Mid, 11:Last
-	unsigned int uDuration;
+	__le16 uDuration;
 	unsigned char *pbyBuffer;
 	unsigned int cbIVlen = 0;
 	unsigned int cbICVlen = 0;
@@ -1448,7 +1448,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				uDuration = s_uFillDataHead(pDevice, byPktType, pvTxDataHd, cbFragmentSize, uDMAIdx, bNeedACK,
 							    uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption, pDevice->wCurrentRate);
 				// Generate TX MAC Header
-				vGenerateMACHeader(pDevice, pbyMacHdr, (unsigned short)uDuration, psEthHeader, bNeedEncrypt,
+				vGenerateMACHeader(pDevice, pbyMacHdr, uDuration, psEthHeader, bNeedEncrypt,
 						   wFragType, uDMAIdx, uFragIdx);
 
 				if (bNeedEncrypt == true) {
@@ -1539,7 +1539,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 							    uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption, pDevice->wCurrentRate);
 
 				// Generate TX MAC Header
-				vGenerateMACHeader(pDevice, pbyMacHdr, (unsigned short)uDuration, psEthHeader, bNeedEncrypt,
+				vGenerateMACHeader(pDevice, pbyMacHdr, uDuration, psEthHeader, bNeedEncrypt,
 						   wFragType, uDMAIdx, uFragIdx);
 
 				if (bNeedEncrypt == true) {
@@ -1657,7 +1657,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 							    uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption, pDevice->wCurrentRate);
 
 				// Generate TX MAC Header
-				vGenerateMACHeader(pDevice, pbyMacHdr, (unsigned short)uDuration, psEthHeader, bNeedEncrypt,
+				vGenerateMACHeader(pDevice, pbyMacHdr, uDuration, psEthHeader, bNeedEncrypt,
 						   wFragType, uDMAIdx, uFragIdx);
 
 				if (bNeedEncrypt == true) {
@@ -1765,7 +1765,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 					    0, 0, uMACfragNum, byFBOption, pDevice->wCurrentRate);
 
 		// Generate TX MAC Header
-		vGenerateMACHeader(pDevice, pbyMacHdr, (unsigned short)uDuration, psEthHeader, bNeedEncrypt,
+		vGenerateMACHeader(pDevice, pbyMacHdr, uDuration, psEthHeader, bNeedEncrypt,
 				   wFragType, uDMAIdx, 0);
 
 		if (bNeedEncrypt == true) {
@@ -1989,7 +1989,7 @@ void
 vGenerateMACHeader(
 	struct vnt_private *pDevice,
 	unsigned char *pbyBufferAddr,
-	unsigned short wDuration,
+	__le16 wDuration,
 	PSEthernetHeader psEthHeader,
 	bool bNeedEncrypt,
 	unsigned short wFragType,
@@ -2027,7 +2027,7 @@ vGenerateMACHeader(
 	if (bNeedEncrypt)
 		pMACHeader->wFrameCtl |= cpu_to_le16((unsigned short)WLAN_SET_FC_ISWEP(1));
 
-	pMACHeader->wDurationID = cpu_to_le16(wDuration);
+	pMACHeader->wDurationID = le16_to_cpu(wDuration);
 
 	if (pDevice->bLongHeader) {
 		PWLAN_80211HDR_A4 pMACA4Header  = (PWLAN_80211HDR_A4) pbyBufferAddr;
-- 
1.9.1

