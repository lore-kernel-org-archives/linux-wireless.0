Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63719 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3HPWoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:44:13 -0400
Received: by mail-wi0-f171.google.com with SMTP id hr7so1358790wib.4
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 15:44:11 -0700 (PDT)
Message-ID: <1376693044.18777.1.camel@canaries32-MCP7A> (sfid-20130817_004418_697057_286A95EE)
Subject: [PATCH 3/8] staging: vt6656: desc.h remove typedef SRrvTime_ab to
 new structure.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 23:44:04 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To new structure.
typedef struct tagSRrvTime_ab -> struct vnt_rrv_time_ab

This is only needed by rxtc.c so moved to rxtx.h and
will eventually form part of the structure of
struct vnt_tx_buffer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h |  8 ----
 drivers/staging/vt6656/rxtx.c | 85 +++++++++++++++++++++++++++----------------
 drivers/staging/vt6656/rxtx.h |  5 +++
 3 files changed, 59 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index ae0ce51..c2dec3b 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -146,14 +146,6 @@
 /*
  * RsvTime buffer header
  */
-typedef struct tagSRrvTime_ab {
-    u16        wRTSTxRrvTime;
-    u16        wTxRrvTime;
-} __attribute__ ((__packed__))
-SRrvTime_ab, *PSRrvTime_ab;
-
-typedef const SRrvTime_ab *PCSRrvTime_ab;
-
 typedef struct tagSRrvTime_atim {
     u16        wCTSTxRrvTime_ba;
     u16        wTxRrvTime_a;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9c52c31..b21a496 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -949,7 +949,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         if (pvRTS != NULL) {//RTS_need, non PCF mode
             //Fill RsvTime
             if (pvRrvTime) {
-                PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+		struct vnt_rrv_time_ab *pBuf =
+				(struct vnt_rrv_time_ab *)pvRrvTime;
                 pBuf->wRTSTxRrvTime = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));//2:RTSTxRrvTime_aa, 0:5GHz
                 pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//0:OFDM
             }
@@ -959,7 +960,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         else if (pvRTS == NULL) {//RTS_needless, non PCF mode
             //Fill RsvTime
             if (pvRrvTime) {
-                PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+		struct vnt_rrv_time_ab *pBuf =
+				(struct vnt_rrv_time_ab *)pvRrvTime;
                 pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11A, cbFrameSize, wCurrentRate, bNeedACK)); //0:OFDM
             }
         }
@@ -969,7 +971,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         if ((pvRTS != NULL)) {//RTS_need, non PCF mode
             //Fill RsvTime
             if (pvRrvTime) {
-                PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+		struct vnt_rrv_time_ab *pBuf =
+				(struct vnt_rrv_time_ab *)pvRrvTime;
                 pBuf->wRTSTxRrvTime = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));//0:RTSTxRrvTime_bb, 1:2.4GHz
                 pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK));//1:CCK
             }
@@ -979,7 +982,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         else { //RTS_needless, non PCF mode
             //Fill RsvTime
             if (pvRrvTime) {
-                PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+		struct vnt_rrv_time_ab *pBuf =
+				(struct vnt_rrv_time_ab *)pvRrvTime;
                 pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK)); //1:CCK
             }
         }
@@ -1217,46 +1221,60 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     else {//802.11a/b packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-                pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-                pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+		pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr +
+								wTxBufSize);
+		pMICHDR = (PSMICHDRHead)(pbyTxBufferAddr + wTxBufSize +
+						sizeof(struct vnt_rrv_time_ab));
 		pvRTS = (struct vnt_rts_ab *) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(SRrvTime_ab) + cbMICHDR);
+				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
                 pvCTS = NULL;
 		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(SRrvTime_ab) + cbMICHDR +
+			sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
 						sizeof(struct vnt_rts_ab));
-		cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR +
-			sizeof(struct vnt_rts_ab) + sizeof(STxDataHead_ab);
+		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+			cbMICHDR + sizeof(struct vnt_rts_ab) +
+				sizeof(STxDataHead_ab);
             }
             else if (bRTS == false) { //RTS_needless, no MICHDR
-                pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-                pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
+								wTxBufSize);
+		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+						sizeof(struct vnt_rrv_time_ab));
                 pvRTS = NULL;
                 pvCTS = NULL;
-                pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
-                cbHeaderLength = wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(STxDataHead_ab);
+		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize +
+				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+					cbMICHDR + sizeof(STxDataHead_ab);
             }
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-                pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-                pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
+						wTxBufSize);
+		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(struct vnt_rrv_time_ab));
 		pvRTS = (struct vnt_rts_a_fb *) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(SRrvTime_ab) + cbMICHDR);
+				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
                 pvCTS = NULL;
 		pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(SRrvTime_ab) + cbMICHDR +
+			sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
 					sizeof(struct vnt_rts_a_fb));
-		cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR +
-			sizeof(struct vnt_rts_a_fb) + sizeof(STxDataHead_a_FB);
+		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+			cbMICHDR + sizeof(struct vnt_rts_a_fb) +
+					sizeof(STxDataHead_a_FB);
             }
             else if (bRTS == false) { //RTS_needless
-                pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-                pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
+								wTxBufSize);
+		pMICHDR = (PSMICHDRHead)(pbyTxBufferAddr + wTxBufSize +
+						sizeof(struct vnt_rrv_time_ab));
                 pvRTS = NULL;
                 pvCTS = NULL;
-                pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
-                cbHeaderLength = wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(STxDataHead_a_FB);
+		pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+			cbMICHDR + sizeof(STxDataHead_a_FB);
             }
         } // Auto Fall Back
     }
@@ -1676,12 +1694,14 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 		sizeof(struct vnt_cts) + sizeof(STxDataHead_g);
     }
     else { // 802.11a/b packet
-        pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
+	pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr + wTxBufSize);
         pMICHDR = NULL;
         pvRTS = NULL;
         pCTS = NULL;
-        pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
-        cbHeaderSize = wTxBufSize + sizeof(SRrvTime_ab) + sizeof(STxDataHead_ab);
+	pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize +
+					sizeof(struct vnt_rrv_time_ab));
+	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+		sizeof(STxDataHead_ab);
     }
 
     memcpy(&(sEthHeader.h_dest[0]),
@@ -2082,12 +2102,15 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     }
     else {//802.11a/b packet
 
-        pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-        pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+	pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr + wTxBufSize);
+	pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+		sizeof(struct vnt_rrv_time_ab));
         pvRTS = NULL;
         pvCTS = NULL;
-        pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
-        cbHeaderSize = wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(STxDataHead_ab);
+	pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize +
+		sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
+							sizeof(STxDataHead_ab);
     }
     memcpy(&(sEthHeader.h_dest[0]),
 	   &(p80211Header->sA3.abyAddr1[0]),
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 35a6b47..7573760 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -49,6 +49,11 @@ struct vnt_rrv_time_cts {
 	u16 wTxRrvTime_a;
 } __packed;
 
+struct vnt_rrv_time_ab {
+	u16 wRTSTxRrvTime;
+	u16 wTxRrvTime;
+} __packed;
+
 /* RTS buffer header */
 struct vnt_rts_g {
 	u8 bySignalField_b;
-- 
1.8.1.2

