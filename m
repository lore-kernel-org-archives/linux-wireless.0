Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:41957 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaCFWqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 17:46:11 -0500
Received: by mail-we0-f173.google.com with SMTP id w61so3962922wes.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 14:46:10 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/5] staging: vt6655: 64 bit fixes :TKIP mode micheal.c sizeof long.
Date: Thu,  6 Mar 2014 22:44:23 +0000
Message-Id: <1394145865-3748-3-git-send-email-tvboxspy@gmail.com> (sfid-20140306_234616_054041_D7FFD590)
In-Reply-To: <1394145865-3748-1-git-send-email-tvboxspy@gmail.com>
References: <1394145865-3748-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix MIC_vGetMIC and MIC_vInit to u32

Fix calling functions to u32

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/dpc.c     |  4 ++--
 drivers/staging/vt6655/michael.c | 14 +++++++-------
 drivers/staging/vt6655/michael.h |  6 ++++--
 drivers/staging/vt6655/rxtx.c    | 32 ++++++++++++++++----------------
 4 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 0a29c90..7663856 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -733,8 +733,8 @@ device_receive_frame(
 			unsigned long *pdwMIC_R;
 			unsigned long dwMIC_Priority;
 			unsigned long dwMICKey0 = 0, dwMICKey1 = 0;
-			unsigned long dwLocalMIC_L = 0;
-			unsigned long dwLocalMIC_R = 0;
+			u32 dwLocalMIC_L = 0;
+			u32 dwLocalMIC_R = 0;
 			viawget_wpa_header *wpahdr;
 
 			if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
diff --git a/drivers/staging/vt6655/michael.c b/drivers/staging/vt6655/michael.c
index 7ea5f7f..ade4c85 100644
--- a/drivers/staging/vt6655/michael.c
+++ b/drivers/staging/vt6655/michael.c
@@ -53,14 +53,14 @@
 */
 static void s_vClear(void);                       // Clear the internal message,
 // resets the object to the state just after construction.
-static void s_vSetKey(unsigned long dwK0, unsigned long dwK1);
+static void s_vSetKey(u32  dwK0, u32  dwK1);
 static void s_vAppendByte(unsigned char b);            // Add a single byte to the internal message
 
 /*---------------------  Export Variables  --------------------------*/
-static unsigned long L, R;           // Current state
+static u32 L, R;	/* Current state */
 
-static unsigned long K0, K1;         // Key
-static unsigned long M;              // Message accumulator (single word)
+static u32 K0, K1;	/* Key */
+static u32 M;		/* Message accumulator (single word) */
 static unsigned int nBytesInM;      // # bytes in M
 
 /*---------------------  Export Functions  --------------------------*/
@@ -98,7 +98,7 @@ static void s_vClear(void)
 	M = 0;
 }
 
-static void s_vSetKey(unsigned long dwK0, unsigned long dwK1)
+static void s_vSetKey(u32 dwK0, u32 dwK1)
 {
 	// Set the key
 	K0 = dwK0;
@@ -129,7 +129,7 @@ static void s_vAppendByte(unsigned char b)
 	}
 }
 
-void MIC_vInit(unsigned long dwK0, unsigned long dwK1)
+void MIC_vInit(u32 dwK0, u32 dwK1)
 {
 	// Set the key
 	s_vSetKey(dwK0, dwK1);
@@ -155,7 +155,7 @@ void MIC_vAppend(unsigned char *src, unsigned int nBytes)
 	}
 }
 
