Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:61923 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3FEUXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 16:23:38 -0400
Received: by mail-ea0-f181.google.com with SMTP id a11so1530672eae.12
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 13:23:36 -0700 (PDT)
Message-ID: <1370463812.6213.26.camel@canaries64> (sfid-20130605_222341_340625_156E1B22)
Subject: [PATCH 04/13] staging: vt6656: clean up MACvSetKeyEntry
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 21:23:32 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove internal white space and camel case.

Camel case changes;
pDevice -> priv
uKeyIdx -> key_idx
pbyAddr -> addr
pdwKey -> key
uEntryIdx -> entry_idx
pbyKey -> ptr_key
wOffset -> offset
dwData1 -> data1
dwData2 -> data2
pbyData -> data

ii -> i

Functional change
Removed MAKEWORD macro
key_idx changed to u16

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 132 ++++++++++++++++++-------------------------
 drivers/staging/vt6656/mac.h |   2 +-
 2 files changed, 55 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 13c15fa..56da5ef 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -125,92 +125,68 @@ void MACvDisableKeyEntry(struct vnt_private *priv, u32 entry_idx)
  *      Set the Key by MISCFIFO
  *
  * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
+ * In:
+ *	dwIoBase        - Base Address for MAC
  *
- *  Out:
- *      none
+ * Out:
+ *	none
  *
  * Return Value: none
  *
  */
-void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
-	u32 uKeyIdx, u8 *pbyAddr, u32 *pdwKey)
+void MACvSetKeyEntry(struct vnt_private *priv, u16 key_ctl, u32 entry_idx,
+	u16 key_idx, u8 *addr, u32 *key)
 {
-	u8 *pbyKey;
-	u16 wOffset;
-	u32 dwData1, dwData2;
-	int ii;
-	u8 pbyData[24];
-
-	if (pDevice->byLocalID <= MAC_REVISION_A1)
-		if (pDevice->vnt_mgmt.byCSSPK == KEY_CTL_CCMP)
+	u8 data[24];
+	u8 *ptr_key;
+	u16 offset;
+	u32 data1, data2;
+	int i;
+
+	if (priv->byLocalID <= MAC_REVISION_A1)
+		if (priv->vnt_mgmt.byCSSPK == KEY_CTL_CCMP)
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
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-    //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-
-    //wOffset++;
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
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
-    //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
-    //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-
-    //wOffset++;
-
-    //wOffset += (uKeyIdx * 4);
-/*    for (ii=0;ii<4;ii++) {
-        // alway push 128 bits
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"3.(%d) wOffset: %d, Data: %lX\n", ii, wOffset+ii, *pdwKey);
-        VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+ii);
-        VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, *pdwKey++);
-        VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
-    }
-*/
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
-                        24,
-                        pbyData
-                        );
+	offset = MISCFIFO_KEYETRY0;
+	offset += (entry_idx * MISCFIFO_KEYENTRYSIZE);
+
+	data1 = (u32)key_ctl;
+	data1 <<= 16;
+	data1 |= (u32)(*(addr + 5) << 8);
+	data1 |= (u32)*(addr + 4);
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"1. offset: %d, data1: %X, key_ctl:%X\n",
+		offset, data1, key_ctl);
+
+	data2 = 0;
+	data2 |= *(addr + 3);
+	data2 <<= 8;
+	data2 |= *(addr + 2);
+	data2 <<= 8;
+	data2 |= *(addr + 1);
+	data2 <<= 8;
+	data2 |= *(addr);
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"2. offset: %d, data2: %X\n", offset, data2);
+
+	ptr_key = (u8 *)key;
+
+	data[0] = (u8)data1;
+	data[1] = (u8)(data1 >> 8);
+	data[2] = (u8)(data1 >> 16);
+	data[3] = (u8)(data1 >> 24);
+	data[4] = (u8)data2;
+	data[5] = (u8)(data2 >> 8);
+	data[6] = (u8)(data2 >> 16);
+	data[7] = (u8)(data2 >> 24);
+
+	for (i = 8; i < 24; i++)
+		data[i] = *ptr_key++;
+
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SETKEY,
+		offset, key_idx, ARRAY_SIZE(data), data);
 
 }
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index f0cecc9..548ab3c 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -407,7 +407,7 @@ void MACvWriteMultiAddr(struct vnt_private *, u16, u8);
 void MACbShutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u32);
-void MACvSetKeyEntry(struct vnt_private *, u16, u32, u32, u8 *, u32 *);
+void MACvSetKeyEntry(struct vnt_private *, u16, u32, u16, u8 *, u32 *);
 void MACvRegBitsOff(struct vnt_private *, u8, u8);
 void MACvRegBitsOn(struct vnt_private *, u8, u8);
 void MACvWriteWord(struct vnt_private *, u8, u16);
-- 
1.8.1.2



