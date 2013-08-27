Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:48784 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3H0Kq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 06:46:26 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so1524221bkb.41
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 03:46:25 -0700 (PDT)
Message-ID: <1377600377.3320.59.camel@canaries32-MCP7A> (sfid-20130827_124629_766310_3ED906AB)
Subject: [PATCH 1/5] staging: vt6656: rxtx.c s_vFillCTSHead Remove byPktType
 if
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 11:46:17 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s_vFillCTSHead is only called when byPktType == PK_TYPE_11GB ||
byPktType == PK_TYPE_11GA so remove unnecessary if on byPktType.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 463a8d5..98224bc 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -766,7 +766,6 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
         return;
     }
 
-    if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 	if (byFBOption != AUTO_FB_NONE) {
 		/* Auto Fall back */
 		struct vnt_cts_fb *pBuf = (struct vnt_cts_fb *)pvCTS;
@@ -802,7 +801,6 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		pBuf->data.frame_control = TYPE_CTL_CTS;
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
         }
-    }
 }
 
 /*+
-- 
1.8.1.2

