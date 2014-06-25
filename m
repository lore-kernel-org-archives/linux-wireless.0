Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61013 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaFYUVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:41 -0400
Received: by mail-wi0-f174.google.com with SMTP id bs8so8637255wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 22/34] staging: vt6656: dead code remove old key functions
Date: Wed, 25 Jun 2014 21:19:59 +0100
Message-Id: <1403727611-6825-23-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223007_571080_F332984E)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |   1 -
 drivers/staging/vt6656/key.c    | 694 ----------------------------------------
 drivers/staging/vt6656/key.h    |  69 ----
 drivers/staging/vt6656/wcmd.c   |   4 -
 4 files changed, 768 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index b6ae34f..a145081 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -635,7 +635,6 @@ struct vnt_private {
 	NDIS_802_11_WEP_STATUS eEncryptionStatus;
 	int  bTransmitKey;
 	NDIS_802_11_WEP_STATUS eOldEncryptionStatus;
-	SKeyManagement sKey;
 	u32 dwIVCounter;
 
 	u8 abyPRNG[WLAN_WEPMAX_KEYLEN+3];
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 3513066..a7c7a2d 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -26,709 +26,15 @@
  * Date: May 29, 2003
  *
  * Functions:
- *      KeyvInitTable - Init Key management table
- *      KeybGetKey - Get Key from table
- *      KeybSetKey - Set Key to table
- *      KeybRemoveKey - Remove Key from table
- *      KeybGetTransmitKey - Get Transmit Key from table
  *
  * Revision History:
  *
  */
 
 #include "mac.h"
-#include "tmacro.h"
 #include "key.h"
 #include "usbpipe.h"
 
-static int          msglevel                =MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-
-static void s_vCheckKeyTableValid(struct vnt_private *pDevice,
-	PSKeyManagement pTable)
-{
-	int i;
-	u16 wLength = 0;
-	u8 pbyData[MAX_KEY_TABLE];
-
-    for (i=0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse == true) &&
-            (pTable->KeyTable[i].PairwiseKey.bKeyValid == false) &&
-            (pTable->KeyTable[i].GroupKey[0].bKeyValid == false) &&
-            (pTable->KeyTable[i].GroupKey[1].bKeyValid == false) &&
-            (pTable->KeyTable[i].GroupKey[2].bKeyValid == false) &&
-            (pTable->KeyTable[i].GroupKey[3].bKeyValid == false)
-            ) {
-
-            pTable->KeyTable[i].bInUse = false;
-            pTable->KeyTable[i].wKeyCtl = 0;
-            pTable->KeyTable[i].bSoftWEP = false;
-            pbyData[wLength++] = (u8) i;
-        }
-    }
-
-	if (wLength != 0)
-		vnt_control_out(pDevice, MESSAGE_TYPE_CLRKEYENTRY,
-			0, 0, wLength, pbyData);
-
-}
-
-/*
- * Description: Init Key management table
- *
- * Parameters:
- *  In:
- *      pTable          - Pointer to Key table
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void KeyvInitTable(struct vnt_private *pDevice, PSKeyManagement pTable)
-{
-	int i, jj;
-	u8 pbyData[MAX_KEY_TABLE+1];
-
-    for (i=0;i<MAX_KEY_TABLE;i++) {
-        pTable->KeyTable[i].bInUse = false;
-        pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
-	pTable->KeyTable[i].PairwiseKey.pvKeyTable =
-	  (void *)&pTable->KeyTable[i];
-        for (jj=0; jj < MAX_GROUP_KEY; jj++) {
-            pTable->KeyTable[i].GroupKey[jj].bKeyValid = false;
-	    pTable->KeyTable[i].GroupKey[jj].pvKeyTable =
-	      (void *) &(pTable->KeyTable[i]);
-        }
-        pTable->KeyTable[i].wKeyCtl = 0;
-        pTable->KeyTable[i].dwGTKeyIndex = 0;
-        pTable->KeyTable[i].bSoftWEP = false;
-        pbyData[i] = (u8) i;
-    }
-    pbyData[i] = (u8) i;
-
-	vnt_control_out(pDevice, MESSAGE_TYPE_CLRKEYENTRY,
-			0, 0, 11, pbyData);
-
-    return;
-}
-
-/*
- * Description: Get Key from table
- *
- * Parameters:
- *  In:
- *      pTable          - Pointer to Key table
- *      pbyBSSID        - BSSID of Key
- *      dwKeyIndex      - Key Index (0xFFFFFFFF means pairwise key)
- *  Out:
- *      pKey            - Key return
- *
- * Return Value: true if found otherwise false
- *
- */
-int KeybGetKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyIndex,
-	PSKeyItem *pKey)
-{
-	int i;
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybGetKey()\n");
-
-    *pKey = NULL;
-    for (i=0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse == true) &&
-	    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
-            if (dwKeyIndex == 0xFFFFFFFF) {
-                if (pTable->KeyTable[i].PairwiseKey.bKeyValid == true) {
-                    *pKey = &(pTable->KeyTable[i].PairwiseKey);
-                    return (true);
-                }
-                else {
-                    return (false);
-                }
-            } else if (dwKeyIndex < MAX_GROUP_KEY) {
-                if (pTable->KeyTable[i].GroupKey[dwKeyIndex].bKeyValid == true) {
-                    *pKey = &(pTable->KeyTable[i].GroupKey[dwKeyIndex]);
-                    return (true);
-                }
-                else {
-                    return (false);
-                }
-            }
-            else {
-                return (false);
-            }
-        }
-    }
-    return (false);
-}
-
-/*
- * Description: Set Key to table
- *
- * Parameters:
- *  In:
- *      pTable          - Pointer to Key table
- *      pbyBSSID        - BSSID of Key
- *      dwKeyIndex      - Key index (reference to NDIS DDK)
- *      uKeyLength      - Key length
- *      KeyRSC          - Key RSC
- *      pbyKey          - Pointer to key
- *  Out:
- *      none
- *
- * Return Value: true if success otherwise false
- *
- */
-int KeybSetKey(struct vnt_private *pDevice, PSKeyManagement pTable,
-	u8 *pbyBSSID, u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
-	u8 byKeyDecMode)
-{
-	PSKeyItem   pKey;
-	int i, j, ii;
-	u32 uKeyIdx;
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-		"Enter KeybSetKey: %X\n", dwKeyIndex);
-
-    j = (MAX_KEY_TABLE-1);
-    for (i=0;i<(MAX_KEY_TABLE-1);i++) {
-        if ((pTable->KeyTable[i].bInUse == false) &&
-            (j == (MAX_KEY_TABLE-1))) {
-            // found empty table
-            j = i;
-        }
-        if ((pTable->KeyTable[i].bInUse == true) &&
-	    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
-            // found table already exist
-            if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
-                // Pairwise key
-                pKey = &(pTable->KeyTable[i].PairwiseKey);
-                pTable->KeyTable[i].wKeyCtl &= 0xFFF0;          // clear pairwise key control filed
-                pTable->KeyTable[i].wKeyCtl |= byKeyDecMode;
-                uKeyIdx = 4;                                    // use HW key entry 4 for pairwise key
-            } else {
-                // Group key
-                if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY)
-                    return (false);
-                pKey = &(pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF]);
-                if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
-                    // Group transmit key
-                    pTable->KeyTable[i].dwGTKeyIndex = dwKeyIndex;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"Group transmit key(R)[%X]: %d\n",
-					pTable->KeyTable[i].dwGTKeyIndex, i);
-                }
-                pTable->KeyTable[i].wKeyCtl &= 0xFF0F;          // clear group key control filed
-                pTable->KeyTable[i].wKeyCtl |= (byKeyDecMode << 4);
-                pTable->KeyTable[i].wKeyCtl |= 0x0040;          // use group key for group address
-                uKeyIdx = (dwKeyIndex & 0x000000FF);
-            }
-            pTable->KeyTable[i].wKeyCtl |= 0x8000;              // enable on-fly
-
-            pKey->bKeyValid = true;
-            pKey->uKeyLength = uKeyLength;
-            pKey->dwKeyIndex = dwKeyIndex;
-            pKey->byCipherSuite = byKeyDecMode;
-            memcpy(pKey->abyKey, pbyKey, uKeyLength);
-            if (byKeyDecMode == KEY_CTL_WEP) {
-                if (uKeyLength == WLAN_WEP40_KEYLEN)
-                    pKey->abyKey[15] &= 0x7F;
-                if (uKeyLength == WLAN_WEP104_KEYLEN)
-                    pKey->abyKey[15] |= 0x80;
-            }
-
-	    vnt_mac_set_keyentry(pDevice, pTable->KeyTable[i].wKeyCtl, i,
-					uKeyIdx, pbyBSSID, pKey->abyKey);
-
-		if ((dwKeyIndex & USE_KEYRSC) == 0)
-			pKey->KeyRSC = 0; /* RSC set by NIC */
-		else
-			pKey->KeyRSC = *KeyRSC;
-
-            pKey->dwTSC47_16 = 0;
-            pKey->wTSC15_0 = 0;
-
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybSetKey(R): \n");
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->bKeyValid: %d\n ", pKey->bKeyValid);
-            //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->uKeyLength: %d\n ", pKey->uKeyLength);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->abyKey: ");
-            for (ii = 0; ii < pKey->uKeyLength; ii++) {
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pKey->abyKey[ii]);
-            }
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %x\n ",
-			pKey->dwTSC47_16);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ",
-			pKey->wTSC15_0);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %x\n ",
-			pKey->dwKeyIndex);
-
-            return (true);
-        }
-    }
-    if (j < (MAX_KEY_TABLE-1)) {
-	memcpy(pTable->KeyTable[j].abyBSSID, pbyBSSID, ETH_ALEN);
-        pTable->KeyTable[j].bInUse = true;
-        if ((dwKeyIndex & PAIRWISE_KEY) != 0)  {
-            // Pairwise key
-            pKey = &(pTable->KeyTable[j].PairwiseKey);
-            pTable->KeyTable[j].wKeyCtl &= 0xFFF0;          // clear pairwise key control filed
-            pTable->KeyTable[j].wKeyCtl |= byKeyDecMode;
-            uKeyIdx = 4;                                    // use HW key entry 4 for pairwise key
-        } else {
-            // Group key
-            if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY)
-                return (false);
-            pKey = &(pTable->KeyTable[j].GroupKey[dwKeyIndex & 0x000000FF]);
-            if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
-                // Group transmit key
-                pTable->KeyTable[j].dwGTKeyIndex = dwKeyIndex;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Group transmit key(N)[%X]: %d\n",
-				pTable->KeyTable[j].dwGTKeyIndex, j);
-            }
-            pTable->KeyTable[j].wKeyCtl &= 0xFF0F;          // clear group key control filed
-            pTable->KeyTable[j].wKeyCtl |= (byKeyDecMode << 4);
-            pTable->KeyTable[j].wKeyCtl |= 0x0040;          // use group key for group address
-            uKeyIdx = (dwKeyIndex & 0x000000FF);
-        }
-        pTable->KeyTable[j].wKeyCtl |= 0x8000;              // enable on-fly
-
-        pKey->bKeyValid = true;
-        pKey->uKeyLength = uKeyLength;
-        pKey->dwKeyIndex = dwKeyIndex;
-        pKey->byCipherSuite = byKeyDecMode;
-        memcpy(pKey->abyKey, pbyKey, uKeyLength);
-        if (byKeyDecMode == KEY_CTL_WEP) {
-            if (uKeyLength == WLAN_WEP40_KEYLEN)
-                pKey->abyKey[15] &= 0x7F;
-            if (uKeyLength == WLAN_WEP104_KEYLEN)
-                pKey->abyKey[15] |= 0x80;
-        }
-
-	vnt_mac_set_keyentry(pDevice, pTable->KeyTable[j].wKeyCtl, j, uKeyIdx,
-					pbyBSSID, pKey->abyKey);
-
-		if ((dwKeyIndex & USE_KEYRSC) == 0)
-			pKey->KeyRSC = 0; /* RSC set by NIC */
-		else
-			pKey->KeyRSC = *KeyRSC;
-
-        pKey->dwTSC47_16 = 0;
-        pKey->wTSC15_0 = 0;
-
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybSetKey(N): \n");
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->bKeyValid: %d\n ", pKey->bKeyValid);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->uKeyLength: %d\n ", (int)pKey->uKeyLength);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->abyKey: ");
-        for (ii = 0; ii < pKey->uKeyLength; ii++) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pKey->abyKey[ii]);
-        }
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %x\n ",
-		pKey->dwTSC47_16);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ", pKey->wTSC15_0);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %x\n ",
-		pKey->dwKeyIndex);
-
-        return (true);
-    }
-    return (false);
-}
-
-/*
- * Description: Remove Key from table
- *
- * Parameters:
- *  In:
- *      pTable          - Pointer to Key table
- *      pbyBSSID        - BSSID of Key
- *      dwKeyIndex      - Key Index (reference to NDIS DDK)
- *  Out:
- *      none
- *
- * Return Value: true if success otherwise false
- *
- */
-
-int KeybRemoveKey(struct vnt_private *pDevice, PSKeyManagement pTable,
-	u8 *pbyBSSID, u32 dwKeyIndex)
-{
-	int i;
-	int bReturnValue = false;
-
-    if (is_broadcast_ether_addr(pbyBSSID)) {
-        // delete all keys
-        if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
-            for (i=0;i<MAX_KEY_TABLE;i++) {
-                pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
-            }
-            bReturnValue =  true;
-        }
-        else if ((dwKeyIndex & 0x000000FF) < MAX_GROUP_KEY) {
-            for (i=0;i<MAX_KEY_TABLE;i++) {
-                pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF].bKeyValid = false;
-                if ((dwKeyIndex & 0x7FFFFFFF) == (pTable->KeyTable[i].dwGTKeyIndex & 0x7FFFFFFF)) {
-                    // remove Group transmit key
-                    pTable->KeyTable[i].dwGTKeyIndex = 0;
-                }
-            }
-            bReturnValue = true;
-        }
-        else {
-            bReturnValue = false;
-        }
-
-    } else {
-        for (i=0;i<MAX_KEY_TABLE;i++) {
-            if ( (pTable->KeyTable[i].bInUse == true) &&
-		 ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
-
-                if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
-                    pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
-                    bReturnValue = true;
-                    break;
-                }
-                else if ((dwKeyIndex & 0x000000FF) < MAX_GROUP_KEY) {
-                    pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF].bKeyValid = false;
-                    if ((dwKeyIndex & 0x7FFFFFFF) == (pTable->KeyTable[i].dwGTKeyIndex & 0x7FFFFFFF)) {
-                        // remove Group transmit key
-                        pTable->KeyTable[i].dwGTKeyIndex = 0;
-                    }
-                    bReturnValue = true;
-                    break;
-                }
-                else {
-                    bReturnValue = false;
-                    break;
-                }
-            } //pTable->KeyTable[i].bInUse == true
-        }  //for
-        bReturnValue = true;
-    }
-
-    s_vCheckKeyTableValid(pDevice,pTable);
-    return bReturnValue;
-
-}
-
-/*
- * Description: Remove Key from table
- *
- * Parameters:
- *  In:
- *      pTable          - Pointer to Key table
- *      pbyBSSID        - BSSID of Key
- *  Out:
- *      none
- *
- * Return Value: true if success otherwise false
- *
- */
-int KeybRemoveAllKey(struct vnt_private *pDevice, PSKeyManagement pTable,
-	u8 *pbyBSSID)
-{
-	int i, u;
-
-    for (i=0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse == true) &&
-	    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
-            pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
-	    for (u = 0; u < MAX_GROUP_KEY; u++)
-		pTable->KeyTable[i].GroupKey[u].bKeyValid = false;
-
-            pTable->KeyTable[i].dwGTKeyIndex = 0;
-            s_vCheckKeyTableValid(pDevice, pTable);
-            return (true);
-        }
-    }
-    return (false);
-}
-
-/*
- * Description: Get Transmit Key from table
- *
- * Parameters:
- *  In:
- *      pTable          - Pointer to Key table
- *      pbyBSSID        - BSSID of Key
- *  Out:
- *      pKey            - Key return
- *
- * Return Value: true if found otherwise false
- *
- */
-int KeybGetTransmitKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyType,
-	PSKeyItem *pKey)
-{
-	int i, ii;
-
-	*pKey = NULL;
-
-    for (i = 0; i < MAX_KEY_TABLE; i++) {
-        if ((pTable->KeyTable[i].bInUse == true) &&
-	    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
-
-            if (dwKeyType == PAIRWISE_KEY) {
-
-                if (pTable->KeyTable[i].PairwiseKey.bKeyValid == true) {
-                    *pKey = &(pTable->KeyTable[i].PairwiseKey);
-
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybGetTransmitKey:");
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"PAIRWISE_KEY: KeyTable.abyBSSID: ");
-                    for (ii = 0; ii < 6; ii++) {
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"%x ", pTable->KeyTable[i].abyBSSID[ii]);
-                    }
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-
-                    return (true);
-                }
-                else {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"PairwiseKey.bKeyValid == false\n");
-                    return (false);
-                }
-            } // End of Type == PAIRWISE
-            else {
-                if (pTable->KeyTable[i].dwGTKeyIndex == 0) {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ERROR: dwGTKeyIndex == 0 !!!\n");
-                    return false;
-                }
-                if (pTable->KeyTable[i].GroupKey[(pTable->KeyTable[i].dwGTKeyIndex&0x000000FF)].bKeyValid == true) {
-                    *pKey = &(pTable->KeyTable[i].GroupKey[(pTable->KeyTable[i].dwGTKeyIndex&0x000000FF)]);
-
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybGetTransmitKey:");
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GROUP_KEY: KeyTable.abyBSSID\n");
-                        for (ii = 0; ii < 6; ii++) {
-                            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"%x ", pTable->KeyTable[i].abyBSSID[ii]);
-                        }
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"dwGTKeyIndex: %X\n",
-				pTable->KeyTable[i].dwGTKeyIndex);
-
-                    return (true);
-                }
-                else {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GroupKey.bKeyValid == false\n");
-                    return (false);
-                }
-            } // End of Type = GROUP
-        } // BSSID match
-    }
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ERROR: NO Match BSSID !!! ");
-    for (ii = 0; ii < 6; ii++) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"%02x ", *(pbyBSSID+ii));
-    }
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-    return (false);
-}
-
-/*
- * Description: Set Key to table
- *
- * Parameters:
- *  In:
- *      pTable          - Pointer to Key table
- *      dwKeyIndex      - Key index (reference to NDIS DDK)
- *      uKeyLength      - Key length
- *      KeyRSC          - Key RSC
- *      pbyKey          - Pointer to key
- *  Out:
- *      none
- *
- * Return Value: true if success otherwise false
- *
- */
-
-int KeybSetDefaultKey(struct vnt_private *pDevice, PSKeyManagement pTable,
-	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
-	u8 byKeyDecMode)
-{
-	int ii;
-	PSKeyItem pKey;
-	u32 uKeyIdx;
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enter KeybSetDefaultKey: %1x, %d\n",
-	    (int) dwKeyIndex, (int) uKeyLength);
-
-    if ((dwKeyIndex & PAIRWISE_KEY) != 0) {                  // Pairwise key
-        return (false);
-    } else if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY) {
-        return (false);
-    }
-
-    if (uKeyLength > MAX_KEY_LEN)
-	    return false;
-
-    pTable->KeyTable[MAX_KEY_TABLE-1].bInUse = true;
-    for (ii = 0; ii < ETH_ALEN; ii++)
-        pTable->KeyTable[MAX_KEY_TABLE-1].abyBSSID[ii] = 0xFF;
-
-    // Group key
-    pKey = &(pTable->KeyTable[MAX_KEY_TABLE-1].GroupKey[dwKeyIndex & 0x000000FF]);
-    if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
-        // Group transmit key
-        pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex = dwKeyIndex;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-		"Group transmit key(R)[%X]: %d\n",
-		pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex,
-		MAX_KEY_TABLE-1);
-
-    }
-    pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl &= 0x7F00;          // clear all key control filed
-    pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl |= (byKeyDecMode << 4);
-    pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl |= (byKeyDecMode);
-    pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl |= 0x0044;          // use group key for all address
-    uKeyIdx = (dwKeyIndex & 0x000000FF);
-
-    if ((uKeyLength == WLAN_WEP232_KEYLEN) &&
-        (byKeyDecMode == KEY_CTL_WEP)) {
-        pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl |= 0x4000;              // disable on-fly disable address match
-        pTable->KeyTable[MAX_KEY_TABLE-1].bSoftWEP = true;
-    } else {
-        if (pTable->KeyTable[MAX_KEY_TABLE-1].bSoftWEP == false)
-            pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl |= 0xC000;          // enable on-fly disable address match
-    }
-
-    pKey->bKeyValid = true;
-    pKey->uKeyLength = uKeyLength;
-    pKey->dwKeyIndex = dwKeyIndex;
-    pKey->byCipherSuite = byKeyDecMode;
-    memcpy(pKey->abyKey, pbyKey, uKeyLength);
-    if (byKeyDecMode == KEY_CTL_WEP) {
-        if (uKeyLength == WLAN_WEP40_KEYLEN)
-            pKey->abyKey[15] &= 0x7F;
-        if (uKeyLength == WLAN_WEP104_KEYLEN)
-            pKey->abyKey[15] |= 0x80;
-    }
-
-	vnt_mac_set_keyentry(pDevice, pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl,
-		MAX_KEY_TABLE-1, uKeyIdx,
-		pTable->KeyTable[MAX_KEY_TABLE-1].abyBSSID, pKey->abyKey);
-
-		if ((dwKeyIndex & USE_KEYRSC) == 0)
-			pKey->KeyRSC = 0; /* RSC set by NIC */
-		else
-			pKey->KeyRSC = *KeyRSC;
-
-    pKey->dwTSC47_16 = 0;
-    pKey->wTSC15_0 = 0;
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybSetKey(R): \n");
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->bKeyValid: %d\n", pKey->bKeyValid);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->uKeyLength: %d\n", (int)pKey->uKeyLength);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->abyKey: \n");
-    for (ii = 0; ii < pKey->uKeyLength; ii++) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"%x", pKey->abyKey[ii]);
-    }
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %x\n",
-		pKey->dwTSC47_16);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n", pKey->wTSC15_0);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %x\n",
-		pKey->dwKeyIndex);
-
-    return (true);
-}
-
-/*
- * Description: Set Key to table
- *
- * Parameters:
- *  In:
- *      pTable          - Pointer to Key table
- *      dwKeyIndex      - Key index (reference to NDIS DDK)
- *      uKeyLength      - Key length
- *      KeyRSC          - Key RSC
- *      pbyKey          - Pointer to key
- *  Out:
- *      none
- *
- * Return Value: true if success otherwise false
- *
- */
-
-int KeybSetAllGroupKey(struct vnt_private *pDevice, PSKeyManagement pTable,
-	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
-	u8 byKeyDecMode)
-{
-	int i, ii;
-	PSKeyItem pKey;
-	u32 uKeyIdx;
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Enter KeybSetAllGroupKey: %X\n",
-		dwKeyIndex);
-
-    if ((dwKeyIndex & PAIRWISE_KEY) != 0) {                  // Pairwise key
-        return (false);
-    } else if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY) {
-        return (false);
-    }
-
-    for (i=0; i < MAX_KEY_TABLE-1; i++) {
-        if (pTable->KeyTable[i].bInUse == true) {
-            // found table already exist
-            // Group key
-            pKey = &(pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF]);
-            if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
-                // Group transmit key
-                pTable->KeyTable[i].dwGTKeyIndex = dwKeyIndex;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Group transmit key(R)[%X]: %d\n",
-			pTable->KeyTable[i].dwGTKeyIndex, i);
-
-            }
-            pTable->KeyTable[i].wKeyCtl &= 0xFF0F;          // clear group key control filed
-            pTable->KeyTable[i].wKeyCtl |= (byKeyDecMode << 4);
-            pTable->KeyTable[i].wKeyCtl |= 0x0040;          // use group key for group address
-            uKeyIdx = (dwKeyIndex & 0x000000FF);
-
-            pTable->KeyTable[i].wKeyCtl |= 0x8000;              // enable on-fly
-
-            pKey->bKeyValid = true;
-            pKey->uKeyLength = uKeyLength;
-            pKey->dwKeyIndex = dwKeyIndex;
-            pKey->byCipherSuite = byKeyDecMode;
-            memcpy(pKey->abyKey, pbyKey, uKeyLength);
-            if (byKeyDecMode == KEY_CTL_WEP) {
-                if (uKeyLength == WLAN_WEP40_KEYLEN)
-                    pKey->abyKey[15] &= 0x7F;
-                if (uKeyLength == WLAN_WEP104_KEYLEN)
-                    pKey->abyKey[15] |= 0x80;
-            }
-
-	    vnt_mac_set_keyentry(pDevice, pTable->KeyTable[i].wKeyCtl, i,
-			uKeyIdx, pTable->KeyTable[i].abyBSSID, pKey->abyKey);
-
-		if ((dwKeyIndex & USE_KEYRSC) == 0)
-			pKey->KeyRSC = 0; /* RSC set by NIC */
-		else
-			pKey->KeyRSC = *KeyRSC;
-
-            pKey->dwTSC47_16 = 0;
-            pKey->wTSC15_0 = 0;
-
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybSetKey(R): \n");
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->bKeyValid: %d\n ", pKey->bKeyValid);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->uKeyLength: %d\n ", (int)pKey->uKeyLength);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->abyKey: ");
-            for (ii = 0; ii < pKey->uKeyLength; ii++) {
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"%02x ", pKey->abyKey[ii]);
-            }
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-
-            //DBG_PRN_GRP12(("pKey->dwTSC47_16: %lX\n ", pKey->dwTSC47_16));
-            //DBG_PRN_GRP12(("pKey->wTSC15_0: %X\n ", pKey->wTSC15_0));
-            //DBG_PRN_GRP12(("pKey->dwKeyIndex: %lX\n ", pKey->dwKeyIndex));
-
-        } // (pTable->KeyTable[i].bInUse == true)
-    }
-    return (true);
-}
-
 int vnt_key_init_table(struct vnt_private *priv)
 {
 	int ret;
diff --git a/drivers/staging/vt6656/key.h b/drivers/staging/vt6656/key.h
index 779a97a..3cb1291 100644
--- a/drivers/staging/vt6656/key.h
+++ b/drivers/staging/vt6656/key.h
@@ -32,23 +32,12 @@
 
 #include "device.h"
 
-#define MAX_GROUP_KEY       4
 #define MAX_KEY_TABLE       11
-#define MAX_KEY_LEN         32
-#define AES_KEY_LEN         16
-
-#define AUTHENTICATOR_KEY   0x10000000
-#define USE_KEYRSC          0x20000000
-#define PAIRWISE_KEY        0x40000000
-#define TRANSMIT_KEY        0x80000000
-
-#define GROUP_KEY           0x00000000
 
 #define KEY_CTL_WEP         0x00
 #define KEY_CTL_NONE        0x01
 #define KEY_CTL_TKIP        0x02
 #define KEY_CTL_CCMP        0x03
-#define KEY_CTL_INVALID     0xFF
 
 #define VNT_KEY_DEFAULTKEY	0x1
 #define VNT_KEY_GROUP_ADDRESS	0x2
@@ -58,64 +47,6 @@
 #define VNT_KEY_ONFLY		0x8000
 #define VNT_KEY_ONFLY_ALL	0x4000
 
-typedef struct tagSKeyItem
-{
-    bool        bKeyValid;
-	u32 uKeyLength;
-    u8        abyKey[MAX_KEY_LEN];
-	u64 KeyRSC;
-    u32       dwTSC47_16;
-    u16        wTSC15_0;
-    u8        byCipherSuite;
-    u8        byReserved0;
-    u32       dwKeyIndex;
-    void *pvKeyTable;
-} SKeyItem, *PSKeyItem; //64
-
-typedef struct tagSKeyTable
-{
-    u8        abyBSSID[ETH_ALEN];  /* 6 */
-    u8        byReserved0[2];              //8
-    SKeyItem    PairwiseKey;
-    SKeyItem    GroupKey[MAX_GROUP_KEY]; //64*5 = 320, 320+8=328
-    u32       dwGTKeyIndex;            // GroupTransmitKey Index
-    bool        bInUse;
-    u16        wKeyCtl;
-    bool        bSoftWEP;
-    u8        byReserved1[6];
-} SKeyTable, *PSKeyTable; //352
-
-typedef struct tagSKeyManagement
-{
-    SKeyTable   KeyTable[MAX_KEY_TABLE];
-} SKeyManagement, *PSKeyManagement;
-
-void KeyvInitTable(struct vnt_private *, PSKeyManagement pTable);
-
-int KeybGetKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyIndex,
-	PSKeyItem *pKey);
-
-int KeybSetKey(struct vnt_private *, PSKeyManagement pTable, u8 *pbyBSSID,
-	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
-	u8 byKeyDecMode);
-
-int KeybRemoveKey(struct vnt_private *, PSKeyManagement pTable,
-	u8 *pbyBSSID, u32 dwKeyIndex);
-
-int KeybRemoveAllKey(struct vnt_private *, PSKeyManagement pTable,
-	u8 *pbyBSSID);
-
-int KeybGetTransmitKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyType,
-	PSKeyItem *pKey);
-
-int KeybSetDefaultKey(struct vnt_private *, PSKeyManagement pTable,
-	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
-	u8 byKeyDecMode);
-
-int KeybSetAllGroupKey(struct vnt_private *, PSKeyManagement pTable,
-	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
-	u8 byKeyDecMode);
-
 int vnt_key_init_table(struct vnt_private *);
 
 int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index d063229..106c4c4 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -139,10 +139,6 @@ void vRunCommand(struct work_struct *work)
 		}
 		break;
 
-	case WLAN_CMD_REMOVE_ALLKEY_START:
-		KeybRemoveAllKey(pDevice, &(pDevice->sKey), pDevice->abyBSSID);
-		break;
-
 	case WLAN_CMD_MAC_DISPOWERSAVING_START:
 		vnt_control_in_u8(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PSCTL, &byData);
 		if ((byData & PSCTL_PS) != 0) {
-- 
1.9.1

