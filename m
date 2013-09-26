Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54868 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3IZRty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 13:49:54 -0400
Received: by mail-wi0-f172.google.com with SMTP id hn9so7465539wib.5
        for <linux-wireless@vger.kernel.org>; Thu, 26 Sep 2013 10:49:53 -0700 (PDT)
Message-ID: <1380217784.2059.11.camel@canaries64-MCP7A> (sfid-20130926_194959_180366_4E686C86)
Subject: [PATCH 2/5] staging: vt6656: rxtx.c create structure to join
 vnt_tx_data_head with vnt_tx_head.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Sep 2013 18:49:44 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create struct vnt_tx_mic_hdr for with union vnt_tx_data_head
for mic mode.

Create union vnt_tx for mic and non mic mode.

Attach vnt_rrv_time_* to relevant tx_head.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 12 ++++++------
 drivers/staging/vt6656/rxtx.h | 25 ++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7b05ee8..c80a809 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -870,7 +870,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 	if (need_rts) {
             //Fill RsvTime
-		struct vnt_rrv_time_rts *pBuf = &tx_buffer->tx_head.rts;
+		struct vnt_rrv_time_rts *pBuf = &tx_buffer->tx_head.tx_rts.rts;
 
 		pBuf->wRTSTxRrvTime_aa = s_uGetRTSCTSRsvTime(pDevice, 2,
 				byPktType, cbFrameSize, wCurrentRate);
@@ -889,7 +889,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
         else {//RTS_needless, PCF mode
             //Fill RsvTime
-		struct vnt_rrv_time_cts *pBuf = &tx_buffer->tx_head.cts;
+		struct vnt_rrv_time_cts *pBuf = &tx_buffer->tx_head.tx_cts.cts;
 
 		pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
 			cbFrameSize, wCurrentRate, bNeedACK);
@@ -906,7 +906,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
     else if (byPktType == PK_TYPE_11A) {
 	if (need_rts) {
             //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.ab;
+		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
 
 		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 2,
 				byPktType, cbFrameSize, wCurrentRate);
@@ -917,7 +917,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
 	} else {
             //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.ab;
+		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
 
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11A,
 			cbFrameSize, wCurrentRate, bNeedACK);
@@ -926,7 +926,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
     else if (byPktType == PK_TYPE_11B) {
 	if (need_rts) {
             //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.ab;
+		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
 
 		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
@@ -938,7 +938,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
         else { //RTS_needless, non PCF mode
             //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.ab;
+		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
 
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 			cbFrameSize, wCurrentRate, bNeedACK);
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 78b7b74..bbda9a3 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -180,10 +180,29 @@ union vnt_tx_data_head {
 	struct vnt_cts_fb cts_g_fb;
 };
 
+struct vnt_tx_mic_hdr {
+	struct vnt_mic_hdr hdr;
+	union vnt_tx_data_head head;
+} __packed;
+
+union vnt_tx {
+	struct vnt_tx_mic_hdr mic;
+	union vnt_tx_data_head head;
+};
+
 union vnt_tx_head {
-	struct vnt_rrv_time_rts rts;
-	struct vnt_rrv_time_cts cts;
-	struct vnt_rrv_time_ab ab;
+	struct {
+		struct vnt_rrv_time_rts rts;
+		union vnt_tx tx;
+	} __packed tx_rts;
+	struct {
+		struct vnt_rrv_time_cts cts;
+		union vnt_tx tx;
+	} __packed tx_cts;
+	struct {
+		struct vnt_rrv_time_ab ab;
+		union vnt_tx tx;
+	} __packed tx_ab;
 };
 
 struct vnt_tx_fifo_head {
-- 
1.8.3.2

