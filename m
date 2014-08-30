Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:36485 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaH3V0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:46 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so3654842wes.8
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/23] staging: vt6655: Replace typedef struct tagSRTSData with ieee80211_rts data
Date: Sat, 30 Aug 2014 22:25:39 +0100
Message-Id: <1409433949-5468-13-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234533_880473_0ECC64E5)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing SRTSData Data with struct ieee80211_rts data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 21 +++--------
 drivers/staging/vt6655/rxtx.c | 84 +++++++++++++++++++++++++------------------
 2 files changed, 54 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 0da860e..3ce5fe8 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -33,6 +33,7 @@
 
 #include <linux/types.h>
 #include <linux/mm.h>
+#include "linux/ieee80211.h"
 #include "ttype.h"
 #include "tether.h"
 
@@ -338,18 +339,6 @@ typedef struct tagSRrvTime_atim {
 SRrvTime_atim, *PSRrvTime_atim;
 typedef const SRrvTime_atim *PCSRrvTime_atim;
 
-//
-// RTS buffer header
-//
-typedef struct tagSRTSData {
-	unsigned short wFrameControl;
-	unsigned short wDurationID;
-	unsigned char abyRA[ETH_ALEN];
-	unsigned char abyTA[ETH_ALEN];
-} __attribute__ ((__packed__))
-SRTSData, *PSRTSData;
-typedef const SRTSData *PCSRTSData;
-
 /* Length, Service, and Signal fields of Phy for Tx */
 struct vnt_phy_field {
 	u8 signal;
@@ -370,7 +359,7 @@ typedef struct tagSRTS_g {
 	unsigned short wDuration_aa;
 	unsigned short wDuration_bb;
 	unsigned short wReserved;
-	SRTSData    Data;
+	struct ieee80211_rts data;
 } __attribute__ ((__packed__))
 SRTS_g, *PSRTS_g;
 typedef const SRTS_g *PCSRTS_g;
@@ -386,7 +375,7 @@ typedef struct tagSRTS_g_FB {
 	unsigned short wRTSDuration_aa_f0;
 	unsigned short wRTSDuration_ba_f1;
 	unsigned short wRTSDuration_aa_f1;
-	SRTSData    Data;
+	struct ieee80211_rts data;
 } __attribute__ ((__packed__))
 SRTS_g_FB, *PSRTS_g_FB;
 typedef const SRTS_g_FB *PCSRTS_g_FB;
@@ -395,7 +384,7 @@ typedef struct tagSRTS_ab {
 	struct vnt_phy_field ab;
 	unsigned short wDuration;
 	unsigned short wReserved;
-	SRTSData    Data;
+	struct ieee80211_rts data;
 } __attribute__ ((__packed__))
 SRTS_ab, *PSRTS_ab;
 typedef const SRTS_ab *PCSRTS_ab;
@@ -406,7 +395,7 @@ typedef struct tagSRTS_a_FB {
 	unsigned short wReserved;
 	unsigned short wRTSDuration_f0;
 	unsigned short wRTSDuration_f1;
-	SRTSData    Data;
+	struct ieee80211_rts data;
 } __attribute__ ((__packed__))
 SRTS_a_FB, *PSRTS_a_FB;
 typedef const SRTS_a_FB *PCSRTS_a_FB;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 0171f64..208643e 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -832,19 +832,23 @@ s_vFillRTSHead(
 			pBuf->wDuration_aa = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //2:RTSDuration_aa, 1:2.4G, 2,3: 2.4G OFDMData
 			pBuf->wDuration_ba = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //1:RTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
 
-			pBuf->Data.wDurationID = pBuf->wDuration_aa;
-			//Get RTS Frame body
-			pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
+			pBuf->data.duration = pBuf->wDuration_aa;
+			/* Get RTS Frame body */
+			pBuf->data.frame_control =
+					cpu_to_le16(IEEE80211_FTYPE_CTL |
+						    IEEE80211_STYPE_RTS);
+
+
 			if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
 			    (pDevice->eOPMode == OP_MODE_AP)) {
-				memcpy(&(pBuf->Data.abyRA[0]), &(psEthHeader->abyDstAddr[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 			} else {
-				memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 			}
 			if (pDevice->eOPMode == OP_MODE_AP)
-				memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 			else
-				memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 
 		} else {
 			PSRTS_g_FB pBuf = (PSRTS_g_FB)pvRTS;
@@ -864,21 +868,24 @@ s_vFillRTSHead(
 			pBuf->wRTSDuration_aa_f0 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //5:wRTSDuration_aa_f0, 1:2.4G, 1:CCKData
 			pBuf->wRTSDuration_ba_f1 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //6:wRTSDuration_ba_f1, 1:2.4G, 1:CCKData
 			pBuf->wRTSDuration_aa_f1 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //7:wRTSDuration_aa_f1, 1:2.4G, 1:CCKData
-			pBuf->Data.wDurationID = pBuf->wDuration_aa;
-			//Get RTS Frame body
-			pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
+			pBuf->data.duration = pBuf->wDuration_aa;
+			/* Get RTS Frame body */
+			pBuf->data.frame_control =
+					cpu_to_le16(IEEE80211_FTYPE_CTL |
+						    IEEE80211_STYPE_RTS);
+
 
 			if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
 			    (pDevice->eOPMode == OP_MODE_AP)) {
-				memcpy(&(pBuf->Data.abyRA[0]), &(psEthHeader->abyDstAddr[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 			} else {
-				memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 			}
 
 			if (pDevice->eOPMode == OP_MODE_AP)
-				memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 			else
-				memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 
 		} // if (byFBOption == AUTO_FB_NONE)
 	} else if (byPktType == PK_TYPE_11A) {
@@ -890,21 +897,24 @@ s_vFillRTSHead(
 					  byPktType, &pBuf->ab);
 			//Get Duration
 			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
-			pBuf->Data.wDurationID = pBuf->wDuration;
-			//Get RTS Frame body
-			pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
+			pBuf->data.duration = pBuf->wDuration;
+			/* Get RTS Frame body */
+			pBuf->data.frame_control =
+					cpu_to_le16(IEEE80211_FTYPE_CTL |
+						    IEEE80211_STYPE_RTS);
+
 
 			if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
 			    (pDevice->eOPMode == OP_MODE_AP)) {
-				memcpy(&(pBuf->Data.abyRA[0]), &(psEthHeader->abyDstAddr[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 			} else {
-				memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 			}
 
 			if (pDevice->eOPMode == OP_MODE_AP)
-				memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 			else
-				memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 
 		} else {
 			PSRTS_a_FB pBuf = (PSRTS_a_FB)pvRTS;
@@ -916,20 +926,23 @@ s_vFillRTSHead(
 			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
 			pBuf->wRTSDuration_f0 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //5:RTSDuration_aa_f0, 0:5G, 0: 5G OFDMData
 			pBuf->wRTSDuration_f1 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //7:RTSDuration_aa_f1, 0:5G, 0:
-			pBuf->Data.wDurationID = pBuf->wDuration;
-			//Get RTS Frame body
-			pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
+			pBuf->data.duration = pBuf->wDuration;
+			/* Get RTS Frame body */
+			pBuf->data.frame_control =
+					cpu_to_le16(IEEE80211_FTYPE_CTL |
+						    IEEE80211_STYPE_RTS);
+
 
 			if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
 			    (pDevice->eOPMode == OP_MODE_AP)) {
-				memcpy(&(pBuf->Data.abyRA[0]), &(psEthHeader->abyDstAddr[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 			} else {
-				memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 			}
 			if (pDevice->eOPMode == OP_MODE_AP)
-				memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 			else
-				memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
+				memcpy(&pBuf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 		}
 	} else if (byPktType == PK_TYPE_11B) {
 		PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
@@ -939,21 +952,22 @@ s_vFillRTSHead(
 				  PK_TYPE_11B, &pBuf->ab);
 		//Get Duration
 		pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_bb, 1:2.4G, 1:CCKData
-		pBuf->Data.wDurationID = pBuf->wDuration;
-		//Get RTS Frame body
-		pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
+		pBuf->data.duration = pBuf->wDuration;
+		/* Get RTS Frame body */
+		pBuf->data.frame_control =
+			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
 
 		if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
 		    (pDevice->eOPMode == OP_MODE_AP)) {
-			memcpy(&(pBuf->Data.abyRA[0]), &(psEthHeader->abyDstAddr[0]), ETH_ALEN);
+			memcpy(&pBuf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 		} else {
-			memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+			memcpy(&pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 		}
 
 		if (pDevice->eOPMode == OP_MODE_AP)
-			memcpy(&(pBuf->Data.abyTA[0]), &(pDevice->abyBSSID[0]), ETH_ALEN);
+			memcpy(&pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 		else
-			memcpy(&(pBuf->Data.abyTA[0]), &(psEthHeader->abySrcAddr[0]), ETH_ALEN);
+			memcpy(&pBuf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 	}
 }
 
-- 
1.9.1

