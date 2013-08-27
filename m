Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:36363 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab3H0I6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:58:33 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so1461025bkh.40
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 01:58:32 -0700 (PDT)
Message-ID: <1377593901.3320.12.camel@canaries32-MCP7A> (sfid-20130827_105837_536305_7C84CD12)
Subject: [PATCH 2/2] staging: vt6656: rxtx.c s_vFillRTSHead PK_TYPE_11A
 allow fall through AUTO_FB_NONE
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 09:58:21 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

byFBOption == AUTO_FB_NONE (0) is the same as PK_TYPE_11B

Reverse if condition to break and allow fall through.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index e049a34..463a8d5 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -743,15 +743,12 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 				bNeedAck, wCurrentRate, byFBOption);
 		break;
 	case PK_TYPE_11A:
-		if (byFBOption == AUTO_FB_NONE)
-			vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
-				psEthHeader, byPktType, cbFrameLength,
-				bNeedAck, wCurrentRate, byFBOption);
-		else
+		if (byFBOption) {
 			vnt_rxtx_rts_a_fb_head(pDevice, &head->rts_a_fb,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
-		break;
+			break;
+		}
 	case PK_TYPE_11B:
 		vnt_rxtx_rts_ab_head(pDevice, &head->rts_ab,
 			psEthHeader, byPktType, cbFrameLength,
-- 
1.8.1.2

