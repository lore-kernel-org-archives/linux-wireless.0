Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:59864 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3H0I5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:57:00 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so1559862bkb.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 01:56:59 -0700 (PDT)
Message-ID: <1377593810.3320.11.camel@canaries32-MCP7A> (sfid-20130827_105704_820734_091F6881)
Subject: [PATCH 1/2] staging: vt6656: rxtx.c: s_vFillRTSHead change if/else
 to switch on byPktype
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 09:56:50 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allowing fall through where necessary.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index e97bc40..e049a34 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -730,7 +730,9 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	*	into account.
 	*	Otherwise, we need to modified codes for them.
 	*/
-	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
+	switch (byPktType) {
+	case PK_TYPE_11GB:
+	case PK_TYPE_11GA:
 		if (byFBOption == AUTO_FB_NONE)
 			vnt_rxtx_rts_g_head(pDevice, &head->rts_g,
 				psEthHeader, byPktType, cbFrameLength,
@@ -739,7 +741,8 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 			vnt_rxtx_rts_g_fb_head(pDevice, &head->rts_g_fb,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
-	} else if (byPktType == PK_TYPE_11A) {
+		break;
+	case PK_TYPE_11A:
 		if (byFBOption == AUTO_FB_NONE)
 			vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
 				psEthHeader, byPktType, cbFrameLength,
@@ -748,7 +751,8 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 			vnt_rxtx_rts_a_fb_head(pDevice, &head->rts_a_fb,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
-	} else if (byPktType == PK_TYPE_11B) {
+		break;
+	case PK_TYPE_11B:
 		vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
 			psEthHeader, byPktType, cbFrameLength,
 			bNeedAck, wCurrentRate, byFBOption);
-- 
1.8.1.2

