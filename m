Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34925 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3HZKSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 06:18:00 -0400
Received: by mail-ea0-f176.google.com with SMTP id q16so1497816ead.21
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 03:17:59 -0700 (PDT)
Message-ID: <1377512272.3685.42.camel@canaries32-MCP7A> (sfid-20130826_121805_323921_D7F6CE9D)
Subject: [PATCH 5/6] staging: vt6656: rxtx s_vFillRTSHead create union of
 vnt_rts*/vnt_cts* structures.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Aug 2013 11:17:52 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only one of vnt_rts*/vnt_cts* structures are accessed at any one time.

Join these structures in to a single union.

These will eventually form the tail structure of vnt_tx_buffer and
include structures vnt_tx_datahead*

Structures in s_vFillCTSHead will join in next patch series.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 25 ++++++++-----------------
 drivers/staging/vt6656/rxtx.h | 12 ++++++++++++
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a45cc9f..0785431 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -720,48 +720,39 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	void *pvRTS, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
 {
+	union vnt_tx_data_head *head = pvRTS;
 
-    if (pvRTS == NULL)
-    	return;
+	if (!head)
+		return;
 
     // Note: So far RTSHead doesn't appear in ATIM & Beacom DMA, so we don't need to take them into account.
     //       Otherwise, we need to modified codes for them.
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
         if (byFBOption == AUTO_FB_NONE) {
-		struct vnt_rts_g *pBuf = (struct vnt_rts_g *)pvRTS;
-
-		vnt_rxtx_rts_g_head(pDevice, pBuf,
+		vnt_rxtx_rts_g_head(pDevice, &head->rts_g,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
         }
         else {
-		struct vnt_rts_g_fb *pBuf = (struct vnt_rts_g_fb *)pvRTS;
-
-		vnt_rxtx_rts_g_fb_head(pDevice, pBuf,
+		vnt_rxtx_rts_g_fb_head(pDevice, &head->rts_g_fb,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
         } // if (byFBOption == AUTO_FB_NONE)
     }
     else if (byPktType == PK_TYPE_11A) {
         if (byFBOption == AUTO_FB_NONE) {
-		struct vnt_rts_ab *pBuf = (struct vnt_rts_ab *)pvRTS;
-
-		vnt_rxtx_rts_ab_head(pDevice, pBuf,
+		vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
         }
         else {
-		struct vnt_rts_a_fb *pBuf = (struct vnt_rts_a_fb *)pvRTS;
-
-		vnt_rxtx_rts_a_fb_head(pDevice, pBuf,
+		vnt_rxtx_rts_a_fb_head(pDevice, &head->rts_a_fb,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
         }
     }
     else if (byPktType == PK_TYPE_11B) {
-	struct vnt_rts_ab *pBuf = (struct vnt_rts_ab *)pvRTS;
-
-	vnt_rxtx_rts_ab_head(pDevice, pBuf,
+	vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
 			psEthHeader, byPktType, cbFrameLength,
 			bNeedAck, wCurrentRate, byFBOption);
     }
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index ad62052..4bbee1c 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -168,6 +168,18 @@ struct vnt_cts_fb {
 	u16 reserved2;
 } __packed;
 
+union vnt_tx_data_head {
+	/* rts g */
+	struct vnt_rts_g rts_g;
+	struct vnt_rts_g_fb rts_g_fb;
+	/* rts a/b */
+	struct vnt_rts_ab rts_ab;
+	struct vnt_rts_a_fb rts_a_fb;
+	/* cts g */
+	struct vnt_cts cts_g;
+	struct vnt_cts_fb cts_g_fb;
+};
+
 struct vnt_tx_buffer {
 	u8 byType;
 	u8 byPKTNO;
-- 
1.8.1.2

