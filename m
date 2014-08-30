Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61261 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaH3V01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:27 -0400
Received: by mail-wi0-f181.google.com with SMTP id e4so4203800wiv.2
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/23] staging: vt6655: rxtx replace typedef struct tagSRrvTime_gCTS with struct vnt_rrv_time_cts
Date: Sat, 30 Aug 2014 22:25:28 +0100
Message-Id: <1409433949-5468-2-git-send-email-tvboxspy@gmail.com> (sfid-20140830_232630_271674_5D9E5601)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replacing members
wCTSTxRrvTime_ba, wReserved, wTxRrvTime_b and wTxRrvTime_a
with
cts_rrv_time_ba, reserved, rrv_time_b and rrv_time_a;

Creating the new structure in rxtx.h and Using __le16 where necessary

pvRrvTime is a void pointer

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h |  9 --------
 drivers/staging/vt6655/rxtx.c | 54 ++++++++++++++++++++++++-------------------
 drivers/staging/vt6655/rxtx.h |  7 ++++++
 3 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 49a2e04..237a99c 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -331,15 +331,6 @@ typedef const STxSyncDesc *PCSTxSyncDesc;
 //
 // RsvTime buffer header
 //
-typedef struct tagSRrvTime_gCTS {
-	unsigned short wCTSTxRrvTime_ba;
-	unsigned short wReserved;
-	unsigned short wTxRrvTime_b;
-	unsigned short wTxRrvTime_a;
-} __attribute__ ((__packed__))
-SRrvTime_gCTS, *PSRrvTime_gCTS;
-typedef const SRrvTime_gCTS *PCSRrvTime_gCTS;
-
 typedef struct tagSRrvTime_ab {
 	unsigned short wRTSTxRrvTime;
 	unsigned short wTxRrvTime;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 609aec8..b2fd513 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1095,11 +1095,11 @@ s_vGenerateTxParameter(
 
 			//Fill RsvTime
 			if (pvRrvTime) {
-				PSRrvTime_gCTS pBuf = (PSRrvTime_gCTS)pvRrvTime;
+				struct vnt_rrv_time_cts *buf = pvRrvTime;
 
-				pBuf->wTxRrvTime_a = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//2.4G OFDM
-				pBuf->wTxRrvTime_b = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));//1:CCK
-				pBuf->wCTSTxRrvTime_ba = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 3, byPktType, cbFrameSize, wCurrentRate));//3:CTSTxRrvTime_Ba, 1:2.4GHz
+				buf->rrv_time_a = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));
+				buf->rrv_time_b = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));
+				buf->cts_rrv_time_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 3, byPktType, cbFrameSize, wCurrentRate));
 			}
 
 			//Fill CTS
@@ -1319,12 +1319,12 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				pvTxDataHd = (PSTxDataHead_g)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g));
 				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g) + sizeof(STxDataHead_g);
 			} else { //RTS_needless
-				pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
+				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts));
 				pvRTS = NULL;
-				pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR);
-				pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS));
-				cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS) + sizeof(STxDataHead_g);
+				pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
+				pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS) + sizeof(STxDataHead_g);
 			}
 		} else {
 			// Auto Fall Back
@@ -1336,12 +1336,12 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g_FB));
 				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g_FB) + sizeof(STxDataHead_g_FB);
 			} else { //RTS_needless
-				pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
+				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts));
 				pvRTS = NULL;
-				pvCTS = (PSCTS_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR);
-				pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS_FB));
-				cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS_FB) + sizeof(STxDataHead_g_FB);
+				pvCTS = (PSCTS_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
+				pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS_FB));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS_FB) + sizeof(STxDataHead_g_FB);
 			}
 		} // Auto Fall Back
 	} else {//802.11a/b packet
@@ -2183,13 +2183,15 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 
 	//Set RrvTime/RTS/CTS Buffer
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-
-		pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
+		pvRrvTime = (void *) (pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = NULL;
 		pvRTS = NULL;
-		pCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
-		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + sizeof(SCTS));
-		cbHeaderSize = wTxBufSize + sizeof(SRrvTime_gCTS) + sizeof(SCTS) + sizeof(STxDataHead_g);
+		pCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize +
+					sizeof(struct vnt_rrv_time_cts));
+		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
+				sizeof(struct vnt_rrv_time_cts) + sizeof(SCTS));
+		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
+					sizeof(SCTS) + sizeof(STxDataHead_g);
 	} else { // 802.11a/b packet
 		pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = NULL;
@@ -2668,12 +2670,16 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
 
-		pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
-		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
+		pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
+					sizeof(struct vnt_rrv_time_cts));
 		pvRTS = NULL;
-		pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR);
-		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS));
-		cbHeaderSize = wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS) + sizeof(STxDataHead_g);
+		pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize +
+				sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
+		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
+			sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS));
+		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
+				cbMICHDR + sizeof(SCTS) + sizeof(STxDataHead_g);
 
 	} else {//802.11a/b packet
 
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index f5f6478..4dca615 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -66,6 +66,13 @@ struct vnt_rrv_time_rts {
 	__le16 rrv_time_a;
 } __packed;
 
+struct vnt_rrv_time_cts {
+	__le16 cts_rrv_time_ba;
+	u16 reserved;
+	__le16 rrv_time_b;
+	__le16 rrv_time_a;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

