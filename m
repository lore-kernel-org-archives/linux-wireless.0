Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:60441 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaH3V0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:48 -0400
Received: by mail-we0-f179.google.com with SMTP id t60so3645790wes.24
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:46 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/23] staging: vt6655: Replace typedef struct tagSCTSData with ieee80211_cts data
Date: Sat, 30 Aug 2014 22:25:40 +0100
Message-Id: <1409433949-5468-14-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234533_315499_4EDBB08A)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_cts data needs extra padding with reserved2 set to 0

use IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS to set frame_control

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 14 ++++----------
 drivers/staging/vt6655/rxtx.c | 26 +++++++++++++++++---------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 3ce5fe8..00c3922 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -403,19 +403,12 @@ typedef const SRTS_a_FB *PCSRTS_a_FB;
 //
 // CTS buffer header
 //
-typedef struct tagSCTSData {
-	unsigned short wFrameControl;
-	unsigned short wDurationID;
-	unsigned char abyRA[ETH_ALEN];
-	unsigned short wReserved;
-} __attribute__ ((__packed__))
-SCTSData, *PSCTSData;
-
 typedef struct tagSCTS {
 	struct vnt_phy_field b;
 	unsigned short wDuration_ba;
 	unsigned short wReserved;
-	SCTSData    Data;
+	struct ieee80211_cts data;
+	u16 reserved2;
 } __attribute__ ((__packed__))
 SCTS, *PSCTS;
 typedef const SCTS *PCSCTS;
@@ -426,7 +419,8 @@ typedef struct tagSCTS_FB {
 	unsigned short wReserved;
 	unsigned short wCTSDuration_ba_f0;
 	unsigned short wCTSDuration_ba_f1;
-	SCTSData    Data;
+	struct ieee80211_cts data;
+	u16 reserved2;
 } __attribute__ ((__packed__))
 SCTS_FB, *PSCTS_FB;
 typedef const SCTS_FB *PCSCTS_FB;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 208643e..d94d496 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1016,11 +1016,15 @@ s_vFillCTSHead(
 			pBuf->wCTSDuration_ba_f1 = (unsigned short)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //9:CTSDuration_ba_f1, 1:2.4G, 2,3:2.4G OFDM Data
 			pBuf->wCTSDuration_ba_f1 += pDevice->wCTSDuration;
 			pBuf->wCTSDuration_ba_f1 = cpu_to_le16(pBuf->wCTSDuration_ba_f1);
-			//Get CTS Frame body
-			pBuf->Data.wDurationID = pBuf->wDuration_ba;
-			pBuf->Data.wFrameControl = TYPE_CTL_CTS;//0x00C4
-			pBuf->Data.wReserved = 0x0000;
-			memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyCurrentNetAddr[0]), ETH_ALEN);
+			/* Get CTS Frame body */
+			pBuf->data.duration = pBuf->wDuration_ba;
+
+			pBuf->data.frame_control =
+				cpu_to_le16(IEEE80211_FTYPE_CTL |
+					    IEEE80211_STYPE_CTS);
+
+			pBuf->reserved2 = 0x0;
+			memcpy(&pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 
 		} else { //if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA)
 			PSCTS pBuf = (PSCTS)pvCTS;
@@ -1035,10 +1039,14 @@ s_vFillCTSHead(
 			pBuf->wDuration_ba = cpu_to_le16(pBuf->wDuration_ba);
 
 			//Get CTS Frame body
-			pBuf->Data.wDurationID = pBuf->wDuration_ba;
-			pBuf->Data.wFrameControl = TYPE_CTL_CTS;//0x00C4
-			pBuf->Data.wReserved = 0x0000;
-			memcpy(&(pBuf->Data.abyRA[0]), &(pDevice->abyCurrentNetAddr[0]), ETH_ALEN);
+			pBuf->data.duration = pBuf->wDuration_ba;
+
+			pBuf->data.frame_control =
+				cpu_to_le16(IEEE80211_FTYPE_CTL |
+					    IEEE80211_STYPE_CTS);
+
+			pBuf->reserved2 = 0x0;
+			memcpy(&pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 		}
 	}
 }
-- 
1.9.1

