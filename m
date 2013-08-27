Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62270 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3H0L3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 07:29:22 -0400
Received: by mail-ee0-f48.google.com with SMTP id l10so2183848eei.21
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 04:29:21 -0700 (PDT)
Message-ID: <1377602950.3320.82.camel@canaries32-MCP7A> (sfid-20130827_132925_815740_2DF8660E)
Subject: [PATCH 1/2] staging: vt6656: rxtx.c s_vFillTxKey  clean up format
 and white space.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 12:29:10 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 175 ++++++++++++++++++++++--------------------
 1 file changed, 93 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 69fcafe..b5a9c3a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -190,95 +190,106 @@ static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyHdrBuf;
 	u32 dwRevIVCounter;
 
-    //Fill TXKEY
-    if (pTransmitKey == NULL)
-        return;
-
-    dwRevIVCounter = cpu_to_le32(pDevice->dwIVCounter);
-    *pdwIV = pDevice->dwIVCounter;
-    pDevice->byKeyIndex = pTransmitKey->dwKeyIndex & 0xf;
-
-    if (pTransmitKey->byCipherSuite == KEY_CTL_WEP) {
-        if (pTransmitKey->uKeyLength == WLAN_WEP232_KEYLEN ){
-            memcpy(pDevice->abyPRNG, (u8 *)&(dwRevIVCounter), 3);
-            memcpy(pDevice->abyPRNG+3, pTransmitKey->abyKey, pTransmitKey->uKeyLength);
-        } else {
-            memcpy(pbyBuf, (u8 *)&(dwRevIVCounter), 3);
-            memcpy(pbyBuf+3, pTransmitKey->abyKey, pTransmitKey->uKeyLength);
-            if(pTransmitKey->uKeyLength == WLAN_WEP40_KEYLEN) {
-                memcpy(pbyBuf+8, (u8 *)&(dwRevIVCounter), 3);
-                memcpy(pbyBuf+11, pTransmitKey->abyKey, pTransmitKey->uKeyLength);
-            }
-            memcpy(pDevice->abyPRNG, pbyBuf, 16);
-        }
-        // Append IV after Mac Header
-        *pdwIV &= WEP_IV_MASK;//00000000 11111111 11111111 11111111
-	*pdwIV |= (u32)pDevice->byKeyIndex << 30;
-        *pdwIV = cpu_to_le32(*pdwIV);
-        pDevice->dwIVCounter++;
-        if (pDevice->dwIVCounter > WEP_IV_MASK) {
-            pDevice->dwIVCounter = 0;
-        }
-    } else if (pTransmitKey->byCipherSuite == KEY_CTL_TKIP) {
-        pTransmitKey->wTSC15_0++;
-        if (pTransmitKey->wTSC15_0 == 0) {
-            pTransmitKey->dwTSC47_16++;
-        }
-        TKIPvMixKey(pTransmitKey->abyKey, pDevice->abyCurrentNetAddr,
-                    pTransmitKey->wTSC15_0, pTransmitKey->dwTSC47_16, pDevice->abyPRNG);
-        memcpy(pbyBuf, pDevice->abyPRNG, 16);
-        // Make IV
-        memcpy(pdwIV, pDevice->abyPRNG, 3);
-
-        *(pbyIVHead+3) = (u8)(((pDevice->byKeyIndex << 6) & 0xc0) | 0x20); // 0x20 is ExtIV
-        // Append IV&ExtIV after Mac Header
-        *pdwExtIV = cpu_to_le32(pTransmitKey->dwTSC47_16);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"vFillTxKey()---- pdwExtIV: %x\n",
-		*pdwExtIV);
-
-    } else if (pTransmitKey->byCipherSuite == KEY_CTL_CCMP) {
-        pTransmitKey->wTSC15_0++;
-        if (pTransmitKey->wTSC15_0 == 0) {
-            pTransmitKey->dwTSC47_16++;
-        }
-        memcpy(pbyBuf, pTransmitKey->abyKey, 16);
-
-        // Make IV
-        *pdwIV = 0;
-        *(pbyIVHead+3) = (u8)(((pDevice->byKeyIndex << 6) & 0xc0) | 0x20); // 0x20 is ExtIV
-        *pdwIV |= cpu_to_le16((u16)(pTransmitKey->wTSC15_0));
-        //Append IV&ExtIV after Mac Header
-        *pdwExtIV = cpu_to_le32(pTransmitKey->dwTSC47_16);
-
-	if (!mic_hdr)
+	/* Fill TXKEY */
+	if (pTransmitKey == NULL)
 		return;
 
-	/* MICHDR0 */
-	mic_hdr->id = 0x59;
-	mic_hdr->payload_len = cpu_to_be16(wPayloadLen);
-	memcpy(mic_hdr->mic_addr2, pMACHeader->addr2, ETH_ALEN);
+	dwRevIVCounter = cpu_to_le32(pDevice->dwIVCounter);
+	*pdwIV = pDevice->dwIVCounter;
+	pDevice->byKeyIndex = pTransmitKey->dwKeyIndex & 0xf;
 
-	mic_hdr->tsc_47_16 = cpu_to_be32(pTransmitKey->dwTSC47_16);
-	mic_hdr->tsc_15_0 = cpu_to_be16(pTransmitKey->wTSC15_0);
-
-	/* MICHDR1 */
-	if (pDevice->bLongHeader)
-		mic_hdr->hlen = cpu_to_be16(28);
-	else
-		mic_hdr->hlen = cpu_to_be16(22);
+	if (pTransmitKey->byCipherSuite == KEY_CTL_WEP) {
+		if (pTransmitKey->uKeyLength == WLAN_WEP232_KEYLEN) {
+			memcpy(pDevice->abyPRNG, (u8 *)&dwRevIVCounter, 3);
+			memcpy(pDevice->abyPRNG + 3, pTransmitKey->abyKey,
+						pTransmitKey->uKeyLength);
+		} else {
+			memcpy(pbyBuf, (u8 *)&dwRevIVCounter, 3);
+			memcpy(pbyBuf + 3, pTransmitKey->abyKey,
+						pTransmitKey->uKeyLength);
+			if (pTransmitKey->uKeyLength == WLAN_WEP40_KEYLEN) {
+				memcpy(pbyBuf+8, (u8 *)&dwRevIVCounter, 3);
+			memcpy(pbyBuf+11, pTransmitKey->abyKey,
+						pTransmitKey->uKeyLength);
+			}
+
+			memcpy(pDevice->abyPRNG, pbyBuf, 16);
+		}
+		/* Append IV after Mac Header */
+		*pdwIV &= WEP_IV_MASK;
+		*pdwIV |= (u32)pDevice->byKeyIndex << 30;
+		*pdwIV = cpu_to_le32(*pdwIV);
+
+		pDevice->dwIVCounter++;
+		if (pDevice->dwIVCounter > WEP_IV_MASK)
+			pDevice->dwIVCounter = 0;
+	} else if (pTransmitKey->byCipherSuite == KEY_CTL_TKIP) {
+		pTransmitKey->wTSC15_0++;
+		if (pTransmitKey->wTSC15_0 == 0)
+			pTransmitKey->dwTSC47_16++;
+
+		TKIPvMixKey(pTransmitKey->abyKey, pDevice->abyCurrentNetAddr,
+			pTransmitKey->wTSC15_0, pTransmitKey->dwTSC47_16,
+							pDevice->abyPRNG);
+		memcpy(pbyBuf, pDevice->abyPRNG, 16);
+
+		/* Make IV */
+		memcpy(pdwIV, pDevice->abyPRNG, 3);
+
+		*(pbyIVHead+3) = (u8)(((pDevice->byKeyIndex << 6) &
+							0xc0) | 0x20);
+		/*  Append IV&ExtIV after Mac Header */
+		*pdwExtIV = cpu_to_le32(pTransmitKey->dwTSC47_16);
+
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"vFillTxKey()---- pdwExtIV: %x\n", *pdwExtIV);
+
+	} else if (pTransmitKey->byCipherSuite == KEY_CTL_CCMP) {
+		pTransmitKey->wTSC15_0++;
+		if (pTransmitKey->wTSC15_0 == 0)
+			pTransmitKey->dwTSC47_16++;
+
+		memcpy(pbyBuf, pTransmitKey->abyKey, 16);
+
+		/* Make IV */
+		*pdwIV = 0;
+		*(pbyIVHead+3) = (u8)(((pDevice->byKeyIndex << 6) &
+							0xc0) | 0x20);
+
+		*pdwIV |= cpu_to_le16((u16)(pTransmitKey->wTSC15_0));
+
+		/* Append IV&ExtIV after Mac Header */
+		*pdwExtIV = cpu_to_le32(pTransmitKey->dwTSC47_16);
+
+		if (!mic_hdr)
+			return;
+
+		/* MICHDR0 */
+		mic_hdr->id = 0x59;
+		mic_hdr->payload_len = cpu_to_be16(wPayloadLen);
+		memcpy(mic_hdr->mic_addr2, pMACHeader->addr2, ETH_ALEN);
+
+		mic_hdr->tsc_47_16 = cpu_to_be32(pTransmitKey->dwTSC47_16);
+		mic_hdr->tsc_15_0 = cpu_to_be16(pTransmitKey->wTSC15_0);
+
+		/* MICHDR1 */
+		if (pDevice->bLongHeader)
+			mic_hdr->hlen = cpu_to_be16(28);
+		else
+			mic_hdr->hlen = cpu_to_be16(22);
 
-	memcpy(mic_hdr->addr1, pMACHeader->addr1, ETH_ALEN);
-	memcpy(mic_hdr->addr2, pMACHeader->addr2, ETH_ALEN);
+		memcpy(mic_hdr->addr1, pMACHeader->addr1, ETH_ALEN);
+		memcpy(mic_hdr->addr2, pMACHeader->addr2, ETH_ALEN);
 
-	/* MICHDR2 */
-	memcpy(mic_hdr->addr3, pMACHeader->addr3, ETH_ALEN);
-	mic_hdr->frame_control = cpu_to_le16(pMACHeader->frame_control
+		/* MICHDR2 */
+		memcpy(mic_hdr->addr3, pMACHeader->addr3, ETH_ALEN);
+		mic_hdr->frame_control = cpu_to_le16(pMACHeader->frame_control
 								& 0xc78f);
-	mic_hdr->seq_ctrl = cpu_to_le16(pMACHeader->seq_ctrl & 0xf);
+		mic_hdr->seq_ctrl = cpu_to_le16(pMACHeader->seq_ctrl & 0xf);
 
-	if (pDevice->bLongHeader)
-		memcpy(mic_hdr->addr4, pMACHeader->addr4, ETH_ALEN);
-    }
+		if (pDevice->bLongHeader)
+			memcpy(mic_hdr->addr4, pMACHeader->addr4, ETH_ALEN);
+	}
 }
 
 static void s_vSWencryption(struct vnt_private *pDevice,
-- 
1.8.1.2

