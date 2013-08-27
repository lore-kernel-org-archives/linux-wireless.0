Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:34750 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3H0Ksm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 06:48:42 -0400
Received: by mail-bk0-f50.google.com with SMTP id mz11so1594258bkb.9
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 03:48:41 -0700 (PDT)
Message-ID: <1377600514.3320.61.camel@canaries32-MCP7A> (sfid-20130827_124845_469356_51066486)
Subject: [PATCH 2/5] staging: vt6656: s_vFillCTSHead join structures of
 vnt_cts* to union vnt_tx_data_head
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 11:48:34 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only one of vnt_rts*/vnt_cts* structures are accessed at any one time.

structures vnt_cts and vnt_cts_fb are members of union vnt_tx_data_head.

Create pointer union head and point structures to the correct member.

Point the union to pvCTS.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 10 +++++-----From 3deb77d380b80ff3cf719efc96f33ca27c8ad29c Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Sun, 25 Aug 2013 10:08:13 +0100
Subject: [PATCH 04/13] staging: vt6656: s_vFillCTSHead add union
 vnt_tx_data_head

 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 98224bc..fd3c598 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -760,15 +760,15 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 	u8 byPktType, void *pvCTS, u32 cbFrameLength, int bNeedAck,
 	u16 wCurrentRate, u8 byFBOption)
 {
+	union vnt_tx_data_head *head = pvCTS;
 	u32 uCTSFrameLen = 14;
 
-    if (pvCTS == NULL) {
-        return;
-    }
+	if (!head)
+		return;
 
 	if (byFBOption != AUTO_FB_NONE) {
 		/* Auto Fall back */
-		struct vnt_cts_fb *pBuf = (struct vnt_cts_fb *)pvCTS;
+		struct vnt_cts_fb *pBuf = &head->cts_g_fb;
 		/* Get SignalField,ServiceField,Length */
 		BBvCalculateParameter(pDevice, uCTSFrameLen,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
@@ -788,7 +788,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		pBuf->data.frame_control = TYPE_CTL_CTS;
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 	} else {
-		struct vnt_cts *pBuf = (struct vnt_cts *)pvCTS;
+		struct vnt_cts *pBuf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
 		BBvCalculateParameter(pDevice, uCTSFrameLen,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
-- 
1.8.1.2

