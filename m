Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63591 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbaCRT0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:10 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so6459853wgg.9
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/14] staging: vt6656: rxtx: Replace wRTSTxRrvTime*
Date: Tue, 18 Mar 2014 19:24:57 +0000
Message-Id: <1395170708-2990-3-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202615_141339_8247A72B)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix base type to __le16 and remove camel case.

Camel case changes
wRTSTxRrvTime* -> rts_rrv_time*

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 10 +++++-----
 drivers/staging/vt6656/rxtx.h |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1a29251..51aa77c 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -816,11 +816,11 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			struct vnt_rrv_time_rts *pBuf =
 					&tx_buffer->tx_head.tx_rts.rts;
 
-			pBuf->wRTSTxRrvTime_aa = s_uGetRTSCTSRsvTime(pDevice, 2,
+			pBuf->rts_rrv_time_aa = s_uGetRTSCTSRsvTime(pDevice, 2,
 					byPktType, cbFrameSize, wCurrentRate);
-			pBuf->wRTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 1,
+			pBuf->rts_rrv_time_ba = s_uGetRTSCTSRsvTime(pDevice, 1,
 					byPktType, cbFrameSize, wCurrentRate);
-			pBuf->wRTSTxRrvTime_bb = s_uGetRTSCTSRsvTime(pDevice, 0,
+			pBuf->rts_rrv_time_bb = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
 
 			pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice,
@@ -880,7 +880,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
 							tx_head.tx_ab.ab;
 
-			pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 2,
+			pBuf->rts_rrv_time = s_uGetRTSCTSRsvTime(pDevice, 2,
 				byPktType, cbFrameSize, wCurrentRate);
 
 			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
@@ -914,7 +914,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
 							tx_head.tx_ab.ab;
 
-			pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 0,
+			pBuf->rts_rrv_time = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
 
 			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index bb2d0ce..1e8f5e2 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -53,9 +53,9 @@ struct vnt_mic_hdr {
 
 /* RsvTime buffer header */
 struct vnt_rrv_time_rts {
-	u16 wRTSTxRrvTime_ba;
-	u16 wRTSTxRrvTime_aa;
-	u16 wRTSTxRrvTime_bb;
+	__le16 rts_rrv_time_ba;
+	__le16 rts_rrv_time_aa;
+	__le16 rts_rrv_time_bb;
 	u16 wReserved;
 	u16 wTxRrvTime_b;
 	u16 wTxRrvTime_a;
@@ -69,7 +69,7 @@ struct vnt_rrv_time_cts {
 } __packed;
 
 struct vnt_rrv_time_ab {
-	u16 wRTSTxRrvTime;
+	__le16 rts_rrv_time;
 	u16 wTxRrvTime;
 } __packed;
 
-- 
1.9.0

