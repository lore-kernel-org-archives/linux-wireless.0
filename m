Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:48580 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3HPWvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:51:46 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so2116154wes.39
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 15:51:45 -0700 (PDT)
Message-ID: <1376693498.18777.8.camel@canaries32-MCP7A> (sfid-20130817_005236_723532_E52FB1BD)
Subject: [PATCH 8/8] staging: vt6656: desc.h remove typedef
 tagSTxDataHead_a_FB  to new structure in rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 23:51:38 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To new structure.
typedef struct tagSTxDataHead_a_FB -> struct vnt_tx_datahead_a_fb

This is only needed by rxtc.c so moved to rxtx.h visible to
vnt_rts* structures which it will eventually form part of
their structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 15 ---------------
 drivers/staging/vt6656/rxtx.c | 15 ++++++++-------
 drivers/staging/vt6656/rxtx.h | 10 ++++++++++
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index d350fd3..b3e8cc1 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -164,21 +164,6 @@ STxShortBufHead, *PSTxShortBufHead;
 typedef const STxShortBufHead *PCSTxShortBufHead;
 
 /*
- * TX data header
- */
-typedef struct tagSTxDataHead_a_FB {
-    u8    bySignalField;
-    u8    byServiceField;
-    u16    wTransmitLength;
-    u16    wDuration;
-    u16    wTimeStampOff;
-    u16    wDuration_f0;
-    u16    wDuration_f1;
-} __attribute__ ((__packed__))
-STxDataHead_a_FB, *PSTxDataHead_a_FB;
-typedef const STxDataHead_a_FB *PCSTxDataHead_a_FB;
-
-/*
  * MICHDR data header
  */
 typedef struct tagSMICHDRHead {
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a4d3728..d7f920d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -563,7 +563,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
     else if (byPktType == PK_TYPE_11A) {
         if ((byFBOption != AUTO_FB_NONE) && (uDMAIdx != TYPE_ATIMDMA) && (uDMAIdx != TYPE_BEACONDMA)) {
             // Auto Fallback
-            PSTxDataHead_a_FB pBuf = (PSTxDataHead_a_FB)pTxDataHead;
+		struct vnt_tx_datahead_a_fb *pBuf =
+			(struct vnt_tx_datahead_a_fb *)pTxDataHead;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                 (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
@@ -1262,12 +1263,12 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 		pvRTS = (struct vnt_rts_a_fb *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
                 pvCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
+		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
+			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
 					sizeof(struct vnt_rts_a_fb));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
 			cbMICHDR + sizeof(struct vnt_rts_a_fb) +
-					sizeof(STxDataHead_a_FB);
+					sizeof(struct vnt_tx_datahead_a_fb);
             }
             else if (bRTS == false) { //RTS_needless
 		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
@@ -1276,10 +1277,10 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 						sizeof(struct vnt_rrv_time_ab));
                 pvRTS = NULL;
                 pvCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
+			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-			cbMICHDR + sizeof(STxDataHead_a_FB);
+			cbMICHDR + sizeof(struct vnt_tx_datahead_a_fb);
             }
         } // Auto Fall Back
     }
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index d66d71d..b1ef90e 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -91,6 +91,16 @@ struct vnt_tx_datahead_ab {
 	u16 wTimeStampOff;
 } __packed;
 
+struct vnt_tx_datahead_a_fb {
+	u8 bySignalField;
+	u8 byServiceField;
+	u16 wTransmitLength;
+	u16 wDuration;
+	u16 wTimeStampOff;
+	u16 wDuration_f0;
+	u16 wDuration_f1;
+} __packed;
+
 /* RTS buffer header */
 struct vnt_rts_g {
 	u8 bySignalField_b;
-- 
1.8.1.2

