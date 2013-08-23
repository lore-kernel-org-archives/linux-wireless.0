Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:64965 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3HWNeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 09:34:06 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so300753ead.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 06:34:04 -0700 (PDT)
Message-ID: <1377264835.13953.35.camel@canaries32-MCP7A> (sfid-20130823_153411_544596_6C3EB170)
Subject: [PATCH 1/2] staging: vt6656: desc.h Remove typedef struct
 tagSMICHDRHead to new structure in rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Aug 2013 14:33:55 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To new structure.
typedef struct tagSMICHDRHead -> struct vnt_mic_hdr

This is only needed by rxtc.c so moved to rxtx.h

The new structure is the same size as the old but
contains the members as pointer referenced in
rxtx.c s_vFillTxKey
u8 id
	*pMICHDR = 0x59;
u8 tx_priority;
	*((u8 *)(pMICHDR+1)) = 0; // TxPriority
u8 mic_addr2[6];
	memcpy(pMICHDR+2, &(pMACHeader->addr2[0]), 6);
__be32 tsc_47_16;
	pMICHDR+8 = HIBYTE(HIWORD(pTransmitKey->dwTSC47_16));
	pMICHDR+9 = LOBYTE(HIWORD(pTransmitKey->dwTSC47_16));
	pMICHDR+10 = HIBYTE(LOWORD(pTransmitKey->dwTSC47_16));
	pMICHDR+11 = LOBYTE(LOWORD(pTransmitKey->dwTSC47_16));
__be16 tsc_15_0;
	pMICHDR+12 = HIBYTE(pTransmitKey->wTSC15_0);
	pMICHDR+13 = LOBYTE(pTransmitKey->wTSC15_0);
__be16 payload_len;
	pMICHDR+14 = HIBYTE(wPayloadLen);
	pMICHDR+15 = LOBYTE(wPayloadLen);
__be16 hlen;
	pMICHDR+16 = 0; // HLEN[15:8]
	pMICHDR+17 = 28; // HLEN[7:0]
__le16 frame_control;
	memcpy(pMICHDR+18, (u8 *)&wValue, 2); // MSKFRACTL
u8 addr1[6];
	memcpy(pMICHDR+20, &(pMACHeader->addr1[0]), 6);
u8 addr2[6];
	memcpy(pMICHDR+26, &(pMACHeader->addr2[0]), 6);
u8 addr3[6];
	memcpy(pMICHDR+32, &(pMACHeader->addr3[0]), 6);
__le16 seq_ctrl;
	memcpy(pMICHDR+38, (u8 *)&wValue, 2); // MSKSEQCTL
u8 addr4[6];
	memcpy(pMICHDR+40, &(pMACHeader->addr4[0]), 6);
