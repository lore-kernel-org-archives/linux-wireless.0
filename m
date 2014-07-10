Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61825 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaGJS4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:50 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so5078111wib.14
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:56:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/16] staging: vt6656: rxtx: move tx_context->fb_option into function structure.
Date: Thu, 10 Jul 2014 19:56:03 +0100
Message-Id: <1405018577-6832-2-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205653_073518_06DA3FD9)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace fb_option in function calls with tx_context->fb_option.

Namely functions s_vFillCTSHead and s_vFillRTSHead

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 998a62a..a556d81 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -545,7 +545,7 @@ static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 	switch (byPktType) {
 	case PK_TYPE_11GB:
 	case PK_TYPE_11GA:
-		if (byFBOption == AUTO_FB_NONE)
+		if (!tx_context->fb_option)
 			return vnt_rxtx_rts_g_head(tx_context, &head->rts_g,
 				byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
@@ -556,7 +556,7 @@ static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 				byFBOption);
 		break;
 	case PK_TYPE_11A:
-		if (byFBOption) {
+		if (tx_context->fb_option) {
 			return vnt_rxtx_rts_a_fb_head(tx_context,
 				&head->rts_a_fb, byPktType,
 				cbFrameLength, bNeedAck, wCurrentRate,
@@ -582,7 +582,7 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 	if (!head)
 		return 0;
 
-	if (byFBOption != AUTO_FB_NONE) {
+	if (tx_context->fb_option) {
 		/* Auto Fall back */
 		struct vnt_cts_fb *pBuf = &head->cts_g_fb;
 		/* Get SignalField,ServiceField,Length */
-- 
1.9.1

