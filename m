Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:44165 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbaEaKvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:31 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so3109486wes.9
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/14] staging: vt6656: rename MACvSetKeyEntry to vnt_mac_set_keyentry
Date: Sat, 31 May 2014 11:50:40 +0100
Message-Id: <1401533449-2972-5-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125138_541367_1AFF3AC9)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/key.c | 12 ++++++------
 drivers/staging/vt6656/mac.c |  2 +-
 drivers/staging/vt6656/mac.h |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 4b08654..33e3e5a 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -238,8 +238,8 @@ int KeybSetKey(struct vnt_private *pDevice, PSKeyManagement pTable,
                     pKey->abyKey[15] |= 0x80;
             }
 
-	    MACvSetKeyEntry(pDevice, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx,
-			pbyBSSID, pKey->abyKey);
+	    vnt_mac_set_keyentry(pDevice, pTable->KeyTable[i].wKeyCtl, i,
+					uKeyIdx, pbyBSSID, pKey->abyKey);
 
 		if ((dwKeyIndex & USE_KEYRSC) == 0)
 			pKey->KeyRSC = 0; /* RSC set by NIC */
@@ -308,7 +308,7 @@ int KeybSetKey(struct vnt_private *pDevice, PSKeyManagement pTable,
                 pKey->abyKey[15] |= 0x80;
         }
 
-	MACvSetKeyEntry(pDevice, pTable->KeyTable[j].wKeyCtl, j, uKeyIdx,
+	vnt_mac_set_keyentry(pDevice, pTable->KeyTable[j].wKeyCtl, j, uKeyIdx,
 					pbyBSSID, pKey->abyKey);
 
 		if ((dwKeyIndex & USE_KEYRSC) == 0)
@@ -604,7 +604,7 @@ int KeybSetDefaultKey(struct vnt_private *pDevice, PSKeyManagement pTable,
             pKey->abyKey[15] |= 0x80;
     }
 
-	MACvSetKeyEntry(pDevice, pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl,
+	vnt_mac_set_keyentry(pDevice, pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl,
 		MAX_KEY_TABLE-1, uKeyIdx,
 		pTable->KeyTable[MAX_KEY_TABLE-1].abyBSSID, pKey->abyKey);
 
@@ -700,8 +700,8 @@ int KeybSetAllGroupKey(struct vnt_private *pDevice, PSKeyManagement pTable,
                     pKey->abyKey[15] |= 0x80;
             }
 
-	    MACvSetKeyEntry(pDevice, pTable->KeyTable[i].wKeyCtl, i, uKeyIdx,
-			pTable->KeyTable[i].abyBSSID, pKey->abyKey);
+	    vnt_mac_set_keyentry(pDevice, pTable->KeyTable[i].wKeyCtl, i,
+			uKeyIdx, pTable->KeyTable[i].abyBSSID, pKey->abyKey);
 
 		if ((dwKeyIndex & USE_KEYRSC) == 0)
 			pKey->KeyRSC = 0; /* RSC set by NIC */
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index fe6b4ac..2d5121a 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -119,7 +119,7 @@ void vnt_mac_disable_keyentry(struct vnt_private *priv, u8 entry_idx)
  * Return Value: none
  *
  */
-void MACvSetKeyEntry(struct vnt_private *priv, u16 key_ctl, u32 entry_idx,
+void vnt_mac_set_keyentry(struct vnt_private *priv, u16 key_ctl, u32 entry_idx,
 	u32 key_idx, u8 *addr, u8 *key)
 {
 	struct vnt_mac_set_key set_key;
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index a808794..331c75c 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -418,7 +418,7 @@ void vnt_mac_set_filter(struct vnt_private *, u64);
 void vnt_mac_shutdown(struct vnt_private *);
 void vnt_mac_set_bb_type(struct vnt_private *, u8);
 void vnt_mac_disable_keyentry(struct vnt_private *, u8);
-void MACvSetKeyEntry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
+void vnt_mac_set_keyentry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
 void MACvRegBitsOff(struct vnt_private *, u8, u8);
 void MACvRegBitsOn(struct vnt_private *, u8, u8);
 void MACvWriteWord(struct vnt_private *, u8, u16);
-- 
1.9.1

