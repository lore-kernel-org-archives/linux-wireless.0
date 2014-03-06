Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:41471 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFWqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 17:46:01 -0500
Received: by mail-we0-f181.google.com with SMTP id q58so3955548wes.26
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 14:46:00 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/5] staging: vt6655: 64 bit fixes: MACvSetKeyEntry correct sizeof long,
Date: Thu,  6 Mar 2014 22:44:22 +0000
Message-Id: <1394145865-3748-2-git-send-email-tvboxspy@gmail.com> (sfid-20140306_234605_743557_3392DBF4)
In-Reply-To: <1394145865-3748-1-git-send-email-tvboxspy@gmail.com>
References: <1394145865-3748-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use u32 to correct the pointer of pdwKey and the size of dwData.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/key.c |  8 ++++----
 drivers/staging/vt6655/mac.c | 10 +++++-----
 drivers/staging/vt6655/mac.h |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index eab3b41..78b5809 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -242,7 +242,7 @@ bool KeybSetKey(
 				if (uKeyLength == WLAN_WEP104_KEYLEN)
 					pKey->abyKey[15] |= 0x80;
 			}
-			MACvSetKeyEntry(dwIoBase, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx, pbyBSSID, (unsigned long *)pKey->abyKey, byLocalID);
+			MACvSetKeyEntry(dwIoBase, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx, pbyBSSID, (u32 *)pKey->abyKey, byLocalID);
 
 			if ((dwKeyIndex & USE_KEYRSC) == 0) {
 				// RSC set by NIC
@@ -306,7 +306,7 @@ bool KeybSetKey(
 			if (uKeyLength == WLAN_WEP104_KEYLEN)
 				pKey->abyKey[15] |= 0x80;
 		}
-		MACvSetKeyEntry(dwIoBase, pTable->KeyTable[j].wKeyCtl, j, uKeyIdx, pbyBSSID, (unsigned long *)pKey->abyKey, byLocalID);
+		MACvSetKeyEntry(dwIoBase, pTable->KeyTable[j].wKeyCtl, j, uKeyIdx, pbyBSSID, (u32 *)pKey->abyKey, byLocalID);
 
 		if ((dwKeyIndex & USE_KEYRSC) == 0) {
 			// RSC set by NIC
@@ -670,7 +670,7 @@ bool KeybSetDefaultKey(
 		if (uKeyLength == WLAN_WEP104_KEYLEN)
 			pKey->abyKey[15] |= 0x80;
 	}
-	MACvSetKeyEntry(dwIoBase, pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl, MAX_KEY_TABLE-1, uKeyIdx, pTable->KeyTable[MAX_KEY_TABLE-1].abyBSSID, (unsigned long *)pKey->abyKey, byLocalID);
+	MACvSetKeyEntry(dwIoBase, pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl, MAX_KEY_TABLE-1, uKeyIdx, pTable->KeyTable[MAX_KEY_TABLE-1].abyBSSID, (u32 *)pKey->abyKey, byLocalID);
 
 	if ((dwKeyIndex & USE_KEYRSC) == 0) {
 		// RSC set by NIC
@@ -766,7 +766,7 @@ bool KeybSetAllGroupKey(
 				if (uKeyLength == WLAN_WEP104_KEYLEN)
 					pKey->abyKey[15] |= 0x80;
 			}
-			MACvSetKeyEntry(dwIoBase, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx, pTable->KeyTable[i].abyBSSID, (unsigned long *)pKey->abyKey, byLocalID);
+			MACvSetKeyEntry(dwIoBase, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx, pTable->KeyTable[i].abyBSSID, (u32 *)pKey->abyKey, byLocalID);
 
 			if ((dwKeyIndex & USE_KEYRSC) == 0) {
 				// RSC set by NIC
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 21bd8a1..0ec079f 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -1428,10 +1428,10 @@ bool MACbPSWakeup(unsigned long dwIoBase)
  */
 
 void MACvSetKeyEntry(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx,
-		     unsigned int uKeyIdx, unsigned char *pbyAddr, unsigned long *pdwKey, unsigned char byLocalID)
+		     unsigned int uKeyIdx, unsigned char *pbyAddr, u32 *pdwKey, unsigned char byLocalID)
 {
 	unsigned short wOffset;
-	unsigned long dwData;
+	u32 dwData;
 	int     ii;
 
 	if (byLocalID <= 1)
@@ -1445,7 +1445,7 @@ void MACvSetKeyEntry(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned in
 	dwData |= wKeyCtl;
 	dwData <<= 16;
 	dwData |= MAKEWORD(*(pbyAddr+4), *(pbyAddr+5));
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "1. wOffset: %d, Data: %lX, KeyCtl:%X\n", wOffset, dwData, wKeyCtl);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "1. wOffset: %d, Data: %X, KeyCtl:%X\n", wOffset, dwData, wKeyCtl);
 
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
 	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
@@ -1460,7 +1460,7 @@ void MACvSetKeyEntry(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned in
 	dwData |= *(pbyAddr+1);
 	dwData <<= 8;
 	dwData |= *(pbyAddr+0);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "2. wOffset: %d, Data: %lX\n", wOffset, dwData);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "2. wOffset: %d, Data: %X\n", wOffset, dwData);
 
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
 	VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
@@ -1470,7 +1470,7 @@ void MACvSetKeyEntry(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned in
 	wOffset += (uKeyIdx * 4);
 	for (ii = 0; ii < 4; ii++) {
 		// always push 128 bits
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "3.(%d) wOffset: %d, Data: %lX\n", ii, wOffset+ii, *pdwKey);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "3.(%d) wOffset: %d, Data: %X\n", ii, wOffset+ii, *pdwKey);
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
 		VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 3f177f7..4615db0 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -1038,7 +1038,7 @@ bool MACbFlushSYNCFifo(unsigned long dwIoBase);
 bool MACbPSWakeup(unsigned long dwIoBase);
 
 void MACvSetKeyEntry(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx,
-		     unsigned int uKeyIdx, unsigned char *pbyAddr, unsigned long *pdwKey, unsigned char byLocalID);
+		     unsigned int uKeyIdx, unsigned char *pbyAddr, u32 *pdwKey, unsigned char byLocalID);
 void MACvDisableKeyEntry(unsigned long dwIoBase, unsigned int uEntryIdx);
 void MACvSetDefaultKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
 			    unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID);
-- 
1.9.0