-void MIC_vGetMIC(unsigned long *pdwL, unsigned long *pdwR)
+void MIC_vGetMIC(u32 *pdwL, u32 *pdwR)
 {
 	// Append the minimum padding
 	s_vAppendByte(0x5a);
diff --git a/drivers/staging/vt6655/michael.h b/drivers/staging/vt6655/michael.h
index 387d206..f6c2c15 100644
--- a/drivers/staging/vt6655/michael.h
+++ b/drivers/staging/vt6655/michael.h
@@ -31,11 +31,13 @@
 #ifndef __MICHAEL_H__
 #define __MICHAEL_H__
 
+#include <linux/types.h>
+
 /*---------------------  Export Definitions -------------------------*/
 
 /*---------------------  Export Types  ------------------------------*/
 
-void MIC_vInit(unsigned long dwK0, unsigned long dwK1);
+void MIC_vInit(u32 dwK0, u32 dwK1);
 
 void MIC_vUnInit(void);
 
@@ -44,7 +46,7 @@ void MIC_vAppend(unsigned char *src, unsigned int nBytes);
 
 /* Get the MIC result. Destination should accept 8 bytes of result. */
 /* This also resets the message to empty. */
-void MIC_vGetMIC(unsigned long *pdwL, unsigned long *pdwR);
+void MIC_vGetMIC(u32 *pdwL, u32 *pdwR);
 
 /*---------------------  Export Macros ------------------------------*/
 
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 6affd6e..222c224 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1259,8 +1259,8 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 	unsigned int cbMICHDR = 0;
 	unsigned long dwMICKey0, dwMICKey1;
 	unsigned long dwMIC_Priority;
-	unsigned long *pdwMIC_L;
-	unsigned long *pdwMIC_R;
+	u32 *pdwMIC_L;
+	u32 *pdwMIC_R;
 	unsigned long dwSafeMIC_L, dwSafeMIC_R; //Fix "Last Frag Size" < "MIC length".
 	bool bMIC2Frag = false;
 	unsigned int uMICFragLen = 0;
@@ -1624,10 +1624,10 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 					if (bMIC2Frag == false) {
 						if (uTmpLen != 0)
 							MIC_vAppend((pbyBuffer + uLength), uTmpLen);
-						pdwMIC_L = (unsigned long *)(pbyBuffer + uLength + uTmpLen);
-						pdwMIC_R = (unsigned long *)(pbyBuffer + uLength + uTmpLen + 4);
+						pdwMIC_L = (u32 *)(pbyBuffer + uLength + uTmpLen);
+						pdwMIC_R = (u32 *)(pbyBuffer + uLength + uTmpLen + 4);
 						MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Last MIC:%lX, %lX\n", *pdwMIC_L, *pdwMIC_R);
+						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Last MIC:%X, %X\n", *pdwMIC_L, *pdwMIC_R);
 					} else {
 						if (uMICFragLen >= 4) {
 							memcpy((pbyBuffer + uLength), ((unsigned char *)&dwSafeMIC_R + (uMICFragLen - 4)),
@@ -1744,8 +1744,8 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 						uMICFragLen = cbFragPayloadSize - uTmpLen;
 						ASSERT(uMICFragLen < cbMIClen);
 
-						pdwMIC_L = (unsigned long *)(pbyBuffer + uLength + uTmpLen);
-						pdwMIC_R = (unsigned long *)(pbyBuffer + uLength + uTmpLen + 4);
+						pdwMIC_L = (u32 *)(pbyBuffer + uLength + uTmpLen);
+						pdwMIC_R = (u32 *)(pbyBuffer + uLength + uTmpLen + 4);
 						MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
 						dwSafeMIC_L = *pdwMIC_L;
 						dwSafeMIC_R = *pdwMIC_R;
@@ -1759,7 +1759,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 						  }
 						  DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "\n");
 						*/
-						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get MIC:%lX, %lX\n", *pdwMIC_L, *pdwMIC_R);
+						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get MIC:%X, %X\n", *pdwMIC_L, *pdwMIC_R);
 					}
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Middle frag len: %d\n", uTmpLen);
 					/*
@@ -1873,8 +1873,8 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 
 			MIC_vAppend((pbyBuffer + uLength - cb802_1_H_len), cbFrameBodySize);
 
-			pdwMIC_L = (unsigned long *)(pbyBuffer + uLength - cb802_1_H_len + cbFrameBodySize);
-			pdwMIC_R = (unsigned long *)(pbyBuffer + uLength - cb802_1_H_len + cbFrameBodySize + 4);
+			pdwMIC_L = (u32 *)(pbyBuffer + uLength - cb802_1_H_len + cbFrameBodySize);
+			pdwMIC_R = (u32 *)(pbyBuffer + uLength - cb802_1_H_len + cbFrameBodySize + 4);
 
 			MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
 			MIC_vUnInit();
@@ -1887,7 +1887,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "uLength: %d, %d\n", uLength, cbFrameBodySize);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "cbReqCount:%d, %d, %d, %d\n", cbReqCount, cbHeaderLength, uPadding, cbIVlen);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC:%lx, %lx\n", *pdwMIC_L, *pdwMIC_R);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC:%x, %x\n", *pdwMIC_L, *pdwMIC_R);
 /*
   for (ii = 0; ii < 8; ii++) {
   DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", *(((unsigned char *)(pdwMIC_L) + ii)));
@@ -2594,8 +2594,8 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 	unsigned int uLength = 0;
 	unsigned long dwMICKey0, dwMICKey1;
 	unsigned long dwMIC_Priority;
-	unsigned long *pdwMIC_L;
-	unsigned long *pdwMIC_R;
+	u32 *pdwMIC_L;
+	u32 *pdwMIC_R;
 	unsigned short wTxBufSize;
 	unsigned int cbMacHdLen;
 	SEthernetHeader sEthHeader;
@@ -2855,8 +2855,8 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 
 			MIC_vAppend((pbyTxBufferAddr + uLength), cbFrameBodySize);
 
-			pdwMIC_L = (unsigned long *)(pbyTxBufferAddr + uLength + cbFrameBodySize);
-			pdwMIC_R = (unsigned long *)(pbyTxBufferAddr + uLength + cbFrameBodySize + 4);
+			pdwMIC_L = (u32 *)(pbyTxBufferAddr + uLength + cbFrameBodySize);
+			pdwMIC_R = (u32 *)(pbyTxBufferAddr + uLength + cbFrameBodySize + 4);
 
 			MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
 			MIC_vUnInit();
@@ -2869,7 +2869,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "uLength: %d, %d\n", uLength, cbFrameBodySize);
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "cbReqCount:%d, %d, %d, %d\n", cbReqCount, cbHeaderSize, uPadding, cbIVlen);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC:%lx, %lx\n", *pdwMIC_L, *pdwMIC_R);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC:%x, %x\n", *pdwMIC_L, *pdwMIC_R);
 
 		}
 
-- 
1.9.0

