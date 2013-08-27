Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54469 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3H0LIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 07:08:06 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so1534256bkb.41
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 04:08:05 -0700 (PDT)
Message-ID: <1377601678.3320.72.camel@canaries32-MCP7A> (sfid-20130827_130810_884257_6D4D7304)
Subject: [PATCH 5/5] staging: vt6656: rxtx.c s_vFillRTSHead/s_vFillCTSHead
 move union vnt_tx_data_head up one level.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 12:07:58 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move
s_vFillRTSHead union vnt_tx_data_head to void *pvRTS argument.
s_vFillCTSHead union vnt_tx_data_head to void *pvCTS argument.

In s_vGenerateTxParameter create union vnt_tx_data_head
pointing to rts_cts; 

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c9f6ffc..273bd5d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -125,11 +125,11 @@ static u16 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice, u8 byRTSRsvType,
 	u8 byPktType, u32 cbFrameLength, u16 wCurrentRate);
 
 static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
-	u8 byPktType, void *pvCTS, u32 cbFrameLength, int bNeedAck,
-	u16 wCurrentRate, u8 byFBOption);
+	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
+	int bNeedAck, u16 wCurrentRate, u8 byFBOption);
 
 static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
-	void *pvRTS, u32 cbFrameLength, int bNeedAck,
+	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption);
 
 static u16 s_uGetDataDuration(struct vnt_private *pDevice,
@@ -717,10 +717,9 @@ static int vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
 }
 
 static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
-	void *pvRTS, u32 cbFrameLength, int bNeedAck,
+	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
 {
-	union vnt_tx_data_head *head = pvRTS;
 
 	if (!head)
 		return;
@@ -757,10 +756,9 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 }
 
 static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
-	u8 byPktType, void *pvCTS, u32 cbFrameLength, int bNeedAck,
-	u16 wCurrentRate, u8 byFBOption)
+	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
+	int bNeedAck, u16 wCurrentRate, u8 byFBOption)
 {
-	union vnt_tx_data_head *head = pvCTS;
 	u32 uCTSFrameLen = 14;
 
 	if (!head)
@@ -831,6 +829,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
 	struct ethhdr *psEthHeader, bool need_rts)
 {
+	union vnt_tx_data_head *head = rts_cts;
 	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
 	u16 wFifoCtl;
 	u8 byFBOption = AUTO_FB_NONE;
@@ -870,7 +869,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 			PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate,
 				bNeedACK);
 		/* Fill RTS */
-		s_vFillRTSHead(pDevice, byPktType, rts_cts, cbFrameSize,
+		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
         }
         else {//RTS_needless, PCF mode
@@ -885,7 +884,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
 				byPktType, cbFrameSize, wCurrentRate);
 		/* Fill CTS */
-		s_vFillCTSHead(pDevice, uDMAIdx, byPktType, rts_cts,
+		s_vFillCTSHead(pDevice, uDMAIdx, byPktType, head,
 			cbFrameSize, bNeedACK, wCurrentRate, byFBOption);
         }
     }
@@ -899,7 +898,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
 				cbFrameSize, wCurrentRate, bNeedACK);
 		/* Fill RTS */
-		s_vFillRTSHead(pDevice, byPktType, rts_cts, cbFrameSize,
+		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
 	} else {
             //Fill RsvTime
@@ -919,7 +918,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 				cbFrameSize, wCurrentRate, bNeedACK);
 		/* Fill RTS */
-		s_vFillRTSHead(pDevice, byPktType, rts_cts, cbFrameSize,
+		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
         }
         else { //RTS_needless, non PCF mode
-- 
1.8.1.2

