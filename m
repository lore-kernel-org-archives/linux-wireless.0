Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:58124 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3JAPHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 11:07:35 -0400
Received: by mail-we0-f172.google.com with SMTP id w61so7506606wes.31
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 08:07:34 -0700 (PDT)
Message-ID: <1380640045.2087.11.camel@canaries64-MCP7A> (sfid-20131001_170738_232565_9EE5AD8F)
Subject: [PATCH 8/8] staging: vt6656: rxtx.c remove dead code
 s_uFillDataHead/pvTxDataHd.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 16:07:25 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

uFillDataHead in is now dead so remove and pvTxDataHd.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 42 +++---------------------------------------
 1 file changed, 3 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index d094a6a..8df94ff 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -103,10 +103,6 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
 	int bNeedACK, u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts);
 
-static u32 s_uFillDataHead(struct vnt_private *pDevice,
-	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
-	u32 uDMAIdx, int bNeedAck, u8 byFBOption);
-
 static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 	u8 *pbyBufferAddr, u16 wDuration, struct ethhdr *psEthHeader,
 	int bNeedEncrypt, u16 wFragType, u32 uDMAIdx, u32 uFragIdx);
@@ -583,32 +579,6 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_private *priv, u8 pkt_type,
 	return buf->wDuration;
 }
 
-static u32 s_uFillDataHead(struct vnt_private *pDevice,
-	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
-	u32 uDMAIdx, int bNeedAck, u8 byFBOption)
-{
-
-    if (pTxDataHead == NULL) {
-        return 0;
-    }
-
-    if (byPktType == PK_TYPE_11A) {
-		struct vnt_tx_datahead_ab *pBuf =
-			(struct vnt_tx_datahead_ab *)pTxDataHead;
-
-		return vnt_rxtx_datahead_ab(pDevice, byPktType,	wCurrentRate,
-				pBuf, cbFrameLength, bNeedAck);
-    }
-    else if (byPktType == PK_TYPE_11B) {
-		struct vnt_tx_datahead_ab *pBuf =
-			(struct vnt_tx_datahead_ab *)pTxDataHead;
-
-		return vnt_rxtx_datahead_ab(pDevice, byPktType,	wCurrentRate,
-				pBuf, cbFrameLength, bNeedAck);
-    }
-    return 0;
-}
-
 static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
 	struct ieee80211_rts *rts, struct ethhdr *eth_hdr,
 		u16 duration)
@@ -1026,14 +996,13 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 uDuration;
 	u32 cbHeaderLength = 0, uPadding = 0;
 	struct vnt_mic_hdr *pMICHDR;
-	void *pvTxDataHd;
 	u8 byFBOption = AUTO_FB_NONE, byFragType;
 	u16 wTxBufSize;
 	u32 dwMICKey0, dwMICKey1, dwMIC_Priority;
 	u32 *pdwMIC_L, *pdwMIC_R;
 	int bSoftWEP = false;
 
-	pMICHDR = pvTxDataHd = NULL;
+	pMICHDR = NULL;
 
 	if (bNeedEncryption && pTransmitKey->pvKeyTable) {
 		if (((PSKeyTable)pTransmitKey->pvKeyTable)->bSoftWEP == true)
@@ -1797,7 +1766,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	struct vnt_tx_fifo_head *pTxBufHead;
 	u8 byPktType;
 	u8 *pbyTxBufferAddr;
-	void *pvTxDataHd;
 	u32 uDuration, cbReqCount;
 	struct ieee80211_hdr *pMACHeader;
 	u32 cbHeaderSize, cbFrameBodySize;
@@ -1823,7 +1791,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	u32 cbExtSuppRate = 0;
 	struct vnt_usb_send_context *pContext;
 
-	pMICHDR = pvTxDataHd = NULL;
+	pMICHDR = NULL;
 
     if(skb->len <= WLAN_HDR_ADDR3_LEN) {
        cbFrameBodySize = 0;
@@ -2006,11 +1974,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 		pTX_Buffer, &pMICHDR, cbMICHDR,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
-    //Fill DataHead
-    uDuration |= s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd,
-		cbFrameSize, TYPE_TXDMA0, bNeedACK, AUTO_FB_NONE);
-
-    pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
+	pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
 
     cbReqCount = cbHeaderSize + cbMacHdLen + uPadding + cbIVlen + (cbFrameBodySize + cbMIClen) + cbExtSuppRate;
 
-- 
1.8.3.2


