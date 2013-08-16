Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43169 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab3HPWS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:18:57 -0400
Received: by mail-wg0-f48.google.com with SMTP id f12so1966169wgh.27
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 15:18:56 -0700 (PDT)
Message-ID: <1376684815.8057.44.camel@canaries32-MCP7A> (sfid-20130817_001905_698515_2794B496)
Subject: [PATCH 1/8] staging: vt6656: desc.h: Move typedef tagSRrvTime_gRTS
 to new structure in rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 21:26:55 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To new structure.
typedef struct tagSRrvTime_gRTS -> struct vnt_rrv_time_rts

This is only needed by rxtc.c so moved to rxtx.h and
will eventually form part of the structure of
struct vnt_tx_buffer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 12 ------------
 drivers/staging/vt6656/rxtx.c | 30 ++++++++++++++++++------------
 drivers/staging/vt6656/rxtx.h | 10 ++++++++++
 3 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index d770a78..89b580d 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -146,18 +146,6 @@
 /*
  * RsvTime buffer header
  */
-typedef struct tagSRrvTime_gRTS {
-    u16        wRTSTxRrvTime_ba;
-    u16        wRTSTxRrvTime_aa;
-    u16        wRTSTxRrvTime_bb;
-    u16        wReserved;
-    u16        wTxRrvTime_b;
-    u16        wTxRrvTime_a;
-} __attribute__ ((__packed__))
-SRrvTime_gRTS, *PSRrvTime_gRTS;
-
-typedef const SRrvTime_gRTS *PCSRrvTime_gRTS;
-
 typedef struct tagSRrvTime_gCTS {
     u16        wCTSTxRrvTime_ba;
     u16        wReserved;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index d9827b3..c9dceae 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -919,7 +919,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         if (pvRTS != NULL) { //RTS_need
             //Fill RsvTime
             if (pvRrvTime) {
-                PSRrvTime_gRTS pBuf = (PSRrvTime_gRTS)pvRrvTime;
+		struct vnt_rrv_time_rts *pBuf =
+			(struct vnt_rrv_time_rts *)pvRrvTime;
                 pBuf->wRTSTxRrvTime_aa = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));//2:RTSTxRrvTime_aa, 1:2.4GHz
                 pBuf->wRTSTxRrvTime_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 1, byPktType, cbFrameSize, wCurrentRate));//1:RTSTxRrvTime_ba, 1:2.4GHz
                 pBuf->wRTSTxRrvTime_bb = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));//0:RTSTxRrvTime_bb, 1:2.4GHz
@@ -1149,15 +1150,17 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-                pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
-                pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
+		pvRrvTime = (struct vnt_rrv_time_rts *)
+					(pbyTxBufferAddr + wTxBufSize);
+		pMICHDR = (PSMICHDRHead)(pbyTxBufferAddr + wTxBufSize +
+					sizeof(struct vnt_rrv_time_rts));
 		pvRTS = (struct vnt_rts_g *) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(SRrvTime_gRTS) + cbMICHDR);
+				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
                 pvCTS = NULL;
 		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(SRrvTime_gRTS) + cbMICHDR +
+			sizeof(struct vnt_rrv_time_rts) + cbMICHDR +
 						sizeof(struct vnt_rts_g));
-		cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) +
+		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
 			cbMICHDR + sizeof(struct vnt_rts_g) +
 				sizeof(STxDataHead_g);
             }
@@ -1176,16 +1179,19 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-                pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
-                pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
+		pvRrvTime = (struct vnt_rrv_time_rts *)(pbyTxBufferAddr +
+								wTxBufSize);
+		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+					sizeof(struct vnt_rrv_time_rts));
 		pvRTS = (struct vnt_rts_g_fb *) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(SRrvTime_gRTS) + cbMICHDR);
+				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
                 pvCTS = NULL;
 		pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(SRrvTime_gRTS) + cbMICHDR +
+			sizeof(struct vnt_rrv_time_rts) + cbMICHDR +
 					sizeof(struct vnt_rts_g_fb));
-		cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR +
-			sizeof(struct vnt_rts_g_fb) + sizeof(STxDataHead_g_FB);
+		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
+			cbMICHDR + sizeof(struct vnt_rts_g_fb) +
+				sizeof(STxDataHead_g_FB);
             }
             else if (bRTS == false) { //RTS_needless
                 pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 8fd5be1..8afade2 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -32,6 +32,16 @@
 #include "device.h"
 #include "wcmd.h"
 
+/* RsvTime buffer header */
+struct vnt_rrv_time_rts {
+	u16 wRTSTxRrvTime_ba;
+	u16 wRTSTxRrvTime_aa;
+	u16 wRTSTxRrvTime_bb;
+	u16 wReserved;
+	u16 wTxRrvTime_b;
+	u16 wTxRrvTime_a;
+} __packed;
+
 /* RTS buffer header */
 struct vnt_rts_g {
 	u8 bySignalField_b;
-- 
1.8.1.2



