Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61362 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3HWNh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 09:37:56 -0400
Received: by mail-wg0-f46.google.com with SMTP id k13so550659wgh.25
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 06:37:54 -0700 (PDT)
Message-ID: <1377265068.13953.37.camel@canaries32-MCP7A> (sfid-20130823_153758_624602_09F462C2)
Subject: [PATCH 2/2] staging: vt6656: rxtx.c s_vFillTxKey fill structure
 vnt_mic_hdr
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Aug 2013 14:37:48 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the pointer offsets with structure of mic_hdr with
endian conversion where needed.

Replace vFillTxKey argument u8 *pMICHDR with struct vnt_mic_hdr *mic_hdr
and fix type of calling functions.

An extra check that mic_hdr is not NULL

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 71 +++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c055c76..14b7def 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -113,7 +113,7 @@ static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 
 static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
 	u8 *pbyIVHead, PSKeyItem pTransmitKey, u8 *pbyHdrBuf, u16 wPayloadLen,
-	u8 *pMICHDR);
+	struct vnt_mic_hdr *mic_hdr);
 
 static void s_vSWencryption(struct vnt_private *pDevice,
 	PSKeyItem pTransmitKey, u8 *pbyPayloadHead, u16 wPayloadSize);
@@ -183,11 +183,10 @@ static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 
 static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
 	u8 *pbyIVHead, PSKeyItem pTransmitKey, u8 *pbyHdrBuf,
-	u16 wPayloadLen, u8 *pMICHDR)
+	u16 wPayloadLen, struct vnt_mic_hdr *mic_hdr)
 {
 	u32 *pdwIV = (u32 *)pbyIVHead;
 	u32 *pdwExtIV = (u32 *)((u8 *)pbyIVHead + 4);
-	u16 wValue;
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyHdrBuf;
 	u32 dwRevIVCounter;
 
@@ -251,40 +250,34 @@ static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
         //Append IV&ExtIV after Mac Header
         *pdwExtIV = cpu_to_le32(pTransmitKey->dwTSC47_16);
 
-        //Fill MICHDR0
-        *pMICHDR = 0x59;
-        *((u8 *)(pMICHDR+1)) = 0; // TxPriority
-        memcpy(pMICHDR+2, &(pMACHeader->addr2[0]), 6);
-        *((u8 *)(pMICHDR+8)) = HIBYTE(HIWORD(pTransmitKey->dwTSC47_16));
-        *((u8 *)(pMICHDR+9)) = LOBYTE(HIWORD(pTransmitKey->dwTSC47_16));
-        *((u8 *)(pMICHDR+10)) = HIBYTE(LOWORD(pTransmitKey->dwTSC47_16));
-        *((u8 *)(pMICHDR+11)) = LOBYTE(LOWORD(pTransmitKey->dwTSC47_16));
-        *((u8 *)(pMICHDR+12)) = HIBYTE(pTransmitKey->wTSC15_0);
-        *((u8 *)(pMICHDR+13)) = LOBYTE(pTransmitKey->wTSC15_0);
-        *((u8 *)(pMICHDR+14)) = HIBYTE(wPayloadLen);
-        *((u8 *)(pMICHDR+15)) = LOBYTE(wPayloadLen);
-
-        //Fill MICHDR1
-        *((u8 *)(pMICHDR+16)) = 0; // HLEN[15:8]
-        if (pDevice->bLongHeader) {
-            *((u8 *)(pMICHDR+17)) = 28; // HLEN[7:0]
-        } else {
-            *((u8 *)(pMICHDR+17)) = 22; // HLEN[7:0]
-        }
-        wValue = cpu_to_le16(pMACHeader->frame_control & 0xC78F);
-        memcpy(pMICHDR+18, (u8 *)&wValue, 2); // MSKFRACTL
-        memcpy(pMICHDR+20, &(pMACHeader->addr1[0]), 6);
-        memcpy(pMICHDR+26, &(pMACHeader->addr2[0]), 6);
-
-        //Fill MICHDR2
-        memcpy(pMICHDR+32, &(pMACHeader->addr3[0]), 6);
-        wValue = pMACHeader->seq_ctrl;
-        wValue &= 0x000F;
-        wValue = cpu_to_le16(wValue);
-        memcpy(pMICHDR+38, (u8 *)&wValue, 2); // MSKSEQCTL
-        if (pDevice->bLongHeader) {
-            memcpy(pMICHDR+40, &(pMACHeader->addr4[0]), 6);
-        }
+	if (!mic_hdr)
+		return;
+
+	/* MICHDR0 */
+	mic_hdr->id = 0x59;
+	mic_hdr->payload_len = cpu_to_be16(wPayloadLen);
+	memcpy(mic_hdr->mic_addr2, pMACHeader->addr2, ETH_ALEN);
+
+	mic_hdr->tsc_47_16 = cpu_to_be32(pTransmitKey->dwTSC47_16);
+	mic_hdr->tsc_15_0 = cpu_to_be16(pTransmitKey->wTSC15_0);
+
+	/* MICHDR1 */
+	if (pDevice->bLongHeader)
+		mic_hdr->hlen = cpu_to_be16(28);
+	else
+		mic_hdr->hlen = cpu_to_be16(22);
+
+	memcpy(mic_hdr->addr1, pMACHeader->addr1, ETH_ALEN);
+	memcpy(mic_hdr->addr2, pMACHeader->addr2, ETH_ALEN);
+
+	/* MICHDR2 */
+	memcpy(mic_hdr->addr3, pMACHeader->addr3, ETH_ALEN);
+	mic_hdr->frame_control = cpu_to_le16(pMACHeader->frame_control
+								& 0xc78f);
+	mic_hdr->seq_ctrl = cpu_to_le16(pMACHeader->seq_ctrl & 0xf);
+
+	if (pDevice->bLongHeader)
+		memcpy(mic_hdr->addr4, pMACHeader->addr4, ETH_ALEN);
     }
 }
 
@@ -1294,7 +1287,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     if (bNeedEncryption == true) {
         //Fill TXKEY
         s_vFillTxKey(pDevice, (u8 *)(pTxBufHead->adwTxKey), pbyIVHead, pTransmitKey,
-                         pbyMacHdr, (u16)cbFrameBodySize, (u8 *)pMICHDR);
+		pbyMacHdr, (u16)cbFrameBodySize, pMICHDR);
 
         if (pDevice->bEnableHostWEP) {
             pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16 = pTransmitKey->dwTSC47_16;
@@ -2203,7 +2196,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
         }
 
         s_vFillTxKey(pDevice, (u8 *)(pTxBufHead->adwTxKey), pbyIVHead, pTransmitKey,
-                     pbyMacHdr, (u16)cbFrameBodySize, (u8 *)pMICHDR);
+		pbyMacHdr, (u16)cbFrameBodySize, pMICHDR);
 
         if (pDevice->bEnableHostWEP) {
             pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16 = pTransmitKey->dwTSC47_16;
-- 
1.8.1.2




