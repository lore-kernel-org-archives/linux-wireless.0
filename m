Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48954 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbaCRT0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:12 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so6404908wgh.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/14] staging: vt6656: rxtx: Replace wTxRrvTime*
Date: Tue, 18 Mar 2014 19:24:58 +0000
Message-Id: <1395170708-2990-4-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202618_274839_25F94CFA)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix base type to __le16 and remove camel case.

Camel case changes
wTxRrvTime* -> rrv_time*

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 16 ++++++++--------
 drivers/staging/vt6656/rxtx.h | 10 +++++-----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 51aa77c..9846c90 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -823,9 +823,9 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			pBuf->rts_rrv_time_bb = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
 
-			pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice,
+			pBuf->rrv_time_a = vnt_rxtx_rsvtime_le16(pDevice,
 				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
-			pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
+			pBuf->rrv_time_b = vnt_rxtx_rsvtime_le16(pDevice,
 					PK_TYPE_11B, cbFrameSize,
 					pDevice->byTopCCKBasicRate, bNeedACK);
 
@@ -846,9 +846,9 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			struct vnt_rrv_time_cts *pBuf = &tx_buffer->
 							tx_head.tx_cts.cts;
 
-			pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice,
+			pBuf->rrv_time_a = vnt_rxtx_rsvtime_le16(pDevice,
 				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
-			pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
+			pBuf->rrv_time_b = vnt_rxtx_rsvtime_le16(pDevice,
 				PK_TYPE_11B, cbFrameSize,
 					pDevice->byTopCCKBasicRate, bNeedACK);
 
@@ -883,7 +883,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			pBuf->rts_rrv_time = s_uGetRTSCTSRsvTime(pDevice, 2,
 				byPktType, cbFrameSize, wCurrentRate);
 
-			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
+			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
 				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
 
 			/* Fill RTS */
@@ -894,7 +894,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
 							tx_head.tx_ab.ab;
 
-			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
+			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
 				PK_TYPE_11A, cbFrameSize,
 					wCurrentRate, bNeedACK);
 
@@ -917,7 +917,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			pBuf->rts_rrv_time = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
 
-			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
+			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
 				PK_TYPE_11B, cbFrameSize, wCurrentRate,
 								bNeedACK);
 
@@ -929,7 +929,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
 							tx_head.tx_ab.ab;
 
-			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
+			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
 				PK_TYPE_11B, cbFrameSize,
 					wCurrentRate, bNeedACK);
 
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 1e8f5e2..f0ab2a3 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -57,20 +57,20 @@ struct vnt_rrv_time_rts {
 	__le16 rts_rrv_time_aa;
 	__le16 rts_rrv_time_bb;
 	u16 wReserved;
-	u16 wTxRrvTime_b;
-	u16 wTxRrvTime_a;
+	__le16 rrv_time_b;
+	__le16 rrv_time_a;
 } __packed;
 
 struct vnt_rrv_time_cts {
 	u16 wCTSTxRrvTime_ba;
 	u16 wReserved;
-	u16 wTxRrvTime_b;
-	u16 wTxRrvTime_a;
+	__le16 rrv_time_b;
+	__le16 rrv_time_a;
 } __packed;
 
 struct vnt_rrv_time_ab {
 	__le16 rts_rrv_time;
-	u16 wTxRrvTime;
+	__le16 rrv_time;
 } __packed;
 
 /* TX data header */
-- 
1.9.0

