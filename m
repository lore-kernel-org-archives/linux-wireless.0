Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51646 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3HEVIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 17:08:17 -0400
Received: by mail-wi0-f170.google.com with SMTP id hi8so2028153wib.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2013 14:08:16 -0700 (PDT)
Message-ID: <1375736885.9097.12.camel@canaries64> (sfid-20130805_230823_550753_D2B555D9)
Subject: [PATCH 1/2] staging: vt6656: desc.h remove typedef struct
 tagSRTSData
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 Aug 2013 22:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace structures with struct ieee80211_rts data.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h |  19 ++---
 drivers/staging/vt6656/rxtx.c | 183 +++++++++++++++---------------------------
 2 files changed, 69 insertions(+), 133 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 64cb046..aa5e249 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -33,6 +33,7 @@
 
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/ieee80211.h>
 
 #include "tether.h"
 
@@ -187,16 +188,6 @@ typedef const SRrvTime_atim *PCSRrvTime_atim;
 /*
  * RTS buffer header
  */
-typedef struct tagSRTSData {
-    u16    wFrameControl;
-    u16    wDurationID;
-    u8    abyRA[ETH_ALEN];
-    u8    abyTA[ETH_ALEN];
-} __attribute__ ((__packed__))
-SRTSData, *PSRTSData;
-
-typedef const SRTSData *PCSRTSData;
-
 typedef struct tagSRTS_g {
     u8        bySignalField_b;
     u8        byServiceField_b;
@@ -208,7 +199,7 @@ typedef struct tagSRTS_g {
     u16        wDuration_aa;
     u16        wDuration_bb;
     u16        wReserved;
-    SRTSData    Data;
+	struct ieee80211_rts data;
 } __attribute__ ((__packed__))
 SRTS_g, *PSRTS_g;
 typedef const SRTS_g *PCSRTS_g;
@@ -228,7 +219,7 @@ typedef struct tagSRTS_g_FB {
     u16        wRTSDuration_aa_f0;
     u16        wRTSDuration_ba_f1;
     u16        wRTSDuration_aa_f1;
-    SRTSData    Data;
+	struct ieee80211_rts data;
 } __attribute__ ((__packed__))
 SRTS_g_FB, *PSRTS_g_FB;
 
@@ -240,7 +231,7 @@ typedef struct tagSRTS_ab {
     u16        wTransmitLength;
     u16        wDuration;
     u16        wReserved;
-    SRTSData    Data;
+	struct ieee80211_rts data;
 } __attribute__ ((__packed__))
 SRTS_ab, *PSRTS_ab;
 
@@ -254,7 +245,7 @@ typedef struct tagSRTS_a_FB {
     u16        wReserved;
     u16        wRTSDuration_f0;
     u16        wRTSDuration_f1;
-    SRTSData    Data;
+	struct ieee80211_rts data;
 } __attribute__ ((__packed__))
 SRTS_a_FB, *PSRTS_a_FB;
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 137608f..fd6f817 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -795,32 +795,20 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             pBuf->wDuration_bb = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, PK_TYPE_11B, pDevice->byTopCCKBasicRate, bNeedAck, byFBOption));    //0:RTSDuration_bb, 1:2.4G, 1:CCKData
             pBuf->wDuration_aa = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //2:RTSDuration_aa, 1:2.4G, 2,3: 2.4G OFDMData
             pBuf->wDuration_ba = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //1:RTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
+		pBuf->data.duration = pBuf->wDuration_aa;
+		/*Get RTS Frame body */
+		pBuf->data.frame_control = TYPE_CTL_RTS;
 
