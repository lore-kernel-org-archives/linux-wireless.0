Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39769 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaEaMf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 08:35:57 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so2240185wib.5
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 05:35:56 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/4] staging: vt6656: rxtx s_vFillTxKey use vnt_usb_send_context
Date: Sat, 31 May 2014 13:34:59 +0100
Message-Id: <1401539700-3183-3-git-send-email-tvboxspy@gmail.com> (sfid-20140531_143605_232154_FFC7014E)
In-Reply-To: <1401539700-3183-1-git-send-email-tvboxspy@gmail.com>
References: <1401539700-3183-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use struct vnt_usb_send_context to get mac header and
priv pointers

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index e4cc1ff..26cc57e 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -106,10 +106,9 @@ static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 	struct ethhdr *psEthHeader, int bNeedEncrypt, u16 wFragType,
 	u32 uFragIdx);
 
-static void s_vFillTxKey(struct vnt_private *pDevice,
+static void s_vFillTxKey(struct vnt_usb_send_context *tx_context,
 	struct vnt_tx_fifo_head *fifo_head, u8 *pbyIVHead,
-	PSKeyItem pTransmitKey, u8 *pbyHdrBuf, u16 wPayloadLen,
-	struct vnt_mic_hdr *mic_hdr);
+	PSKeyItem pTransmitKey, u16 wPayloadLen, struct vnt_mic_hdr *mic_hdr);
 
 static void s_vSWencryption(struct vnt_private *pDevice,
 	PSKeyItem pTransmitKey, u8 *pbyPayloadHead, u16 wPayloadSize);
@@ -177,15 +176,15 @@ static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 	stats->tx_bytes += wPktLength;
 }
 
-static void s_vFillTxKey(struct vnt_private *pDevice,
+static void s_vFillTxKey(struct vnt_usb_send_context *tx_context,
 	struct vnt_tx_fifo_head *fifo_head, u8 *pbyIVHead,
-	PSKeyItem pTransmitKey, u8 *pbyHdrBuf, u16 wPayloadLen,
-	struct vnt_mic_hdr *mic_hdr)
+	PSKeyItem pTransmitKey, u16 wPayloadLen, struct vnt_mic_hdr *mic_hdr)
 {
+	struct vnt_private *pDevice = tx_context->priv;
+	struct ieee80211_hdr *pMACHeader = tx_context->hdr;
 	u8 *pbyBuf = (u8 *)&fifo_head->adwTxKey[0];
 	__le32 *pdwIV = (__le32 *)pbyIVHead;
 	__le32 *pdwExtIV = (__le32 *)((u8 *)pbyIVHead + 4);
-	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyHdrBuf;
 	__le32 rev_iv_counter;
 
 	/* Fill TXKEY */
@@ -1156,8 +1155,8 @@ static int s_bPacketToWirelessUsb(struct vnt_usb_send_context *tx_context,
 
     if (bNeedEncryption == true) {
         //Fill TXKEY
-	s_vFillTxKey(pDevice, pTxBufHead, pbyIVHead, pTransmitKey,
-		pbyMacHdr, (u16)cbFrameBodySize, pMICHDR);
+	s_vFillTxKey(tx_context, pTxBufHead, pbyIVHead, pTransmitKey,
+		(u16)cbFrameBodySize, pMICHDR);
     }
 
 	/* 802.1H */
@@ -1556,8 +1555,8 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
             }
         } while(false);
         //Fill TXKEY
-	s_vFillTxKey(pDevice, pTxBufHead, pbyIVHead, pTransmitKey,
-                     (u8 *)pMACHeader, (u16)cbFrameBodySize, NULL);
+	s_vFillTxKey(pContext, pTxBufHead, pbyIVHead, pTransmitKey,
+			(u16)cbFrameBodySize, NULL);
 
         memcpy(pMACHeader, pPacket->p80211Header, cbMacHdLen);
         memcpy(pbyPayloadHead, ((u8 *)(pPacket->p80211Header) + cbMacHdLen),
-- 
1.9.1

