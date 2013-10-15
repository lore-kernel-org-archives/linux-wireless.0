Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59335 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687Ab3JOUlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 16:41:45 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so2778009wgh.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 13:41:44 -0700 (PDT)
Message-ID: <1381869698.5100.40.camel@canaries32-MCP7A> (sfid-20131015_224151_440628_5303AE61)
Subject: [PATCH 1/2] staging: vt6656: rxtx.c s_vFillTxKey replace u8 *pbyBuf.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:41:38 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_tx_fifo_head and attach pbyBuf to
adwTxKey[0]

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 0c1c46f..35a3ddb 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -107,8 +107,9 @@ static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 	u8 *pbyBufferAddr, u16 wDuration, struct ethhdr *psEthHeader,
 	int bNeedEncrypt, u16 wFragType, u32 uDMAIdx, u32 uFragIdx);
 
-static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
-	u8 *pbyIVHead, PSKeyItem pTransmitKey, u8 *pbyHdrBuf, u16 wPayloadLen,
+static void s_vFillTxKey(struct vnt_private *pDevice,
+	struct vnt_tx_fifo_head *fifo_head, u8 *pbyIVHead,
+	PSKeyItem pTransmitKey, u8 *pbyHdrBuf, u16 wPayloadLen,
 	struct vnt_mic_hdr *mic_hdr);
 
 static void s_vSWencryption(struct vnt_private *pDevice,
@@ -179,10 +180,12 @@ static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 	   ETH_ALEN);
 }
 
-static void s_vFillTxKey(struct vnt_private *pDevice, u8 *pbyBuf,
-	u8 *pbyIVHead, PSKeyItem pTransmitKey, u8 *pbyHdrBuf,
-	u16 wPayloadLen, struct vnt_mic_hdr *mic_hdr)
+static void s_vFillTxKey(struct vnt_private *pDevice,
+	struct vnt_tx_fifo_head *fifo_head, u8 *pbyIVHead,
+	PSKeyItem pTransmitKey, u8 *pbyHdrBuf, u16 wPayloadLen,
+	struct vnt_mic_hdr *mic_hdr)
 {
+	u8 *pbyBuf = (u8 *)&fifo_head->adwTxKey[0];
 	u32 *pdwIV = (u32 *)pbyIVHead;
 	u32 *pdwExtIV = (u32 *)((u8 *)pbyIVHead + 4);
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyHdrBuf;
@@ -1171,7 +1174,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 
     if (bNeedEncryption == true) {
         //Fill TXKEY
-        s_vFillTxKey(pDevice, (u8 *)(pTxBufHead->adwTxKey), pbyIVHead, pTransmitKey,
+	s_vFillTxKey(pDevice, pTxBufHead, pbyIVHead, pTransmitKey,
 		pbyMacHdr, (u16)cbFrameBodySize, pMICHDR);
 
         if (pDevice->bEnableHostWEP) {
@@ -1591,7 +1594,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
             }
         } while(false);
         //Fill TXKEY
-        s_vFillTxKey(pDevice, (u8 *)(pTxBufHead->adwTxKey), pbyIVHead, pTransmitKey,
+	s_vFillTxKey(pDevice, pTxBufHead, pbyIVHead, pTransmitKey,
                      (u8 *)pMACHeader, (u16)cbFrameBodySize, NULL);
 
         memcpy(pMACHeader, pPacket->p80211Header, cbMacHdLen);
@@ -2034,7 +2037,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
         }
 
-        s_vFillTxKey(pDevice, (u8 *)(pTxBufHead->adwTxKey), pbyIVHead, pTransmitKey,
+	s_vFillTxKey(pDevice, pTxBufHead, pbyIVHead, pTransmitKey,
 		pbyMacHdr, (u16)cbFrameBodySize, pMICHDR);
 
         if (pDevice->bEnableHostWEP) {
-- 
1.8.3.2

