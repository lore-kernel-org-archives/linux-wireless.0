Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:45471 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3H0KvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 06:51:06 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so1535934bkb.34
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 03:51:04 -0700 (PDT)
Message-ID: <1377600658.3320.63.camel@canaries32-MCP7A> (sfid-20130827_125113_041290_962B3896)
Subject: [PATCH 3/5] staging: vt6656: rxtx.c s_vGenerateTxParameter create
 argument bool need rts
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 11:50:58 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Allow conditional statements to be based on true/false instead of
NULL or not pointer pvRTS.

Harmonise all call functions will bool type.

If need_rts is true then rts is needed.

If need_rts is false then
	cts is needed only when byPktType == PK_TYPE_11GB || PK_TYPE_11GA.
	none no rts/cts other byPktTypes.

This allow the joining of pointers pvRTS/pvCTS in to single pointer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index fd3c598..2fd71c3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -101,7 +101,7 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice);
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
 	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader);
+	struct ethhdr *psEthHeader, bool need_rts);
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
@@ -829,7 +829,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
 	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader)
+	struct ethhdr *psEthHeader, bool need_rts)
 {
 	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
 	u16 wFifoCtl;
@@ -854,8 +854,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-
-        if (pvRTS != NULL) { //RTS_need
+	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_rts *pBuf =
 			(struct vnt_rrv_time_rts *)pvRrvTime;
@@ -891,8 +890,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
     }
     else if (byPktType == PK_TYPE_11A) {
-
-        if (pvRTS != NULL) {//RTS_need, non PCF mode
+	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
@@ -903,8 +901,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             //Fill RTS
 	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
 			psEthHeader, wCurrentRate, byFBOption);
-        }
-        else if (pvRTS == NULL) {//RTS_needless, non PCF mode
+	} else {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
@@ -913,8 +910,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
     }
     else if (byPktType == PK_TYPE_11B) {
-
-        if ((pvRTS != NULL)) {//RTS_need, non PCF mode
+	if (need_rts) {From 48dc74774174065ae9d0c1bbfe46178fbd2f4c6d Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Sun, 25 Aug 2013 10:37:35 +0100
Subject: [PATCH 05/13] staging: vt6656: rxtx.c s_vGenerateTxParameter create
 need rts

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index fd3c598..2fd71c3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -101,7 +101,7 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice);
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
 	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader);
+	struct ethhdr *psEthHeader, bool need_rts);
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
@@ -829,7 +829,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
 	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader)
+	struct ethhdr *psEthHeader, bool need_rts)
 {
 	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
 	u16 wFifoCtl;
@@ -854,8 +854,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-
-        if (pvRTS != NULL) { //RTS_need
+	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_rts *pBuf =
 			(struct vnt_rrv_time_rts *)pvRrvTime;
@@ -891,8 +890,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
     }
     else if (byPktType == PK_TYPE_11A) {
-
-        if (pvRTS != NULL) {//RTS_need, non PCF mode
+	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
@@ -903,8 +901,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             //Fill RTS
 	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
 			psEthHeader, wCurrentRate, byFBOption);
-        }
-        else if (pvRTS == NULL) {//RTS_needless, non PCF mode
+	} else {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =From 48dc74774174065ae9d0c1bbfe46178fbd2f4c6d Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Sun, 25 Aug 2013 10:37:35 +0100
Subject: [PATCH 05/13] staging: vt6656: rxtx.c s_vGenerateTxParameter create
 need rts

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index fd3c598..2fd71c3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -101,7 +101,7 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice);
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
 	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader);
+	struct ethhdr *psEthHeader, bool need_rts);
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
@@ -829,7 +829,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
 	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader)
