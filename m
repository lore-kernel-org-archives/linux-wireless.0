Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53353 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaGJS44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:56 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so5563wgh.15
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:56:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/16] staging: vt6656: s_vGenerateTxParameter rxtx.c s_vGenerateTxParameter pBuf->rrv_time always the calling pkt_type
Date: Thu, 10 Jul 2014 19:56:08 +0100
Message-Id: <1405018577-6832-7-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205708_796580_9617234F)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use byPktType instead of macro.

The pkt_type has already been filtered in this function so its always set
to the correct one.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 49bda3c..bad2fe4 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -760,7 +760,7 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 							tx_head.tx_ab.ab;
 
 			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
-				PK_TYPE_11A, cbFrameSize,
+				byPktType, cbFrameSize,
 					wCurrentRate, bNeedACK);
 
 			return vnt_rxtx_datahead_a_fb(tx_context, byPktType,
@@ -783,7 +783,7 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 				byPktType, cbFrameSize, wCurrentRate);
 
 			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
-				PK_TYPE_11B, cbFrameSize, wCurrentRate,
+				byPktType, cbFrameSize, wCurrentRate,
 								bNeedACK);
 
 			/* Fill RTS */
@@ -795,7 +795,7 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 							tx_head.tx_ab.ab;
 
 			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
-				PK_TYPE_11B, cbFrameSize,
+				byPktType, cbFrameSize,
 					wCurrentRate, bNeedACK);
 
 			return vnt_rxtx_datahead_ab(tx_context, byPktType,
-- 
1.9.1

