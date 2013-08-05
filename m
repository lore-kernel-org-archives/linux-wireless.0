Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:56220 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3HEUJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 16:09:21 -0400
Received: by mail-we0-f172.google.com with SMTP id t61so2924733wes.31
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2013 13:09:19 -0700 (PDT)
Message-ID: <1375733354.7004.25.camel@canaries64> (sfid-20130805_220924_787998_49423902)
Subject: [PATCH 2/3] staging: vt6656: rxtx.c: s_vGetFreeContext use single
 tx memset.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 Aug 2013 21:09:14 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

memset to 0 structure _USB_SEND_CONTEXT pContext->Data to its
size of MAX_TOTAL_SIZE_WITH_ALL_HEADERS as defined
in device.h

This removes the need for memset in the TX path.

It also allows the removal of dead structure
TX_BUFFER_CONTAINER BufferHeader;

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index be0c9ce..137608f 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -155,6 +155,7 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice)
         pContext = pDevice->apTD[ii];
         if (pContext->bBoolInUse == false) {
             pContext->bBoolInUse = true;
+		memset(pContext->Data, 0, MAX_TOTAL_SIZE_WITH_ALL_HEADERS);
             pReturnContext = pContext;
             break;
         }
@@ -1206,7 +1207,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	}
 
     pTxBufHead = (PTX_BUFFER) usbPacketBuf;
-    memset(pTxBufHead, 0, sizeof(TX_BUFFER));
 
     // Get pkt type
     if (ntohs(psEthHeader->h_proto) > ETH_DATA_LEN) {
@@ -1582,8 +1582,6 @@ static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 {
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyBufferAddr;
 
-    memset(pMACHeader, 0, (sizeof(struct ieee80211_hdr)));
-
     if (uDMAIdx == TYPE_ATIMDMA) {
     	pMACHeader->frame_control = TYPE_802_11_ATIM;
     } else {
@@ -1699,7 +1697,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     cbFrameBodySize = pPacket->cbPayloadLen;
     pTxBufHead = (PSTxBufHead) pbyTxBufferAddr;
     wTxBufSize = sizeof(STxBufHead);
-    memset(pTxBufHead, 0, wTxBufSize);
 
     if (pDevice->byBBType == BB_TYPE_11A) {
         wCurrentRate = RATE_6M;
@@ -1828,9 +1825,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
         cbHeaderSize = wTxBufSize + sizeof(SRrvTime_ab) + sizeof(STxDataHead_ab);
     }
 
-    memset((void *)(pbyTxBufferAddr + wTxBufSize), 0,
-	   (cbHeaderSize - wTxBufSize));
-
     memcpy(&(sEthHeader.h_dest[0]),
 	   &(pPacket->p80211Header->sA3.abyAddr1[0]),
 	   ETH_ALEN);
@@ -1968,7 +1962,6 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 
     pTxBufHead = (PSTxShortBufHead) pbyTxBufferAddr;
     wTxBufSize = sizeof(STxShortBufHead);
-    memset(pTxBufHead, 0, wTxBufSize);
 
     if (pDevice->byBBType == BB_TYPE_11A) {
         wCurrentRate = RATE_6M;
@@ -2077,7 +2070,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     pbyTxBufferAddr = (u8 *)(&pTX_Buffer->adwTxKey[0]);
     pTxBufHead = (PSTxBufHead) pbyTxBufferAddr;
     wTxBufSize = sizeof(STxBufHead);
-    memset(pTxBufHead, 0, wTxBufSize);
 
     if (pDevice->byBBType == BB_TYPE_11A) {
         wCurrentRate = RATE_6M;
@@ -2233,8 +2225,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
         pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
         cbHeaderSize = wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(STxDataHead_ab);
     }
-    memset((void *)(pbyTxBufferAddr + wTxBufSize), 0,
-	   (cbHeaderSize - wTxBufSize));
     memcpy(&(sEthHeader.h_dest[0]),
 	   &(p80211Header->sA3.abyAddr1[0]),
 	   ETH_ALEN);
-- 
1.8.1.2




