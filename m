Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41600 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaEYUia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 16:38:30 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so3353561wib.13
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 13:38:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/8] staging: vt6656: MACvSetKeyEntry create structure to write key
Date: Sun, 25 May 2014 21:36:29 +0100
Message-Id: <1401050189-3249-8-git-send-email-tvboxspy@gmail.com> (sfid-20140525_223834_265884_B1936C82)
In-Reply-To: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
References: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create structure for wKeyCtl , pbyAddr and pbyKey

wKeyCtl(key_ctl) and pbyAddr(addr) form an union of 64 bits with swap
of two 32 bits. pbyKey(key) has a length of WLAN_KEY_LEN_CCMP(16)
bytes.

swap is needed because high order 32 bits needs to written out first.

pbyKey is memcpy on to key.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 65 ++++++++++++--------------------------------
 drivers/staging/vt6656/mac.h | 11 ++++++++
 2 files changed, 29 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index f486834..bc72144 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -125,60 +125,31 @@ void MACvDisableKeyEntry(struct vnt_private *priv, u8 entry_idx)
 void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
 	u32 uKeyIdx, u8 *pbyAddr, u32 *pdwKey)
 {
-	u8 *pbyKey;
+	struct vnt_mac_set_key set_key;
+	u8 *pbyKey = (u8 *)pdwKey;
 	u16 wOffset;
-	u32 dwData1, dwData2;
-	int ii;
-	u8 pbyData[24];
 
 	if (pDevice->byLocalID <= MAC_REVISION_A1)
 		if (pDevice->vnt_mgmt.byCSSPK == KEY_CTL_CCMP)
 			return;
 
-    wOffset = MISCFIFO_KEYETRY0;
-    wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
-
-    dwData1 = 0;
-    dwData1 |= wKeyCtl;
-    dwData1 <<= 16;
-    dwData1 |= MAKEWORD(*(pbyAddr+4), *(pbyAddr+5));
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"1. wOffset: %d, Data: %X,"\
-		" KeyCtl:%X\n", wOffset, dwData1, wKeyCtl);
-
-    dwData2 = 0;
-    dwData2 |= *(pbyAddr+3);
-    dwData2 <<= 8;
-    dwData2 |= *(pbyAddr+2);
-    dwData2 <<= 8;
-    dwData2 |= *(pbyAddr+1);
-    dwData2 <<= 8;
-    dwData2 |= *(pbyAddr+0);
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"2. wOffset: %d, Data: %X\n",
-		wOffset, dwData2);
-
-    pbyKey = (u8 *)pdwKey;
-
-    pbyData[0] = (u8)dwData1;
-    pbyData[1] = (u8)(dwData1>>8);
-    pbyData[2] = (u8)(dwData1>>16);
-    pbyData[3] = (u8)(dwData1>>24);
-    pbyData[4] = (u8)dwData2;
-    pbyData[5] = (u8)(dwData2>>8);
-    pbyData[6] = (u8)(dwData2>>16);
-    pbyData[7] = (u8)(dwData2>>24);
-    for (ii = 8; ii < 24; ii++)
-	pbyData[ii] = *pbyKey++;
-
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_SETKEY,
-                        wOffset,
-                        (u16)uKeyIdx,
-			ARRAY_SIZE(pbyData),
-                        pbyData
-                        );
+	wOffset = MISCFIFO_KEYETRY0;
+	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
 
+	set_key.u.write.key_ctl = cpu_to_le16(wKeyCtl);
+	memcpy(set_key.u.write.addr, pbyAddr, ETH_ALEN);
+
+	/* swap over swap[0] and swap[1] to get correct write order */
+	swap(set_key.u.swap[0], set_key.u.swap[1]);
+
+	memcpy(set_key.key, pbyKey, WLAN_KEY_LEN_CCMP);
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"offset %d key ctl %d set key %24ph\n",
+				wOffset, wKeyCtl, (u8 *)&set_key);
+
+	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_SETKEY, wOffset,
+		(u16)uKeyIdx, sizeof(struct vnt_mac_set_key), (u8 *)&set_key);
 }
 
 void MACvRegBitsOff(struct vnt_private *priv, u8 reg_ofs, u8 bits)
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 2084d4b..8100685 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -403,6 +403,17 @@
 #define MAC_REVISION_A0     0x00
 #define MAC_REVISION_A1     0x01
 
+struct vnt_mac_set_key {
+	union {
+		struct {
+			u8 addr[ETH_ALEN];
+			__le16 key_ctl;
+		} write __packed;
+		u32 swap[2];
+	} u;
+	u8 key[WLAN_KEY_LEN_CCMP];
+} __packed;
+
 void MACvWriteMultiAddr(struct vnt_private *, u64);
 void MACbShutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
-- 
1.9.1

