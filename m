Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42004 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab3HPWjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:07 -0400
Received: by mail-wi0-f175.google.com with SMTP id hq12so1355158wib.8
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 15:39:06 -0700 (PDT)
Message-ID: <1376692737.18777.0.camel@canaries32-MCP7A> (sfid-20130817_021552_545893_07C912B1)
Subject: [PATCH 2/8] staging: vt6656: desc.h: Move typedef struct
 tagSRrvTime_gCTS to new structure in rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 23:38:57 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To new structure.
typedef struct tagSRrvTime_gCTS -> struct vnt_rrv_time_cts

This is only needed by rxtc.c so moved to rxtx.h and
will eventually form part of the structure of
struct vnt_tx_buffer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 10 --------
 drivers/staging/vt6656/rxtx.c | 53 ++++++++++++++++++++++++-------------------
 drivers/staging/vt6656/rxtx.h |  7 ++++++
 3 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 89b580d..ae0ce51 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -146,16 +146,6 @@
 /*
  * RsvTime buffer header
  */
-typedef struct tagSRrvTime_gCTS {
-    u16        wCTSTxRrvTime_ba;
-    u16        wReserved;
-    u16        wTxRrvTime_b;
-    u16        wTxRrvTime_a;
-} __attribute__ ((__packed__))
-SRrvTime_gCTS, *PSRrvTime_gCTS;
-
-typedef const SRrvTime_gCTS *PCSRrvTime_gCTS;
-
 typedef struct tagSRrvTime_ab {
     u16        wRTSTxRrvTime;
     u16        wTxRrvTime;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c9dceae..9c52c31 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -934,7 +934,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 
             //Fill RsvTime
             if (pvRrvTime) {
-                PSRrvTime_gCTS pBuf = (PSRrvTime_gCTS)pvRrvTime;
+		struct vnt_rrv_time_cts *pBuf =
+				(struct vnt_rrv_time_cts *)pvRrvTime;
                 pBuf->wTxRrvTime_a = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//2.4G OFDM
                 pBuf->wTxRrvTime_b = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));//1:CCK
                 pBuf->wCTSTxRrvTime_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 3, byPktType, cbFrameSize, wCurrentRate));//3:CTSTxRrvTime_Ba, 1:2.4GHz
@@ -1165,16 +1166,19 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(STxDataHead_g);
             }
             else { //RTS_needless
-                pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
-                pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
+		pvRrvTime = (struct vnt_rrv_time_cts *)
+				(pbyTxBufferAddr + wTxBufSize);
+		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(struct vnt_rrv_time_cts));
                 pvRTS = NULL;
 		pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(SRrvTime_gCTS) + cbMICHDR);
+				sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(SRrvTime_gCTS) + cbMICHDR +
+			sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
 						sizeof(struct vnt_cts));
-		cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR +
-			sizeof(struct vnt_cts) + sizeof(STxDataHead_g);
+		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
+			cbMICHDR + sizeof(struct vnt_cts) +
+				sizeof(STxDataHead_g);
             }
         } else {
             // Auto Fall Back
@@ -1194,15 +1198,17 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(STxDataHead_g_FB);
             }
             else if (bRTS == false) { //RTS_needless
-                pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
-                pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
+		pvRrvTime = (struct vnt_rrv_time_cts *)
+				(pbyTxBufferAddr + wTxBufSize);
+		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+				sizeof(struct vnt_rrv_time_cts));
                 pvRTS = NULL;
 		pvCTS = (struct vnt_cts_fb *) (pbyTxBufferAddr + wTxBufSize +
-					sizeof(SRrvTime_gCTS) + cbMICHDR);
+			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 		pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr +
-			wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR +
-						sizeof(struct vnt_cts_fb));
-		cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gCTS) +
+			wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
+				cbMICHDR + sizeof(struct vnt_cts_fb));
+		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
 				cbMICHDR + sizeof(struct vnt_cts_fb) +
 					sizeof(STxDataHead_g_FB);
             }
@@ -1659,14 +1665,14 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     //Set RrvTime/RTS/CTS Buffer
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
 
-        pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
+	pvRrvTime = (struct vnt_rrv_time_cts *) (pbyTxBufferAddr + wTxBufSize);
         pMICHDR = NULL;
         pvRTS = NULL;
 	pCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
-						sizeof(SRrvTime_gCTS));
+					sizeof(struct vnt_rrv_time_cts));
 	pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
-		sizeof(SRrvTime_gCTS) + sizeof(struct vnt_cts));
-	cbHeaderSize = wTxBufSize + sizeof(SRrvTime_gCTS) +
+		sizeof(struct vnt_rrv_time_cts) + sizeof(struct vnt_cts));
+	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
 		sizeof(struct vnt_cts) + sizeof(STxDataHead_g);
     }
     else { // 802.11a/b packet
@@ -2061,15 +2067,16 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-
-        pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
-        pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
+	pvRrvTime = (struct vnt_rrv_time_cts *) (pbyTxBufferAddr + wTxBufSize);
+	pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+					sizeof(struct vnt_rrv_time_cts));
         pvRTS = NULL;
 	pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(SRrvTime_gCTS) + cbMICHDR);
+			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 	pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
-		sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(struct vnt_cts));
-	cbHeaderSize = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR +
+		sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
+					sizeof(struct vnt_cts));
+	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
 				sizeof(struct vnt_cts) + sizeof(STxDataHead_g);
 
     }
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 8afade2..35a6b47 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -42,6 +42,13 @@ struct vnt_rrv_time_rts {
 	u16 wTxRrvTime_a;
 } __packed;
 
+struct vnt_rrv_time_cts {
+	u16 wCTSTxRrvTime_ba;
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