+	struct ethhdr *psEthHeader, bool need_rts)
 {
 	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
 	u16 wFifoCtl;
@@ -854,8 +854,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-
-        if (pvRTS != NULL) { //RTS_need
+	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_rts *pBuf =
 			(struct vnt_rrv_time_rts *)pvRrvTime;
@@ -891,8 +890,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
     }
     else if (byPktType == PK_TYPE_11A) {
-
-        if (pvRTS != NULL) {//RTS_need, non PCF mode
+	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
@@ -903,8 +901,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             //Fill RTS
 	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
 			psEthHeader, wCurrentRate, byFBOption);
-        }
-        else if (pvRTS == NULL) {//RTS_needless, non PCF mode
+	} else {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
@@ -913,8 +910,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
     }
     else if (byPktType == PK_TYPE_11B) {
-
-        if ((pvRTS != NULL)) {//RTS_need, non PCF mode
+	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
@@ -953,7 +949,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 cb802_1_H_len;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbMACHdLen = 0;
 	u32 cbFCSlen = 4, cbMICHDR = 0;
-	int bNeedACK, bRTS;
+	int bNeedACK;
+	bool bRTS = false;
 	u8 *pbyType, *pbyMacHdr, *pbyIVHead, *pbyPayloadHead, *pbyTxBufferAddr;
 	u8 abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
 	u8 abySNAP_Bridgetunnel[ETH_ALEN]
@@ -1236,7 +1233,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
 			   (void *)pbyTxBufferAddr, pvRrvTime, pvRTS, pvCTS,
-                               cbFrameSize, bNeedACK, uDMAIdx, psEthHeader);
+		cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
 				byFBOption);
@@ -1640,7 +1637,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,  pbyTxBufferAddr, pvRrvTime, pvRTS, pCTS,
-                           cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader);
+		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
@@ -2051,7 +2048,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate, pbyTxBufferAddr, pvRrvTime, pvRTS, pvCTS,
-                           cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader);
+		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
-- 
1.8.1.2

 				(struct vnt_rrv_time_ab *)pvRrvTime;
@@ -913,8 +910,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
     }
     else if (byPktType == PK_TYPE_11B) {
-
-        if ((pvRTS != NULL)) {//RTS_need, non PCF mode
+	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
@@ -953,7 +949,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 cb802_1_H_len;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbMACHdLen = 0;
 	u32 cbFCSlen = 4, cbMICHDR = 0;
-	int bNeedACK, bRTS;
+	int bNeedACK;
+	bool bRTS = false;
 	u8 *pbyType, *pbyMacHdr, *pbyIVHead, *pbyPayloadHead, *pbyTxBufferAddr;
 	u8 abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
 	u8 abySNAP_Bridgetunnel[ETH_ALEN]
@@ -1236,7 +1233,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
 			   (void *)pbyTxBufferAddr, pvRrvTime, pvRTS, pvCTS,
-                               cbFrameSize, bNeedACK, uDMAIdx, psEthHeader);
+		cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
 				byFBOption);
@@ -1640,7 +1637,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,  pbyTxBufferAddr, pvRrvTime, pvRTS, pCTS,
-                           cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader);
+		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
@@ -2051,7 +2048,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate, pbyTxBufferAddr, pvRrvTime, pvRTS, pvCTS,
-                           cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader);
+		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
-- 
1.8.1.2

             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
@@ -953,7 +949,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 cb802_1_H_len;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbMACHdLen = 0;
 	u32 cbFCSlen = 4, cbMICHDR = 0;
-	int bNeedACK, bRTS;
+	int bNeedACK;
+	bool bRTS = false;
 	u8 *pbyType, *pbyMacHdr, *pbyIVHead, *pbyPayloadHead, *pbyTxBufferAddr;
 	u8 abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
 	u8 abySNAP_Bridgetunnel[ETH_ALEN]
@@ -1236,7 +1233,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
 			   (void *)pbyTxBufferAddr, pvRrvTime, pvRTS, pvCTS,
-                               cbFrameSize, bNeedACK, uDMAIdx, psEthHeader);
+		cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
 				byFBOption);
@@ -1640,7 +1637,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,  pbyTxBufferAddr, pvRrvTime, pvRTS, pCTS,
-                           cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader);
+		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
@@ -2051,7 +2048,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate, pbyTxBufferAddr, pvRrvTime, pvRTS, pvCTS,
-                           cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader);
+		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
-- 
1.8.1.2