-            pBuf->Data.wDurationID = pBuf->wDuration_aa;
-            //Get RTS Frame body
-            pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
+		if (pDevice->eOPMode == OP_MODE_ADHOC ||
+				pDevice->eOPMode == OP_MODE_AP)
+			memcpy(pBuf->data.ra, psEthHeader->h_dest, ETH_ALEN);
+		else
+			memcpy(pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 
-	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-	    (pDevice->eOPMode == OP_MODE_AP)) {
-		memcpy(&(pBuf->Data.abyRA[0]),
-		       &(psEthHeader->h_dest[0]),
-		       ETH_ALEN);
-	}
-            else {
-		    memcpy(&(pBuf->Data.abyRA[0]),
-			   &(pDevice->abyBSSID[0]),
-			   ETH_ALEN);
-	    }
-	if (pDevice->eOPMode == OP_MODE_AP) {
-		memcpy(&(pBuf->Data.abyTA[0]),
-		       &(pDevice->abyBSSID[0]),
-		       ETH_ALEN);
-	}
-            else {
-		    memcpy(&(pBuf->Data.abyTA[0]),
-			   &(psEthHeader->h_source[0]),
-			   ETH_ALEN);
-            }
+		if (pDevice->eOPMode == OP_MODE_AP)
+			memcpy(pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
+		else
+			memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
         }
         else {
            PSRTS_g_FB pBuf = (PSRTS_g_FB)pvRTS;
@@ -841,33 +829,20 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             pBuf->wRTSDuration_aa_f0 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //5:wRTSDuration_aa_f0, 1:2.4G, 1:CCKData
             pBuf->wRTSDuration_ba_f1 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //6:wRTSDuration_ba_f1, 1:2.4G, 1:CCKData
             pBuf->wRTSDuration_aa_f1 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //7:wRTSDuration_aa_f1, 1:2.4G, 1:CCKData
-            pBuf->Data.wDurationID = pBuf->wDuration_aa;
-            //Get RTS Frame body
-            pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
-
-	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-	    (pDevice->eOPMode == OP_MODE_AP)) {
-		memcpy(&(pBuf->Data.abyRA[0]),
-		       &(psEthHeader->h_dest[0]),
-		       ETH_ALEN);
-	}
-            else {
-		memcpy(&(pBuf->Data.abyRA[0]),
-		       &(pDevice->abyBSSID[0]),
-		       ETH_ALEN);
-            }
-
-	if (pDevice->eOPMode == OP_MODE_AP) {
-		memcpy(&(pBuf->Data.abyTA[0]),
-		       &(pDevice->abyBSSID[0]),
-		       ETH_ALEN);
-	}
-            else {
-		    memcpy(&(pBuf->Data.abyTA[0]),
-			   &(psEthHeader->h_source[0]),
-			   ETH_ALEN);
-            }
-
+		pBuf->data.duration = pBuf->wDuration_aa;
+		/*Get RTS Frame body*/
+		pBuf->data.frame_control = TYPE_CTL_RTS;
+
+		if (pDevice->eOPMode == OP_MODE_ADHOC ||
+				pDevice->eOPMode == OP_MODE_AP)
+			memcpy(pBuf->data.ra, psEthHeader->h_dest, ETH_ALEN);
+		else
+			memcpy(pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
+
+		if (pDevice->eOPMode == OP_MODE_AP)
+			memcpy(pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
+		else
+			memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
         } // if (byFBOption == AUTO_FB_NONE)
     }
     else if (byPktType == PK_TYPE_11A) {
@@ -880,31 +855,20 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             pBuf->wTransmitLength = cpu_to_le16(wLen);
             //Get Duration
             pBuf->wDuration = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
-    	    pBuf->Data.wDurationID = pBuf->wDuration;
-            //Get RTS Frame body
-            pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
-
-	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-	    (pDevice->eOPMode == OP_MODE_AP)) {
-		memcpy(&(pBuf->Data.abyRA[0]),
-		       &(psEthHeader->h_dest[0]),
-		       ETH_ALEN);
-	} else {
-		memcpy(&(pBuf->Data.abyRA[0]),
-		       &(pDevice->abyBSSID[0]),
-		       ETH_ALEN);
-	}
+		pBuf->data.duration = pBuf->wDuration;
+		/* Get RTS Frame body */
+		pBuf->data.frame_control = TYPE_CTL_RTS;
 
