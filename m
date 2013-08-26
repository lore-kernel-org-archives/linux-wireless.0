Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41551 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3HZKVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 06:21:18 -0400
Received: by mail-ea0-f174.google.com with SMTP id z15so1497223ead.5
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 03:21:17 -0700 (PDT)
Message-ID: <1377512471.3685.44.camel@canaries32-MCP7A> (sfid-20130826_122129_355823_A13B25EA)
Subject: [PATCH 6/6] staging: rxtx.c s_vFillRTSHead white space and
 formating clean up
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Aug 2013 11:21:11 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 0785431..e97bc40 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -725,37 +725,34 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	if (!head)
 		return;
 
-    // Note: So far RTSHead doesn't appear in ATIM & Beacom DMA, so we don't need to take them into account.
-    //       Otherwise, we need to modified codes for them.
-    if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-        if (byFBOption == AUTO_FB_NONE) {
-		vnt_rxtx_rts_g_head(pDevice, &head->rts_g,
+	/* Note: So far RTSHead doesn't appear in ATIM
+	*	& Beacom DMA, so we don't need to take them
+	*	into account.
+	*	Otherwise, we need to modified codes for them.
+	*/
+	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
+		if (byFBOption == AUTO_FB_NONE)
+			vnt_rxtx_rts_g_head(pDevice, &head->rts_g,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
-        }
-        else {
-		vnt_rxtx_rts_g_fb_head(pDevice, &head->rts_g_fb,
+		else
+			vnt_rxtx_rts_g_fb_head(pDevice, &head->rts_g_fb,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
-        } // if (byFBOption == AUTO_FB_NONE)
-    }
-    else if (byPktType == PK_TYPE_11A) {
-        if (byFBOption == AUTO_FB_NONE) {
-		vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
+	} else if (byPktType == PK_TYPE_11A) {
+		if (byFBOption == AUTO_FB_NONE)
+			vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
-        }
-        else {
-		vnt_rxtx_rts_a_fb_head(pDevice, &head->rts_a_fb,
+		else
+			vnt_rxtx_rts_a_fb_head(pDevice, &head->rts_a_fb,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
-        }
-    }
-    else if (byPktType == PK_TYPE_11B) {
-	vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
+	} else if (byPktType == PK_TYPE_11B) {
+		vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
 			psEthHeader, byPktType, cbFrameLength,
 			bNeedAck, wCurrentRate, byFBOption);
-    }
+	}
 }
 
 static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
-- 
1.8.1.2

