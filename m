Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58048 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3HEVMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 17:12:48 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so2918335wgg.12
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2013 14:12:47 -0700 (PDT)
Message-ID: <1375737162.9097.14.camel@canaries64> (sfid-20130805_231300_849223_949D3709)
Subject: [PATCH 2/2] staging: vt6656: desc.h remove typedef struct
 tagSCTSData
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 Aug 2013 22:12:42 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace structures with struct ieee80211_cts data

typedef struct tagSCTSData include extra packing wReserved
not in struct ieee80211_cts

This is corrected by adding reserved2 to the structures.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h | 14 ++++----------
 drivers/staging/vt6656/rxtx.c | 23 ++++++++---------------
 2 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index aa5e249..1a1cf34 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -254,21 +254,14 @@ typedef const SRTS_a_FB *PCSRTS_a_FB;
 /*
  * CTS buffer header
  */
-typedef struct tagSCTSData {
-    u16    wFrameControl;
-    u16    wDurationID;
-    u8    abyRA[ETH_ALEN];
-    u16    wReserved;
-} __attribute__ ((__packed__))
-SCTSData, *PSCTSData;
-
 typedef struct tagSCTS {
     u8        bySignalField_b;
     u8        byServiceField_b;
     u16        wTransmitLength_b;
     u16        wDuration_ba;
     u16        wReserved;
-    SCTSData    Data;
+	struct ieee80211_cts data;
+	u16 reserved2;
 } __attribute__ ((__packed__))
 SCTS, *PSCTS;
 
@@ -282,7 +275,8 @@ typedef struct tagSCTS_FB {
     u16        wReserved;
     u16        wCTSDuration_ba_f0;
     u16        wCTSDuration_ba_f1;
-    SCTSData    Data;
+	struct ieee80211_cts data;
+	u16 reserved2;
 } __attribute__ ((__packed__))
 SCTS_FB, *PSCTS_FB;
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index fd6f817..1d58d1f 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -958,13 +958,10 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
             //Get CTSDuration_ba_f1
             pBuf->wCTSDuration_ba_f1 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //9:CTSDuration_ba_f1, 1:2.4G, 2,3:2.4G OFDM Data
             pBuf->wCTSDuration_ba_f1 = cpu_to_le16(pBuf->wCTSDuration_ba_f1);
-            //Get CTS Frame body
-            pBuf->Data.wDurationID = pBuf->wDuration_ba;
-            pBuf->Data.wFrameControl = TYPE_CTL_CTS;//0x00C4
-            pBuf->Data.wReserved = 0x0000;
-	memcpy(&(pBuf->Data.abyRA[0]),
-	       &(pDevice->abyCurrentNetAddr[0]),
-	       ETH_ALEN);
+		/* Get CTS Frame body */
+		pBuf->data.duration = pBuf->wDuration_ba;
+		pBuf->data.frame_control = TYPE_CTL_CTS;
+		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
         } else { //if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA)
             PSCTS pBuf = (PSCTS)pvCTS;
             //Get SignalField,ServiceField,Length
@@ -975,14 +972,10 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
             //Get CTSDuration_ba
             pBuf->wDuration_ba = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //3:CTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
             pBuf->wDuration_ba = cpu_to_le16(pBuf->wDuration_ba);
-
-            //Get CTS Frame body
-            pBuf->Data.wDurationID = pBuf->wDuration_ba;
-            pBuf->Data.wFrameControl = TYPE_CTL_CTS;//0x00C4
-            pBuf->Data.wReserved = 0x0000;
-	memcpy(&(pBuf->Data.abyRA[0]),
-	       &(pDevice->abyCurrentNetAddr[0]),
-	       ETH_ALEN);
+		/*Get CTS Frame body*/
+		pBuf->data.duration = pBuf->wDuration_ba;
+		pBuf->data.frame_control = TYPE_CTL_CTS;
+		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
         }
     }
 }
-- 
1.8.1.2



