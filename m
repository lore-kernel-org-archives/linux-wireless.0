Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56366 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaCFWr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 17:47:29 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so1613706wgh.10
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 14:47:28 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/5] staging: vt6655: 64 bit fix sizeof long TKIP mic
Date: Thu,  6 Mar 2014 22:44:25 +0000
Message-Id: <1394145865-3748-5-git-send-email-tvboxspy@gmail.com> (sfid-20140306_234732_464812_A60F66A3)
In-Reply-To: <1394145865-3748-1-git-send-email-tvboxspy@gmail.com>
References: <1394145865-3748-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change to u32 and fix debug message format

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 222c224..c2653eb 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1257,11 +1257,11 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 //    unsigned char abyTmp[8];
 //    unsigned long dwCRC;
 	unsigned int cbMICHDR = 0;
-	unsigned long dwMICKey0, dwMICKey1;
-	unsigned long dwMIC_Priority;
+	u32 dwMICKey0, dwMICKey1;
+	u32 dwMIC_Priority;
 	u32 *pdwMIC_L;
 	u32 *pdwMIC_R;
-	unsigned long dwSafeMIC_L, dwSafeMIC_R; //Fix "Last Frag Size" < "MIC length".
+	u32 dwSafeMIC_L, dwSafeMIC_R; /* Fix "Last Frag Size" < "MIC length". */
 	bool bMIC2Frag = false;
 	unsigned int uMICFragLen = 0;
 	unsigned int uMACfragNum = 1;
@@ -1434,21 +1434,21 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 //////////////////////////////////////////////////////////////////
 	if ((bNeedEncrypt == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
 		if (pDevice->pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
-			dwMICKey0 = *(unsigned long *)(&pTransmitKey->abyKey[16]);
-			dwMICKey1 = *(unsigned long *)(&pTransmitKey->abyKey[20]);
+			dwMICKey0 = *(u32 *)(&pTransmitKey->abyKey[16]);
+			dwMICKey1 = *(u32 *)(&pTransmitKey->abyKey[20]);
 		} else if ((pTransmitKey->dwKeyIndex & AUTHENTICATOR_KEY) != 0) {
-			dwMICKey0 = *(unsigned long *)(&pTransmitKey->abyKey[16]);
-			dwMICKey1 = *(unsigned long *)(&pTransmitKey->abyKey[20]);
+			dwMICKey0 = *(u32 *)(&pTransmitKey->abyKey[16]);
+			dwMICKey1 = *(u32 *)(&pTransmitKey->abyKey[20]);
 		} else {
-			dwMICKey0 = *(unsigned long *)(&pTransmitKey->abyKey[24]);
-			dwMICKey1 = *(unsigned long *)(&pTransmitKey->abyKey[28]);
+			dwMICKey0 = *(u32 *)(&pTransmitKey->abyKey[24]);
+			dwMICKey1 = *(u32 *)(&pTransmitKey->abyKey[28]);
 		}
 		// DO Software Michael
 		MIC_vInit(dwMICKey0, dwMICKey1);
 		MIC_vAppend((unsigned char *)&(psEthHeader->abyDstAddr[0]), 12);
 		dwMIC_Priority = 0;
 		MIC_vAppend((unsigned char *)&dwMIC_Priority, 4);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC KEY: %lX, %lX\n", dwMICKey0, dwMICKey1);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC KEY: %X, %X\n", dwMICKey0, dwMICKey1);
 	}
 
 ///////////////////////////////////////////////////////////////////
@@ -2592,8 +2592,8 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 	unsigned int uPadding = 0;
 	unsigned int cbMICHDR = 0;
 	unsigned int uLength = 0;
-	unsigned long dwMICKey0, dwMICKey1;
-	unsigned long dwMIC_Priority;
+	u32 dwMICKey0, dwMICKey1;
+	u32 dwMIC_Priority;
 	u32 *pdwMIC_L;
 	u32 *pdwMIC_R;
 	unsigned short wTxBufSize;
@@ -2841,15 +2841,15 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 		}
 
 		if ((pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
-			dwMICKey0 = *(unsigned long *)(&pTransmitKey->abyKey[16]);
-			dwMICKey1 = *(unsigned long *)(&pTransmitKey->abyKey[20]);
+			dwMICKey0 = *(u32 *)(&pTransmitKey->abyKey[16]);
+			dwMICKey1 = *(u32 *)(&pTransmitKey->abyKey[20]);
 
 			// DO Software Michael
 			MIC_vInit(dwMICKey0, dwMICKey1);
 			MIC_vAppend((unsigned char *)&(sEthHeader.abyDstAddr[0]), 12);
 			dwMIC_Priority = 0;
 			MIC_vAppend((unsigned char *)&dwMIC_Priority, 4);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "DMA0_tx_8021:MIC KEY: %lX, %lX\n", dwMICKey0, dwMICKey1);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "DMA0_tx_8021:MIC KEY: %X, %X\n", dwMICKey0, dwMICKey1);
 
 			uLength = cbHeaderSize + cbMacHdLen + uPadding + cbIVlen;
 
-- 
1.9.0

