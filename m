Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53530 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab3HPWuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:50:37 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj13so1362747wib.5
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 15:50:36 -0700 (PDT)
Message-ID: <1376693432.18777.7.camel@canaries32-MCP7A> (sfid-20130817_005058_781001_F7F271B1)
Subject: [PATCH 7/8] staging: vt6656: desc.h remove typedef
 tagSTxDataHead_ab  to new structure in rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 23:50:32 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To new structure.
typedef struct tagSTxDataHead_ab -> struct vnt_tx_datahead_ab

This is only needed by rxtc.c so moved to rxtx.h visible to
vnt_rts* structures which it will eventually form part of
their structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 10 --------
 drivers/staging/vt6656/rxtx.c | 55 ++++++++++++++++++++++++-------------------
 drivers/staging/vt6656/rxtx.h |  8 +++++++
 3 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 1ee0331..d350fd3 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -166,16 +166,6 @@ typedef const STxShortBufHead *PCSTxShortBufHead;
 /*
  * TX data header
  */
-typedef struct tagSTxDataHead_ab {
-    u8    bySignalField;
-    u8    byServiceField;
-    u16    wTransmitLength;
-    u16    wDuration;
-    u16    wTimeStampOff;
-} __attribute__ ((__packed__))
-STxDataHead_ab, *PSTxDataHead_ab;
-typedef const STxDataHead_ab *PCSTxDataHead_ab;
-
 typedef struct tagSTxDataHead_a_FB {
     u8    bySignalField;
     u8    byServiceField;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 20c4656..a4d3728 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -500,7 +500,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 	if ((uDMAIdx == TYPE_ATIMDMA) || (uDMAIdx == TYPE_BEACONDMA)) {
-		PSTxDataHead_ab pBuf = (PSTxDataHead_ab) pTxDataHead;
+		struct vnt_tx_datahead_ab *pBuf =
+			(struct vnt_tx_datahead_ab *)pTxDataHead;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
@@ -579,7 +580,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
             }
             return (pBuf->wDuration);
         } else {
-            PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
+		struct vnt_tx_datahead_ab *pBuf =
+			(struct vnt_tx_datahead_ab *)pTxDataHead;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
@@ -595,7 +597,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
         }
     }
     else if (byPktType == PK_TYPE_11B) {
-            PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
+		struct vnt_tx_datahead_ab *pBuf =
+			(struct vnt_tx_datahead_ab *)pTxDataHead;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
@@ -1230,12 +1233,12 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 		pvRTS = (struct vnt_rts_ab *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
                 pvCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
+		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
+			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
 						sizeof(struct vnt_rts_ab));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
 			cbMICHDR + sizeof(struct vnt_rts_ab) +
-				sizeof(STxDataHead_ab);
+				sizeof(struct vnt_tx_datahead_ab);
             }
             else if (bRTS == false) { //RTS_needless, no MICHDR
 		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
@@ -1244,10 +1247,10 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 						sizeof(struct vnt_rrv_time_ab));
                 pvRTS = NULL;
                 pvCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
+			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-					cbMICHDR + sizeof(STxDataHead_ab);
+				cbMICHDR + sizeof(struct vnt_tx_datahead_ab);
             }
         } else {
             // Auto Fall Back
@@ -1700,10 +1703,10 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
         pMICHDR = NULL;
         pvRTS = NULL;
         pCTS = NULL;
-	pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize +
-					sizeof(struct vnt_rrv_time_ab));
+	pvTxDataHd = (struct vnt_tx_datahead_ab *) (pbyTxBufferAddr +
+		wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-		sizeof(STxDataHead_ab);
+		sizeof(struct vnt_tx_datahead_ab);
     }
 
     memcpy(&(sEthHeader.h_dest[0]),
@@ -1792,8 +1795,9 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_b =
 			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 	} else {
-            ((PSTxDataHead_ab)pvTxDataHd)->wDuration = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
-        }
+		((struct vnt_tx_datahead_ab *)pvTxDataHd)->wDuration =
+			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
+	}
     }
 
     pTX_Buffer->wTxByteCount = cpu_to_le16((u16)(cbReqCount));
@@ -1824,7 +1828,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	u16 wTxBufSize = sizeof(STxShortBufHead);
 	PSTxShortBufHead pTxBufHead;
 	struct ieee80211_hdr *pMACHeader;
-	PSTxDataHead_ab pTxDataHead;
+	struct vnt_tx_datahead_ab *pTxDataHead;
 	u16 wCurrentRate;
 	u32 cbFrameBodySize;
 	u32 cbReqCount;
@@ -1849,7 +1853,8 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 
     if (pDevice->byBBType == BB_TYPE_11A) {
         wCurrentRate = RATE_6M;
-        pTxDataHead = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize);
+	pTxDataHead = (struct vnt_tx_datahead_ab *)
+			(pbyTxBufferAddr + wTxBufSize);
         //Get SignalField,ServiceField,Length
         BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11A,
             (u16 *)&(pTxDataHead->wTransmitLength), (u8 *)&(pTxDataHead->byServiceField), (u8 *)&(pTxDataHead->bySignalField)
@@ -1858,11 +1863,12 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice,
 				DATADUR_A, PK_TYPE_11A, false));
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-        cbHeaderSize = wTxBufSize + sizeof(STxDataHead_ab);
+	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
     } else {
         wCurrentRate = RATE_1M;
         pTxBufHead->wFIFOCtl |= FIFOCTL_11B;
-        pTxDataHead = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize);
+	pTxDataHead = (struct vnt_tx_datahead_ab *)
+				(pbyTxBufferAddr + wTxBufSize);
         //Get SignalField,ServiceField,Length
         BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11B,
             (u16 *)&(pTxDataHead->wTransmitLength), (u8 *)&(pTxDataHead->byServiceField), (u8 *)&(pTxDataHead->bySignalField)
@@ -1871,7 +1877,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice,
 				DATADUR_B, PK_TYPE_11B, false));
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-        cbHeaderSize = wTxBufSize + sizeof(STxDataHead_ab);
+	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
     }
 
     //Generate Beacon Header
@@ -2111,10 +2117,10 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 		sizeof(struct vnt_rrv_time_ab));
         pvRTS = NULL;
         pvCTS = NULL;
-	pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize +
-		sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+	pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
+		wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
-							sizeof(STxDataHead_ab);
+					sizeof(struct vnt_tx_datahead_ab);
     }
     memcpy(&(sEthHeader.h_dest[0]),
 	   &(p80211Header->sA3.abyAddr1[0]),
@@ -2248,8 +2254,9 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_b =
 			cpu_to_le16(p80211Header->sA2.wDurationID);
 	} else {
-            ((PSTxDataHead_ab)pvTxDataHd)->wDuration = cpu_to_le16(p80211Header->sA2.wDurationID);
-        }
+		((struct vnt_tx_datahead_ab *)pvTxDataHd)->wDuration =
+			cpu_to_le16(p80211Header->sA2.wDurationID);
+	}
     }
 
     pTX_Buffer->wTxByteCount = cpu_to_le16((u16)(cbReqCount));
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index ba80271..d66d71d 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -83,6 +83,14 @@ struct vnt_tx_datahead_g_fb {
 	u16 wTimeStampOff_a;
 } __packed;
 
+struct vnt_tx_datahead_ab {
+	u8 bySignalField;
+	u8 byServiceField;
+	u16 wTransmitLength;
+	u16 wDuration;
+	u16 wTimeStampOff;
+} __packed;
+
 /* RTS buffer header */
 struct vnt_rts_g {
 	u8 bySignalField_b;
-- 
1.8.1.2

