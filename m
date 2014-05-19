Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:55403 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbaESTeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:17 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so6071775wes.32
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:15 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/20] staging: vt6656: dead code bRelayPacketSend
Date: Mon, 19 May 2014 20:32:56 +0100
Message-Id: <1400527992-3061-4-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213424_087270_63AD1B35)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After dead code hostapd remove bRelayPacketSend

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 126 ------------------------------------------
 drivers/staging/vt6656/rxtx.h |   2 -
 2 files changed, 128 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7713181..2b0ae06 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -2073,129 +2073,3 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 
 	return 0;
 }
-
-/*
- * Description:
- *      Relay packet send (AC1DMA) from rx dpc.
- *
- * Parameters:
- *  In:
- *      pDevice         - Pointer to the adapter
- *      pPacket         - Pointer to rx packet
- *      cbPacketSize    - rx ethernet frame size
- *  Out:
- *      TURE, false
- *
- * Return Value: Return true if packet is copy to dma1; otherwise false
- */
-
-int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
-	u32 uNodeIndex)
-{
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	struct vnt_tx_buffer *pTX_Buffer;
-	u32 BytesToWrite = 0, uHeaderLen = 0;
-	u8 byPktType = PK_TYPE_11B;
-	int bNeedEncryption = false;
-	PSKeyItem pTransmitKey = NULL;
-	u8 *pbyBSSID;
-	struct vnt_usb_send_context *pContext;
-	u8 byPktTyp;
-	int fConvertedPacket;
-	u32 status;
-	u16 wKeepRate = pDevice->wCurrentRate;
-
-	pContext = s_vGetFreeContext(pDevice);
-
-    if (NULL == pContext) {
-        return false;
-    }
-
-	memcpy(&pDevice->sTxEthHeader, pbySkbData, ETH_HLEN);
-
-    if (pDevice->bEncryptionEnable == true) {
-        bNeedEncryption = true;
-        // get group key
-        pbyBSSID = pDevice->abyBroadcastAddr;
-        if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
-            pTransmitKey = NULL;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"KEY is NULL. [%d]\n", pMgmt->eCurrMode);
-        } else {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"Get GTK.\n");
-        }
-    }
-
-    if ( bNeedEncryption && (pTransmitKey == NULL) ) {
-	pContext->in_use = false;
-        return false;
-    }
-
-    byPktTyp = (u8)pDevice->byPacketType;
-
-    if (pDevice->bFixRate) {
-        if (pDevice->byBBType == BB_TYPE_11B) {
-            if (pDevice->uConnectionRate >= RATE_11M) {
-                pDevice->wCurrentRate = RATE_11M;
-            } else {
-                pDevice->wCurrentRate = (u16)pDevice->uConnectionRate;
-            }
-        } else {
-            if ((pDevice->byBBType == BB_TYPE_11A) &&
-                (pDevice->uConnectionRate <= RATE_6M)) {
-                pDevice->wCurrentRate = RATE_6M;
-            } else {
-                if (pDevice->uConnectionRate >= RATE_54M)
-                    pDevice->wCurrentRate = RATE_54M;
-                else
-                    pDevice->wCurrentRate = (u16)pDevice->uConnectionRate;
-            }
-        }
-    }
-    else {
-        pDevice->wCurrentRate = pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate;
-    }
-
-    if (wKeepRate != pDevice->wCurrentRate) {
-	bScheduleCommand((void *) pDevice, WLAN_CMD_SETPOWER, NULL);
-    }
-
-    if (pDevice->wCurrentRate <= RATE_11M)
-        byPktType = PK_TYPE_11B;
-
-    BytesToWrite = uDataLen + ETH_FCS_LEN;
-
-    // Convert the packet to an usb frame and copy into our buffer
-    // and send the irp.
-
-	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->data[0];
-
-    fConvertedPacket = s_bPacketToWirelessUsb(pDevice, byPktType,
-			pTX_Buffer, bNeedEncryption,
-			uDataLen, &pDevice->sTxEthHeader,
-                         pbySkbData, pTransmitKey, uNodeIndex,
-                         pDevice->wCurrentRate,
-                         &uHeaderLen, &BytesToWrite
-                        );
-
-    if (fConvertedPacket == false) {
-	pContext->in_use = false;
-        return false;
-    }
-
-    pTX_Buffer->byPKTNO = (u8) (((pDevice->wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
-    pTX_Buffer->tx_byte_count = cpu_to_le16((u16)BytesToWrite);
-
-	pContext->skb = NULL;
-	pContext->type = CONTEXT_DATA_PACKET;
-	pContext->buf_len = (u16)BytesToWrite + 4; /* USB header */
-
-    s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
-		&pDevice->sTxEthHeader.h_dest[0],
-		(u16)(BytesToWrite - uHeaderLen),
-		pTX_Buffer->fifo_head.wFIFOCtl);
-
-    status = PIPEnsSendBulkOut(pDevice,pContext);
-
-    return true;
-}
-
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 982f162..6db3337 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -250,7 +250,5 @@ void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb);
 int nsDMA_tx_packet(struct vnt_private *, struct sk_buff *skb);
 CMD_STATUS csMgmt_xmit(struct vnt_private *, struct vnt_tx_mgmt *);
 CMD_STATUS csBeacon_xmit(struct vnt_private *, struct vnt_tx_mgmt *);
-int bRelayPacketSend(struct vnt_private *, u8 *pbySkbData, u32 uDataLen,
-	u32 uNodeIndex);
 
 #endif /* __RXTX_H__ */
-- 
1.9.1

