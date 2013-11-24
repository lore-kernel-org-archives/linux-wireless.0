Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46569 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3KXNZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 08:25:31 -0500
Received: by mail-wi0-f171.google.com with SMTP id ca18so2502729wib.10
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 05:25:30 -0800 (PST)
Message-ID: <1385299525.13346.9.camel@canaries32-MCP7A> (sfid-20131124_142549_135949_EEF1EA64)
Subject: [PATCH 1/2] staging: vt6656: csBeacon_xmit merge structures.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 24 Nov 2013 13:25:25 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge structures typedef struct tagSTxShortBufHead and the members of
struct vnt_tx_datahead_ab to form single structure vnt_tx_short_buf_head.

Remove the duplicate members in struct vnt_beacon_buffer already in
typedef struct tagSTxShortBufHead.

This removes the need for any pointer arithmetic.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h |  8 ------
 drivers/staging/vt6656/rxtx.c | 61 +++++++++++++++++++++----------------------
 drivers/staging/vt6656/rxtx.h | 11 ++++++--
 3 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index afe7074..7c6dd5f 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -146,14 +146,6 @@
 /*
  * TX FIFO header
  */
-
-typedef struct tagSTxShortBufHead {
-    u16    wFIFOCtl;
-    u16    wTimeStamp;
-} __attribute__ ((__packed__))
-STxShortBufHead, *PSTxShortBufHead;
-typedef const STxShortBufHead *PCSTxShortBufHead;
-
 typedef struct tagSBEACONCtl {
 	u32 BufReady:1;
 	u32 TSF:15;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a95575f..a45604a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1643,12 +1643,10 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	struct vnt_tx_mgmt *pPacket)
 {
 	struct vnt_beacon_buffer *pTX_Buffer;
+	struct vnt_tx_short_buf_head *short_head;
 	u32 cbFrameSize = pPacket->cbMPDULen + WLAN_FCS_LEN;
 	u32 cbHeaderSize = 0;
-	u16 wTxBufSize = sizeof(STxShortBufHead);
-	PSTxShortBufHead pTxBufHead;
 	struct ieee80211_hdr *pMACHeader;
-	struct vnt_tx_datahead_ab *pTxDataHead;
 	u16 wCurrentRate;
 	u32 cbFrameBodySize;
 	u32 cbReqCount;
@@ -1664,39 +1662,40 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
     }
 
 	pTX_Buffer = (struct vnt_beacon_buffer *)&pContext->Data[0];
-    pbyTxBufferAddr = (u8 *)&(pTX_Buffer->wFIFOCtl);
+	short_head = &pTX_Buffer->short_head;
+	pbyTxBufferAddr = (u8 *)&short_head->fifo_ctl;
 
     cbFrameBodySize = pPacket->cbPayloadLen;
 
-    pTxBufHead = (PSTxShortBufHead) pbyTxBufferAddr;
-    wTxBufSize = sizeof(STxShortBufHead);
+	cbHeaderSize = sizeof(struct vnt_tx_short_buf_head);
 
-    if (pDevice->byBBType == BB_TYPE_11A) {
-        wCurrentRate = RATE_6M;
-	pTxDataHead = (struct vnt_tx_datahead_ab *)
-			(pbyTxBufferAddr + wTxBufSize);
-        //Get SignalField,ServiceField,Length
-	BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11A,
-							&pTxDataHead->ab);
-        //Get Duration and TimeStampOff
-	pTxDataHead->wDuration = s_uGetDataDuration(pDevice,
-						PK_TYPE_11A, false);
-	pTxDataHead->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
-	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
-    } else {
-        wCurrentRate = RATE_1M;
-        pTxBufHead->wFIFOCtl |= FIFOCTL_11B;
-	pTxDataHead = (struct vnt_tx_datahead_ab *)
-				(pbyTxBufferAddr + wTxBufSize);
-        //Get SignalField,ServiceField,Length
-	BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11B,
-							&pTxDataHead->ab);
-        //Get Duration and TimeStampOff
-	pTxDataHead->wDuration = s_uGetDataDuration(pDevice,
+	if (pDevice->byBBType == BB_TYPE_11A) {
+		wCurrentRate = RATE_6M;
+
+		/* Get SignalField,ServiceField,Length */
+		BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate,
+			PK_TYPE_11A, &short_head->ab);
+
+		/* Get Duration and TimeStampOff */
+		short_head->duration = s_uGetDataDuration(pDevice,
+							PK_TYPE_11A, false);
+		short_head->time_stamp_off =
+				vnt_time_stamp_off(pDevice, wCurrentRate);
+	} else {
+		wCurrentRate = RATE_1M;
+		short_head->fifo_ctl |= FIFOCTL_11B;
+
+		/* Get SignalField,ServiceField,Length */
+		BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate,
+					PK_TYPE_11B, &short_head->ab);
+
+		/* Get Duration and TimeStampOff */
+		short_head->duration = s_uGetDataDuration(pDevice,
 						PK_TYPE_11B, false);
-	pTxDataHead->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
-	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
-    }
+		short_head->time_stamp_off =
+			vnt_time_stamp_off(pDevice, wCurrentRate);
+	}
+
 
     //Generate Beacon Header
     pMACHeader = (struct ieee80211_hdr *)(pbyTxBufferAddr + cbHeaderSize);
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index eecbe89..bb21ad6 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -230,12 +230,19 @@ struct vnt_tx_buffer {
 	union vnt_tx_head tx_head;
 } __packed;
 
+struct vnt_tx_short_buf_head {
+	u16 fifo_ctl;
+	u16 time_stamp;
+	struct vnt_phy_field ab;
+	u16 duration;
+	u16 time_stamp_off;
+} __packed;
+
 struct vnt_beacon_buffer {
 	u8 byType;
 	u8 byPKTNO;
 	u16 wTxByteCount;
-	u16 wFIFOCtl;
-	u16 wTimeStamp;
+	struct vnt_tx_short_buf_head short_head;
 } __packed;
 
 void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb);
-- 
1.8.4.4


