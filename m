Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:52151 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab3HPWtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:49:24 -0400
Received: by mail-we0-f181.google.com with SMTP id q57so1342827wes.40
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 15:49:23 -0700 (PDT)
Message-ID: <1376693355.18777.6.camel@canaries32-MCP7A> (sfid-20130817_004939_739761_920A295A)
Subject: [PATCH 6/8] staging: vt6656: desc.h remove typedef
 tagSTxDataHead_g_FB  to new structure in rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 23:49:15 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To new structure.
typedef struct tagSTxDataHead_g_FB -> struct vnt_tx_datahead_g_fb

This is only needed by rxtc.c so moved to rxtx.h visible to
vnt_rts*/vnt_cts* structures which it will eventually form part of
their structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 17 -----------------
 drivers/staging/vt6656/rxtx.c | 15 ++++++++-------
 drivers/staging/vt6656/rxtx.h | 15 +++++++++++++++
 3 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index b0cb8c4..1ee0331 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -166,23 +166,6 @@ typedef const STxShortBufHead *PCSTxShortBufHead;
 /*
  * TX data header
  */
-typedef struct tagSTxDataHead_g_FB {
-    u8    bySignalField_b;
-    u8    byServiceField_b;
-    u16    wTransmitLength_b;
-    u8    bySignalField_a;
-    u8    byServiceField_a;
-    u16    wTransmitLength_a;
-    u16    wDuration_b;
-    u16    wDuration_a;
-    u16    wDuration_a_f0;
-    u16    wDuration_a_f1;
-    u16    wTimeStampOff_b;
-    u16    wTimeStampOff_a;
-} __attribute__ ((__packed__))
-STxDataHead_g_FB, *PSTxDataHead_g_FB;
-typedef const STxDataHead_g_FB *PCSTxDataHead_g_FB;
-
 typedef struct tagSTxDataHead_ab {
     u8    bySignalField;
     u8    byServiceField;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 585a2e3..20c4656 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -535,7 +535,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
                 return (pBuf->wDuration_a);
              } else {
                 // Auto Fallback
-                PSTxDataHead_g_FB pBuf = (PSTxDataHead_g_FB)pTxDataHead;
+		struct vnt_tx_datahead_g_fb *pBuf =
+			(struct vnt_tx_datahead_g_fb *)pTxDataHead;
                 //Get SignalField,ServiceField,Length
                 BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
                     (u16 *)&(pBuf->wTransmitLength_a), (u8 *)&(pBuf->byServiceField_a), (u8 *)&(pBuf->bySignalField_a)
@@ -1195,12 +1196,12 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 		pvRTS = (struct vnt_rts_g_fb *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
                 pvCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_rts) + cbMICHDR +
-					sizeof(struct vnt_rts_g_fb));
+		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
+			wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
+				cbMICHDR + sizeof(struct vnt_rts_g_fb));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
 			cbMICHDR + sizeof(struct vnt_rts_g_fb) +
-				sizeof(STxDataHead_g_FB);
+				sizeof(struct vnt_tx_datahead_g_fb);
             }
             else if (bRTS == false) { //RTS_needless
 		pvRrvTime = (struct vnt_rrv_time_cts *)
@@ -1210,12 +1211,12 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
                 pvRTS = NULL;
 		pvCTS = (struct vnt_cts_fb *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
-		pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr +
+		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
 				cbMICHDR + sizeof(struct vnt_cts_fb));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
 				cbMICHDR + sizeof(struct vnt_cts_fb) +
-					sizeof(STxDataHead_g_FB);
+					sizeof(struct vnt_tx_datahead_g_fb);
             }
         } // Auto Fall Back
     }
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 3c82623..ba80271 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -68,6 +68,21 @@ struct vnt_tx_datahead_g {
 	u16 wTimeStampOff_a;
 } __packed;
 
+struct vnt_tx_datahead_g_fb {
+	u8 bySignalField_b;
+	u8 byServiceField_b;
+	u16 wTransmitLength_b;
+	u8 bySignalField_a;
+	u8 byServiceField_a;
+	u16 wTransmitLength_a;
+	u16 wDuration_b;
+	u16 wDuration_a;
+	u16 wDuration_a_f0;
+	u16 wDuration_a_f1;
+	u16 wTimeStampOff_b;
+	u16 wTimeStampOff_a;
+} __packed;
+
 /* RTS buffer header */
 struct vnt_rts_g {
 	u8 bySignalField_b;
-- 
1.8.1.2

