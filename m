Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47038 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab3HGUb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 16:31:56 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so1967375wgg.16
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 13:31:55 -0700 (PDT)
Message-ID: <1375907508.5626.39.camel@canaries64> (sfid-20130807_223200_098664_812DF88B)
Subject: [PATCH 3/4] staging: vt6656: rxtx.c s_uFillDataHead remove dead
 variables.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 07 Aug 2013 21:31:48 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As result of patches
staging: vt6656: rxtx.c: s_uGetDataDuration remove First Frag or Mid Frag dead code
staging: vt6656: rxtx.c: s_uGetDataDuration remove dead variables.

variables uFragIdx, cbLastFragmentSize, uMACfragNum are dead.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 2751531..70a30d9 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -106,8 +106,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
-	u32 uDMAIdx, int bNeedAck, u32 uFragIdx, u32 cbLastFragmentSize,
-	u32 uMACfragNum, u8 byFBOption);
+	u32 uDMAIdx, int bNeedAck, u8 byFBOption);
 
 static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 	u8 *pbyBufferAddr, u16 wDuration, struct ethhdr *psEthHeader,
@@ -525,8 +524,7 @@ static u32 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
-	u32 uDMAIdx, int bNeedAck, u32 uFragIdx, u32 cbLastFragmentSize,
-	u32 uMACfragNum, u8 byFBOption)
+	u32 uDMAIdx, int bNeedAck, u8 byFBOption)
 {
 
     if (pTxDataHead == NULL) {
@@ -1268,7 +1266,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
                                cbFrameSize, bNeedACK, uDMAIdx, psEthHeader);
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
-                                    0, 0, 1/*uMACfragNum*/, byFBOption);
+				byFBOption);
     // Generate TX MAC Header
     s_vGenerateMACHeader(pDevice, pbyMacHdr, (u16)uDuration, psEthHeader, bNeedEncryption,
                            byFragType, uDMAIdx, 0);
@@ -1690,7 +1688,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
-                                0, 0, 1, AUTO_FB_NONE);
+				AUTO_FB_NONE);
 
     pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
 
@@ -2094,7 +2092,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
-                                0, 0, 1, AUTO_FB_NONE);
+				AUTO_FB_NONE);
 
     pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
 
-- 
1.8.1.2