-	if (pDevice->eOPMode == OP_MODE_AP) {
-		memcpy(&(pBuf->Data.abyTA[0]),
-		       &(pDevice->abyBSSID[0]),
-		       ETH_ALEN);
-	} else {
-		memcpy(&(pBuf->Data.abyTA[0]),
-		       &(psEthHeader->h_source[0]),
-		       ETH_ALEN);
-	}
+		if (pDevice->eOPMode == OP_MODE_ADHOC ||
+				pDevice->eOPMode == OP_MODE_AP)
+			memcpy(pBuf->data.ra, psEthHeader->h_dest, ETH_ALEN);
+		else
+			memcpy(pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 
+		if (pDevice->eOPMode == OP_MODE_AP)
+			memcpy(pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
+		else
+			memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
         }
         else {
             PSRTS_a_FB pBuf = (PSRTS_a_FB)pvRTS;
@@ -917,29 +881,20 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             pBuf->wDuration = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
     	    pBuf->wRTSDuration_f0 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //5:RTSDuration_aa_f0, 0:5G, 0: 5G OFDMData
     	    pBuf->wRTSDuration_f1 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //7:RTSDuration_aa_f1, 0:5G, 0:
-    	    pBuf->Data.wDurationID = pBuf->wDuration;
-    	    //Get RTS Frame body
-            pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
+		pBuf->data.duration = pBuf->wDuration;
+		/* Get RTS Frame body */
+		pBuf->data.frame_control = TYPE_CTL_RTS;
 
-	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-	    (pDevice->eOPMode == OP_MODE_AP)) {
-		memcpy(&(pBuf->Data.abyRA[0]),
-		       &(psEthHeader->h_dest[0]),
-		       ETH_ALEN);
-	} else {
-		memcpy(&(pBuf->Data.abyRA[0]),
-		       &(pDevice->abyBSSID[0]),
-		       ETH_ALEN);
-	}
-	if (pDevice->eOPMode == OP_MODE_AP) {
-		memcpy(&(pBuf->Data.abyTA[0]),
-		       &(pDevice->abyBSSID[0]),
-		       ETH_ALEN);
-	} else {
-		memcpy(&(pBuf->Data.abyTA[0]),
-		       &(psEthHeader->h_source[0]),
-		       ETH_ALEN);
-	}
+		if (pDevice->eOPMode == OP_MODE_ADHOC ||
+				pDevice->eOPMode == OP_MODE_AP)
+			memcpy(pBuf->data.ra, psEthHeader->h_dest, ETH_ALEN);
+		else
+			memcpy(pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
+
+		if (pDevice->eOPMode == OP_MODE_AP)
+			memcpy(pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
+		else
+			memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
         }
     }
     else if (byPktType == PK_TYPE_11B) {
@@ -951,31 +906,21 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         pBuf->wTransmitLength = cpu_to_le16(wLen);
         //Get Duration
         pBuf->wDuration = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_bb, 1:2.4G, 1:CCKData
-        pBuf->Data.wDurationID = pBuf->wDuration;
-        //Get RTS Frame body
-        pBuf->Data.wFrameControl = TYPE_CTL_RTS;//0x00B4
 
-	if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
-            (pDevice->eOPMode == OP_MODE_AP)) {
-		memcpy(&(pBuf->Data.abyRA[0]),
-		       &(psEthHeader->h_dest[0]),
-		       ETH_ALEN);
-        }
-        else {
-		memcpy(&(pBuf->Data.abyRA[0]),
-		       &(pDevice->abyBSSID[0]),
-		       ETH_ALEN);
-        }
+	pBuf->data.duration = pBuf->wDuration;
+	/* Get RTS Frame body */
+	pBuf->data.frame_control = TYPE_CTL_RTS;
 
-        if (pDevice->eOPMode == OP_MODE_AP) {
-		memcpy(&(pBuf->Data.abyTA[0]),
-		       &(pDevice->abyBSSID[0]),
-		       ETH_ALEN);
-	} else {
-		memcpy(&(pBuf->Data.abyTA[0]),
-		       &(psEthHeader->h_source[0]),
-		       ETH_ALEN);
-        }
+	if (pDevice->eOPMode == OP_MODE_ADHOC ||
+			pDevice->eOPMode == OP_MODE_AP)
+		memcpy(pBuf->data.ra, psEthHeader->h_dest, ETH_ALEN);
+	else
+		memcpy(pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
+
+	if (pDevice->eOPMode == OP_MODE_AP)
+		memcpy(pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
+	else
+		memcpy(pBuf->data.ta, psEthHeader->h_source, ETH_ALEN);
     }
 }
 
-- 
1.8.1.2



