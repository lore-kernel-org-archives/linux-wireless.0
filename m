Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:36076 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaH3V04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:56 -0400
Received: by mail-we0-f178.google.com with SMTP id u57so3658360wes.23
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 19/23] staging: vt6655: replace typedef struct tagSCTS with struct vnt_cts
Date: Sat, 30 Aug 2014 22:25:45 +0100
Message-Id: <1409433949-5468-19-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234535_059002_87B68619)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
b, wDuration_ba, wReserved, data and reserved2
with
b, duration_ba, reserved, data and reserved2

unsigned short is replaced with u16 or __le16 where necessary.

cast void pointer to pvCTS

Creating the new structure in rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 10 ----------
 drivers/staging/vt6655/rxtx.c | 46 +++++++++++++++++++++++--------------------
 drivers/staging/vt6655/rxtx.h |  9 +++++++++
 3 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index f0a31a8..4d9027e 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -355,16 +355,6 @@ union vnt_phy_field_swap {
 //
 // CTS buffer header
 //
-typedef struct tagSCTS {
-	struct vnt_phy_field b;
-	unsigned short wDuration_ba;
-	unsigned short wReserved;
-	struct ieee80211_cts data;
-	u16 reserved2;
-} __attribute__ ((__packed__))
-SCTS, *PSCTS;
-typedef const SCTS *PCSCTS;
-
 typedef struct tagSCTS_FB {
 	struct vnt_phy_field b;
 	unsigned short wDuration_ba;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 0721fbb..d3de73c 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1071,26 +1071,29 @@ s_vFillCTSHead(
 			memcpy(&pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 
 		} else { //if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA)
-			PSCTS pBuf = (PSCTS)pvCTS;
+			struct vnt_cts *buf = pvCTS;
 			/* Get SignalField, ServiceField & Length */
 			vnt_get_phy_field(pDevice, uCTSFrameLen,
 					  pDevice->byTopCCKBasicRate,
-					  PK_TYPE_11B, &pBuf->b);
+					  PK_TYPE_11B, &buf->b);
 
-			//Get CTSDuration_ba
-			pBuf->wDuration_ba = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //3:CTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
-			pBuf->wDuration_ba += pDevice->wCTSDuration;
-			pBuf->wDuration_ba = cpu_to_le16(pBuf->wDuration_ba);
+			/* Get CTSDuration_ba */
+			buf->duration_ba =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength,
+								      byPktType, wCurrentRate, bNeedAck,
+								      byFBOption));
+			buf->duration_ba += pDevice->wCTSDuration;
+			buf->duration_ba = cpu_to_le16(buf->duration_ba);
 
-			//Get CTS Frame body
-			pBuf->data.duration = pBuf->wDuration_ba;
+			/* Get CTS Frame body */
+			buf->data.duration = buf->duration_ba;
 
-			pBuf->data.frame_control =
+			buf->data.frame_control =
 				cpu_to_le16(IEEE80211_FTYPE_CTL |
 					    IEEE80211_STYPE_CTS);
 
-			pBuf->reserved2 = 0x0;
-			memcpy(&pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
+			buf->reserved2 = 0x0;
+			memcpy(&buf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 		}
 	}
 }
@@ -1390,10 +1393,11 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts));
 				pvRTS = NULL;
-				pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
-				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS));
+				pvCTS = (void *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize +
+						sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(struct vnt_cts));
 				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-							cbMICHDR + sizeof(SCTS) + sizeof(struct vnt_tx_datahead_g);
+							cbMICHDR + sizeof(struct vnt_cts) + sizeof(struct vnt_tx_datahead_g);
 			}
 		} else {
 			// Auto Fall Back
@@ -2126,7 +2130,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 	unsigned char byPktType;
 	unsigned char *pbyTxBufferAddr;
 	void *pvRTS;
-	PSCTS           pCTS;
+	struct vnt_cts *pCTS;
 	void *pvTxDataHd;
 	unsigned int uDuration;
 	unsigned int cbReqCount;
@@ -2264,12 +2268,12 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 		pvRrvTime = (void *) (pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = NULL;
 		pvRTS = NULL;
-		pCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize +
+		pCTS = (struct vnt_cts *)(pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
 		pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize +
-				sizeof(struct vnt_rrv_time_cts) + sizeof(SCTS));
+				sizeof(struct vnt_rrv_time_cts) + sizeof(struct vnt_cts));
 		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-					sizeof(SCTS) + sizeof(struct vnt_tx_datahead_g);
+				sizeof(struct vnt_cts) + sizeof(struct vnt_tx_datahead_g);
 	} else { // 802.11a/b packet
 		pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = NULL;
@@ -2754,12 +2758,12 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
 		pvRTS = NULL;
-		pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize +
+		pvCTS = (struct vnt_cts *)(pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 		pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS));
+			sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(struct vnt_cts));
 		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-				cbMICHDR + sizeof(SCTS) + sizeof(struct vnt_tx_datahead_g);
+				cbMICHDR + sizeof(struct vnt_cts) + sizeof(struct vnt_tx_datahead_g);
 
 	} else {//802.11a/b packet
 
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index bac2214..2c09c11 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -154,6 +154,15 @@ struct vnt_rts_a_fb {
 	struct ieee80211_rts data;
 } __packed;
 
+/* CTS buffer header */
+struct vnt_cts {
+	struct vnt_phy_field b;
+	__le16 duration_ba;
+	u16 reserved;
+	struct ieee80211_cts data;
+	u16 reserved2;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

