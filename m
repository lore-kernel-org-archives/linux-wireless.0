Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43367 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760249Ab3HOU13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 16:27:29 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so600597ead.17
        for <linux-wireless@vger.kernel.org>; Thu, 15 Aug 2013 13:27:27 -0700 (PDT)
Message-ID: <1376598442.8200.29.camel@canaries32-MCP7A> (sfid-20130815_222731_983274_DFEC1B97)
Subject: [PATCH 2/2] staging: vt6656: desc.h Move typedef struct tagSCTS* to
 new structures in rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Aug 2013 21:27:22 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new structures being
typedef struct tagSCTS -> struct vnt_cts
typedef struct tagSCTS_FB -> struct vnt_cts_fb

These are only needed by rxtc.c so moved to rxtx.h and
will eventually form part of the structure of
struct vnt_tx_buffer.

The linux/ieee80211.h in desc.h is no longer needed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 32 ------------------------------
 drivers/staging/vt6656/rxtx.c | 45 ++++++++++++++++++++++++++++---------------
 drivers/staging/vt6656/rxtx.h | 23 ++++++++++++++++++++++
 3 files changed, 53 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 4e2eb18..d770a78 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -33,7 +33,6 @@
 
 #include <linux/types.h>
 #include <linux/mm.h>
-#include <linux/ieee80211.h>
 
 #include "tether.h"
 
@@ -186,37 +185,6 @@ SRrvTime_atim, *PSRrvTime_atim;
 typedef const SRrvTime_atim *PCSRrvTime_atim;
 
 /*
- * CTS buffer header
- */
-typedef struct tagSCTS {
-    u8        bySignalField_b;
-    u8        byServiceField_b;
-    u16        wTransmitLength_b;
-    u16        wDuration_ba;
-    u16        wReserved;
-	struct ieee80211_cts data;
-	u16 reserved2;
-} __attribute__ ((__packed__))
-SCTS, *PSCTS;
-
-typedef const SCTS *PCSCTS;
-
-typedef struct tagSCTS_FB {
-    u8        bySignalField_b;
-    u8        byServiceField_b;
-    u16        wTransmitLength_b;
-    u16        wDuration_ba;
-    u16        wReserved;
-    u16        wCTSDuration_ba_f0;
-    u16        wCTSDuration_ba_f1;
-	struct ieee80211_cts data;
-	u16 reserved2;
-} __attribute__ ((__packed__))
-SCTS_FB, *PSCTS_FB;
-
-typedef const SCTS_FB *PCSCTS_FB;
-
-/*
  * TX FIFO header
  */
 typedef struct tagSTxBufHead {
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index e7ff845..d9827b3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -822,7 +822,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
         if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA) {
             // Auto Fall back
-            PSCTS_FB pBuf = (PSCTS_FB)pvCTS;
+		struct vnt_cts_fb *pBuf = (struct vnt_cts_fb *)pvCTS;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
@@ -844,7 +844,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		pBuf->data.frame_control = TYPE_CTL_CTS;
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
         } else { //if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA)
-            PSCTS pBuf = (PSCTS)pvCTS;
+		struct vnt_cts *pBuf = (struct vnt_cts *)pvCTS;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
@@ -1165,9 +1165,13 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
                 pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
                 pvRTS = NULL;
-                pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR);
-                pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS));
-                cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS) + sizeof(STxDataHead_g);
+		pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
+				sizeof(SRrvTime_gCTS) + cbMICHDR);
+		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(SRrvTime_gCTS) + cbMICHDR +
+						sizeof(struct vnt_cts));
+		cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR +
+			sizeof(struct vnt_cts) + sizeof(STxDataHead_g);
             }
         } else {
             // Auto Fall Back
@@ -1187,9 +1191,14 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
                 pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
                 pvRTS = NULL;
-                pvCTS = (PSCTS_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR);
-                pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS_FB));
-                cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS_FB) + sizeof(STxDataHead_g_FB);
+		pvCTS = (struct vnt_cts_fb *) (pbyTxBufferAddr + wTxBufSize +
+					sizeof(SRrvTime_gCTS) + cbMICHDR);
+		pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr +
+			wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR +
+						sizeof(struct vnt_cts_fb));
+		cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gCTS) +
+				cbMICHDR + sizeof(struct vnt_cts_fb) +
+					sizeof(STxDataHead_g_FB);
             }
         } // Auto Fall Back
     }
@@ -1508,7 +1517,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	PSTxBufHead pTxBufHead;
 	PUSB_SEND_CONTEXT pContext;
 	struct ieee80211_hdr *pMACHeader;
-	PSCTS pCTS;
+	struct vnt_cts *pCTS;
 	struct ethhdr sEthHeader;
 	u8 byPktType, *pbyTxBufferAddr;
 	void *pvRTS, *pvTxDataHd, *pvRrvTime, *pMICHDR;
@@ -1647,9 +1656,12 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
         pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
         pMICHDR = NULL;
         pvRTS = NULL;
-        pCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
-        pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + sizeof(SCTS));
-        cbHeaderSize = wTxBufSize + sizeof(SRrvTime_gCTS) + sizeof(SCTS) + sizeof(STxDataHead_g);
+	pCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
+						sizeof(SRrvTime_gCTS));
+	pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
+		sizeof(SRrvTime_gCTS) + sizeof(struct vnt_cts));
+	cbHeaderSize = wTxBufSize + sizeof(SRrvTime_gCTS) +
+		sizeof(struct vnt_cts) + sizeof(STxDataHead_g);
     }
     else { // 802.11a/b packet
         pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
@@ -2047,9 +2059,12 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
         pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
         pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
         pvRTS = NULL;
-        pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR);
-        pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS));
-        cbHeaderSize = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS) + sizeof(STxDataHead_g);
+	pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(SRrvTime_gCTS) + cbMICHDR);
+	pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
+		sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(struct vnt_cts));
+	cbHeaderSize = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR +
+				sizeof(struct vnt_cts) + sizeof(STxDataHead_g);
 
     }
     else {//802.11a/b packet
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 8ce5bfc..8fd5be1 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -85,6 +85,29 @@ struct vnt_rts_a_fb {
 	struct ieee80211_rts data;
 } __packed;
 
+/* CTS buffer header */
+struct vnt_cts {
+	u8 bySignalField_b;
+	u8 byServiceField_b;
+	u16 wTransmitLength_b;
+	u16 wDuration_ba;
+	u16 wReserved;
+	struct ieee80211_cts data;
+	u16 reserved2;
+} __packed;
+
+struct vnt_cts_fb {
+	u8 bySignalField_b;
+	u8 byServiceField_b;
+	u16 wTransmitLength_b;
+	u16 wDuration_ba;
+	u16 wReserved;
+	u16 wCTSDuration_ba_f0;
+	u16 wCTSDuration_ba_f1;
+	struct ieee80211_cts data;
+	u16 reserved2;
+} __packed;
+
 struct vnt_tx_buffer {
 	u8 byType;
 	u8 byPKTNO;
-- 
1.8.1.2




