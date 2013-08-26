Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48502 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3HZK22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 06:28:28 -0400
Received: by mail-ee0-f50.google.com with SMTP id d51so1507973eek.37
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 03:28:26 -0700 (PDT)
Message-ID: <1377512899.4452.0.camel@canaries32-MCP7A> (sfid-20130826_122830_290334_BAD75E4B)
Subject: [PATCH 6/6 resend] staging: vt6656: rxtx.c s_vFillRTSHead white
 space and formating clean up
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Aug 2013 11:28:19 +0100
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

