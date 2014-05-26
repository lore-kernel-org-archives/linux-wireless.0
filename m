Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33041 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaEZNAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:01 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so7887339wgg.33
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/11] staging: vt6656: MACvSetKeyEntry change u32 pdwKey to u8 pointer
Date: Mon, 26 May 2014 13:58:58 +0100
Message-Id: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150006_779032_8715C846)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change pdwKey u32 pointer to key u8 pointer.

Callers are already u8 remove u32 pointer cast.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/key.c | 15 +++++++++++----
 drivers/staging/vt6656/mac.c |  5 ++---
 drivers/staging/vt6656/mac.h |  2 +-
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index a88c6b18..9283612 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -247,7 +247,9 @@ int KeybSetKey(struct vnt_private *pDevice, PSKeyManagement pTable,
                 if (uKeyLength == WLAN_WEP104_KEYLEN)
                     pKey->abyKey[15] |= 0x80;
             }
-            MACvSetKeyEntry(pDevice, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx, pbyBSSID, (u32 *)pKey->abyKey);
+
+	    MACvSetKeyEntry(pDevice, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx,
+			pbyBSSID, pKey->abyKey);
 
 		if ((dwKeyIndex & USE_KEYRSC) == 0)
 			pKey->KeyRSC = 0; /* RSC set by NIC */
@@ -315,7 +317,9 @@ int KeybSetKey(struct vnt_private *pDevice, PSKeyManagement pTable,
             if (uKeyLength == WLAN_WEP104_KEYLEN)
                 pKey->abyKey[15] |= 0x80;
         }
-        MACvSetKeyEntry(pDevice, pTable->KeyTable[j].wKeyCtl, j, uKeyIdx, pbyBSSID, (u32 *)pKey->abyKey);
+
+	MACvSetKeyEntry(pDevice, pTable->KeyTable[j].wKeyCtl, j, uKeyIdx,
+					pbyBSSID, pKey->abyKey);
 
 		if ((dwKeyIndex & USE_KEYRSC) == 0)
 			pKey->KeyRSC = 0; /* RSC set by NIC */
@@ -610,7 +614,9 @@ int KeybSetDefaultKey(struct vnt_private *pDevice, PSKeyManagement pTable,
             pKey->abyKey[15] |= 0x80;
     }
 
-    MACvSetKeyEntry(pDevice, pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl, MAX_KEY_TABLE-1, uKeyIdx, pTable->KeyTable[MAX_KEY_TABLE-1].abyBSSID, (u32 *) pKey->abyKey);
+	MACvSetKeyEntry(pDevice, pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl,
+		MAX_KEY_TABLE-1, uKeyIdx,
+		pTable->KeyTable[MAX_KEY_TABLE-1].abyBSSID, pKey->abyKey);
 
 		if ((dwKeyIndex & USE_KEYRSC) == 0)
 			pKey->KeyRSC = 0; /* RSC set by NIC */
@@ -704,7 +710,8 @@ int KeybSetAllGroupKey(struct vnt_private *pDevice, PSKeyManagement pTable,
                     pKey->abyKey[15] |= 0x80;
             }
 
-            MACvSetKeyEntry(pDevice, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx, pTable->KeyTable[i].abyBSSID, (u32 *) pKey->abyKey);
+	    MACvSetKeyEntry(pDevice, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx,
+			pTable->KeyTable[i].abyBSSID, pKey->abyKey);
 
 		if ((dwKeyIndex & USE_KEYRSC) == 0)
 			pKey->KeyRSC = 0; /* RSC set by NIC */
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index bc72144..a030c59 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -123,10 +123,9 @@ void MACvDisableKeyEntry(struct vnt_private *priv, u8 entry_idx)
  *
  */
 void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
-	u32 uKeyIdx, u8 *pbyAddr, u32 *pdwKey)
+	u32 uKeyIdx, u8 *pbyAddr, u8 *key)
 {
 	struct vnt_mac_set_key set_key;
-	u8 *pbyKey = (u8 *)pdwKey;
 	u16 wOffset;
 
 	if (pDevice->byLocalID <= MAC_REVISION_A1)
@@ -142,7 +141,7 @@ void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
 	/* swap over swap[0] and swap[1] to get correct write order */
 	swap(set_key.u.swap[0], set_key.u.swap[1]);
 
-	memcpy(set_key.key, pbyKey, WLAN_KEY_LEN_CCMP);
+	memcpy(set_key.key, key, WLAN_KEY_LEN_CCMP);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 		"offset %d key ctl %d set key %24ph\n",
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 8100685..6e45d47 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -418,7 +418,7 @@ void MACvWriteMultiAddr(struct vnt_private *, u64);
 void MACbShutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u8);
-void MACvSetKeyEntry(struct vnt_private *, u16, u32, u32, u8 *, u32 *);
+void MACvSetKeyEntry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
 void MACvRegBitsOff(struct vnt_private *, u8, u8);
 void MACvRegBitsOn(struct vnt_private *, u8, u8);
 void MACvWriteWord(struct vnt_private *, u8, u16);
-- 
1.9.1

