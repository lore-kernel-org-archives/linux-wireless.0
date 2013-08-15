Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:35135 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760249Ab3HOUXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 16:23:33 -0400
Received: by mail-ee0-f41.google.com with SMTP id d17so588467eek.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Aug 2013 13:23:32 -0700 (PDT)
Message-ID: <1376598205.8200.27.camel@canaries32-MCP7A> (sfid-20130815_222339_344448_B72A3E72)
Subject: [PATCH 1/2] staging: vt6656: desc.h Remove typedef struct tagSRTS_*
 to new strutures in rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Aug 2013 21:23:25 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new structures being
typedef struct tagSRTS_g -> struct vnt_rts_g
typedef struct tagSRTS_g_FB -> struct vnt_rts_g_fb
typedef struct tagSRTS_ab -> struct vnt_rts_ab
typedef struct tagSRTS_a_FB -> struct vnt_rts_a_fb

These are only needed by rxtc.c so moved to rxtx.h and
will eventually form part of the structure of
struct vnt_tx_buffer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 66 -------------------------------------------
 drivers/staging/vt6656/rxtx.c | 51 ++++++++++++++++++++++-----------
 drivers/staging/vt6656/rxtx.h | 53 ++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 1a1cf34..4e2eb18 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -186,72 +186,6 @@ SRrvTime_atim, *PSRrvTime_atim;
 typedef const SRrvTime_atim *PCSRrvTime_atim;
 
 /*
- * RTS buffer header
- */
-typedef struct tagSRTS_g {
-    u8        bySignalField_b;
-    u8        byServiceField_b;
-    u16        wTransmitLength_b;
-    u8        bySignalField_a;
-    u8        byServiceField_a;
-    u16        wTransmitLength_a;
-    u16        wDuration_ba;
-    u16        wDuration_aa;
-    u16        wDuration_bb;
-    u16        wReserved;
-	struct ieee80211_rts data;
-} __attribute__ ((__packed__))
-SRTS_g, *PSRTS_g;
-typedef const SRTS_g *PCSRTS_g;
-
-typedef struct tagSRTS_g_FB {
-    u8        bySignalField_b;
-    u8        byServiceField_b;
-    u16        wTransmitLength_b;
-    u8        bySignalField_a;
-    u8        byServiceField_a;
-    u16        wTransmitLength_a;
-    u16        wDuration_ba;
-    u16        wDuration_aa;
-    u16        wDuration_bb;
-    u16        wReserved;
-    u16        wRTSDuration_ba_f0;
-    u16        wRTSDuration_aa_f0;
-    u16        wRTSDuration_ba_f1;
-    u16        wRTSDuration_aa_f1;
-	struct ieee80211_rts data;
-} __attribute__ ((__packed__))
-SRTS_g_FB, *PSRTS_g_FB;
-
-typedef const SRTS_g_FB *PCSRTS_g_FB;
-
-typedef struct tagSRTS_ab {
-    u8        bySignalField;
-    u8        byServiceField;
-    u16        wTransmitLength;
-    u16        wDuration;
-    u16        wReserved;
-	struct ieee80211_rts data;
-} __attribute__ ((__packed__))
-SRTS_ab, *PSRTS_ab;
-
-typedef const SRTS_ab *PCSRTS_ab;
-
-typedef struct tagSRTS_a_FB {
-    u8        bySignalField;
-    u8        byServiceField;
-    u16        wTransmitLength;
-    u16        wDuration;
-    u16        wReserved;
-    u16        wRTSDuration_f0;
-    u16        wRTSDuration_f1;
-	struct ieee80211_rts data;
-} __attribute__ ((__packed__))
-SRTS_a_FB, *PSRTS_a_FB;
-
-typedef const SRTS_a_FB *PCSRTS_a_FB;
-
-/*
  * CTS buffer header
  */
 typedef struct tagSCTS {
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7a4ebbc..e7ff845 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -629,7 +629,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
     //       Otherwise, we need to modified codes for them.
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
         if (byFBOption == AUTO_FB_NONE) {
-            PSRTS_g pBuf = (PSRTS_g)pvRTS;
+		struct vnt_rts_g *pBuf = (struct vnt_rts_g *)pvRTS;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
@@ -665,7 +665,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 			memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
         }
         else {
-           PSRTS_g_FB pBuf = (PSRTS_g_FB)pvRTS;
+		struct vnt_rts_g_fb *pBuf = (struct vnt_rts_g_fb *)pvRTS;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
@@ -715,7 +715,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
     }
     else if (byPktType == PK_TYPE_11A) {
         if (byFBOption == AUTO_FB_NONE) {
-            PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
+		struct vnt_rts_ab *pBuf = (struct vnt_rts_ab *)pvRTS;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
@@ -741,7 +741,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 			memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
         }
         else {
-            PSRTS_a_FB pBuf = (PSRTS_a_FB)pvRTS;
+		struct vnt_rts_a_fb *pBuf = (struct vnt_rts_a_fb *)pvRTS;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
@@ -774,7 +774,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         }
     }
     else if (byPktType == PK_TYPE_11B) {
-        PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
+	struct vnt_rts_ab *pBuf = (struct vnt_rts_ab *)pvRTS;
         //Get SignalField,ServiceField,Length
         BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
             (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
@@ -1151,10 +1151,15 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             if (bRTS == true) {//RTS_need
                 pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
-                pvRTS = (PSRTS_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR);
+		pvRTS = (struct vnt_rts_g *) (pbyTxBufferAddr + wTxBufSize +
+				sizeof(SRrvTime_gRTS) + cbMICHDR);
                 pvCTS = NULL;
-                pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g));
-                cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g) + sizeof(STxDataHead_g);
+		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(SRrvTime_gRTS) + cbMICHDR +
+						sizeof(struct vnt_rts_g));
+		cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) +
+			cbMICHDR + sizeof(struct vnt_rts_g) +
+				sizeof(STxDataHead_g);
             }
             else { //RTS_needless
                 pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
@@ -1169,10 +1174,14 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             if (bRTS == true) {//RTS_need
                 pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
-                pvRTS = (PSRTS_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR);
+		pvRTS = (struct vnt_rts_g_fb *) (pbyTxBufferAddr + wTxBufSize +
+				sizeof(SRrvTime_gRTS) + cbMICHDR);
                 pvCTS = NULL;
-                pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g_FB));
-                cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g_FB) + sizeof(STxDataHead_g_FB);
+		pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(SRrvTime_gRTS) + cbMICHDR +
+					sizeof(struct vnt_rts_g_fb));
+		cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR +
+			sizeof(struct vnt_rts_g_fb) + sizeof(STxDataHead_g_FB);
             }
             else if (bRTS == false) { //RTS_needless
                 pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
@@ -1189,10 +1198,14 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             if (bRTS == true) {//RTS_need
                 pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
-                pvRTS = (PSRTS_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
+		pvRTS = (struct vnt_rts_ab *) (pbyTxBufferAddr + wTxBufSize +
+				sizeof(SRrvTime_ab) + cbMICHDR);
                 pvCTS = NULL;
-                pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(SRTS_ab));
-                cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_ab) + sizeof(STxDataHead_ab);
+		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(SRrvTime_ab) + cbMICHDR +
+						sizeof(struct vnt_rts_ab));
+		cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR +
+			sizeof(struct vnt_rts_ab) + sizeof(STxDataHead_ab);
             }
             else if (bRTS == false) { //RTS_needless, no MICHDR
                 pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
@@ -1207,10 +1220,14 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             if (bRTS == true) {//RTS_need
                 pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
-                pvRTS = (PSRTS_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
+		pvRTS = (struct vnt_rts_a_fb *) (pbyTxBufferAddr + wTxBufSize +
+				sizeof(SRrvTime_ab) + cbMICHDR);
                 pvCTS = NULL;
-                pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(SRTS_a_FB));
-                cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_a_FB) + sizeof(STxDataHead_a_FB);
+		pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(SRrvTime_ab) + cbMICHDR +
+					sizeof(struct vnt_rts_a_fb));
+		cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR +
+			sizeof(struct vnt_rts_a_fb) + sizeof(STxDataHead_a_FB);
             }
             else if (bRTS == false) { //RTS_needless
                 pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 3e347a9..8ce5bfc 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -32,6 +32,59 @@
 #include "device.h"
 #include "wcmd.h"
 
+/* RTS buffer header */
+struct vnt_rts_g {
+	u8 bySignalField_b;
+	u8 byServiceField_b;
+	u16 wTransmitLength_b;
+	u8 bySignalField_a;
+	u8 byServiceField_a;
+	u16 wTransmitLength_a;
+	u16 wDuration_ba;
+	u16 wDuration_aa;
+	u16 wDuration_bb;
+	u16 wReserved;
+	struct ieee80211_rts data;
+} __packed;
+
+struct vnt_rts_g_fb {
+	u8 bySignalField_b;
+	u8 byServiceField_b;
+	u16 wTransmitLength_b;
+	u8 bySignalField_a;
+	u8 byServiceField_a;
+	u16 wTransmitLength_a;
+	u16 wDuration_ba;
+	u16 wDuration_aa;
+	u16 wDuration_bb;
+	u16 wReserved;
+	u16 wRTSDuration_ba_f0;
+	u16 wRTSDuration_aa_f0;
+	u16 wRTSDuration_ba_f1;
+	u16 wRTSDuration_aa_f1;
+	struct ieee80211_rts data;
+} __packed;
+
+struct vnt_rts_ab {
+	u8 bySignalField;
+	u8 byServiceField;
+	u16 wTransmitLength;
+	u16 wDuration;
+	u16 wReserved;
+	struct ieee80211_rts data;
+} __packed;
+
+struct vnt_rts_a_fb {
+	u8 bySignalField;
+	u8 byServiceField;
+	u16 wTransmitLength;
+	u16 wDuration;
+	u16 wReserved;
+	u16 wRTSDuration_f0;
+	u16 wRTSDuration_f1;
+	struct ieee80211_rts data;
+} __packed;
+
 struct vnt_tx_buffer {
 	u8 byType;
 	u8 byPKTNO;
-- 
1.8.1.2

