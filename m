Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38447 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaCFWqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 17:46:33 -0500
Received: by mail-wg0-f45.google.com with SMTP id l18so3538799wgh.28
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 14:46:32 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/5] staging: vt6655: 64 bit fixes TKIP mic correct sizeof long.
Date: Thu,  6 Mar 2014 22:44:24 +0000
Message-Id: <1394145865-3748-4-git-send-email-tvboxspy@gmail.com> (sfid-20140306_234636_458858_C233C3B2)
In-Reply-To: <1394145865-3748-1-git-send-email-tvboxspy@gmail.com>
References: <1394145865-3748-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct to endian base type __le32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/dpc.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 7663856..771bf35 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -729,27 +729,27 @@ device_receive_frame(
 	// Soft MIC
 	if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_TKIP)) {
 		if (bIsWEP) {
-			unsigned long *pdwMIC_L;
-			unsigned long *pdwMIC_R;
-			unsigned long dwMIC_Priority;
-			unsigned long dwMICKey0 = 0, dwMICKey1 = 0;
+			__le32 *pdwMIC_L;
+			__le32 *pdwMIC_R;
+			__le32 dwMIC_Priority;
+			__le32 dwMICKey0 = 0, dwMICKey1 = 0;
 			u32 dwLocalMIC_L = 0;
 			u32 dwLocalMIC_R = 0;
 			viawget_wpa_header *wpahdr;
 
 			if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-				dwMICKey0 = cpu_to_le32(*(unsigned long *)(&pKey->abyKey[24]));
-				dwMICKey1 = cpu_to_le32(*(unsigned long *)(&pKey->abyKey[28]));
+				dwMICKey0 = cpu_to_le32(*(u32 *)(&pKey->abyKey[24]));
+				dwMICKey1 = cpu_to_le32(*(u32 *)(&pKey->abyKey[28]));
 			} else {
 				if (pDevice->pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
-					dwMICKey0 = cpu_to_le32(*(unsigned long *)(&pKey->abyKey[16]));
-					dwMICKey1 = cpu_to_le32(*(unsigned long *)(&pKey->abyKey[20]));
+					dwMICKey0 = cpu_to_le32(*(u32 *)(&pKey->abyKey[16]));
+					dwMICKey1 = cpu_to_le32(*(u32 *)(&pKey->abyKey[20]));
 				} else if ((pKey->dwKeyIndex & BIT28) == 0) {
-					dwMICKey0 = cpu_to_le32(*(unsigned long *)(&pKey->abyKey[16]));
-					dwMICKey1 = cpu_to_le32(*(unsigned long *)(&pKey->abyKey[20]));
+					dwMICKey0 = cpu_to_le32(*(u32 *)(&pKey->abyKey[16]));
+					dwMICKey1 = cpu_to_le32(*(u32 *)(&pKey->abyKey[20]));
 				} else {
-					dwMICKey0 = cpu_to_le32(*(unsigned long *)(&pKey->abyKey[24]));
-					dwMICKey1 = cpu_to_le32(*(unsigned long *)(&pKey->abyKey[28]));
+					dwMICKey0 = cpu_to_le32(*(u32 *)(&pKey->abyKey[24]));
+					dwMICKey1 = cpu_to_le32(*(u32 *)(&pKey->abyKey[28]));
 				}
 			}
 
@@ -763,14 +763,14 @@ device_receive_frame(
 			MIC_vGetMIC(&dwLocalMIC_L, &dwLocalMIC_R);
 			MIC_vUnInit();
 
-			pdwMIC_L = (unsigned long *)(skb->data + 4 + FrameSize);
-			pdwMIC_R = (unsigned long *)(skb->data + 4 + FrameSize + 4);
+			pdwMIC_L = (__le32 *)(skb->data + 4 + FrameSize);
+			pdwMIC_R = (__le32 *)(skb->data + 4 + FrameSize + 4);
 			//DBG_PRN_GRP12(("RxL: %lx, RxR: %lx\n", *pdwMIC_L, *pdwMIC_R));
 			//DBG_PRN_GRP12(("LocalL: %lx, LocalR: %lx\n", dwLocalMIC_L, dwLocalMIC_R));
 			//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dwMICKey0= %lx,dwMICKey1= %lx \n", dwMICKey0, dwMICKey1);
 
-			if ((cpu_to_le32(*pdwMIC_L) != dwLocalMIC_L) ||
-			    (cpu_to_le32(*pdwMIC_R) != dwLocalMIC_R) ||
+			if ((le32_to_cpu(*pdwMIC_L) != dwLocalMIC_L) ||
+			    (le32_to_cpu(*pdwMIC_R) != dwLocalMIC_R) ||
 			    pDevice->bRxMICFail) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "MIC comparison is fail!\n");
 				pDevice->bRxMICFail = false;
-- 
1.9.0

