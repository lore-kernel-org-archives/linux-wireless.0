Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46075 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3HPWsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:48:10 -0400
Received: by mail-wg0-f41.google.com with SMTP id l18so1693334wgh.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 15:48:09 -0700 (PDT)
Message-ID: <1376693283.18777.5.camel@canaries32-MCP7A> (sfid-20130817_004820_234680_AEAC7C40)
Subject: [PATCH 5/8] staging: vt6656: desc.h: remove typedef struct
 tagSTxDataHead_g to new structure in rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 23:48:03 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To new structure.
typedef struct tagSTxDataHead_g -> struct vnt_tx_datahead_g

This is only needed by rxtc.c so moved to rxtx.h visible to
vnt_rts*/vnt_cts* structures which it will eventually form part of
their structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 16 --------------
 drivers/staging/vt6656/rxtx.c | 49 ++++++++++++++++++++++++-------------------
 drivers/staging/vt6656/rxtx.h | 14 +++++++++++++
 3 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index dc089ac..b0cb8c4 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -166,22 +166,6 @@ typedef const STxShortBufHead *PCSTxShortBufHead;
 /*
  * TX data header
  */
-typedef struct tagSTxDataHead_g {
-    u8    bySignalField_b;
-    u8    byServiceField_b;
-    u16    wTransmitLength_b;
-    u8    bySignalField_a;
-    u8    byServiceField_a;
-    u16    wTransmitLength_a;
-    u16    wDuration_b;
-    u16    wDuration_a;
-    u16    wTimeStampOff_b;
-    u16    wTimeStampOff_a;
-} __attribute__ ((__packed__))
-STxDataHead_g, *PSTxDataHead_g;
-
-typedef const STxDataHead_g *PCSTxDataHead_g;
-
 typedef struct tagSTxDataHead_g_FB {
     u8    bySignalField_b;
     u8    byServiceField_b;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index b21a496..585a2e3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -515,7 +515,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
         }
         else { // DATA & MANAGE Frame
             if (byFBOption == AUTO_FB_NONE) {
-                PSTxDataHead_g pBuf = (PSTxDataHead_g)pTxDataHead;
+		struct vnt_tx_datahead_g *pBuf =
+				(struct vnt_tx_datahead_g *)pTxDataHead;
                 //Get SignalField,ServiceField,Length
                 BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                     (u16 *)&(pBuf->wTransmitLength_a), (u8 *)&(pBuf->byServiceField_a), (u8 *)&(pBuf->bySignalField_a)
@@ -1162,12 +1163,12 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 		pvRTS = (struct vnt_rts_g *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
                 pvCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_rts) + cbMICHDR +
-						sizeof(struct vnt_rts_g));
+		pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
+			wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
+				cbMICHDR + sizeof(struct vnt_rts_g));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
 			cbMICHDR + sizeof(struct vnt_rts_g) +
-				sizeof(STxDataHead_g);
+				sizeof(struct vnt_tx_datahead_g);
             }
             else { //RTS_needless
 		pvRrvTime = (struct vnt_rrv_time_cts *)
@@ -1177,12 +1178,12 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
                 pvRTS = NULL;
 		pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
-		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
-						sizeof(struct vnt_cts));
+		pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr +
+			wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
+				cbMICHDR + sizeof(struct vnt_cts));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
 			cbMICHDR + sizeof(struct vnt_cts) +
-				sizeof(STxDataHead_g);
+				sizeof(struct vnt_tx_datahead_g);
             }
         } else {
             // Auto Fall Back
@@ -1688,10 +1689,10 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
         pvRTS = NULL;
 	pCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
-	pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
+	pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr + wTxBufSize +
 		sizeof(struct vnt_rrv_time_cts) + sizeof(struct vnt_cts));
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-		sizeof(struct vnt_cts) + sizeof(STxDataHead_g);
+		sizeof(struct vnt_cts) + sizeof(struct vnt_tx_datahead_g);
     }
     else { // 802.11a/b packet
 	pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr + wTxBufSize);
@@ -1784,10 +1785,12 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
         // This will cause AID-field of PS-POLL packet be incorrect (Because PS-POLL's AID field is
         // in the same place of other packet's Duration-field).
         // And it will cause Cisco-AP to issue Disassociation-packet
-        if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-            ((PSTxDataHead_g)pvTxDataHd)->wDuration_a = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
-            ((PSTxDataHead_g)pvTxDataHd)->wDuration_b = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
-        } else {
+	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
+		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_a =
+			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
+		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_b =
+			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
+	} else {
             ((PSTxDataHead_ab)pvTxDataHd)->wDuration = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
         }
     }
@@ -2093,11 +2096,11 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
         pvRTS = NULL;
 	pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
-	pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
-		sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
+	pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
+		wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
 					sizeof(struct vnt_cts));
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
-				sizeof(struct vnt_cts) + sizeof(STxDataHead_g);
+		sizeof(struct vnt_cts) + sizeof(struct vnt_tx_datahead_g);
 
     }
     else {//802.11a/b packet
@@ -2238,10 +2241,12 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
         // This will cause AID-field of PS-POLL packet be incorrect (Because PS-POLL's AID field is
         // in the same place of other packet's Duration-field).
         // And it will cause Cisco-AP to issue Disassociation-packet
-        if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-            ((PSTxDataHead_g)pvTxDataHd)->wDuration_a = cpu_to_le16(p80211Header->sA2.wDurationID);
-            ((PSTxDataHead_g)pvTxDataHd)->wDuration_b = cpu_to_le16(p80211Header->sA2.wDurationID);
-        } else {
+	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
+		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_a =
+			cpu_to_le16(p80211Header->sA2.wDurationID);
+		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_b =
+			cpu_to_le16(p80211Header->sA2.wDurationID);
+	} else {
             ((PSTxDataHead_ab)pvTxDataHd)->wDuration = cpu_to_le16(p80211Header->sA2.wDurationID);
         }
     }
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 7573760..3c82623 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -54,6 +54,20 @@ struct vnt_rrv_time_ab {
 	u16 wTxRrvTime;
 } __packed;
 
+/* TX data header */
+struct vnt_tx_datahead_g {
+	u8 bySignalField_b;
+	u8 byServiceField_b;
+	u16 wTransmitLength_b;
+	u8 bySignalField_a;
+	u8 byServiceField_a;
+	u16 wTransmitLength_a;
+	u16 wDuration_b;
+	u16 wDuration_a;
+	u16 wTimeStampOff_b;
+	u16 wTimeStampOff_a;
+} __packed;
+
 /* RTS buffer header */
 struct vnt_rts_g {
 	u8 bySignalField_b;
-- 
1.8.1.2