u16 packing; /* packing to 48 bytes */

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 12 ------------
 drivers/staging/vt6656/rxtx.c | 26 +++++++++++++-------------
 drivers/staging/vt6656/rxtx.h | 18 ++++++++++++++++++
 3 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index b3e8cc1..4675135 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -163,18 +163,6 @@ typedef struct tagSTxShortBufHead {
 STxShortBufHead, *PSTxShortBufHead;
 typedef const STxShortBufHead *PCSTxShortBufHead;
 
-/*
- * MICHDR data header
- */
-typedef struct tagSMICHDRHead {
-	u32 adwHDR0[4];
-	u32 adwHDR1[4];
-	u32 adwHDR2[4];
-} __attribute__ ((__packed__))
-SMICHDRHead, *PSMICHDRHead;
-
-typedef const SMICHDRHead *PCSMICHDRHead;
-
 typedef struct tagSBEACONCtl {
 	u32 BufReady:1;
 	u32 TSF:15;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ed3fdf4..c055c76 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1004,7 +1004,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 uDuration;
 	u32 cbHeaderLength = 0, uPadding = 0;
 	void *pvRrvTime;
-	PSMICHDRHead pMICHDR;
+	struct vnt_mic_hdr *pMICHDR;
 	void *pvRTS;
 	void *pvCTS;
 	void *pvTxDataHd;
@@ -1121,7 +1121,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         if (pTransmitKey->byCipherSuite == KEY_CTL_CCMP) {
             cbIVlen = 8;//RSN Header
             cbICVlen = 8;//MIC
-            cbMICHDR = sizeof(SMICHDRHead);
+	    cbMICHDR = sizeof(struct vnt_mic_hdr);
         }
         if (bSoftWEP == false) {
             //MAC Header should be padding 0 to DW alignment.
@@ -1146,7 +1146,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             if (bRTS == true) {//RTS_need
 		pvRrvTime = (struct vnt_rrv_time_rts *)
 					(pbyTxBufferAddr + wTxBufSize);
-		pMICHDR = (PSMICHDRHead)(pbyTxBufferAddr + wTxBufSize +
+		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_rts));
 		pvRTS = (struct vnt_rts_g *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
@@ -1161,7 +1161,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             else { //RTS_needless
 		pvRrvTime = (struct vnt_rrv_time_cts *)
 				(pbyTxBufferAddr + wTxBufSize);
-		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts));
                 pvRTS = NULL;
 		pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
@@ -1178,7 +1178,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             if (bRTS == true) {//RTS_need
 		pvRrvTime = (struct vnt_rrv_time_rts *)(pbyTxBufferAddr +
 								wTxBufSize);
-		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_rts));
 		pvRTS = (struct vnt_rts_g_fb *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
@@ -1193,7 +1193,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             else if (bRTS == false) { //RTS_needless
 		pvRrvTime = (struct vnt_rrv_time_cts *)
 				(pbyTxBufferAddr + wTxBufSize);
-		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_cts));
                 pvRTS = NULL;
 		pvCTS = (struct vnt_cts_fb *) (pbyTxBufferAddr + wTxBufSize +
@@ -1212,7 +1212,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             if (bRTS == true) {//RTS_need
 		pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr +
 								wTxBufSize);
-		pMICHDR = (PSMICHDRHead)(pbyTxBufferAddr + wTxBufSize +
+		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 						sizeof(struct vnt_rrv_time_ab));
 		pvRTS = (struct vnt_rts_ab *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
@@ -1227,7 +1227,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             else if (bRTS == false) { //RTS_needless, no MICHDR
 		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
 								wTxBufSize);
-		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 						sizeof(struct vnt_rrv_time_ab));
                 pvRTS = NULL;
                 pvCTS = NULL;
@@ -1241,7 +1241,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             if (bRTS == true) {//RTS_need
 		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
 						wTxBufSize);
-		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_ab));
 		pvRTS = (struct vnt_rts_a_fb *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
@@ -1256,7 +1256,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
             else if (bRTS == false) { //RTS_needless
 		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
 								wTxBufSize);
-		pMICHDR = (PSMICHDRHead)(pbyTxBufferAddr + wTxBufSize +
+		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 						sizeof(struct vnt_rrv_time_ab));
                 pvRTS = NULL;
                 pvCTS = NULL;
@@ -2057,7 +2057,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
         else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
             cbIVlen = 8;//RSN Header
             cbICVlen = 8;//MIC
-            cbMICHDR = sizeof(SMICHDRHead);
+	    cbMICHDR = sizeof(struct vnt_mic_hdr);
             pTxBufHead->wFragCtl |= FRAGCTL_AES;
             pDevice->bAES = true;
         }
@@ -2076,7 +2076,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
 	pvRrvTime = (struct vnt_rrv_time_cts *) (pbyTxBufferAddr + wTxBufSize);
-	pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+	pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
         pvRTS = NULL;
 	pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
@@ -2091,7 +2091,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     else {//802.11a/b packet
 
 	pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr + wTxBufSize);
-	pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize +
+	pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 		sizeof(struct vnt_rrv_time_ab));
         pvRTS = NULL;
         pvCTS = NULL;
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 3484f2b..ad62052 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -33,6 +33,24 @@
 #include "wcmd.h"
 #include "baseband.h"
 
+/* MIC HDR data header */
+struct vnt_mic_hdr {
+	u8 id;
+	u8 tx_priority;
+	u8 mic_addr2[6];
+	__be32 tsc_47_16;
+	__be16 tsc_15_0;
+	__be16 payload_len;
+	__be16 hlen;
+	__le16 frame_control;
+	u8 addr1[6];
+	u8 addr2[6];
+	u8 addr3[6];
+	__le16 seq_ctrl;
+	u8 addr4[6];
+	u16 packing; /* packing to 48 bytes */
+} __packed;
+
 /* RsvTime buffer header */
 struct vnt_rrv_time_rts {
 	u16 wRTSTxRrvTime_ba;
-- 
1.8.1.2



